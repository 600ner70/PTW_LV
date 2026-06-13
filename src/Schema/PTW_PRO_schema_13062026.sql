

  CREATE TABLE "PTW_PRO"."PTW_LV_CONTROL_MEASURES" 
   (	"CONTROL_MEASURES_ID" NUMBER DEFAULT "PTW_PRO"."PTW_LV_CONTROL_MEASURES_SEQ"."NEXTVAL",  
	"PERMIT_ID" NUMBER NOT NULL ENABLE,  
	"CM_01_SITE_INDUCTION" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"CM_02_RISK_ASSESSMENT" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"CM_03_COMPETENCE_CHECKED" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"CM_04_HAZARDS_AWARE" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"CM_05_PPE_IDENTIFIED" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"CM_06_SOURCES_ISOLATED" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"CM_07_PROVED_DEAD" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"CM_08_STORED_ENERGY" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"CM_09_LIVE_COVERED" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"CM_10_NO_LIVE_WORK" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"CM_11_FIRST_AID" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"CM_12_BARRIERS" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"CM_13_ACCESS_EGRESS" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"CM_14_INSULATED_MATTING" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"CM_15_CALIBRATION_CURRENT" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"CM_16_DANGER_SIGNS" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"CREATED_DATE" TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,  
	"MODIFIED_DATE" TIMESTAMP (6),  
	"CM_LATITUDE" NUMBER,  
	"CM_LONGITUDE" NUMBER,  
	 PRIMARY KEY ("CONTROL_MEASURES_ID") 
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_PTW_LV_CM_PERMIT" FOREIGN KEY ("PERMIT_ID") 
	  REFERENCES "PTW_PRO"."PTW_LV_PERMITS" ("PERMIT_ID") ON DELETE CASCADE ENABLE 
   )  DEFAULT COLLATION "USING_NLS_COMP" ;

  CREATE TABLE "PTW_PRO"."PTW_LV_EQUIPMENT_ISOLATION" 
   (	"ISOLATION_ID" NUMBER DEFAULT "PTW_PRO"."PTW_LV_EQUIPMENT_ISOLATION_SEQ"."NEXTVAL",  
	"PERMIT_ID" NUMBER NOT NULL ENABLE,  
	"ROW_NUMBER" NUMBER(1,0) NOT NULL ENABLE,  
	"EQUIPMENT_ISOLATED" VARCHAR2(200) COLLATE "USING_NLS_COMP",  
	"MEANS_OF_ISOLATION" VARCHAR2(200) COLLATE "USING_NLS_COMP",  
	"SAFETY_LOCK_NO" VARCHAR2(50) COLLATE "USING_NLS_COMP",  
	"CREATED_DATE" TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,  
	"MODIFIED_DATE" TIMESTAMP (6),  
	 PRIMARY KEY ("ISOLATION_ID") 
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_PTW_LV_ISO_PERMIT" FOREIGN KEY ("PERMIT_ID") 
	  REFERENCES "PTW_PRO"."PTW_LV_PERMITS" ("PERMIT_ID") ON DELETE CASCADE ENABLE 
   )  DEFAULT COLLATION "USING_NLS_COMP" ;

  CREATE TABLE "PTW_PRO"."PTW_LV_MONITORING" 
   (	"MONITORING_ID" NUMBER DEFAULT ptw_pro.ptw_lv_monitoring_seq.NEXTVAL,  
	"PERMIT_ID" NUMBER NOT NULL ENABLE,  
	"CHK_PERMIT_ON_DISPLAY" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"CHK_PERMIT_TIME" VARCHAR2(10) COLLATE "USING_NLS_COMP",  
	"CHK_ACCESS_EGRESS" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"CHK_ACCESS_TIME" VARCHAR2(10) COLLATE "USING_NLS_COMP",  
	"CHK_WARNING_SIGNS" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"CHK_WARNING_TIME" VARCHAR2(10) COLLATE "USING_NLS_COMP",  
	"MS_CHECK1_DETAIL" VARCHAR2(1000) COLLATE "USING_NLS_COMP",  
	"MS_CHECK1_TIME" VARCHAR2(10) COLLATE "USING_NLS_COMP",  
	"MS_CHECK1_IN_ORDER" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"MS_CHECK1_COMMENTS" VARCHAR2(1000) COLLATE "USING_NLS_COMP",  
	"MS_CHECK2_DETAIL" VARCHAR2(1000) COLLATE "USING_NLS_COMP",  
	"MS_CHECK2_TIME" VARCHAR2(10) COLLATE "USING_NLS_COMP",  
	"MS_CHECK2_IN_ORDER" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"MS_CHECK2_COMMENTS" VARCHAR2(1000) COLLATE "USING_NLS_COMP",  
	"MS_CHECK3_DETAIL" VARCHAR2(1000) COLLATE "USING_NLS_COMP",  
	"MS_CHECK3_TIME" VARCHAR2(10) COLLATE "USING_NLS_COMP",  
	"MS_CHECK3_IN_ORDER" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"MS_CHECK3_COMMENTS" VARCHAR2(1000) COLLATE "USING_NLS_COMP",  
	"MONITOR_NAME" VARCHAR2(200) COLLATE "USING_NLS_COMP",  
	"MONITOR_SIGNATURE" BLOB,  
	"MONITOR_DATE" DATE,  
	"MONITOR_LATITUDE" NUMBER,  
	"MONITOR_LONGITUDE" NUMBER,  
	"CREATED_DATE" TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,  
	"CREATED_BY" VARCHAR2(100) COLLATE "USING_NLS_COMP",  
	"MODIFIED_DATE" TIMESTAMP (6),  
	"MODIFIED_BY" VARCHAR2(100) COLLATE "USING_NLS_COMP",  
	"PTW_TYPE" VARCHAR2(30) COLLATE "USING_NLS_COMP",  
	"MONITORING_STATUS" VARCHAR2(20) COLLATE "USING_NLS_COMP",  
	 PRIMARY KEY ("MONITORING_ID") 
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_PTW_LV_MON_PERMIT" FOREIGN KEY ("PERMIT_ID") 
	  REFERENCES "PTW_PRO"."PTW_LV_PERMITS" ("PERMIT_ID") ON DELETE CASCADE ENABLE 
   )  DEFAULT COLLATION "USING_NLS_COMP" ;

  CREATE TABLE "PTW_PRO"."PTW_LV_PERMITS" 
   (	"PERMIT_ID" NUMBER DEFAULT "PTW_PRO"."PTW_LV_PERMIT_SEQ"."NEXTVAL",  
	"PERMIT_NUMBER" VARCHAR2(50) COLLATE "USING_NLS_COMP",  
	"SAFETY_PROGRAMME_REF_NO" VARCHAR2(100) COLLATE "USING_NLS_COMP",  
	"ISOLATION_DIAGRAM_SERIAL_NO" VARCHAR2(100) COLLATE "USING_NLS_COMP",  
	"SITE_DETAILS" VARCHAR2(500) COLLATE "USING_NLS_COMP",  
	"AREA_OF_WORKS" VARCHAR2(500) COLLATE "USING_NLS_COMP",  
	"WORK_DESCRIPTION" VARCHAR2(2000) COLLATE "USING_NLS_COMP",  
	"PERSON_IN_CHARGE_NAME" VARCHAR2(200) COLLATE "USING_NLS_COMP",  
	"SUPERVISING_COMPANY" VARCHAR2(200) COLLATE "USING_NLS_COMP",  
	"OTHER_PERSONS_COUNT" NUMBER,  
	"CLIENT_PERMISSION_GRANTED" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"AFFECTS_IT_SYSTEMS" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"IT_PERMISSION_GRANTED" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"PPE_SAFETY_HELMET" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"PPE_ARC_FLASH" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"PPE_SAFETY_FOOTWEAR" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"PPE_HI_VIS" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"PPE_SAFETY_GOGGLES" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"PPE_INSULATING_GLOVES" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"PPE_FALL_RESTRAINT" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"PPE_FALL_ARREST" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"PPE_EAR_DEFENDERS" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"PPE_SAFETY_GLOVES" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"COMMENTS" VARCHAR2(4000) COLLATE "USING_NLS_COMP",  
	"AUTH_PERSON_NAME" VARCHAR2(200) COLLATE "USING_NLS_COMP",  
	"AUTH_PERSON_SIGNATURE" BLOB,  
	"AUTH_PERSON_MOBILE" VARCHAR2(50) COLLATE "USING_NLS_COMP",  
	"AUTH_DATETIME" DATE,  
	"AUTH_LATITUDE" NUMBER,  
	"AUTH_LONGITUDE" NUMBER,  
	"ACCEPT_PERSON_NAME" VARCHAR2(200) COLLATE "USING_NLS_COMP",  
	"ACCEPT_PERSON_SIGNATURE" BLOB,  
	"ACCEPT_PERSON_MOBILE" VARCHAR2(50) COLLATE "USING_NLS_COMP",  
	"ACCEPT_COMPANY" VARCHAR2(200) COLLATE "USING_NLS_COMP",  
	"ACCEPT_DATETIME" DATE,  
	"ACCEPT_LATITUDE" NUMBER,  
	"ACCEPT_LONGITUDE" NUMBER,  
	"CLEAR_WORK_COMPLETE" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"CLEAR_AREA_SAFE" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"CLEAR_PERSON_NAME" VARCHAR2(200) COLLATE "USING_NLS_COMP",  
	"CLEAR_PERSON_SIGNATURE" BLOB,  
	"CLEAR_PERSON_MOBILE" VARCHAR2(50) COLLATE "USING_NLS_COMP",  
	"CLEAR_COMPANY" VARCHAR2(200) COLLATE "USING_NLS_COMP",  
	"CLEAR_DATETIME" DATE,  
	"CLEAR_LATITUDE" NUMBER,  
	"CLEAR_LONGITUDE" NUMBER,  
	"CANCEL_WORK_COMPLETE" VARCHAR2(2) COLLATE "USING_NLS_COMP",  
	"CANCEL_PERSON_NAME" VARCHAR2(200) COLLATE "USING_NLS_COMP",  
	"CANCEL_PERSON_SIGNATURE" BLOB,  
	"CANCEL_DATETIME" DATE,  
	"CANCEL_LATITUDE" NUMBER,  
	"CANCEL_LONGITUDE" NUMBER,  
	"CURRENT_STEP" VARCHAR2(50) COLLATE "USING_NLS_COMP" DEFAULT 'SITE_WORK_DETAILS',  
	"WORKFLOW_STATUS" VARCHAR2(20) COLLATE "USING_NLS_COMP" DEFAULT 'IN_PROGRESS',  
	"COMPLETION_DATE" DATE,  
	"CREATED_DATE" TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,  
	"CREATED_BY" VARCHAR2(100) COLLATE "USING_NLS_COMP",  
	"MODIFIED_DATE" TIMESTAMP (6),  
	"MODIFIED_BY" VARCHAR2(100) COLLATE "USING_NLS_COMP",  
	"SITE_WORK_LATITUDE" NUMBER,  
	"SITE_WORK_LONGITUDE" NUMBER,  
	"PPE_LATITUDE" NUMBER,  
	"PPE_LONGITUDE" NUMBER,  
	"EQUIP_ISO_LATITUDE" NUMBER,  
	"EQUIP_ISO_LONGITUDE" NUMBER,  
	"SUSPENSION_REASON" VARCHAR2(400) COLLATE "USING_NLS_COMP",  
	"SUSPENDED_DATE" DATE,  
	"SUSPENDED_BY" VARCHAR2(100) COLLATE "USING_NLS_COMP",  
	"RESUMED_DATE" DATE,  
	"RESUMED_BY" VARCHAR2(100) COLLATE "USING_NLS_COMP",  
	"STARTED_LONGITUDE" NUMBER,  
	"STARTED_LATITUDE" NUMBER,  
	"STARTED_DATETIME" DATE,  
	"ENDED_DATETIME" DATE,  
	"PTW_TYPE" VARCHAR2(30) COLLATE "USING_NLS_COMP",  
	 PRIMARY KEY ("PERMIT_ID") 
  USING INDEX  ENABLE
   )  DEFAULT COLLATION "USING_NLS_COMP" ;

  CREATE TABLE "PTW_PRO"."PTW_LV_PERMIT_PHOTOS" 
   (	"PHOTO_ID" NUMBER DEFAULT ptw_pro.ptw_lv_photo_seq.NEXTVAL,  
	"PERMIT_ID" NUMBER NOT NULL ENABLE,  
	"PHOTO_DATA" BLOB NOT NULL ENABLE,  
	"MIME_TYPE" VARCHAR2(100) COLLATE "USING_NLS_COMP" DEFAULT 'image/jpeg',  
	"FILE_NAME" VARCHAR2(255) COLLATE "USING_NLS_COMP",  
	"PHOTO_CAPTION" VARCHAR2(500) COLLATE "USING_NLS_COMP",  
	"PHOTO_LATITUDE" NUMBER,  
	"PHOTO_LONGITUDE" NUMBER,  
	"UPLOADED_BY" VARCHAR2(100) COLLATE "USING_NLS_COMP",  
	"UPLOADED_DATE" TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,  
	 CONSTRAINT "PK_PTW_LV_PERMIT_PHOTOS" PRIMARY KEY ("PHOTO_ID") 
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_PTW_LV_PHOTOS_PERMIT" FOREIGN KEY ("PERMIT_ID") 
	  REFERENCES "PTW_PRO"."PTW_LV_PERMITS" ("PERMIT_ID") ON DELETE CASCADE ENABLE 
   )  DEFAULT COLLATION "USING_NLS_COMP" ;

  CREATE TABLE "PTW_PRO"."PTW_LV_ROLES" 
   (	"ROLE_ID" NUMBER GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE,  
	"ROLE_NAME" VARCHAR2(50) COLLATE "USING_NLS_COMP" NOT NULL ENABLE,  
	"ROLE_DESCRIPTION" VARCHAR2(500) COLLATE "USING_NLS_COMP",  
	"IS_ADMIN_ROLE" VARCHAR2(1) COLLATE "USING_NLS_COMP" DEFAULT 'N' NOT NULL ENABLE,  
	"DISPLAY_ORDER" NUMBER DEFAULT 99 NOT NULL ENABLE,  
	"IS_ACTIVE" VARCHAR2(1) COLLATE "USING_NLS_COMP" DEFAULT 'Y' NOT NULL ENABLE,  
	 CONSTRAINT "CHK_PTW_LV_ROLES_ADMIN" CHECK (is_admin_role IN ('Y', 'N')) ENABLE,  
	 CONSTRAINT "CHK_PTW_LV_ROLES_ACTIVE" CHECK (is_active IN ('Y', 'N')) ENABLE,  
	 CONSTRAINT "PK_PTW_LV_ROLES" PRIMARY KEY ("ROLE_ID") 
  USING INDEX  ENABLE, 
	 CONSTRAINT "UQ_PTW_LV_ROLES_NAME" UNIQUE ("ROLE_NAME") 
  USING INDEX  ENABLE
   )  DEFAULT COLLATION "USING_NLS_COMP" ;

  CREATE TABLE "PTW_PRO"."PTW_LV_USERS" 
   (	"USER_ID" NUMBER GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE,  
	"USERNAME" VARCHAR2(100) COLLATE "USING_NLS_COMP" NOT NULL ENABLE,  
	"FIRST_NAME" VARCHAR2(100) COLLATE "USING_NLS_COMP",  
	"LAST_NAME" VARCHAR2(100) COLLATE "USING_NLS_COMP",  
	"EMAIL_ADDRESS" VARCHAR2(200) COLLATE "USING_NLS_COMP",  
	"MOBILE_NO" VARCHAR2(30) COLLATE "USING_NLS_COMP",  
	"JOB_TITLE" VARCHAR2(100) COLLATE "USING_NLS_COMP",  
	"IS_ACTIVE" VARCHAR2(1) COLLATE "USING_NLS_COMP" DEFAULT 'Y' NOT NULL ENABLE,  
	"CREATED_DATE" TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,  
	"CREATED_BY" VARCHAR2(100) COLLATE "USING_NLS_COMP",  
	"MODIFIED_DATE" TIMESTAMP (6),  
	"MODIFIED_BY" VARCHAR2(100) COLLATE "USING_NLS_COMP",  
	 CONSTRAINT "CHK_PTW_LV_USERS_ACTIVE" CHECK (is_active IN ('Y', 'N')) ENABLE,  
	 CONSTRAINT "PK_PTW_LV_USERS" PRIMARY KEY ("USER_ID") 
  USING INDEX  ENABLE, 
	 CONSTRAINT "UQ_PTW_LV_USERS_USERNAME" UNIQUE ("USERNAME") 
  USING INDEX  ENABLE
   )  DEFAULT COLLATION "USING_NLS_COMP" ;

  CREATE TABLE "PTW_PRO"."PTW_LV_USER_ROLES_OLD" 
   (	"ROLE_ID" NUMBER GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE,  
	"USERNAME" VARCHAR2(100) COLLATE "USING_NLS_COMP" NOT NULL ENABLE,  
	"ROLE_NAME" VARCHAR2(50) COLLATE "USING_NLS_COMP" NOT NULL ENABLE,  
	"APP_ID" NUMBER,  
	"IS_ACTIVE" VARCHAR2(1) COLLATE "USING_NLS_COMP" DEFAULT 'Y',  
	"GRANTED_BY" VARCHAR2(100) COLLATE "USING_NLS_COMP",  
	"GRANTED_DATE" TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,  
	"MODIFIED_DATE" TIMESTAMP (6),  
	"MOBILE_NO" VARCHAR2(30) COLLATE "USING_NLS_COMP",  
	"EMAIL_ADDRESS" VARCHAR2(100) COLLATE "USING_NLS_COMP",  
	"FIRST_NAME" VARCHAR2(100) COLLATE "USING_NLS_COMP",  
	"LAST_NAME" VARCHAR2(100) COLLATE "USING_NLS_COMP",  
	"COMPANY_NAME" VARCHAR2(200) COLLATE "USING_NLS_COMP",  
	 CONSTRAINT "CHK_PTW_LV_ROLE_NAME" CHECK ( 
        role_name IN (
            'ADMIN',
            'ADMIN_CONTRACT_SUPPORT',
            'AUTHORISER',
            'ENGINEER',
            'READONLY'
        )
    ) DISABLE, 
	 PRIMARY KEY ("ROLE_ID") 
  USING INDEX  ENABLE, 
	 CONSTRAINT "UQ_PTW_LV_USER_ROLE" UNIQUE ("USERNAME", "ROLE_NAME") 
  USING INDEX  ENABLE
   )  DEFAULT COLLATION "USING_NLS_COMP" ;

  CREATE TABLE "PTW_PRO"."PTW_LV_USER_ROLE_ASSIGNMENTS" 
   (	"USER_ROLE_ID" NUMBER GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE,  
	"USER_ID" NUMBER NOT NULL ENABLE,  
	"ROLE_ID" NUMBER NOT NULL ENABLE,  
	"IS_ACTIVE" VARCHAR2(1) COLLATE "USING_NLS_COMP" DEFAULT 'Y' NOT NULL ENABLE,  
	"GRANTED_BY" VARCHAR2(100) COLLATE "USING_NLS_COMP",  
	"GRANTED_DATE" TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,  
	"MODIFIED_DATE" TIMESTAMP (6),  
	"MODIFIED_BY" VARCHAR2(100) COLLATE "USING_NLS_COMP",  
	 CONSTRAINT "CHK_PTW_UR_ACTIVE" CHECK (is_active IN ('Y', 'N')) ENABLE,  
	 CONSTRAINT "PK_PTW_LV_USER_ROLES" PRIMARY KEY ("USER_ROLE_ID") 
  USING INDEX  ENABLE, 
	 CONSTRAINT "UQ_PTW_USER_ROLE" UNIQUE ("USER_ID", "ROLE_ID") 
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_PTW_UR_USER" FOREIGN KEY ("USER_ID") 
	  REFERENCES "PTW_PRO"."PTW_LV_USERS" ("USER_ID") ENABLE,  
	 CONSTRAINT "FK_PTW_UR_ROLE" FOREIGN KEY ("ROLE_ID") 
	  REFERENCES "PTW_PRO"."PTW_LV_ROLES" ("ROLE_ID") ENABLE 
   )  DEFAULT COLLATION "USING_NLS_COMP" ;

  CREATE TABLE "PTW_PRO"."PTW_STAGE_LOCATIONS" 
   (	"PERMIT_ID" NUMBER,  
	"PERMIT_STAGE" VARCHAR2(100) COLLATE "USING_NLS_COMP",  
	"LATITUDE" NUMBER,  
	"LONGITUDE" NUMBER,  
	"CREATED_DATE" DATE,  
	"CREATED_BY" VARCHAR2(100) COLLATE "USING_NLS_COMP" 
   )  DEFAULT COLLATION "USING_NLS_COMP" ;

  CREATE TABLE "PTW_PRO"."PTW_TYPES" 
   (	"TYPE_ID" NUMBER DEFAULT "PTW_PRO"."PTW_TYPE_ID_SEQ"."NEXTVAL" NOT NULL ENABLE,  
	"PTW_TYPE" VARCHAR2(30) COLLATE "USING_NLS_COMP",  
	"TYPE_DESC" VARCHAR2(400) COLLATE "USING_NLS_COMP" NOT NULL ENABLE,  
	"CREATED_DATE" DATE NOT NULL ENABLE,  
	"CREATED_BY" VARCHAR2(30) COLLATE "USING_NLS_COMP",  
	"AVAILABLE" VARCHAR2(1) COLLATE "USING_NLS_COMP" DEFAULT 'Y' NOT NULL ENABLE,  
	 CONSTRAINT "PTW_TYPES_PK" PRIMARY KEY ("TYPE_ID") 
  USING INDEX  ENABLE
   )  DEFAULT COLLATION "USING_NLS_COMP" ;

  ALTER TABLE "PTW_PRO"."PTW_LV_CONTROL_MEASURES" MODIFY ("PERMIT_ID" NOT NULL ENABLE);
  ALTER TABLE "PTW_PRO"."PTW_LV_CONTROL_MEASURES" ADD PRIMARY KEY ("CONTROL_MEASURES_ID")
  USING INDEX  ENABLE;



  ALTER TABLE "PTW_PRO"."PTW_LV_EQUIPMENT_ISOLATION" MODIFY ("PERMIT_ID" NOT NULL ENABLE);
  ALTER TABLE "PTW_PRO"."PTW_LV_EQUIPMENT_ISOLATION" MODIFY ("ROW_NUMBER" NOT NULL ENABLE);
  ALTER TABLE "PTW_PRO"."PTW_LV_EQUIPMENT_ISOLATION" ADD PRIMARY KEY ("ISOLATION_ID")
  USING INDEX  ENABLE;



  ALTER TABLE "PTW_PRO"."PTW_LV_MONITORING" MODIFY ("PERMIT_ID" NOT NULL ENABLE);
  ALTER TABLE "PTW_PRO"."PTW_LV_MONITORING" ADD PRIMARY KEY ("MONITORING_ID")
  USING INDEX  ENABLE;



  ALTER TABLE "PTW_PRO"."PTW_LV_PERMITS" ADD PRIMARY KEY ("PERMIT_ID")
  USING INDEX  ENABLE;



  ALTER TABLE "PTW_PRO"."PTW_LV_PERMIT_PHOTOS" MODIFY ("PERMIT_ID" NOT NULL ENABLE);
  ALTER TABLE "PTW_PRO"."PTW_LV_PERMIT_PHOTOS" MODIFY ("PHOTO_DATA" NOT NULL ENABLE);
  ALTER TABLE "PTW_PRO"."PTW_LV_PERMIT_PHOTOS" ADD CONSTRAINT "PK_PTW_LV_PERMIT_PHOTOS" PRIMARY KEY ("PHOTO_ID")
  USING INDEX  ENABLE;



  ALTER TABLE "PTW_PRO"."PTW_LV_ROLES" MODIFY ("ROLE_ID" NOT NULL ENABLE);
  ALTER TABLE "PTW_PRO"."PTW_LV_ROLES" MODIFY ("ROLE_NAME" NOT NULL ENABLE);
  ALTER TABLE "PTW_PRO"."PTW_LV_ROLES" MODIFY ("IS_ADMIN_ROLE" NOT NULL ENABLE);
  ALTER TABLE "PTW_PRO"."PTW_LV_ROLES" MODIFY ("DISPLAY_ORDER" NOT NULL ENABLE);
  ALTER TABLE "PTW_PRO"."PTW_LV_ROLES" MODIFY ("IS_ACTIVE" NOT NULL ENABLE);
  ALTER TABLE "PTW_PRO"."PTW_LV_ROLES" ADD CONSTRAINT "CHK_PTW_LV_ROLES_ADMIN" CHECK (is_admin_role IN ('Y', 'N')) ENABLE;
  ALTER TABLE "PTW_PRO"."PTW_LV_ROLES" ADD CONSTRAINT "CHK_PTW_LV_ROLES_ACTIVE" CHECK (is_active IN ('Y', 'N')) ENABLE;
  ALTER TABLE "PTW_PRO"."PTW_LV_ROLES" ADD CONSTRAINT "PK_PTW_LV_ROLES" PRIMARY KEY ("ROLE_ID")
  USING INDEX  ENABLE;
  ALTER TABLE "PTW_PRO"."PTW_LV_ROLES" ADD CONSTRAINT "UQ_PTW_LV_ROLES_NAME" UNIQUE ("ROLE_NAME")
  USING INDEX  ENABLE;



  ALTER TABLE "PTW_PRO"."PTW_LV_USERS" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "PTW_PRO"."PTW_LV_USERS" MODIFY ("USERNAME" NOT NULL ENABLE);
  ALTER TABLE "PTW_PRO"."PTW_LV_USERS" MODIFY ("IS_ACTIVE" NOT NULL ENABLE);
  ALTER TABLE "PTW_PRO"."PTW_LV_USERS" ADD CONSTRAINT "CHK_PTW_LV_USERS_ACTIVE" CHECK (is_active IN ('Y', 'N')) ENABLE;
  ALTER TABLE "PTW_PRO"."PTW_LV_USERS" ADD CONSTRAINT "PK_PTW_LV_USERS" PRIMARY KEY ("USER_ID")
  USING INDEX  ENABLE;
  ALTER TABLE "PTW_PRO"."PTW_LV_USERS" ADD CONSTRAINT "UQ_PTW_LV_USERS_USERNAME" UNIQUE ("USERNAME")
  USING INDEX  ENABLE;



  ALTER TABLE "PTW_PRO"."PTW_LV_USER_ROLES_OLD" MODIFY ("ROLE_ID" NOT NULL ENABLE);
  ALTER TABLE "PTW_PRO"."PTW_LV_USER_ROLES_OLD" MODIFY ("USERNAME" NOT NULL ENABLE);
  ALTER TABLE "PTW_PRO"."PTW_LV_USER_ROLES_OLD" MODIFY ("ROLE_NAME" NOT NULL ENABLE);
  ALTER TABLE "PTW_PRO"."PTW_LV_USER_ROLES_OLD" ADD CONSTRAINT "CHK_PTW_LV_ROLE_NAME" CHECK (
        role_name IN (
            'ADMIN',
            'ADMIN_CONTRACT_SUPPORT',
            'AUTHORISER',
            'ENGINEER',
            'READONLY'
        )
    ) DISABLE;
  ALTER TABLE "PTW_PRO"."PTW_LV_USER_ROLES_OLD" ADD PRIMARY KEY ("ROLE_ID")
  USING INDEX  ENABLE;
  ALTER TABLE "PTW_PRO"."PTW_LV_USER_ROLES_OLD" ADD CONSTRAINT "UQ_PTW_LV_USER_ROLE" UNIQUE ("USERNAME", "ROLE_NAME")
  USING INDEX  ENABLE;



  ALTER TABLE "PTW_PRO"."PTW_LV_USER_ROLE_ASSIGNMENTS" MODIFY ("USER_ROLE_ID" NOT NULL ENABLE);
  ALTER TABLE "PTW_PRO"."PTW_LV_USER_ROLE_ASSIGNMENTS" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "PTW_PRO"."PTW_LV_USER_ROLE_ASSIGNMENTS" MODIFY ("ROLE_ID" NOT NULL ENABLE);
  ALTER TABLE "PTW_PRO"."PTW_LV_USER_ROLE_ASSIGNMENTS" MODIFY ("IS_ACTIVE" NOT NULL ENABLE);
  ALTER TABLE "PTW_PRO"."PTW_LV_USER_ROLE_ASSIGNMENTS" ADD CONSTRAINT "CHK_PTW_UR_ACTIVE" CHECK (is_active IN ('Y', 'N')) ENABLE;
  ALTER TABLE "PTW_PRO"."PTW_LV_USER_ROLE_ASSIGNMENTS" ADD CONSTRAINT "PK_PTW_LV_USER_ROLES" PRIMARY KEY ("USER_ROLE_ID")
  USING INDEX  ENABLE;
  ALTER TABLE "PTW_PRO"."PTW_LV_USER_ROLE_ASSIGNMENTS" ADD CONSTRAINT "UQ_PTW_USER_ROLE" UNIQUE ("USER_ID", "ROLE_ID")
  USING INDEX  ENABLE;



  ALTER TABLE "PTW_PRO"."PTW_TYPES" MODIFY ("CREATED_DATE" NOT NULL ENABLE);
  ALTER TABLE "PTW_PRO"."PTW_TYPES" MODIFY ("AVAILABLE" NOT NULL ENABLE);
  ALTER TABLE "PTW_PRO"."PTW_TYPES" MODIFY ("TYPE_ID" NOT NULL ENABLE);
  ALTER TABLE "PTW_PRO"."PTW_TYPES" MODIFY ("TYPE_DESC" NOT NULL ENABLE);
  ALTER TABLE "PTW_PRO"."PTW_TYPES" ADD CONSTRAINT "PTW_TYPES_PK" PRIMARY KEY ("TYPE_ID")
  USING INDEX  ENABLE;





  CREATE INDEX "PTW_PRO"."IDX_PTW_LV_CM_PERMIT" ON "PTW_PRO"."PTW_LV_CONTROL_MEASURES" ("PERMIT_ID") 
  ;

  CREATE INDEX "PTW_PRO"."IDX_PTW_LV_ISO_PERMIT" ON "PTW_PRO"."PTW_LV_EQUIPMENT_ISOLATION" ("PERMIT_ID") 
  ;

  CREATE INDEX "PTW_PRO"."IDX_PTW_LV_MON_PERMIT" ON "PTW_PRO"."PTW_LV_MONITORING" ("PERMIT_ID") 
  ;

  CREATE INDEX "PTW_PRO"."IDX_PTW_LV_PERM_CREATED" ON "PTW_PRO"."PTW_LV_PERMITS" ("CREATED_DATE" DESC) 
  ;

  CREATE INDEX "PTW_PRO"."IDX_PTW_LV_PERM_STATUS" ON "PTW_PRO"."PTW_LV_PERMITS" ("WORKFLOW_STATUS") 
  ;

  CREATE INDEX "PTW_PRO"."IDX_PTW_LV_PHOTOS_PERMIT" ON "PTW_PRO"."PTW_LV_PERMIT_PHOTOS" ("PERMIT_ID") 
  ;

  CREATE INDEX "PTW_PRO"."IDX_PTW_LV_UR_USERNAME" ON "PTW_PRO"."PTW_LV_USER_ROLES_OLD" ("USERNAME") 
  ;

  CREATE UNIQUE INDEX "PTW_PRO"."SYS_IL0000149023C00026$$" ON "PTW_PRO"."PTW_LV_PERMITS" 
  ;

  CREATE UNIQUE INDEX "PTW_PRO"."SYS_IL0000149023C00032$$" ON "PTW_PRO"."PTW_LV_PERMITS" 
  ;

  CREATE UNIQUE INDEX "PTW_PRO"."SYS_IL0000149023C00041$$" ON "PTW_PRO"."PTW_LV_PERMITS" 
  ;

  CREATE UNIQUE INDEX "PTW_PRO"."SYS_IL0000149023C00049$$" ON "PTW_PRO"."PTW_LV_PERMITS" 
  ;

  CREATE UNIQUE INDEX "PTW_PRO"."SYS_IL0000164554C00003$$" ON "PTW_PRO"."PTW_LV_PERMIT_PHOTOS" 
  ;

  CREATE UNIQUE INDEX "PTW_PRO"."SYS_IL0000166174C00022$$" ON "PTW_PRO"."PTW_LV_MONITORING" 
  ;


   CREATE SEQUENCE  "PTW_PRO"."PTW_LV_CONTROL_MEASURES_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 687 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;

   CREATE SEQUENCE  "PTW_PRO"."PTW_LV_EQUIPMENT_ISOLATION_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 426 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;

   CREATE SEQUENCE  "PTW_PRO"."PTW_LV_MONITORING_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 73 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;

   CREATE SEQUENCE  "PTW_PRO"."PTW_LV_PERMIT_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 217 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;

   CREATE SEQUENCE  "PTW_PRO"."PTW_LV_PHOTO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 188 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;

   CREATE SEQUENCE  "PTW_PRO"."PTW_TYPE_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 102 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;


  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PTW_PRO"."PTW_LV_ANALYTICS_V" ("PERMIT_ID", "PERMIT_NUMBER", "WORKFLOW_STATUS", "STATUS_DISPLAY", "STATUS_COLOUR", "COMPANY", "PERSON_IN_CHARGE", "SITE_DETAILS", "AREA_OF_WORKS", "WORK_DESCRIPTION", "CREATED_BY", "AUTH_PERSON_NAME", "CREATED_DATE_ONLY", "CREATED_DATE", "STARTED_DATETIME", "ENDED_DATETIME", "AUTH_DATETIME", "CLEAR_DATETIME", "CANCEL_DATETIME", "HAS_CLEARANCE", "HAS_CANCELLATION", "HAS_PHOTOS", "PTW_TYPE", "GROUP_DAILY", "GROUP_WEEKLY", "GROUP_MONTHLY") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT
    p.permit_id,
    p.permit_number,
    p.workflow_status,
    CASE p.workflow_status
        WHEN 'STARTED'     THEN 'Live'
        WHEN 'IN_PROGRESS' THEN 'In Progress'
        WHEN 'AUTHORISED'  THEN 'Authorised'
        WHEN 'COMPLETED'   THEN 'Completed'
        WHEN 'LAPSED'      THEN 'Lapsed'
        WHEN 'SUSPENDED'   THEN 'Suspended'
        WHEN 'CANCELLED'   THEN 'Cancelled'
        ELSE p.workflow_status
    END AS status_display,
    CASE p.workflow_status
        WHEN 'STARTED'     THEN '#28a745'
        WHEN 'IN_PROGRESS' THEN '#17a2b8'
        WHEN 'AUTHORISED'  THEN '#6c757d'
        WHEN 'COMPLETED'   THEN '#6f42c1'
        WHEN 'LAPSED'      THEN '#6c757d'
        WHEN 'SUSPENDED'   THEN '#fd7e14'
        WHEN 'CANCELLED'   THEN '#dc3545'
        ELSE '#6c757d'
    END AS status_colour,
    NVL(p.supervising_company,   'Unknown') AS company,
    NVL(p.person_in_charge_name, 'Unknown') AS person_in_charge,
    NVL(p.site_details,          'Unknown') AS site_details,
    p.area_of_works,
    p.work_description,
    p.created_by,
    p.auth_person_name,
    TRUNC(p.created_date)                   AS created_date_only,
    p.created_date,
    p.started_datetime,
    p.ended_datetime,
    p.auth_datetime,
    p.clear_datetime,
    p.cancel_datetime,
    -- Has additional data flags (used in IR columns)
    CASE WHEN p.clear_datetime  IS NOT NULL THEN 'Y' ELSE 'N' END AS has_clearance,
    CASE WHEN p.cancel_datetime IS NOT NULL THEN 'Y' ELSE 'N' END AS has_cancellation,
    CASE WHEN p.cancel_work_complete = 'N'  THEN 'Y' ELSE 'N' END AS has_photos,
    p.ptw_type,
    -- Pre-calculated grouping columns for line chart
    TRUNC(p.created_date, 'DD') AS group_daily,
    TRUNC(p.created_date, 'IW') AS group_weekly,
    TRUNC(p.created_date, 'MM') AS group_monthly
