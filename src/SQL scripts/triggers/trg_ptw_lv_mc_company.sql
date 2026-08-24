
  CREATE OR REPLACE EDITIONABLE TRIGGER "PTW_PRO"."TRG_PTW_LV_MC_COMPANY"
    BEFORE INSERT ON ptw_pro.ptw_lv_monitoring_concerns
    FOR EACH ROW
     WHEN (NEW.company_id IS NULL) DECLARE
    v_company_id ptw_pro.ptw_lv_permits.company_id%TYPE;
BEGIN
    SELECT p.company_id
    INTO   v_company_id
    FROM   ptw_pro.ptw_lv_monitoring m
    JOIN   ptw_pro.ptw_lv_permits    p ON p.permit_id = m.permit_id
    WHERE  m.monitoring_id = :NEW.monitoring_id;

    :NEW.company_id := v_company_id;
END;

/
ALTER TRIGGER "PTW_PRO"."TRG_PTW_LV_MC_COMPANY" ENABLE;
