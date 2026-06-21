prompt --application/shared_components/user_interface/lovs/control_measures_lov
begin
--   Manifest
--     CONTROL_MEASURES_LOV
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
 p_id=>wwv_flow_imp.id(45556223896387254)
,p_lov_name=>'CONTROL_MEASURES_LOV'
,p_lov_query=>'.'||wwv_flow_imp.id(45556223896387254)||'.'
,p_location=>'STATIC'
,p_version_scn=>46848007418527
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(45556537033387268)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Yes'
,p_lov_return_value=>'Y'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(45556870216387272)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'No'
,p_lov_return_value=>'N'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(45557244107387273)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'N/A'
,p_lov_return_value=>'NA'
);
wwv_flow_imp.component_end;
end;
/
