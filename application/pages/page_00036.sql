prompt --application/pages/page_00036
begin
--   Manifest
--     PAGE: 00036
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
 p_id=>36
,p_name=>'Issue Authority to Work'
,p_alias=>'ISSUE-AUTHORITY-TO-WORK'
,p_step_title=>'Issue Authority to Work'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var atwSignaturePad;'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.signature-pad-container {',
'    border: 2px solid var(--ut-component-border-color, #d0d0d0);',
'    border-radius: 8px;',
'    background: #ffffff;',
'    padding: 10px;',
'    margin: 10px 0;',
'}',
'',
'.signature-pad {',
'    width: 100%;',
'    height: 150px;',
'    border: 1px dashed #ccc;',
'    border-radius: 4px;',
'    touch-action: none;',
'    cursor: crosshair;',
'}',
'',
'.signature-controls {',
'    display: flex;',
'    gap: 10px;',
'    margin-top: 10px;',
'    justify-content: flex-end;',
'}',
'',
'.signature-controls button {',
'    padding: 6px 12px;',
'    border-radius: 4px;',
'    border: 1px solid #d0d0d0;',
'    background: #f5f5f5;',
'    cursor: pointer;',
'    font-size: 0.875rem;',
'}',
'',
'.signature-controls button:hover {',
'    background: #e0e0e0;',
'}',
''))
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(57338469143019020)
,p_protection_level=>'C'
,p_read_only_when_type=>'EXPRESSION'
,p_read_only_when=>':P36_STATUS IS NOT NULL AND :P36_STATUS NOT IN (''DRAFT'', ''REQUESTED'')'
,p_read_only_when2=>'PLSQL'
,p_page_component_map=>'16'
,p_created_on=>wwv_flow_imp.dz('20261017173434Z')
,p_last_updated_on=>wwv_flow_imp.dz('20261103135732Z')
,p_created_by=>'PTW_PRO'
,p_last_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(57352537174381133)
,p_plug_name=>'Buttons'
,p_static_id=>'buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>90
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017183911Z')
,p_updated_on=>wwv_flow_imp.dz('20261017183912Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(57351651029381124)
,p_plug_name=>'Checks'
,p_static_id=>'checks'
,p_title=>'Checks before work starts'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>70
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017175708Z')
,p_updated_on=>wwv_flow_imp.dz('20261017175708Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(57350996750381117)
,p_plug_name=>'Contractor and site'
,p_static_id=>'contractor-and-site'
,p_title=>'Contractor and site'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>60
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017175708Z')
,p_updated_on=>wwv_flow_imp.dz('20261017175708Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(57352282056381130)
,p_plug_name=>'Signature'
,p_static_id=>'signature_1'
,p_title=>'Issued by'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>80
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="signature-pad-container">',
'  <canvas id="atwSignaturePad" class="signature-pad"></canvas>',
'  <div class="signature-controls">',
'    <button type="button" id="BTN_CLEAR_ATW_SIG"',
'            onclick="if (atwSignaturePad) { atwSignaturePad.clear(); apex.item(''P36_SIGNATURE_DATA'').setValue(''''); }">',
'      Clear</button>',
'  </div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017183911Z')
,p_updated_on=>wwv_flow_imp.dz('20261017183912Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(57351525419381123)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_imp.id(57350996750381117)
,p_button_name=>'ADD_CONTRACTOR'
,p_static_id=>'add-contractor'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Add Contractor'
,p_button_redirect_url=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:8::'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'Y'
,p_security_scheme=>wwv_flow_imp.id(26419849891144614)
,p_created_on=>wwv_flow_imp.dz('20261017175708Z')
,p_updated_on=>wwv_flow_imp.dz('20261017175708Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(57352691207381134)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(57352537174381133)
,p_button_name=>'CANCEL'
,p_static_id=>'cancel'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:35:&SESSION.::&DEBUG.:35::'
,p_warn_on_unsaved_changes=>null
,p_created_on=>wwv_flow_imp.dz('20261017183911Z')
,p_updated_on=>wwv_flow_imp.dz('20261017184624Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(57352711368381135)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(57352537174381133)
,p_button_name=>'CANCEL_ATW'
,p_static_id=>'cancel-atw'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel ATW'
,p_button_position=>'PREVIOUS'
,p_button_condition=>':P36_STATUS IN (''DRAFT'', ''REQUESTED'')'
,p_button_condition2=>'PLSQL'
,p_button_condition_type=>'EXPRESSION'
,p_created_on=>wwv_flow_imp.dz('20261017183911Z')
,p_updated_on=>wwv_flow_imp.dz('20261017184753Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(57352946202381137)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(57352537174381133)
,p_button_name=>'ISSUE'
,p_static_id=>'issue'
,p_button_static_id=>'BTN_ATW_ISSUE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Issue'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'NVL(:P36_STATUS, ''DRAFT'') IN (''DRAFT'', ''REQUESTED'')'
,p_button_condition2=>'PLSQL'
,p_button_condition_type=>'EXPRESSION'
,p_created_on=>wwv_flow_imp.dz('20261017183911Z')
,p_updated_on=>wwv_flow_imp.dz('20261017184731Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(57353026674381138)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_imp.id(57352537174381133)
,p_button_name=>'ISSUE_CHECK_IN'
,p_static_id=>'issue-check-in'
,p_button_static_id=>'BTN_ATW_ISSUE_CHECKIN'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Issue and check in'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'NVL(:P36_STATUS, ''DRAFT'') IN (''DRAFT'', ''REQUESTED'')'
,p_button_condition2=>'PLSQL'
,p_button_condition_type=>'EXPRESSION'
,p_created_on=>wwv_flow_imp.dz('20261017183911Z')
,p_updated_on=>wwv_flow_imp.dz('20261017184731Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(57352880657381136)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(57352537174381133)
,p_button_name=>'SAVE_DRAFT'
,p_static_id=>'save-draft'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Save Draft'
,p_button_position=>'NEXT'
,p_button_condition=>'NVL(:P36_STATUS, ''DRAFT'') IN (''DRAFT'', ''REQUESTED'')'
,p_button_condition2=>'PLSQL'
,p_button_condition_type=>'EXPRESSION'
,p_created_on=>wwv_flow_imp.dz('20261017183911Z')
,p_updated_on=>wwv_flow_imp.dz('20261017184731Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(57353877749381146)
,p_branch_name=>'Page 35'
,p_branch_action=>'f?p=&APP_ID.:35:&SESSION.::&DEBUG.:35::'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'REQUEST_IN_CONDITION'
,p_branch_condition=>'ISSUE, ISSUE_CHECK_IN, CANCEL_ATW'
,p_created_on=>wwv_flow_imp.dz('20261017183912Z')
,p_updated_on=>wwv_flow_imp.dz('20261017183912Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(57353974667381147)
,p_branch_name=>'Page 36'
,p_branch_action=>'f?p=&APP_ID.:36:&SESSION.::&DEBUG.:36:P36_ATW_ID:&P36_ATW_ID.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
,p_branch_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_branch_condition=>'SAVE_DRAFT'
,p_created_on=>wwv_flow_imp.dz('20261017183912Z')
,p_updated_on=>wwv_flow_imp.dz('20261017183912Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(57350618262381114)
,p_name=>'P36_ATW_ID'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017174112Z')
,p_updated_on=>wwv_flow_imp.dz('20261017174112Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(57351086453381118)
,p_name=>'P36_ATW_NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(57350996750381117)
,p_prompt=>'Authority Number'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017175708Z')
,p_updated_on=>wwv_flow_imp.dz('20261017175708Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(57351997341381127)
,p_name=>'P36_COMPETENCE_OK'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(57351651029381124)
,p_item_default=>'N'
,p_prompt=>'Competence checked'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Yes;Y,No;N'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-binary-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2',
  'page_action_on_selection', 'NONE')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017183911Z')
,p_updated_on=>wwv_flow_imp.dz('20261017183911Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(57352032197381128)
,p_name=>'P36_EQUIPMENT_PPE_OK'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(57351651029381124)
,p_item_default=>'N'
,p_prompt=>'Equipment and PPE checked'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Yes;Y,No;N'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-binary-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2',
  'page_action_on_selection', 'NONE')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017183911Z')
,p_updated_on=>wwv_flow_imp.dz('20261017183911Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(57351258242381120)
,p_name=>'P36_HOLDER_USER_ID'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(57350996750381117)
,p_prompt=>'Contractor'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT TRIM(u.first_name || '' '' || u.last_name)',
'       || CASE WHEN u.employer_name IS NOT NULL',
'               THEN '' - '' || u.employer_name END     AS d,',
'       u.user_id                                      AS r',
'FROM   ptw_pro.ptw_lv_users u',
'WHERE  u.is_active  = ''Y''',
'AND    u.company_id = ptw_pro.ptw_sec_pkg.get_effective_company_id',
'AND    ptw_pro.ptw_atw_pkg.is_contractor(u.username) = ''Y''',
'ORDER  BY 1'))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'case_sensitive', 'N',
  'display_as', 'POPUP',
  'fetch_on_search', 'N',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'match_type', 'CONTAINS',
  'min_chars', '0')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017175708Z')
