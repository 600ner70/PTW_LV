prompt --application/pages/page_00010
begin
--   Manifest
--     PAGE: 00010
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
 p_id=>10
,p_name=>'LV Monitoring'
,p_alias=>'LV-MONITORING'
,p_step_title=>'Low Voltage Monitoring'
,p_autocomplete_on_off=>'OFF'
,p_javascript_file_urls=>'#APP_FILES#offline-storage#MIN#.js'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'let monitorSignaturePad;',
'',
'function initSignaturePads() {',
'    setTimeout(function() {',
'        initPad(''monitorSignaturePad'', ''P10_MONITOR_SIGNATURE_HIDDEN'', function(pad) {',
'            monitorSignaturePad = pad;',
'',
'            // Override canvas size to be larger than the default',
'            var canvas = document.getElementById(''monitorSignaturePad'');',
'            var regionBody = canvas.closest(''.t-Region-body'') ||',
'                             canvas.closest(''.t-ContentBody'') ||',
'                             canvas.parentElement;',
'            var newWidth  = regionBody ? regionBody.offsetWidth - 24 : 400;',
'            var newHeight = window.innerWidth < 768 ? 150 : 200;',
'',
'            canvas.width  = newWidth;',
'            canvas.height = newHeight;',
'            canvas.setAttribute(''style'',',
'                ''width:''  + newWidth  + ''px !important;'' +',
'                ''height:'' + newHeight + ''px !important;'' +',
'                ''border: 1px dashed var(--ut-component-border-color, #ccc);'' +',
'                ''border-radius: 4px;'' +',
'                ''touch-action: none;'' +',
'                ''cursor: crosshair;'' +',
'                ''display: block;''',
'            );',
'',
'            var existingDataUrl = apex.item(''P10_MONITOR_SIGNATURE_DATA_URL'').getValue();',
'            var workflowStatus  = apex.item(''P10_WORKFLOW_STATUS'').getValue();',
'',
'            setCanvasBackground(canvas);',
'',
'            if (existingDataUrl) {',
'                loadSignature(pad, canvas, existingDataUrl);',
'                lockCanvas(canvas);',
'                var clearBtn = document.querySelector(''.signature-controls button'');',
'                if (clearBtn) clearBtn.style.display = ''none'';',
'            } else if (workflowStatus !== ''STARTED'') {',
'                lockCanvas(canvas);',
'                var clearBtn = document.querySelector(''.signature-controls button'');',
'                if (clearBtn) clearBtn.style.display = ''none'';',
'            }',
'        });',
'    }, 200);',
'}',
'',
'function setCanvasBackground(canvas) {',
'    if (!canvas) return;',
'    var ctx = canvas.getContext(''2d'');',
'    ctx.save();',
'    ctx.globalCompositeOperation = ''destination-over'';',
'    ctx.fillStyle = ''#ffffff'';',
'    ctx.fillRect(0, 0, canvas.width, canvas.height);',
'    ctx.restore();',
'}',
'',
'function lockCanvas(canvas) {',
'    if (!canvas) return;',
'    canvas.style.pointerEvents  = ''none'';',
'    canvas.style.opacity        = ''0.85'';',
'    canvas.style.cursor         = ''not-allowed'';',
'    canvas.style.backgroundColor = ''#ffffff'';',
'    canvas.title                = ''Signature is locked'';',
'}',
'',
'function clearMonitorSignature() {',
'    if (monitorSignaturePad) monitorSignaturePad.clear();',
'    apex.item(''P10_MONITOR_SIGNATURE_HIDDEN'').setValue('''');',
'    // Re-apply white background after clear',
'    var canvas = document.getElementById(''monitorSignaturePad'');',
'    setCanvasBackground(canvas);',
'}'))
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'initSignaturePads();',
'// Re-display existing signature if record already has one saved.',
'// P10_MONITOR_SIGNATURE_DATA_URL is populated by the Before Header',
unistr('// process (BLOB \2192 base64 data URL). Mirrors Page 5 loadSignature() call.'),
'loadSignature(''monitorSignaturePad'', ''P10_MONITOR_SIGNATURE_DATA_URL'');',
'',
'(function () {',
'',
'    var TRISTATE_ITEMS = [',
'        ''P10_CHK_PERMIT_ON_DISPLAY'',',
'        ''P10_CHK_ACCESS_EGRESS'',',
'        ''P10_CHK_WARNING_SIGNS''',
'    ];',
'',
'    var BINARY_ITEMS = [',
'        ''P10_MS_CHECK1_IN_ORDER'',',
'        ''P10_MS_CHECK2_IN_ORDER'',',
'        ''P10_MS_CHECK3_IN_ORDER''',
'    ];',
'',
'    var TRISTATE_BADGES = [',
unistr('        { val: ''Y'',  cls: ''cm-badge-yes'', label: ''\2713'' },'),
unistr('        { val: ''N'',  cls: ''cm-badge-no'',  label: ''\2717'' },'),
'        { val: ''NA'', cls: ''cm-badge-na'',  label: ''N/A'' }',
'    ];',
'',
'    var BINARY_BADGES = [',
unistr('        { val: ''Y'', cls: ''cm-badge-yes'', label: ''\2713'' },'),
unistr('        { val: ''N'', cls: ''cm-badge-no'',  label: ''\2717'' }'),
'    ];',
'',
'    // Read-only when not STARTED, OR when viewing an existing monitoring record',
'    var isReadOnly = (apex.item(''P10_WORKFLOW_STATUS'').getValue() !== ''STARTED'') ||',
'                     (apex.item(''P10_MONITORING_ID'').getValue() !== '''' && ',
'                      apex.item(''P10_MONITORING_STATUS'').getValue() === ''COMPLETED'');',
'',
'    function buildBadgeRow(itemName, badges) {',
'        // apex.item().getValue() works in both edit and read-only mode',
'        var currentVal = apex.item(itemName).getValue() || '''';',
'',
'        var $row = $(''<div class="cm-badge-row"></div>'').attr(''data-item'', itemName);',
'',
'        badges.forEach(function (b) {',
'            $(''<span></span>'')',
'                .addClass(''cm-badge '' + b.cls)',
'                .toggleClass(''cm-active'', currentVal === b.val)',
'                .toggleClass(''cm-badge-readonly'', isReadOnly)',
'                .attr(''data-value'', b.val)',
'                .text(b.label)',
'                .appendTo($row);',
'        });',
'',
'        return $row;',
'    }',
'',
'    // Build tristate badges',
'    TRISTATE_ITEMS.forEach(function (itemName) {',
'        var $fc = $(''#'' + itemName).closest(''.t-Form-fieldContainer'');',
'        if ($fc.length === 0) return;',
'        $fc.find(''.cm-badge-row'').remove();',
'        $fc.find(''.t-Form-inputContainer'').append(',
'            buildBadgeRow(itemName, TRISTATE_BADGES)',
'        );',
'    });',
'',
'    // Build binary badges',
'    BINARY_ITEMS.forEach(function (itemName) {',
'        var $fc = $(''#'' + itemName).closest(''.t-Form-fieldContainer'');',
'        if ($fc.length === 0) return;',
'        $fc.find(''.cm-badge-row'').remove();',
'        $fc.find(''.t-Form-inputContainer'').append(',
'            buildBadgeRow(itemName, BINARY_BADGES)',
'        );',
'    });',
'',
'    // Hide native radio grids',
'    $(''.cm-tristate-item .apex-item-grid'').hide();',
'    $(''.cm-binary-item .apex-item-radio'').hide();',
'',
unistr('    // Delegated click \2014 edit mode only'),
'    $(document).off(''click.p10badges'').on(''click.p10badges'', ''.cm-badge:not(.cm-badge-readonly)'', function () {',
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
'}());'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.monitoring-section-title {',
'    font-size: 1.1rem;',
'    font-weight: 600;',
'    color: #003366;',
'    margin-bottom: 0.75rem;',
'    padding-bottom: 0.4rem;',
'    border-bottom: 2px solid #003366;',
'}',
'',
'.monitoring-instruction {',
'    font-size: 0.875rem;',
'    color: #555;',
'    font-style: italic;',
'    margin-bottom: 1rem;',
'    padding: 0.75rem 1rem;',
'    background: #f0f4fa;',
'    border-left: 4px solid #003366;',
'    border-radius: 4px;',
'}',
'',
'.monitoring-checks-grid {',
'    width: 100%;',
'    border-collapse: collapse;',
'    font-size: 0.9rem;',
'    margin-bottom: 1.5rem;',
'}',
'',
'.monitoring-checks-grid th {',
'    background: #003366;',
'    color: #fff;',
'    padding: 8px 12px;',
'    text-align: center;',
'    font-weight: 600;',
'    border: 1px solid #002244;',
'}',
'',
'.monitoring-checks-grid td {',
'    padding: 8px 12px;',
'    border: 1px solid #dde;',
'    vertical-align: middle;',
'}',
'',
'.monitoring-checks-grid tr:nth-child(even) td {',
'    background: #f7f9fc;',
'}',
'',
'.method-check-box {',
'    border: 1px solid #ccc;',
'    border-radius: 6px;',
'    padding: 1rem;',
'    margin-bottom: 1rem;',
'    background: #fff;',
'}',
'',
'.method-check-box h4 {',
'    margin: 0 0 0.75rem 0;',
'    font-size: 0.95rem;',
'    font-weight: 600;',
'    color: #003366;',
'}',
'',
'.col-a-header {',
'    background: #e8f0fb;',
'    padding: 0.5rem;',
'    border-radius: 4px;',
'    font-weight: 600;',
'    font-size: 0.8rem;',
'    text-transform: uppercase;',
'    letter-spacing: 0.04em;',
'    margin-bottom: 0.5rem;',
'}',
'',
'.col-b-header {',
'    background: #fef8e7;',
'    padding: 0.5rem;',
'    border-radius: 4px;',
'    font-weight: 600;',
'    font-size: 0.8rem;',
'    text-transform: uppercase;',
'    letter-spacing: 0.04em;',
'    margin-bottom: 0.5rem;',
'}',
'',
'.geo-info {',
'    font-size: 0.72rem;',
'    color: #999;',
'    margin-top: 4px;',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'EXPRESSION'
,p_read_only_when=>':P10_MONITORING_ID IS NOT NULL AND :P10_MONITORING_STATUS = ''COMPLETED'''
,p_read_only_when2=>'PLSQL'
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(40756625218498316)
,p_plug_name=>'Permit Badge'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>100
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="margin-bottom: 20px;">',
'    <span class="apex-badge" style="background-color: #3ea055; color: white; padding: 6px 16px; border-radius: 20px; font-weight: 600;">',
'        Permit: &P10_PERMIT_NUMBER.',
'    </span>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(40756808181498318)
,p_plug_name=>'Site Monitoring Checks'
,p_title=>'Site Monitoring Checks'
,p_icon_css_classes=>'fa-check-circle'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>110
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(40757578900498325)
,p_plug_name=>'Method Statement Checks'
,p_title=>'Checks Against Work Processes &amp; Method Statement'
,p_icon_css_classes=>'fa-tasks'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>120
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p class="monitoring-instruction">',
'    Checks against work processes and method statement - considering the work involved under this Sanction, on<br>',
'    reading the method detailed below an element you wish to check for compliance (note: the minimum is one<br>',
'    check per task carried out under each Sanction, but more are recommended dependent on activity complexity)',
'</p>',
'<div style="display:grid; grid-template-columns:1fr 1fr; gap:0.5rem; font-weight:600;',
'            font-size:0.8rem; text-transform:uppercase; margin-bottom:0.5rem;">',
'    <div class="col-a-header">&#x1F4CB; Column A &mdash; Detail the item or part of the method statement you decide to check</div>',
'    <div class="col-b-header">&#x2705; Column B &mdash; All works carried out correctly, or non-conforming details</div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(40758883896498338)
,p_plug_name=>'Sign-off'
,p_title=>'Monitoring Sign-Off'
,p_icon_css_classes=>'fa-user-circle'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>250
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(40759296869498342)
,p_plug_name=>'Signature Canvas'
,p_parent_plug_id=>wwv_flow_imp.id(40758883896498338)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>40
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'<div class="signature-pad-container">',
'    <canvas id="monitorSignaturePad" class="signature-pad"></canvas>',
'    <div class="signature-controls">',
'        <button type="button" onclick="clearMonitorSignature()">Clear</button>',
'    </div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(40759314865498343)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>260
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(40759594892498345)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(40759314865498343)
,p_button_name=>'SAVE_DRAFT'
,p_button_static_id=>'BTN_SAVE_DRAFT_P10'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Save Draft'
,p_button_position=>'NEXT'
,p_button_execute_validations=>'N'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P10_MONITORING_STATUS'
,p_button_condition2=>'IN_PROGRESS'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(40759672326498346)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(40759314865498343)
,p_button_name=>'SAVE_MONITORING'
,p_button_static_id=>'BTN_SAVE_MONITORING_P10'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save Monitoring'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P10_MONITORING_STATUS'
,p_button_condition2=>'IN_PROGRESS'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-save'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(40759411875498344)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(40759314865498343)
,p_button_name=>'BACK'
,p_button_static_id=>'BTN_BACK_P10'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Back'
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:1::'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(41969353797328824)
,p_branch_name=>'Back to report - SAVE MONITORING'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:1::'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
,p_branch_condition_type=>'EXPRESSION'
,p_branch_condition=>':REQUEST IN (''SAVE_DRAFT'',''SAVE_MONITORING'')'
,p_branch_condition_text=>'PLSQL'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40756370994498313)
,p_name=>'P10_PERMIT_ID'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40756412291498314)
,p_name=>'P10_MONITORING_ID'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40756796685498317)
,p_name=>'P10_PERMIT_NUMBER'
,p_item_sequence=>70
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40756948759498319)
,p_name=>'P10_CHK_PERMIT_ON_DISPLAY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(40756808181498318)
,p_prompt=>'Is Permit on display?'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Yes;Y,No;N,N/A;NA'
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-tristate-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '3',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40757037068498320)
,p_name=>'P10_CHK_PERMIT_TIME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(40756808181498318)
,p_prompt=>'Time of Check'
,p_placeholder=>'HH:MM'
,p_format_mask=>'HH:MI'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>5
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40757109552498321)
,p_name=>'P10_CHK_ACCESS_EGRESS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(40756808181498318)
,p_prompt=>'Is Access / Egress clear?'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Yes;Y,No;N,N/A;NA'
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-tristate-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '3',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40757299824498322)
,p_name=>'P10_CHK_ACCESS_TIME'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(40756808181498318)
,p_prompt=>'Time of check'
,p_placeholder=>'HH:MM'
,p_format_mask=>'HH:MM'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>5
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40757385583498323)
,p_name=>'P10_CHK_WARNING_SIGNS'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(40756808181498318)
,p_prompt=>'Are warning signs in place?'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Yes;Y,No;N,N/A;NA'
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-tristate-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '3',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40757409968498324)
,p_name=>'P10_CHK_WARNING_TIME'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(40756808181498318)
,p_prompt=>'Time of check'
,p_placeholder=>'HH:MM'
,p_format_mask=>'HH:MM'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>5
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40757678038498326)
,p_name=>'P10_MS_CHECK1_DETAIL'
,p_item_sequence=>130
,p_prompt=>'Check 1) Detail of check made'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>1000
,p_cHeight=>4
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40757759672498327)
,p_name=>'P10_MS_CHECK1_IN_ORDER'
,p_item_sequence=>140
,p_prompt=>'All in order?'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Yes - All in Order;Y,No - Non-Conforming;N'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-binary-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40757874990498328)
,p_name=>'P10_MS_CHECK1_TIME'
,p_item_sequence=>150
,p_prompt=>'Enter time of check'
,p_placeholder=>'HH:MM'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>5
,p_colspan=>3
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40757929896498329)
,p_name=>'P10_MS_CHECK1_COMMENTS'
,p_item_sequence=>160
,p_prompt=>'Comments'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>1000
,p_cHeight=>2
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_grid_column=>7
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40758074172498330)
,p_name=>'P10_MS_CHECK2_DETAIL'
,p_item_sequence=>170
,p_prompt=>'Check 2) Detail of check made'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>1000
,p_cHeight=>4
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40758100703498331)
,p_name=>'P10_MS_CHECK2_IN_ORDER'
,p_item_sequence=>180
,p_prompt=>'All in order?'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Yes - All in Order;Y,No - Non-Conforming;N'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-binary-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40758202652498332)
,p_name=>'P10_MS_CHECK2_TIME'
,p_item_sequence=>190
,p_prompt=>'Enter time of check'
,p_placeholder=>'HH:MM'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>5
,p_colspan=>3
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40758315255498333)
,p_name=>'P10_MS_CHECK2_COMMENTS'
,p_item_sequence=>200
,p_prompt=>'Comments'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>2
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_grid_column=>7
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40758415921498334)
,p_name=>'P10_MS_CHECK3_DETAIL'
,p_item_sequence=>210
,p_prompt=>'Check 3) Detail of check made'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>1000
,p_cHeight=>4
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40758515996498335)
,p_name=>'P10_MS_CHECK3_IN_ORDER'
,p_item_sequence=>220
,p_prompt=>'All in order?'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Yes - All in Order;Y,No - Non-Conforming;N'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-binary-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40758619994498336)
,p_name=>'P10_MS_CHECK3_TIME'
,p_item_sequence=>230
,p_prompt=>'Enter time of check'
,p_placeholder=>'HH:MM'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>5
,p_colspan=>3
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40758751775498337)
,p_name=>'P10_MS_CHECK3_COMMENTS'
,p_item_sequence=>240
,p_prompt=>'Comments'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>2
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_grid_column=>7
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40758952948498339)
,p_name=>'P10_MONITOR_NAME'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(40758883896498338)
,p_prompt=>'Monitoring carried out by (Name)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_colspan=>6
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40759052213498340)
,p_name=>'P10_MONITOR_DATE'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(40758883896498338)
,p_item_default=>'SELECT TO_CHAR(SYSDATE,''DD-MON-YYYY'') FROM DUAL'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Date'
,p_placeholder=>'DD-MON-YYYY'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40759179832498341)
,p_name=>'P10_MONITOR_SIGNATURE_HIDDEN'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(40758883896498338)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40759713686498347)
,p_name=>'P10_MONITOR_SIGNATURE_DATA_URL'
,p_item_sequence=>60
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(45757281850782524)
,p_name=>'P10_WORKFLOW_STATUS'
,p_item_sequence=>80
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(49364021888381901)
,p_name=>'P10_MONITORING_STATUS'
,p_item_sequence=>90
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(41967311032328804)
,p_validation_name=>'Monitor Name Required'
,p_validation_sequence=>10
,p_validation=>'P10_MONITOR_NAME'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Monitoring carried out by (Name) is required.'
,p_validation_condition=>':REQUEST = ''SAVE_MONITORING'''
,p_validation_condition2=>'PLSQL'
,p_validation_condition_type=>'EXPRESSION'
,p_associated_item=>wwv_flow_imp.id(40758952948498339)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(41967434843328805)
,p_validation_name=>'Monitor Date Required'
,p_validation_sequence=>20
,p_validation=>'P10_MONITOR_DATE'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Date is required.'
,p_validation_condition=>':REQUEST = ''SAVE_MONITORING'''
,p_validation_condition2=>'PLSQL'
,p_validation_condition_type=>'EXPRESSION'
,p_associated_item=>wwv_flow_imp.id(40759052213498340)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(41967585696328806)
,p_validation_name=>'At Least One Site Check Answered'
,p_validation_sequence=>30
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P10_CHK_PERMIT_ON_DISPLAY IS NOT NULL',
'OR :P10_CHK_ACCESS_EGRESS  IS NOT NULL',
'OR :P10_CHK_WARNING_SIGNS  IS NOT NULL'))
,p_validation2=>'PLSQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>'Please complete at least one site monitoring check.'
,p_validation_condition=>':REQUEST = ''SAVE_MONITORING'''
,p_validation_condition2=>'PLSQL'
,p_validation_condition_type=>'EXPRESSION'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(41967601034328807)
,p_validation_name=>'At Least One Method Statement Check'
,p_validation_sequence=>40
,p_validation=>':P10_MS_CHECK1_DETAIL IS NOT NULL'
,p_validation2=>'PLSQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>'At least one method statement compliance check (Check 1) is required.'
,p_validation_condition=>':REQUEST = ''SAVE_MONITORING'''
,p_validation_condition2=>'PLSQL'
,p_validation_condition_type=>'EXPRESSION'
,p_associated_item=>wwv_flow_imp.id(40757678038498326)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(40760046358498350)
,p_name=>'Click Save Draft'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(40759594892498345)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(41967040351328801)
,p_event_id=>wwv_flow_imp.id(40760046358498350)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'captureLocationThenSubmit(''SAVE_DRAFT'');'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(41967175979328802)
,p_name=>'Click Save Monitoring'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(40759672326498346)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(41967273274328803)
,p_event_id=>wwv_flow_imp.id(41967175979328802)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'saveSignatures();',
'captureLocationThenSubmit(''SAVE_MONITORING'');'))
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(40759823698498348)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load Monitoring Data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_mon    ptw_pro.ptw_lv_monitoring%ROWTYPE;',
'    v_clob   CLOB;',
'BEGIN',
'    -- Always load permit number and workflow status',
'    SELECT permit_number, workflow_status',
'    INTO   :P10_PERMIT_NUMBER, :P10_WORKFLOW_STATUS',
'    FROM   ptw_pro.ptw_lv_permits',
'    WHERE  permit_id = :P10_PERMIT_ID;',
'',
'    -- Only load monitoring data if editing an existing record',
'    IF :P10_MONITORING_ID IS NOT NULL THEN',
'        SELECT *',
'        INTO   v_mon',
'        FROM   ptw_pro.ptw_lv_monitoring',
'        WHERE  monitoring_id = :P10_MONITORING_ID',
'        AND    permit_id     = :P10_PERMIT_ID;',
'',
'        :P10_CHK_PERMIT_ON_DISPLAY := v_mon.chk_permit_on_display;',
'        :P10_CHK_PERMIT_TIME       := v_mon.chk_permit_time;',
'        :P10_CHK_ACCESS_EGRESS     := v_mon.chk_access_egress;',
'        :P10_CHK_ACCESS_TIME       := v_mon.chk_access_time;',
'        :P10_CHK_WARNING_SIGNS     := v_mon.chk_warning_signs;',
'        :P10_CHK_WARNING_TIME      := v_mon.chk_warning_time;',
'        :P10_MS_CHECK1_DETAIL      := v_mon.ms_check1_detail;',
'        :P10_MS_CHECK1_TIME        := v_mon.ms_check1_time;',
'        :P10_MS_CHECK1_IN_ORDER    := v_mon.ms_check1_in_order;',
'        :P10_MS_CHECK1_COMMENTS    := v_mon.ms_check1_comments;',
'        :P10_MS_CHECK2_DETAIL      := v_mon.ms_check2_detail;',
'        :P10_MS_CHECK2_TIME        := v_mon.ms_check2_time;',
'        :P10_MS_CHECK2_IN_ORDER    := v_mon.ms_check2_in_order;',
'        :P10_MS_CHECK2_COMMENTS    := v_mon.ms_check2_comments;',
'        :P10_MS_CHECK3_DETAIL      := v_mon.ms_check3_detail;',
'        :P10_MS_CHECK3_TIME        := v_mon.ms_check3_time;',
'        :P10_MS_CHECK3_IN_ORDER    := v_mon.ms_check3_in_order;',
'        :P10_MS_CHECK3_COMMENTS    := v_mon.ms_check3_comments;',
'        :P10_MONITOR_NAME          := v_mon.monitor_name;',
'        :P10_MONITORING_STATUS     := v_mon.monitoring_status;',
'        :P10_MONITOR_DATE          := TO_CHAR(v_mon.monitor_date, ''DD-MON-YYYY'');',
'',
'        IF v_mon.monitor_signature IS NOT NULL',
'           AND DBMS_LOB.GETLENGTH(v_mon.monitor_signature) > 0',
'        THEN',
'            v_clob := apex_web_service.blob2clobbase64(v_mon.monitor_signature);',
'            v_clob := REPLACE(REPLACE(v_clob, CHR(13), ''''), CHR(10), '''');',
'            :P10_MONITOR_SIGNATURE_DATA_URL :=',
'                ''data:image/png;base64,'' || DBMS_LOB.SUBSTR(v_clob, 32000, 1);',
'        END IF;',
'',
'    ELSE',
unistr('        -- New record \2014 set defaults only'),
'        :P10_MONITOR_DATE               := TO_CHAR(SYSDATE, ''DD-MON-YYYY'');',
'        :P10_MONITOR_SIGNATURE_DATA_URL := NULL;',
'        :P10_MONITORING_STATUS := ''IN_PROGRESS'';',
'    END IF;',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        apex_error.add_error(',
'            p_message          => ''Error loading monitoring data: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P10_PERMIT_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>40759823698498348
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(40759936491498349)
,p_process_sequence=>10
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save Monitoring Data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_sig     BLOB    := NULL;',
'    v_raw     VARCHAR2(32767);',
'    v_base64  VARCHAR2(32767);',
'    v_pos     NUMBER;',
'BEGIN',
'    -- -----------------------------------------------',
'    -- Convert base64 signature to BLOB (if provided)',
'    -- Same pattern as Pages 2-5.',
'    -- -----------------------------------------------',
'    v_raw := :P10_MONITOR_SIGNATURE_HIDDEN;',
'    IF v_raw IS NOT NULL AND LENGTH(v_raw) > 22 THEN',
'        v_pos    := INSTR(v_raw, '','');',
'        v_base64 := SUBSTR(v_raw, v_pos + 1);',
'        v_sig    := apex_web_service.clobbase642blob(TO_CLOB(v_base64));',
'    END IF;',
'',
'    -- -----------------------------------------------',
'    -- UPSERT monitoring record',
'    -- Location sourced from Application Items',
unistr('    -- :APP_LATITUDE / :APP_LONGITUDE \2014 populated by'),
'    -- captureLocationThenSubmit() before page submit.',
'    -- -----------------------------------------------',
'    IF :P10_MONITORING_ID IS NOT NULL THEN',
'        -- UPDATE',
'        UPDATE ptw_pro.ptw_lv_monitoring',
'        SET',
'            chk_permit_on_display  = :P10_CHK_PERMIT_ON_DISPLAY,',
'            chk_permit_time        = :P10_CHK_PERMIT_TIME,',
'            chk_access_egress      = :P10_CHK_ACCESS_EGRESS,',
'            chk_access_time        = :P10_CHK_ACCESS_TIME,',
'            chk_warning_signs      = :P10_CHK_WARNING_SIGNS,',
'            chk_warning_time       = :P10_CHK_WARNING_TIME,',
'            ms_check1_detail       = :P10_MS_CHECK1_DETAIL,',
'            ms_check1_time         = :P10_MS_CHECK1_TIME,',
'            ms_check1_in_order     = :P10_MS_CHECK1_IN_ORDER,',
'            ms_check1_comments     = :P10_MS_CHECK1_COMMENTS,',
'            ms_check2_detail       = :P10_MS_CHECK2_DETAIL,',
'            ms_check2_time         = :P10_MS_CHECK2_TIME,',
'            ms_check2_in_order     = :P10_MS_CHECK2_IN_ORDER,',
'            ms_check2_comments     = :P10_MS_CHECK2_COMMENTS,',
'            ms_check3_detail       = :P10_MS_CHECK3_DETAIL,',
'            ms_check3_time         = :P10_MS_CHECK3_TIME,',
'            ms_check3_in_order     = :P10_MS_CHECK3_IN_ORDER,',
'            ms_check3_comments     = :P10_MS_CHECK3_COMMENTS,',
'            monitor_name           = :P10_MONITOR_NAME,',
'            monitor_date           = TO_DATE(:P10_MONITOR_DATE, ''DD-MON-YYYY''),',
'            monitor_latitude       = :APP_LATITUDE,',
'            monitor_longitude      = :APP_LONGITUDE,',
'            monitor_signature      = CASE WHEN v_sig IS NOT NULL THEN v_sig',
'                                          ELSE monitor_signature END,',
'            monitoring_status      = CASE WHEN :REQUEST = ''SAVE_DRAFT'' THEN',
'                                         ''IN_PROGRESS''',
'                                     ELSE ',
'                                         ''COMPLETED''',
'                                     END,',
'            modified_date          = CURRENT_TIMESTAMP,',
'            modified_by            = NVL(V(''APP_USER''), USER)',
'        WHERE monitoring_id = :P10_MONITORING_ID;',
'    ELSE',
'        -- INSERT',
'        INSERT INTO ptw_pro.ptw_lv_monitoring (',
'            permit_id,',
'            chk_permit_on_display,  chk_permit_time,',
'            chk_access_egress,      chk_access_time,',
'            chk_warning_signs,      chk_warning_time,',
'            ms_check1_detail,       ms_check1_time,',
'            ms_check1_in_order,     ms_check1_comments,',
'            ms_check2_detail,       ms_check2_time,',
'            ms_check2_in_order,     ms_check2_comments,',
'            ms_check3_detail,       ms_check3_time,',
'            ms_check3_in_order,     ms_check3_comments,',
'            monitor_name,           monitor_date,',
'            monitor_latitude,       monitor_longitude,',
'            monitor_signature,      monitoring_status,',
'            created_date,           created_by',
'        ) VALUES (',
'            :P10_PERMIT_ID,',
'            :P10_CHK_PERMIT_ON_DISPLAY,  :P10_CHK_PERMIT_TIME,',
'            :P10_CHK_ACCESS_EGRESS,      :P10_CHK_ACCESS_TIME,',
'            :P10_CHK_WARNING_SIGNS,      :P10_CHK_WARNING_TIME,',
'            :P10_MS_CHECK1_DETAIL,       :P10_MS_CHECK1_TIME,',
'            :P10_MS_CHECK1_IN_ORDER,     :P10_MS_CHECK1_COMMENTS,',
'            :P10_MS_CHECK2_DETAIL,       :P10_MS_CHECK2_TIME,',
'            :P10_MS_CHECK2_IN_ORDER,     :P10_MS_CHECK2_COMMENTS,',
'            :P10_MS_CHECK3_DETAIL,       :P10_MS_CHECK3_TIME,',
'            :P10_MS_CHECK3_IN_ORDER,     :P10_MS_CHECK3_COMMENTS,',
'            :P10_MONITOR_NAME,           ',
'            TO_DATE(:P10_MONITOR_DATE, ''DD-MON-YYYY''),',
'            :APP_LATITUDE,               :APP_LONGITUDE,',
'            v_sig,',
'            CASE WHEN :REQUEST = ''SAVE_DRAFT'' THEN',
'                ''IN_PROGRESS''',
'            ELSE ',
'                ''COMPLETED''',
'            END,',
'            CURRENT_TIMESTAMP,           NVL(V(''APP_USER''), USER)',
'        )',
'        RETURNING monitoring_id INTO :P10_MONITORING_ID;',
'    END IF;',
'',
'    apex_application.g_print_success_message :=',
'        ''Monitoring data saved successfully at '' ||',
'        TO_CHAR(SYSDATE, ''DD-MON-YYYY HH24:MI'') || ''.'';',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        apex_error.add_error(',
'            p_message          => ''Error saving monitoring data: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>':REQUEST IN (''SAVE_DRAFT'',''SAVE_MONITORING'')'
,p_process_when_type=>'EXPRESSION'
,p_process_when2=>'PLSQL'
,p_internal_uid=>40759936491498349
);
wwv_flow_imp.component_end;
end;
/
