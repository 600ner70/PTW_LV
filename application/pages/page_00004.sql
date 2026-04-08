prompt --application/pages/page_00004
begin
--   Manifest
--     PAGE: 00004
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
 p_id=>4
,p_name=>'Equipment Isolation'
,p_alias=>'EQUIPMENT-ISOLATION'
,p_step_title=>'Equipment Isolation'
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
'        OfflineStorage.saveFormData(''4'', formData, apex.jQuery(''#P4_PERMIT_ID'').val() || null)',
'            .then(function() {',
'                var u = new URL(window.location.href);',
'                var p = u.pathname.split(''/'');',
'                while (p[p.length - 1] === '''') p.pop();',
'                if (/^\d+$/.test(p[p.length - 1])) {',
'                    p[p.length - 2] = ''authorisation-acceptance'';',
'                } else {',
'                    p[p.length - 1] = ''authorisation-acceptance'';',
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
'',
'.isolation-table {',
'    width: 100%;',
'    border-collapse: collapse;',
'    margin: 10px 0;',
'}',
'',
'.isolation-table th {',
'    background: #003366;',
'    color: white;',
'    padding: 10px 15px;',
'    text-align: left;',
'    font-weight: 600;',
'}',
'',
'.isolation-table td {',
'    padding: 8px 15px;',
'    border-bottom: 1px solid #e0e0e0;',
'}',
'',
'.isolation-table tr:nth-child(even) {',
'    background: #f8f9fa;',
'}',
'',
'.row-number {',
'    width: 40px;',
'    text-align: center;',
'    font-weight: 600;',
'    color: #003366;',
'}',
'',
''))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_read_only_when=>'P4_WORKFLOW_STATUS'
,p_read_only_when2=>'IN_PROGRESS'
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27017411932886525)
,p_plug_name=>'SyncStatus'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>130
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
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27017917969886530)
,p_plug_name=>'Workflow Status'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>140
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="ptw-workflow-progress">',
'    <div class="workflow-step completed" data-step="1">',
'        <span class="step-icon">&#10003;</span>',
'        <span class="step-text">Site & Work Details</span>',
'    </div>',
'    <div class="workflow-step completed" data-step="2">',
'        <span class="step-icon">&#10003;</span>',
'        <span class="step-text">Control Measures</span>',
'    </div>',
'    <div class="workflow-step active" data-step="3">',
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
'',
''))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27018145295886532)
,p_plug_name=>'Permit Information Badge'
,p_plug_display_sequence=>150
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="margin-bottom: 20px;">',
'    <span class="apex-badge" style="background-color: #3ea055; color: white; padding: 6px 16px; border-radius: 20px; font-weight: 600;">',
'        Permit: &P4_PERMIT_NUMBER.',
'    </span>',
'</div>'))
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P4_PERMIT_NUMBER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27018342698886534)
,p_plug_name=>'Equipment Isolation Table'
,p_title=>'Equipment Isolation Details'
,p_icon_css_classes=>'fa-lock'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>170
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27019604951886547)
,p_plug_name=>'Comments'
,p_title=>'Comments and References'
,p_icon_css_classes=>'fa-comment'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>180
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27019835346886549)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>190
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(27353028511033401)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(27019835346886549)
,p_button_name=>'SAVE_DRAFT'
,p_button_static_id=>'BTN_SAVE_DRAFT_P4'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Save Draft'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_security_scheme=>wwv_flow_imp.id(31533963716212424)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(27353109498033402)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(27019835346886549)
,p_button_name=>'NEXT_STEP'
,p_button_static_id=>'BTN_NEXT_STEP_P4'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Next Step'
,p_button_position=>'NEXT'
,p_icon_css_classes=>'fa-arrow-right'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(27019975461886550)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(27019835346886549)
,p_button_name=>'BACK'
,p_button_static_id=>'BTN_BACK_P4'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Back'
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:3:P3_PERMIT_ID:&P4_PERMIT_ID.'
,p_icon_css_classes=>'fa-arrow-left'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(27353640786033407)
,p_branch_name=>'Refresh Current Page (SAVE_DRAFT)'
,p_branch_action=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:4:P4_PERMIT_ID:&P4_PERMIT_ID.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_branch_condition=>'SAVE_DRAFT'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(27355396888033424)
,p_branch_name=>'Go to Authorisation (NEXT_STEP)'
,p_branch_action=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5:P5_PERMIT_ID:&P4_PERMIT_ID.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
,p_branch_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_branch_condition=>'NEXT_STEP'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27016408036886515)
,p_name=>'P4_PERMIT_ID'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27016543785886516)
,p_name=>'P4_PERMIT_NUMBER'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27016635165886517)
,p_name=>'P4_WORKFLOW_STATUS'
,p_item_sequence=>50
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27016711172886518)
,p_name=>'P4_NEXT_STEP'
,p_item_sequence=>60
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27017550498886526)
,p_name=>'P4_ISO_1_ID'
,p_item_sequence=>90
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27017612768886527)
,p_name=>'P4_ISO_2_ID'
,p_item_sequence=>100
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27017746971886528)
,p_name=>'P4_ISO_3_ID'
,p_item_sequence=>110
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27017866743886529)
,p_name=>'P4_ISO_4_ID'
,p_item_sequence=>120
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27018057140886531)
,p_name=>'P4_CURRENT_STEP'
,p_item_sequence=>70
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27018457939886535)
,p_name=>'P4_ISO_1_EQUIPMENT'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(27018342698886534)
,p_prompt=>'Equipment Isolated (Row 1)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_colspan=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27018568710886536)
,p_name=>'P4_ISO_1_MEANS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(27018342698886534)
,p_prompt=>'Means of Isolation (Row 1)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_begin_on_new_line=>'N'
,p_colspan=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27018618101886537)
,p_name=>'P4_ISO_1_LOCK_NO'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(27018342698886534)
,p_prompt=>'Safety Lock No. (Row 1)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>50
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27018795561886538)
,p_name=>'P4_ISO_2_EQUIPMENT'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(27018342698886534)
,p_prompt=>'Equipment Isolated (Row 2)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_colspan=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27018813428886539)
,p_name=>'P4_ISO_2_MEANS'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(27018342698886534)
,p_prompt=>'Means of Isolation (Row 2)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_begin_on_new_line=>'N'
,p_colspan=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27018963903886540)
,p_name=>'P4_ISO_2_LOCK_NO'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(27018342698886534)
,p_prompt=>'Safety Lock No. (Row 2)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>50
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27019093609886541)
,p_name=>'P4_ISO_3_EQUIPMENT'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(27018342698886534)
,p_prompt=>'Equipment Isolated (Row 3)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_colspan=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27019124716886542)
,p_name=>'P4_ISO_3_MEANS'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(27018342698886534)
,p_prompt=>'Means of Isolation (Row 3)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_begin_on_new_line=>'N'
,p_colspan=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27019250959886543)
,p_name=>'P4_ISO_3_LOCK_NO'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(27018342698886534)
,p_prompt=>'Safety Lock No. (Row 3)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>50
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27019329194886544)
,p_name=>'P4_ISO_4_EQUIPMENT'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(27018342698886534)
,p_prompt=>'Equipment Isolated (Row 4)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_colspan=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27019475030886545)
,p_name=>'P4_ISO_4_MEANS'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(27018342698886534)
,p_prompt=>'Means of Isolation (Row 4)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_begin_on_new_line=>'N'
,p_colspan=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27019534738886546)
,p_name=>'P4_ISO_4_LOCK_NO'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(27018342698886534)
,p_prompt=>'Safety Lock No. (Row 4)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>50
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27019719187886548)
,p_name=>'P4_COMMENTS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(27019604951886547)
,p_prompt=>'Comments and references to associated safety documentation, including risk assessments, method statements and other permits. '
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>4000
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'N',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30143438995642703)
,p_name=>'P4_IS_CHANGED'
,p_item_sequence=>80
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(27353229062033403)
,p_validation_name=>'Permit ID Required'
,p_validation_sequence=>10
,p_validation=>'P4_PERMIT_ID'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Permit ID is required.'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(30158963221375313)
,p_name=>'Capture Location and Submit page'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(27353109498033402)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30159344777375310)
,p_event_id=>wwv_flow_imp.id(30158963221375313)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_IS_CHANGED'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'captureLocationThenSubmit(''NEXT_STEP'');',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(33350285133951416)
,p_name=>'Capture Location and Save Draft'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(27353028511033401)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33350358017951417)
,p_event_id=>wwv_flow_imp.id(33350285133951416)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'captureLocationThenSubmit(''SAVE_DRAFT'');'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(27353441963033405)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save Equipment Isolation and Comments'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    -- Helper procedure to save one isolation row',
'    PROCEDURE save_isolation_row(',
'        p_iso_id     IN OUT NUMBER,',
'        p_permit_id  IN NUMBER,',
'        p_row_num    IN NUMBER,',
'        p_equipment  IN VARCHAR2,',
'        p_means      IN VARCHAR2,',
'        p_lock_no    IN VARCHAR2',
'    ) IS',
'    BEGIN',
'        -- Only save if any data entered',
'        IF p_equipment IS NOT NULL OR p_means IS NOT NULL OR p_lock_no IS NOT NULL THEN',
'            IF p_iso_id IS NULL THEN',
'                -- INSERT',
'                INSERT INTO ptw_pro.ptw_lv_equipment_isolation (',
'                    permit_id, row_number, equipment_isolated, means_of_isolation, safety_lock_no',
'                ) VALUES (',
'                    p_permit_id, p_row_num, p_equipment, p_means, p_lock_no',
'                ) RETURNING isolation_id INTO p_iso_id;',
'            ELSIF :P4_IS_CHANGED = ''Y'' THEN',
'                -- UPDATE',
'                UPDATE ptw_pro.ptw_lv_equipment_isolation',
'                SET equipment_isolated = p_equipment,',
'                    means_of_isolation = p_means,',
'                    safety_lock_no = p_lock_no,',
'                    modified_date = CURRENT_TIMESTAMP',
'                WHERE isolation_id = p_iso_id;',
'            END IF;',
'        ELSIF p_iso_id IS NOT NULL THEN',
'            -- All fields cleared - delete the row',
'            DELETE FROM ptw_pro.ptw_lv_equipment_isolation',
'            WHERE isolation_id = p_iso_id;',
'            p_iso_id := NULL;',
'        END IF;',
'    END save_isolation_row;',
'',
'BEGIN',
'    -- Save each isolation row',
'    save_isolation_row(:P4_ISO_1_ID, :P4_PERMIT_ID, 1, :P4_ISO_1_EQUIPMENT, :P4_ISO_1_MEANS, :P4_ISO_1_LOCK_NO);',
'    save_isolation_row(:P4_ISO_2_ID, :P4_PERMIT_ID, 2, :P4_ISO_2_EQUIPMENT, :P4_ISO_2_MEANS, :P4_ISO_2_LOCK_NO);',
'    save_isolation_row(:P4_ISO_3_ID, :P4_PERMIT_ID, 3, :P4_ISO_3_EQUIPMENT, :P4_ISO_3_MEANS, :P4_ISO_3_LOCK_NO);',
'    save_isolation_row(:P4_ISO_4_ID, :P4_PERMIT_ID, 4, :P4_ISO_4_EQUIPMENT, :P4_ISO_4_MEANS, :P4_ISO_4_LOCK_NO);',
'',
'    -- Save comments on permits table',
'    UPDATE ptw_pro.ptw_lv_permits',
'    SET comments = :P4_COMMENTS,',
'        current_step = :P4_CURRENT_STEP,',
'        equip_iso_latitude = :APP_LATITUDE,',
'        equip_iso_longitude = :APP_LONGITUDE,',
'        modified_by = NVL(V(''APP_USER''), USER),',
'        modified_date = CURRENT_TIMESTAMP',
'    WHERE permit_id = :P4_PERMIT_ID;',
'',
'    COMMIT;',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_error.add_error(',
'            p_message => ''Error saving equipment isolation data: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RAISE;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Equipment isolation data saved successfully.'
,p_security_scheme=>wwv_flow_imp.id(31533963716212424)
,p_internal_uid=>27353441963033405
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(30143977664642708)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
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
'    IF v_is_engineer > 0 AND :P4_PERMIT_ID IS NOT NULL THEN  -- use correct Pn_PERMIT_ID per page',
'',
'        SELECT COUNT(*) INTO v_is_owner',
'        FROM   ptw_pro.ptw_lv_permits',
'        WHERE  permit_id = :P4_PERMIT_ID         -- use correct Pn_PERMIT_ID per page',
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
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P4_PERMIT_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>30143977664642708
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(27353350362033404)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load Equipment Isolation Data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'',
'    :P4_CURRENT_STEP := ''EQUIP_ISOLATION'';',
'    -- Load permit info',
'    SELECT permit_number, comments, workflow_status',
'    INTO :P4_PERMIT_NUMBER, :P4_COMMENTS, :P4_WORKFLOW_STATUS',
'    FROM ptw_pro.ptw_lv_permits',
'    WHERE permit_id = :P4_PERMIT_ID;',
'',
'    -- Load isolation rows (up to 4)',
'    FOR r IN (',
'        SELECT isolation_id, row_number, equipment_isolated, means_of_isolation, safety_lock_no',
'        FROM ptw_pro.ptw_lv_equipment_isolation',
'        WHERE permit_id = :P4_PERMIT_ID',
'        ORDER BY row_number',
'    ) LOOP',
'        CASE r.row_number',
'            WHEN 1 THEN',
'                :P4_ISO_1_ID := r.isolation_id;',
'                :P4_ISO_1_EQUIPMENT := r.equipment_isolated;',
'                :P4_ISO_1_MEANS := r.means_of_isolation;',
'                :P4_ISO_1_LOCK_NO := r.safety_lock_no;',
'            WHEN 2 THEN',
'                :P4_ISO_2_ID := r.isolation_id;',
'                :P4_ISO_2_EQUIPMENT := r.equipment_isolated;',
'                :P4_ISO_2_MEANS := r.means_of_isolation;',
'                :P4_ISO_2_LOCK_NO := r.safety_lock_no;',
'            WHEN 3 THEN',
'                :P4_ISO_3_ID := r.isolation_id;',
'                :P4_ISO_3_EQUIPMENT := r.equipment_isolated;',
'                :P4_ISO_3_MEANS := r.means_of_isolation;',
'                :P4_ISO_3_LOCK_NO := r.safety_lock_no;',
'            WHEN 4 THEN',
'                :P4_ISO_4_ID := r.isolation_id;',
'                :P4_ISO_4_EQUIPMENT := r.equipment_isolated;',
'                :P4_ISO_4_MEANS := r.means_of_isolation;',
'                :P4_ISO_4_LOCK_NO := r.safety_lock_no;',
'        END CASE;',
'    END LOOP;',
'',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        apex_error.add_error(',
'            p_message => ''Permit not found.'',',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P4_PERMIT_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>27353350362033404
);
wwv_flow_imp.component_end;
end;
/
