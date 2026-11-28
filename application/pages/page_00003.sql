prompt --application/pages/page_00003
begin
--   Manifest
--     PAGE: 00003
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
 p_id=>3
,p_name=>'Control Measures & PPE'
,p_alias=>'CONTROL-MEASURES-PPE'
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
'        OfflineStorage.saveFormData(''3'', formData, apex.jQuery(''#P3_PERMIT_ID'').val() || null)',
'            .then(function() {',
'                var u = new URL(window.location.href);',
'                var p = u.pathname.split(''/'');',
'                while (p[p.length - 1] === '''') p.pop();',
'                if (/^\d+$/.test(p[p.length - 1])) {',
'                    p[p.length - 2] = ''equipment-isolation'';',
'                } else {',
'                    p[p.length - 1] = ''equipment-isolation'';',
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
'}());',
'',
'function initCMChecklist() {',
'    var $items = $(''.cm-tristate-item'');',
'',
'    if ($items.length === 0) return; // not on a CM page',
'',
'    // Append red asterisk to each item''s label',
'    $items.each(function() {',
'        $(this).find(''.t-Form-labelContainer label, label'').first()',
'               .append(''<span class="cm-required-star" aria-hidden="true"> *</span>'');',
'    });',
'}',
'',
'apex.jQuery(document).on(''apexreadyend'', function() {',
'    initCMChecklist();',
'});',
'',
'PTW.checklist.load(',
'    $v(''P3_PERMIT_ID''),',
'    { controlMeasures: ''cm-checklist-region'', ppe: ''ppe-checklist-region'' },',
'    apex.item(''P3_WORKFLOW_STATUS'').getValue() !== ''DRAFT''',
');',
''))
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
''))
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_read_only_when=>'P3_WORKFLOW_STATUS'
,p_read_only_when2=>'DRAFT'
,p_page_component_map=>'25'
,p_last_updated_on=>wwv_flow_imp.dz('20260919124734Z')
,p_last_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27015615881886507)
,p_plug_name=>'Buttons'
,p_static_id=>'buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>180
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_query_headings_type=>'COLON_DELMITED_LIST'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_updated_on=>wwv_flow_imp.dz('20260919124545Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(26945876367347729)
,p_plug_name=>'Control Measures Checklist'
,p_static_id=>'cm-checklist-region'
,p_title=>'&P3_SECTION_TITLE.'
,p_region_name=>'cm-checklist-region'
,p_icon_css_classes=>'fa-clipboard-check'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>160
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_query_headings_type=>'COLON_DELMITED_LIST'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_updated_on=>wwv_flow_imp.dz('20260919124734Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(52235549972814910)
,p_plug_name=>'Permit Type Badge'
,p_static_id=>'permit-information-badge'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>140
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'RETURN ptw_pro.ptw_ui_pkg.get_permit_type_badge_html(',
'    p_permit_id => :P3_PERMIT_ID,',
'    p_ptw_type  => :P3_PTW_TYPE',
');'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P3_PERMIT_NUMBER'
,p_updated_on=>wwv_flow_imp.dz('20260919124545Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8879376723853342)
,p_plug_name=>'Permit Number Badge'
,p_static_id=>'permit-number-badge'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>150
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'    <div style="margin-bottom: 20px;">',
'        <span class="apex-badge" style="background-color: #3ea055; color: white; padding: 6px 16px; border-radius: 20px; font-weight: 600;">',
'            Permit: &P3_PERMIT_NUMBER.',
'        </span>',
'    </div>'))
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P3_PERMIT_NUMBER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260824211904Z')
,p_updated_on=>wwv_flow_imp.dz('20260919124545Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(26947595929347746)
,p_plug_name=>'PPE Requirements'
,p_static_id=>'ppe-checklist-region'
,p_title=>'Identify Essential Personal Protective Equipment (PPE) Required To Be Worn'
,p_region_name=>'ppe-checklist-region'
,p_icon_css_classes=>'fa-shield'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>170
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_query_headings_type=>'COLON_DELMITED_LIST'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_updated_on=>wwv_flow_imp.dz('20260919124545Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27017387018886524)
,p_plug_name=>'SyncStatus'
,p_static_id=>'syncstatus'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>120
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div id="connection-status" style="padding: 10px; margin-bottom: 10px; border-radius: 4px;">',
'    <span id="status-icon"></span>',
'    <span id="status-text"></span>',
'    <!-- <button id="sync-btn" style="margin-left: 10px; display: none;">Sync Now</button> -->',
'</div>'))
,p_plug_query_headings_type=>'COLON_DELMITED_LIST'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_updated_on=>wwv_flow_imp.dz('20260919124545Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(26945421637347725)
,p_plug_name=>'Workflow Progress'
,p_static_id=>'workflow-progress'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>130
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'RETURN ptw_pro.ptw_ui_pkg.get_workflow_steps_html(',
'    p_permit_id => :P3_PERMIT_ID,',
'    p_ptw_type  => :P3_PTW_TYPE,',
'    p_current_step => ''CONTROL_MEASURES''',
');'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_updated_on=>wwv_flow_imp.dz('20260919124545Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(27015706306886508)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(27015615881886507)
,p_button_name=>'BACK'
,p_static_id=>'back'
,p_button_static_id=>'BTN_BACK_P3'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Back'
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_PERMIT_ID:&P3_PERMIT_ID.'
,p_updated_on=>wwv_flow_imp.dz('20260502204901Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(27015908062886510)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(27015615881886507)
,p_button_name=>'NEXT_STEP'
,p_static_id=>'next-step'
,p_button_static_id=>'BTN_NEXT_STEP_P3'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Next Step'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-arrow-right'
,p_updated_on=>wwv_flow_imp.dz('20260906172849Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(27015845414886509)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(27015615881886507)
,p_button_name=>'SAVE_DRAFT'
,p_static_id=>'save-draft'
,p_button_static_id=>'BTN_SAVE_DRAFT_P3'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Save Draft'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_security_scheme=>wwv_flow_imp.id(31533963716212424)
,p_updated_on=>wwv_flow_imp.dz('20260318200244Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(8878615829853335)
,p_branch_name=>'Go to Authorisation & Acceptance'
,p_branch_action=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5:P5_PERMIT_ID:&P3_PERMIT_ID.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>30
,p_branch_condition_type=>'EXPRESSION'
,p_branch_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':REQUEST = ''NEXT_STEP'' AND NOT EXISTS (',
'    SELECT 1',
'    FROM   ptw_pro.ptw_lv_permits p',
'    JOIN   ptw_pro.ptw_types t       ON t.ptw_type = p.ptw_type',
'    JOIN   ptw_pro.ptw_type_sections ts ON ts.type_id = t.type_id',
'    WHERE  p.permit_id   = :P3_PERMIT_ID',
'    AND    ts.section_code = ''EQUIPMENT_ISOLATION''',
')'))
,p_branch_condition_text=>'SQL'
,p_created_on=>wwv_flow_imp.dz('20260820200823Z')
,p_updated_on=>wwv_flow_imp.dz('20260823154826Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(27016855871886519)
,p_branch_name=>'Go to Equipment Isolation (NEXT_STEP)'
,p_branch_action=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:4:P4_PERMIT_ID:&P3_PERMIT_ID.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'EXPRESSION'
,p_branch_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':REQUEST = ''NEXT_STEP'' AND EXISTS (',
'    SELECT 1',
'    FROM   ptw_pro.ptw_lv_permits p',
'    JOIN   ptw_pro.ptw_types t       ON t.ptw_type = p.ptw_type',
'    JOIN   ptw_pro.ptw_type_sections ts ON ts.type_id = t.type_id',
'    WHERE  p.permit_id   = :P3_PERMIT_ID',
'    AND    ts.section_code = ''EQUIPMENT_ISOLATION''',
')'))
,p_branch_condition_text=>'SQL'
,p_updated_on=>wwv_flow_imp.dz('20260823154826Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(27016963816886520)
,p_branch_name=>'Refresh Current Page (SAVE_DRAFT)'
,p_branch_action=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:3:P3_PERMIT_ID:&P3_PERMIT_ID.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
,p_branch_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_branch_condition=>'SAVE_DRAFT'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(8879956456853348)
,p_name=>'P3_CHECKLIST_JSON'
,p_item_sequence=>100
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260824221228Z')
,p_updated_on=>wwv_flow_imp.dz('20260824221228Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26945279075347723)
,p_name=>'P3_CONTROL_MEASURES_ID'
,p_item_sequence=>60
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26945586048347726)
,p_name=>'P3_CURRENT_STEP'
,p_item_sequence=>70
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30143343361642702)
,p_name=>'P3_IS_CHANGED'
,p_item_sequence=>40
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26945059061347721)
,p_name=>'P3_PERMIT_ID'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26945136605347722)
,p_name=>'P3_PERMIT_NUMBER'
,p_item_sequence=>50
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(8879066732853339)
,p_name=>'P3_PTW_TYPE'
,p_item_sequence=>90
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260823154826Z')
,p_updated_on=>wwv_flow_imp.dz('20260823154826Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(42197875323924531)
,p_name=>'P3_SECTION_TITLE'
,p_item_sequence=>110
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260919124545Z')
,p_updated_on=>wwv_flow_imp.dz('20260919124545Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26945368522347724)
,p_name=>'P3_WORKFLOW_STATUS'
,p_item_sequence=>80
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(45757058192782522)
,p_validation_name=>'All Control Measures Must Be Confirmed'
,p_static_id=>'all-control-measures-must-be-confirmed'
,p_validation_sequence=>20
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_unanswered_count NUMBER;',
'BEGIN',
'    SELECT COUNT(*)',
'    INTO   l_unanswered_count',
'    FROM   ptw_pro.ptw_checklist_items ci',
'    JOIN   ptw_pro.ptw_types t         ON t.type_id = ci.type_id',
'    JOIN   ptw_pro.ptw_lv_permits p    ON p.ptw_type = t.ptw_type',
'    WHERE  p.permit_id  = :P3_PERMIT_ID',
'    AND    ci.is_active = ''Y''',
'    AND    ci.section_code = ''CONTROL_MEASURES''',
'    AND    NOT EXISTS (',
'        SELECT 1',
'        FROM   JSON_TABLE(:P3_CHECKLIST_JSON, ''$[*]''',
'                   COLUMNS (',
'                       checklist_item_id NUMBER      PATH ''$.checklist_item_id'',',
'                       response          VARCHAR2(2) PATH ''$.response''',
'                   )) jt',
'        WHERE  jt.checklist_item_id = ci.checklist_item_id',
'        AND    jt.response IS NOT NULL',
'    );',
'',
'    RETURN l_unanswered_count = 0;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'All control measures must be confirmed before proceeding to the next step.'
,p_always_execute=>'Y'
,p_validation_condition=>'NEXT_STEP'
,p_validation_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260501142007Z')
,p_updated_on=>wwv_flow_imp.dz('20260824225747Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(27016045833886511)
,p_validation_name=>'Permit ID Required'
,p_static_id=>'permit-id-required'
,p_validation_sequence=>10
,p_validation=>'P3_PERMIT_ID'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Permit ID is required. Please start from Step 1.'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(30153697799398471)
,p_name=>'Get Location and Next Step'
,p_static_id=>'get-location-and-next-step'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(27015908062886510)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_updated_on=>wwv_flow_imp.dz('20260824221615Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30154011180398458)
,p_event_id=>wwv_flow_imp.id(30153697799398471)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P3_IS_CHANGED'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'apex.item(''P3_CHECKLIST_JSON'').setValue(JSON.stringify(PTW.checklist.collect()));',
    'captureLocationThenSubmit(''NEXT_STEP'');',
    '')))).to_clob
,p_updated_on=>wwv_flow_imp.dz('20260824221615Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(33350440547951418)
,p_name=>'Get Location and Save Draft'
,p_static_id=>'get-location-and-save-draft'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(27015845414886509)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_created_on=>wwv_flow_imp.dz('20260318200152Z')
,p_updated_on=>wwv_flow_imp.dz('20260824221615Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33350512772951419)
,p_event_id=>wwv_flow_imp.id(33350440547951418)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'apex.item(''P3_CHECKLIST_JSON'').setValue(JSON.stringify(PTW.checklist.collect()));',
    'captureLocationThenSubmit(''SAVE_DRAFT'');')))).to_clob
