prompt --application/shared_components/security/authorizations/can_issue_atw
begin
--   Manifest
--     SECURITY SCHEME: Can Issue ATW
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
 p_id=>wwv_flow_imp.id(57338469143019020)
,p_name=>'Can Issue ATW'
,p_static_id=>'can-issue-atw'
,p_scheme_type=>'NATIVE_FUNCTION_BODY'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'plsql_function_body', 'RETURN ptw_pro.ptw_atw_pkg.is_issuer(:APP_USER) = ''Y'';')).to_clob
,p_error_message=>'You do not have permission to use this page.'
,p_version_scn=>'SH256:PnXEqyNGqPSsqLeD7MDYGuqn263so4wkl8Pke0nEYv8'
,p_caching=>'BY_USER_BY_PAGE_VIEW'
,p_created_on=>wwv_flow_imp.dz('20261017162148Z')
,p_updated_on=>wwv_flow_imp.dz('20261017162148Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
