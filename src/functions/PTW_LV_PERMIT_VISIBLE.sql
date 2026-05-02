create or replace FUNCTION         ptw_lv_permit_visible(
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