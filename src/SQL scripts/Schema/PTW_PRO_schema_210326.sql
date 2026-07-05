 CREATE TABLE "PTW_LV_PERMITS" 
   (	"PERMIT_ID" NUMBER DEFAULT "PTW_PRO"."PTW_LV_PERMIT_SEQ"."NEXTVAL", 
	"PERMIT_NUMBER" VARCHAR2(50), 
	"SAFETY_PROGRAMME_REF_NO" VARCHAR2(100), 
	"ISOLATION_DIAGRAM_SERIAL_NO" VARCHAR2(100), 
	"SITE_DETAILS" VARCHAR2(500), 
	"AREA_OF_WORKS" VARCHAR2(500), 
	"WORK_DESCRIPTION" VARCHAR2(2000), 
	"PERSON_IN_CHARGE_NAME" VARCHAR2(200), 
	"SUPERVISING_COMPANY" VARCHAR2(200), 
	"OTHER_PERSONS_COUNT" NUMBER, 
	"CLIENT_PERMISSION_GRANTED" VARCHAR2(2), 
	"AFFECTS_IT_SYSTEMS" VARCHAR2(2), 
	"IT_PERMISSION_GRANTED" VARCHAR2(2), 
	"PPE_SAFETY_HELMET" VARCHAR2(2), 
	"PPE_ARC_FLASH" VARCHAR2(2), 
	"PPE_SAFETY_FOOTWEAR" VARCHAR2(2), 
	"PPE_HI_VIS" VARCHAR2(2), 
	"PPE_SAFETY_GOGGLES" VARCHAR2(2), 
	"PPE_INSULATING_GLOVES" VARCHAR2(2), 
	"PPE_FALL_RESTRAINT" VARCHAR2(2), 
	"PPE_FALL_ARREST" VARCHAR2(2), 
	"PPE_EAR_DEFENDERS" VARCHAR2(2), 
	"PPE_SAFETY_GLOVES" VARCHAR2(2), 
	"COMMENTS" VARCHAR2(4000), 
	"AUTH_PERSON_NAME" VARCHAR2(200), 
	"AUTH_PERSON_SIGNATURE" BLOB, 
	"AUTH_PERSON_MOBILE" VARCHAR2(50), 
	"AUTH_FROM_DATETIME" DATE, 
	"AUTH_TO_DATETIME" DATE, 
	"AUTH_LATITUDE" NUMBER, 
	"AUTH_LONGITUDE" NUMBER, 
	"ACCEPT_PERSON_NAME" VARCHAR2(200), 
	"ACCEPT_PERSON_SIGNATURE" BLOB, 
	"ACCEPT_PERSON_MOBILE" VARCHAR2(50), 
	"ACCEPT_COMPANY" VARCHAR2(200), 
	"ACCEPT_DATETIME" DATE, 
	"ACCEPT_LATITUDE" NUMBER, 
	"ACCEPT_LONGITUDE" NUMBER, 
	"CLEAR_WORK_COMPLETE" VARCHAR2(2), 
	"CLEAR_AREA_SAFE" VARCHAR2(2), 
	"CLEAR_PERSON_NAME" VARCHAR2(200), 
	"CLEAR_PERSON_SIGNATURE" BLOB, 
	"CLEAR_PERSON_MOBILE" VARCHAR2(50), 
	"CLEAR_COMPANY" VARCHAR2(200), 
	"CLEAR_DATETIME" DATE, 
	"CLEAR_LATITUDE" NUMBER, 
	"CLEAR_LONGITUDE" NUMBER, 
	"CANCEL_WORK_COMPLETE" VARCHAR2(2), 
	"CANCEL_PERSON_NAME" VARCHAR2(200), 
	"CANCEL_PERSON_SIGNATURE" BLOB, 
	"CANCEL_DATETIME" DATE, 
	"CANCEL_LATITUDE" NUMBER, 
	"CANCEL_LONGITUDE" NUMBER, 
	"CURRENT_STEP" VARCHAR2(50) DEFAULT 'SITE_WORK_DETAILS', 
	"WORKFLOW_STATUS" VARCHAR2(20) DEFAULT 'IN_PROGRESS', 
	"COMPLETION_DATE" DATE, 
	"CREATED_DATE" TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP, 
	"CREATED_BY" VARCHAR2(100), 
	"MODIFIED_DATE" TIMESTAMP (6), 
	"MODIFIED_BY" VARCHAR2(100), 
	"SITE_WORK_LATITUDE" NUMBER, 
	"SITE_WORK_LONGITUDE" NUMBER, 
	"PPE_LATITUDE" NUMBER, 
	"PPE_LONGITUDE" NUMBER, 
	"EQUIP_ISO_LATITUDE" NUMBER, 
	"EQUIP_ISO_LONGITUDE" NUMBER, 
	"SUSPENSION_REASON" VARCHAR2(400), 
	"SUSPENDED_DATE" DATE, 
	"SUSPENDED_BY" VARCHAR2(100), 
	"RESUMED_DATE" DATE, 
	"RESUMED_BY" VARCHAR2(100), 
	 PRIMARY KEY ("PERMIT_ID")
  USING INDEX  ENABLE
   ) ;

  CREATE TABLE "PTW_LV_CONTROL_MEASURES" 
   (	"CONTROL_MEASURES_ID" NUMBER DEFAULT "PTW_PRO"."PTW_LV_CONTROL_MEASURES_SEQ"."NEXTVAL", 
	"PERMIT_ID" NUMBER NOT NULL ENABLE, 
	"CM_01_SITE_INDUCTION" VARCHAR2(2), 
	"CM_02_RISK_ASSESSMENT" VARCHAR2(2), 
	"CM_03_COMPETENCE_CHECKED" VARCHAR2(2), 
	"CM_04_HAZARDS_AWARE" VARCHAR2(2), 
	"CM_05_PPE_IDENTIFIED" VARCHAR2(2), 
	"CM_06_SOURCES_ISOLATED" VARCHAR2(2), 
	"CM_07_PROVED_DEAD" VARCHAR2(2), 
	"CM_08_STORED_ENERGY" VARCHAR2(2), 
	"CM_09_LIVE_COVERED" VARCHAR2(2), 
	"CM_10_NO_LIVE_WORK" VARCHAR2(2), 
	"CM_11_FIRST_AID" VARCHAR2(2), 
	"CM_12_BARRIERS" VARCHAR2(2), 
	"CM_13_ACCESS_EGRESS" VARCHAR2(2), 
	"CM_14_INSULATED_MATTING" VARCHAR2(2), 
	"CM_15_CALIBRATION_CURRENT" VARCHAR2(2), 
	"CM_16_DANGER_SIGNS" VARCHAR2(2), 
	"CREATED_DATE" TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP, 
	"MODIFIED_DATE" TIMESTAMP (6), 
	"CM_LATITUDE" NUMBER, 
	"CM_LONGITUDE" NUMBER, 
	 PRIMARY KEY ("CONTROL_MEASURES_ID")
  USING INDEX  ENABLE
   ) ;

  CREATE TABLE "PTW_LV_EQUIPMENT_ISOLATION" 
   (	"ISOLATION_ID" NUMBER DEFAULT "PTW_PRO"."PTW_LV_EQUIPMENT_ISOLATION_SEQ"."NEXTVAL", 
	"PERMIT_ID" NUMBER NOT NULL ENABLE, 
	"ROW_NUMBER" NUMBER(1,0) NOT NULL ENABLE, 
	"EQUIPMENT_ISOLATED" VARCHAR2(200), 
	"MEANS_OF_ISOLATION" VARCHAR2(200), 
	"SAFETY_LOCK_NO" VARCHAR2(50), 
	"CREATED_DATE" TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP, 
	"MODIFIED_DATE" TIMESTAMP (6), 
	 PRIMARY KEY ("ISOLATION_ID")
  USING INDEX  ENABLE
   ) ;

  CREATE TABLE "PTW_LV_USER_ROLES" 
   (	"ROLE_ID" NUMBER GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"USERNAME" VARCHAR2(100) NOT NULL ENABLE, 
	"ROLE_NAME" VARCHAR2(50) NOT NULL ENABLE, 
	"APP_ID" NUMBER, 
	"IS_ACTIVE" VARCHAR2(1) DEFAULT 'Y', 
	"GRANTED_BY" VARCHAR2(100), 
	"GRANTED_DATE" TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP, 
	"MODIFIED_DATE" TIMESTAMP (6), 
	"MOBILE_NO" VARCHAR2(30), 
	"EMAIL_ADDRESS" VARCHAR2(100), 
	"FIRST_NAME" VARCHAR2(100), 
	"LAST_NAME" VARCHAR2(100), 
	 CONSTRAINT "CHK_PTW_LV_ROLE_NAME" CHECK (
        role_name IN (
            'ADMIN',
            'ADMIN_CONTRACT_SUPPORT',
            'AUTHORISER',
            'ENGINEER',
            'READONLY'
        )
    ) ENABLE, 
	 PRIMARY KEY ("ROLE_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "UQ_PTW_LV_USER_ROLE" UNIQUE ("USERNAME", "ROLE_NAME")
  USING INDEX  ENABLE
   ) ;

  CREATE TABLE "PTW_STAGE_LOCATIONS" 
   (	"PERMIT_ID" NUMBER, 
	"PERMIT_STAGE" VARCHAR2(100), 
	"LATITUDE" NUMBER, 
	"LONGITUDE" NUMBER, 
	"CREATED_DATE" DATE, 
	"CREATED_BY" VARCHAR2(100)
   ) ;

  ALTER TABLE "PTW_LV_CONTROL_MEASURES" ADD CONSTRAINT "FK_PTW_LV_CM_PERMIT" FOREIGN KEY ("PERMIT_ID")
	  REFERENCES "PTW_LV_PERMITS" ("PERMIT_ID") ON DELETE CASCADE ENABLE;

  CREATE INDEX "IDX_PTW_LV_CM_PERMIT" ON "PTW_LV_CONTROL_MEASURES" ("PERMIT_ID") 
  ;

  CREATE OR REPLACE EDITIONABLE TRIGGER "PTW_LV_CONTROL_MEASURES_STAGE_LOC_TRG" 
AFTER INSERT OR UPDATE ON ptw_pro.ptw_lv_control_measures
FOR EACH ROW
DECLARE
    v_changed BOOLEAN := FALSE;
BEGIN
    IF INSERTING THEN
       v_changed := TRUE;
    ELSIF UPDATING THEN
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
    END IF;
    IF v_changed THEN
        INSERT INTO ptw_pro.ptw_stage_locations (
            permit_id,
            permit_stage,
            latitude,
            longitude,
            created_date,
            created_by
        ) VALUES (
            :NEW.permit_id,
            'CONTROL_MEASURES',
            :NEW.cm_latitude,
            :NEW.cm_longitude,
            SYSDATE,
            NVL(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER)
        );
    END IF;
END ptw_lv_control_measures_stage_loc_trg;
/
ALTER TRIGGER "PTW_LV_CONTROL_MEASURES_STAGE_LOC_TRG" ENABLE;

  ALTER TABLE "PTW_LV_EQUIPMENT_ISOLATION" ADD CONSTRAINT "FK_PTW_LV_ISO_PERMIT" FOREIGN KEY ("PERMIT_ID")
	  REFERENCES "PTW_LV_PERMITS" ("PERMIT_ID") ON DELETE CASCADE ENABLE;

  CREATE INDEX "IDX_PTW_LV_ISO_PERMIT" ON "PTW_LV_EQUIPMENT_ISOLATION" ("PERMIT_ID") 
  ;

  CREATE OR REPLACE EDITIONABLE TRIGGER "PTW_LV_EQUIPMENT_ISOLATION_STAGE_LOC_TRG" 
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
ALTER TRIGGER "PTW_LV_EQUIPMENT_ISOLATION_STAGE_LOC_TRG" ENABLE;

  CREATE INDEX "IDX_PTW_LV_PERM_STATUS" ON "PTW_LV_PERMITS" ("WORKFLOW_STATUS") 
  ;

  CREATE OR REPLACE EDITIONABLE TRIGGER "PTW_LV_PERMITS_STAGE_LOC_TRG" 
AFTER INSERT OR UPDATE ON ptw_pro.ptw_lv_permits
FOR EACH ROW
DECLARE
    v_changed BOOLEAN := FALSE;
    l_latitude NUMBER;
    l_longitude NUMBER;
BEGIN
    IF INSERTING THEN
       v_changed := TRUE;
    ELSIF UPDATING THEN
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
    END IF;
    IF v_changed THEN
        INSERT INTO ptw_pro.ptw_stage_locations (
            permit_id,
            permit_stage,
            latitude,
            longitude,
            created_date,
            created_by
        ) VALUES (
            :NEW.permit_id,
            :NEW.current_step,
            l_latitude,
            l_longitude,
            SYSDATE,
            NVL(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER)
        );
    END IF;

END ptw_lv_permits_stage_loc_trg;
/
ALTER TRIGGER "PTW_LV_PERMITS_STAGE_LOC_TRG" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "TRG_PTW_LV_PERMIT_NUMBER" 
    BEFORE INSERT ON ptw_lv_permits
    FOR EACH ROW
BEGIN
    IF :NEW.permit_number IS NULL THEN
        :NEW.permit_number := 'PTW-LV/' ||
                              TO_CHAR(SYSDATE, 'YYYY') || '/' ||
                              LPAD(:NEW.permit_id, 5, '0');
    END IF;
END;
/
ALTER TRIGGER "TRG_PTW_LV_PERMIT_NUMBER" ENABLE;

  CREATE INDEX "IDX_PTW_LV_UR_USERNAME" ON "PTW_LV_USER_ROLES" ("USERNAME") 
  ;
create or replace FUNCTION ptw_lv_is_contract_support(p_username IN VARCHAR2)
RETURN VARCHAR2 IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM ptw_lv_user_roles
    WHERE UPPER(username) = UPPER(p_username)
      AND role_name = 'ADMIN_CONTRACT_SUPPORT'
      AND is_active = 'Y';
    RETURN CASE WHEN v_count > 0 THEN 'Y' ELSE 'N' END;
EXCEPTION
    WHEN OTHERS THEN RETURN 'N';
END;
/
























  CREATE INDEX "IDX_PTW_LV_ISO_PERMIT" ON "PTW_LV_EQUIPMENT_ISOLATION" ("PERMIT_ID") 
  ;

  CREATE INDEX "IDX_PTW_LV_PERM_STATUS" ON "PTW_LV_PERMITS" ("WORKFLOW_STATUS") 
  ;

  CREATE UNIQUE INDEX "SYS_C0030470" ON "PTW_LV_USER_ROLES" ("ROLE_ID") 
  ;

  CREATE INDEX "IDX_PTW_LV_UR_USERNAME" ON "PTW_LV_USER_ROLES" ("USERNAME") 
  ;

  CREATE UNIQUE INDEX "SYS_C0030441" ON "PTW_LV_CONTROL_MEASURES" ("CONTROL_MEASURES_ID") 
  ;

  CREATE INDEX "IDX_PTW_LV_PERM_CREATED" ON "PTW_LV_PERMITS" ("CREATED_DATE" DESC) 
  ;

  CREATE UNIQUE INDEX "UQ_PTW_LV_USER_ROLE" ON "PTW_LV_USER_ROLES" ("USERNAME", "ROLE_NAME") 
  ;

  CREATE INDEX "IDX_PTW_LV_CM_PERMIT" ON "PTW_LV_CONTROL_MEASURES" ("PERMIT_ID") 
  ;

  CREATE UNIQUE INDEX "SYS_C0030439" ON "PTW_LV_PERMITS" ("PERMIT_ID") 
  ;

  CREATE UNIQUE INDEX "SYS_C0030445" ON "PTW_LV_EQUIPMENT_ISOLATION" ("ISOLATION_ID") 
  ;

















































   CREATE SEQUENCE  "PTW_LV_CONTROL_MEASURES_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 41 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;

   CREATE SEQUENCE  "PTW_LV_EQUIPMENT_ISOLATION_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 60 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;

   CREATE SEQUENCE  "PTW_LV_PERMIT_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 29 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
Rem No synonym found to generate DDL.





















create or replace TRIGGER ptw_pro.ptw_lv_control_measures_stage_loc_trg
AFTER INSERT OR UPDATE ON ptw_pro.ptw_lv_control_measures
FOR EACH ROW
DECLARE
    v_changed BOOLEAN := FALSE;
BEGIN
    IF INSERTING THEN
       v_changed := TRUE;
    ELSIF UPDATING THEN
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
    END IF;
    IF v_changed THEN
        INSERT INTO ptw_pro.ptw_stage_locations (
            permit_id,
            permit_stage,
            latitude,
            longitude,
            created_date,
            created_by
        ) VALUES (
            :NEW.permit_id,
            'CONTROL_MEASURES',
            :NEW.cm_latitude,
            :NEW.cm_longitude,
            SYSDATE,
            NVL(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER)
        );
    END IF;
END ptw_lv_control_measures_stage_loc_trg;
/
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
create or replace TRIGGER ptw_pro.ptw_lv_permits_stage_loc_trg
AFTER INSERT OR UPDATE ON ptw_pro.ptw_lv_permits
FOR EACH ROW
DECLARE
    v_changed BOOLEAN := FALSE;
    l_latitude NUMBER;
    l_longitude NUMBER;
BEGIN
    IF INSERTING THEN
       v_changed := TRUE;
    ELSIF UPDATING THEN
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
    END IF;
    IF v_changed THEN
        INSERT INTO ptw_pro.ptw_stage_locations (
            permit_id,
            permit_stage,
            latitude,
            longitude,
            created_date,
            created_by
        ) VALUES (
            :NEW.permit_id,
            :NEW.current_step,
            l_latitude,
            l_longitude,
            SYSDATE,
            NVL(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER)
        );
    END IF;

END ptw_lv_permits_stage_loc_trg;
/
create or replace TRIGGER trg_ptw_lv_permit_number
    BEFORE INSERT ON ptw_lv_permits
    FOR EACH ROW
BEGIN
    IF :NEW.permit_number IS NULL THEN
        :NEW.permit_number := 'PTW-LV/' ||
                              TO_CHAR(SYSDATE, 'YYYY') || '/' ||
                              LPAD(:NEW.permit_id, 5, '0');
    END IF;
END;
/

  CREATE OR REPLACE EDITIONABLE TRIGGER "PTW_LV_CONTROL_MEASURES_STAGE_LOC_TRG" 
AFTER INSERT OR UPDATE ON ptw_pro.ptw_lv_control_measures
FOR EACH ROW
DECLARE
    v_changed BOOLEAN := FALSE;
BEGIN
    IF INSERTING THEN
       v_changed := TRUE;
    ELSIF UPDATING THEN
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
    END IF;
    IF v_changed THEN
        INSERT INTO ptw_pro.ptw_stage_locations (
            permit_id,
            permit_stage,
            latitude,
            longitude,
            created_date,
            created_by
        ) VALUES (
            :NEW.permit_id,
            'CONTROL_MEASURES',
            :NEW.cm_latitude,
            :NEW.cm_longitude,
            SYSDATE,
            NVL(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER)
        );
    END IF;
END ptw_lv_control_measures_stage_loc_trg;
/
ALTER TRIGGER "PTW_LV_CONTROL_MEASURES_STAGE_LOC_TRG" ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "PTW_LV_EQUIPMENT_ISOLATION_STAGE_LOC_TRG" 
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
ALTER TRIGGER "PTW_LV_EQUIPMENT_ISOLATION_STAGE_LOC_TRG" ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "PTW_LV_PERMITS_STAGE_LOC_TRG" 
AFTER INSERT OR UPDATE ON ptw_pro.ptw_lv_permits
FOR EACH ROW
DECLARE
    v_changed BOOLEAN := FALSE;
    l_latitude NUMBER;
    l_longitude NUMBER;
BEGIN
    IF INSERTING THEN
       v_changed := TRUE;
    ELSIF UPDATING THEN
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
    END IF;
    IF v_changed THEN
        INSERT INTO ptw_pro.ptw_stage_locations (
            permit_id,
            permit_stage,
            latitude,
            longitude,
            created_date,
            created_by
        ) VALUES (
            :NEW.permit_id,
            :NEW.current_step,
            l_latitude,
            l_longitude,
            SYSDATE,
            NVL(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER)
        );
    END IF;

END ptw_lv_permits_stage_loc_trg;
/
ALTER TRIGGER "PTW_LV_PERMITS_STAGE_LOC_TRG" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "TRG_PTW_LV_PERMIT_NUMBER" 
    BEFORE INSERT ON ptw_lv_permits
    FOR EACH ROW
BEGIN
    IF :NEW.permit_number IS NULL THEN
        :NEW.permit_number := 'PTW-LV/' ||
                              TO_CHAR(SYSDATE, 'YYYY') || '/' ||
                              LPAD(:NEW.permit_id, 5, '0');
    END IF;
END;
/
ALTER TRIGGER "TRG_PTW_LV_PERMIT_NUMBER" ENABLE;
Rem No database link found to generate DDL.


























  CREATE UNIQUE INDEX "SYS_C0030441" ON "PTW_LV_CONTROL_MEASURES" ("CONTROL_MEASURES_ID") 
  ;
  CREATE INDEX "IDX_PTW_LV_CM_PERMIT" ON "PTW_LV_CONTROL_MEASURES" ("PERMIT_ID") 
  ;

  CREATE OR REPLACE EDITIONABLE TRIGGER "PTW_LV_CONTROL_MEASURES_STAGE_LOC_TRG" 
AFTER INSERT OR UPDATE ON ptw_pro.ptw_lv_control_measures
FOR EACH ROW
DECLARE
    v_changed BOOLEAN := FALSE;
BEGIN
    IF INSERTING THEN
       v_changed := TRUE;
    ELSIF UPDATING THEN
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
    END IF;
    IF v_changed THEN
        INSERT INTO ptw_pro.ptw_stage_locations (
            permit_id,
            permit_stage,
            latitude,
            longitude,
            created_date,
            created_by
        ) VALUES (
            :NEW.permit_id,
            'CONTROL_MEASURES',
            :NEW.cm_latitude,
            :NEW.cm_longitude,
            SYSDATE,
            NVL(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER)
        );
    END IF;
END ptw_lv_control_measures_stage_loc_trg;
/
ALTER TRIGGER "PTW_LV_CONTROL_MEASURES_STAGE_LOC_TRG" ENABLE;

  CREATE UNIQUE INDEX "SYS_C0030445" ON "PTW_LV_EQUIPMENT_ISOLATION" ("ISOLATION_ID") 
  ;
  CREATE INDEX "IDX_PTW_LV_ISO_PERMIT" ON "PTW_LV_EQUIPMENT_ISOLATION" ("PERMIT_ID") 
  ;

  CREATE OR REPLACE EDITIONABLE TRIGGER "PTW_LV_EQUIPMENT_ISOLATION_STAGE_LOC_TRG" 
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
ALTER TRIGGER "PTW_LV_EQUIPMENT_ISOLATION_STAGE_LOC_TRG" ENABLE;

  CREATE UNIQUE INDEX "SYS_C0030439" ON "PTW_LV_PERMITS" ("PERMIT_ID") 
  ;
  CREATE INDEX "IDX_PTW_LV_PERM_STATUS" ON "PTW_LV_PERMITS" ("WORKFLOW_STATUS") 
  ;
  CREATE INDEX "IDX_PTW_LV_PERM_CREATED" ON "PTW_LV_PERMITS" ("CREATED_DATE" DESC) 
  ;

  CREATE OR REPLACE EDITIONABLE TRIGGER "PTW_LV_PERMITS_STAGE_LOC_TRG" 
AFTER INSERT OR UPDATE ON ptw_pro.ptw_lv_permits
FOR EACH ROW
DECLARE
    v_changed BOOLEAN := FALSE;
    l_latitude NUMBER;
    l_longitude NUMBER;
BEGIN
    IF INSERTING THEN
       v_changed := TRUE;
    ELSIF UPDATING THEN
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
    END IF;
    IF v_changed THEN
        INSERT INTO ptw_pro.ptw_stage_locations (
            permit_id,
            permit_stage,
            latitude,
            longitude,
            created_date,
            created_by
        ) VALUES (
            :NEW.permit_id,
            :NEW.current_step,
            l_latitude,
            l_longitude,
            SYSDATE,
            NVL(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER)
        );
    END IF;

END ptw_lv_permits_stage_loc_trg;
/
ALTER TRIGGER "PTW_LV_PERMITS_STAGE_LOC_TRG" ENABLE;
  CREATE OR REPLACE EDITIONABLE TRIGGER "TRG_PTW_LV_PERMIT_NUMBER" 
    BEFORE INSERT ON ptw_lv_permits
    FOR EACH ROW
BEGIN
    IF :NEW.permit_number IS NULL THEN
        :NEW.permit_number := 'PTW-LV/' ||
                              TO_CHAR(SYSDATE, 'YYYY') || '/' ||
                              LPAD(:NEW.permit_id, 5, '0');
    END IF;
END;
/
ALTER TRIGGER "TRG_PTW_LV_PERMIT_NUMBER" ENABLE;

  CREATE UNIQUE INDEX "SYS_C0030470" ON "PTW_LV_USER_ROLES" ("ROLE_ID") 
  ;
  CREATE UNIQUE INDEX "UQ_PTW_LV_USER_ROLE" ON "PTW_LV_USER_ROLES" ("USERNAME", "ROLE_NAME") 
  ;
  CREATE INDEX "IDX_PTW_LV_UR_USERNAME" ON "PTW_LV_USER_ROLES" ("USERNAME") 
  ;
