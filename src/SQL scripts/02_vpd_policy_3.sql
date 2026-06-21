--------------------------------------------------------------------------------
-- 02_vpd_policy.sql
-- Row-Level Security (VPD) for multi-tenant company isolation
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 1. Application context — session-scoped, set via trusted PL/SQL only
--------------------------------------------------------------------------------
CREATE OR REPLACE CONTEXT ptw_sec_ctx USING ptw_pro.ptw_sec_pkg;

--------------------------------------------------------------------------------
-- 2. Package: sets context + VPD policy function
--------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE ptw_pro.ptw_sec_pkg AS

    -- Called once per APEX session (Post-Authentication process)
    PROCEDURE set_session_context(p_username IN VARCHAR2);

    -- VPD policy function — returns the predicate appended to all
    -- SELECT/UPDATE/DELETE on protected tables
    FUNCTION company_policy(
        p_schema  IN VARCHAR2,
        p_object  IN VARCHAR2
    ) RETURN VARCHAR2;

    -- Page 8 (User Management) guard: raises an error if the target user
    -- is not in the caller's company (unless caller is a super user /
    -- workspace admin). Call this at the top of every Page 8 DML process
    -- before acting on a user_id passed via page item.
    PROCEDURE check_user_in_company(p_user_id IN ptw_pro.ptw_lv_users.user_id%TYPE);

END ptw_sec_pkg;
/

CREATE OR REPLACE PACKAGE BODY ptw_pro.ptw_sec_pkg AS

    PROCEDURE set_session_context(p_username IN VARCHAR2) IS
        v_company_id    ptw_pro.ptw_lv_users.company_id%TYPE;
        v_is_super_user ptw_pro.ptw_lv_users.is_super_user%TYPE;
    BEGIN
        SELECT company_id, is_super_user
        INTO   v_company_id, v_is_super_user
        FROM   ptw_pro.ptw_lv_users
        WHERE  UPPER(username) = UPPER(p_username)
        AND    is_active = 'Y';

        IF v_is_super_user = 'Y' THEN
            DBMS_SESSION.SET_CONTEXT('PTW_SEC_CTX', 'IS_SUPER_USER', 'Y');
            DBMS_SESSION.SET_CONTEXT('PTW_SEC_CTX', 'COMPANY_ID', NULL);
        ELSE
            DBMS_SESSION.SET_CONTEXT('PTW_SEC_CTX', 'IS_SUPER_USER', 'N');
            DBMS_SESSION.SET_CONTEXT('PTW_SEC_CTX', 'COMPANY_ID',
                TO_CHAR(v_company_id));
        END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Unknown/inactive user: deny everything (no company_id set,
            -- not super user — policy below will return restrictive '1=2')
            DBMS_SESSION.SET_CONTEXT('PTW_SEC_CTX', 'IS_SUPER_USER', 'N');
            DBMS_SESSION.SET_CONTEXT('PTW_SEC_CTX', 'COMPANY_ID', NULL);
        WHEN OTHERS THEN
            DBMS_SESSION.SET_CONTEXT('PTW_SEC_CTX', 'IS_SUPER_USER', 'N');
            DBMS_SESSION.SET_CONTEXT('PTW_SEC_CTX', 'COMPANY_ID', NULL);
    END set_session_context;


    FUNCTION company_policy(
        p_schema IN VARCHAR2,
        p_object IN VARCHAR2
    ) RETURN VARCHAR2 IS
        v_is_super_user VARCHAR2(1);
        v_company_id    VARCHAR2(50);
    BEGIN
        -- Fallback: APEX workspace admin (builder/Administrators group)
        -- bypasses regardless of app-level context — primary super-user check
        IF APEX_UTIL.CURRENT_USER_IN_GROUP('Administrators')
        THEN
            RETURN NULL; -- no restriction
        END IF;

        v_is_super_user := SYS_CONTEXT('PTW_SEC_CTX', 'IS_SUPER_USER');
        v_company_id    := SYS_CONTEXT('PTW_SEC_CTX', 'COMPANY_ID');

        -- Secondary: app-level super user flag
        IF v_is_super_user = 'Y' THEN
            RETURN NULL; -- no restriction
        END IF;

        -- No company context = deny all rows (fail closed)
        IF v_company_id IS NULL THEN
            RETURN '1=2';
        END IF;

        RETURN 'company_id = ' || v_company_id;

    EXCEPTION
        WHEN OTHERS THEN
            RETURN '1=2'; -- fail closed on any error
    END company_policy;


    PROCEDURE check_user_in_company(p_user_id IN ptw_pro.ptw_lv_users.user_id%TYPE) IS
        v_target_company NUMBER;
        v_caller_company NUMBER;
        v_caller_super   VARCHAR2(1);
    BEGIN
        -- Workspace admins always allowed
        IF APEX_UTIL.CURRENT_USER_IN_GROUP('Administrators')
        THEN
            RETURN;
        END IF;

        SELECT company_id, is_super_user
        INTO   v_caller_company, v_caller_super
        FROM   ptw_pro.ptw_lv_users
        WHERE  UPPER(username) = UPPER(V('APP_USER'));

        IF v_caller_super = 'Y' THEN
            RETURN; -- super users allowed
        END IF;

        SELECT company_id
        INTO   v_target_company
        FROM   ptw_pro.ptw_lv_users
        WHERE  user_id = p_user_id;

        IF v_target_company IS NULL OR v_target_company != v_caller_company THEN
            RAISE_APPLICATION_ERROR(-20002,
                'Access denied: this user does not belong to your company.');
        END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002,
                'Access denied: user not found or not permitted.');
        WHEN OTHERS THEN
            IF SQLCODE = -20002 THEN
                RAISE;
            END IF;
            RAISE_APPLICATION_ERROR(-20002,
                'Access denied: unable to verify user company.');
    END check_user_in_company;

