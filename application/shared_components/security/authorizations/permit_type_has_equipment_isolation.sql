prompt --application/shared_components/security/authorizations/permit_type_has_equipment_isolation
begin
--   Manifest
--     SECURITY SCHEME: Permit Type Has Equipment Isolation
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
 p_id=>wwv_flow_imp.id(23589822345016707)
,p_name=>'Permit Type Has Equipment Isolation'
,p_static_id=>'permit-type-has-equipment-isolation'
,p_scheme_type=>'NATIVE_EXISTS'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'sql_query', wwv_flow_string.join(wwv_flow_t_varchar2(
    '     SELECT 1',
    '     FROM   ptw_pro.ptw_lv_permits p',
    '     JOIN   ptw_pro.ptw_types t          ON t.ptw_type = p.ptw_type',
    '     JOIN   ptw_pro.ptw_type_sections ts ON ts.type_id = t.type_id',
    '     WHERE  p.permit_id     = :P4_PERMIT_ID',
    '     AND    ts.section_code = ''EQUIPMENT_ISOLATION''')))).to_clob
,p_error_message=>'This permit type does not use Equipment Isolation - access denied.'
,p_version_scn=>'SH256:nObxceznut5mZtIcx-1VG5BV5K1dX6ps2wR_fo7dvgQ'
,p_caching=>'BY_USER_BY_PAGE_VIEW'
,p_created_on=>wwv_flow_imp.dz('20260823155718Z')
,p_updated_on=>wwv_flow_imp.dz('20260823155718Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
