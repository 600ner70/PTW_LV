
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "PTW_PRO"."PTW_DRA_PKG" AS

    FUNCTION create_dra(
        p_dra_type          IN ptw_pro.ptw_lv_dra_assessments.dra_type%TYPE,
        p_site_details      IN ptw_pro.ptw_lv_dra_assessments.site_details%TYPE,
        p_engineer_name     IN ptw_pro.ptw_lv_dra_assessments.engineer_name%TYPE,
        p_job_number        IN ptw_pro.ptw_lv_dra_assessments.job_number%TYPE DEFAULT NULL,
        p_supervising_company IN ptw_pro.ptw_lv_dra_assessments.supervising_company%TYPE DEFAULT NULL,
        p_site_id           IN ptw_pro.ptw_lv_dra_assessments.site_id%TYPE DEFAULT NULL,
        p_permit_id         IN ptw_pro.ptw_lv_dra_assessments.permit_id%TYPE DEFAULT NULL,
        p_latitude          IN NUMBER DEFAULT NULL,
        p_longitude         IN NUMBER DEFAULT NULL
    ) RETURN ptw_pro.ptw_lv_dra_assessments.dra_id%TYPE
    IS
        l_dra_id ptw_pro.ptw_lv_dra_assessments.dra_id%TYPE;
    BEGIN
        IF p_dra_type NOT IN ('ENGINEER','SUBCONTRACTOR') THEN
            RAISE_APPLICATION_ERROR(-20064, 'Invalid DRA type: ' || p_dra_type);
        END IF;

        IF p_site_details IS NULL OR TRIM(p_site_details) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20065, 'Task and Work Location Details is required.');
        END IF;

        IF p_engineer_name IS NULL OR TRIM(p_engineer_name) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20066, 'Engineer name is required.');
        END IF;

        INSERT INTO ptw_pro.ptw_lv_dra_assessments (
            dra_type, site_details, engineer_name, job_number,
            supervising_company, site_id, permit_id,
            started_latitude, started_longitude
        ) VALUES (
            p_dra_type, p_site_details, p_engineer_name, p_job_number,
            p_supervising_company, p_site_id, p_permit_id,
            p_latitude, p_longitude
        )
        RETURNING dra_id INTO l_dra_id;

        RETURN l_dra_id;
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE BETWEEN -20099 AND -20060 THEN
                RAISE;
            END IF;
            RAISE_APPLICATION_ERROR(-20067, 'Error creating DRA: ' || SQLERRM);
    END create_dra;


    FUNCTION get_dra_json(p_dra_id IN ptw_pro.ptw_lv_dra_assessments.dra_id%TYPE)
        RETURN CLOB
    IS
        l_exists PLS_INTEGER;
        l_clob   CLOB;
    BEGIN
        -- Subject to VPD on PTW_LV_DRA_ASSESSMENTS: a DRA outside the
        -- caller's company simply won't be found here.
        SELECT 1 INTO l_exists
        FROM   ptw_pro.ptw_lv_dra_assessments
        WHERE  dra_id = p_dra_id;

        apex_json.initialize_clob_output;
        apex_json.open_array;

        FOR r IN (
            SELECT di.dra_item_id, di.item_code, di.section_code,
                   di.category_no, di.category_label, di.item_seq,
                   di.question_text, di.response_type, dr.response
            FROM   ptw_pro.ptw_dra_items di
            LEFT JOIN ptw_pro.ptw_dra_responses dr
                   ON dr.dra_item_id = di.dra_item_id
                  AND dr.dra_id = p_dra_id
            WHERE  di.is_active = 'Y'
            ORDER BY DECODE(di.section_code, 'STAGE1', 1, 'HAZARDS', 2, 'CONTROLS', 3),
                     di.item_seq
        ) LOOP
            apex_json.open_object;
            apex_json.write('dra_item_id', r.dra_item_id);
            apex_json.write('item_code', r.item_code);
            apex_json.write('section', r.section_code);
            apex_json.write('category_no', r.category_no);
            apex_json.write('category_label', r.category_label);
            apex_json.write('seq', r.item_seq);
            apex_json.write('question', r.question_text);
            apex_json.write('response_type', r.response_type);
            apex_json.write('response', r.response);
            apex_json.close_object;
        END LOOP;

        apex_json.close_array;
        l_clob := apex_json.get_clob_output;
        apex_json.free_output;
        RETURN l_clob;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            apex_json.free_output;
            RETURN '[]';
        WHEN OTHERS THEN
            apex_json.free_output;
            RAISE_APPLICATION_ERROR(-20068, 'Error loading DRA ' || p_dra_id || ': ' || SQLERRM);
    END get_dra_json;


    PROCEDURE save_dra_responses(
        p_dra_id    IN ptw_pro.ptw_lv_dra_assessments.dra_id%TYPE,
        p_json      IN CLOB
    )
    IS
        l_company_id ptw_pro.ptw_lv_dra_assessments.company_id%TYPE;
        l_status     ptw_pro.ptw_lv_dra_assessments.workflow_status%TYPE;
    BEGIN
        SELECT company_id, workflow_status
        INTO   l_company_id, l_status
        FROM   ptw_pro.ptw_lv_dra_assessments
        WHERE  dra_id = p_dra_id;

        IF l_status != 'DRAFT' THEN
            RAISE_APPLICATION_ERROR(-20069, 'This DRA is ' || l_status || ' and can no longer be edited.');
        END IF;

        MERGE INTO ptw_pro.ptw_dra_responses dr
        USING (
            SELECT jt.dra_item_id, jt.response
            FROM   JSON_TABLE(
                       p_json, '$[*]'
                       COLUMNS (
                           dra_item_id NUMBER      PATH '$.dra_item_id',
                           response    VARCHAR2(3) PATH '$.response'
                       )
                   ) jt
            WHERE  jt.response IS NOT NULL
        ) src
        ON (dr.dra_id = p_dra_id AND dr.dra_item_id = src.dra_item_id)
        WHEN MATCHED THEN
            UPDATE SET dr.response      = src.response,
                       dr.modified_date = CURRENT_TIMESTAMP,
                       dr.modified_by   = NVL(V('APP_USER'), USER)
        WHEN NOT MATCHED THEN
            INSERT (dra_id, dra_item_id, response, company_id, created_by)
            VALUES (p_dra_id, src.dra_item_id, src.response, l_company_id, NVL(V('APP_USER'), USER));

        -- A TICK item left out of this payload means it was unticked -
        -- remove any stale response row so it doesn't still show as selected.
        DELETE FROM ptw_pro.ptw_dra_responses dr
        WHERE  dr.dra_id = p_dra_id
        AND    dr.dra_item_id IN (
                   SELECT dra_item_id FROM ptw_pro.ptw_dra_items WHERE response_type = 'TICK'
               )
        AND    dr.dra_item_id NOT IN (
                   SELECT jt.dra_item_id
                   FROM   JSON_TABLE(
                              p_json, '$[*]'
                              COLUMNS (dra_item_id NUMBER PATH '$.dra_item_id')
                          ) jt
               );

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20070, 'DRA ' || p_dra_id || ' not found or not accessible.');
        WHEN OTHERS THEN
            IF SQLCODE BETWEEN -20099 AND -20060 THEN
                RAISE;
            END IF;
            RAISE_APPLICATION_ERROR(-20071, 'Error saving DRA responses: ' || SQLERRM);
    END save_dra_responses;


    PROCEDURE complete_dra(
        p_dra_id            IN ptw_pro.ptw_lv_dra_assessments.dra_id%TYPE,
        p_can_proceed       IN ptw_pro.ptw_lv_dra_assessments.stage3_can_proceed%TYPE,
        p_no_reason         IN ptw_pro.ptw_lv_dra_assessments.stage3_no_reason%TYPE DEFAULT NULL,
        p_signature_name    IN ptw_pro.ptw_lv_dra_assessments.signature_person_name%TYPE,
        p_signature_b64     IN CLOB,
        p_latitude          IN NUMBER DEFAULT NULL,
        p_longitude         IN NUMBER DEFAULT NULL
    )
    IS
        l_status        ptw_pro.ptw_lv_dra_assessments.workflow_status%TYPE;
        l_unanswered    PLS_INTEGER;
        l_signature_blob BLOB;
    BEGIN
        SELECT workflow_status INTO l_status
        FROM   ptw_pro.ptw_lv_dra_assessments
        WHERE  dra_id = p_dra_id;

        IF l_status != 'DRAFT' THEN
            RAISE_APPLICATION_ERROR(-20072, 'This DRA is ' || l_status || ' and cannot be completed again.');
        END IF;

        IF p_can_proceed NOT IN ('YES','NO') THEN
            RAISE_APPLICATION_ERROR(-20073, 'Please answer the Stage 3 question.');
        END IF;

        IF p_can_proceed = 'NO' AND (p_no_reason IS NULL OR TRIM(p_no_reason) IS NULL) THEN
            RAISE_APPLICATION_ERROR(-20074, 'Please record your reasons - work must not proceed.');
        END IF;

        IF p_signature_name IS NULL OR TRIM(p_signature_name) IS NULL OR p_signature_b64 IS NULL THEN
            RAISE_APPLICATION_ERROR(-20075, 'A signature is required to complete this DRA.');
        END IF;

        -- All 20 STAGE1 questions must be answered before completion.
        SELECT COUNT(*)
        INTO   l_unanswered
        FROM   ptw_pro.ptw_dra_items di
        LEFT JOIN ptw_pro.ptw_dra_responses dr
               ON dr.dra_item_id = di.dra_item_id AND dr.dra_id = p_dra_id
        WHERE  di.section_code = 'STAGE1'
        AND    di.is_active = 'Y'
        AND    dr.response IS NULL;

        IF l_unanswered > 0 THEN
            RAISE_APPLICATION_ERROR(-20076,
                l_unanswered || ' Stage 1 question(s) still need an answer.');
        END IF;

        -- Signature arrives as a base64 PNG data URL payload (matches the
        -- existing permit signature pattern - see DEVELOPER_NOTES.md
        -- section 8). Strip any "data:image/png;base64," prefix if present.
        l_signature_blob := apex_web_service.clobbase642blob(
            CASE
                WHEN INSTR(p_signature_b64, 'base64,') > 0
                THEN SUBSTR(p_signature_b64, INSTR(p_signature_b64, 'base64,') + 7)
                ELSE p_signature_b64
            END
        );

        UPDATE ptw_pro.ptw_lv_dra_assessments
        SET    stage3_can_proceed    = p_can_proceed,
               stage3_no_reason      = p_no_reason,
               signature_person_name = p_signature_name,
               signature             = l_signature_blob,
               signed_datetime       = SYSDATE,
               signature_latitude    = p_latitude,
               signature_longitude   = p_longitude,
               workflow_status       = 'COMPLETED'
        WHERE  dra_id = p_dra_id;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20077, 'DRA ' || p_dra_id || ' not found or not accessible.');
        WHEN OTHERS THEN
            IF SQLCODE BETWEEN -20099 AND -20060 THEN
                RAISE;
            END IF;
            RAISE_APPLICATION_ERROR(-20078, 'Error completing DRA: ' || SQLERRM);
    END complete_dra;


    PROCEDURE cancel_dra(
        p_dra_id    IN ptw_pro.ptw_lv_dra_assessments.dra_id%TYPE,
        p_reason    IN ptw_pro.ptw_lv_dra_assessments.cancel_reason%TYPE
    )
    IS
        l_status ptw_pro.ptw_lv_dra_assessments.workflow_status%TYPE;
    BEGIN
        SELECT workflow_status INTO l_status
        FROM   ptw_pro.ptw_lv_dra_assessments
        WHERE  dra_id = p_dra_id;

        IF l_status != 'DRAFT' THEN
            RAISE_APPLICATION_ERROR(-20079, 'Only a Draft DRA can be cancelled.');
        END IF;

        IF p_reason IS NULL OR TRIM(p_reason) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20080, 'Please give a reason for cancelling this DRA.');
        END IF;

        UPDATE ptw_pro.ptw_lv_dra_assessments
        SET    workflow_status = 'CANCELLED',
               cancel_reason   = p_reason,
               cancel_datetime = SYSDATE
        WHERE  dra_id = p_dra_id;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20081, 'DRA ' || p_dra_id || ' not found or not accessible.');
        WHEN OTHERS THEN
            IF SQLCODE BETWEEN -20099 AND -20060 THEN
                RAISE;
            END IF;
            RAISE_APPLICATION_ERROR(-20082, 'Error cancelling DRA: ' || SQLERRM);
    END cancel_dra;

    PROCEDURE save_dra_header(
        p_dra_id              IN OUT ptw_pro.ptw_lv_dra_assessments.dra_id%TYPE,
        p_dra_type            IN     ptw_pro.ptw_lv_dra_assessments.dra_type%TYPE,
        p_workflow_status     IN     ptw_pro.ptw_lv_dra_assessments.workflow_status%TYPE,
        p_site_id             IN     ptw_pro.ptw_lv_dra_assessments.site_id%TYPE,
        p_site_details        IN     ptw_pro.ptw_lv_dra_assessments.site_details%TYPE,
        p_job_number          IN     ptw_pro.ptw_lv_dra_assessments.job_number%TYPE,
        p_engineer_name       IN     ptw_pro.ptw_lv_dra_assessments.engineer_name%TYPE,
        p_supervising_company IN     ptw_pro.ptw_lv_dra_assessments.supervising_company%TYPE,
        p_permit_id           IN     ptw_pro.ptw_lv_dra_assessments.permit_id%TYPE,
        p_latitude            IN     NUMBER,
        p_longitude           IN     NUMBER,
        p_dra_number          OUT    ptw_pro.ptw_lv_dra_assessments.dra_number%TYPE,
        p_saved               OUT    BOOLEAN,
        p_message             OUT    VARCHAR2
    ) IS
    BEGIN
        p_saved := FALSE;

        IF p_dra_id IS NOT NULL AND p_workflow_status != 'DRAFT' THEN
            p_message := 'This DRA is ' || p_workflow_status || ' - no changes saved.';
            RETURN;
        END IF;

        IF p_dra_id IS NULL THEN
            -- INSERT NEW DRA
            INSERT INTO ptw_pro.ptw_lv_dra_assessments (
                dra_type, site_id, site_details, job_number, engineer_name,
                supervising_company, permit_id, started_latitude, started_longitude
            ) VALUES (
                p_dra_type, p_site_id, p_site_details, p_job_number, p_engineer_name,
                p_supervising_company, p_permit_id, p_latitude, p_longitude
            ) RETURNING dra_id, dra_number
              INTO p_dra_id, p_dra_number;

            p_saved   := TRUE;
            p_message := 'DRA ' || p_dra_number || ' created successfully.';

        ELSE
            -- UPDATE EXISTING DRA (only if something has changed)
            UPDATE ptw_pro.ptw_lv_dra_assessments
            SET    dra_type             = NVL(p_dra_type, dra_type),
                   site_id              = p_site_id,
                   site_details         = p_site_details,
                   job_number           = p_job_number,
                   engineer_name        = p_engineer_name,
                   supervising_company  = p_supervising_company,
                   permit_id            = p_permit_id,
                   modified_by          = NVL(V('APP_USER'), USER),
                   modified_date        = CURRENT_TIMESTAMP
            WHERE  dra_id = p_dra_id
            AND (
                NVL(dra_type,            'x') != NVL(p_dra_type,            dra_type) OR
                NVL(site_id,              -1) != NVL(p_site_id,              -1)      OR
                NVL(site_details,        'x') != NVL(p_site_details,        'x')      OR
                NVL(job_number,          'x') != NVL(p_job_number,          'x')      OR
                NVL(engineer_name,       'x') != NVL(p_engineer_name,       'x')      OR
                NVL(supervising_company, 'x') != NVL(p_supervising_company, 'x')      OR
                NVL(permit_id,            -1) != NVL(p_permit_id,            -1)
            )
            RETURNING dra_number INTO p_dra_number;

            IF SQL%ROWCOUNT > 0 THEN
                p_saved   := TRUE;
                p_message := 'DRA ' || p_dra_number || ' updated successfully.';
            ELSE
                SELECT dra_number INTO p_dra_number
                FROM   ptw_pro.ptw_lv_dra_assessments WHERE dra_id = p_dra_id;
                p_saved   := TRUE;
                p_message := 'No changes to save.';
            END IF;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            p_saved   := FALSE;
            p_message := 'Error saving DRA: ' || SQLERRM;
    END save_dra_header;

END ptw_dra_pkg;
/
