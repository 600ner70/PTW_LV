prompt --application/shared_components/logic/application_items/g_active_permit_id
begin
--   Manifest
--     APPLICATION ITEM: G_ACTIVE_PERMIT_ID
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
 p_id=>wwv_flow_imp.id(24381845581118078)
,p_name=>'G_ACTIVE_PERMIT_ID'
,p_protection_level=>'I'
,p_version_scn=>'SH256:h6AnkrOP4FcCv7MFgRZC3YKCPvo8EMkhU38svg5BhH8'
,p_created_on=>wwv_flow_imp.dz('20260824200051Z')
,p_updated_on=>wwv_flow_imp.dz('20260824200052Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
