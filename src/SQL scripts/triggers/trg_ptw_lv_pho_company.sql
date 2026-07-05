
  CREATE OR REPLACE EDITIONABLE TRIGGER "PTW_PRO"."TRG_PTW_LV_PHO_COMPANY"
BEFORE INSERT ON ptw_pro.ptw_lv_permit_photos
FOR EACH ROW
 WHEN (NEW.company_id IS NULL) BEGIN
    SELECT company_id INTO :NEW.company_id
    FROM ptw_pro.ptw_lv_permits
    WHERE permit_id = :NEW.permit_id;
END;

/
ALTER TRIGGER "PTW_PRO"."TRG_PTW_LV_PHO_COMPANY" ENABLE;
