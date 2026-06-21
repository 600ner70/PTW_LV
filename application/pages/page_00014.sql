prompt --application/pages/page_00014
begin
--   Manifest
--     PAGE: 00014
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
 p_id=>14
,p_name=>'Create PTW'
,p_alias=>'PTW-TYPES'
,p_page_mode=>'MODAL'
,p_step_title=>'Create PTW'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(40553413561170616)
,p_plug_name=>'PTW available types'
,p_title=>'PTW available types'
,p_icon_css_classes=>'fa-file-cabinet'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>50
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(40553741884170619)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>60
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(40553968345170621)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(40553741884170619)
,p_button_name=>'CREATE'
,p_button_static_id=>'P14_CREATE_BTN'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Go'
,p_button_position=>'NEXT'
,p_icon_css_classes=>'fa-play-circle-o'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(40553863773170620)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(40553741884170619)
,p_button_name=>'CANCEL'
,p_button_static_id=>'P14_CANCEL_BTN'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'PREVIOUS'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(40555114567170633)
,p_branch_name=>'Go to create a PTW'
,p_branch_action=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_PERMIT_ID,P2_WORKFLOW_STATUS:&P14_PERMIT_ID.,IN_PROGRESS'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40553272069170614)
,p_name=>'P14_PERMIT_ID'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40553335302170615)
,p_name=>'P14_WORKFLOW_STATUS'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40553683189170618)
,p_name=>'P14_PTW_TYPES'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(40553413561170616)
,p_prompt=>'Available types'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT t.type_desc d,',
'       t.ptw_type  r',
'FROM   ptw_pro.ptw_types t',
'JOIN   ptw_pro.ptw_lv_company_types ct ON ct.type_id = t.type_id',
'WHERE  t.available = ''Y''',
'AND    ct.is_active = ''Y''',
'AND    ct.company_id in (SELECT company_id',
'                         FROM   ptw_pro.ptw_lv_users',
'                         WHERE ((UPPER(username) = UPPER(v(''APP_USER''))',
'                         AND    is_super_user <> ''Y'')',
'                         OR     (company_id = :P14_COMPANY_ID)))',
'ORDER  BY t.type_desc'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select -'
,p_lov_cascade_parent_items=>'P14_COMPANY_ID'
,p_ajax_items_to_submit=>'P14_COMPANY_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(52465015239584447)
,p_name=>'P14_COMPANY_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(40553413561170616)
,p_prompt=>'Create permit for company'
,p_source=>'V(''G_OVERRIDE_COMPANY_ID'')'
,p_source_type=>'EXPRESSION'
,p_source_language=>'PLSQL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT company_name d,',
'       company_id   r',
'FROM   ptw_pro.ptw_lv_companies',
'WHERE  is_active = ''Y''',
'ORDER  BY company_name'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-- Select --'
,p_cHeight=>1
,p_display_when=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT 1 ',
'FROM ptw_pro.ptw_lv_users',
'WHERE UPPER(username) = UPPER(:APP_USER)',
'AND   is_super_user = ''Y''',
'AND   is_active = ''Y'''))
,p_display_when_type=>'EXISTS'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(40554911737170631)
,p_validation_name=>'PTW type required'
,p_validation_sequence=>10
,p_validation=>'P14_PTW_TYPES'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Please select a PTW type before continuing.'
,p_when_button_pressed=>wwv_flow_imp.id(40553968345170621)
,p_associated_item=>wwv_flow_imp.id(40553683189170618)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(52465166751584448)
,p_validation_name=>'Company required for Super User'
,p_validation_sequence=>20
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_count NUMBER;',
'BEGIN',
'    SELECT COUNT(*)',
'    INTO   l_count',
'    FROM   ptw_pro.ptw_lv_users',
'    WHERE  UPPER(username) = UPPER(:APP_USER)',
'    AND    is_super_user = ''Y''',
'    AND    is_active = ''Y'';',
'',
'    IF l_count > 0 AND :P14_COMPANY_ID IS NULL THEN',
'      RETURN ''Super User - Please select a company before continuing.'';',
'    END IF;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_ERR_TEXT'
,p_when_button_pressed=>wwv_flow_imp.id(40553968345170621)
,p_associated_item=>wwv_flow_imp.id(52465015239584447)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(40554251233170624)
,p_validation_name=>'Is an available PTW?'
,p_validation_sequence=>30
,p_validation=>':P14_PTW_TYPES = ''LV ISOLATION'''
,p_validation2=>'PLSQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>'PTW type is not currently available for this customer.'
,p_always_execute=>'Y'
,p_validation_condition=>'CREATE'
,p_validation_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(52494489024962703)
,p_name=>'Refresh PTW Types on Company Change'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P14_COMPANY_ID'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(52494668297962705)
,p_event_id=>wwv_flow_imp.id(52494489024962703)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'NULL;'
,p_attribute_02=>'P14_COMPANY_ID'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(52494565850962704)
,p_event_id=>wwv_flow_imp.id(52494489024962703)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P14_PTW_TYPES'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(52465285312584449)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set Company Override'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_count NUMBER;',
'BEGIN',
'    SELECT COUNT(*)',
'    INTO   l_count',
'    FROM   ptw_pro.ptw_lv_users',
'    WHERE  UPPER(username) = UPPER(:APP_USER)',
'    AND    is_super_user = ''Y''',
'    AND    is_active = ''Y'';',
'    ',
'    IF l_count > 0 THEN',
'        APEX_UTIL.SET_SESSION_STATE(''G_OVERRIDE_COMPANY_ID'', :P14_COMPANY_ID);',
'    END IF;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(40553968345170621)
,p_internal_uid=>52465285312584449
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(40554413173170626)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Back to Dashboard'
,p_attribute_02=>'N'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(40553863773170620)
,p_internal_uid=>40554413173170626
);
wwv_flow_imp.component_end;
end;
/
