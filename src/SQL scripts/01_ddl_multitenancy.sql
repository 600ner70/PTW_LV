--------------------------------------------------------------------------------
-- 01_ddl_multitenancy.sql
-- PTW_PRO schema — multi-company / multi-tenant changes
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 1. COMPANIES TABLE
--------------------------------------------------------------------------------
CREATE TABLE ptw_pro.ptw_lv_companies (
    company_id    NUMBER GENERATED ALWAYS AS IDENTITY
                  MINVALUE 1 START WITH 1 CACHE 20 NOT NULL ENABLE,
    company_name  VARCHAR2(200) NOT NULL ENABLE,
    company_code  VARCHAR2(30),
    is_active     VARCHAR2(1) DEFAULT 'Y' NOT NULL ENABLE,
    created_date  TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    created_by    VARCHAR2(100),
    modified_date TIMESTAMP(6),
    modified_by   VARCHAR2(100),
    CONSTRAINT pk_ptw_lv_companies PRIMARY KEY (company_id) USING INDEX ENABLE,
    CONSTRAINT uq_ptw_lv_companies_code UNIQUE (company_code) USING INDEX ENABLE,
    CONSTRAINT chk_ptw_lv_companies_active CHECK (is_active IN ('Y','N')) ENABLE
);

--------------------------------------------------------------------------------
-- 2. USERS — add company_id + is_super_user
--------------------------------------------------------------------------------
ALTER TABLE ptw_pro.ptw_lv_users
    ADD (
        company_id    NUMBER,
        is_super_user VARCHAR2(1) DEFAULT 'N' NOT NULL
    );

ALTER TABLE ptw_pro.ptw_lv_users
    ADD CONSTRAINT chk_ptw_lv_users_super CHECK (is_super_user IN ('Y','N')) ENABLE;

ALTER TABLE ptw_pro.ptw_lv_users
    ADD CONSTRAINT fk_ptw_lv_users_company
    FOREIGN KEY (company_id) REFERENCES ptw_pro.ptw_lv_companies (company_id);

CREATE INDEX ptw_pro.idx_ptw_lv_users_company ON ptw_pro.ptw_lv_users (company_id);

-- NOTE: company_id is nullable to allow super users with no company.
-- Application logic / a validation should enforce company_id IS NOT NULL
-- for any user where is_super_user = 'N'.

--------------------------------------------------------------------------------
-- 3. PERMITS — add company_id (root of tenant scoping)
--------------------------------------------------------------------------------
ALTER TABLE ptw_pro.ptw_lv_permits
    ADD (company_id NUMBER);

ALTER TABLE ptw_pro.ptw_lv_permits
    ADD CONSTRAINT fk_ptw_lv_permits_company
    FOREIGN KEY (company_id) REFERENCES ptw_pro.ptw_lv_companies (company_id);

CREATE INDEX ptw_pro.idx_ptw_lv_permits_company ON ptw_pro.ptw_lv_permits (company_id);

--------------------------------------------------------------------------------
-- 4. CHILD TABLES — add company_id (denormalised for VPD simplicity/performance)
--------------------------------------------------------------------------------
ALTER TABLE ptw_pro.ptw_lv_control_measures      ADD (company_id NUMBER);
ALTER TABLE ptw_pro.ptw_lv_equipment_isolation   ADD (company_id NUMBER);
ALTER TABLE ptw_pro.ptw_lv_monitoring            ADD (company_id NUMBER);
ALTER TABLE ptw_pro.ptw_lv_permit_photos         ADD (company_id NUMBER);

CREATE INDEX ptw_pro.idx_ptw_lv_cm_company   ON ptw_pro.ptw_lv_control_measures    (company_id);
CREATE INDEX ptw_pro.idx_ptw_lv_iso_company  ON ptw_pro.ptw_lv_equipment_isolation (company_id);
CREATE INDEX ptw_pro.idx_ptw_lv_mon_company  ON ptw_pro.ptw_lv_monitoring          (company_id);
CREATE INDEX ptw_pro.idx_ptw_lv_pho_company  ON ptw_pro.ptw_lv_permit_photos       (company_id);

-- Triggers to auto-populate child.company_id from parent permit on insert
-- (keeps it denormalised/in-sync without requiring every page process to set it)

CREATE OR REPLACE TRIGGER ptw_pro.trg_ptw_lv_cm_company
BEFORE INSERT ON ptw_pro.ptw_lv_control_measures
FOR EACH ROW
WHEN (NEW.company_id IS NULL)
BEGIN
    SELECT company_id INTO :NEW.company_id
    FROM ptw_pro.ptw_lv_permits
    WHERE permit_id = :NEW.permit_id;
