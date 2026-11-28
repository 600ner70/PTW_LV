prompt --application/shared_components/user_interface/lovs/control_measures_lov
begin
--   Manifest
--     CONTROL_MEASURES_LOV
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.6'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(45556223896387254)
,p_lov_name=>'CONTROL_MEASURES_LOV'
,p_static_id=>'control-measures-lov'
,p_lov_query=>'.'||wwv_flow_imp.id(45556223896387254)||'.'
,p_location=>'STATIC'
,p_version_scn=>'46848007418527'
,p_created_on=>wwv_flow_imp.dz('20260428173630Z')
,p_updated_on=>wwv_flow_imp.dz('20260428173631Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(45556870216387272)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'No'
,p_lov_return_value=>'N'
,p_static_id=>'n'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(45557244107387273)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'N/A'
,p_lov_return_value=>'NA'
,p_static_id=>'na'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(45556537033387268)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Yes'
,p_lov_return_value=>'Y'
,p_static_id=>'y'
);
wwv_flow_imp.component_end;
end;
/
