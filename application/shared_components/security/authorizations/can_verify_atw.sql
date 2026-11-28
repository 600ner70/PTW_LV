prompt --application/shared_components/security/authorizations/can_verify_atw
begin
--   Manifest
--     SECURITY SCHEME: Can Verify ATW
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
 p_id=>wwv_flow_imp.id(57338820634024934)
,p_name=>'Can Verify ATW'
,p_static_id=>'can-verify-atw'
,p_scheme_type=>'NATIVE_FUNCTION_BODY'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'plsql_function_body', 'RETURN ptw_pro.ptw_atw_pkg.can_verify(:APP_USER) = ''Y'';')).to_clob
,p_error_message=>'You do not have permission to use this page.'
,p_version_scn=>'SH256:PjyOE336MGk6nJMXRSPvSJdvNhEDye4jPZ6HqjUmpfs'
,p_caching=>'BY_USER_BY_PAGE_VIEW'
,p_created_on=>wwv_flow_imp.dz('20261017162247Z')
,p_updated_on=>wwv_flow_imp.dz('20261017162323Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
