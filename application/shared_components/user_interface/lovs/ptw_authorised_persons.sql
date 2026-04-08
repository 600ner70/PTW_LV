prompt --application/shared_components/user_interface/lovs/ptw_authorised_persons
begin
--   Manifest
--     PTW_AUTHORISED_PERSONS
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.15'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(35799522908090663)
,p_lov_name=>'PTW_AUTHORISED_PERSONS'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT DISTINCT',
'    u.first_name || '' '' || u.last_name     AS display_value,',
'    u.username                             AS return_value,',
'    u.mobile_no',
'FROM   ptw_pro.ptw_lv_user_roles_v  u',
'WHERE  u.role_name IN (''ADMIN'', ''AUTHORISER'')',
'AND    u.username <> ''PTW_PRO''',
'AND    u.is_active = ''Y''',
'ORDER BY display_value'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'RETURN_VALUE'
,p_display_column_name=>'DISPLAY_VALUE'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'ASC'
,p_version_scn=>46647446830926
);
wwv_flow_imp.component_end;
end;
/
