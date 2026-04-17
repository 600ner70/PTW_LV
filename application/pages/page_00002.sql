prompt --application/pages/page_00002
begin
--   Manifest
--     PAGE: 00002
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.15'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_page.create_page(
 p_id=>2
,p_name=>'Site & Work Details'
,p_alias=>'SITE-WORK-DETAILS'
,p_step_title=>'Site & Work Details'
,p_autocomplete_on_off=>'OFF'
,p_javascript_file_urls=>'#APP_FILES#offline-storage#MIN#.js'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Update connection status UI',
'function updateConnectionUI() {',
'    const statusDiv = document.getElementById(''connection-status'');',
'    const statusIcon = document.getElementById(''status-icon'');',
'    const statusText = document.getElementById(''status-text'');',
'    ',
'    if (navigator.onLine) {',
'        statusDiv.style.backgroundColor = ''#d4edda'';',
unistr('        statusIcon.innerHTML = ''\2713'';'),
'        statusText.innerHTML = ''Connected'';',
'    } else {',
'        statusDiv.style.backgroundColor = ''#fff3cd'';',
unistr('        statusIcon.innerHTML = ''\26A0'';'),
'        statusText.innerHTML = ''Offline Mode'';',
'    }',
'}',
'',
'// Initial update',
'updateConnectionUI();',
'',
'// Listen for connection changes',
'window.addEventListener(''online'', updateConnectionUI);',
'window.addEventListener(''offline'', updateConnectionUI);',
'',
''))
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Initialize offline storage',
'OfflineStorage.initDB();',
'ConnectionManager.init();',
'',
'// Offline handler for NEXT_STEP button.',
'// Capture phase (true) fires before APEX''s bubble-phase DA,',
'// preventing the Execute PLSQL action from making an AJAX call that fails offline.',
'(function() {',
'    var btn = document.querySelector(''[data-otel-label="NEXT_STEP"]'');',
'    if (!btn) return;',
'    btn.addEventListener(''click'', function(e) {',
'        if (navigator.onLine) return;',
'        e.stopImmediatePropagation();',
'        e.preventDefault();',
'        var formData = {};',
'        apex.jQuery(''form'').serializeArray().forEach(function(i) { formData[i.name] = i.value; });',
'        OfflineStorage.saveFormData(''2'', formData, apex.jQuery(''#P2_PERMIT_ID'').val() || null)',
'            .then(function() {',
'                var u = new URL(window.location.href);',
'                var p = u.pathname.split(''/'');',
'                while (p[p.length - 1] === '''') p.pop();',
unistr('                // URL is /ords/r/app/page-alias/permit-id \2014 replace page-alias, keep permit-id'),
'                if (/^\d+$/.test(p[p.length - 1])) {',
'                    p[p.length - 2] = ''control-measures-ppe'';',
'                } else {',
'                    p[p.length - 1] = ''control-measures-ppe'';',
'                }',
'                u.pathname = p.join(''/'');',
'                u.search = '''';',
'                apex.message.showPageSuccess(''Data saved offline. Will sync when reconnected.'');',
'                setTimeout(function() { window.location.href = u.toString(); }, 800);',
'            })',
'            .catch(function(err) {',
'                apex.message.showErrors([{type:''error'',message:''Offline save error: ''+err.message}]);',
'            });',
'    }, true);',
'}());'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.ptw-workflow-progress {',
'    display: flex;',
'    justify-content: space-between;',
'    align-items: flex-start;',
'    margin: 2rem 0;',
'    padding: 1.5rem;',
'    background: var(--ut-component-background-color, #ffffff);',
'    border-radius: 8px;',
'    border: 1px solid var(--ut-component-border-color, #e0e0e0);',
'    position: relative;',
'}',
'',
'.ptw-workflow-progress::before {',
'    content: '''';',
'    position: absolute;',
'    top: 3rem;',
'    left: 3rem;',
'    right: 3rem;',
'    height: 2px;',
'    background: var(--ut-palette-neutral-300, #d0d0d0);',
'    z-index: 0;',
'}',
'',
'.workflow-step {',
'    display: flex;',
'    flex-direction: column;',
'    align-items: center;',
'    position: relative;',
'    z-index: 1;',
'    flex: 1;',
'    gap: 0.5rem;',
'}',
'',
'.step-icon {',
'    width: 48px;',
'    height: 48px;',
'    border-radius: 50%;',
'    background: var(--ut-component-background-color, #ffffff);',
'    border: 3px solid var(--ut-palette-neutral-300, #d0d0d0);',
'    display: flex;',
'    align-items: center;',
'    justify-content: center;',
'    font-weight: 600;',
'    font-size: 1.125rem;',
'    color: var(--ut-palette-neutral-500, #666666);',
'    transition: all 0.3s ease;',
'}',
'',
'.workflow-step.active .step-icon {',
'    background: #003366;',
'    border-color: #003366;',
'    color: #ffffff;',
'    box-shadow: 0 4px 8px rgba(0, 51, 102, 0.2);',
'}',
'',
'.workflow-step.completed .step-icon {',
'    background: var(--ut-palette-success, #3ea055);',
'    border-color: var(--ut-palette-success, #3ea055);',
'    color: #ffffff;',
'}',
'',
'.step-text {',
'    font-size: 0.875rem;',
'    text-align: center;',
'    color: var(--ut-palette-neutral-600, #595959);',
'    max-width: 100px;',
'    line-height: 1.3;',
'}',
'',
'.workflow-step.active .step-text {',
'    color: #003366;',
'    font-weight: 600;',
'}',
'',
'@media (max-width: 768px) {',
'    .ptw-workflow-progress {',
'        flex-wrap: wrap;',
'        gap: 1rem;',
'    }',
'    .workflow-step {',
'        flex-basis: 30%;',
'    }',
'    .ptw-workflow-progress::before {',
'        display: none;',
'    }',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_read_only_when=>'P2_WORKFLOW_STATUS'
,p_read_only_when2=>'IN_PROGRESS'
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(25229500348353135)
,p_plug_name=>'Workflow Status'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>60
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="ptw-workflow-progress">',
'    <div class="workflow-step active" data-step="1">',
'        <span class="step-icon">1</span>',
'        <span class="step-text">Site & Work Details</span>',
'    </div>',
'    <div class="workflow-step" data-step="2">',
'        <span class="step-icon">2</span>',
'        <span class="step-text">Control Measures</span>',
'    </div>',
'    <div class="workflow-step" data-step="3">',
'        <span class="step-icon">3</span>',
'        <span class="step-text">Equipment Isolation</span>',
'    </div>',
'    <div class="workflow-step" data-step="4">',
'        <span class="step-icon">4</span>',
'        <span class="step-text">Authorisation</span>',
'    </div>',
'    <div class="workflow-step" data-step="5">',
'        <span class="step-icon">5</span>',
'        <span class="step-text">Clearance</span>',
'    </div>',
'</div>',
''))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(25230364426353143)
,p_plug_name=>'Permit Information Badge'
,p_plug_display_sequence=>70
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="margin-bottom: 20px;">',
'    <span class="apex-badge" style="background-color: #3ea055; color: white; padding: 6px 16px; border-radius: 20px; font-weight: 600;">',
'        Permit: &P2_PERMIT_NUMBER.',
'    </span>',
'</div>',
''))
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P2_PERMIT_ID'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(25230494463353144)
,p_plug_name=>'Header Information'
,p_title=>'Permit Header Information'
,p_icon_css_classes=>'fa-file-text'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>80
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(25230894903353148)
,p_plug_name=>'Site & Work Details'
,p_title=>'Site & Work Details'
,p_icon_css_classes=>'fa-building'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>90
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(26943346862347704)
,p_plug_name=>'Client Permission'
,p_title=>'Client Permission'
,p_icon_css_classes=>'fa-check-square'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>100
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(26944035438347711)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>110
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27017146064886522)
,p_plug_name=>'SyncStatus'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>50
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div id="connection-status" style="padding: 10px; margin-bottom: 10px; border-radius: 4px;">',
'    <span id="status-icon"></span>',
'    <span id="status-text"></span>',
'    <!-- <button id="sync-btn" style="margin-left: 10px; display: none;">Sync Now</button> -->',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(26944216198347713)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(26944035438347711)
,p_button_name=>'SAVE_DRAFT'
,p_button_static_id=>'BTN_SAVE_DRAFT_P2'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Save Draft'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_security_scheme=>wwv_flow_imp.id(31533963716212424)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(26944315283347714)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(26944035438347711)
,p_button_name=>'NEXT_STEP'
,p_button_static_id=>'BTN_NEXT_STEP_P2'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Next Step'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-arrow-right'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(26944114711347712)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(26944035438347711)
,p_button_name=>'CANCEL'
,p_button_static_id=>'BTN_CANCEL_P2'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:2:P1_PERMIT_ID:&P2_PERMIT_ID.'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(26945737570347728)
,p_branch_name=>'Go to Control Measures'
,p_branch_action=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:3:P3_PERMIT_ID:&P2_PERMIT_ID.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_branch_condition=>'NEXT_STEP'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(26945667934347727)
,p_branch_name=>'Refresh Current Page'
,p_branch_action=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_PERMIT_ID:&P2_PERMIT_ID.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
,p_branch_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_branch_condition=>'SAVE_DRAFT'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(25229203963353132)
,p_name=>'P2_PERMIT_ID'
,p_item_sequence=>10
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(25229379255353133)
,p_name=>'P2_CURRENT_STEP'
,p_item_sequence=>20
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(25229474334353134)
,p_name=>'P2_WORKFLOW_STATUS'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(25230519318353145)
,p_name=>'P2_SAFETY_PROGRAMME_REF_NO'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(25230494463353144)
,p_prompt=>'Safety Programme Reference No.'
,p_placeholder=>'Enter reference number'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>100
,p_read_only_when=>'ptw_pro.ptw_lv_is_contract_support(V(''APP_USER'')) = ''Y'''
,p_read_only_when2=>'PLSQL'
,p_read_only_when_type=>'EXPRESSION'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(25230683508353146)
,p_name=>'P2_ISOLATION_DIAGRAM_SERIAL_NO'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(25230494463353144)
,p_prompt=>'Isolation & Earthing Diagram Serial No.'
,p_placeholder=>'Enter serial number'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>100
,p_read_only_when=>'ptw_pro.ptw_lv_is_contract_support(V(''APP_USER'')) = ''Y'''
,p_read_only_when2=>'PLSQL'
,p_read_only_when_type=>'EXPRESSION'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(25230756080353147)
,p_name=>'P2_PERMIT_NUMBER'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(25230978574353149)
,p_name=>'P2_SITE_DETAILS'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(25230894903353148)
,p_prompt=>'Site details and area of works'
,p_placeholder=>'Enter full site details and area of works'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>500
,p_cHeight=>3
,p_read_only_when=>'ptw_pro.ptw_lv_is_contract_support(V(''APP_USER'')) = ''Y'''
,p_read_only_when2=>'PLSQL'
,p_read_only_when_type=>'EXPRESSION'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(25231084779353150)
,p_name=>'P2_WORK_DESCRIPTION'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(25230894903353148)
,p_prompt=>'Description of work activity'
,p_placeholder=>'Describe the work activity to be carried out'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>2000
,p_cHeight=>3
,p_read_only_when=>'ptw_pro.ptw_lv_is_contract_support(V(''APP_USER'')) = ''Y'''
,p_read_only_when2=>'PLSQL'
,p_read_only_when_type=>'EXPRESSION'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26943083679347701)
,p_name=>'P2_PERSON_IN_CHARGE_NAME'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(25230894903353148)
,p_prompt=>'Name of Person in Charge'
,p_placeholder=>'Full name of person in charge'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_read_only_when=>'ptw_pro.ptw_lv_is_contract_support(V(''APP_USER'')) = ''Y'''
,p_read_only_when2=>'PLSQL'
,p_read_only_when_type=>'EXPRESSION'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26943152825347702)
,p_name=>'P2_SUPERVISING_COMPANY'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(25230894903353148)
,p_prompt=>'Company responsible for supervising the works'
,p_placeholder=>'Company name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_read_only_when=>'ptw_pro.ptw_lv_is_contract_support(V(''APP_USER'')) = ''Y'''
,p_read_only_when2=>'PLSQL'
,p_read_only_when_type=>'EXPRESSION'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26943296650347703)
,p_name=>'P2_OTHER_PERSONS_COUNT'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(25230894903353148)
,p_prompt=>'Number of other persons working under this Permit'
,p_placeholder=>'0'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_read_only_when=>'ptw_pro.ptw_lv_is_contract_support(V(''APP_USER'')) = ''Y'''
,p_read_only_when2=>'PLSQL'
,p_read_only_when_type=>'EXPRESSION'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26943471028347705)
,p_name=>'P2_CLIENT_PERMISSION_GRANTED'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(26943346862347704)
,p_prompt=>'Has the client granted permission for these works to proceed?'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Yes;Y,No;N'
,p_read_only_when=>'ptw_pro.ptw_lv_is_contract_support(V(''APP_USER'')) = ''Y'''
,p_read_only_when2=>'PLSQL'
,p_read_only_when_type=>'EXPRESSION'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26943599720347706)
,p_name=>'P2_AFFECTS_IT_SYSTEMS'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(26943346862347704)
,p_prompt=>'Will these works affect any IT or other business critical systems?'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Yes;Y,No;N'
,p_read_only_when=>'ptw_pro.ptw_lv_is_contract_support(V(''APP_USER'')) = ''Y'''
,p_read_only_when2=>'PLSQL'
,p_read_only_when_type=>'EXPRESSION'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26943672440347707)
,p_name=>'P2_IT_PERMISSION_GRANTED'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(26943346862347704)
,p_prompt=>'If ''Yes'' has permission been granted to proceed?'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Yes;Y,No;N'
,p_read_only_when=>'ptw_pro.ptw_lv_is_contract_support(V(''APP_USER'')) = ''Y'''
,p_read_only_when2=>'PLSQL'
,p_read_only_when_type=>'EXPRESSION'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(28347563310917048)
,p_name=>'P2_IS_CHANGED'
,p_item_sequence=>20
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(26944420328347715)
,p_validation_name=>'Site Details Required'
,p_validation_sequence=>10
,p_validation=>'P2_SITE_DETAILS'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Site details are required.'
,p_associated_item=>wwv_flow_imp.id(25230978574353149)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(26944589701347716)
,p_validation_name=>'Person in Charge Required'
,p_validation_sequence=>20
,p_validation=>'P2_PERSON_IN_CHARGE_NAME'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Name of Person in Charge is required.'
,p_associated_item=>wwv_flow_imp.id(26943083679347701)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(26944608190347717)
,p_validation_name=>'Client Permission Required'
,p_validation_sequence=>30
,p_validation=>'P2_CLIENT_PERMISSION_GRANTED'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Please indicate if the client has granted permission.'
,p_associated_item=>wwv_flow_imp.id(26943471028347705)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26943794986347708)
,p_name=>'Show/Hide IT Permission Question'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P2_AFFECTS_IT_SYSTEMS'
,p_condition_element=>'P2_AFFECTS_IT_SYSTEMS'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26943866082347709)
,p_event_id=>wwv_flow_imp.id(26943794986347708)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_IT_PERMISSION_GRANTED'
,p_client_condition_type=>'EQUALS'
,p_client_condition_element=>'P2_AFFECTS_IT_SYSTEMS'
,p_client_condition_expression=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26943911056347710)
,p_event_id=>wwv_flow_imp.id(26943794986347708)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_IT_PERMISSION_GRANTED'
,p_client_condition_type=>'EQUALS'
,p_client_condition_element=>'P2_AFFECTS_IT_SYSTEMS'
,p_client_condition_expression=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(28347379433917046)
,p_name=>'Click NEXT STEP'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(26944315283347714)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33349755492951411)
,p_event_id=>wwv_flow_imp.id(28347379433917046)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'captureLocationThenSubmit(''NEXT_STEP'');'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(33349958939951413)
,p_name=>'Click SAVE DRAFT'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(26944216198347713)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33350005327951414)
,p_event_id=>wwv_flow_imp.id(33349958939951413)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'captureLocationThenSubmit(''SAVE_DRAFT'');',
''))
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(26944820115347719)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save Permit Data (INSERT or UPDATE)'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_permit_id NUMBER;',
'    v_permit_number VARCHAR2(50);',
'BEGIN',
'    IF :P2_PERMIT_ID IS NULL THEN',
'        -- INSERT NEW PERMIT',
'        INSERT INTO ptw_pro.ptw_lv_permits (',
'            safety_programme_ref_no,',
'            ptw_type,',
'            isolation_diagram_serial_no,',
'            site_details,',
'            work_description,',
'            person_in_charge_name,',
'            supervising_company,',
'            other_persons_count,',
'            client_permission_granted,',
'            affects_it_systems,',
'            it_permission_granted,',
'            current_step,',
'            workflow_status,',
'            site_work_latitude,',
'            site_work_longitude,',
'            created_by',
'        ) VALUES (',
'            :P2_SAFETY_PROGRAMME_REF_NO,',
'            ''LV ISOLATION'',',
'            :P2_ISOLATION_DIAGRAM_SERIAL_NO,',
'            :P2_SITE_DETAILS,',
'            :P2_WORK_DESCRIPTION,',
'            :P2_PERSON_IN_CHARGE_NAME,',
'            :P2_SUPERVISING_COMPANY,',
'            :P2_OTHER_PERSONS_COUNT,',
'            :P2_CLIENT_PERMISSION_GRANTED,',
'            :P2_AFFECTS_IT_SYSTEMS,',
'            :P2_IT_PERMISSION_GRANTED,',
'            ''SITE_WORK_DETAILS'',',
'            ''IN_PROGRESS'',',
'            :APP_LATITUDE,',
'            :APP_LONGITUDE,',
'            NVL(V(''APP_USER''), USER)',
'        ) RETURNING permit_id, permit_number',
'          INTO v_permit_id, v_permit_number;',
'',
'        :P2_PERMIT_ID := v_permit_id;',
'        :P2_PERMIT_NUMBER := v_permit_number;',
'        :P2_CURRENT_STEP := ''SITE_WORK_DETAILS'';',
'        :P2_WORKFLOW_STATUS := ''IN_PROGRESS'';',
'',
'        apex_application.g_print_success_message :=',
'            ''Permit '' || v_permit_number || '' created successfully.'';',
'',
'    ELSE',
'      IF :P2_IS_CHANGED = ''Y'' THEN',
'        -- UPDATE EXISTING PERMIT',
'        UPDATE ptw_pro.ptw_lv_permits',
'        SET safety_programme_ref_no = :P2_SAFETY_PROGRAMME_REF_NO,',
'            ptw_type = ''LV ISOLATION'',',
'            isolation_diagram_serial_no = :P2_ISOLATION_DIAGRAM_SERIAL_NO,',
'            site_details = :P2_SITE_DETAILS,',
'            work_description = :P2_WORK_DESCRIPTION,',
'            person_in_charge_name = :P2_PERSON_IN_CHARGE_NAME,',
'            supervising_company = :P2_SUPERVISING_COMPANY,',
'            other_persons_count = :P2_OTHER_PERSONS_COUNT,',
'            client_permission_granted = :P2_CLIENT_PERMISSION_GRANTED,',
'            affects_it_systems = :P2_AFFECTS_IT_SYSTEMS,',
'            it_permission_granted = :P2_IT_PERMISSION_GRANTED,',
'            site_work_latitude = :APP_LATITUDE,',
'            site_work_longitude = :APP_LONGITUDE,',
'            modified_by = NVL(V(''APP_USER''), USER),',
'            modified_date = CURRENT_TIMESTAMP',
'        WHERE permit_id = :P2_PERMIT_ID;',
'',
'        IF SQL%ROWCOUNT = 0 THEN',
'            RAISE_APPLICATION_ERROR(-20001, ''Permit not found for update.'');',
'        END IF;',
'',
'        apex_application.g_print_success_message :=',
'            ''Permit '' || :P2_PERMIT_NUMBER || '' updated successfully.'';',
'      END IF;',
'    END IF;',
'',
'    COMMIT;',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_error.add_error(',
'            p_message => ''Error saving permit: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RAISE;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>':REQUEST IN (''SAVE_DRAFT'',''NEXT_STEP'')'
,p_process_when_type=>'EXPRESSION'
,p_process_when2=>'PLSQL'
,p_process_success_message=>'Permit saved successfully.'
,p_security_scheme=>wwv_flow_imp.id(31533963716212424)
,p_internal_uid=>26944820115347719
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(26944769422347718)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load Permit Data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'',
'  :P2_CURRENT_STEP := ''SITE_WORK_DETAILS'';',
'  ',
'    SELECT',
'        permit_number,',
'        current_step,',
'        workflow_status,',
'        safety_programme_ref_no,',
'        isolation_diagram_serial_no,',
'        site_details,',
'        work_description,',
'        person_in_charge_name,',
'        supervising_company,',
'        other_persons_count,',
'        client_permission_granted,',
'        affects_it_systems,',
'        it_permission_granted',
'    INTO',
'        :P2_PERMIT_NUMBER,',
'        :P2_CURRENT_STEP,',
'        :P2_WORKFLOW_STATUS,',
'        :P2_SAFETY_PROGRAMME_REF_NO,',
'        :P2_ISOLATION_DIAGRAM_SERIAL_NO,',
'        :P2_SITE_DETAILS,',
'        :P2_WORK_DESCRIPTION,',
'        :P2_PERSON_IN_CHARGE_NAME,',
'        :P2_SUPERVISING_COMPANY,',
'        :P2_OTHER_PERSONS_COUNT,',
'        :P2_CLIENT_PERMISSION_GRANTED,',
'        :P2_AFFECTS_IT_SYSTEMS,',
'        :P2_IT_PERMISSION_GRANTED',
'    FROM ptw_pro.ptw_lv_permits',
'    WHERE permit_id = :P2_PERMIT_ID;',
'',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        :P2_PERMIT_ID := NULL;',
'        :P2_WORKFLOW_STATUS := ''IN_PROGRESS'';',
'        apex_error.add_error(',
'            p_message => ''Permit not found.'',',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'    WHEN OTHERS THEN',
'        apex_error.add_error(',
'            p_message => ''Error loading permit: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P2_PERMIT_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>26944769422347718
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(30143717338642706)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Engineer Own Permit Check'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_is_engineer NUMBER;',
'    v_is_owner    NUMBER;',
'BEGIN',
'    SELECT COUNT(*) INTO v_is_engineer',
'    FROM   ptw_pro.ptw_lv_user_roles_v          -- changed',
'    WHERE  UPPER(username) = UPPER(V(''APP_USER''))',
'    AND    role_name = ''ENGINEER''',
'    AND    is_active = ''Y'';',
'',
'    IF v_is_engineer > 0 AND :P2_PERMIT_ID IS NOT NULL THEN  -- use correct Pn_PERMIT_ID per page',
'',
'        SELECT COUNT(*) INTO v_is_owner',
'        FROM   ptw_pro.ptw_lv_permits',
'        WHERE  permit_id = :P2_PERMIT_ID         -- use correct Pn_PERMIT_ID per page',
'        AND    UPPER(created_by) = UPPER(V(''APP_USER''));',
'',
'        IF v_is_owner = 0 THEN',
'            apex_error.add_error(',
'                p_message          => ''Access denied. You can only edit permits you have created.'',',
'                p_display_location => apex_error.c_inline_in_notification',
'            );',
'            apex_util.redirect_url(',
'                apex_page.get_url(p_page => 1)',
'            );',
'        END IF;',
'',
'    END IF;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P2_PERMIT_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>30143717338642706
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(27017024078886521)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SYNC_OFFLINE_DATA'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_data_json  CLOB := apex_application.g_x01;',
'    l_page_id    VARCHAR2(100) := apex_application.g_x02;',
'    l_record_id  NUMBER := apex_application.g_x03;  -- NULL = INSERT, value = UPDATE',
'    l_json       JSON_OBJECT_T;',
'    l_success    BOOLEAN := TRUE;',
'    l_message    VARCHAR2(4000);',
'BEGIN',
'    -- Parse JSON data',
'    l_json := JSON_OBJECT_T.parse(l_data_json);',
'    ',
'    BEGIN',
'        IF l_record_id IS NULL THEN',
'            -- INSERT new record',
'            INSERT INTO ptw_pro.ptw_lv_permits (',
'              safety_programme_ref_no,',
'              isolation_diagram_serial_no,',
'              site_details,',
'              work_description,',
'              person_in_charge_name,',
'              supervising_company,',
'              other_persons_count,',
'              client_permission_granted,',
'              affects_it_systems,',
'              it_permission_granted,',
'              current_step,',
'              workflow_status,',
'              site_work_latitude,',
'              site_work_longitude,',
'              created_by,',
'              created_date',
'            ) VALUES (',
'                l_json.get_string(''P2_SAFETY_PROGRAMME_REF_NO''),',
'                l_json.get_string(''P2_ISOLATION_DIAGRAM_SERIAL_NO''),',
'                l_json.get_string(''P2_SITE_DETAILS''),',
'                l_json.get_string(''P2_WORK_DESCRIPTION''),',
'                l_json.get_string(''P2_PERSON_IN_CHARGE_NAME''),',
'                l_json.get_string(''P2_SUPERVISING_COMPANY''),',
'                l_json.get_number(''P2_OTHER_PERSONS_COUNT''),',
'                l_json.get_string(''P2_CLIENT_PERMISSION_GRANTED''),',
'                l_json.get_string(''P2_AFFECTS_IT_SYSTEMS''),',
'                l_json.get_string(''P2_IT_PERMISSION_GRANTED''),',
'                ''SITE_WORK_DETAILS'',',
'                ''IN_PROGRESS'',',
'                l_json.get_number(''APP_LATITUDE''),',
'                l_json.get_number(''APP_LONGITUDE''),',
'                NVL(V(''APP_USER''), USER),',
'                SYSDATE',
'            );',
'            ',
'            l_message := ''Record created successfully'';',
'            ',
'        ELSE',
'            -- UPDATE existing record',
'            UPDATE ptw_pro.ptw_lv_permits',
'            SET safety_programme_ref_no      = l_json.get_string(''P2_SAFETY_PROGRAMME_REF_NO''),',
'                isolation_diagram_serial_no  = l_json.get_string(''P2_ISOLATION_DIAGRAM_SERIAL_NO''),',
'                site_details                 = l_json.get_string(''P2_SITE_DETAILS''),',
'                work_description             = l_json.get_string(''P2_WORK_DESCRIPTION''),',
'                person_in_charge_name        = l_json.get_string(''P2_PERSON_IN_CHARGE_NAME''),',
'                supervising_company          = l_json.get_string(''P2_SUPERVISING_COMPANY''),',
'                other_persons_count          = l_json.get_number(''P2_OTHER_PERSONS_COUNT''),',
'                client_permission_granted    = l_json.get_string(''P2_CLIENT_PERMISSION_GRANTED''),',
'                affects_it_systems           = l_json.get_string(''P2_AFFECTS_IT_SYSTEMS''),',
'                it_permission_granted        = l_json.get_string(''P2_IT_PERMISSION_GRANTED''),',
'                site_work_latitude           = l_json.get_number(''APP_LATITUDE''),',
'                site_work_longitude          = l_json.get_number(''APP_LONGITUDE''),',
'                modified_by                  = NVL(V(''APP_USER''), USER),',
'                modified_date                = SYSDATE',
'            WHERE permit_id = l_record_id;',
'            ',
'            l_message := ''Record updated successfully'';',
'        END IF;',
'        ',
'        COMMIT;',
'        ',
'    EXCEPTION WHEN OTHERS THEN',
'        l_success := FALSE;',
'        l_message := SQLERRM;',
'        ROLLBACK;',
'    END;',
'    ',
'    -- Return JSON response',
'    apex_json.open_object;',
'    apex_json.write(''success'', l_success);',
'    apex_json.write(''message'', l_message);',
'    apex_json.close_object;',
'    ',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'SYNC_OFFLINE_DATA'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_security_scheme=>wwv_flow_imp.id(31533963716212424)
,p_internal_uid=>27017024078886521
);
wwv_flow_imp.component_end;
end;
/
