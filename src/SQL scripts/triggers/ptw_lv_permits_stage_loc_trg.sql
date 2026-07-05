
  CREATE OR REPLACE EDITIONABLE TRIGGER "PTW_PRO"."PTW_LV_PERMITS_STAGE_LOC_TRG"
AFTER INSERT OR UPDATE ON ptw_pro.ptw_lv_permits
FOR EACH ROW
DECLARE
    v_changed BOOLEAN := FALSE;
    l_latitude NUMBER;
    l_longitude NUMBER;
BEGIN
    IF INSERTING THEN
       v_changed := TRUE;
    END IF;
    --
    IF NVL(:NEW.safety_programme_ref_no,'NULL') != NVL(:OLD.safety_programme_ref_no,'NULL') THEN
      v_changed := TRUE;
      l_latitude := :NEW.site_work_latitude;
      l_longitude := :NEW.site_work_longitude;
    END IF;
    IF NVL(:NEW.isolation_diagram_serial_no,'NULL') != NVL(:OLD.isolation_diagram_serial_no,'NULL') THEN
      v_changed := TRUE;
      l_latitude := :NEW.site_work_latitude;
      l_longitude := :NEW.site_work_longitude;
    END IF;
    IF NVL(:NEW.site_details,'NULL') != NVL(:OLD.site_details,'NULL') THEN
      v_changed := TRUE;
      l_latitude := :NEW.site_work_latitude;
      l_longitude := :NEW.site_work_longitude;
    END IF;
    IF NVL(:NEW.work_description,'NULL') !=  NVL(:OLD.work_description,'NULL') THEN
      v_changed := TRUE;
      l_latitude := :NEW.site_work_latitude;
      l_longitude := :NEW.site_work_longitude;
    END IF;
    IF NVL(:NEW.person_in_charge_name,'NULL') != NVL(:OLD.person_in_charge_name,'NULL') THEN
      v_changed := TRUE;
      l_latitude := :NEW.site_work_latitude;
      l_longitude := :NEW.site_work_longitude;
    END IF;
    IF NVL(:NEW.supervising_company,'NULL') != NVL(:OLD.supervising_company,'NULL') THEN
      v_changed := TRUE;
      l_latitude := :NEW.site_work_latitude;
      l_longitude := :NEW.site_work_longitude;
    END IF;
    IF NVL(:NEW.other_persons_count,-999999) != NVL(:OLD.other_persons_count,-999999) THEN
      v_changed := TRUE;
      l_latitude := :NEW.site_work_latitude;
      l_longitude := :NEW.site_work_longitude;
    END IF;
    IF NVL(:NEW.client_permission_granted,'NULL') != NVL(:OLD.client_permission_granted,'NULL') THEN
      v_changed := TRUE;
      l_latitude := :NEW.site_work_latitude;
      l_longitude := :NEW.site_work_longitude;
    END IF;
    IF NVL(:NEW.affects_it_systems,'NULL') != NVL(:OLD.affects_it_systems,'NULL') THEN
      v_changed := TRUE;
      l_latitude := :NEW.site_work_latitude;
      l_longitude := :NEW.site_work_longitude;
    END IF;
    IF NVL(:NEW.it_permission_granted,'NULL') != NVL(:OLD.it_permission_granted,'NULL') THEN
      v_changed := TRUE;
      l_latitude := :NEW.site_work_latitude;
      l_longitude := :NEW.site_work_longitude;
    END IF;
    IF NVL(:NEW.ppe_safety_helmet,'NULL') != NVL(:OLD.ppe_safety_helmet,'NULL') THEN
      v_changed := TRUE;
      l_latitude := :NEW.ppe_latitude;
      l_longitude := :NEW.ppe_longitude;
    END IF;
    IF NVL(:NEW.ppe_arc_flash,'NULL') != NVL(:OLD.ppe_arc_flash,'NULL') THEN
      v_changed := TRUE;
      l_latitude := :NEW.ppe_latitude;
      l_longitude := :NEW.ppe_longitude;
    END IF;
    IF NVL(:NEW.ppe_safety_footwear,'NULL') != NVL(:OLD.ppe_safety_footwear,'NULL') THEN
      v_changed := TRUE;
      l_latitude := :NEW.ppe_latitude;
      l_longitude := :NEW.ppe_longitude;
    END IF;
    IF NVL(:NEW.ppe_hi_vis,'NULL') != NVL(:OLD.ppe_hi_vis,'NULL') THEN
      v_changed := TRUE;
      l_latitude := :NEW.ppe_latitude;
      l_longitude := :NEW.ppe_longitude;
    END IF;
    IF NVL(:NEW.ppe_safety_goggles,'NULL') != NVL(:OLD.ppe_safety_goggles,'NULL') THEN
      v_changed := TRUE;
      l_latitude := :NEW.ppe_latitude;
      l_longitude := :NEW.ppe_longitude;
    END IF;
    IF NVL(:NEW.ppe_insulating_gloves,'NULL') != NVL(:OLD.ppe_insulating_gloves,'NULL') THEN
      v_changed := TRUE;
      l_latitude := :NEW.ppe_latitude;
      l_longitude := :NEW.ppe_longitude;
    END IF;
    IF NVL(:NEW.ppe_fall_restraint,'NULL') != NVL(:OLD.ppe_fall_restraint,'NULL') THEN
      v_changed := TRUE;
      l_latitude := :NEW.ppe_latitude;
      l_longitude := :NEW.ppe_longitude;
    END IF;
    IF NVL(:NEW.ppe_fall_arrest,'NULL') != NVL(:OLD.ppe_fall_arrest,'NULL') THEN
      v_changed := TRUE;
      l_latitude := :NEW.ppe_latitude;
      l_longitude := :NEW.ppe_longitude;
    END IF;
    IF NVL(:NEW.ppe_ear_defenders,'NULL') != NVL(:OLD.ppe_ear_defenders,'NULL') THEN
      v_changed := TRUE;
      l_latitude := :NEW.ppe_latitude;
      l_longitude := :NEW.ppe_longitude;
    END IF;
    IF NVL(:NEW.ppe_safety_gloves,'NULL') != NVL(:OLD.ppe_safety_gloves,'NULL') THEN
      v_changed := TRUE;
      l_latitude := :NEW.ppe_latitude;
      l_longitude := :NEW.ppe_longitude;
    END IF;
    --
    IF (:NEW.accept_person_signature IS NOT NULL AND :OLD.accept_person_signature IS NOT NULL) THEN
        IF DBMS_LOB.COMPARE(:NEW.accept_person_signature, :OLD.accept_person_signature) != 0 THEN
          v_changed := TRUE;
          l_latitude := :NEW.accept_latitude;
          l_longitude := :NEW.accept_longitude;
        END IF;
    ELSIF (:NEW.accept_person_signature IS NULL AND :OLD.accept_person_signature IS NOT NULL) OR
          (:NEW.accept_person_signature IS NOT NULL AND :OLD.accept_person_signature IS NULL) THEN
          v_changed := TRUE;
          l_latitude := :NEW.accept_latitude;
          l_longitude := :NEW.accept_longitude;
    END IF;
    IF (:NEW.auth_person_signature IS NOT NULL AND :OLD.auth_person_signature IS NOT NULL) THEN
        IF DBMS_LOB.COMPARE(:NEW.auth_person_signature, :OLD.auth_person_signature) != 0 THEN
          v_changed := TRUE;
          l_latitude := :NEW.auth_latitude;
          l_longitude := :NEW.auth_longitude;
        END IF;
    ELSIF (:NEW.auth_person_signature IS NULL AND :OLD.auth_person_signature IS NOT NULL) OR
          (:NEW.auth_person_signature IS NOT NULL AND :OLD.auth_person_signature IS NULL) THEN
          v_changed := TRUE;
          l_latitude := :NEW.auth_latitude;
          l_longitude := :NEW.auth_longitude;
    END IF;
    IF (NVL(:NEW.auth_datetime, DATE '1900-01-01') != NVL(:OLD.auth_datetime, DATE '1900-01-01')) THEN
          v_changed := TRUE;
          l_latitude := :NEW.auth_latitude;
          l_longitude := :NEW.auth_longitude;
    END IF;
    IF :NEW.current_step = 'LIVE' AND (NVL(:NEW.started_datetime, DATE '1900-01-01') != NVL(:OLD.started_datetime, DATE '1900-01-01'))THEN
          v_changed := TRUE;
          l_latitude := :NEW.started_latitude;
          l_longitude := :NEW.started_longitude;
    END IF;
    -- Equipment Isolation: catch step transition (NEXT_STEP button)
    IF NVL(:NEW.current_step,'NULL') != NVL(:OLD.current_step,'NULL')
       AND :NEW.current_step = 'EQUIP_ISOLATION' THEN
        v_changed   := TRUE;
        l_latitude  := :NEW.equip_iso_latitude;
        l_longitude := :NEW.equip_iso_longitude;
    END IF;

    -- Equipment Isolation: catch SAVE_DRAFT within the same step
    IF :NEW.current_step = 'EQUIP_ISOLATION'
       AND NVL(:NEW.equip_iso_latitude, -999999) != NVL(:OLD.equip_iso_latitude, -999999) THEN
        v_changed   := TRUE;
        l_latitude  := :NEW.equip_iso_latitude;
        l_longitude := :NEW.equip_iso_longitude;
    END IF;
    -- Clearance: catch step transition (most reliable signal)
    IF NVL(:NEW.current_step,'NULL') != NVL(:OLD.current_step,'NULL')
       AND :NEW.current_step = 'CLEARANCE' THEN
        v_changed   := TRUE;
        l_latitude  := :NEW.clear_latitude;
        l_longitude := :NEW.clear_longitude;
    END IF;

    -- Cancelled: catch step transition
    IF NVL(:NEW.current_step,'NULL') != NVL(:OLD.current_step,'NULL')
       AND :NEW.current_step = 'CANCELLED' THEN
        v_changed   := TRUE;
        l_latitude  := :NEW.cancel_latitude;
        l_longitude := :NEW.cancel_longitude;
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
            :NEW.current_step,
            l_latitude,
            l_longitude,
            SYSDATE,
            NVL(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER),
            :NEW.company_id
        );
    END IF;

END ptw_lv_permits_stage_loc_trg;
/
ALTER TRIGGER "PTW_PRO"."PTW_LV_PERMITS_STAGE_LOC_TRG" ENABLE;
