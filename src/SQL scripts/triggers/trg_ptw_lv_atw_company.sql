
  CREATE OR REPLACE EDITIONABLE TRIGGER "PTW_PRO"."TRG_PTW_LV_ATW_COMPANY"
BEFORE INSERT ON ptw_pro.ptw_lv_atw
FOR EACH ROW
 WHEN (NEW.company_id IS NULL) BEGIN
    :NEW.company_id := ptw_pro.ptw_sec_pkg.get_effective_company_id;

    IF :NEW.company_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20200,
            'Cannot determine company for this Authority to Work. If you are a super '
            || 'user, select a company first; otherwise contact your administrator.');
    END IF;
END;
/
ALTER TRIGGER "PTW_PRO"."TRG_PTW_LV_ATW_COMPANY" ENABLE;
