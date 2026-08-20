--------------------------------------------------------------------------------
-- 05_new_tables_ddl.sql
-- New tables for: (1) permit-type-driven checklist (Control Measures + PPE)
--                  (2) signature normalization (replaces AUTH_/ACCEPT_/CLEAR_/
--                      CANCEL_ column groups on PTW_LV_PERMITS)
--                  (3) monitoring check normalization (replaces MS_CHECK1..3
--                      column groups on PTW_LV_MONITORING)
--
-- Run as PTW_PRO (or a user with CREATE TABLE/SEQUENCE/TRIGGER + EXECUTE on
-- DBMS_RLS in that schema). Run AFTER 01-04, since this depends on
-- PTW_TYPES, PTW_LV_PERMITS, PTW_LV_MONITORING, and PTW_SEC_PKG.COMPANY_POLICY.
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 1. Sequences
--------------------------------------------------------------------------------
CREATE SEQUENCE "PTW_PRO"."PTW_CHECKLIST_ITEM_SEQ"
  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1
  NOCACHE NOORDER NOCYCLE NOKEEP NOSCALE GLOBAL;

CREATE SEQUENCE "PTW_PRO"."PTW_CHECKLIST_RESPONSE_SEQ"
  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1
  NOCACHE NOORDER NOCYCLE NOKEEP NOSCALE GLOBAL;

CREATE SEQUENCE "PTW_PRO"."PTW_SIGNATURE_SEQ"
  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1
  NOCACHE NOORDER NOCYCLE NOKEEP NOSCALE GLOBAL;

CREATE SEQUENCE "PTW_PRO"."PTW_MONITORING_CHECK_SEQ"
  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1
  NOCACHE NOORDER NOCYCLE NOKEEP NOSCALE GLOBAL;

