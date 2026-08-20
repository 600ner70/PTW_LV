--------------------------------------------------------------------------------
-- 07_migrate_existing_data.sql
-- One-time backfill of existing LV Electrical permit data into the new
-- normalized tables. Run AFTER 05 and 06.
--
-- *** RUN ON A DEV/TEST COPY FIRST. Check row counts against source tables
-- *** before trusting this against real permit data, same as your existing
-- *** 04_backfill.sql note.
--
-- Legacy columns on PTW_LV_CONTROL_MEASURES / PTW_LV_PERMITS / PTW_LV_MONITORING
-- are left in place — nothing here drops or alters them. This only copies
-- data forward. Decide separately (and later) whether/when to retire them
-- once the app is reading from the new tables.
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 1. CONTROL MEASURES (16 columns -> rows), via UNPIVOT
--    UNPIVOT excludes NULLs by default, so only answered questions migrate.
--
--    NOTE on aliasing: UNPIVOT must apply to a single row source, so the
--    join is wrapped in a subquery (src) first. But once UNPIVOT (...) u
--    is applied, "src" stops being visible to the outer query entirely —
--    ALL columns of the result, including passthrough ones that were
--    never part of the pivot (permit_id, company_id), must be referenced
--    via the alias that follows UNPIVOT (u), not the pre-UNPIVOT alias.
--------------------------------------------------------------------------------
INSERT INTO ptw_pro.ptw_checklist_responses
    (permit_id, checklist_item_id, response, company_id, created_by)
SELECT u.permit_id, ci.checklist_item_id, u.response_value, u.company_id,
       'MIGRATION_07'
FROM (
    SELECT cm.permit_id, p.company_id,
           cm.cm_01_site_induction,     cm.cm_02_risk_assessment,
           cm.cm_03_competence_checked, cm.cm_04_hazards_aware,
           cm.cm_05_ppe_identified,     cm.cm_06_sources_isolated,
           cm.cm_07_proved_dead,        cm.cm_08_stored_energy,
           cm.cm_09_live_covered,       cm.cm_10_no_live_work,
           cm.cm_11_first_aid,          cm.cm_12_barriers,
           cm.cm_13_access_egress,      cm.cm_14_insulated_matting,
           cm.cm_15_calibration_current, cm.cm_16_danger_signs
    FROM   ptw_pro.ptw_lv_control_measures cm
    JOIN   ptw_pro.ptw_lv_permits p ON p.permit_id = cm.permit_id
) src
UNPIVOT (response_value FOR item_code IN (
    cm_01_site_induction        AS 'CM_01_SITE_INDUCTION',
    cm_02_risk_assessment       AS 'CM_02_RISK_ASSESSMENT',
    cm_03_competence_checked    AS 'CM_03_COMPETENCE_CHECKED',
    cm_04_hazards_aware         AS 'CM_04_HAZARDS_AWARE',
    cm_05_ppe_identified        AS 'CM_05_PPE_IDENTIFIED',
    cm_06_sources_isolated      AS 'CM_06_SOURCES_ISOLATED',
    cm_07_proved_dead           AS 'CM_07_PROVED_DEAD',
    cm_08_stored_energy         AS 'CM_08_STORED_ENERGY',
    cm_09_live_covered          AS 'CM_09_LIVE_COVERED',
    cm_10_no_live_work          AS 'CM_10_NO_LIVE_WORK',
    cm_11_first_aid             AS 'CM_11_FIRST_AID',
    cm_12_barriers               AS 'CM_12_BARRIERS',
    cm_13_access_egress         AS 'CM_13_ACCESS_EGRESS',
    cm_14_insulated_matting     AS 'CM_14_INSULATED_MATTING',
    cm_15_calibration_current   AS 'CM_15_CALIBRATION_CURRENT',
    cm_16_danger_signs          AS 'CM_16_DANGER_SIGNS'
)) u
JOIN ptw_pro.ptw_checklist_items ci
  ON ci.item_code = u.item_code
 AND ci.type_id   = (SELECT type_id FROM ptw_pro.ptw_types WHERE ptw_type = 'LV ISOLATION')