FROM ptw_pro.ptw_lv_permits p;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PTW_PRO"."PTW_LV_USER_ROLES_V" ("ROLE_ID", "USERNAME", "ROLE_NAME", "IS_ACTIVE", "USER_ACTIVE", "ROLE_ACTIVE", "FIRST_NAME", "LAST_NAME", "EMAIL_ADDRESS", "MOBILE_NO", "JOB_TITLE", "GRANTED_BY", "GRANTED_DATE", "MODIFIED_DATE", "USER_ID", "ROLE_REF_ID", "IS_ADMIN_ROLE", "ROLE_DESCRIPTION", "DISPLAY_ORDER") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT
    ur.user_role_id                                         AS role_id,
    u.username,
    r.role_name,
    CASE
        WHEN u.is_active = 'Y' AND ur.is_active = 'Y' THEN 'Y'
        ELSE 'N'
    END                                                     AS is_active,
    u.is_active                                             AS user_active,
    ur.is_active                                            AS role_active,
    u.first_name,
    u.last_name,
    u.email_address,
    u.mobile_no,
    u.job_title,
    ur.granted_by,
    ur.granted_date,
    ur.modified_date,
    u.user_id,
    r.role_id                                               AS role_ref_id,
    r.is_admin_role,
    r.role_description,
    r.display_order
