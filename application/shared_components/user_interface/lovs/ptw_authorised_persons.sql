prompt --application/shared_components/user_interface/lovs/ptw_authorised_persons
begin
--   Manifest
--     PTW_AUTHORISED_PERSONS
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.14'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PERMITPRO'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(35799522908090663)
,p_lov_name=>'PTW_AUTHORISED_PERSONS'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT u.first_name || '' '' || u.last_name || '' ('' || u.role_name || '')'' AS display_value,',
'       u.role_id                                                        AS return_value,',
'       mobile_no',
'FROM   ptw_pro.ptw_lv_user_roles u',
'WHERE  u.role_name IN (''ADMIN'', ''AUTHORISER'')',
'AND    u.is_active = ''Y''',
'ORDER BY u.last_name, u.first_name;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'RETURN_VALUE'
,p_display_column_name=>'DISPLAY_VALUE'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'ASC'
,p_version_scn=>46565116378574
);
wwv_flow_imp_shared.create_list_of_values_cols(
 p_id=>wwv_flow_imp.id(37968678277802592)
,p_query_column_name=>'RETURN_VALUE'
,p_display_sequence=>10
,p_data_type=>'VARCHAR2'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_imp_shared.create_list_of_values_cols(
 p_id=>wwv_flow_imp.id(37969013626802590)
,p_query_column_name=>'DISPLAY_VALUE'
,p_heading=>'Display Value'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_imp_shared.create_list_of_values_cols(
 p_id=>wwv_flow_imp.id(37969408129802589)
,p_query_column_name=>'MOBILE_NO'
,p_heading=>'Mobile No'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_imp.component_end;
end;
/
