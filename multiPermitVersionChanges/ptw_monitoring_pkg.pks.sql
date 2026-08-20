CREATE OR REPLACE PACKAGE ptw_pro.ptw_monitoring_pkg AS
    --------------------------------------------------------------------------
    -- Replaces the MS_CHECK1../2../3.. column groups on PTW_LV_MONITORING.
    -- Still called 3 times today (check_seq 1,2,3) to match the current UI
    -- exactly — but nothing here caps it at 3, so lifting that cap later is
    -- a UI change only, not a schema change.
    --------------------------------------------------------------------------
    PROCEDURE save_check(
        p_monitoring_id IN ptw_pro.ptw_lv_monitoring.monitoring_id%TYPE,
        p_check_seq     IN ptw_pro.ptw_monitoring_checks.check_seq%TYPE,
        p_detail        IN ptw_pro.ptw_monitoring_checks.detail%TYPE,
        p_check_time    IN ptw_pro.ptw_monitoring_checks.check_time%TYPE,
        p_in_order      IN ptw_pro.ptw_monitoring_checks.in_order%TYPE,
        p_comments      IN ptw_pro.ptw_monitoring_checks.comments%TYPE DEFAULT NULL
    );

END ptw_monitoring_pkg;
/
