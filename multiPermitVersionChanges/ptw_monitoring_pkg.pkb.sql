CREATE OR REPLACE PACKAGE BODY ptw_pro.ptw_monitoring_pkg AS

    PROCEDURE save_check(
        p_monitoring_id IN ptw_pro.ptw_lv_monitoring.monitoring_id%TYPE,
        p_check_seq     IN ptw_pro.ptw_monitoring_checks.check_seq%TYPE,
        p_detail        IN ptw_pro.ptw_monitoring_checks.detail%TYPE,
        p_check_time    IN ptw_pro.ptw_monitoring_checks.check_time%TYPE,
        p_in_order      IN ptw_pro.ptw_monitoring_checks.in_order%TYPE,
        p_comments      IN ptw_pro.ptw_monitoring_checks.comments%TYPE DEFAULT NULL
    ) IS
        l_company_id ptw_pro.ptw_lv_monitoring.company_id%TYPE;
    BEGIN
        SELECT company_id INTO l_company_id
        FROM   ptw_pro.ptw_lv_monitoring
        WHERE  monitoring_id = p_monitoring_id;

        MERGE INTO ptw_pro.ptw_monitoring_checks mc
        USING (SELECT p_monitoring_id AS monitoring_id, p_check_seq AS check_seq FROM dual) src
        ON (mc.monitoring_id = src.monitoring_id AND mc.check_seq = src.check_seq)
        WHEN MATCHED THEN
            UPDATE SET detail        = p_detail,
                       check_time    = p_check_time,
                       in_order      = p_in_order,
                       comments      = p_comments,
                       modified_date = CURRENT_TIMESTAMP,
                       modified_by   = NVL(V('APP_USER'), USER)
        WHEN NOT MATCHED THEN
            INSERT (monitoring_id, check_seq, detail, check_time, in_order,
                    comments, company_id, created_by)
            VALUES (p_monitoring_id, p_check_seq, p_detail, p_check_time, p_in_order,
                    p_comments, l_company_id, NVL(V('APP_USER'), USER));

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20070, 'Monitoring record ' || p_monitoring_id
                || ' not found or not accessible.');
        WHEN OTHERS THEN
            IF SQLCODE = -20070 THEN
                RAISE;
            END IF;
            RAISE_APPLICATION_ERROR(-20071, 'Error saving check ' || p_check_seq
                || ' for monitoring ' || p_monitoring_id || ': ' || SQLERRM);
    END save_check;

END ptw_monitoring_pkg;
/
