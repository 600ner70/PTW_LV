prompt --application/pages/page_00034
begin
--   Manifest
--     PAGE: 00034
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.6'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_page.create_page(
 p_id=>34
,p_name=>'My Authority to Work'
,p_alias=>'MY-ATW'
,p_step_title=>'My Authority to Work'
,p_autocomplete_on_off=>'OFF'
,p_javascript_file_urls=>'#APP_FILES#ptw-atw#MIN#.js'
,p_css_file_urls=>'#APP_FILES#ptw-atw#MIN#.css'
,p_step_template=>2979075366320325194
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(57339334556030684)
,p_protection_level=>'C'
,p_page_component_map=>'25'
,p_created_on=>wwv_flow_imp.dz('20261017163111Z')
,p_last_updated_on=>wwv_flow_imp.dz('20261017191122Z')
,p_created_by=>'PTW_PRO'
,p_last_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(56991553371385731)
,p_plug_name=>'Actions'
,p_static_id=>'actions'
,p_region_css_classes=>'ptw-atw-actions'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>60
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P34_ATW_ID'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017170440Z')
,p_updated_on=>wwv_flow_imp.dz('20261017170441Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(56991482652385730)
,p_plug_name=>'Pass'
,p_static_id=>'pass'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>50
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    IF :P34_ATW_ID IS NULL THEN',
'        RETURN ''<div class="ptw-atw-empty">''',
'            || ''<span class="fa fa-id-card-o" aria-hidden="true"></span>''',
'            || ''<p>You have no Authority to Work for today.</p>''',
'            || ''<p>Ask the BGIS site contact to issue one when you arrive.</p>''',
'            || ''</div>'';',
'    END IF;',
'    RETURN ptw_pro.ptw_atw_pkg.render_pass(:P34_ATW_ID);',
'END;'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_ajax_items_to_submit=>'P34_ATW_ID'
,p_created_on=>wwv_flow_imp.dz('20261017170440Z')
,p_updated_on=>wwv_flow_imp.dz('20261017190942Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(56991713732385733)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(56991553371385731)
,p_button_name=>'CHECK_IN'
,p_static_id=>'check-in'
,p_button_static_id=>'BTN_ATW_CHECK_IN'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Check In'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>':P34_STATUS IN (''ISSUED'', ''CHECKED_OUT'')'
,p_button_condition2=>'PLSQL'
,p_button_condition_type=>'EXPRESSION'
,p_button_css_classes=>'fa-sign-in'
,p_grid_new_row=>'Y'
,p_created_on=>wwv_flow_imp.dz('20261017170440Z')
,p_updated_on=>wwv_flow_imp.dz('20261017170440Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(56991830393385734)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(56991553371385731)
,p_button_name=>'CHECK_OUT'
,p_static_id=>'check-out'
,p_button_static_id=>'BTN_ATW_CHECK_OUT'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Check Out'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>':P34_STATUS = ''ON_SITE'''
,p_button_condition2=>'PLSQL'
,p_button_condition_type=>'EXPRESSION'
,p_button_css_classes=>'fa-sign-out'
,p_grid_new_row=>'Y'
,p_created_on=>wwv_flow_imp.dz('20261017170440Z')
,p_updated_on=>wwv_flow_imp.dz('20261017170440Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(56991085379385726)
,p_name=>'P34_ATW_ID'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017170440Z')
,p_updated_on=>wwv_flow_imp.dz('20261017170440Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(56991164280385727)
,p_name=>'P34_STATUS'
,p_item_sequence=>40
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017170440Z')
,p_updated_on=>wwv_flow_imp.dz('20261017170440Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(56991271722385728)
,p_computation_sequence=>10
,p_computation_item=>'P34_ATW_ID'
,p_static_id=>'p34-atw-id'
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'EXPRESSION'
,p_computation_language=>'PLSQL'
,p_computation=>'ptw_pro.ptw_atw_pkg.get_today_atw_id(:APP_USER)'
,p_created_on=>wwv_flow_imp.dz('20261017170440Z')
,p_updated_on=>wwv_flow_imp.dz('20261017170440Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(56991391231385729)
,p_computation_sequence=>20
,p_computation_item=>'P34_STATUS'
,p_static_id=>'p34-status'
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT effective_status',
'FROM   ptw_pro.ptw_lv_atw_v',
'WHERE  atw_id = :P34_ATW_ID'))
,p_created_on=>wwv_flow_imp.dz('20261017170440Z')
,p_updated_on=>wwv_flow_imp.dz('20261017170440Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(56992190665385737)
,p_name=>' 2. Init pass'
,p_static_id=>'2-init-pass'
,p_event_sequence=>20
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
,p_created_on=>wwv_flow_imp.dz('20261017170440Z')
,p_updated_on=>wwv_flow_imp.dz('20261017170440Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(56992205092385738)
,p_event_id=>wwv_flow_imp.id(56992190665385737)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'ptwAtw.initPass(''atw-pass'', 60);')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017170440Z')
,p_updated_on=>wwv_flow_imp.dz('20261017170440Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(56991909327385735)
,p_name=>'Check in / out click'
,p_static_id=>'check-in-out-click'
,p_event_sequence=>10
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'#BTN_ATW_CHECK_IN, #BTN_ATW_CHECK_OUT'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_created_on=>wwv_flow_imp.dz('20261017170440Z')
,p_updated_on=>wwv_flow_imp.dz('20261017191122Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(56992000454385736)
,p_event_id=>wwv_flow_imp.id(56991909327385735)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'captureLocationThenSubmit(',
    '    this.triggeringElement.id === ''BTN_ATW_CHECK_IN'' ? ''CHECK_IN'' : ''CHECK_OUT''',
    ');')))).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017170440Z')
,p_updated_on=>wwv_flow_imp.dz('20261017170440Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(56992373545385739)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Check in'
,p_static_id=>'check-in'
,p_process_sql_clob=>'ptw_pro.ptw_atw_pkg.check_in(:P34_ATW_ID, TO_NUMBER(:APP_LATITUDE), TO_NUMBER(:APP_LONGITUDE));'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(56991713732385733)
,p_process_success_message=>'Checked in.'
,p_internal_uid=>56992373545385739
,p_created_on=>wwv_flow_imp.dz('20261017170440Z')
,p_updated_on=>wwv_flow_imp.dz('20261017170440Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(56992447329385740)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Check out'
,p_static_id=>'check-out'
,p_process_sql_clob=>'ptw_pro.ptw_atw_pkg.check_out(:P34_ATW_ID, TO_NUMBER(:APP_LATITUDE), TO_NUMBER(:APP_LONGITUDE));'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(56991830393385734)
,p_process_success_message=>'Checked out.'
,p_internal_uid=>56992447329385740
,p_created_on=>wwv_flow_imp.dz('20261017170440Z')
,p_updated_on=>wwv_flow_imp.dz('20261017170440Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
