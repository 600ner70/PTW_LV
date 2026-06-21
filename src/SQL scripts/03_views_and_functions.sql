--------------------------------------------------------------------------------
-- 03_views_and_functions.sql
-- Updated PTW_LV_USER_ROLES_V and PTW_LV_PERMIT_VISIBLE
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 1. PTW_LV_USER_ROLES_V — add company_id, company_name, is_super_user
--------------------------------------------------------------------------------
CREATE OR REPLACE FORCE EDITIONABLE VIEW ptw_pro.ptw_lv_user_roles_v (
    role_id, username, role_name, is_active, user_active, role_active,
    first_name, last_name, email_address, mobile_no, job_title,
    granted_by, granted_date, modified_date, user_id, role_ref_id,
    is_admin_role, role_description, display_order,
    company_id, company_name, is_super_user
) AS
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
    r.display_order,
    u.company_id,
    c.company_name,
    u.is_super_user
FROM   ptw_pro.ptw_lv_user_role_assignments  ur
JOIN   ptw_pro.ptw_lv_users                  u   ON u.user_id = ur.user_id
JOIN   ptw_pro.ptw_lv_roles                  r   ON r.role_id = ur.role_id
LEFT JOIN ptw_pro.ptw_lv_companies           c   ON c.company_id = u.company_id;

--------------------------------------------------------------------------------
-- 2. PTW_LV_PERMIT_VISIBLE — unchanged signature; company scoping is now
--    handled entirely by VPD on PTW_LV_PERMITS before this function runs.
--    This function continues to apply ROLE-based visibility WITHIN the
--    (already company-scoped) rowset.
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION ptw_pro.ptw_lv_permit_visible(
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
    -- NOTE: No company_id check here. VPD on ptw_lv_permits guarantees that
    -- p_permit_id (and therefore p_created_by / p_auth_person_name as read
    -- from that row) already belongs to the caller's company, or the caller
    -- is a super user / workspace admin who bypasses VPD entirely.
    -- This function therefore only needs to answer: "within the rows this
    -- user is already permitted to see, does their ROLE entitle them to
    -- see THIS row?"

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

    -- Admin-class (company admin) or super user: see all (within company,
    -- enforced by VPD already)
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

--------------------------------------------------------------------------------
-- 3. ptw_lv_is_contract_support — unchanged. Role check is global-role-based,
--    not company-specific. Left as-is for reference/no-op.
--------------------------------------------------------------------------------