WHERE NOT EXISTS (
    SELECT 1 FROM ptw_pro.ptw_checklist_responses cr
    WHERE cr.permit_id = u.permit_id AND cr.checklist_item_id = ci.checklist_item_id
);

--------------------------------------------------------------------------------
-- 2. PPE (10 columns -> rows), same technique, source is PTW_LV_PERMITS directly.
--    No JOIN here, but the same alias-scoping issue still applies to a raw
--    table reference — wrapped in a subquery for the same reason.
--------------------------------------------------------------------------------
INSERT INTO ptw_pro.ptw_checklist_responses
    (permit_id, checklist_item_id, response, company_id, created_by)
SELECT u.permit_id, ci.checklist_item_id, u.response_value, u.company_id,
       'MIGRATION_07'
FROM (
    SELECT permit_id, company_id,
           ppe_safety_helmet,     ppe_arc_flash,
           ppe_safety_footwear,   ppe_hi_vis,
           ppe_safety_goggles,    ppe_insulating_gloves,
           ppe_fall_restraint,    ppe_fall_arrest,
           ppe_ear_defenders,     ppe_safety_gloves
    FROM   ptw_pro.ptw_lv_permits
) src
UNPIVOT (response_value FOR item_code IN (
    ppe_safety_helmet      AS 'PPE_SAFETY_HELMET',
    ppe_arc_flash          AS 'PPE_ARC_FLASH',
    ppe_safety_footwear    AS 'PPE_SAFETY_FOOTWEAR',
    ppe_hi_vis             AS 'PPE_HI_VIS',
    ppe_safety_goggles     AS 'PPE_SAFETY_GOGGLES',
    ppe_insulating_gloves  AS 'PPE_INSULATING_GLOVES',
    ppe_fall_restraint     AS 'PPE_FALL_RESTRAINT',
    ppe_fall_arrest        AS 'PPE_FALL_ARREST',
    ppe_ear_defenders      AS 'PPE_EAR_DEFENDERS',
    ppe_safety_gloves      AS 'PPE_SAFETY_GLOVES'
)) u
JOIN ptw_pro.ptw_checklist_items ci
  ON ci.item_code = u.item_code
 AND ci.type_id   = (SELECT type_id FROM ptw_pro.ptw_types WHERE ptw_type = 'LV ISOLATION')
WHERE NOT EXISTS (
    SELECT 1 FROM ptw_pro.ptw_checklist_responses cr
    WHERE cr.permit_id = u.permit_id AND cr.checklist_item_id = ci.checklist_item_id
);

COMMIT;

--------------------------------------------------------------------------------
-- 3. SIGNATURES — 4 stages, explicit (column sets genuinely differ per
--    stage: AUTH has no company column, CANCEL has neither mobile nor
--    company — matching exactly what PTW_LV_PERMITS actually has today,
--    not an assumed symmetric shape).
--------------------------------------------------------------------------------
INSERT INTO ptw_pro.ptw_signatures
    (permit_id, stage, person_name, signature_blob, mobile_no, event_datetime,
     latitude, longitude, company_id, created_by)
SELECT permit_id, 'AUTH', auth_person_name, auth_person_signature, auth_person_mobile,
       auth_datetime, auth_latitude, auth_longitude, company_id, 'MIGRATION_07'
FROM   ptw_pro.ptw_lv_permits p
WHERE  auth_person_name IS NOT NULL
AND    NOT EXISTS (SELECT 1 FROM ptw_pro.ptw_signatures s WHERE s.permit_id = p.permit_id AND s.stage = 'AUTH');

INSERT INTO ptw_pro.ptw_signatures
    (permit_id, stage, person_name, signature_blob, mobile_no, company_name, event_datetime,
     latitude, longitude, company_id, created_by)
SELECT permit_id, 'ACCEPT', accept_person_name, accept_person_signature, accept_person_mobile,
       accept_company, accept_datetime, accept_latitude, accept_longitude, company_id, 'MIGRATION_07'
FROM   ptw_pro.ptw_lv_permits p
WHERE  accept_person_name IS NOT NULL
AND    NOT EXISTS (SELECT 1 FROM ptw_pro.ptw_signatures s WHERE s.permit_id = p.permit_id AND s.stage = 'ACCEPT');

