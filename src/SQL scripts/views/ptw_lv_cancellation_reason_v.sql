
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PTW_PRO"."PTW_LV_CANCELLATION_REASON_V" ("PERMIT_ID", "CANCEL_WORK_COMPLETE", "CANCEL_PERSON_NAME", "CANCEL_DATETIME", "CANCEL_PERSON_SIGNATURE", "CONCERN_ID", "CHECK_NUMBER", "CHECK_LABEL", "CONCERN_DESCRIPTION", "ACTIONS_TAKEN", "CONCERN_PERSON_NAME", "CONCERN_DATETIME", "CONCERN_SIGNATURE", "IS_CONCERN_CANCELLATION") AS
  SELECT
    p.permit_id,
    p.cancel_work_complete,
    cancel_sig.person_name      AS cancel_person_name,
    cancel_sig.event_datetime   AS cancel_datetime,
    cancel_sig.signature_blob   AS cancel_person_signature,
    mc.concern_id,
    mc.check_number,
    CASE mc.check_number
        WHEN 1 THEN 'Method Statement Check 1'
        WHEN 2 THEN 'Method Statement Check 2'
        WHEN 3 THEN 'Method Statement Check 3'
    END                                            AS check_label,
    mc.concern_description,
    mc.actions_taken,
    mc.concern_person_name,
    mc.concern_datetime,
    mc.concern_signature,
    CASE WHEN mc.concern_id IS NOT NULL THEN 'Y' ELSE 'N' END AS is_concern_cancellation
FROM   ptw_pro.ptw_lv_permits p
LEFT JOIN ptw_pro.ptw_signatures cancel_sig
       ON cancel_sig.permit_id = p.permit_id AND cancel_sig.stage = 'CANCEL'
LEFT JOIN ptw_pro.ptw_lv_monitoring_concerns mc
       ON mc.happy_to_continue = 'N'
       AND mc.monitoring_id IN (
             SELECT m.monitoring_id
             FROM   ptw_pro.ptw_lv_monitoring m
             WHERE  m.permit_id = p.permit_id
           )
WHERE  p.workflow_status = 'CANCELLED';
