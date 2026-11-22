
  CREATE OR REPLACE EDITIONABLE TRIGGER "PTW_PRO"."TRG_PTW_LV_ATW_EV_COMPANY"
BEFORE INSERT ON ptw_pro.ptw_lv_atw_events
FOR EACH ROW
BEGIN
    SELECT company_id
    INTO   :NEW.company_id
    FROM   ptw_pro.ptw_lv_atw
    WHERE  atw_id = :NEW.atw_id;
END;
/
ALTER TRIGGER "PTW_PRO"."TRG_PTW_LV_ATW_EV_COMPANY" ENABLE;