INSERT INTO ptw_pro.ptw_signatures
    (permit_id, stage, person_name, signature_blob, mobile_no, company_name, event_datetime,
     latitude, longitude, company_id, created_by)
SELECT permit_id, 'CLEAR', clear_person_name, clear_person_signature, clear_person_mobile,
       clear_company, clear_datetime, clear_latitude, clear_longitude, company_id, 'MIGRATION_07'
FROM   ptw_pro.ptw_lv_permits p
WHERE  clear_person_name IS NOT NULL
AND    NOT EXISTS (SELECT 1 FROM ptw_pro.ptw_signatures s WHERE s.permit_id = p.permit_id AND s.stage = 'CLEAR');

INSERT INTO ptw_pro.ptw_signatures
    (permit_id, stage, person_name, signature_blob, event_datetime,
     latitude, longitude, company_id, created_by)
SELECT permit_id, 'CANCEL', cancel_person_name, cancel_person_signature,
       cancel_datetime, cancel_latitude, cancel_longitude, company_id, 'MIGRATION_07'
FROM   ptw_pro.ptw_lv_permits p
WHERE  cancel_person_name IS NOT NULL
AND    NOT EXISTS (SELECT 1 FROM ptw_pro.ptw_signatures s WHERE s.permit_id = p.permit_id AND s.stage = 'CANCEL');

COMMIT;

--------------------------------------------------------------------------------
-- 4. MONITORING CHECKS — 3 fixed slots -> rows (still capped at 3 here;
--    lifting the cap is a UI change, out of scope for this migration)
--------------------------------------------------------------------------------
INSERT INTO ptw_pro.ptw_monitoring_checks
    (monitoring_id, check_seq, detail, check_time, in_order, comments, company_id, created_by)
SELECT monitoring_id, 1, ms_check1_detail, ms_check1_time, ms_check1_in_order, ms_check1_comments,
       company_id, 'MIGRATION_07'
FROM   ptw_pro.ptw_lv_monitoring m
WHERE  ms_check1_detail IS NOT NULL
AND    NOT EXISTS (SELECT 1 FROM ptw_pro.ptw_monitoring_checks c WHERE c.monitoring_id = m.monitoring_id AND c.check_seq = 1);

INSERT INTO ptw_pro.ptw_monitoring_checks
    (monitoring_id, check_seq, detail, check_time, in_order, comments, company_id, created_by)
SELECT monitoring_id, 2, ms_check2_detail, ms_check2_time, ms_check2_in_order, ms_check2_comments,
       company_id, 'MIGRATION_07'
FROM   ptw_pro.ptw_lv_monitoring m
WHERE  ms_check2_detail IS NOT NULL
AND    NOT EXISTS (SELECT 1 FROM ptw_pro.ptw_monitoring_checks c WHERE c.monitoring_id = m.monitoring_id AND c.check_seq = 2);

INSERT INTO ptw_pro.ptw_monitoring_checks
    (monitoring_id, check_seq, detail, check_time, in_order, comments, company_id, created_by)
SELECT monitoring_id, 3, ms_check3_detail, ms_check3_time, ms_check3_in_order, ms_check3_comments,
       company_id, 'MIGRATION_07'
FROM   ptw_pro.ptw_lv_monitoring m
WHERE  ms_check3_detail IS NOT NULL
AND    NOT EXISTS (SELECT 1 FROM ptw_pro.ptw_monitoring_checks c WHERE c.monitoring_id = m.monitoring_id AND c.check_seq = 3);

COMMIT;

--------------------------------------------------------------------------------
-- 5. Sanity checks — row counts should roughly line up (won't be exact 1:1
--    since legacy columns can hold NULL where new rows are simply absent)
--------------------------------------------------------------------------------
-- SELECT COUNT(*) FROM ptw_pro.ptw_checklist_responses;
-- SELECT COUNT(*) FROM ptw_pro.ptw_signatures;
-- SELECT COUNT(*) FROM ptw_pro.ptw_monitoring_checks;