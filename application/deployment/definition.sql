prompt --application/deployment/definition
begin
--   Manifest
--     INSTALL: 105
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.6'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp_shared.create_install(
 p_id=>wwv_flow_imp.id(26429768795145699)
,p_deinstall_script_clob=>wwv_flow_imp.varchar2_to_clob(wwv_flow_imp.g_varchar2_table)
,p_created_on=>wwv_flow_imp.dz('20260207174837Z')
,p_last_updated_on=>wwv_flow_imp.dz('20260207174837Z')
,p_created_by=>'PERMITPRO'
,p_last_updated_by=>'PERMITPRO'
);
wwv_flow_imp.component_end;
end;
/
