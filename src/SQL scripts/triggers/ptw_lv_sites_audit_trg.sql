create or replace TRIGGER "PTW_PRO"."TRG_PTW_LV_SITES_AUDIT"
 BEFORE INSERT OR UPDATE ON ptw_pro.ptw_lv_sites
 FOR EACH ROW
 BEGIN
     IF INSERTING THEN
         :NEW.created_date := SYSTIMESTAMP;
         :NEW.created_by   := NVL(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER);
     END IF;
     :NEW.modified_date := SYSTIMESTAMP;
     :NEW.modified_by   := NVL(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER);
 END;
 /

