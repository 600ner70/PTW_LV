create or replace TRIGGER ptw_pro.ptw_lv_equipment_isolation_stage_loc_trg
AFTER INSERT OR UPDATE ON ptw_pro.ptw_lv_equipment_isolation
FOR EACH ROW
DECLARE
    v_changed BOOLEAN := FALSE;
BEGIN
    IF INSERTING THEN
       v_changed := TRUE;
    ELSIF UPDATING THEN
       --
       IF NVL(:NEW.equipment_isolated,'NULL') != NVL(:OLD.equipment_isolated,'NULL') THEN v_changed := TRUE; END IF;
       IF NVL(:NEW.means_of_isolation,'NULL') != NVL(:OLD.means_of_isolation,'NULL') THEN v_changed := TRUE; END IF;
       IF NVL(:NEW.safety_lock_no,'NULL') != NVL(:OLD.safety_lock_no,'NULL') THEN v_changed := TRUE; END IF;
    END IF;
    IF v_changed THEN

        DECLARE
          l_latitude NUMBER;
          l_longitude NUMBER;
        BEGIN
          SELECT equip_iso_latitude, equip_iso_longitude
          INTO   l_latitude, l_longitude
          FROM   ptw_pro.ptw_lv_permits
          WHERE  permit_id = :NEW.permit_id;
    
          INSERT INTO ptw_pro.ptw_stage_locations (
            permit_id,
            permit_stage,
            latitude,
            longitude,
            created_date,
            created_by
          ) VALUES (
            :NEW.permit_id,
            'EQUIP_ISOLATION',
            l_latitude,
            l_longitude,
            SYSDATE,
            NVL(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER)
          );
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
    END IF;
END ptw_lv_equipment_isolation_stage_loc_trg;
/
