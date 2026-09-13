
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "PTW_PRO"."PTW_CHECKLIST_PKG" AS

    FUNCTION get_checklist_json(p_permit_id IN ptw_pro.ptw_lv_permits.permit_id%TYPE)
        RETURN CLOB
    IS
        l_type_id ptw_pro.ptw_types.type_id%TYPE;
        l_clob    CLOB;
    BEGIN
        -- Subject to VPD on PTW_LV_PERMITS: a permit outside the caller's
        -- company simply won't be found here.
        SELECT t.type_id
        INTO   l_type_id
        FROM   ptw_pro.ptw_lv_permits p
        JOIN   ptw_pro.ptw_types t ON t.ptw_type = p.ptw_type
        WHERE  p.permit_id = p_permit_id;

        apex_json.initialize_clob_output;
        apex_json.open_array;

        FOR r IN (
            SELECT ci.checklist_item_id, ci.item_code, ci.section_code,
                   ci.item_seq, ci.question_text, ci.help_text,
                   ci.response_type, cr.response
            FROM   ptw_pro.ptw_checklist_items ci
            LEFT JOIN ptw_pro.ptw_checklist_responses cr
                   ON cr.checklist_item_id = ci.checklist_item_id
                  AND cr.permit_id = p_permit_id
            WHERE  ci.type_id = l_type_id
            AND    ci.is_active = 'Y'
            ORDER BY ci.section_code, ci.item_seq
        ) LOOP
            apex_json.open_object;
            apex_json.write('checklist_item_id', r.checklist_item_id);
            apex_json.write('item_code', r.item_code);
            apex_json.write('section', r.section_code);
            apex_json.write('seq', r.item_seq);
            apex_json.write('question', r.question_text);
            apex_json.write('help', r.help_text);
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
            RAISE_APPLICATION_ERROR(-20051, 'Error loading checklist for permit '
                || p_permit_id || ': ' || SQLERRM);
    END get_checklist_json;


    PROCEDURE save_checklist_responses(
        p_permit_id IN ptw_pro.ptw_lv_permits.permit_id%TYPE,
        p_json      IN CLOB,
        p_latitude  IN NUMBER DEFAULT NULL,
        p_longitude IN NUMBER DEFAULT NULL
    )
    IS
        l_company_id ptw_pro.ptw_lv_permits.company_id%TYPE;
    BEGIN
        -- Same VPD-backed lookup as above — also doubles as existence check.
        SELECT company_id
        INTO   l_company_id
        FROM   ptw_pro.ptw_lv_permits
        WHERE  permit_id = p_permit_id;

        MERGE INTO ptw_pro.ptw_checklist_responses cr
        USING (
            SELECT jt.checklist_item_id, jt.response
            FROM   JSON_TABLE(
                       p_json, '$[*]'
                       COLUMNS (
                           checklist_item_id NUMBER       PATH '$.checklist_item_id',
                           response          VARCHAR2(2)  PATH '$.response'
                       )
                   ) jt
            WHERE  jt.response IS NOT NULL
        ) src
        ON (cr.permit_id = p_permit_id AND cr.checklist_item_id = src.checklist_item_id)
        WHEN MATCHED THEN
            UPDATE SET cr.response      = src.response,
                       cr.modified_date = CURRENT_TIMESTAMP,
                       cr.modified_by   = NVL(V('APP_USER'), USER)
        WHEN NOT MATCHED THEN
            INSERT (permit_id, checklist_item_id, response, company_id, created_by)
            VALUES (p_permit_id, src.checklist_item_id, src.response, l_company_id,
                     NVL(V('APP_USER'), USER));

        -- Stage-location logging, moved here from ptw_lv_control_measures_
        -- stage_loc_trg. That trigger fires on ptw_lv_control_measures, the
        -- old fixed-column table this checklist refactor stopped writing
        -- to — a table trigger can't watch a table nothing writes to, so
        -- it's been permanently dormant and CONTROL_MEASURES has never
        -- appeared in permit history since this refactor shipped. Only log
        -- when the MERGE actually changed something, same "real changes
        -- only" rule the other stage triggers already follow.
        IF SQL%ROWCOUNT > 0 THEN
            INSERT INTO ptw_pro.ptw_stage_locations (
                permit_id, permit_stage, latitude, longitude,
                created_date, created_by, company_id
            ) VALUES (
                p_permit_id, 'CONTROL_MEASURES', p_latitude, p_longitude,
                SYSDATE, NVL(V('APP_USER'), USER), l_company_id
            );
        END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20052, 'Permit ' || p_permit_id
                || ' not found or not accessible.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20053, 'Error saving checklist for permit '
                || p_permit_id || ': ' || SQLERRM);
    END save_checklist_responses;

END ptw_checklist_pkg;
/
