
  CREATE OR REPLACE EDITIONABLE TRIGGER "PTW_PRO"."PTW_LV_CONTROL_MEASURES_STAGE_LOC_TRG"
AFTER INSERT OR UPDATE ON ptw_pro.ptw_lv_control_measures
FOR EACH ROW
DECLARE
    v_changed BOOLEAN := FALSE;
BEGIN
    IF INSERTING THEN
       v_changed := TRUE;
    END IF;
       --
    IF NVL(:NEW.cm_01_site_induction,'NULL') != NVL(:OLD.cm_01_site_induction,'NULL') THEN v_changed := TRUE; END IF;
    IF NVL(:NEW.cm_02_risk_assessment,'NULL') != NVL(:OLD.cm_02_risk_assessment,'NULL') THEN v_changed := TRUE; END IF;
    IF NVL(:NEW.cm_03_competence_checked,'NULL') != NVL(:OLD.cm_03_competence_checked,'NULL') THEN v_changed := TRUE; END IF;
    IF NVL(:NEW.cm_04_hazards_aware,'NULL') != NVL(:OLD.cm_04_hazards_aware,'NULL') THEN v_changed := TRUE; END IF;
    IF NVL(:NEW.cm_05_ppe_identified,'NULL') != NVL(:OLD.cm_05_ppe_identified,'NULL') THEN v_changed := TRUE; END IF;
    IF NVL(:NEW.cm_06_sources_isolated,'NULL') != NVL(:OLD.cm_06_sources_isolated,'NULL') THEN v_changed := TRUE; END IF;
    IF NVL(:NEW.cm_07_proved_dead,'NULL') != NVL(:OLD.cm_07_proved_dead,'NULL') THEN v_changed := TRUE; END IF;
    IF NVL(:NEW.cm_08_stored_energy,'NULL') != NVL(:OLD.cm_08_stored_energy,'NULL') THEN v_changed := TRUE; END IF;
    IF NVL(:NEW.cm_09_live_covered,'NULL') != NVL(:OLD.cm_09_live_covered,'NULL') THEN v_changed := TRUE; END IF;
    IF NVL(:NEW.cm_10_no_live_work,'NULL') != NVL(:OLD.cm_10_no_live_work,'NULL') THEN v_changed := TRUE; END IF;
    IF NVL(:NEW.cm_11_first_aid,'NULL') != NVL(:OLD.cm_11_first_aid,'NULL') THEN v_changed := TRUE; END IF;
    IF NVL(:NEW.cm_12_barriers,'NULL') != NVL(:OLD.cm_12_barriers,'NULL') THEN v_changed := TRUE; END IF;
    IF NVL(:NEW.cm_13_access_egress,'NULL') != NVL(:OLD.cm_13_access_egress,'NULL') THEN v_changed := TRUE; END IF;
    IF NVL(:NEW.cm_14_insulated_matting,'NULL') != NVL(:OLD.cm_14_insulated_matting,'NULL') THEN v_changed := TRUE; END IF;
    IF NVL(:NEW.cm_15_calibration_current,'NULL') != NVL(:OLD.cm_15_calibration_current,'NULL') THEN v_changed := TRUE; END IF;
    IF NVL(:NEW.cm_16_danger_signs,'NULL') != NVL(:OLD.cm_16_danger_signs,'NULL') THEN v_changed := TRUE; END IF;

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
            'CONTROL_MEASURES',
            :NEW.cm_latitude,
            :NEW.cm_longitude,
            SYSDATE,
            NVL(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER),
            :NEW.company_id
        );
    END IF;
END ptw_lv_control_measures_stage_loc_trg;
/
ALTER TRIGGER "PTW_PRO"."PTW_LV_CONTROL_MEASURES_STAGE_LOC_TRG" ENABLE;
