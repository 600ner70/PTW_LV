--------------------------------------------------------------------------------
-- 06_seed_checklist_items.sql
-- Seeds PTW_TYPES (adds GENERAL if missing) and PTW_CHECKLIST_ITEMS for
-- LV Electrical + General. Safe to re-run (MERGE = idempotent).
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- STEP 0 — confirmed from PTW_TYPES data: LV Electrical's code is
-- 'LV ISOLATION' (type_id 98), not a guessed 'LV_ELECTRICAL'. The literal
-- is corrected throughout this script.
--
-- PTW_TYPES also already has 5 more types sitting ready and AVAILABLE='Y':
-- HOT WORK, CONFINED SPACES, WORKING AT HEIGHT, COLD WORK, LONE WORKING.
-- None of them have checklist items yet — that's expected, add them the
-- same way as LV ISOLATION/GENERAL below whenever each of those forms is
-- ready to build. This script only seeds the two in scope right now.
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- STEP 1 — Ensure both PTW_TYPES rows exist
--------------------------------------------------------------------------------
MERGE INTO ptw_pro.ptw_types t
USING (SELECT 'LV ISOLATION' AS ptw_type, 'LV Isolation Permit to Work' AS type_desc FROM dual) s
ON (t.ptw_type = s.ptw_type)
WHEN NOT MATCHED THEN
    INSERT (ptw_type, type_desc, created_date, created_by, available)
    VALUES (s.ptw_type, s.type_desc, SYSDATE, NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), USER), 'Y');

MERGE INTO ptw_pro.ptw_types t
USING (SELECT 'GENERAL' AS ptw_type, 'General Permit to Work' AS type_desc FROM dual) s
ON (t.ptw_type = s.ptw_type)
WHEN NOT MATCHED THEN
    INSERT (ptw_type, type_desc, created_date, created_by, available)
    VALUES (s.ptw_type, s.type_desc, SYSDATE, NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), USER), 'Y');

COMMIT;

--------------------------------------------------------------------------------
-- STEP 2 — Checklist items
--
-- IMPORTANT: the General items below are a starting point, not a confirmed
-- match to your physical form. The "Smart General Permit to Work" PDF text I
-- had access to was mostly the closure/signature page — I could clearly
-- confirm the pressure-system item (GEN_01) and that the core items below
-- are common to both forms, but I could not see General's full control
-- measures section the way I could for LV Electrical's actual page 3 items.
-- Please check this list against the real form before going live with it.
--------------------------------------------------------------------------------

DECLARE
    l_lv_type_id      ptw_pro.ptw_types.type_id%TYPE;
    l_general_type_id ptw_pro.ptw_types.type_id%TYPE;

    PROCEDURE upsert_item(
        p_type_id       IN ptw_pro.ptw_checklist_items.type_id%TYPE,
        p_section_code  IN ptw_pro.ptw_checklist_items.section_code%TYPE,
        p_item_code     IN ptw_pro.ptw_checklist_items.item_code%TYPE,
        p_item_seq      IN ptw_pro.ptw_checklist_items.item_seq%TYPE,
        p_question_text IN ptw_pro.ptw_checklist_items.question_text%TYPE,
        p_help_text     IN ptw_pro.ptw_checklist_items.help_text%TYPE DEFAULT NULL,
        p_response_type IN ptw_pro.ptw_checklist_items.response_type%TYPE DEFAULT 'TRISTATE'
    ) IS
    BEGIN
        MERGE INTO ptw_pro.ptw_checklist_items ci
        USING (SELECT p_type_id AS type_id, p_item_code AS item_code FROM dual) s
        ON (ci.type_id = s.type_id AND ci.item_code = s.item_code)
        WHEN MATCHED THEN
            UPDATE SET ci.section_code  = p_section_code,
                       ci.item_seq      = p_item_seq,
                       ci.question_text = p_question_text,
                       ci.help_text     = p_help_text,
                       ci.response_type = p_response_type
        WHEN NOT MATCHED THEN
            INSERT (type_id, section_code, item_code, item_seq, question_text, help_text, response_type)
            VALUES (p_type_id, p_section_code, p_item_code, p_item_seq, p_question_text, p_help_text, p_response_type);
    END upsert_item;

