prompt --application/pages/page_00011
begin
--   Manifest
--     PAGE: 00011
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
 p_id=>11
,p_name=>'Control Measures & PPE bkup'
,p_alias=>'CONTROL-MEASURES-PPE1'
,p_step_title=>'Control Measures & PPE'
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
'// Override form submission for offline mode',
'if (!apex.page.submit._original) {',
'    apex.page.submit._original = apex.page.submit;',
'}',
'',
'apex.page.submit = function(options) {',
'    if (ConnectionManager.isOnline) {',
'        apex.page.submit._original(options);',
'    } else {',
'        const formData = apex.page.getValues();',
'        OfflineStorage.saveFormData(apex.page.getId(), formData)',
'            .then((id) => {',
'                apex.message.showPageSuccess(''Data saved offline. Will sync when connected.'');',
'            })',
'            .catch((error) => {',
'                apex.message.showErrors([{',
'                    type: ''error'',',
'                    message: ''Error saving offline: '' + error.message',
'                }]);',
'            });',
'    }',
'};'))
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
'',
'.cm-checklist {',
'    width: 100%;',
'    border-collapse: collapse;',
'    margin: 10px 0;',
'}',
'',
'.cm-checklist th {',
'    background: #003366;',
'    color: white;',
'    padding: 10px 15px;',
'    text-align: left;',
'    font-weight: 600;',
'}',
'',
'.cm-checklist td {',
'    padding: 10px 15px;',
'    border-bottom: 1px solid #e0e0e0;',
'    vertical-align: top;',
'}',
'',
'.cm-checklist tr:nth-child(even) {',
'    background: #f8f9fa;',
'}',
'',
'.cm-checklist .cm-number {',
'    width: 40px;',
'    text-align: center;',
'    font-weight: 600;',
'    color: #003366;',
'}',
'',
'.cm-checklist .cm-radio {',
'    width: 80px;',
'    text-align: center;',
'}',
'',
'.ppe-grid {',
'    display: grid;',
'    grid-template-columns: repeat(2, 1fr);',
'    gap: 15px;',
'    padding: 15px;',
'}',
'',
'.ppe-item {',
'    display: flex;',
'    align-items: center;',
'    gap: 10px;',
'    padding: 10px;',
'    border: 1px solid #e0e0e0;',
'    border-radius: 6px;',
'    background: #f8f9fa;',
'}',
'',
'/* Force radio group labels to wrap for long text */',
'.t-Form-labelContainer {',
'    white-space: normal !important;',
'}',
'',
'.t-Form-labelContainer label {',
'    white-space: normal !important;',
'    word-wrap: break-word;',
'    overflow-wrap: break-word;',
'}',
'',
'/* Green-tick checkbox for CM items */',
'',
'/* Hide native input visually but keep it interactive.',
'   opacity:0 + absolute positioning makes it invisible without breaking',
'   label-click toggling (display:none would break clicking).',
'   The double-tick issue is now handled by label::after below. */',
'.cm-tick-item .apex-item-option input {',
'    position: absolute;',
'    opacity: 0;',
'    width: 1px;',
'    height: 1px;',
'    margin: 0;',
'}',
'',
'/* label::before shows N/A (unchecked) or green tick (checked).',
'   font-size: 0 hides the LOV "Yes" text; ::before sets its own font-size.',
'   label::after suppressed - APEX Universal Theme uses it for its own tick',
'   glyph which was appearing as a second small tick beneath our custom one. */',
'.cm-tick-item .apex-item-option label {',
'    display: inline-flex;',
'    align-items: center;',
'    cursor: pointer;',
'    font-size: 0;',
'}',
'',
'.cm-tick-item .apex-item-option label::after {',
'    display: none !important;',
'}',
'',
'.cm-tick-item .apex-item-option label::before {',
'    content: ''N/A'';',
'    display: inline-flex;',
'    align-items: center;',
'    justify-content: center;',
'    width: 52px;',
'    height: 34px;',
'    border: 2px solid #ced4da;',
'    border-radius: 8px;',
'    background: #f0f0f0;',
'    color: #888;',
'    font-size: 0.78rem;',
'    font-weight: 700;',
'    letter-spacing: 0.05em;',
'    transition: all 0.18s;',
'    flex-shrink: 0;',
'}',
'',
'.cm-tick-item .apex-item-option input:checked + label::before {',
unistr('    content: ''\2713'';'),
'    background: #28a745;',
'    border-color: #1e7e34;',
'    color: #fff;',
'    font-size: 1.4rem;',
'}',
'',
'/* Question text wrapping */',
'.cm-tick-item .t-Form-labelContainer label {',
'    white-space: normal !important;',
'    word-wrap: break-word;',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_read_only_when=>'P11_WORKFLOW_STATUS'
,p_read_only_when2=>'IN_PROGRESS'
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(59896102123348739)
,p_plug_name=>'Workflow Progress'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>100
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="ptw-workflow-progress">',
'    <div class="workflow-step completed" data-step="1">',
'        <span class="step-icon">&#10003;</span>',
'        <span class="step-text">Site & Work Details</span>',
'    </div>',
'    <div class="workflow-step active" data-step="2">',
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
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(59896556853348743)
,p_plug_name=>'Control Measures Checklist'
,p_title=>'Control Measures - must be in place before issuing a Permit to Work LV Electrical'
,p_icon_css_classes=>'fa-clipboard-check'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>120
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(59898276415348760)
,p_plug_name=>'PPE Requirements'
,p_title=>'Identify Essential Personal Protective Equipment (PPE) Required To Be Worn'
,p_icon_css_classes=>'fa-shield'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>130
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(59966296367887521)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>140
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(59968067504887538)
,p_plug_name=>'SyncStatus'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>90
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div id="connection-status" style="padding: 10px; margin-bottom: 10px; border-radius: 4px;">',
'    <span id="status-icon"></span>',
'    <span id="status-text"></span>',
'    <!-- <button id="sync-btn" style="margin-left: 10px; display: none;">Sync Now</button> -->',
'</div>'))
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(85186230458815924)
,p_plug_name=>'Permit Information Badge'
,p_plug_display_sequence=>110
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="margin-bottom: 20px;">',
'    <span class="apex-badge" style="background-color: #3ea055; color: white; padding: 6px 16px; border-radius: 20px; font-weight: 600;">',
'        Permit: &P11_PERMIT_NUMBER.',
'    </span>',
'</div>',
''))
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P11_PERMIT_NUMBER'
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(32952092993000995)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(59966296367887521)
,p_button_name=>'SAVE_DRAFT'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Save Draft'
,p_button_position=>'NEXT'
,p_security_scheme=>wwv_flow_imp.id(31533963716212424)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(32952401892000993)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(59966296367887521)
,p_button_name=>'NEXT_STEP'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Next Step'
,p_button_position=>'NEXT'
,p_icon_css_classes=>'fa-arrow-right'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(32951659833000998)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(59966296367887521)
,p_button_name=>'BACK'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Back'
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_PERMIT_ID:&P11_PERMIT_ID.'
,p_icon_css_classes=>'fa-arrow-left'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(32969733265000901)
,p_branch_name=>'Go to Equipment Isolation (NEXT_STEP)'
,p_branch_action=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:4:P4_PERMIT_ID:&P11_PERMIT_ID.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_branch_condition=>'NEXT_STEP'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(32970163513000899)
,p_branch_name=>'Refresh Current Page (SAVE_DRAFT)'
,p_branch_action=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.:11:P11_PERMIT_ID:&P11_PERMIT_ID.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
,p_branch_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_branch_condition=>'SAVE_DRAFT'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59900015247348714)
,p_name=>'P11_CM_01'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(59896556853348743)
,p_prompt=>'1. All workers under this PTW have completed and signed off on a site induction?'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_help_text=>'All persons working under this PTW have received and signed, as understood, a suitable site induction?'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59900141758348715)
,p_name=>'P11_CM_02'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(59896556853348743)
,p_prompt=>'2. A reviewed risk assessment and method statement, including emergency evacuation, is in place and understood by all workers.?'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_help_text=>'A suitable and sufficient written risk assessment and method statement for these works, which has already been understood by all persons working under this permit is in place and has been reviewed at the point of works by the person controlling the w'
||'orks. This must include the provision of an emergency evacuation plan.'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59900238509348716)
,p_name=>'P11_CM_03'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(59896556853348743)
,p_prompt=>'3. The competence of the people working under the permit has been checked and is deemed to be adequate for these works.'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59900317899348717)
,p_name=>'P11_CM_04'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(59896556853348743)
,p_prompt=>'4. The person in charge of the works must be made aware of all hazards within the vicinity of the place of works.'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59900401176348718)
,p_name=>'P11_CM_05'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(59896556853348743)
,p_prompt=>'5. Where the use of PPE is identified as a control measure within the risk assessment, this equipment is in good order.'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59900555567348719)
,p_name=>'P11_CM_06'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(59896556853348743)
,p_prompt=>'6. Confirm that all sources of supply have been isolated, locked off and caution signs fitted, list details below.'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59900675528348720)
,p_name=>'P11_CM_07'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(59896556853348743)
,p_prompt=>'7. Confirm all isolated supplies are proven or confirmed dead before work starts?'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_help_text=>'Confirm that all isolated sources of supply have been proved dead using an approved tester and proving unit, where this is not possible the AP must confirm dead at the point of work after the issue of this Permit.'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59900789858348721)
,p_name=>'P11_CM_08'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(59896556853348743)
,p_prompt=>'8. Confirm all systems to be worked on have been checked to ensure that any stored energy has been dissipated.'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59900846437348722)
,p_name=>'P11_CM_09'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(59896556853348743)
,p_prompt=>'9. Confirm any live parts are insulated and no exposed live components remain?'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_help_text=>'Confirm that if any section of the equipment is still live it is covered in a suitable insulating material and that there are no exposed live parts.'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59900921663348723)
,p_name=>'P11_CM_10'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(59896556853348743)
,p_prompt=>'10. Confirm that sufficient measures are in place to ensure that no live equipment is worked on.'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59901035826348724)
,p_name=>'P11_CM_11'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(59896556853348743)
,p_prompt=>'11. Confirm there are first aid facilities available.'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59901168341348725)
,p_name=>'P11_CM_12'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(59896556853348743)
,p_prompt=>'12. Confirm that suitable barriers have been used to clearly identify the working area.'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59901225138348726)
,p_name=>'P11_CM_13'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(59896556853348743)
,p_prompt=>'13. Confirm there is unrestricted access and egress to the working area.'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59901361761348727)
,p_name=>'P11_CM_14'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_imp.id(59896556853348743)
,p_prompt=>'14. Confirm there is suitable insulated matting available.'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59901459621348728)
,p_name=>'P11_CM_15'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_imp.id(59896556853348743)
,p_prompt=>'15. Confirm that the calibration of the test equipment is current.'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59901566138348729)
,p_name=>'P11_CM_16'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_imp.id(59896556853348743)
,p_prompt=>'16. Danger signs have been applied to adjacent live equipment.'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59908882327348692)
,p_name=>'P11_PPE_SAFETY_HELMET'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(59898276415348760)
,p_prompt=>'Safety Helmet (Hard Hat)'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59908997960348693)
,p_name=>'P11_PPE_ARC_FLASH'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(59898276415348760)
,p_prompt=>'Arc Flash PPE'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59909108414348694)
,p_name=>'P11_PPE_SAFETY_FOOTWEAR'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(59898276415348760)
,p_prompt=>'Safety Footwear'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59909171610348695)
,p_name=>'P11_PPE_HI_VIS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(59898276415348760)
,p_prompt=>'Hi-Vis Vest/Jkt'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59909286137348649)
,p_name=>'P11_PERMIT_ID'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59909363681348650)
,p_name=>'P11_PERMIT_NUMBER'
,p_item_sequence=>50
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59909506151348651)
,p_name=>'P11_CONTROL_MEASURES_ID'
,p_item_sequence=>60
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59909595598348652)
,p_name=>'P11_WORKFLOW_STATUS'
,p_item_sequence=>80
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59909813124348654)
,p_name=>'P11_CURRENT_STEP'
,p_item_sequence=>70
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59976241359887446)
,p_name=>'P11_PPE_SAFETY_GOGGLES'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(59898276415348760)
,p_prompt=>'Safety Goggles'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59976378590887447)
,p_name=>'P11_PPE_INSULATING_GLOVES'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(59898276415348760)
,p_prompt=>'Electrical Insulating Gloves'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59976497326887448)
,p_name=>'P11_PPE_FALL_RESTRAINT'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(59898276415348760)
,p_prompt=>'Fall Restraint Harness'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59976581803887449)
,p_name=>'P11_PPE_FALL_ARREST'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(59898276415348760)
,p_prompt=>'Fall Arrest Harness'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59976680741887450)
,p_name=>'P11_PPE_EAR_DEFENDERS'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(59898276415348760)
,p_prompt=>'Ear Defenders/Plugs'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59976745927887451)
,p_name=>'P11_PPE_SAFETY_GLOVES'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(59898276415348760)
,p_prompt=>'Safety Gloves'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Yes;Y'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-tick-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(63107570437643630)
,p_name=>'P11_IS_CHANGED'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(32966232151000916)
,p_validation_name=>'Permit ID Required'
,p_validation_sequence=>10
,p_validation=>'P11_PERMIT_ID'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Permit ID is required. Please start from Step 1.'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(32967740450000908)
,p_name=>'Check status of page'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(32952401892000993)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32968252633000906)
,p_event_id=>wwv_flow_imp.id(32967740450000908)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_IS_CHANGED'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if (apex.page.isChanged()) {',
'    // do something, e.g. enable a save button',
'    apex.item(''P11_IS_CHANGED'').setValue(''Y'');',
'} else {',
'    apex.item(''P11_IS_CHANGED'').setValue(''N'');',
'}'))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32968711952000904)
,p_event_id=>wwv_flow_imp.id(32967740450000908)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'NULL;'
,p_attribute_02=>'P11_IS_CHANGED'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32969211821000902)
,p_event_id=>wwv_flow_imp.id(32967740450000908)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'NEXT_STEP'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(32966929382000912)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save Control Measures and PPE Data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    -- Save/Update Control Measures',
'    IF :P11_CONTROL_MEASURES_ID IS NULL THEN',
'        -- INSERT',
'        INSERT INTO ptw_pro.ptw_lv_control_measures (',
'            permit_id,',
'            cm_01_site_induction,',
'            cm_02_risk_assessment,',
'            cm_03_competence_checked,',
'            cm_04_hazards_aware,',
'            cm_05_ppe_identified,',
'            cm_06_sources_isolated,',
'            cm_07_proved_dead,',
'            cm_08_stored_energy,',
'            cm_09_live_covered,',
'            cm_10_no_live_work,',
'            cm_11_first_aid,',
'            cm_12_barriers,',
'            cm_13_access_egress,',
'            cm_14_insulated_matting,',
'            cm_15_calibration_current,',
'            cm_16_danger_signs',
'        ) VALUES (',
'            :P11_PERMIT_ID,',
'            :P11_CM_01,',
'            :P11_CM_02,',
'            :P11_CM_03,',
'            :P11_CM_04,',
'            :P11_CM_05,',
'            :P11_CM_06,',
'            :P11_CM_07,',
'            :P11_CM_08,',
'            :P11_CM_09,',
'            :P11_CM_10,',
'            :P11_CM_11,',
'            :P11_CM_12,',
'            :P11_CM_13,',
'            :P11_CM_14,',
'            :P11_CM_15,',
'            :P11_CM_16',
'        ) RETURNING control_measures_id INTO :P11_CONTROL_MEASURES_ID;',
'',
'        UPDATE ptw_pro.ptw_lv_permits',
'        SET    ppe_safety_helmet = :P11_PPE_SAFETY_HELMET,',
'               ppe_arc_flash = :P11_PPE_ARC_FLASH,',
'               ppe_safety_footwear = :P11_PPE_SAFETY_FOOTWEAR,',
'               ppe_hi_vis = :P11_PPE_HI_VIS,',
'               ppe_safety_goggles = :P11_PPE_SAFETY_GOGGLES,',
'               ppe_insulating_gloves = :P11_PPE_INSULATING_GLOVES,',
'               ppe_fall_restraint = :P11_PPE_FALL_RESTRAINT,',
'               ppe_fall_arrest = :P11_PPE_FALL_ARREST,',
'               ppe_ear_defenders = :P11_PPE_EAR_DEFENDERS,',
'               ppe_safety_gloves = :P11_PPE_SAFETY_GLOVES,',
'               ppe_latitude = :P0_LATITUDE,',
'               ppe_longitude = :P0_LONGITUDE,',
'               current_step = :P11_CURRENT_STEP,',
'               modified_by = NVL(V(''APP_USER''), USER),',
'               modified_date = CURRENT_TIMESTAMP',
'        WHERE  permit_id = :P11_PERMIT_ID;',
'',
'        COMMIT;',
'',
'    END IF;',
'',
'    IF :P11_IS_CHANGED = ''Y'' THEN',
'        -- UPDATE',
'        UPDATE ptw_pro.ptw_lv_control_measures',
'        SET cm_01_site_induction = :P11_CM_01,',
'            cm_02_risk_assessment = :P11_CM_02,',
'            cm_03_competence_checked = :P11_CM_03,',
'            cm_04_hazards_aware = :P11_CM_04,',
'            cm_05_ppe_identified = :P11_CM_05,',
'            cm_06_sources_isolated = :P11_CM_06,',
'            cm_07_proved_dead = :P11_CM_07,',
'            cm_08_stored_energy = :P11_CM_08,',
'            cm_09_live_covered = :P11_CM_09,',
'            cm_10_no_live_work = :P11_CM_10,',
'            cm_11_first_aid = :P11_CM_11,',
'            cm_12_barriers = :P11_CM_12,',
'            cm_13_access_egress = :P11_CM_13,',
'            cm_14_insulated_matting = :P11_CM_14,',
'            cm_15_calibration_current = :P11_CM_15,',
'            cm_16_danger_signs = :P11_CM_16,',
'            modified_date = CURRENT_TIMESTAMP',
'        WHERE control_measures_id = :P11_CONTROL_MEASURES_ID;',
'',
'        -- Update PPE on permits table',
'        UPDATE ptw_pro.ptw_lv_permits',
'        SET    ppe_safety_helmet = :P11_PPE_SAFETY_HELMET,',
'               ppe_arc_flash = :P11_PPE_ARC_FLASH,',
'               ppe_safety_footwear = :P11_PPE_SAFETY_FOOTWEAR,',
'               ppe_hi_vis = :P11_PPE_HI_VIS,',
'               ppe_safety_goggles = :P11_PPE_SAFETY_GOGGLES,',
'               ppe_insulating_gloves = :P11_PPE_INSULATING_GLOVES,',
'               ppe_fall_restraint = :P11_PPE_FALL_RESTRAINT,',
'               ppe_fall_arrest = :P11_PPE_FALL_ARREST,',
'               ppe_ear_defenders = :P11_PPE_EAR_DEFENDERS,',
'               ppe_safety_gloves = :P11_PPE_SAFETY_GLOVES,',
'               ppe_latitude = :P0_LATITUDE,',
'               ppe_longitude = :P0_LONGITUDE,',
'               current_step = :P11_CURRENT_STEP,',
'               modified_by = NVL(V(''APP_USER''), USER),',
'               modified_date = CURRENT_TIMESTAMP',
'        WHERE  permit_id = :P11_PERMIT_ID;',
'',
'        COMMIT;',
'        ',
'    END IF;',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_error.add_error(',
'            p_message => ''Error saving control measures: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RAISE;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>':REQUEST IN (''SAVE_DRAFT'',''NEXT_STEP'')'
,p_process_when_type=>'EXPRESSION'
,p_process_when2=>'PLSQL'
,p_process_success_message=>'Control measures and PPE saved successfully.'
,p_security_scheme=>wwv_flow_imp.id(31533963716212424)
,p_internal_uid=>32966929382000912
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(32966537202000915)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load Control Measures and PPE Data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    -- Load permit info (PPE columns)',
'    :P11_CURRENT_STEP := ''CONTROL_MEASURES'';',
'    SELECT',
'        permit_number,',
'        ppe_safety_helmet,',
'        ppe_arc_flash,',
'        ppe_safety_footwear,',
'        ppe_hi_vis,',
'        ppe_safety_goggles,',
'        ppe_insulating_gloves,',
'        ppe_fall_restraint,',
'        ppe_fall_arrest,',
'        ppe_ear_defenders,',
'        ppe_safety_gloves,',
'        workflow_status',
'    INTO',
'        :P11_PERMIT_NUMBER,',
'        :P11_PPE_SAFETY_HELMET,',
'        :P11_PPE_ARC_FLASH,',
'        :P11_PPE_SAFETY_FOOTWEAR,',
'        :P11_PPE_HI_VIS,',
'        :P11_PPE_SAFETY_GOGGLES,',
'        :P11_PPE_INSULATING_GLOVES,',
'        :P11_PPE_FALL_RESTRAINT,',
'        :P11_PPE_FALL_ARREST,',
'        :P11_PPE_EAR_DEFENDERS,',
'        :P11_PPE_SAFETY_GLOVES,',
'        :P11_WORKFLOW_STATUS',
'    FROM ptw_pro.ptw_lv_permits',
'    WHERE permit_id = :P11_PERMIT_ID;',
'',
'    -- Load control measures if they exist',
'    BEGIN',
'        SELECT',
'            control_measures_id,',
'            cm_01_site_induction,',
'            cm_02_risk_assessment,',
'            cm_03_competence_checked,',
'            cm_04_hazards_aware,',
'            cm_05_ppe_identified,',
'            cm_06_sources_isolated,',
'            cm_07_proved_dead,',
'            cm_08_stored_energy,',
'            cm_09_live_covered,',
'            cm_10_no_live_work,',
'            cm_11_first_aid,',
'            cm_12_barriers,',
'            cm_13_access_egress,',
'            cm_14_insulated_matting,',
'            cm_15_calibration_current,',
'            cm_16_danger_signs',
'        INTO',
'            :P11_CONTROL_MEASURES_ID,',
'            :P11_CM_01,',
'            :P11_CM_02,',
'            :P11_CM_03,',
'            :P11_CM_04,',
'            :P11_CM_05,',
'            :P11_CM_06,',
'            :P11_CM_07,',
'            :P11_CM_08,',
'            :P11_CM_09,',
'            :P11_CM_10,',
'            :P11_CM_11,',
'            :P11_CM_12,',
'            :P11_CM_13,',
'            :P11_CM_14,',
'            :P11_CM_15,',
'            :P11_CM_16',
'        FROM ptw_pro.ptw_lv_control_measures',
'        WHERE permit_id = :P11_PERMIT_ID;',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN',
'            :P11_CONTROL_MEASURES_ID := NULL;',
'    END;',
'',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        apex_error.add_error(',
'            p_message => ''Permit not found.'',',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P11_PERMIT_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>32966537202000915
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(32967334464000909)
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
,p_process_when=>'P11_PERMIT_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>32967334464000909
);
wwv_flow_imp.component_end;
end;
/
