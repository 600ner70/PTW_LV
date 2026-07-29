BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema   => 'PTW_PRO',
        object_name     => 'PTW_LV_SITES',
        policy_name     => 'PTW_COMPANY_POLICY',
        function_schema => 'PTW_PRO',
        policy_function => 'PTW_SEC_PKG.COMPANY_POLICY',
        statement_types => 'SELECT,INSERT,UPDATE,DELETE',
        update_check    => TRUE
    );
END;
/