FROM   ptw_pro.ptw_lv_user_role_assignments  ur
JOIN   ptw_pro.ptw_lv_users                  u   ON u.user_id = ur.user_id
JOIN   ptw_pro.ptw_lv_roles                  r   ON r.role_id = ur.role_id;


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
ALTER TRIGGER "PTW_PRO"."PTW_LV_CONTROL_MEASURES_STAGE_LOC_TRG" ENABLE;

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
            created_by
        ) VALUES (
            :NEW.permit_id,
            'MONITORING',
            l_latitude,
            l_longitude,
            SYSDATE,
            NVL(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER)
        );
    END IF;

END ptw_lv_monitoring_stage_loc_trg;
/
ALTER TRIGGER "PTW_PRO"."PTW_LV_MONITORING_STAGE_LOC_TRG" ENABLE;

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
ALTER TRIGGER "PTW_PRO"."PTW_LV_PERMITS_STAGE_LOC_TRG" ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "PTW_PRO"."TRG_PTW_LV_PERMIT_NUMBER" 
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
ALTER TRIGGER "PTW_PRO"."TRG_PTW_LV_PERMIT_NUMBER" ENABLE;


  CREATE OR REPLACE EDITIONABLE FUNCTION "PTW_PRO"."GENERATE_PTW_LV_PDF" (
    p_permit_id       IN NUMBER,
    p_include_history IN VARCHAR2 DEFAULT 'N'
) RETURN CLOB

