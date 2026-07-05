
  CREATE OR REPLACE EDITIONABLE TRIGGER "PTW_PRO"."PTW_LV_MONITORING_STAGE_LOC_TRG"
AFTER INSERT OR UPDATE ON ptw_pro.ptw_lv_monitoring
FOR EACH ROW
DECLARE
    v_changed   BOOLEAN := FALSE;
    l_latitude  NUMBER;
    l_longitude NUMBER;
BEGIN
    IF INSERTING THEN
        v_changed   := TRUE;
        l_latitude  := :NEW.monitor_latitude;
        l_longitude := :NEW.monitor_longitude;
    END IF;

    IF NVL(:NEW.monitor_name,'NULL') != NVL(:OLD.monitor_name,'NULL') THEN
        v_changed   := TRUE;
        l_latitude  := :NEW.monitor_latitude;
        l_longitude := :NEW.monitor_longitude;
    END IF;

    IF NVL(:NEW.monitoring_status,'NULL') != NVL(:OLD.monitoring_status,'NULL') THEN
        v_changed   := TRUE;
        l_latitude  := :NEW.monitor_latitude;
        l_longitude := :NEW.monitor_longitude;
    END IF;

    IF (:NEW.monitor_signature IS NOT NULL AND :OLD.monitor_signature IS NOT NULL) THEN
        IF DBMS_LOB.COMPARE(:NEW.monitor_signature, :OLD.monitor_signature) != 0 THEN
            v_changed   := TRUE;
            l_latitude  := :NEW.monitor_latitude;
            l_longitude := :NEW.monitor_longitude;
        END IF;
    ELSIF (:NEW.monitor_signature IS NULL  AND :OLD.monitor_signature IS NOT NULL) OR
          (:NEW.monitor_signature IS NOT NULL AND :OLD.monitor_signature IS NULL) THEN
        v_changed   := TRUE;
        l_latitude  := :NEW.monitor_latitude;
        l_longitude := :NEW.monitor_longitude;
    END IF;

    IF v_changed THEN
        INSERT INTO ptw_pro.ptw_stage_locations (
            permit_id,
            permit_stage,
            latitude,
            longitude,
            created_date,
            created_by,
            company_id
        ) VALUES (
            :NEW.permit_id,
            'MONITORING',
            l_latitude,
            l_longitude,
            SYSDATE,
            NVL(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER),
            :NEW.company_id
        );
    END IF;

END ptw_lv_monitoring_stage_loc_trg;
/
ALTER TRIGGER "PTW_PRO"."PTW_LV_MONITORING_STAGE_LOC_TRG" ENABLE;