,p_updated_on=>wwv_flow_imp.dz('20261017175708Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(57351774791381125)
,p_name=>'P36_INDUCTION_OK'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(57351651029381124)
,p_item_default=>'N'
,p_prompt=>'Site induction / orientation completed'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Yes;Y,No;N'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-binary-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2',
  'page_action_on_selection', 'NONE')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017175708Z')
,p_updated_on=>wwv_flow_imp.dz('20261017175708Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(57352363333381131)
,p_name=>'P36_ISSUER_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(57352282056381130)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT NVL(MAX(TRIM(first_name || '' '' || last_name)), :APP_USER)',
'FROM   ptw_pro.ptw_lv_users',
'WHERE  UPPER(username) = UPPER(:APP_USER)'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Name'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017183911Z')
,p_updated_on=>wwv_flow_imp.dz('20261017183911Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(57352140187381129)
,p_name=>'P36_ISSUER_NOTES'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(57351651029381124)
,p_prompt=>'Notes'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>1000
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017183911Z')
,p_updated_on=>wwv_flow_imp.dz('20261017183911Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(57351478850381122)
,p_name=>'P36_RAMS_REFERENCE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(57350996750381117)
,p_prompt=>'RAMS / safe system of work reference'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>500
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017175708Z')
,p_updated_on=>wwv_flow_imp.dz('20261017175708Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(57350870624381116)
,p_name=>'P36_SIGNATURE_DATA'
,p_item_sequence=>50
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017174112Z')
,p_updated_on=>wwv_flow_imp.dz('20261017185955Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(57351113562381119)
,p_name=>'P36_SITE_ID'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(57350996750381117)
,p_prompt=>'Site'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT site_name AS d,',
'       site_id   AS r',
'FROM   ptw_pro.ptw_lv_sites',
'WHERE  is_active = ''Y''',
'ORDER  BY site_name'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select Site -'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'case_sensitive', 'N',
  'display_as', 'POPUP',
  'fetch_on_search', 'N',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'match_type', 'CONTAINS',
  'min_chars', '0')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017175708Z')
,p_updated_on=>wwv_flow_imp.dz('20261103135732Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(57351855287381126)
,p_name=>'P36_SSOW_OK'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(57351651029381124)
,p_item_default=>'N'
,p_prompt=>'Safe system of work approved'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Yes;Y,No;N'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-binary-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2',
  'page_action_on_selection', 'NONE')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017183911Z')
,p_updated_on=>wwv_flow_imp.dz('20261017183911Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(57350773405381115)
,p_name=>'P36_STATUS'
,p_item_sequence=>40
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017174112Z')
,p_updated_on=>wwv_flow_imp.dz('20261017174112Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(57351365930381121)
,p_name=>'P36_WORK_DESCRIPTION'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(57350996750381117)
,p_prompt=>'Work to be carried out'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>500
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017175708Z')
,p_updated_on=>wwv_flow_imp.dz('20261017175708Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(57353332421381141)
,p_name=>'Issue click'
,p_static_id=>'issue-click'
,p_event_sequence=>20
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'#BTN_ATW_ISSUE, #BTN_ATW_ISSUE_CHECKIN'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_created_on=>wwv_flow_imp.dz('20261017183911Z')
,p_updated_on=>wwv_flow_imp.dz('20261017185225Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(57353425296381142)
,p_event_id=>wwv_flow_imp.id(57353332421381141)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'var request = this.triggeringElement.id === ''BTN_ATW_ISSUE_CHECKIN'' ? ''ISSUE_CHECK_IN'' : ''ISSUE'';',
    'var sig = atwSignaturePad ? atwSignaturePad.getDataURL() : '''';',
    '',
    'apex.message.clearErrors();',
    'if (!sig) {',
    '    apex.message.showErrors([{ type: ''error'', location: ''page'',',
    '                               message: ''Please sign before issuing.'', unsafe: false }]);',
    '} else {',
    '    apex.item(''P36_SIGNATURE_DATA'').setValue(sig);',
    '    apex.message.confirm(',
    '        ''Issue this Authority to Work? You are confirming all four checks have been done.'',',
    '        function (ok) { if (ok) { captureLocationThenSubmit(request); } });',
    '}')))).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017183911Z')
,p_updated_on=>wwv_flow_imp.dz('20261017185225Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(57353150993381139)
,p_name=>'On Page Load'
,p_static_id=>'on-page-load'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
,p_created_on=>wwv_flow_imp.dz('20261017183911Z')
,p_updated_on=>wwv_flow_imp.dz('20261017183911Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(57353246871381140)
,p_event_id=>wwv_flow_imp.id(57353150993381139)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'var isReadOnly = ['''', ''DRAFT'', ''REQUESTED''].indexOf(apex.item(''P36_STATUS'').getValue()) === -1;',
    '',
    'initPad(''atwSignaturePad'', ''P36_SIGNATURE_DATA'', function (pad) { atwSignaturePad = pad; });',
    '',
    '// Binary Y/N badges - same pattern as Pages 16 / 24 / 33 (ptw-global.css styles)',
    '(function () {',
    '    var BINARY_ITEMS = [''P36_INDUCTION_OK'', ''P36_SSOW_OK'', ''P36_COMPETENCE_OK'', ''P36_EQUIPMENT_PPE_OK''];',
    '    var BADGES = [',
    unistr('        { val: ''Y'', cls: ''binary-badge-yes'', label: ''\2713'' },'),
    unistr('        { val: ''N'', cls: ''binary-badge-no'',  label: ''\2717'' }'),
    '    ];',
    '',
    '    BINARY_ITEMS.forEach(function (itemName) {',
    '        var $fc = apex.jQuery(''#'' + itemName).closest(''.t-Form-fieldContainer'');',
    '        if ($fc.length === 0) { return; }',
    '        $fc.find(''.binary-badge-row'').remove();',
    '',
    '        var currentVal = apex.item(itemName).getValue() || '''';',
    '        var $row = apex.jQuery(''<div class="binary-badge-row"></div>'').attr(''data-item'', itemName);',
    '        BADGES.forEach(function (b) {',
    '            apex.jQuery(''<span></span>'')',
    '                .addClass(''binary-badge '' + b.cls)',
    '                .toggleClass(''cm-active'', currentVal === b.val)',
    '                .toggleClass(''binary-readonly'', isReadOnly)',
    '                .attr(''data-value'', b.val)',
    '                .text(b.label)',
    '                .appendTo($row);',
    '        });',
    '        $fc.find(''.t-Form-inputContainer'').append($row);',
    '    });',
    '',
    '    apex.jQuery(''.cm-binary-item .apex-item-grid'').hide();',
    '',
    '    apex.jQuery(document)',
    '        .off(''click.binarybadge36'')',
    '        .on(''click.binarybadge36'', ''.binary-badge:not(.binary-readonly)'', function () {',
    '            var $badge   = apex.jQuery(this);',
    '            var $row     = $badge.closest(''.binary-badge-row'');',
    '            var itemName = $row.attr(''data-item'');',
    '            apex.item(itemName).setValue($badge.attr(''data-value''));',
    '            $row.find(''.binary-badge'').removeClass(''cm-active'');',
    '            $badge.addClass(''cm-active'');',
    '        });',
    '}());',
    '',
    'if (isReadOnly) {',
    '    var c = document.getElementById(''atwSignaturePad'');',
    '    if (c) { c.style.pointerEvents = ''none''; c.style.opacity = ''0.6''; }',
    '    apex.jQuery(''#BTN_CLEAR_ATW_SIG'').hide();',
    '}')))).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017183911Z')
,p_updated_on=>wwv_flow_imp.dz('20261017183911Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(57353714126381145)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Cancel ATW'
,p_static_id=>'cancel-atw'
,p_process_sql_clob=>'ptw_pro.ptw_atw_pkg.cancel_atw(:P36_ATW_ID, ''Cancelled by issuer'');'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CANCEL_ATW'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_process_success_message=>'Authority to Work cancelled.'
,p_internal_uid=>57353714126381145
,p_created_on=>wwv_flow_imp.dz('20261017183912Z')
,p_updated_on=>wwv_flow_imp.dz('20261017183912Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(57352469507381132)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Fetch ATW'
,p_static_id=>'fetch-atw'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT site_id, holder_user_id, work_description, rams_reference,',
'       induction_ok, ssow_ok, competence_ok, equipment_ppe_ok,',
'       issuer_notes, status, atw_number',
'INTO   :P36_SITE_ID, :P36_HOLDER_USER_ID, :P36_WORK_DESCRIPTION, :P36_RAMS_REFERENCE,',
'       :P36_INDUCTION_OK, :P36_SSOW_OK, :P36_COMPETENCE_OK, :P36_EQUIPMENT_PPE_OK,',
'       :P36_ISSUER_NOTES, :P36_STATUS, :P36_ATW_NUMBER',
'FROM   ptw_pro.ptw_lv_atw_v',
'WHERE  atw_id = :P36_ATW_ID;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P36_ATW_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>57352469507381132
,p_created_on=>wwv_flow_imp.dz('20261017183911Z')
,p_updated_on=>wwv_flow_imp.dz('20261017183911Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(57353669631381144)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Issue ATW'
,p_static_id=>'issue-atw'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'ptw_pro.ptw_atw_pkg.issue_atw(',
'    p_atw_id         => :P36_ATW_ID,',
'    p_issuer_sig_b64 => :P36_SIGNATURE_DATA,',
'    p_latitude       => TO_NUMBER(:APP_LATITUDE),',
'    p_longitude      => TO_NUMBER(:APP_LONGITUDE),',
'    p_check_in_now   => CASE WHEN :REQUEST = ''ISSUE_CHECK_IN'' THEN ''Y'' ELSE ''N'' END);'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'ISSUE,ISSUE_CHECK_IN'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_process_success_message=>'Authority to Work issued.'
,p_internal_uid=>57353669631381144
,p_created_on=>wwv_flow_imp.dz('20261017183911Z')
,p_updated_on=>wwv_flow_imp.dz('20261017183911Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(57353554811381143)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save ATW'
,p_static_id=>'save-atw'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_id NUMBER := :P36_ATW_ID;',
'BEGIN',
'    ptw_pro.ptw_atw_pkg.save_draft(',
'        p_atw_id           => l_id,',
'        p_site_id          => :P36_SITE_ID,',
'        p_holder_user_id   => :P36_HOLDER_USER_ID,',
'        p_work_description => :P36_WORK_DESCRIPTION,',
'        p_rams_reference   => :P36_RAMS_REFERENCE,',
'        p_induction_ok     => :P36_INDUCTION_OK,',
'        p_ssow_ok          => :P36_SSOW_OK,',
'        p_competence_ok    => :P36_COMPETENCE_OK,',
'        p_equipment_ppe_ok => :P36_EQUIPMENT_PPE_OK,',
'        p_issuer_notes     => :P36_ISSUER_NOTES);',
'    :P36_ATW_ID := l_id;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'SAVE_DRAFT,ISSUE,ISSUE_CHECK_IN'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_process_success_message=>'Saved.'
,p_internal_uid=>57353554811381143
,p_created_on=>wwv_flow_imp.dz('20261017183911Z')
,p_updated_on=>wwv_flow_imp.dz('20261017183911Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
