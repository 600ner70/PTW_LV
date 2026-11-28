prompt --application/shared_components/logic/application_items/g_override_company_id
begin
--   Manifest
--     APPLICATION ITEM: G_OVERRIDE_COMPANY_ID
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.6'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_shared.create_flow_item(
 p_id=>wwv_flow_imp.id(52448169030127115)
,p_name=>'G_OVERRIDE_COMPANY_ID'
,p_protection_level=>'I'
,p_version_scn=>'47254835603203'
,p_created_on=>wwv_flow_imp.dz('20260614125542Z')
,p_updated_on=>wwv_flow_imp.dz('20260614125542Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
