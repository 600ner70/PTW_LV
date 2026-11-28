prompt --application/pages/page_00037
begin
--   Manifest
--     PAGE: 00037
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
 p_id=>37
,p_name=>'Verify ATW'
,p_alias=>'ATW-VERIFY'
,p_step_title=>'Verify ATW'
,p_autocomplete_on_off=>'OFF'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#APP_FILES#ptw-atw#MIN#.js',
'#APP_FILES#jsQR.min.js'))
,p_css_file_urls=>'#APP_FILES#ptw-atw#MIN#.css'
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(57338820634024934)
,p_page_component_map=>'25'
,p_created_on=>wwv_flow_imp.dz('20261018113401Z')
,p_last_updated_on=>wwv_flow_imp.dz('20261018125942Z')
,p_created_by=>'PTW_PRO'
,p_last_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(57453103191967807)
,p_plug_name=>'Manual Entry'
,p_static_id=>'manual-entry'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>110
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_display_condition_type=>'ITEM_IS_NULL'
,p_plug_display_when_condition=>'P37_ATW_ID'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261018122218Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122219Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(57452947155967805)
,p_plug_name=>'Not Found'
,p_static_id=>'not-found'
,p_region_template_options=>'#DEFAULT#:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--danger'
,p_plug_template=>2040683448887306517
,p_plug_display_sequence=>90
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>'No Authority to Work matches this code. Check the number, or ask the BGIS site contact.'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P37_NOT_FOUND'
,p_plug_display_when_cond2=>'Y'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261018122218Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122219Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(57453277123967808)
,p_plug_name=>'Result'
,p_static_id=>'result'
,p_region_name=>'atw-result'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>120
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>'RETURN ptw_pro.ptw_atw_pkg.render_pass(:P37_ATW_ID);'
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_ajax_items_to_submit=>'P37_ATW_ID'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P37_ATW_ID'
,p_created_on=>wwv_flow_imp.dz('20261018122218Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122219Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(57453429545967810)
,p_plug_name=>'Revoke dialog'
,p_static_id=>'revoke-dialog'
,p_title=>'Revoke Authority to Work'
,p_region_name=>'revoke-dlg'
,p_region_template_options=>'#DEFAULT#:js-dialog-size600x400'
,p_plug_template=>2672673746673652531
,p_plug_display_sequence=>150
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261018122218Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122219Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(57453098188967806)
,p_plug_name=>'Scanner'
,p_static_id=>'scanner'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>100
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="ptw-atw-scanner">',
'  <video id="atw-video" playsinline muted></video>',
'  <div class="ptw-atw-scanner-frame"></div>',
'</div>',
'<p id="atw-scan-msg" class="ptw-atw-scanner-msg">Starting camera...</p>'))
,p_plug_display_condition_type=>'ITEM_IS_NULL'
,p_plug_display_when_condition=>'P37_ATW_ID'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261018122218Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122219Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(57453383467967809)
,p_plug_name=>'Staff actions'
,p_static_id=>'staff-actions'
,p_region_css_classes=>'ptw-atw-actions'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>130
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P37_ATW_ID'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261018122218Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122219Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(57453606990967812)
,p_button_sequence=>140
,p_button_plug_id=>wwv_flow_imp.id(57453383467967809)
,p_button_name=>'CHECK_IN_FOR'
,p_static_id=>'check-in-for'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Check in for them'
,p_button_position=>'NEXT'
,p_button_condition=>':P37_STATUS IN (''ISSUED'', ''CHECKED_OUT'')'
,p_button_condition2=>'PLSQL'
,p_button_condition_type=>'EXPRESSION'
,p_security_scheme=>wwv_flow_imp.id(57338469143019020)
,p_created_on=>wwv_flow_imp.dz('20261018122218Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122218Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(57453763504967813)
,p_button_sequence=>150
,p_button_plug_id=>wwv_flow_imp.id(57453383467967809)
,p_button_name=>'CHECK_OUT_FOR'
,p_static_id=>'check-out-for'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Check out for them'
,p_button_position=>'NEXT'
,p_button_condition=>':P37_STATUS = ''ON_SITE'''
,p_button_condition2=>'PLSQL'
,p_button_condition_type=>'EXPRESSION'
,p_security_scheme=>wwv_flow_imp.id(57338469143019020)
,p_created_on=>wwv_flow_imp.dz('20261018122218Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122218Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(57454039264967816)
,p_button_sequence=>90
,p_button_plug_id=>wwv_flow_imp.id(57453429545967810)
,p_button_name=>'CONFIRM_REVOKE'
,p_static_id=>'confirm-revoke'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Revoke'
,p_button_position=>'NEXT'
,p_security_scheme=>wwv_flow_imp.id(57338469143019020)
,p_created_on=>wwv_flow_imp.dz('20261018122218Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122218Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(57453531193967811)
,p_button_sequence=>80
,p_button_plug_id=>wwv_flow_imp.id(57453103191967807)
,p_button_name=>'FIND'
,p_static_id=>'find'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Find'
,p_button_position=>'NEXT'
,p_created_on=>wwv_flow_imp.dz('20261018122218Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122218Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(57453858254967814)
,p_button_sequence=>160
,p_button_plug_id=>wwv_flow_imp.id(57453383467967809)
,p_button_name=>'REVOKE'
,p_static_id=>'revoke'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Revoke'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>':P37_STATUS IN (''ISSUED'', ''ON_SITE'', ''CHECKED_OUT'')'
,p_button_condition2=>'PLSQL'
,p_button_condition_type=>'EXPRESSION'
,p_security_scheme=>wwv_flow_imp.id(57338469143019020)
,p_created_on=>wwv_flow_imp.dz('20261018122218Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122218Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(57453900209967815)
,p_button_sequence=>170
,p_button_plug_id=>wwv_flow_imp.id(57453383467967809)
,p_button_name=>'SCAN_ANOTHER'
,p_static_id=>'scan-another'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Scan Another'
,p_button_position=>'NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:37:&SESSION.::&DEBUG.:37::'
,p_warn_on_unsaved_changes=>null
,p_created_on=>wwv_flow_imp.dz('20261018122218Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122218Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(57455047683967826)
,p_branch_name=>'All requests'
,p_branch_action=>'f?p=&APP_ID.:37:&SESSION.::&DEBUG.:::'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_created_on=>wwv_flow_imp.dz('20261018122219Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122219Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(57354141172381149)
,p_name=>'P37_ATW_ID'
,p_item_sequence=>40
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261018122218Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122218Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(57452606294967802)
,p_name=>'P37_ATW_NUMBER'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(57453103191967807)
,p_prompt=>'Or enter the ATW number'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261018122218Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122218Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(57452523885967801)
,p_name=>'P37_NOT_FOUND'
,p_item_sequence=>60
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261018122218Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122218Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(57452753856967803)
,p_name=>'P37_REVOKE_REASON'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(57453429545967810)
,p_prompt=>'Reason'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261018122218Z')
,p_updated_on=>wwv_flow_imp.dz('20261018125942Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(57354240628381150)
,p_name=>'P37_STATUS'
,p_item_sequence=>50
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261018122218Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122218Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(57354090211381148)
,p_name=>'P37_TOKEN'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261018122218Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122218Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(57455190346967827)
,p_validation_name=>'Revoke reason required'
,p_static_id=>'revoke-reason-required'
,p_validation_sequence=>10
,p_validation=>'P37_REVOKE_REASON'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Record the reason for revoking.'
,p_when_button_pressed=>wwv_flow_imp.id(57454039264967816)
,p_associated_item=>wwv_flow_imp.id(57452753856967803)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20261018125942Z')
,p_updated_on=>wwv_flow_imp.dz('20261018125942Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(57454371958967819)
,p_name=>'Open revoke dialog'
,p_static_id=>'open-revoke-dialog'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(57453858254967814)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_created_on=>wwv_flow_imp.dz('20261018122218Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122219Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(57454451352967820)
,p_event_id=>wwv_flow_imp.id(57454371958967819)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-open-region'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(57453429545967810)
,p_created_on=>wwv_flow_imp.dz('20261018122219Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122219Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(57454154671967817)
,p_name=>'Start scanner'
,p_static_id=>'start-scanner'
,p_event_sequence=>10
,p_condition_element=>'P37_ATW_ID'
,p_triggering_condition_type=>'NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
,p_created_on=>wwv_flow_imp.dz('20261018122218Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122218Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(57454252389967818)
,p_event_id=>wwv_flow_imp.id(57454154671967817)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'ptwAtw.initScanner(''atw-video'', ''atw-scan-msg'', ''P37_TOKEN'', ''VERIFY'');')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261018122218Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122218Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(57454795195967823)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Check in for them'
,p_static_id=>'check-in-for-them'
,p_process_sql_clob=>'ptw_pro.ptw_atw_pkg.check_in(:P37_ATW_ID);'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CHECK_IN_FOR'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_process_success_message=>'Checked in.'
,p_internal_uid=>57454795195967823
,p_created_on=>wwv_flow_imp.dz('20261018122219Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122219Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(57454876267967824)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Check out for them'
,p_static_id=>'check-out-for-them'
,p_process_sql_clob=>'ptw_pro.ptw_atw_pkg.check_out(:P37_ATW_ID);'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CHECK_OUT_FOR'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_process_success_message=>'Checked out.'
,p_internal_uid=>57454876267967824
,p_created_on=>wwv_flow_imp.dz('20261018122219Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122219Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(57452874846967804)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Look up ATW'
,p_static_id=>'look-up-atw'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_token VARCHAR2(100);',
'BEGIN',
'    :P37_ATW_ID    := NULL;',
'    :P37_STATUS    := NULL;',
'    :P37_NOT_FOUND := NULL;',
'',
'    IF :P37_TOKEN IS NOT NULL THEN',
'        l_token := :P37_TOKEN;',
'    ELSIF :P37_ATW_NUMBER IS NOT NULL THEN',
'        SELECT MAX(verify_token)',
'        INTO   l_token',
'        FROM   ptw_pro.ptw_lv_atw_v',
'        WHERE  atw_number = UPPER(TRIM(:P37_ATW_NUMBER));',
'    ELSE',
'        RETURN;                         -- nothing yet: show the scanner',
'    END IF;',
'',
'    IF l_token IS NOT NULL THEN',
'        :P37_ATW_ID := ptw_pro.ptw_atw_pkg.verify_scan(l_token);   -- also logs VERIFIED',
'    END IF;',
'',
'    IF :P37_ATW_ID IS NULL THEN',
'        :P37_NOT_FOUND := ''Y'';',
'    ELSE',
'        SELECT effective_status',
'        INTO   :P37_STATUS',
'        FROM   ptw_pro.ptw_lv_atw_v',
'        WHERE  atw_id = :P37_ATW_ID;',
'    END IF;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>57452874846967804
,p_created_on=>wwv_flow_imp.dz('20261018122219Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122219Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(57454964794967825)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Revoke'
,p_static_id=>'revoke'
,p_process_sql_clob=>'ptw_pro.ptw_atw_pkg.revoke_atw(:P37_ATW_ID, :P37_REVOKE_REASON);'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CONFIRM_REVOKE'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_process_success_message=>'Authority to Work revoked. The holder has been notified.'
,p_internal_uid=>57454964794967825
,p_created_on=>wwv_flow_imp.dz('20261018122219Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122219Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(57454691963967822)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Use scanned code'
,p_static_id=>'use-scanned-code'
,p_process_sql_clob=>':P37_ATW_NUMBER := NULL;'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'VERIFY'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_internal_uid=>57454691963967822
,p_created_on=>wwv_flow_imp.dz('20261018122219Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122219Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(57454518173967821)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Use typed number'
,p_static_id=>'use-typed-number'
,p_process_sql_clob=>':P37_TOKEN := NULL;'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'FIND'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_internal_uid=>57454518173967821
,p_created_on=>wwv_flow_imp.dz('20261018122219Z')
,p_updated_on=>wwv_flow_imp.dz('20261018122219Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