END;
/

CREATE OR REPLACE TRIGGER ptw_pro.trg_ptw_lv_iso_company
BEFORE INSERT ON ptw_pro.ptw_lv_equipment_isolation
FOR EACH ROW
WHEN (NEW.company_id IS NULL)
BEGIN
    SELECT company_id INTO :NEW.company_id
    FROM ptw_pro.ptw_lv_permits
    WHERE permit_id = :NEW.permit_id;
END;
/

CREATE OR REPLACE TRIGGER ptw_pro.trg_ptw_lv_mon_company
BEFORE INSERT ON ptw_pro.ptw_lv_monitoring
FOR EACH ROW
WHEN (NEW.company_id IS NULL)
BEGIN
    SELECT company_id INTO :NEW.company_id
    FROM ptw_pro.ptw_lv_permits
    WHERE permit_id = :NEW.permit_id;
END;
/

CREATE OR REPLACE TRIGGER ptw_pro.trg_ptw_lv_pho_company
BEFORE INSERT ON ptw_pro.ptw_lv_permit_photos
FOR EACH ROW
WHEN (NEW.company_id IS NULL)
BEGIN
    SELECT company_id INTO :NEW.company_id
    FROM ptw_pro.ptw_lv_permits
    WHERE permit_id = :NEW.permit_id;
END;
/

--------------------------------------------------------------------------------
-- 5. PTW_TYPES — stays GLOBAL (master list, managed by super user)
--------------------------------------------------------------------------------
-- NO column changes to ptw_types. It remains a global master list of
-- available permit types, maintained by the super user (initially via SQL
-- script, later via a super-user app).
--
-- NOT placed under VPD — it's reference/master data, same tier as
-- ptw_lv_roles.

--------------------------------------------------------------------------------
-- 5b. NEW: PTW_LV_COMPANY_TYPES — junction table
--      Which master types each company is licensed/permitted to use.
--      This is the company-scoped, VPD-protected, billable entity.
--------------------------------------------------------------------------------
CREATE TABLE ptw_pro.ptw_lv_company_types (
    company_type_id NUMBER GENERATED ALWAYS AS IDENTITY
                     MINVALUE 1 START WITH 1 CACHE 20 NOT NULL ENABLE,
    company_id      NUMBER NOT NULL ENABLE,
    type_id         NUMBER NOT NULL ENABLE,
    is_active       VARCHAR2(1) DEFAULT 'Y' NOT NULL ENABLE,
    created_date    TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    created_by      VARCHAR2(100),
    modified_date   TIMESTAMP(6),
    modified_by     VARCHAR2(100),
    CONSTRAINT pk_ptw_lv_company_types PRIMARY KEY (company_type_id)
        USING INDEX ENABLE,
    CONSTRAINT uq_ptw_lv_company_types UNIQUE (company_id, type_id)
        USING INDEX ENABLE,
    CONSTRAINT chk_ptw_lv_company_types_active CHECK (is_active IN ('Y','N')) ENABLE,
    CONSTRAINT fk_ptw_lv_company_types_company FOREIGN KEY (company_id)
        REFERENCES ptw_pro.ptw_lv_companies (company_id),
    CONSTRAINT fk_ptw_lv_company_types_type FOREIGN KEY (type_id)
        REFERENCES ptw_pro.ptw_types (type_id)
);

CREATE INDEX ptw_pro.idx_ptw_lv_co_types_company ON ptw_pro.ptw_lv_company_types (company_id);
CREATE INDEX ptw_pro.idx_ptw_lv_co_types_type    ON ptw_pro.ptw_lv_company_types (type_id);

-- This table IS placed under VPD (Stage 4) — company admins manage only
-- their own company's assignments.
--
-- Billing: COUNT(*) WHERE is_active = 'Y' GROUP BY company_id gives
-- "number of permit types this company is licensed for".

--------------------------------------------------------------------------------
-- NOTES / DECISIONS — RESOLVED
--------------------------------------------------------------------------------
-- a) PTW_TYPES stays global, no company_id, no VPD. Super user manages the
--    master list (initially via SQL, later via a super-user app).
--
-- b) PTW_LV_COMPANY_TYPES is the new company-scoped junction table — VPD
--    applies to THIS table, not ptw_types. Company admins assign which
--    master types their company can use.
--
-- c) After backfill (see 02_backfill script), make company_id NOT NULL on:
--      ptw_lv_permits.company_id, ptw_lv_control_measures.company_id,
--      ptw_lv_equipment_isolation.company_id, ptw_lv_monitoring.company_id,
--      ptw_lv_permit_photos.company_id.
--    (ptw_types unaffected - no company_id column on it at all now.)
