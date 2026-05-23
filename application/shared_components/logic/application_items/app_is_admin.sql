prompt --application/shared_components/logic/application_items/app_is_admin
begin
--   Manifest
--     APPLICATION ITEM: APP_IS_ADMIN
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.16'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_shared.create_flow_item(
 p_id=>wwv_flow_imp.id(46108593711330235)
,p_name=>'APP_IS_ADMIN'
,p_protection_level=>'I'
,p_version_scn=>46857033709824
);
wwv_flow_imp.component_end;
end;
/
