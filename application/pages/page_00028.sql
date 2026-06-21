prompt --application/pages/page_00028
begin
--   Manifest
--     PAGE: 00028
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.17'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_page.create_page(
 p_id=>28
,p_name=>'Set Active Company'
,p_alias=>'SET-ACTIVE-COMPANY'
,p_step_title=>'Set Active Company'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.admin-page-header {',
'    background: linear-gradient(135deg, #003366 0%, #005599 100%);',
'    color: white;',
'    padding: 25px 30px;',
'    border-radius: 8px;',
'    margin-bottom: 25px;',
'}',
'.admin-page-header h1 { margin: 0 0 5px 0; font-size: 1.75rem; font-weight: 700; }',
'.admin-page-header p  { margin: 0; opacity: 0.85; font-size: 0.95rem; }'))
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(52412848522131878)
,p_protection_level=>'C'
,p_page_component_map=>'25'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(52494724784962706)
,p_plug_name=>'Page Header'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>30
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_html CLOB;',
'BEGIN',
'    l_html := ''<div class="admin-page-header">''',
'           || ''  <h1>Set Active Company</h1>''',
'           || ''  <p>Choose a company to view and manage as. This applies across ''',
'           || ''     the whole application (dashboard, permit types, user ''',
'           || ''     maintenance, and creating permits) until you clear it or ''',
'           || ''     log out and back in.</p>''',
'           || ''</div>'';',
'    RETURN l_html;',
'END;'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(52494859514962707)
,p_plug_name=>'Active Company'
,p_title=>'Active Company'
,p_icon_css_classes=>'fa-building'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>40
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(52495180908962710)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>50
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(52495220439962711)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(52495180908962710)
,p_button_name=>'SET'
,p_button_static_id=>'BTN_SET_P28'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Set Active Company'
,p_button_position=>'NEXT'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(52495371259962712)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(52495180908962710)
,p_button_name=>'CLEAR'
,p_button_static_id=>'BTN_CLEAR_P28'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'View All Companies'
,p_button_position=>'PREVIOUS'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(52495602273962715)
,p_branch_name=>'Reload Page 28'
,p_branch_action=>'f?p=&APP_ID.:28:&SESSION.::&DEBUG.:28::'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(52494935017962708)
,p_name=>'P28_COMPANY_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(52494859514962707)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Active Company'
,p_source=>'V(''G_OVERRIDE_COMPANY_ID'')'
,p_source_type=>'EXPRESSION'
,p_source_language=>'PLSQL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT company_name d,',
'       company_id   r',
'FROM   ptw_pro.ptw_lv_companies',
'WHERE  is_active = ''Y''',
'ORDER  BY company_name;'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-- View All Companies (no restriction) --'
,p_cHeight=>1
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(52495028573962709)
,p_name=>'P28_CURRENT_STATUS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(52494859514962707)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Currently'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'        v_override  VARCHAR2(50)  := V(''G_OVERRIDE_COMPANY_ID'');',
'        v_name      VARCHAR2(200);',
'    BEGIN',
'        IF v_override IS NULL OR v_override = '''' THEN',
'            RETURN ''Viewing ALL companies (no restriction).'';',
'        END IF;',
'',
'        BEGIN',
'            SELECT company_name',
'            INTO   v_name',
'            FROM   ptw_pro.ptw_lv_companies',
'            WHERE  company_id = TO_NUMBER(v_override);',
'        EXCEPTION',
'            WHEN NO_DATA_FOUND THEN',
'                v_name := ''Unknown company (ID: '' || v_override || '')'';',
'        END;',
'',
'        RETURN ''Viewing as: '' || v_name;',
'    END;'))
,p_source_type=>'FUNCTION_BODY'
,p_source_language=>'PLSQL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(52495491439962713)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Apply Active Company'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    APEX_UTIL.SET_SESSION_STATE(''G_OVERRIDE_COMPANY_ID'', :P28_COMPANY_ID);',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(52495220439962711)
,p_process_success_message=>'Set new Active Company.'
,p_internal_uid=>52495491439962713
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(52495536478962714)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Clear Active Company'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    APEX_UTIL.SET_SESSION_STATE(''G_OVERRIDE_COMPANY_ID'', NULL);',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(52495371259962712)
,p_process_success_message=>'Cleared Company.'
,p_internal_uid=>52495536478962714
);
wwv_flow_imp.component_end;
end;
/
