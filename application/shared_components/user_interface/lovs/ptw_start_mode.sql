prompt --application/shared_components/user_interface/lovs/ptw_start_mode
begin
--   Manifest
--     PTW_START_MODE
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.17'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(35799750662081781)
,p_lov_name=>'PTW_START_MODE'
,p_lov_query=>'.'||wwv_flow_imp.id(35799750662081781)||'.'
,p_location=>'STATIC'
,p_version_scn=>46547617773438
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(35800037549081777)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Start immediately'
,p_lov_return_value=>'IMMEDIATE'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(35800402277081773)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Scheduled start'
,p_lov_return_value=>'SCHEDULED'
);
wwv_flow_imp.component_end;
end;
/
