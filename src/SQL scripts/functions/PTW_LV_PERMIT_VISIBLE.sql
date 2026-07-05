
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
