
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "PTW_PRO"."PTW_SEC_PKG" AS

    PROCEDURE set_session_context(p_username IN VARCHAR2) IS
    BEGIN
        -- No longer used: DBMS_SESSION.SET_CONTEXT is unreliable under ORDS
        -- connection pooling. company_policy now does a direct V('APP_USER')
        -- lookup instead. Stub kept for reference/rollback script compatibility.
        NULL;
    END set_session_context;


    FUNCTION company_policy(
        p_schema IN VARCHAR2,
        p_object IN VARCHAR2
    ) RETURN VARCHAR2 IS
        v_app_user      VARCHAR2(255);
        v_company_id    VARCHAR2(50);
        v_is_super_user VARCHAR2(1);
        v_override      VARCHAR2(50);
    BEGIN
        -- No APEX session = fail closed (e.g. direct SQL Developer access)
        v_app_user := V('APP_USER');
        IF v_app_user IS NULL OR v_app_user = '' THEN
            RETURN '1=2';
        END IF;

        -- Look up this user's company and super-user flag directly
        SELECT TO_CHAR(company_id), is_super_user
        INTO   v_company_id, v_is_super_user
        FROM   ptw_pro.ptw_lv_users
        WHERE  UPPER(username) = UPPER(v_app_user)
        AND    is_active = 'Y';

        -- Super user: check for a company override (set via G_OVERRIDE_COMPANY_ID
        -- application item when super user picks a company on Page 14).
        -- If override set, scope to that company; otherwise see all.
        IF v_is_super_user = 'Y' THEN
            v_override := V('G_OVERRIDE_COMPANY_ID');
            IF v_override IS NULL OR v_override = '' THEN
                RETURN NULL; -- no restriction, see all companies
            ELSE
                RETURN 'company_id = ' || TO_NUMBER(v_override);
            END IF;
        END IF;

        -- Normal user: scope to their assigned company
        IF v_company_id IS NULL THEN
            RETURN '1=2'; -- no company assigned, deny all
        END IF;

        RETURN 'company_id = ' || v_company_id;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN '1=2'; -- unknown/inactive user
        WHEN OTHERS        THEN RETURN '1=2'; -- fail closed
    END company_policy;


PROCEDURE check_user_in_company(p_username IN VARCHAR2) IS
    v_target_company NUMBER;
    v_caller_company NUMBER;
    v_caller_super   VARCHAR2(1);
    v_override       VARCHAR2(50);
BEGIN
    -- Workspace admins always allowed
    IF APEX_UTIL.CURRENT_USER_IN_GROUP('Administrators') THEN
        RETURN;
    END IF;

    SELECT company_id, is_super_user
    INTO   v_caller_company, v_caller_super
    FROM   ptw_pro.ptw_lv_users
    WHERE  UPPER(username) = UPPER(SYS_CONTEXT('APEX$SESSION', 'APP_USER'));

    IF v_caller_super = 'Y' THEN
        v_override := V('G_OVERRIDE_COMPANY_ID');
        IF v_override IS NULL OR v_override = '' THEN
            RETURN; -- super user, no override: unrestricted
        END IF;
        v_caller_company := TO_NUMBER(v_override);
    END IF;

    SELECT company_id
    INTO   v_target_company
    FROM   ptw_pro.ptw_lv_users
    WHERE  UPPER(username) = UPPER(p_username);

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

PROCEDURE set_system_context IS
BEGIN
    DBMS_SESSION.SET_CONTEXT('PTW_SEC_CTX', 'IS_SUPER_USER', 'Y');
    DBMS_SESSION.SET_CONTEXT('PTW_SEC_CTX', 'COMPANY_ID', NULL);
END set_system_context;

END ptw_sec_pkg;
/
