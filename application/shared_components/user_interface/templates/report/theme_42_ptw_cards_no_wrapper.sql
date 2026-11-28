prompt --application/shared_components/user_interface/templates/report/theme_42_ptw_cards_no_wrapper
begin
--   Manifest
--     ROW TEMPLATE: ptw-cards-no-wrapper
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.6'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_shared.create_row_template(
 p_id=>wwv_flow_imp.id(46213173237812182)
,p_row_template_name=>'PTW Cards - No Wrapper'
,p_static_id=>'ptw-cards-no-wrapper'
,p_internal_name=>'PTW_CARDS_NO_WRAPPER'
,p_row_template1=>'#COLUMN_VALUE#'
,p_row_template_before_rows=>' '
,p_row_template_after_rows=>' '
,p_row_template_type=>'GENERIC_COLUMNS'
,p_theme_id=>42
,p_theme_class_id=>3
,p_translate_this_template=>'N'
,p_created_on=>wwv_flow_imp.dz('20260506182720Z')
,p_updated_on=>wwv_flow_imp.dz('20260506182913Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
