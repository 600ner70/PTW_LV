
  CREATE OR REPLACE EDITIONABLE PACKAGE "PTW_PRO"."PTW_DRA_PKG" AS

    PROCEDURE save_dra_header(
        p_dra_id              IN OUT ptw_pro.ptw_lv_dra_assessments.dra_id%TYPE,
        p_dra_type            IN     ptw_pro.ptw_lv_dra_assessments.dra_type%TYPE,
        p_workflow_status     IN     ptw_pro.ptw_lv_dra_assessments.workflow_status%TYPE, -- ignored, kept for compatibility
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
    );

    FUNCTION get_dra_json(p_dra_id IN ptw_pro.ptw_lv_dra_assessments.dra_id%TYPE)
        RETURN CLOB;

    PROCEDURE save_dra_responses(
        p_dra_id    IN ptw_pro.ptw_lv_dra_assessments.dra_id%TYPE,
        p_json      IN CLOB
    );

    PROCEDURE save_dra_details(
        p_dra_id          IN ptw_pro.ptw_lv_dra_assessments.dra_id%TYPE,
        p_hazard_details  IN ptw_pro.ptw_lv_dra_assessments.hazard_details%TYPE,
        p_control_details IN ptw_pro.ptw_lv_dra_assessments.control_details%TYPE
    );

    PROCEDURE complete_dra(
        p_dra_id            IN ptw_pro.ptw_lv_dra_assessments.dra_id%TYPE,
        p_can_proceed       IN ptw_pro.ptw_lv_dra_assessments.stage3_can_proceed%TYPE,
        p_no_reason         IN ptw_pro.ptw_lv_dra_assessments.stage3_no_reason%TYPE DEFAULT NULL,
        p_signature_name    IN ptw_pro.ptw_lv_dra_assessments.signature_person_name%TYPE,
        p_signature_b64     IN CLOB,
        p_latitude          IN NUMBER DEFAULT NULL,
        p_longitude         IN NUMBER DEFAULT NULL
    );

    PROCEDURE cancel_dra(
        p_dra_id    IN ptw_pro.ptw_lv_dra_assessments.dra_id%TYPE,
        p_reason    IN ptw_pro.ptw_lv_dra_assessments.cancel_reason%TYPE
    );

    -- 'Y' if the DRA is COMPLETED, said work CAN proceed, and is either
    -- unlinked or already linked to p_permit_id.
    FUNCTION can_use_for_permit(
        p_dra_id    IN ptw_pro.ptw_lv_dra_assessments.dra_id%TYPE,
        p_permit_id IN ptw_pro.ptw_lv_permits.permit_id%TYPE
    ) RETURN VARCHAR2;

    PROCEDURE link_to_permit(
        p_dra_id    IN ptw_pro.ptw_lv_dra_assessments.dra_id%TYPE,
        p_permit_id IN ptw_pro.ptw_lv_permits.permit_id%TYPE
    );

