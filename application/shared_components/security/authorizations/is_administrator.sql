prompt --application/shared_components/security/authorizations/is_administrator
begin
--   Manifest
--     SECURITY SCHEME: Is Administrator
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.17'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(31533525830252139)
,p_name=>'Is Administrator'
,p_scheme_type=>'NATIVE_FUNCTION_BODY'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_count NUMBER;',
'BEGIN',
'    SELECT COUNT(*)',
'    INTO   v_count',
'    FROM   ptw_pro.ptw_lv_user_roles_v',
'    WHERE  UPPER(username) = UPPER(:APP_USER)',
'    AND    role_name = ''ADMIN''',
'    AND    is_active = ''Y'';',
'    RETURN v_count > 0;',
'EXCEPTION',
'    WHEN OTHERS THEN RETURN FALSE;',
'END;'))
,p_error_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'You do not have permission to perform this action.',
'Please contact your system administrator.'))
,p_version_scn=>46647445922313
,p_caching=>'BY_USER_BY_PAGE_VIEW'
);
wwv_flow_imp.component_end;
end;
/
