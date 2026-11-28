prompt --application/shared_components/security/authorizations/administration_rights
begin
--   Manifest
--     SECURITY SCHEME: Administration Rights
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
 p_id=>wwv_flow_imp.id(26419849891144614)
,p_name=>'Administration Rights'
,p_static_id=>'administration-rights'
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
    '    AND    role_name IN (''ADMIN'', ''ADMIN_USER_SUPPORT'')',
    '    AND    is_active = ''Y'';',
    '    RETURN v_count > 0;',
    'EXCEPTION',
    '    WHEN OTHERS THEN RETURN FALSE;',
    'END;')))).to_clob
,p_error_message=>'Insufficient privileges - you must be an Administrator or User Support Admin to access this page.'
,p_version_scn=>'46647445791035'
,p_caching=>'BY_USER_BY_PAGE_VIEW'
,p_created_on=>wwv_flow_imp.dz('20260207174826Z')
,p_updated_on=>wwv_flow_imp.dz('20260403125213Z')
,p_created_by=>'PERMITPRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