,p_created_on=>wwv_flow_imp.dz('20260318200152Z')
,p_updated_on=>wwv_flow_imp.dz('20260824221615Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(30143851377642707)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Engineer Own Permit Check'
,p_static_id=>'engineer-own-permit-check'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_is_engineer NUMBER;',
'    v_is_owner    NUMBER;',
'    v_is_auth     NUMBER;',
'BEGIN',
'    SELECT COUNT(*) INTO v_is_engineer',
'    FROM   ptw_pro.ptw_lv_user_roles_v          -- changed',
'    WHERE  UPPER(username) = UPPER(V(''APP_USER''))',
'    AND    role_name = ''ENGINEER''',
'    AND    is_active = ''Y'';',
'',
'    IF v_is_engineer > 0 AND :P3_PERMIT_ID IS NOT NULL THEN  -- use correct Pn_PERMIT_ID per page',
'',
'        SELECT COUNT(*) INTO v_is_owner',
'        FROM   ptw_pro.ptw_lv_permits',
'        WHERE  permit_id = :P3_PERMIT_ID         -- use correct Pn_PERMIT_ID per page',
'        AND    UPPER(created_by) = UPPER(V(''APP_USER''));',
'',
'        IF v_is_owner = 0 THEN',
'',
'            SELECT COUNT(*) INTO v_is_auth',
'            FROM   ptw_pro.ptw_signatures',
'            WHERE  permit_id = :P3_PERMIT_ID',
'            AND    stage     = ''AUTH''',
'            AND    UPPER(person_name) = UPPER(V(''APP_USER''));  -- check if the engineer is the auth_person',
'',
'          IF v_is_auth = 0 THEN',
'            apex_error.add_error(',
'                p_message          => ''Access denied. You can only edit permits you have created.'',',
'                p_display_location => apex_error.c_inline_in_notification',
'            );',
'            apex_util.redirect_url(',
'                apex_page.get_url(p_page => 1)',
'            );',
'          END IF;',
'        END IF;',
'    END IF;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P3_PERMIT_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>30143851377642707
,p_updated_on=>wwv_flow_imp.dz('20260820191834Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(8880044332853349)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_CHECKLIST'
,p_static_id=>'get-checklist'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    htp.prn(''{"items":'' || ptw_pro.ptw_checklist_pkg.get_checklist_json(apex_application.g_x01) || ''}'');',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>8880044332853349
,p_created_on=>wwv_flow_imp.dz('20260824221615Z')
,p_updated_on=>wwv_flow_imp.dz('20260824221615Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(27016141402886512)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load Control Measures and PPE Data'
,p_static_id=>'load-control-measures-and-ppe-data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    -- Load permit info (PPE columns)',
'    :P3_CURRENT_STEP := ''CONTROL_MEASURES'';',
'    SELECT',
'        permit_number,',
'        workflow_status,',
'        ptw_type',
'    INTO',
'        :P3_PERMIT_NUMBER,',
'        :P3_WORKFLOW_STATUS,',
'        :P3_PTW_TYPE',
'    FROM ptw_pro.ptw_lv_permits',
'    WHERE permit_id = :P3_PERMIT_ID;',
'',
'    :G_ACTIVE_PERMIT_ID := :P3_PERMIT_ID;',
'',
'    :P3_SECTION_TITLE := CASE WHEN :P3_PTW_TYPE = ''LIMITATION OF ACCESS''',
'                          THEN ''Control Measures - must be in place before issuing this Limitation of Access''',
'                          ELSE ''Control Measures - must be in place before issuing a Permit to Work''',
'                         END;',
'',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        apex_error.add_error(',
'            p_message => ''Permit not found.'',',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P3_PERMIT_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>27016141402886512
,p_updated_on=>wwv_flow_imp.dz('20260919124546Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(27016268704886513)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save Control Measures and PPE Data'
,p_static_id=>'save-control-measures-and-ppe-data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    IF :P3_WORKFLOW_STATUS = ''DRAFT'' THEN',
'        ptw_pro.ptw_checklist_pkg.save_checklist_responses(',
'            :P3_PERMIT_ID,',
'            :P3_CHECKLIST_JSON,',
'            TO_NUMBER(:APP_LATITUDE),',
'            TO_NUMBER(:APP_LONGITUDE)',
'        );',
'    END IF;',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_error.add_error(',
'            p_message          => ''Error saving control measures: '' || SQLERRM,',
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
,p_internal_uid=>27016268704886513
,p_updated_on=>wwv_flow_imp.dz('20260829152350Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
