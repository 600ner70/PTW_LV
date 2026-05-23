prompt --application/shared_components/user_interface/lovs/access_roles
begin
--   Manifest
--     ACCESS_ROLES
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.16'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(30193984908539779)
,p_lov_name=>'ACCESS_ROLES'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select role_name d, role_id r',
'from APEX_APPL_ACL_ROLES where application_id = :APP_ID ',
'order by 1'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'R'
,p_display_column_name=>'D'
,p_version_scn=>46397943188904
);
wwv_flow_imp.component_end;
end;
/
