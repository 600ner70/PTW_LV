prompt --application/shared_components/security/authorizations/can_authorise_permits
begin
--   Manifest
--     SECURITY SCHEME: Can Authorise Permits
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.6'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(31534159719199270)
,p_name=>'Can Authorise Permits'
,p_static_id=>'can-authorise-permits'
,p_scheme_type=>'NATIVE_FUNCTION_BODY'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'plsql_function_body', wwv_flow_string.join(wwv_flow_t_varchar2(
    'DECLARE',
    '    v_count NUMBER;',
    'BEGIN',
    '    SELECT COUNT(*)',
    '    INTO   v_count',
    '    FROM   ptw_pro.ptw_lv_user_roles_v',
    '    WHERE  UPPER(username) = UPPER(:APP_USER)',
    '    AND    role_name IN (''ADMIN'', ''AUTHORISER'')',
    '    AND    is_active = ''Y'';',
    '    RETURN v_count > 0;',
    'EXCEPTION',
    '    WHEN OTHERS THEN RETURN FALSE;',
    'END;')))).to_clob
,p_error_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'You do not have permission to perform this action.',
'Please contact your system administrator.',
''))
,p_version_scn=>'46647446017058'
,p_caching=>'BY_USER_BY_PAGE_VIEW'
,p_created_on=>wwv_flow_imp.dz('20260228165043Z')
,p_updated_on=>wwv_flow_imp.dz('20260403125531Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