BEGIN
    SELECT type_id INTO l_lv_type_id      FROM ptw_pro.ptw_types WHERE ptw_type = 'LV ISOLATION';
    SELECT type_id INTO l_general_type_id FROM ptw_pro.ptw_types WHERE ptw_type = 'GENERAL';

    ------------------------------------------------------------------------
    -- LV ELECTRICAL — Control Measures (mirrors existing P3_CM_01..16)
    ------------------------------------------------------------------------
    upsert_item(l_lv_type_id, 'CONTROL_MEASURES', 'CM_01_SITE_INDUCTION',      10, 'All workers under this PTW have completed and signed off on a site induction?');
    upsert_item(l_lv_type_id, 'CONTROL_MEASURES', 'CM_02_RISK_ASSESSMENT',     20, 'A suitable and sufficient risk assessment and method statement is in place and has been reviewed at the point of works.');
    upsert_item(l_lv_type_id, 'CONTROL_MEASURES', 'CM_03_COMPETENCE_CHECKED',  30, 'Competence of all persons working under this permit has been checked.');
    upsert_item(l_lv_type_id, 'CONTROL_MEASURES', 'CM_04_HAZARDS_AWARE',       40, 'All persons are aware of the hazards associated with this work.');
    upsert_item(l_lv_type_id, 'CONTROL_MEASURES', 'CM_05_PPE_IDENTIFIED',      50, 'Essential PPE required for this work has been identified.');
    upsert_item(l_lv_type_id, 'CONTROL_MEASURES', 'CM_06_SOURCES_ISOLATED',    60, 'All isolated sources of supply have been proved dead using an approved tester and proving unit.');
    upsert_item(l_lv_type_id, 'CONTROL_MEASURES', 'CM_07_PROVED_DEAD',         70, 'Where proving dead was not possible, the AP has confirmed dead at the point of work after issue of this permit.');
    upsert_item(l_lv_type_id, 'CONTROL_MEASURES', 'CM_08_STORED_ENERGY',       80, 'Stored energy sources have been identified and discharged/isolated.');
    upsert_item(l_lv_type_id, 'CONTROL_MEASURES', 'CM_09_LIVE_COVERED',        90, 'Adjacent live parts have been covered/shrouded.');
    upsert_item(l_lv_type_id, 'CONTROL_MEASURES', 'CM_10_NO_LIVE_WORK',       100, 'No live working is permitted/planned under this permit.');
    upsert_item(l_lv_type_id, 'CONTROL_MEASURES', 'CM_11_FIRST_AID',          110, 'First aid provision is in place for the duration of the works.');
    upsert_item(l_lv_type_id, 'CONTROL_MEASURES', 'CM_12_BARRIERS',           120, 'Barriers/signage are in place around the work area.');
    upsert_item(l_lv_type_id, 'CONTROL_MEASURES', 'CM_13_ACCESS_EGRESS',      130, 'Access and egress to the work area is clear.');
    upsert_item(l_lv_type_id, 'CONTROL_MEASURES', 'CM_14_INSULATED_MATTING',  140, 'Insulated matting is in place where required.');
    upsert_item(l_lv_type_id, 'CONTROL_MEASURES', 'CM_15_CALIBRATION_CURRENT',150, 'Calibration of the test equipment used is confirmed current.');
    upsert_item(l_lv_type_id, 'CONTROL_MEASURES', 'CM_16_DANGER_SIGNS',       160, 'Danger signs have been applied to adjacent live equipment.');

    ------------------------------------------------------------------------
    -- LV ELECTRICAL — PPE (mirrors existing PPE_* columns)
    ------------------------------------------------------------------------
    upsert_item(l_lv_type_id, 'PPE', 'PPE_SAFETY_HELMET',      10, 'Safety Helmet (Hard Hat)',        NULL, 'TICK');
    upsert_item(l_lv_type_id, 'PPE', 'PPE_ARC_FLASH',          20, 'Arc Flash PPE',                   NULL, 'TICK');
    upsert_item(l_lv_type_id, 'PPE', 'PPE_SAFETY_FOOTWEAR',    30, 'Safety Footwear',                 NULL, 'TICK');
    upsert_item(l_lv_type_id, 'PPE', 'PPE_HI_VIS',             40, 'Hi-Vis Vest/Jacket',              NULL, 'TICK');
    upsert_item(l_lv_type_id, 'PPE', 'PPE_SAFETY_GOGGLES',     50, 'Safety Goggles',                  NULL, 'TICK');
    upsert_item(l_lv_type_id, 'PPE', 'PPE_INSULATING_GLOVES',  60, 'Electrical Insulating Gloves',    NULL, 'TICK');
    upsert_item(l_lv_type_id, 'PPE', 'PPE_FALL_RESTRAINT',     70, 'Fall Restraint Harness',          NULL, 'TICK');
    upsert_item(l_lv_type_id, 'PPE', 'PPE_FALL_ARREST',        80, 'Fall Arrest Harness',             NULL, 'TICK');
    upsert_item(l_lv_type_id, 'PPE', 'PPE_EAR_DEFENDERS',      90, 'Ear Defenders/Plugs',             NULL, 'TICK');
    upsert_item(l_lv_type_id, 'PPE', 'PPE_SAFETY_GLOVES',     100, 'Safety Gloves',                   NULL, 'TICK');

    ------------------------------------------------------------------------
    -- GENERAL — Control Measures
    -- Shared items reuse the SAME item_code as LV where the question is
    -- identical, so a future "did every type ask this?" report is a trivial
    -- GROUP BY item_code. GEN_01 is the one item confirmed distinct to
    -- General from the PDF (pressure systems).
    ------------------------------------------------------------------------
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'CM_01_SITE_INDUCTION',      10, 'All workers under this PTW have completed and signed off on a site induction?');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'CM_02_RISK_ASSESSMENT',     20, 'A suitable and sufficient risk assessment and method statement is in place and has been reviewed at the point of works.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'CM_03_COMPETENCE_CHECKED',  30, 'Competence of all persons working under this permit has been checked.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'CM_05_PPE_IDENTIFIED',      40, 'Essential PPE required for this work has been identified.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'CM_11_FIRST_AID',           50, 'First aid provision is in place for the duration of the works.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'CM_12_BARRIERS',            60, 'Barriers/signage are in place around the work area.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'CM_13_ACCESS_EGRESS',       70, 'Access and egress to the work area is clear.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'CM_15_CALIBRATION_CURRENT', 80, 'Calibration of the test equipment used is confirmed current.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'GEN_01_PRESSURE_NEUTRAL',   90, 'Where works are conducted on pressurised systems, the system has been returned to a neutral state before work commences.');

    ------------------------------------------------------------------------
    -- GENERAL — PPE (shared subset — confirm the full list against the form)
    ------------------------------------------------------------------------
    upsert_item(l_general_type_id, 'PPE', 'PPE_SAFETY_HELMET',   10, 'Safety Helmet (Hard Hat)',  NULL, 'TICK');
    upsert_item(l_general_type_id, 'PPE', 'PPE_SAFETY_FOOTWEAR', 20, 'Safety Footwear',           NULL, 'TICK');
    upsert_item(l_general_type_id, 'PPE', 'PPE_HI_VIS',          30, 'Hi-Vis Vest/Jacket',        NULL, 'TICK');
    upsert_item(l_general_type_id, 'PPE', 'PPE_SAFETY_GOGGLES',  40, 'Safety Goggles',            NULL, 'TICK');
    upsert_item(l_general_type_id, 'PPE', 'PPE_EAR_DEFENDERS',   50, 'Ear Defenders/Plugs',       NULL, 'TICK');
    upsert_item(l_general_type_id, 'PPE', 'PPE_SAFETY_GLOVES',   60, 'Safety Gloves',             NULL, 'TICK');

    COMMIT;    ------------------------------------------------------------------------
    -- GENERAL — Control Measures (corrected against the full "Permit to
    -- Work — General Work" form; previous seed was based on the closure
    -- page only and missed/misworded several items — see chat history).
    -- Shared item_codes reused only where the question is genuinely the
    -- same as LV's; items 4, 6, 8-13 have no LV equivalent and are new.
    ------------------------------------------------------------------------
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'CM_01_SITE_INDUCTION',        10, 'All persons working under this permit have undertaken a site specific safety induction.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'CM_02_RISK_ASSESSMENT',       20, 'A suitable and sufficient written risk assessment and method statement for these works, which has been read and understood by all persons working under this permit, is in place and has been reviewed at the point of works by the person controlling the works.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'CM_03_COMPETENCE_CHECKED',    30, 'The competence of the people working under the permit has been checked and is deemed to be adequate for these works.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'GEN_02_PIC_HAZARDS_AWARE',    40, 'The person in charge of the works must be made aware of all hazards within the vicinity of the place of works.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'CM_05_PPE_IDENTIFIED',        50, 'Where the use of PPE is identified as a control measure within the risk assessment, this equipment is in good order.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'GEN_03_ISOLATED_LOCKED',      60, 'All equipment/systems to be worked on have been isolated and locked off from all sources of energy, with suitable signage fitted.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'CM_08_STORED_ENERGY',         70, 'All systems to be worked on have been checked to ensure that any stored energy has been dissipated.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'GEN_04_ACCEPTOR_ISOLATION',   80, 'The person accepting this permit must be shown the points of isolation and be given the option of fitting additional safety locks.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'GEN_05_REFERRAL_LV_HV_TEST',  90, 'Where works and/or testing is to be conducted on potentially ''live equipment'', a separate ''Low Voltage'' and/or ''High Voltage'' Electrical Permit and/or ''Sanction to Test'' must be issued.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'GEN_06_REFERRAL_HV_ACCESS',  100, 'Where works are in the vicinity of High Voltage systems and/or equipment a ''High Voltage Limitation of Access'' must be issued.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'GEN_07_REFERRAL_HEIGHT',     110, 'Where ''Working at Height'' is to be conducted, a separate ''Working at Height Permit'' must be issued.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'GEN_08_REFERRAL_CONFINED',   120, 'Where works are to be conducted in an area defined as a ''Confined Space'', a separate ''Confined Spaces Permit'' must be issued.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'GEN_09_REFERRAL_HOT_WORKS',  130, 'Where ''Hot Works'' are to be conducted, a separate ''Hot Works Permit'' must be issued.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'GEN_01_PRESSURE_NEUTRAL',    140, 'Where works are to be conducted on pressurised systems, the pressure system must be returned to a neutral state before work commences.');

    ------------------------------------------------------------------------
    -- GENERAL — PPE: no separate PPE checklist section exists on the real
    -- form (PPE is only referenced inline in item 5 above). The 6 PPE items
    -- seeded previously were invented, not derived from the form — retire
    -- them rather than leave stale rows the checklist UI would still render.
    ------------------------------------------------------------------------
    UPDATE ptw_pro.ptw_checklist_items
    SET    is_active = 'N'
    WHERE  type_id      = l_general_type_id
    AND    section_code = 'PPE';
END;
/