--------------------------------------------------------------------------------
-- 2. PTW_CHECKLIST_ITEMS — metadata, one row per question per permit type.
--    NOT company-scoped / NOT under VPD — shared reference data, same
--    treatment as PTW_TYPES (a company doesn't own a question, it owns
--    which TYPE it's licensed for via PTW_LV_COMPANY_TYPES, unchanged).
--------------------------------------------------------------------------------
CREATE TABLE "PTW_PRO"."PTW_CHECKLIST_ITEMS"
   (  "CHECKLIST_ITEM_ID" NUMBER DEFAULT "PTW_PRO"."PTW_CHECKLIST_ITEM_SEQ"."NEXTVAL" NOT NULL ENABLE,
      "TYPE_ID"           NUMBER NOT NULL ENABLE,
      "SECTION_CODE"      VARCHAR2(30 BYTE) NOT NULL ENABLE,
      "ITEM_CODE"         VARCHAR2(30 BYTE) NOT NULL ENABLE,
      "ITEM_SEQ"          NUMBER NOT NULL ENABLE,
      "QUESTION_TEXT"     VARCHAR2(500 BYTE) NOT NULL ENABLE,
      "HELP_TEXT"         VARCHAR2(1000 BYTE),
      "RESPONSE_TYPE"     VARCHAR2(20 BYTE) DEFAULT 'TRISTATE' NOT NULL ENABLE,
      "IS_ACTIVE"         VARCHAR2(1 BYTE) DEFAULT 'Y' NOT NULL ENABLE,
      "CREATED_DATE"      DATE NOT NULL ENABLE,
      "CREATED_BY"        VARCHAR2(30 BYTE),
       CONSTRAINT "PK_PTW_CHECKLIST_ITEMS" PRIMARY KEY ("CHECKLIST_ITEM_ID")
  USING INDEX ENABLE,
       CONSTRAINT "UQ_PTW_CHECKLIST_ITEMS" UNIQUE ("TYPE_ID", "ITEM_CODE")
  USING INDEX ENABLE,
       CONSTRAINT "FK_PTW_CI_TYPE" FOREIGN KEY ("TYPE_ID")
        REFERENCES "PTW_PRO"."PTW_TYPES" ("TYPE_ID") ENABLE,
       CONSTRAINT "CHK_PTW_CI_SECTION" CHECK (section_code IN ('CONTROL_MEASURES','PPE')) ENABLE,
       CONSTRAINT "CHK_PTW_CI_RESP_TYPE" CHECK (response_type IN ('TRISTATE','TICK')) ENABLE,
       CONSTRAINT "CHK_PTW_CI_ACTIVE" CHECK (is_active IN ('Y','N')) ENABLE
   ) DEFAULT COLLATION "USING_NLS_COMP";

CREATE INDEX "PTW_PRO"."IDX_PTW_CI_TYPE" ON "PTW_PRO"."PTW_CHECKLIST_ITEMS" ("TYPE_ID");

-- Audit trigger — identical pattern to TRG_PTW_TYPES_AUDIT
CREATE OR REPLACE EDITIONABLE TRIGGER "PTW_PRO"."TRG_PTW_CHECKLIST_ITEMS_AUDIT"
BEFORE INSERT ON ptw_pro.ptw_checklist_items
FOR EACH ROW
BEGIN
    :NEW.created_date := SYSDATE;
    :NEW.created_by   := NVL(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER);
END;
/
ALTER TRIGGER "PTW_PRO"."TRG_PTW_CHECKLIST_ITEMS_AUDIT" ENABLE;

--------------------------------------------------------------------------------
-- 3. PTW_CHECKLIST_RESPONSES — one row per answered question per permit.
--    Permit-linked -> company_id + VPD, same as PTW_LV_CONTROL_MEASURES today.
--------------------------------------------------------------------------------
CREATE TABLE "PTW_PRO"."PTW_CHECKLIST_RESPONSES"
   (  "CHECKLIST_RESPONSE_ID" NUMBER DEFAULT "PTW_PRO"."PTW_CHECKLIST_RESPONSE_SEQ"."NEXTVAL",
      "PERMIT_ID"             NUMBER NOT NULL ENABLE,
      "CHECKLIST_ITEM_ID"     NUMBER NOT NULL ENABLE,
      "RESPONSE"              VARCHAR2(2 BYTE) COLLATE "USING_NLS_COMP",
      "COMPANY_ID"            NUMBER NOT NULL ENABLE,
      "CREATED_DATE"          TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,
      "CREATED_BY"            VARCHAR2(100 BYTE) COLLATE "USING_NLS_COMP",
      "MODIFIED_DATE"         TIMESTAMP (6),
      "MODIFIED_BY"           VARCHAR2(100 BYTE) COLLATE "USING_NLS_COMP",
       CONSTRAINT "PK_PTW_CHECKLIST_RESPONSES" PRIMARY KEY ("CHECKLIST_RESPONSE_ID")
  USING INDEX ENABLE,
       CONSTRAINT "UQ_PTW_CHECKLIST_RESPONSES" UNIQUE ("PERMIT_ID", "CHECKLIST_ITEM_ID")
  USING INDEX ENABLE,
       CONSTRAINT "FK_PTW_CR_PERMIT" FOREIGN KEY ("PERMIT_ID")
        REFERENCES "PTW_PRO"."PTW_LV_PERMITS" ("PERMIT_ID") ON DELETE CASCADE ENABLE,
       CONSTRAINT "FK_PTW_CR_ITEM" FOREIGN KEY ("CHECKLIST_ITEM_ID")
        REFERENCES "PTW_PRO"."PTW_CHECKLIST_ITEMS" ("CHECKLIST_ITEM_ID") ENABLE,
       CONSTRAINT "CHK_PTW_CR_RESPONSE" CHECK (response IN ('Y','N','NA')) ENABLE
   ) DEFAULT COLLATION "USING_NLS_COMP";

CREATE INDEX "PTW_PRO"."IDX_PTW_CR_PERMIT" ON "PTW_PRO"."PTW_CHECKLIST_RESPONSES" ("PERMIT_ID");
CREATE INDEX "PTW_PRO"."IDX_PTW_CR_ITEM"   ON "PTW_PRO"."PTW_CHECKLIST_RESPONSES" ("CHECKLIST_ITEM_ID");

--------------------------------------------------------------------------------
-- 4. PTW_SIGNATURES — replaces the AUTH_/ACCEPT_/CLEAR_/CANCEL_ column groups
--    on PTW_LV_PERMITS. One row per stage per permit (max 4 rows/permit).
--------------------------------------------------------------------------------
CREATE TABLE "PTW_PRO"."PTW_SIGNATURES"
   (  "SIGNATURE_ID"    NUMBER DEFAULT "PTW_PRO"."PTW_SIGNATURE_SEQ"."NEXTVAL",
      "PERMIT_ID"       NUMBER NOT NULL ENABLE,
      "STAGE"           VARCHAR2(10 BYTE) COLLATE "USING_NLS_COMP" NOT NULL ENABLE,
      "PERSON_NAME"     VARCHAR2(200 BYTE) COLLATE "USING_NLS_COMP",
      "SIGNATURE_BLOB"  BLOB,
      "MOBILE_NO"       VARCHAR2(50 BYTE) COLLATE "USING_NLS_COMP",
      "COMPANY_NAME"    VARCHAR2(200 BYTE) COLLATE "USING_NLS_COMP",
      "EVENT_DATETIME"  DATE,
      "LATITUDE"        NUMBER,
      "LONGITUDE"       NUMBER,
      "COMPANY_ID"      NUMBER NOT NULL ENABLE,
      "CREATED_DATE"    TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,
      "CREATED_BY"      VARCHAR2(100 BYTE) COLLATE "USING_NLS_COMP",
      "MODIFIED_DATE"   TIMESTAMP (6),
      "MODIFIED_BY"     VARCHAR2(100 BYTE) COLLATE "USING_NLS_COMP",
       CONSTRAINT "PK_PTW_SIGNATURES" PRIMARY KEY ("SIGNATURE_ID")
  USING INDEX ENABLE,
       CONSTRAINT "UQ_PTW_SIGNATURES" UNIQUE ("PERMIT_ID", "STAGE")
  USING INDEX ENABLE,
       CONSTRAINT "FK_PTW_SIG_PERMIT" FOREIGN KEY ("PERMIT_ID")
        REFERENCES "PTW_PRO"."PTW_LV_PERMITS" ("PERMIT_ID") ON DELETE CASCADE ENABLE,
       CONSTRAINT "CHK_PTW_SIG_STAGE" CHECK (stage IN ('AUTH','ACCEPT','CLEAR','CANCEL')) ENABLE
   ) DEFAULT COLLATION "USING_NLS_COMP";

CREATE INDEX "PTW_PRO"."IDX_PTW_SIG_PERMIT" ON "PTW_PRO"."PTW_SIGNATURES" ("PERMIT_ID");

--------------------------------------------------------------------------------
-- 5. PTW_MONITORING_CHECKS — replaces the MS_CHECK1../2../3.. column groups
--    on PTW_LV_MONITORING. One row per check performed (no longer capped at 3).
--------------------------------------------------------------------------------
CREATE TABLE "PTW_PRO"."PTW_MONITORING_CHECKS"
   (  "MONITORING_CHECK_ID" NUMBER DEFAULT "PTW_PRO"."PTW_MONITORING_CHECK_SEQ"."NEXTVAL",
      "MONITORING_ID"       NUMBER NOT NULL ENABLE,
      "CHECK_SEQ"           NUMBER NOT NULL ENABLE,
      "DETAIL"              VARCHAR2(1000 BYTE) COLLATE "USING_NLS_COMP",
      "CHECK_TIME"          VARCHAR2(10 BYTE) COLLATE "USING_NLS_COMP",
      "IN_ORDER"            VARCHAR2(2 BYTE) COLLATE "USING_NLS_COMP",
      "COMMENTS"            VARCHAR2(1000 BYTE) COLLATE "USING_NLS_COMP",
      "COMPANY_ID"          NUMBER NOT NULL ENABLE,
      "CREATED_DATE"        TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP,
      "CREATED_BY"          VARCHAR2(100 BYTE) COLLATE "USING_NLS_COMP",
      "MODIFIED_DATE"       TIMESTAMP (6),
      "MODIFIED_BY"         VARCHAR2(100 BYTE) COLLATE "USING_NLS_COMP",
       CONSTRAINT "PK_PTW_MONITORING_CHECKS" PRIMARY KEY ("MONITORING_CHECK_ID")
  USING INDEX ENABLE,
       CONSTRAINT "UQ_PTW_MONITORING_CHECKS" UNIQUE ("MONITORING_ID", "CHECK_SEQ")
  USING INDEX ENABLE,
       CONSTRAINT "FK_PTW_MC_MONITORING" FOREIGN KEY ("MONITORING_ID")
        REFERENCES "PTW_PRO"."PTW_LV_MONITORING" ("MONITORING_ID") ON DELETE CASCADE ENABLE,
       CONSTRAINT "CHK_PTW_MC_IN_ORDER" CHECK (in_order IN ('Y','N')) ENABLE
   ) DEFAULT COLLATION "USING_NLS_COMP";

CREATE INDEX "PTW_PRO"."IDX_PTW_MC_MONITORING" ON "PTW_PRO"."PTW_MONITORING_CHECKS" ("MONITORING_ID");

--------------------------------------------------------------------------------
-- 6. VPD policies — PTW_CHECKLIST_ITEMS is deliberately excluded (shared
--    reference data, same treatment as PTW_TYPES). The other three follow
--    the exact pattern already used for PTW_LV_CONTROL_MEASURES etc.
--------------------------------------------------------------------------------
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema   => 'PTW_PRO',
        object_name     => 'PTW_CHECKLIST_RESPONSES',
        policy_name     => 'PTW_COMPANY_POLICY',
        function_schema => 'PTW_PRO',
        policy_function => 'PTW_SEC_PKG.COMPANY_POLICY',
        statement_types => 'SELECT,INSERT,UPDATE,DELETE',
        update_check    => TRUE
    );

    DBMS_RLS.ADD_POLICY(
        object_schema   => 'PTW_PRO',
        object_name     => 'PTW_SIGNATURES',
        policy_name     => 'PTW_COMPANY_POLICY',
        function_schema => 'PTW_PRO',
        policy_function => 'PTW_SEC_PKG.COMPANY_POLICY',
        statement_types => 'SELECT,INSERT,UPDATE,DELETE',
        update_check    => TRUE
    );

    DBMS_RLS.ADD_POLICY(
        object_schema   => 'PTW_PRO',
        object_name     => 'PTW_MONITORING_CHECKS',
        policy_name     => 'PTW_COMPANY_POLICY',
        function_schema => 'PTW_PRO',
        policy_function => 'PTW_SEC_PKG.COMPANY_POLICY',
        statement_types => 'SELECT,INSERT,UPDATE,DELETE',
        update_check    => TRUE
    );
END;
/