IS
    v_permit     ptw_pro.ptw_lv_permits%ROWTYPE;
    v_cm         ptw_pro.ptw_lv_control_measures%ROWTYPE;
    v_html       CLOB;
    v_mon_count  NUMBER := 0;
    v_mon_num    NUMBER := 0;

    CURSOR c_isolation IS
        SELECT *
        FROM   ptw_pro.ptw_lv_equipment_isolation
        WHERE  permit_id = p_permit_id
        ORDER  BY row_number;

    CURSOR c_monitoring IS
        SELECT *
        FROM   ptw_pro.ptw_lv_monitoring
        WHERE  permit_id = p_permit_id
        ORDER  BY created_date ASC;

    -- ============================================================
    -- HELPER FUNCTIONS
    -- ============================================================

    FUNCTION safe_val (p_text VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN NVL(REPLACE(REPLACE(SUBSTR(p_text, 1, 4000), '<', '&lt;'), '>', '&gt;'), '-');
    END;

    FUNCTION safe_num (p_num NUMBER) RETURN VARCHAR2 IS
    BEGIN
        RETURN NVL(TO_CHAR(p_num), '-');
    END;

    FUNCTION get_yn (p_value VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE p_value
            WHEN 'Y'  THEN '<span class="status-badge status-yes">Yes</span>'
            WHEN 'N'  THEN '<span class="status-badge status-no">No</span>'
            WHEN 'NA' THEN '<span class="status-badge status-na">N/A</span>'
            ELSE '-'
        END;
    END;

    FUNCTION get_yn_label (p_value VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE p_value
            WHEN 'Y' THEN 'completed'
            WHEN 'N' THEN 'not complete'
            ELSE '(not recorded)'
        END;
    END;

    FUNCTION get_safe_label (p_value VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE p_value
            WHEN 'Y' THEN 'safe'
            WHEN 'N' THEN 'not safe'
            ELSE '(not recorded)'
        END;
    END;

    FUNCTION get_checked (p_value VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE WHEN p_value = 'Y' THEN '&#9745;' ELSE '&#9744;' END;
    END;

    FUNCTION get_cm_tick (p_value VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE p_value WHEN 'Y'  THEN '<span class="tick-mark">&#10003;</span>' ELSE '' END;
    END;

    FUNCTION get_cm_na (p_value VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE p_value WHEN 'NA' THEN '<span class="na-mark">N/A</span>' ELSE '' END;
    END;

    FUNCTION get_cm_no (p_value VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE p_value WHEN 'N'  THEN '<span class="no-mark">&#10007;</span>' ELSE '' END;
    END;

    FUNCTION fmt_datetime (p_date DATE) RETURN VARCHAR2 IS
    BEGIN
        RETURN NVL(TO_CHAR(p_date, 'DD-MON-YYYY HH24:MI'), '-');
    END;

    FUNCTION fmt_date (p_date DATE) RETURN VARCHAR2 IS
    BEGIN
        RETURN NVL(TO_CHAR(p_date, 'DD-MON-YYYY'), '-');
    END;

    FUNCTION get_signature_img (p_blob BLOB) RETURN CLOB IS
        v_base64 CLOB;
        v_result CLOB;
    BEGIN
        IF p_blob IS NULL OR DBMS_LOB.GETLENGTH(p_blob) = 0 THEN
            RETURN TO_CLOB('<p style="color:#999;font-style:italic;text-align:center;'
                        || 'margin:0;padding:15px 0;">No signature captured</p>');
        END IF;
        BEGIN
            v_base64 := APEX_WEB_SERVICE.BLOB2CLOBBASE64(p_blob);
            v_result := TO_CLOB('<img src="data:image/png;base64,');
            DBMS_LOB.APPEND(v_result, v_base64);
            DBMS_LOB.APPEND(v_result, TO_CLOB('" class="signature-image" alt="Signature" />'));
            RETURN v_result;
        EXCEPTION
            WHEN OTHERS THEN
                DECLARE
                    v_chunk    VARCHAR2(32767);
                    v_pos      NUMBER := 1;
                    v_length   NUMBER := DBMS_LOB.GETLENGTH(p_blob);
                    v_chunk_sz NUMBER := 12000;
                BEGIN
                    v_result := TO_CLOB('<img src="data:image/png;base64,');
                    WHILE v_pos <= v_length LOOP
                        v_chunk := UTL_RAW.CAST_TO_VARCHAR2(
                            UTL_ENCODE.BASE64_ENCODE(
                                DBMS_LOB.SUBSTR(p_blob, LEAST(v_chunk_sz, v_length - v_pos + 1), v_pos)
                            )
                        );
                        v_chunk := REPLACE(REPLACE(v_chunk, CHR(10), ''), CHR(13), '');
                        DBMS_LOB.APPEND(v_result, TO_CLOB(v_chunk));
                        v_pos := v_pos + v_chunk_sz;
                    END LOOP;
                    DBMS_LOB.APPEND(v_result, TO_CLOB('" class="signature-image" alt="Signature" />'));
                    RETURN v_result;
                END;
        END;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN TO_CLOB('<p style="color:#c0392b;font-style:italic;text-align:center;'
                        || 'margin:0;font-size:8pt;">Error loading signature</p>');
    END;

-- ============================================================
-- MAIN BODY
-- ============================================================
BEGIN
    IF p_permit_id IS NULL THEN
        RETURN '<div class="ptw-lv-report-container">'
            || '<h2 style="color:red;">No Permit Selected</h2></div>';
    END IF;

    BEGIN
        SELECT * INTO v_permit
        FROM   ptw_pro.ptw_lv_permits
        WHERE  permit_id = p_permit_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN '<div class="ptw-lv-report-container">'
                || '<h2 style="color:red;">Permit Not Found</h2>'
                || '<p>Permit ID: ' || p_permit_id || '</p></div>';
    END;

    BEGIN
        SELECT * INTO v_cm
        FROM   ptw_pro.ptw_lv_control_measures
        WHERE  permit_id = p_permit_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
    END;

    SELECT COUNT(*) INTO v_mon_count
    FROM   ptw_pro.ptw_lv_monitoring
    WHERE  permit_id = p_permit_id;

    -- ============================================================
    -- HTML DOCUMENT + CSS
    -- ============================================================
    v_html := '<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Permit to Work LV-Electrical - ' || safe_val(v_permit.permit_number) || '</title>
<style>
    @page { size: A4; margin: 12mm; }
    body {
        font-family: Arial, Helvetica, sans-serif;
        font-size: 9pt; color: #333; margin: 0; padding: 0;
    }
    .ptw-lv-report-container { max-width: 780px; margin: 0 auto; }

    .ptw-lv-header {
        background: #003366; color: white;
        padding: 12px 16px; border-radius: 4px 4px 0 0;
    }
    .ptw-lv-header h1 {
        margin: 0 0 6px 0; font-size: 13pt;
        letter-spacing: 0.5px; text-transform: uppercase;
    }
    .header-refs {
        display: flex; gap: 10px; font-size: 8pt;
        border-top: 1px solid rgba(255,255,255,0.3);
        padding-top: 6px; margin-top: 4px;
    }
    .header-refs div { flex: 1; }

    .ptw-lv-section { border: 1px solid #c0c0c0; border-top: none; }
    .ptw-lv-section-title {
        background: #003366; color: white;
        padding: 5px 12px; font-weight: 700; font-size: 8.5pt;
        text-transform: uppercase; letter-spacing: 0.3px;
    }
    .ptw-lv-section-subtitle {
        background: #dce6f0; color: #003366;
        padding: 4px 12px; font-weight: 700; font-size: 8pt;
        border-bottom: 1px solid #c0c0c0;
    }

    .ptw-lv-row {
        display: flex; padding: 4px 12px;
        border-bottom: 1px solid #eee; font-size: 8.5pt;
        align-items: flex-start;
    }
    .ptw-lv-row:last-child { border-bottom: none; }
    .ptw-lv-label { width: 42%; font-weight: 600; color: #333; padding-right: 8px; }
    .ptw-lv-value { width: 58%; }

    .ptw-lv-table { width: 100%; border-collapse: collapse; font-size: 8.5pt; }
    .ptw-lv-table th {
        background: #dce6f0; color: #003366;
        padding: 5px 8px; text-align: left; font-weight: 700;
        border: 1px solid #c0c0c0; font-size: 8pt;
    }
    .ptw-lv-table td {
        padding: 4px 8px; border: 1px solid #c0c0c0; vertical-align: middle;
    }
    .cm-number { width: 28px; text-align: center; font-weight: 700; background: #f5f5f5; }
    .cm-tick   { width: 55px; text-align: center; }

    .ppe-grid { display: flex; flex-wrap: wrap; padding: 6px 12px; }
    .ppe-item { width: 50%; padding: 2px 0; font-size: 8.5pt; }

    .status-badge {
        display: inline-block; padding: 1px 7px; border-radius: 8px;
        font-size: 7.5pt; font-weight: 700;
    }
    .status-yes { background: #d4edda; color: #155724; }
    .status-no  { background: #f8d7da; color: #721c24; }
    .status-na  { background: #e2e3e5; color: #383d41; }

    .tick-mark { color: #155724; font-weight: bold; font-size: 11pt; }
    .na-mark   { color: #666; font-style: italic; font-size: 8pt; }
    .no-mark   { color: #dc3545; font-weight: 700; font-size: 11pt; }

    .declaration-box {
        padding: 7px 12px; background: #f8f9fa;
        border-left: 3px solid #003366;
        font-size: 8pt; line-height: 1.6; margin: 0; font-style: italic;
    }

    .signature-box {
        border: 1px solid #bbb; min-height: 55px;
        padding: 4px; text-align: center;
        background: #fff; margin: 3px 0;
    }
    .signature-image { max-width: 100%; max-height: 75px; display: block; margin: 0 auto; }

    .page-break { page-break-before: always; }

    .footer {
        border-top: 1px solid #ddd; margin-top: 6px;
        padding: 6px 12px; font-size: 7pt; color: #888; text-align: center;
    }

    /* ── Permit History section ─────────────────────────────── */    
    .history-section {
        border: 1px solid #c0c0c0;
        border-top: none;
        margin-top: 0;
    }
    .history-section .ptw-lv-section-title {
        background: #1a3a5c;
    }
    .history-table {
        width: 100%; border-collapse: collapse; font-size: 8.5pt;
    }
    .history-table th {
        background: #dce6f0; color: #003366;
        padding: 5px 8px; text-align: left; font-weight: 700;
        border: 1px solid #c0c0c0; font-size: 8pt;
    }
    .history-table td {
        padding: 5px 8px; border: 1px solid #c0c0c0;
        vertical-align: middle;
    }
    .history-table tr:nth-child(even) td {
        background: #f7f9fc;
    }
    .history-step-badge {
        display: inline-block;
        background: #003366; color: #fff;
        padding: 2px 8px; border-radius: 10px;
        font-size: 7.5pt; font-weight: 700;
        white-space: nowrap;
    }
    .history-no-data {
        padding: 12px; font-style: italic;
        color: #888; font-size: 8pt; text-align: center;
    }

    @media print {
        body { font-size: 8pt; }
        .ptw-lv-section { page-break-inside: avoid; }
        .history-section { page-break-inside: avoid; }
    }
</style>
</head>
<body>
<div class="ptw-lv-report-container">';

    -- ============================================================
    -- PAGE 1 HEADER
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-header">
        <h1>Permit to Work &mdash; LV Electrical</h1>
        <div class="header-refs">
            <div>Safety Programme Reference No.:<br>
                <strong>' || safe_val(v_permit.safety_programme_ref_no) || '</strong></div>
            <div>Isolation &amp; Earthing Diagram Serial No.:<br>
                <strong>' || safe_val(v_permit.isolation_diagram_serial_no) || '</strong></div>
            <div>Permit to Work No.:<br>
                <strong>' || safe_val(v_permit.permit_number) || '</strong></div>
        </div>
    </div>';

    -- ============================================================
    -- SITE & WORK DETAILS
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Site &amp; Work Details</div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Site details and area of works:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.site_details) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Description of work activity:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.work_description) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Name of Person in Charge:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.person_in_charge_name) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Company responsible for supervising the works:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.supervising_company) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Number of other persons working under this Permit:</div>
            <div class="ptw-lv-value">' || safe_num(v_permit.other_persons_count) || '</div>
        </div>
    </div>';

    -- ============================================================
    -- CONTROL MEASURES (16 items)
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Control Measures</div>
        <table class="ptw-lv-table">
            <thead>
                <tr>
                    <th class="cm-number">No.</th>
                    <th>Control Measure</th>
                    <th class="cm-tick">&#10003; Yes</th>
                    <th class="cm-tick">&#10007; No</th>
                    <th class="cm-tick">N/A</th>
                </tr>
            </thead>
            <tbody>
                <tr><td class="cm-number">1</td>
                    <td>All persons working under this PTW have received and signed, as understood,
                        a suitable site induction?</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_01_site_induction) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_01_site_induction)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_01_site_induction)   || '</td></tr>
                <tr><td class="cm-number">2</td>
                    <td>A suitable and sufficient written risk assessment and method statement for
                        these works, which has already been understood by all persons working under
                        this permit is in place and has been reviewed at the point of works by the
                        person controlling the works. This must include the provision of an emergency
                        evacuation plan.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_02_risk_assessment) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_02_risk_assessment)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_02_risk_assessment)   || '</td></tr>
                <tr><td class="cm-number">3</td>
                    <td>The competence of the people working under the permit has been checked.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_03_competence_checked) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_03_competence_checked)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_03_competence_checked)   || '</td></tr>
                <tr><td class="cm-number">4</td>
                    <td>The person in charge of the works must be made aware of all hazards.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_04_hazards_aware) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_04_hazards_aware)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_04_hazards_aware)   || '</td></tr>
                <tr><td class="cm-number">5</td>
                    <td>Where the use of PPE is identified as a control measure, equipment is in
                        good order.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_05_ppe_identified) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_05_ppe_identified)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_05_ppe_identified)   || '</td></tr>
                <tr><td class="cm-number">6</td>
                    <td>All sources of supply have been isolated, locked off and caution signs
                        fitted.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_06_sources_isolated) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_06_sources_isolated)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_06_sources_isolated)   || '</td></tr>
                <tr><td class="cm-number">7</td>
                    <td>Confirm that all isolated sources of supply have been proved dead using an
                        approved tester and proving unit, where this is not possible the AP must
                        confirm dead at the point of work after the issue of this Permit.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_07_proved_dead) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_07_proved_dead)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_07_proved_dead)   || '</td></tr>
                <tr><td class="cm-number">8</td>
                    <td>All systems checked to ensure any stored energy has been dissipated.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_08_stored_energy) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_08_stored_energy)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_08_stored_energy)   || '</td></tr>
                <tr><td class="cm-number">9</td>
                    <td>Live equipment covered in suitable insulating material, no exposed live
                        parts.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_09_live_covered) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_09_live_covered)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_09_live_covered)   || '</td></tr>
                <tr><td class="cm-number">10</td>
                    <td>Sufficient measures in place to ensure no live equipment is worked on.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_10_no_live_work) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_10_no_live_work)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_10_no_live_work)   || '</td></tr>
                <tr><td class="cm-number">11</td>
                    <td>First aid facilities available.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_11_first_aid) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_11_first_aid)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_11_first_aid)   || '</td></tr>
                <tr><td class="cm-number">12</td>
                    <td>Suitable barriers used to clearly identify the working area.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_12_barriers) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_12_barriers)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_12_barriers)   || '</td></tr>
                <tr><td class="cm-number">13</td>
                    <td>Unrestricted access and egress to the working area.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_13_access_egress) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_13_access_egress)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_13_access_egress)   || '</td></tr>
                <tr><td class="cm-number">14</td>
                    <td>Suitable insulated matting available.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_14_insulated_matting) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_14_insulated_matting)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_14_insulated_matting)   || '</td></tr>
                <tr><td class="cm-number">15</td>
                    <td>Confirm that the calibration of the test equipment is current.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_15_calibration_current) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_15_calibration_current)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_15_calibration_current)   || '</td></tr>
                <tr><td class="cm-number">16</td>
                    <td>Danger signs have been applied to adjacent live equipment.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_16_danger_signs) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_16_danger_signs)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_16_danger_signs)   || '</td></tr>
            </tbody>
        </table>
    </div>';

    -- ============================================================
    -- PPE REQUIREMENTS
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Identify Essential PPE Required To Be Worn</div>
        <div style="font-size:7.5pt;color:#555;padding:4px 12px;font-style:italic;
                    border-bottom:1px solid #eee;">
            This list is not exhaustive &mdash; please refer to risk assessment.
            This Permit MUST be issued for the SHORTEST reasonable period of TIME
            (never usually longer than 12 Hours).
        </div>
        <table style="width:100%;border-collapse:collapse;font-size:8.5pt;">
            <tr>
                <td style="width:50%;padding:3px 12px;">'
                    || get_checked(v_permit.ppe_safety_helmet)     || ' Safety Helmet (Hard Hat)</td>
                <td style="width:50%;padding:3px 12px;">'
                    || get_checked(v_permit.ppe_arc_flash)         || ' Arc Flash PPE</td>
            </tr>
            <tr>
                <td style="padding:3px 12px;">'
                    || get_checked(v_permit.ppe_safety_footwear)   || ' Safety Footwear</td>
                <td style="padding:3px 12px;">'
                    || get_checked(v_permit.ppe_hi_vis)            || ' Hi-Vis Vest/Jkt</td>
            </tr>
            <tr>
                <td style="padding:3px 12px;">'
                    || get_checked(v_permit.ppe_safety_goggles)    || ' Safety Goggles</td>
                <td style="padding:3px 12px;">'
                    || get_checked(v_permit.ppe_insulating_gloves) || ' Electrical Insulating Gloves</td>
            </tr>
            <tr>
                <td style="padding:3px 12px;">'
                    || get_checked(v_permit.ppe_fall_restraint)    || ' Fall Restraint Harness</td>
                <td style="padding:3px 12px;">'
                    || get_checked(v_permit.ppe_fall_arrest)       || ' Fall Arrest Harness</td>
            </tr>
            <tr>
                <td style="padding:3px 12px;">'
                    || get_checked(v_permit.ppe_ear_defenders)     || ' Ear Defenders/Plugs</td>
                <td style="padding:3px 12px;">'
                    || get_checked(v_permit.ppe_safety_gloves)     || ' Safety Gloves</td>
            </tr>
        </table>
    </div>';

    -- ============================================================
    -- EQUIPMENT ISOLATION TABLE
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Equipment Isolation</div>
        <table class="ptw-lv-table">
            <thead>
                <tr>
                    <th style="width:28px;">No.</th>
                    <th>Equipment isolated</th>
                    <th>Means of isolation</th>
                    <th style="width:95px;">Safety lock no.</th>
                </tr>
            </thead>
            <tbody>';

    FOR iso IN c_isolation LOOP
        v_html := v_html || '
                <tr>
                    <td style="text-align:center;font-weight:700;">' || iso.row_number         || '</td>
                    <td>'                                                                        || safe_val(iso.equipment_isolated) || '</td>
                    <td>'                                                                        || safe_val(iso.means_of_isolation)  || '</td>
                    <td>'                                                                        || safe_val(iso.safety_lock_no)      || '</td>
                </tr>';
    END LOOP;

    -- Fill any unused isolation rows up to 4
    FOR i IN (
        SELECT LEVEL AS rn FROM DUAL CONNECT BY LEVEL <= 4
        MINUS
        SELECT row_number
        FROM   ptw_pro.ptw_lv_equipment_isolation
        WHERE  permit_id = p_permit_id
    ) LOOP
        v_html := v_html || '
                <tr>
                    <td style="text-align:center;font-weight:700;">' || i.rn || '</td>
                    <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
                </tr>';
    END LOOP;

    v_html := v_html || '
            </tbody>
        </table>
    </div>';

    -- ============================================================
    -- AUTHORISATION
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Authorisation of this Permit to Work</div>
        <div class="declaration-box">
            I have reviewed all aspects of the task/activity and I am satisfied with the
            arrangements as detailed within the relevant risk assessment and method statement
            that have been put in place and certify that this activity detailed is authorised
            to proceed.
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Authorised Person:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.auth_person_name)   || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Mobile Tel No.:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.auth_person_mobile) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">FROM:</div>
            <div class="ptw-lv-value">' || fmt_datetime(v_permit.started_datetime) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">TO:</div>
            <div class="ptw-lv-value">' || fmt_datetime(v_permit.ended_datetime) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Signature:</div>
            <div class="ptw-lv-value">
                <div class="signature-box">' || get_signature_img(v_permit.auth_person_signature) || '</div>
            </div>
        </div>
    </div>';

    -- ============================================================
    -- ACCEPTANCE
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Acceptance of this Permit to Work</div>
        <div class="declaration-box">
            I certify that I am competent to supervise and undertake the works detailed within
            this Permit to Work and have read and fully understand the documentation associated
            with this work activity.
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Person in Charge of Works:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.accept_person_name)   || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Mobile Tel. No.:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.accept_person_mobile) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Company:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.accept_company) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Date &amp; Time:</div>
            <div class="ptw-lv-value">' || fmt_datetime(v_permit.accept_datetime) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Signature:</div>
            <div class="ptw-lv-value">
                <div class="signature-box">' || get_signature_img(v_permit.accept_person_signature) || '</div>
            </div>
        </div>
    </div>';

    -- ============================================================
    -- CLEARANCE
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Clearance of this Permit to Work</div>
        <div class="declaration-box">
            I certify that the works detailed within this Permit to Work are
            <strong>' || get_yn_label(v_permit.clear_work_complete) || '</strong>.
            The area [has]/[has not] been left in a safe and tidy condition and all waste has
            been removed from site. It is <strong>' || get_safe_label(v_permit.clear_area_safe) || '</strong>
            to reinstate the plant and equipment.
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Works complete:</div>
            <div class="ptw-lv-value">' || get_yn(v_permit.clear_work_complete) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Area left safe and tidy:</div>
            <div class="ptw-lv-value">' ||
                CASE v_permit.clear_area_safe
                    WHEN 'Y' THEN '<span class="status-badge status-yes">Yes</span>'
                    WHEN 'N' THEN '<span class="status-badge status-no">No</span>'
                    ELSE '-'
                END || '
            </div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Person in Charge of Works:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.clear_person_name)   || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Mobile Tel. No.:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.clear_person_mobile) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Company:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.clear_company) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Date &amp; Time:</div>
            <div class="ptw-lv-value">' || fmt_datetime(v_permit.clear_datetime) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Signature:</div>
            <div class="ptw-lv-value">
                <div class="signature-box">' || get_signature_img(v_permit.clear_person_signature) || '</div>
            </div>
        </div>
    </div>';

    -- ============================================================
    -- CANCELLATION
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Cancellation of this Permit to Work</div>
        <div class="declaration-box">
            I confirm that these works have been
            <strong>' || get_yn_label(v_permit.cancel_work_complete) || '</strong>
            and that I have checked that the place of work has been left in a safe and tidy
            condition. Where the work is not complete a further Permit may be required.
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Works complete:</div>
            <div class="ptw-lv-value">' || get_yn(v_permit.cancel_work_complete) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Authorised Person:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.cancel_person_name) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Date &amp; Time:</div>
            <div class="ptw-lv-value">' || fmt_datetime(v_permit.cancel_datetime) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Signature:</div>
            <div class="ptw-lv-value">
                <div class="signature-box">' || get_signature_img(v_permit.cancel_person_signature) || '</div>
            </div>
        </div>
    </div>';

    -- ============================================================
    -- PAGE 1 FOOTER
    -- ============================================================
    v_html := v_html || '
    <div class="footer">
        During the works the Original copy shall be retained by the &lsquo;Authorised Person&rsquo;
        and the copy shall be retained by the &lsquo;Person in Charge&rsquo; of the work and must
        have it available at all times for inspection. On completion of the works, the copy must be
        returned and both parts are signed when cancelling this Permit. Retention period 5 years.
        <br>Generated: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI') ||
        ' &nbsp;|&nbsp; Permit: ' || safe_val(v_permit.permit_number) || '
    </div>';

    -- ============================================================
    -- PAGE 2+: LOW VOLTAGE MONITORING
    -- One printed page per monitoring record, in date order.
    -- ============================================================
    FOR v_mon IN c_monitoring LOOP
        v_mon_num := v_mon_num + 1;

        v_html := v_html || '<div class="page-break"></div>'
                         || '<div class="ptw-lv-report-container">';

        v_html := v_html || '<div class="ptw-lv-header">'
                         || '<h1>Low Voltage Monitoring</h1>'
                         || '<div class="header-refs">';
        v_html := v_html || '<div>Permit No.: <strong>'
                         || safe_val(v_permit.permit_number) || '</strong></div>';
        v_html := v_html || '<div>Check: <strong>'
                         || TO_CHAR(v_mon_num) || ' of ' || TO_CHAR(v_mon_count)
                         || '</strong></div>';
        v_html := v_html || '<div>Date: <strong>'
                         || NVL(TO_CHAR(v_mon.monitor_date, 'DD-MON-YYYY'), '-')
                         || '</strong></div>';
        v_html := v_html || '</div></div>';

        v_html := v_html || '<div class="ptw-lv-section">'
                         || '<div class="declaration-box" style="padding:6px 12px;">'
                         || 'The following checks are to be undertaken by the issuer of this permit.'
                         || '</div></div>';

        v_html := v_html || '<div class="ptw-lv-section">'
                         || '<div class="ptw-lv-section-title">Site Monitoring Checks</div>'
                         || '<table class="ptw-lv-table"><thead><tr>'
                         || '<th>Check</th>'
                         || '<th style="width:55px;text-align:center;">Yes</th>'
                         || '<th style="width:55px;text-align:center;">No</th>'
                         || '<th style="width:55px;text-align:center;">N/A</th>'
                         || '<th style="width:90px;">Time of check</th>'
                         || '</tr></thead><tbody>';

        -- Row 1: Is Permit on display?
        v_html := v_html || '<tr><td>Is Permit on display?</td>'
            || '<td style="text-align:center;">' || CASE v_mon.chk_permit_on_display WHEN 'Y'  THEN '<span class="tick-mark">&#10003;</span>' ELSE '' END || '</td>'
            || '<td style="text-align:center;">' || CASE v_mon.chk_permit_on_display WHEN 'N'  THEN '<span class="tick-mark" style="color:#c0392b;">&#10003;</span>' ELSE '' END || '</td>'
            || '<td style="text-align:center;">' || CASE v_mon.chk_permit_on_display WHEN 'NA' THEN '<span class="na-mark">N/A</span>' ELSE '' END || '</td>'
            || '<td>' || NVL(v_mon.chk_permit_time, '') || '</td></tr>';

        -- Row 2: Is Access / Egress clear?
        v_html := v_html || '<tr><td>Is Access / Egress clear?</td>'
            || '<td style="text-align:center;">' || CASE v_mon.chk_access_egress WHEN 'Y'  THEN '<span class="tick-mark">&#10003;</span>' ELSE '' END || '</td>'
            || '<td style="text-align:center;">' || CASE v_mon.chk_access_egress WHEN 'N'  THEN '<span class="tick-mark" style="color:#c0392b;">&#10003;</span>' ELSE '' END || '</td>'
            || '<td style="text-align:center;">' || CASE v_mon.chk_access_egress WHEN 'NA' THEN '<span class="na-mark">N/A</span>' ELSE '' END || '</td>'
            || '<td>' || NVL(v_mon.chk_access_time, '') || '</td></tr>';

        -- Row 3: Are warning signs in place?
        v_html := v_html || '<tr><td>Are warning signs in place?</td>'
            || '<td style="text-align:center;">' || CASE v_mon.chk_warning_signs WHEN 'Y'  THEN '<span class="tick-mark">&#10003;</span>' ELSE '' END || '</td>'
            || '<td style="text-align:center;">' || CASE v_mon.chk_warning_signs WHEN 'N'  THEN '<span class="tick-mark" style="color:#c0392b;">&#10003;</span>' ELSE '' END || '</td>'
            || '<td style="text-align:center;">' || CASE v_mon.chk_warning_signs WHEN 'NA' THEN '<span class="na-mark">N/A</span>' ELSE '' END || '</td>'
            || '<td>' || NVL(v_mon.chk_warning_time, '') || '</td></tr>';

        v_html := v_html || '</tbody></table></div>';

        v_html := v_html || '<div class="ptw-lv-section">'
                         || '<div class="ptw-lv-section-title">'
                         || 'Checks Against Work Processes &amp; Method Statement</div>'
                         || '<div style="font-size:7.5pt;color:#555;padding:5px 12px;'
                         || 'font-style:italic;border-bottom:1px solid #eee;">'
                         || 'Considering the work involved under this Permit, on reading the method '
                         || 'statement detail below an element you wish to check for compliance. '
                         || 'Note: the minimum is one check per task carried out under each Permit, '
                         || 'but more are recommended dependent on activity complexity.</div>'
                         || '<table class="ptw-lv-table"><thead><tr>'
                         || '<th style="width:50%;">Column A &mdash; Detail the item or part of the '
                         || 'method statement you decide to check</th>'
                         || '<th style="width:50%;">Column B &mdash; Detail if all works are being '
                         || 'carried out correctly, or what was found to be non-conforming</th>'
                         || '</tr></thead><tbody>';

        -- Check 1 (always shown)
        v_html := v_html || '
                <tr>
                    <td style="vertical-align:top;">
                        <div style="font-size:8pt;font-weight:700;margin-bottom:3px;">
                            Check 1) Detail of check made:</div>
                        <div>' || NVL(safe_val(v_mon.ms_check1_detail), '&nbsp;') || '</div>
                        <div style="margin-top:6px;font-size:8pt;">
                            <strong>Enter time of check:</strong> '
                            || NVL(v_mon.ms_check1_time, '-') || '</div>
                    </td>
                    <td style="vertical-align:top;">
                        <div><strong>All in order:</strong>&nbsp;&nbsp;' ||
                        CASE v_mon.ms_check1_in_order
                            WHEN 'Y' THEN 'YES &nbsp;/&nbsp; <span style="color:#aaa;">NO</span>'
                            WHEN 'N' THEN '<span style="color:#aaa;">YES</span> &nbsp;/&nbsp; NO'
                            ELSE 'YES &nbsp;/&nbsp; NO'
                        END || '</div>
                        <div style="margin-top:6px;font-size:8pt;"><strong>Comments:</strong><br>'
                            || NVL(safe_val(v_mon.ms_check1_comments), '&nbsp;') || '</div>
                    </td>
                </tr>';

        -- Check 2 (only if data entered)
        IF v_mon.ms_check2_detail IS NOT NULL THEN
            v_html := v_html || '
                <tr>
                    <td style="vertical-align:top;">
                        <div style="font-size:8pt;font-weight:700;margin-bottom:3px;">
                            Check 2) Detail of check made:</div>
                        <div>' || safe_val(v_mon.ms_check2_detail) || '</div>
                        <div style="margin-top:6px;font-size:8pt;">
                            <strong>Enter time of check:</strong> '
                            || NVL(v_mon.ms_check2_time, '-') || '</div>
                    </td>
                    <td style="vertical-align:top;">
                        <div><strong>All in order:</strong>&nbsp;&nbsp;' ||
                        CASE v_mon.ms_check2_in_order
                            WHEN 'Y' THEN 'YES &nbsp;/&nbsp; <span style="color:#aaa;">NO</span>'
                            WHEN 'N' THEN '<span style="color:#aaa;">YES</span> &nbsp;/&nbsp; NO'
                            ELSE 'YES &nbsp;/&nbsp; NO'
                        END || '</div>
                        <div style="margin-top:6px;font-size:8pt;"><strong>Comments:</strong><br>'
                            || NVL(safe_val(v_mon.ms_check2_comments), '&nbsp;') || '</div>
                    </td>
                </tr>';
        END IF;

        -- Check 3 (only if data entered)
        IF v_mon.ms_check3_detail IS NOT NULL THEN
            v_html := v_html || '
                <tr>
                    <td style="vertical-align:top;">
                        <div style="font-size:8pt;font-weight:700;margin-bottom:3px;">
                            Check 3) Detail of check made:</div>
                        <div>' || safe_val(v_mon.ms_check3_detail) || '</div>
                        <div style="margin-top:6px;font-size:8pt;">
                            <strong>Enter time of check:</strong> '
                            || NVL(v_mon.ms_check3_time, '-') || '</div>
                    </td>
                    <td style="vertical-align:top;">
                        <div><strong>All in order:</strong>&nbsp;&nbsp;' ||
                        CASE v_mon.ms_check3_in_order
                            WHEN 'Y' THEN 'YES &nbsp;/&nbsp; <span style="color:#aaa;">NO</span>'
                            WHEN 'N' THEN '<span style="color:#aaa;">YES</span> &nbsp;/&nbsp; NO'
                            ELSE 'YES &nbsp;/&nbsp; NO'
                        END || '</div>
                        <div style="margin-top:6px;font-size:8pt;"><strong>Comments:</strong><br>'
                            || NVL(safe_val(v_mon.ms_check3_comments), '&nbsp;') || '</div>
                    </td>
                </tr>';
        END IF;

        v_html := v_html || '
            </tbody>
        </table>
    </div>

    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Monitoring Sign-Off</div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Monitoring carried out by (Name):</div>
            <div class="ptw-lv-value">' || safe_val(v_mon.monitor_name) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Date:</div>
            <div class="ptw-lv-value">' || fmt_date(v_mon.monitor_date) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">(Print) Signature:</div>
            <div class="ptw-lv-value">
                <div class="signature-box">'
                    || get_signature_img(v_mon.monitor_signature) || '</div>
            </div>
        </div>
    </div>

    <div class="footer">
        Generated: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI') ||
        ' &nbsp;|&nbsp; Permit: ' || safe_val(v_permit.permit_number) || '
    </div>
    </div>'; -- end ptw-lv-report-container (monitoring page)

    END LOOP; -- c_monitoring

    -- ============================================================
    -- PERMIT HISTORY SECTION (only when p_include_history = 'Y')
    -- Uses same query as Page 6 IR — latest record per stage only.
    -- Appended after all monitoring pages as an audit appendix.
    -- ============================================================
    IF NVL(p_include_history, 'N') = 'Y' THEN

        v_html := v_html || '<div class="page-break"></div>
    <div class="ptw-lv-report-container">
    <div class="history-section">
        <div class="ptw-lv-section-title">&#128203; Permit Stage History</div>';

        DECLARE
            v_hist_count NUMBER := 0;
        BEGIN
            SELECT COUNT(*)
            INTO   v_hist_count
            FROM (
                WITH max_row AS (
                    SELECT MAX(created_date) AS max_date,
                           permit_id,
                           permit_stage
                    FROM   ptw_pro.ptw_stage_locations
                    GROUP  BY permit_id, permit_stage
                )
                SELECT sl.permit_stage
                FROM   ptw_pro.ptw_stage_locations sl
                JOIN   max_row mr
                       ON  mr.permit_id    = sl.permit_id
                       AND mr.permit_stage = sl.permit_stage
                       AND mr.max_date     = sl.created_date
                WHERE  sl.permit_id = p_permit_id
            );

            IF v_hist_count = 0 THEN
                v_html := v_html || '
        <div class="history-no-data">No stage history recorded for this permit.</div>';
            ELSE
                v_html := v_html || '
        <table class="history-table">
            <thead>
                <tr>
                    <th style="width:32%;">Stage</th>
                    <th style="width:22%;">Date / Time</th>
                    <th style="width:22%;">Recorded By</th>
                    <th style="width:24%;">GPS Location</th>
                </tr>
            </thead>
            <tbody>';

                FOR r IN (
                    WITH max_row AS (
                        SELECT MAX(created_date) AS max_date,
                               permit_id,
                               permit_stage
                        FROM   ptw_pro.ptw_stage_locations
                        GROUP  BY permit_id, permit_stage
                    )
                    SELECT CASE sl.permit_stage
                               WHEN 'SITE_WORK_DETAILS' THEN 'Step 1: Site &amp; Work Details'
                               WHEN 'CONTROL_MEASURES'  THEN 'Step 2: Control Measures'
                               WHEN 'EQUIP_ISOLATION'   THEN 'Step 3: Equipment Isolation'
                               WHEN 'AUTHORISATION'     THEN 'Step 4: Authorisation'
                               WHEN 'LIVE'              THEN 'Step 5: Live'
                               ELSE NVL(SUBSTR(sl.permit_stage, 1, 100), '-')
                           END                                              AS step_display,
                           TO_CHAR(sl.created_date, 'DD-MON-YYYY HH24:MI') AS created_date,
                           NVL(REPLACE(REPLACE(SUBSTR(sl.created_by, 1, 200),
                                               '<', '&lt;'), '>', '&gt;'), '-') AS created_by,
                           CASE
                               WHEN sl.latitude  IS NOT NULL
                                AND sl.longitude IS NOT NULL
                               THEN TO_CHAR(ROUND(sl.latitude,  5)) || ', '
                                 || TO_CHAR(ROUND(sl.longitude, 5))
                               ELSE 'Not recorded'
                           END AS location_display
                    FROM   ptw_pro.ptw_stage_locations sl
                    JOIN   max_row mr
                           ON  mr.permit_id    = sl.permit_id
                           AND mr.permit_stage = sl.permit_stage
                           AND mr.max_date     = sl.created_date
                    WHERE  sl.permit_id = p_permit_id
                    ORDER  BY sl.created_date ASC
                ) LOOP
                    v_html := v_html || '
                <tr>
                    <td><span class="history-step-badge">'
                        || r.step_display    || '</span></td>
                    <td>' || r.created_date  || '</td>
                    <td>' || r.created_by    || '</td>
                    <td>' || r.location_display || '</td>
                </tr>';
                END LOOP;

                v_html := v_html || '
            </tbody>
        </table>';
            END IF;
        END;

        v_html := v_html || '
    <div class="footer">
        Audit History &nbsp;|&nbsp; Permit: ' || safe_val(v_permit.permit_number) ||
        ' &nbsp;|&nbsp; Generated: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI') || '
    </div>
    </div>'; -- end history-section
    v_html := v_html || '
    </div>'; -- end ptw-lv-report-container (history page)

    END IF; -- p_include_history

    -- Timestamp only when no monitoring records exist
    IF v_mon_count = 0 THEN
        v_html := v_html || '
    <div style="font-size:7pt;color:#aaa;text-align:right;padding:4px 0;">
        Generated: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI') || '
    </div>';
    END IF;

    v_html := v_html || '
