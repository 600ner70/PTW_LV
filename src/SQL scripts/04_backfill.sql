--------------------------------------------------------------------------------
-- 04_backfill.sql
-- One-time backfill: assign existing data to a "default" company so
-- NOT NULL constraints and VPD can be safely applied.
--
-- *** RUN THIS BEFORE APPLYING VPD POLICIES (02_vpd_policy.sql) IF YOU ALREADY
-- *** HAVE PRODUCTION DATA. If this is a fresh/dev environment with no real
-- *** data yet, you can skip this and just create companies + assign users
-- *** manually going forward.
--------------------------------------------------------------------------------

-- 1. Create your own company (the existing operator/owner of the app)
INSERT INTO ptw_pro.ptw_lv_companies (company_name, company_code, is_active)
VALUES ('MWMPRINT', 'MWM', 'Y');

-- Capture the new company_id
-- (run separately, note the value, e.g. 1)
-- SELECT company_id FROM ptw_pro.ptw_lv_companies WHERE company_code = '<<CODE>>';

-- 2. Assign ALL existing users to that company (except the one(s) you
--    designate as super users — set is_super_user='Y' and leave company_id NULL)
UPDATE ptw_pro.ptw_lv_users
SET    company_id = 1   -- <<< replace with actual new company_id
WHERE  is_super_user = 'N'
   OR  is_super_user IS NULL;

-- Manually flag your super user(s):
-- UPDATE ptw_pro.ptw_lv_users SET is_super_user = 'Y', company_id = NULL
-- WHERE username = '<<your username>>';

-- 3. Backfill ptw_lv_permits.company_id from creator's company
--    (assumes created_by maps to a username in ptw_lv_users)
UPDATE ptw_pro.ptw_lv_permits p
SET    company_id = (
           SELECT u.company_id
           FROM   ptw_pro.ptw_lv_users u
           WHERE  UPPER(u.username) = UPPER(p.created_by)
       )
WHERE  p.company_id IS NULL;

-- Fallback: any permits where created_by didn't match a user (orphaned /
-- legacy data) — assign to default company
UPDATE ptw_pro.ptw_lv_permits
SET    company_id = 1   -- <<< replace with actual default company_id
WHERE  company_id IS NULL;

-- 4. Backfill child tables from parent permit
UPDATE ptw_pro.ptw_lv_control_measures cm
SET    cm.company_id = (
           SELECT p.company_id FROM ptw_pro.ptw_lv_permits p
           WHERE  p.permit_id = cm.permit_id
       )
WHERE  cm.company_id IS NULL;

UPDATE ptw_pro.ptw_lv_equipment_isolation iso
SET    iso.company_id = (
           SELECT p.company_id FROM ptw_pro.ptw_lv_permits p
           WHERE  p.permit_id = iso.permit_id
       )
WHERE  iso.company_id IS NULL;

UPDATE ptw_pro.ptw_lv_monitoring mon
SET    mon.company_id = (
           SELECT p.company_id FROM ptw_pro.ptw_lv_permits p
           WHERE  p.permit_id = mon.permit_id
       )
WHERE  mon.company_id IS NULL;

UPDATE ptw_pro.ptw_lv_permit_photos pho
SET    pho.company_id = (
           SELECT p.company_id FROM ptw_pro.ptw_lv_permits p
           WHERE  p.permit_id = pho.permit_id
       )
WHERE  pho.company_id IS NULL;

-- 5. PTW_LV_COMPANY_TYPES — seed the default company with access to all
--    currently-existing master ptw_types (so the app keeps working exactly
--    as before for existing users — they had access to all ~12 types, so
--    the default company gets all ~12 assigned).
INSERT INTO ptw_pro.ptw_lv_company_types (company_id, type_id, is_active, created_by)
SELECT 1, type_id, 'Y', 'BACKFILL'   -- <<< replace 1 with actual default company_id
FROM   ptw_pro.ptw_types
WHERE  available = 'Y';

-- New companies onboarded after this point start with ZERO assigned types —
-- the company admin (via the new maintenance page, Stage 6) must explicitly
-- pick which master types apply to them. This is the billable event.

--------------------------------------------------------------------------------
-- 6. Verify no NULLs remain before enforcing NOT NULL
--------------------------------------------------------------------------------
-- SELECT COUNT(*) FROM ptw_pro.ptw_lv_permits WHERE company_id IS NULL;
-- SELECT COUNT(*) FROM ptw_pro.ptw_lv_control_measures WHERE company_id IS NULL;
-- SELECT COUNT(*) FROM ptw_pro.ptw_lv_equipment_isolation WHERE company_id IS NULL;
-- SELECT COUNT(*) FROM ptw_pro.ptw_lv_monitoring WHERE company_id IS NULL;
-- SELECT COUNT(*) FROM ptw_pro.ptw_lv_permit_photos WHERE company_id IS NULL;
-- SELECT COUNT(*) FROM ptw_pro.ptw_lv_users WHERE company_id IS NULL AND is_super_user = 'N';

-- Then:
-- ALTER TABLE ptw_pro.ptw_lv_permits MODIFY (company_id NOT NULL);
-- ALTER TABLE ptw_pro.ptw_lv_control_measures MODIFY (company_id NOT NULL);
-- ALTER TABLE ptw_pro.ptw_lv_equipment_isolation MODIFY (company_id NOT NULL);
-- ALTER TABLE ptw_pro.ptw_lv_monitoring MODIFY (company_id NOT NULL);
-- ALTER TABLE ptw_pro.ptw_lv_permit_photos MODIFY (company_id NOT NULL);
-- (ptw_lv_users.company_id stays nullable — super users have no company)
