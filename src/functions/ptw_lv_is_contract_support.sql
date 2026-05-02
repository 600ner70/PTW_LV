create or replace FUNCTION         ptw_lv_is_contract_support
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