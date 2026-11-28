prompt --application/shared_components/logic/application_items/app_longitude
begin
--   Manifest
--     APPLICATION ITEM: APP_LONGITUDE
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
 p_id=>wwv_flow_imp.id(33449999278968941)
,p_name=>'APP_LONGITUDE'
,p_protection_level=>'I'
,p_version_scn=>'46483335370242'
,p_created_on=>wwv_flow_imp.dz('20260312210906Z')
,p_updated_on=>wwv_flow_imp.dz('20260312210906Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
