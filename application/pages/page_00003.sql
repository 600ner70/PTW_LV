prompt --application/pages/page_00003
begin
--   Manifest
--     PAGE: 00003
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
'(function () {',
'',
'    var CM_ITEMS = [',
'        ''P3_CM_01'',''P3_CM_02'',''P3_CM_03'',''P3_CM_04'',',
'        ''P3_CM_05'',''P3_CM_06'',''P3_CM_07'',''P3_CM_08'',',
'        ''P3_CM_09'',''P3_CM_10'',''P3_CM_11'',''P3_CM_12'',',
'        ''P3_CM_13'',''P3_CM_14'',''P3_CM_15'',''P3_CM_16''',
'    ];',
'',
'    var PPE_ITEMS = [',
'        ''P3_PPE_SAFETY_HELMET'',',
'        ''P3_PPE_ARC_FLASH'',',
'        ''P3_PPE_SAFETY_FOOTWEAR'',',
'        ''P3_PPE_HI_VIS'',',
'        ''P3_PPE_SAFETY_GOGGLES'',',
'        ''P3_PPE_INSULATING_GLOVES'',',
'        ''P3_PPE_FALL_RESTRAINT'',',
'        ''P3_PPE_FALL_ARREST'',',
'        ''P3_PPE_EAR_DEFENDERS'',',
'        ''P3_PPE_SAFETY_GLOVES''',
'    ];',
'',
'    var BADGES = [',
unistr('        { val: ''Y'',  cls: ''cm-badge-yes'', label: ''\2713'' },'),
unistr('        { val: ''N'',  cls: ''cm-badge-no'',  label: ''\2717'' },'),
'        { val: ''NA'', cls: ''cm-badge-na'',  label: ''N/A'' }',
'    ];',
'',
'    var isReadOnly = (apex.item(''P3_WORKFLOW_STATUS'').getValue() !== ''IN_PROGRESS'');',
'',
'    // -------------------------------------------------------',
'    // CM TRISTATE BADGES',
'    // -------------------------------------------------------',
'    CM_ITEMS.forEach(function (itemName) {',
'',
'        var $fc = $(''#'' + itemName).closest(''.t-Form-fieldContainer'');',
'        if ($fc.length === 0) {',
'            $fc = $(''[id="'' + itemName + ''_LABEL"]'').closest(''.t-Form-fieldContainer'');',
'        }',
'        if ($fc.length === 0) return;',
'',
'        $fc.find(''.cm-badge-row'').remove();',
'',
'        var currentVal = '''';',
'        if (!isReadOnly) {',
'            currentVal = $(''input[name="'' + itemName + ''"]:checked'').val() || '''';',
'        } else {',
'            currentVal = apex.item(itemName).getValue() || '''';',
'        }',
'',
'        var $row = $(''<div class="cm-badge-row"></div>'').attr(''data-item'', itemName);',
'',
'        BADGES.forEach(function (b) {',
'            $(''<span></span>'')',
'                .addClass(''cm-badge '' + b.cls)',
'                .toggleClass(''cm-active'', currentVal === b.val)',
'                .toggleClass(''cm-badge-readonly'', isReadOnly)',
'                .attr(''data-value'', b.val)',
'                .text(b.label)',
'                .appendTo($row);',
'        });',
'',
'        $fc.find(''.t-Form-inputContainer'').append($row);',
'    });',
'',
'    // Hide native CM radio grid',
'    $(''.cm-tristate-item .apex-item-grid'').hide();',
'',
unistr('    // CM delegated click \2014 edit mode only'),
'    $(document).off(''click.cmtristate'').on(''click.cmtristate'', ''.cm-badge:not(.cm-badge-readonly)'', function () {',
'        var $badge   = $(this);',
'        var $row     = $badge.closest(''.cm-badge-row'');',
'        var itemName = $row.attr(''data-item'');',
'        var val      = $badge.attr(''data-value'');',
'',
'        $(''input[name="'' + itemName + ''"][value="'' + val + ''"]'')',
'            .prop(''checked'', true).trigger(''change'');',
'',
'        $row.find(''.cm-badge'').removeClass(''cm-active'');',
'        $badge.addClass(''cm-active'');',
'    });',
'',
'    // -------------------------------------------------------',
'    // PPE SINGLE TICK BADGES',
'    // -------------------------------------------------------',
'    PPE_ITEMS.forEach(function (itemName) {',
'',
'        var $fc = $(''#'' + itemName).closest(''.t-Form-fieldContainer'');',
'        if ($fc.length === 0) return;',
'',
'        $fc.find(''.ppe-badge-row'').remove();',
'',
'        var currentVal = apex.item(itemName).getValue() || '''';',
'        var isChecked  = (currentVal.indexOf(''Y'') > -1);',
'',
'        var $badge = $(''<span></span>'')',
'            .addClass(''ppe-badge'')',
'            .toggleClass(''ppe-active'', isChecked)',
'            .toggleClass(''ppe-readonly'', isReadOnly)',
'            .attr(''data-item'', itemName)',
unistr('            .text(''\2713'');'),
'',
'        var $row = $(''<div class="ppe-badge-row"></div>'').append($badge);',
'        $fc.find(''.t-Form-inputContainer'').append($row);',
'    });',
'',
'    // Hide native PPE checkboxes',
'    $(''.cm-tick-item .apex-item-checkbox'').hide();',
'',
unistr('    // PPE delegated click \2014 edit mode only'),
'    $(document).off(''click.ppetick'').on(''click.ppetick'', ''.ppe-badge:not(.ppe-readonly)'', function () {',
'        var $badge     = $(this);',
'        var itemName   = $badge.attr(''data-item'');',
'        var isNowActive = !$badge.hasClass(''ppe-active'');',
'',
'        $(''input[name="'' + itemName + ''"]'').prop(''checked'', isNowActive).trigger(''change'');',
'        apex.item(itemName).setValue(isNowActive ? ''Y'' : '''');',
'',
'        $badge.toggleClass(''ppe-active'', isNowActive);',
'    });',
'',
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
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_read_only_when=>'P3_WORKFLOW_STATUS'
,p_read_only_when2=>'IN_PROGRESS'
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(26945421637347725)
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
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(26945876367347729)
,p_plug_name=>'Control Measures Checklist'
,p_title=>'Control Measures - must be in place before issuing a Permit to Work LV Electrical'
,p_icon_css_classes=>'fa-clipboard-check'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>120
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(26947595929347746)
,p_plug_name=>'PPE Requirements'
,p_title=>'Identify Essential Personal Protective Equipment (PPE) Required To Be Worn'
,p_icon_css_classes=>'fa-shield'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>130
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27015615881886507)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>140
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27017387018886524)
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
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(52235549972814910)
,p_plug_name=>'Permit Information Badge'
,p_plug_display_sequence=>110
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="margin-bottom: 20px;">',
'    <span class="apex-badge" style="background-color: #3ea055; color: white; padding: 6px 16px; border-radius: 20px; font-weight: 600;">',
'        Permit: &P3_PERMIT_NUMBER.',
'    </span>',
'</div>',
''))
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P3_PERMIT_NUMBER'
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(27015845414886509)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(27015615881886507)
,p_button_name=>'SAVE_DRAFT'
,p_button_static_id=>'BTN_SAVE_DRAFT_P3'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Save Draft'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_security_scheme=>wwv_flow_imp.id(31533963716212424)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(27015908062886510)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(27015615881886507)
,p_button_name=>'NEXT_STEP'
,p_button_static_id=>'BTN_NEXT_STEP_P3'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Next Step'
,p_button_position=>'NEXT'
,p_icon_css_classes=>'fa-arrow-right'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(27015706306886508)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(27015615881886507)
,p_button_name=>'BACK'
,p_button_static_id=>'BTN_BACK_P3'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Back'
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_PERMIT_ID:&P3_PERMIT_ID.'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(27016855871886519)
,p_branch_name=>'Go to Equipment Isolation (NEXT_STEP)'
,p_branch_action=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:4:P4_PERMIT_ID:&P3_PERMIT_ID.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_branch_condition=>'NEXT_STEP'
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
 p_id=>wwv_flow_imp.id(26945059061347721)
,p_name=>'P3_PERMIT_ID'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26945136605347722)
,p_name=>'P3_PERMIT_NUMBER'
,p_item_sequence=>50
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26945279075347723)
,p_name=>'P3_CONTROL_MEASURES_ID'
,p_item_sequence=>60
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26945368522347724)
,p_name=>'P3_WORKFLOW_STATUS'
,p_item_sequence=>80
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26945586048347726)
,p_name=>'P3_CURRENT_STEP'
,p_item_sequence=>70
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26945920615347730)
,p_name=>'P3_CM_01'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(26945876367347729)
,p_prompt=>'1. All workers under this PTW have completed and signed off on a site induction?'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'CONTROL_MEASURES_LOV'
,p_lov=>'.'||wwv_flow_imp.id(45556223896387254)||'.'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tristate-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_help_text=>'All persons working under this PTW have received and signed, as understood, a suitable site induction?'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '3',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26946047126347731)
,p_name=>'P3_CM_02'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(26945876367347729)
,p_prompt=>'2. A reviewed risk assessment and method statement, including emergency evacuation, is in place and understood by all workers.?'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'CONTROL_MEASURES_LOV'
,p_lov=>'.'||wwv_flow_imp.id(45556223896387254)||'.'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tristate-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_help_text=>'A suitable and sufficient written risk assessment and method statement for these works, which has already been understood by all persons working under this permit is in place and has been reviewed at the point of works by the person controlling the w'
||'orks. This must include the provision of an emergency evacuation plan.'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '3',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26946143877347732)
,p_name=>'P3_CM_03'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(26945876367347729)
,p_prompt=>'3. The competence of the people working under the permit has been checked and is deemed to be adequate for these works.'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'CONTROL_MEASURES_LOV'
,p_lov=>'.'||wwv_flow_imp.id(45556223896387254)||'.'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tristate-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '3',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26946223267347733)
,p_name=>'P3_CM_04'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(26945876367347729)
,p_prompt=>'4. The person in charge of the works must be made aware of all hazards within the vicinity of the place of works.'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'CONTROL_MEASURES_LOV'
,p_lov=>'.'||wwv_flow_imp.id(45556223896387254)||'.'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tristate-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '3',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26946306544347734)
,p_name=>'P3_CM_05'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(26945876367347729)
,p_prompt=>'5. Where the use of PPE is identified as a control measure within the risk assessment, this equipment is in good order.'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'CONTROL_MEASURES_LOV'
,p_lov=>'.'||wwv_flow_imp.id(45556223896387254)||'.'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tristate-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '3',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26946460935347735)
,p_name=>'P3_CM_06'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(26945876367347729)
,p_prompt=>'6. Confirm that all sources of supply have been isolated, locked off and caution signs fitted, list details below.'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'CONTROL_MEASURES_LOV'
,p_lov=>'.'||wwv_flow_imp.id(45556223896387254)||'.'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tristate-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '3',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26946580896347736)
,p_name=>'P3_CM_07'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(26945876367347729)
,p_prompt=>'7. Confirm all isolated supplies are proven or confirmed dead before work starts?'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'CONTROL_MEASURES_LOV'
,p_lov=>'.'||wwv_flow_imp.id(45556223896387254)||'.'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tristate-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_help_text=>'Confirm that all isolated sources of supply have been proved dead using an approved tester and proving unit, where this is not possible the AP must confirm dead at the point of work after the issue of this Permit.'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '3',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26946695226347737)
,p_name=>'P3_CM_08'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(26945876367347729)
,p_prompt=>'8. Confirm all systems to be worked on have been checked to ensure that any stored energy has been dissipated.'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'CONTROL_MEASURES_LOV'
,p_lov=>'.'||wwv_flow_imp.id(45556223896387254)||'.'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tristate-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '3',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26946751805347738)
,p_name=>'P3_CM_09'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(26945876367347729)
,p_prompt=>'9. Confirm any live parts are insulated and no exposed live components remain?'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'CONTROL_MEASURES_LOV'
,p_lov=>'.'||wwv_flow_imp.id(45556223896387254)||'.'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tristate-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_help_text=>'Confirm that if any section of the equipment is still live it is covered in a suitable insulating material and that there are no exposed live parts.'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '3',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26946827031347739)
,p_name=>'P3_CM_10'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(26945876367347729)
,p_prompt=>'10. Confirm that sufficient measures are in place to ensure that no live equipment is worked on.'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'CONTROL_MEASURES_LOV'
,p_lov=>'.'||wwv_flow_imp.id(45556223896387254)||'.'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tristate-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '3',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26946941194347740)
,p_name=>'P3_CM_11'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(26945876367347729)
,p_prompt=>'11. Confirm there are first aid facilities available.'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'CONTROL_MEASURES_LOV'
,p_lov=>'.'||wwv_flow_imp.id(45556223896387254)||'.'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tristate-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '3',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26947073709347741)
,p_name=>'P3_CM_12'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(26945876367347729)
,p_prompt=>'12. Confirm that suitable barriers have been used to clearly identify the working area.'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'CONTROL_MEASURES_LOV'
,p_lov=>'.'||wwv_flow_imp.id(45556223896387254)||'.'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tristate-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '3',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26947130506347742)
,p_name=>'P3_CM_13'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(26945876367347729)
,p_prompt=>'13. Confirm there is unrestricted access and egress to the working area.'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'CONTROL_MEASURES_LOV'
,p_lov=>'.'||wwv_flow_imp.id(45556223896387254)||'.'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tristate-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '3',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26947267129347743)
,p_name=>'P3_CM_14'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_imp.id(26945876367347729)
,p_prompt=>'14. Confirm there is suitable insulated matting available.'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'CONTROL_MEASURES_LOV'
,p_lov=>'.'||wwv_flow_imp.id(45556223896387254)||'.'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tristate-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '3',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26947364989347744)
,p_name=>'P3_CM_15'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_imp.id(26945876367347729)
,p_prompt=>'15. Confirm that the calibration of the test equipment is current.'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'CONTROL_MEASURES_LOV'
,p_lov=>'.'||wwv_flow_imp.id(45556223896387254)||'.'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tristate-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '3',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26947471506347745)
,p_name=>'P3_CM_16'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_imp.id(26945876367347729)
,p_prompt=>'16. Danger signs have been applied to adjacent live equipment.'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'CONTROL_MEASURES_LOV'
,p_lov=>'.'||wwv_flow_imp.id(45556223896387254)||'.'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-tristate-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '3',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26947670039347747)
,p_name=>'P3_PPE_SAFETY_HELMET'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(26947595929347746)
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
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26947785672347748)
,p_name=>'P3_PPE_ARC_FLASH'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(26947595929347746)
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
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26947896126347749)
,p_name=>'P3_PPE_SAFETY_FOOTWEAR'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(26947595929347746)
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
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26947959322347750)
,p_name=>'P3_PPE_HI_VIS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(26947595929347746)
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
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27015029071886501)
,p_name=>'P3_PPE_SAFETY_GOGGLES'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(26947595929347746)
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
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27015166302886502)
,p_name=>'P3_PPE_INSULATING_GLOVES'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(26947595929347746)
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
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27015285038886503)
,p_name=>'P3_PPE_FALL_RESTRAINT'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(26947595929347746)
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
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27015369515886504)
,p_name=>'P3_PPE_FALL_ARREST'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(26947595929347746)
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
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27015468453886505)
,p_name=>'P3_PPE_EAR_DEFENDERS'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(26947595929347746)
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
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27015533639886506)
,p_name=>'P3_PPE_SAFETY_GLOVES'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(26947595929347746)
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
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30143343361642702)
,p_name=>'P3_IS_CHANGED'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(27016045833886511)
,p_validation_name=>'Permit ID Required'
,p_validation_sequence=>10
,p_validation=>'P3_PERMIT_ID'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Permit ID is required. Please start from Step 1.'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(45757058192782522)
,p_validation_name=>'All Control Measures Must Be Confirmed'
,p_validation_sequence=>20
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'RETURN (',
'    :P3_CM_01 IS NOT NULL AND :P3_CM_02 IS NOT NULL AND',
'    :P3_CM_03 IS NOT NULL AND :P3_CM_04 IS NOT NULL AND',
'    :P3_CM_05 IS NOT NULL AND :P3_CM_06 IS NOT NULL AND',
'    :P3_CM_07 IS NOT NULL AND :P3_CM_08 IS NOT NULL AND',
'    :P3_CM_09 IS NOT NULL AND :P3_CM_10 IS NOT NULL AND',
'    :P3_CM_11 IS NOT NULL AND :P3_CM_12 IS NOT NULL AND',
'    :P3_CM_13 IS NOT NULL AND :P3_CM_14 IS NOT NULL AND',
'    :P3_CM_15 IS NOT NULL AND :P3_CM_16 IS NOT NULL',
');'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'All 16 control measures must be confirmed before proceeding to the next step.'
,p_always_execute=>'Y'
,p_validation_condition=>'NEXT_STEP'
,p_validation_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(30153697799398471)
,p_name=>'Get Location and Next Step'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(27015908062886510)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30154011180398458)
,p_event_id=>wwv_flow_imp.id(30153697799398471)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P3_IS_CHANGED'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'captureLocationThenSubmit(''NEXT_STEP'');',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(33350440547951418)
,p_name=>'Get Location and Save Draft'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(27015845414886509)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33350512772951419)
,p_event_id=>wwv_flow_imp.id(33350440547951418)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'captureLocationThenSubmit(''SAVE_DRAFT'');'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(27016268704886513)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save Control Measures and PPE Data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    -- PART 1: Save PPE to ptw_lv_permits (always UPDATE, record already exists)',
'    UPDATE ptw_pro.ptw_lv_permits',
'    SET    ppe_safety_helmet       = :P3_PPE_SAFETY_HELMET,',
'           ppe_arc_flash           = :P3_PPE_ARC_FLASH,',
'           ppe_safety_footwear     = :P3_PPE_SAFETY_FOOTWEAR,',
'           ppe_hi_vis              = :P3_PPE_HI_VIS,',
'           ppe_safety_goggles      = :P3_PPE_SAFETY_GOGGLES,',
'           ppe_insulating_gloves   = :P3_PPE_INSULATING_GLOVES,',
'           ppe_fall_restraint      = :P3_PPE_FALL_RESTRAINT,',
'           ppe_fall_arrest         = :P3_PPE_FALL_ARREST,',
'           ppe_ear_defenders       = :P3_PPE_EAR_DEFENDERS,',
'           ppe_safety_gloves       = :P3_PPE_SAFETY_GLOVES,',
'           ppe_latitude            = :APP_LATITUDE,',
'           ppe_longitude           = :APP_LONGITUDE,',
'           current_step            = :P3_CURRENT_STEP,',
'           workflow_status         = :P3_WORKFLOW_STATUS,',
'           modified_by             = NVL(V(''APP_USER''), USER),',
'           modified_date           = CURRENT_TIMESTAMP',
'    WHERE  permit_id = :P3_PERMIT_ID;',
'',
'    -- PART 2: Save Control Measures using MERGE (INSERT or UPDATE)',
'    MERGE INTO ptw_pro.ptw_lv_control_measures tgt',
'    USING (SELECT :P3_PERMIT_ID AS permit_id FROM dual) src',
'    ON (tgt.permit_id = src.permit_id)',
'    WHEN MATCHED THEN',
'        UPDATE SET',
'            cm_01_site_induction      = :P3_CM_01,',
'            cm_02_risk_assessment     = :P3_CM_02,',
'            cm_03_competence_checked  = :P3_CM_03,',
'            cm_04_hazards_aware       = :P3_CM_04,',
'            cm_05_ppe_identified      = :P3_CM_05,',
'            cm_06_sources_isolated    = :P3_CM_06,',
'            cm_07_proved_dead         = :P3_CM_07,',
'            cm_08_stored_energy       = :P3_CM_08,',
'            cm_09_live_covered        = :P3_CM_09,',
'            cm_10_no_live_work        = :P3_CM_10,',
'            cm_11_first_aid           = :P3_CM_11,',
'            cm_12_barriers            = :P3_CM_12,',
'            cm_13_access_egress       = :P3_CM_13,',
'            cm_14_insulated_matting   = :P3_CM_14,',
'            cm_15_calibration_current = :P3_CM_15,',
'            cm_16_danger_signs        = :P3_CM_16,',
'            cm_latitude               = :APP_LATITUDE,',
'            cm_longitude              = :APP_LONGITUDE,',
'            modified_date             = CURRENT_TIMESTAMP',
'    WHEN NOT MATCHED THEN',
'        INSERT (',
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
'            cm_16_danger_signs,',
'            cm_latitude,',
'            cm_longitude',
'        ) VALUES (',
'            :P3_PERMIT_ID,',
'            :P3_CM_01,',
'            :P3_CM_02,',
'            :P3_CM_03,',
'            :P3_CM_04,',
'            :P3_CM_05,',
'            :P3_CM_06,',
'            :P3_CM_07,',
'            :P3_CM_08,',
'            :P3_CM_09,',
'            :P3_CM_10,',
'            :P3_CM_11,',
'            :P3_CM_12,',
'            :P3_CM_13,',
'            :P3_CM_14,',
'            :P3_CM_15,',
'            :P3_CM_16,',
'            :APP_LATITUDE,',
'            :APP_LONGITUDE',
'        );',
'',
'    COMMIT;',
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
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(27016141402886512)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load Control Measures and PPE Data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    -- Load permit info (PPE columns)',
'    :P3_CURRENT_STEP := ''CONTROL_MEASURES'';',
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
'        :P3_PERMIT_NUMBER,',
'        :P3_PPE_SAFETY_HELMET,',
'        :P3_PPE_ARC_FLASH,',
'        :P3_PPE_SAFETY_FOOTWEAR,',
'        :P3_PPE_HI_VIS,',
'        :P3_PPE_SAFETY_GOGGLES,',
'        :P3_PPE_INSULATING_GLOVES,',
'        :P3_PPE_FALL_RESTRAINT,',
'        :P3_PPE_FALL_ARREST,',
'        :P3_PPE_EAR_DEFENDERS,',
'        :P3_PPE_SAFETY_GLOVES,',
'        :P3_WORKFLOW_STATUS',
'    FROM ptw_pro.ptw_lv_permits',
'    WHERE permit_id = :P3_PERMIT_ID;',
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
'            :P3_CONTROL_MEASURES_ID,',
'            :P3_CM_01,',
'            :P3_CM_02,',
'            :P3_CM_03,',
'            :P3_CM_04,',
'            :P3_CM_05,',
'            :P3_CM_06,',
'            :P3_CM_07,',
'            :P3_CM_08,',
'            :P3_CM_09,',
'            :P3_CM_10,',
'            :P3_CM_11,',
'            :P3_CM_12,',
'            :P3_CM_13,',
'            :P3_CM_14,',
'            :P3_CM_15,',
'            :P3_CM_16',
'        FROM ptw_pro.ptw_lv_control_measures',
'        WHERE permit_id = :P3_PERMIT_ID;',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN',
'            :P3_CONTROL_MEASURES_ID := NULL;',
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
,p_process_when=>'P3_PERMIT_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>27016141402886512
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(30143851377642707)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Engineer Own Permit Check'
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
'          SELECT COUNT(*) INTO v_is_auth ',
'          FROM   ptw_pro.ptw_lv_permits',
'          WHERE  permit_id = :P3_PERMIT_ID',
'          AND    NVL(UPPER(auth_person_name),''XXX'') = UPPER(V(''APP_USER''));  -- check if the engineer is the auth_person',
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
);
wwv_flow_imp.component_end;
end;
/
