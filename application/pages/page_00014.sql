prompt --application/pages/page_00014
begin
--   Manifest
--     PAGE: 00014
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.16'
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
,p_page_component_map=>'17'
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
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(40553413561170616)
,p_prompt=>'Available types'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT type_desc d,',
'       ptw_type  r',
'FROM   ptw_pro.ptw_types',
'WHERE  available = ''Y'';'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select -'
,p_cHeight=>1
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
 p_id=>wwv_flow_imp.id(40554251233170624)
,p_validation_name=>'Is an available PTW?'
,p_validation_sequence=>20
,p_validation=>':P14_PTW_TYPES = ''LV ISOLATION'''
,p_validation2=>'PLSQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>'PTW type is not currently available for this customer.'
,p_always_execute=>'Y'
,p_validation_condition=>'CREATE'
,p_validation_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
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