</div>
</body>
</html>';

    RETURN v_html;

EXCEPTION
    WHEN OTHERS THEN
        RETURN '<html><body>'
            || '<h2 style="color:red;">Error Generating Report</h2>'
            || '<p>' || SQLERRM || '</p>'
            || '<pre>' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || '</pre>'
            || '</body></html>';
END generate_ptw_lv_pdf;
/

  CREATE OR REPLACE EDITIONABLE FUNCTION "PTW_PRO"."PTW_LV_IS_CONTRACT_SUPPORT" 
    (p_username IN VARCHAR2)
RETURN VARCHAR2
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO   v_count
    FROM   ptw_pro.ptw_lv_user_roles_v        -- view handles both active flags
    WHERE  UPPER(username) = UPPER(p_username)
    AND    role_name       = 'ADMIN_CONTRACT_SUPPORT'
    AND    is_active       = 'Y';              -- combined effective flag from view

    RETURN CASE WHEN v_count > 0 THEN 'Y' ELSE 'N' END;
EXCEPTION
    WHEN OTHERS THEN RETURN 'N';
END ptw_lv_is_contract_support;
/

  CREATE OR REPLACE EDITIONABLE FUNCTION "PTW_PRO"."PTW_LV_PERMIT_VISIBLE" (
    p_permit_id        IN ptw_pro.ptw_lv_permits.permit_id%TYPE,
    p_created_by       IN ptw_pro.ptw_lv_permits.created_by%TYPE,
    p_auth_person_name IN ptw_pro.ptw_lv_permits.auth_person_name%TYPE,
    p_username         IN VARCHAR2
) RETURN VARCHAR2 -- 'Y' or 'N'
IS
    v_is_admin      NUMBER;
    v_is_engineer   NUMBER;
    v_is_authoriser NUMBER;