END ptw_sec_pkg;
/

--------------------------------------------------------------------------------
-- 3. Apply VPD policies to protected tables
--------------------------------------------------------------------------------
BEGIN
    -- PERMITS (root table)
    DBMS_RLS.ADD_POLICY(
        object_schema   => 'PTW_PRO',
        object_name     => 'PTW_LV_PERMITS',
        policy_name     => 'PTW_COMPANY_POLICY',
        function_schema => 'PTW_PRO',
        policy_function => 'PTW_SEC_PKG.COMPANY_POLICY',
        statement_types => 'SELECT,INSERT,UPDATE,DELETE',
        update_check    => TRUE
    );

    -- CONTROL MEASURES
    DBMS_RLS.ADD_POLICY(
        object_schema   => 'PTW_PRO',
        object_name     => 'PTW_LV_CONTROL_MEASURES',
        policy_name     => 'PTW_COMPANY_POLICY',
        function_schema => 'PTW_PRO',
        policy_function => 'PTW_SEC_PKG.COMPANY_POLICY',
        statement_types => 'SELECT,INSERT,UPDATE,DELETE',
        update_check    => TRUE
    );

    -- EQUIPMENT ISOLATION
    DBMS_RLS.ADD_POLICY(
        object_schema   => 'PTW_PRO',
        object_name     => 'PTW_LV_EQUIPMENT_ISOLATION',
        policy_name     => 'PTW_COMPANY_POLICY',
        function_schema => 'PTW_PRO',
        policy_function => 'PTW_SEC_PKG.COMPANY_POLICY',
        statement_types => 'SELECT,INSERT,UPDATE,DELETE',
        update_check    => TRUE
    );

    -- MONITORING
    DBMS_RLS.ADD_POLICY(
        object_schema   => 'PTW_PRO',
        object_name     => 'PTW_LV_MONITORING',
        policy_name     => 'PTW_COMPANY_POLICY',
        function_schema => 'PTW_PRO',
        policy_function => 'PTW_SEC_PKG.COMPANY_POLICY',
        statement_types => 'SELECT,INSERT,UPDATE,DELETE',
        update_check    => TRUE
    );

    -- PERMIT PHOTOS
    DBMS_RLS.ADD_POLICY(
        object_schema   => 'PTW_PRO',
        object_name     => 'PTW_LV_PERMIT_PHOTOS',
        policy_name     => 'PTW_COMPANY_POLICY',
        function_schema => 'PTW_PRO',
        policy_function => 'PTW_SEC_PKG.COMPANY_POLICY',
        statement_types => 'SELECT,INSERT,UPDATE,DELETE',
        update_check    => TRUE
    );

    -- COMPANY TYPES (junction table: which master ptw_types each company can use)
    DBMS_RLS.ADD_POLICY(
        object_schema   => 'PTW_PRO',
        object_name     => 'PTW_LV_COMPANY_TYPES',
        policy_name     => 'PTW_COMPANY_POLICY',
        function_schema => 'PTW_PRO',
        policy_function => 'PTW_SEC_PKG.COMPANY_POLICY',
        statement_types => 'SELECT,INSERT,UPDATE,DELETE',
        update_check    => TRUE
    );
END;
/

--------------------------------------------------------------------------------
-- IMPORTANT NOTES
--------------------------------------------------------------------------------
-- 1. PTW_TYPES is global master data (no company_id, not under VPD) —
--    managed by the super user. PTW_LV_COMPANY_TYPES is the company-scoped
--    junction table that IS under VPD — company admins manage their own
--    company's assignments only.
--
-- 2. ptw_lv_users and ptw_lv_companies are DELIBERATELY NOT under VPD.
--    - ptw_lv_users: Page 8 (User Management) needs company admins to see/manage
--      users in their own company — this should be a WHERE clause in the page's
--      SQL (region source), not VPD, since "see my company's users" requires
--      the SAME filter as VPD anyway but Page 8 administration is a narrower,
--      reviewable surface. Optionally add VPD here too for defense-in-depth —
--      flag if you want this.
--    - ptw_lv_companies: super users manage all companies; company admins
--      should see only their own company's record (1 row) — again, a page-level
--      filter on Page 8/new company settings page is sufficient and clearer
--      than VPD for a near-static single-row lookup.
--
-- 3. PTW_STAGE_LOCATIONS and PTW_LV_ROLES, PTW_LV_USER_ROLE_ASSIGNMENTS are
--    NOT under VPD (global / non-tenant data, per your decision on roles
--    being global).
--
-- 4. update_check => TRUE prevents a user from UPDATEing a row to move it
--    INTO another company's company_id (or INSERTing directly with another
--    company's id) — this matters because company_id is now a regular column
--    on these tables and could otherwise be tampered with via APEX item
--    manipulation if a hidden item is exposed.
