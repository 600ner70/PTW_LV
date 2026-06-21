-- =====================================================
-- PTW LV-ELECTRICAL - CREATE TEST USERS FOR TEST COMPANY 2
-- Oracle APEX 24.2 | App ID: 105
-- =====================================================
-- Creates two new accounts:
--   ADMINTEST    - role ADMIN      (company admin)
--   ENGINEERTEST - role ENGINEER   (permit-creating user)
-- Both assigned to "Test Company 2" (created during VPD
-- testing). Adjust names/emails/password as desired.
-- =====================================================


-- =====================================================
-- PART 1 - Workspace login accounts
-- Run in: SQL Workshop > SQL Commands (NOT plain SQL
-- Developer) - APEX_UTIL.CREATE_USER relies on the workspace
-- security context, which SQL Commands sets automatically.
--
-- If you must run this from SQL Developer instead, first run:
--   SELECT workspace FROM apex_applications WHERE application_id = 105;
-- then uncomment and run the block below with that workspace
-- name, BEFORE the CREATE_USER calls:
--
-- BEGIN
--     APEX_UTIL.SET_SECURITY_GROUP_ID(
--         APEX_UTIL.FIND_SECURITY_GROUP_ID(p_workspace => 'YOUR_WORKSPACE_NAME')
--     );
-- END;
-- /
-- =====================================================

BEGIN
    APEX_UTIL.CREATE_USER(
        p_user_name                     => 'ADMINTEST',
        p_first_name                    => 'Admin',
        p_last_name                     => 'Test',
        p_email_address                 => 'admintest@ptwtest.local',
        p_web_password                  => 'PtwTest#2026',
        p_developer_privs                => NULL,  -- end user, no Builder access
        p_change_password_on_first_use   => 'Y'
    );

    APEX_UTIL.CREATE_USER(
        p_user_name                     => 'ENGINEERTEST',
        p_first_name                    => 'Engineer',
        p_last_name                     => 'Test',
        p_email_address                 => 'engineertest@ptwtest.local',
        p_web_password                  => 'PtwTest#2026',
        p_developer_privs                => NULL,
        p_change_password_on_first_use   => 'Y'
    );
END;
/

-- NOTE: p_change_password_on_first_use => 'Y' means both
-- accounts will be forced to set their own password on first
-- login - 'PtwTest#2026' is a one-time temporary password
-- only.


-- =====================================================
-- PART 2 - Application profile + role assignments
-- Run as PTW_PRO (same connection as everything else)
-- =====================================================

-- Sanity check first - confirm Test Company 2 resolves to a
-- company_id before inserting anything that depends on it:
SELECT company_id, company_name
FROM   ptw_pro.ptw_lv_companies
WHERE  company_name = 'Test Company 2';
-- If this returns no rows, STOP and check the exact
-- company_name spelling/casing before continuing.


-- ---- ADMINTEST ----
INSERT INTO ptw_pro.ptw_lv_users
    (username, first_name, last_name, email_address, job_title,
     is_active, company_id, is_super_user, created_by)
VALUES
    ('ADMINTEST', 'Admin', 'Test', 'admintest@ptwtest.local',
     'Company Administrator',
     'Y',
     (SELECT company_id FROM ptw_pro.ptw_lv_companies WHERE company_name = 'Test Company 2'),
     'N',
     USER);

INSERT INTO ptw_pro.ptw_lv_user_role_assignments
    (user_id, role_id, is_active, granted_by)
VALUES
    ((SELECT user_id FROM ptw_pro.ptw_lv_users WHERE username = 'ADMINTEST'),
     (SELECT role_id FROM ptw_pro.ptw_lv_roles WHERE role_name = 'ADMIN'),
     'Y', USER);


-- ---- ENGINEERTEST ----
INSERT INTO ptw_pro.ptw_lv_users
    (username, first_name, last_name, email_address, job_title,
     is_active, company_id, is_super_user, created_by)
VALUES
    ('ENGINEERTEST', 'Engineer', 'Test', 'engineertest@ptwtest.local',
     'Electrical Engineer',
     'Y',
     (SELECT company_id FROM ptw_pro.ptw_lv_companies WHERE company_name = 'Test Company 2'),
     'N',
     USER);

INSERT INTO ptw_pro.ptw_lv_user_role_assignments
    (user_id, role_id, is_active, granted_by)
VALUES
    ((SELECT user_id FROM ptw_pro.ptw_lv_users WHERE username = 'ENGINEERTEST'),
     (SELECT role_id FROM ptw_pro.ptw_lv_roles WHERE role_name = 'ENGINEER'),
     'Y', USER);

COMMIT;


-- =====================================================
-- VERIFICATION
-- =====================================================

SELECT u.username, u.first_name, u.last_name, u.is_active,
       u.company_id, c.company_name, u.is_super_user,
       r.role_name, ur.is_active AS role_active
FROM   ptw_pro.ptw_lv_users u
JOIN   ptw_pro.ptw_lv_companies c ON c.company_id = u.company_id
LEFT   JOIN ptw_pro.ptw_lv_user_role_assignments ur ON ur.user_id = u.user_id
LEFT   JOIN ptw_pro.ptw_lv_roles r ON r.role_id = ur.role_id
WHERE  u.username IN ('ADMINTEST', 'ENGINEERTEST');


-- =====================================================
-- NOTE - Permit Types for Test Company 2
-- =====================================================
-- Per Stage 6.4: a new company starts with ZERO permit types
-- assigned (ptw_lv_company_types). If Test Company 2 doesn't
-- already have LV ISOLATION assigned (check via Page 23 as
-- ADMINTEST, or query ptw_lv_company_types directly),
-- ENGINEERTEST won't see any options on Page 14's PTW type
-- dropdown and can't create a permit yet.
--
-- Recommended: log in as ADMINTEST, go to Permit Types
-- (Page 23), set LV ISOLATION to "Yes" and Save. This is also
-- a good real-world test of Page 23 with a fresh company.


-- =====================================================
-- VERIFICATION TESTS
-- =====================================================
-- 1. Log in as ADMINTEST - prompted to change password (first
--    use). After login, "Admin" menu entries appear (User
--    Maintenance, Permit Types) but NOT Companies/Master
--    Permit Types (Super User Rights only).
-- 2. As ADMINTEST, Page 23 (Permit Types) - initially empty
--    (or shows whatever was assigned during yesterday's Page
--    23 testing, if any). Assign LV ISOLATION (Yes), Save.
-- 3. As ADMINTEST, Page 8 (User Maintenance) - shows ONLY
--    Test Company 2's users (ADMINTEST, ENGINEERTEST, and any
--    others previously created for this company) - confirms
--    Stage 7 Part 3's 8.1 filter.
-- 4. Log in as ENGINEERTEST - prompted to change password.
--    Page 14 now shows LV ISOLATION as an option (after step
--    2). Create a permit - confirm company_id is correctly
--    stamped to Test Company 2 (trg_ptw_lv_permits_company),
--    and the permit appears on ENGINEERTEST's/ADMINTEST's
--    dashboard but NOT a different company's users' dashboards.
-- 5. Confirm ENGINEERTEST does NOT see "Admin" menu entries at
--    all (Administration Rights fails for ENGINEER role).