END ptw_dra_pkg;
/
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "PTW_PRO"."PTW_DRA_PKG" AS

    ---------------------------------------------------------------------------
    -- Private helpers
    ---------------------------------------------------------------------------
    FUNCTION app_user RETURN VARCHAR2 IS
    BEGIN
        RETURN UPPER(NVL(V('APP_USER'), USER));
    END app_user;

    -- Same roles as the APP_IS_ADMIN application computation.
    FUNCTION is_admin RETURN BOOLEAN IS
        l_count NUMBER;
        l_user  VARCHAR2(255) := app_user;   -- private functions can't be used inside SQL
    BEGIN
        SELECT COUNT(*)
        INTO   l_count
        FROM   ptw_pro.ptw_lv_user_roles_v
        WHERE  UPPER(username) = l_user
        AND    role_name IN ('ADMIN', 'ADMIN_CONTRACT_SUPPORT')
        AND    is_active = 'Y';
        RETURN l_count > 0;
    END is_admin;

    -- Locks the row and returns status + creator. Raises if not found
    -- (VPD hides other companies' rows, so "not found" covers both).
    PROCEDURE get_dra_for_update(
        p_dra_id     IN  ptw_pro.ptw_lv_dra_assessments.dra_id%TYPE,
        p_status     OUT ptw_pro.ptw_lv_dra_assessments.workflow_status%TYPE,
        p_created_by OUT ptw_pro.ptw_lv_dra_assessments.created_by%TYPE
    ) IS
    BEGIN
        SELECT workflow_status, created_by
        INTO   p_status, p_created_by
        FROM   ptw_pro.ptw_lv_dra_assessments
        WHERE  dra_id = p_dra_id
        FOR UPDATE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20070, 'DRA ' || p_dra_id || ' not found or not accessible.');
    END get_dra_for_update;

    PROCEDURE assert_can_edit(
        p_dra_id IN ptw_pro.ptw_lv_dra_assessments.dra_id%TYPE
    ) IS
        l_status     ptw_pro.ptw_lv_dra_assessments.workflow_status%TYPE;
        l_created_by ptw_pro.ptw_lv_dra_assessments.created_by%TYPE;
    BEGIN
        get_dra_for_update(p_dra_id, l_status, l_created_by);
        IF l_status <> 'DRAFT' THEN
            RAISE_APPLICATION_ERROR(-20069, 'This DRA is ' || l_status || ' and can no longer be edited.');
        END IF;
        IF UPPER(l_created_by) <> app_user AND NOT is_admin THEN
            RAISE_APPLICATION_ERROR(-20084, 'Only the person who started this DRA can change it.');
        END IF;
    END assert_can_edit;

    ---------------------------------------------------------------------------
    -- save_dra_header
    ---------------------------------------------------------------------------
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
        l_supervising ptw_pro.ptw_lv_dra_assessments.supervising_company%TYPE;
    BEGIN
        p_saved := FALSE;

        IF NVL(p_dra_type, 'x') NOT IN ('ENGINEER', 'SUBCONTRACTOR') THEN
            p_message := 'Choose the type of DRA.';
            RETURN;
        END IF;
        IF TRIM(p_site_details) IS NULL THEN
            p_message := 'Task and Work Location Details is required.';
            RETURN;
        END IF;
        IF TRIM(p_engineer_name) IS NULL THEN
            p_message := 'Engineer name is required.';
            RETURN;
        END IF;

        -- Subcontractor company only applies to a Subcontractor DRA.
        l_supervising := CASE WHEN p_dra_type = 'SUBCONTRACTOR' THEN p_supervising_company END;

        IF p_dra_id IS NULL THEN
            INSERT INTO ptw_pro.ptw_lv_dra_assessments (
                dra_type, site_id, site_details, job_number, engineer_name,
                supervising_company, permit_id, started_latitude, started_longitude
            ) VALUES (
                p_dra_type, p_site_id, p_site_details, p_job_number, p_engineer_name,
                l_supervising, p_permit_id, p_latitude, p_longitude
            ) RETURNING dra_id, dra_number
              INTO p_dra_id, p_dra_number;

            p_saved   := TRUE;
            p_message := 'DRA ' || p_dra_number || ' created.';
        ELSE
            assert_can_edit(p_dra_id);   -- status from the table, not the page

            UPDATE ptw_pro.ptw_lv_dra_assessments
            SET    site_id             = p_site_id,     -- dra_type is fixed after creation
                   site_details        = p_site_details,
                   job_number          = p_job_number,
                   engineer_name       = p_engineer_name,
                   supervising_company = CASE WHEN dra_type = 'SUBCONTRACTOR'
                                              THEN p_supervising_company END,
                   permit_id           = p_permit_id
            WHERE  dra_id = p_dra_id
            RETURNING dra_number INTO p_dra_number;

            p_saved   := TRUE;
            p_message := 'DRA ' || p_dra_number || ' saved.';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            p_saved   := FALSE;
            p_message := REGEXP_REPLACE(SQLERRM, '^ORA-\d+: ');
    END save_dra_header;

    ---------------------------------------------------------------------------
    -- get_dra_json (unchanged)
    ---------------------------------------------------------------------------
    FUNCTION get_dra_json(p_dra_id IN ptw_pro.ptw_lv_dra_assessments.dra_id%TYPE)
        RETURN CLOB
    IS
        l_exists PLS_INTEGER;
        l_clob   CLOB;
    BEGIN
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

    ---------------------------------------------------------------------------
    -- save_dra_responses
    ---------------------------------------------------------------------------
    PROCEDURE save_dra_responses(
        p_dra_id    IN ptw_pro.ptw_lv_dra_assessments.dra_id%TYPE,
        p_json      IN CLOB
    )
    IS
        l_company_id ptw_pro.ptw_lv_dra_assessments.company_id%TYPE;
        l_user       VARCHAR2(255) := app_user;   -- private functions can't be used inside SQL
    BEGIN
        assert_can_edit(p_dra_id);

        SELECT company_id INTO l_company_id
        FROM   ptw_pro.ptw_lv_dra_assessments
        WHERE  dra_id = p_dra_id;

        IF p_json IS NULL THEN
            RETURN;   -- nothing posted (e.g. page loaded read-only)
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
                       dr.modified_by   = l_user
        WHEN NOT MATCHED THEN
            INSERT (dra_id, dra_item_id, response, company_id, created_by)
            VALUES (p_dra_id, src.dra_item_id, src.response, l_company_id, l_user);

        -- A TICK item left out of the payload was unticked - remove it.
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
                   WHERE  jt.dra_item_id IS NOT NULL
               );

    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE BETWEEN -20099 AND -20060 THEN
                RAISE;
            END IF;
            RAISE_APPLICATION_ERROR(-20071, 'Error saving DRA responses: ' || SQLERRM);
    END save_dra_responses;

    ---------------------------------------------------------------------------
    -- save_dra_details (NEW)
    ---------------------------------------------------------------------------
    PROCEDURE save_dra_details(
        p_dra_id          IN ptw_pro.ptw_lv_dra_assessments.dra_id%TYPE,
        p_hazard_details  IN ptw_pro.ptw_lv_dra_assessments.hazard_details%TYPE,
        p_control_details IN ptw_pro.ptw_lv_dra_assessments.control_details%TYPE
    ) IS
    BEGIN
        assert_can_edit(p_dra_id);

        UPDATE ptw_pro.ptw_lv_dra_assessments
        SET    hazard_details  = TRIM(p_hazard_details),
               control_details = TRIM(p_control_details)
        WHERE  dra_id = p_dra_id;
    END save_dra_details;

    ---------------------------------------------------------------------------
    -- complete_dra
    ---------------------------------------------------------------------------
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
        l_status         ptw_pro.ptw_lv_dra_assessments.workflow_status%TYPE;
        l_created_by     ptw_pro.ptw_lv_dra_assessments.created_by%TYPE;
        l_unanswered     PLS_INTEGER;
        l_hazards        PLS_INTEGER;
        l_controls       PLS_INTEGER;
        l_hazard_txt     ptw_pro.ptw_lv_dra_assessments.hazard_details%TYPE;
        l_control_txt    ptw_pro.ptw_lv_dra_assessments.control_details%TYPE;
    BEGIN
        get_dra_for_update(p_dra_id, l_status, l_created_by);

        IF l_status <> 'DRAFT' THEN
            RAISE_APPLICATION_ERROR(-20072, 'This DRA is ' || l_status || ' and cannot be completed again.');
        END IF;
        IF UPPER(l_created_by) <> app_user THEN
            RAISE_APPLICATION_ERROR(-20085,
                'Only the person who carried out this DRA can sign it off.');
        END IF;
        IF NVL(p_can_proceed, 'x') NOT IN ('YES','NO') THEN
            RAISE_APPLICATION_ERROR(-20073, 'Please answer the Stage 3 question.');
        END IF;
        IF p_can_proceed = 'NO' AND TRIM(p_no_reason) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20074, 'Please record your reasons - work must not proceed.');
        END IF;
        IF TRIM(p_signature_name) IS NULL OR p_signature_b64 IS NULL THEN
            RAISE_APPLICATION_ERROR(-20075, 'A signature is required to complete this DRA.');
        END IF;

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

        SELECT COUNT(CASE WHEN di.section_code = 'HAZARDS'  THEN 1 END),
               COUNT(CASE WHEN di.section_code = 'CONTROLS' THEN 1 END)
        INTO   l_hazards, l_controls
        FROM   ptw_pro.ptw_dra_responses dr
        JOIN   ptw_pro.ptw_dra_items di ON di.dra_item_id = dr.dra_item_id
        WHERE  dr.dra_id = p_dra_id
        AND    dr.response = 'Y';

        SELECT hazard_details, control_details
        INTO   l_hazard_txt, l_control_txt
        FROM   ptw_pro.ptw_lv_dra_assessments
        WHERE  dra_id = p_dra_id;

        IF l_hazards = 0 AND TRIM(l_hazard_txt) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20086, 'Identify at least one hazard (Stage 2A).');
        END IF;
        IF l_controls = 0 AND TRIM(l_control_txt) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20087, 'Identify at least one control measure (Stage 2B).');
        END IF;

        UPDATE ptw_pro.ptw_lv_dra_assessments
        SET    stage3_can_proceed    = p_can_proceed,
               stage3_no_reason      = CASE WHEN p_can_proceed = 'NO' THEN TRIM(p_no_reason) END,
               signature_person_name = TRIM(p_signature_name),
               signature             = apex_web_service.clobbase642blob(
                                           REGEXP_REPLACE(p_signature_b64, '^data:image/[^;]+;base64,', '')),
               signed_datetime       = SYSDATE,
               signature_latitude    = p_latitude,
               signature_longitude   = p_longitude,
               workflow_status       = 'COMPLETED'
        WHERE  dra_id = p_dra_id;

    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE BETWEEN -20099 AND -20060 THEN
                RAISE;
            END IF;
            RAISE_APPLICATION_ERROR(-20078, 'Error completing DRA: ' || SQLERRM);
    END complete_dra;

    ---------------------------------------------------------------------------
    -- cancel_dra
    ---------------------------------------------------------------------------
    PROCEDURE cancel_dra(
        p_dra_id    IN ptw_pro.ptw_lv_dra_assessments.dra_id%TYPE,
        p_reason    IN ptw_pro.ptw_lv_dra_assessments.cancel_reason%TYPE
    )
    IS
        l_status     ptw_pro.ptw_lv_dra_assessments.workflow_status%TYPE;
        l_created_by ptw_pro.ptw_lv_dra_assessments.created_by%TYPE;
    BEGIN
        get_dra_for_update(p_dra_id, l_status, l_created_by);

        IF l_status <> 'DRAFT' THEN
            RAISE_APPLICATION_ERROR(-20079, 'Only a Draft DRA can be cancelled.');
        END IF;
        IF UPPER(l_created_by) <> app_user AND NOT is_admin THEN
            RAISE_APPLICATION_ERROR(-20088, 'Only the person who started this DRA, or an admin, can cancel it.');
        END IF;
        IF TRIM(p_reason) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20080, 'Please give a reason for cancelling this DRA.');
        END IF;

        UPDATE ptw_pro.ptw_lv_dra_assessments
        SET    workflow_status = 'CANCELLED',
               cancel_reason   = TRIM(p_reason),
               cancel_datetime = SYSDATE
        WHERE  dra_id = p_dra_id;

    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE BETWEEN -20099 AND -20060 THEN
                RAISE;
            END IF;
            RAISE_APPLICATION_ERROR(-20082, 'Error cancelling DRA: ' || SQLERRM);
    END cancel_dra;

    ---------------------------------------------------------------------------
    -- Permit link (Page 9 gate)
    ---------------------------------------------------------------------------
    FUNCTION can_use_for_permit(
        p_dra_id    IN ptw_pro.ptw_lv_dra_assessments.dra_id%TYPE,
        p_permit_id IN ptw_pro.ptw_lv_permits.permit_id%TYPE
    ) RETURN VARCHAR2 IS
        l_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO   l_count
        FROM   ptw_pro.ptw_lv_dra_assessments
        WHERE  dra_id             = p_dra_id
        AND    workflow_status    = 'COMPLETED'
        AND    stage3_can_proceed = 'YES'
        AND    (permit_id IS NULL OR permit_id = p_permit_id);
        RETURN CASE WHEN l_count > 0 THEN 'Y' ELSE 'N' END;
    END can_use_for_permit;

    PROCEDURE link_to_permit(
        p_dra_id    IN ptw_pro.ptw_lv_dra_assessments.dra_id%TYPE,
        p_permit_id IN ptw_pro.ptw_lv_permits.permit_id%TYPE
    ) IS
    BEGIN
        IF can_use_for_permit(p_dra_id, p_permit_id) = 'N' THEN
            RAISE_APPLICATION_ERROR(-20089,
                'That DRA cannot be used: it must be completed, say work can proceed, '
                || 'and not already belong to another permit.');
        END IF;

        -- Bypasses the DRAFT-only edit rule deliberately: linking a
        -- completed DRA to the permit it was done for is not an edit
        -- of the assessment itself.
        UPDATE ptw_pro.ptw_lv_dra_assessments
        SET    permit_id = p_permit_id
        WHERE  dra_id    = p_dra_id;
    END link_to_permit;

END ptw_dra_pkg;
/
