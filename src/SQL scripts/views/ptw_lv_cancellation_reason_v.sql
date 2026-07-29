CREATE OR REPLACE VIEW ptw_pro.ptw_lv_cancellation_reason_v AS
SELECT
    p.permit_id,
    p.cancel_work_complete,
    p.cancel_person_name,
    p.cancel_datetime,
    p.cancel_person_signature,
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
LEFT JOIN ptw_pro.ptw_lv_monitoring_concerns mc
       ON mc.happy_to_continue = 'N'
       AND mc.monitoring_id IN (
             SELECT m.monitoring_id
             FROM   ptw_pro.ptw_lv_monitoring m
             WHERE  m.permit_id = p.permit_id
           )
WHERE  p.workflow_status = 'CANCELLED';