BEGIN
    SELECT 
        SUM(CASE WHEN role_name IN ('ADMIN','ADMIN_USER_SUPPORT',
                                    'ADMIN_CONTRACT_SUPPORT','READONLY') 
                 THEN 1 ELSE 0 END),
        SUM(CASE WHEN role_name = 'ENGINEER'   THEN 1 ELSE 0 END),
        SUM(CASE WHEN role_name = 'AUTHORISER' THEN 1 ELSE 0 END)
    INTO v_is_admin, v_is_engineer, v_is_authoriser
    FROM ptw_pro.ptw_lv_user_roles_v
    WHERE UPPER(username) = UPPER(p_username)
    AND   is_active = 'Y';

    -- Admin-class: see all
    IF v_is_admin > 0 THEN RETURN 'Y'; END IF;

    -- Engineer only: own created
    IF v_is_engineer > 0 AND v_is_authoriser = 0 THEN
        RETURN CASE WHEN UPPER(p_created_by) = UPPER(p_username) 
                    THEN 'Y' ELSE 'N' END;
    END IF;

    -- Authoriser only: own authorised
    IF v_is_authoriser > 0 AND v_is_engineer = 0 THEN
        RETURN CASE WHEN UPPER(p_auth_person_name) = UPPER(p_username) 
                    THEN 'Y' ELSE 'N' END;
    END IF;

    -- Engineer + Authoriser: created OR authorised
    IF v_is_engineer > 0 AND v_is_authoriser > 0 THEN
        RETURN CASE WHEN UPPER(p_created_by)        = UPPER(p_username)
                      OR UPPER(p_auth_person_name)  = UPPER(p_username)
                    THEN 'Y' ELSE 'N' END;
    END IF;

    RETURN 'N';
EXCEPTION
    WHEN OTHERS THEN RETURN 'N';
END ptw_lv_permit_visible;
/
