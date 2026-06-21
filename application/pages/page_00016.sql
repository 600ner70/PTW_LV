prompt --application/pages/page_00016
begin
--   Manifest
--     PAGE: 00016
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.17'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_page.create_page(
 p_id=>16
,p_name=>'Clear Permit'
,p_alias=>'CLEAR-PERMIT'
,p_page_mode=>'MODAL'
,p_step_title=>'Clear Permit'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var p16SigPad = null;',
'',
'function p16InitSig() {',
'    var canvas = document.getElementById(''p16SigCanvas'');',
'    if (!canvas) return;',
'    var wrapper = canvas.parentElement;',
'    var w = Math.max((wrapper ? wrapper.offsetWidth - 24 : 400), 280);',
'    canvas.width  = w;',
'    canvas.height = 150;',
'    canvas.style.width  = w + ''px'';',
'    canvas.style.height = ''150px'';',
'    var ctx = canvas.getContext(''2d'');',
'    ctx.strokeStyle = ''#000000'';',
'    ctx.lineWidth   = 2;',
'    ctx.lineCap     = ''round'';',
'    ctx.lineJoin    = ''round'';',
'    p16SigPad = new SignaturePad(canvas, ctx);',
'}',
'',
'function p16ClearSig() {',
'    if (p16SigPad) { p16SigPad.clear(); }',
'}',
'',
'function p16SaveSig() {',
'    if (!p16SigPad || p16SigPad.isEmpty) {',
'        apex.item(''P16_CLEAR_SIGNATURE_DATA'').setValue('''');',
'    } else {',
'        apex.item(''P16_CLEAR_SIGNATURE_DATA'').setValue(p16SigPad.getDataURL());',
'    }',
'}',
''))
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('// \2500\2500 Shared state \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'var p16Status  = apex.item(''P16_WORKFLOW_STATUS'').getValue();',
'var isReadOnly = (p16Status !== ''STARTED'');',
'',
unistr('// \2500\2500 Signature pad init \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
unistr('// \2500\2500 Signature pad init \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'setTimeout(function () {',
'    p16InitSig();',
'',
'    // Always clear first to prevent stale canvas from previous open',
'    if (p16SigPad) { p16SigPad.clear(); }',
'',
unistr('    // \2500\2500 Load existing signature (COMPLETED view) \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'    var existingSig = apex.item(''P16_CLEAR_SIGNATURE_DATA_URL'').getValue();',
'',
'    if (existingSig) {',
'        loadSignature(p16SigPad, document.getElementById(''p16SigCanvas''), existingSig);',
'',
'        if (isReadOnly) {',
'            var canvas = document.getElementById(''p16SigCanvas'');',
'            if (canvas) {',
'                canvas.style.pointerEvents  = ''none'';',
'                canvas.style.opacity        = ''0.85'';',
'                canvas.style.cursor         = ''not-allowed'';',
'                canvas.title                = ''Signature locked'';',
'            }',
'            var clearBtn = document.getElementById(''p16ClearSigBtn'');',
'            if (clearBtn) clearBtn.style.display = ''none'';',
'        }',
'    } else if (isReadOnly) {',
unistr('        // STARTED but no sig yet \2014 just lock canvas'),
'        var canvas = document.getElementById(''p16SigCanvas'');',
'        if (canvas) {',
'            canvas.style.pointerEvents  = ''none'';',
'            canvas.style.opacity        = ''0.85'';',
'            canvas.style.cursor         = ''not-allowed'';',
'        }',
'    }',
'',
'}, 350);',
'',
unistr('// \2500\2500 Save signature before submit \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'apex.jQuery(document).on(''apexbeforepagesubmit'', function () {',
'    p16SaveSig();',
'});',
'',
unistr('// \2500\2500 Binary Y/N badges \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'(function () {',
'',
'    var BINARY_ITEMS = [',
'        ''P16_CLEAR_WORK_COMPLETE'',',
'        ''P16_CLEAR_AREA_SAFE''',
'    ];',
'',
'    var BADGES = [',
unistr('        { val: ''Y'', cls: ''binary-badge-yes'', label: ''\2713'' },'),
unistr('        { val: ''N'', cls: ''binary-badge-no'',  label: ''\2717'' }'),
'    ];',
'',
'    BINARY_ITEMS.forEach(function (itemName) {',
'',
'        var $fc = $(''#'' + itemName).closest(''.t-Form-fieldContainer'');',
'        if ($fc.length === 0) return;',
'',
'        $fc.find(''.binary-badge-row'').remove();',
'',
'        var currentVal = '''';',
'        if (!isReadOnly) {',
'            currentVal = $(''input[name="'' + itemName + ''"]:checked'').val() || '''';',
'        } else {',
'            currentVal = apex.item(itemName).getValue() || '''';',
'        }',
'',
'        var $row = $(''<div class="binary-badge-row"></div>'').attr(''data-item'', itemName);',
'',
'        BADGES.forEach(function (b) {',
'            $(''<span></span>'')',
'                .addClass(''binary-badge '' + b.cls)',
'                .toggleClass(''cm-active'', currentVal === b.val)',
'                .toggleClass(''binary-readonly'', isReadOnly)',
'                .attr(''data-value'', b.val)',
'                .text(b.label)',
'                .appendTo($row);',
'        });',
'',
'        $fc.find(''.t-Form-inputContainer'').append($row);',
'    });',
'',
'    $(''.cm-binary-item .apex-item-grid'').hide();',
'',
'    $(document).off(''click.binarybadge'').on(''click.binarybadge'', ''.binary-badge:not(.binary-readonly)'', function () {',
'        var $badge   = $(this);',
'        var $row     = $badge.closest(''.binary-badge-row'');',
'        var itemName = $row.attr(''data-item'');',
'        var val      = $badge.attr(''data-value'');',
'',
'        $(''input[name="'' + itemName + ''"][value="'' + val + ''"]'')',
'            .prop(''checked'', true).trigger(''change'');',
'',
'        $row.find(''.binary-badge'').removeClass(''cm-active'');',
'        $badge.addClass(''cm-active'');',
'    });',
'',
'}());',
'',
unistr('// \2500\2500 Lock text fields in read-only mode \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'if (isReadOnly) {',
'    var readOnlyItems = [',
'        ''P16_CLEAR_PERSON_NAME'',',
'        ''P16_CLEAR_PERSON_MOBILE'',',
'        ''P16_CLEAR_COMPANY'',',
'        ''P16_CLEAR_DATETIME''',
'    ];',
'    readOnlyItems.forEach(function (itemName) {',
'        var $el = $(''#'' + itemName);',
'        $el.prop(''readonly'', true)',
'           .css({',
'               ''background-color'': ''rgb(213, 209, 209)'',',
'               ''pointer-events'':   ''none'',',
'               ''cursor'':           ''default''',
'           });',
'    });',
'',
'    // Hide submit button',
'    $(''#BTN_CLEAR_PERMIT_P16'').hide();',
'}',
'',
unistr('// \2500\2500 Required star (mandatory indicator) \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'function initP16RequiredStars() {',
'    var $fc = $(''#P16_CLEAR_WORK_COMPLETE'').closest(''.t-Form-fieldContainer'');',
'    if ($fc.length === 0) return;',
'    $fc.find(''.t-Form-labelContainer label, label'').first()',
'       .append(''<span class="cm-required-star" aria-hidden="true"> *</span>'');',
'}',
'',
'apex.jQuery(document).on(''apexreadyend'', function () {',
'    initP16RequiredStars();',
'});',
'',
unistr('// \2500\2500 Declaration text update \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'function p16UpdateDeclaration() {',
'    var workVal = apex.item(''P16_CLEAR_WORK_COMPLETE'').getValue();',
'    var safeVal = apex.item(''P16_CLEAR_AREA_SAFE'').getValue();',
'',
'    var $work = $(''#p16-decl-work-complete'');',
'    if (workVal === ''Y'') {',
'        $work.text(''completed'').css(''color'', ''#1e7e34'');',
'    } else if (workVal === ''N'') {',
'        $work.text(''not completed'').css(''color'', ''#a71d2a'');',
'    } else {',
'        $work.text(''completed / not completed'').css(''color'', ''#344B5C'');',
'    }',
'',
'    var $safe = $(''#p16-decl-area-safe'');',
'    var $tidy = $(''#p16-decl-area-tidy'');',
'    if (safeVal === ''Y'') {',
'        $safe.text(''is'').css(''color'', ''#1e7e34'');',
'        $tidy.text(''has'').css(''color'', ''#1e7e34'');',
'    } else if (safeVal === ''N'') {',
'        $safe.text(''is NOT'').css(''color'', ''#a71d2a'');',
'        $tidy.text(''has NOT'').css(''color'', ''#a71d2a'');',
'    } else {',
'        $safe.text(''is / is not'').css(''color'', ''#344B5C'');',
'        $tidy.text(''has / has not'').css(''color'', ''#344B5C'');',
'    }',
'}',
'',
'// Run on load then on every badge click',
'p16UpdateDeclaration();',
'',
'$(document).on(''click.p16decl'', ''.binary-badge'', function () {',
'    setTimeout(p16UpdateDeclaration, 50);',
'});'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.p16-declaration-box {',
'    background: #fff8e1;',
'    border-left: 4px solid #f59c00;',
'    padding: 16px 20px;',
'    border-radius: 4px;',
'    font-size: 14px;',
'    line-height: 1.7;',
'    margin-bottom: 4px;',
'}',
'.p16-declaration-box strong { color: #344B5C; }',
'',
'.p16-sig-wrapper canvas {',
'    display: block;',
'    border: 1px dashed var(--ut-component-border-color, #ccc);',
'    border-radius: 4px;',
'    touch-action: none;',
'    cursor: crosshair;',
'    background: #fff;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(31533963716212424)
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(41970349812328834)
,p_plug_name=>'Permit Info Banner'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>50
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-Alert t-Alert--info t-Alert--horizontal" role="region" style="margin-bottom:8px;">',
'  <div class="t-Alert-wrap">',
'    <div class="t-Alert-icon"><span class="t-Icon fa fa-check-circle-o"></span></div>',
'    <div class="t-Alert-content">',
'      <div class="t-Alert-header">',
'        <h2 class="t-Alert-title">Clearance of Permit to Work</h2>',
'      </div>',
'      <div class="t-Alert-body">',
'        Permit: <strong>&P16_PERMIT_NUMBER.</strong>',
'      </div>',
'    </div>',
'  </div>',
'</div>',
''))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(41970462082328835)
,p_plug_name=>'Declaration'
,p_title=>'Declaration'
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>60
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="p16-declaration-box">',
'  <p style="margin:0 0 10px 0;">',
'    By signing below, I confirm that the works carried out under this Permit to Work',
'    have been <strong id="p16-decl-work-complete">completed / not completed</strong> and that all personnel under',
'    my supervision have vacated the work area.',
'  </p>',
'  <p style="margin:0 0 10px 0;">',
'    I confirm that it <strong id="p16-decl-area-safe">is / is not</strong> safe to reinstate the plant and',
'    equipment which has been worked on under this Permit to Work.',
'  </p>',
'  <p style="margin:0;">',
'    The work area <strong id="p16-decl-area-tidy">has / has not</strong> been left in a safe and tidy condition,',
'    all temporary measures have been removed, and all waste has been cleared from site.',
'    This Permit to Work is hereby surrendered and closed.',
'  </p>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(41970550498328836)
,p_plug_name=>'Person in Charge of Works'
,p_title=>'Person in Charge of Works'
,p_icon_css_classes=>'fa-user'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>70
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(41970654008328837)
,p_plug_name=>'Signature'
,p_title=>unistr('Signature \2013 Person in Charge of Works')
,p_icon_css_classes=>'fa-pencil'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>80
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="p16-sig-wrapper">',
'  <label class="t-Form-label" style="display:block;margin-bottom:6px;">',
'    Signature <span style="color:#C0392B;" aria-hidden="true">*</span>',
'  </label>',
'  <canvas id="p16SigCanvas"></canvas>',
'  <button type="button"',
'          class="t-Button t-Button--small t-Button--simple"',
'          id="p16ClearSigBtn"',
'          style="margin-top:6px;"',
'          onclick="p16ClearSig()">',
'    <span class="fa fa-eraser" aria-hidden="true"></span> Clear Signature',
'  </button>',
'</div>',
''))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(41970736729328838)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>90
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(41971873495328849)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(41970736729328838)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(41971964243328850)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(41970736729328838)
,p_button_name=>'CLEAR_PERMIT'
,p_button_static_id=>'BTN_CLEAR_PERMIT_P16'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Clear Permit'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-check-circle'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(47748469701890006)
,p_branch_name=>'Back to Dashboard after saving'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:1::'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_branch_condition=>'P16_CLEARED'
,p_branch_condition_text=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(41970853732328839)
,p_name=>'P16_PERMIT_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(41970550498328836)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(41970924705328840)
,p_name=>'P16_PERMIT_NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(41970550498328836)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(41971091989328841)
,p_name=>'P16_CLEAR_WORK_COMPLETE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(41970462082328835)
,p_prompt=>'Works are completed?'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Completed;Y,Not Complete;N'
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-binary-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(41971120202328842)
,p_name=>'P16_CLEAR_AREA_SAFE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(41970462082328835)
,p_prompt=>'It is safe to reinstate plant and equipment?'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Safe to reinstate plant and equipment;Y,NOT Safe to reinstate;N'
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-binary-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(41971205189328843)
,p_name=>'P16_CLEAR_PERSON_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(41970550498328836)
,p_prompt=>'Name'
,p_placeholder=>'Full name of person in charge'
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
 p_id=>wwv_flow_imp.id(41971361135328844)
,p_name=>'P16_CLEAR_COMPANY'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(41970550498328836)
,p_prompt=>'Company'
,p_placeholder=>'Company Name'
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
 p_id=>wwv_flow_imp.id(41971460280328845)
,p_name=>'P16_CLEAR_PERSON_MOBILE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(41970550498328836)
,p_prompt=>'Mobile Tel. No.'
,p_placeholder=>'07700 900000'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>50
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(41971556521328846)
,p_name=>'P16_CLEAR_DATETIME'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(41970550498328836)
,p_prompt=>'Time / Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(41971678908328847)
,p_name=>'P16_CLEAR_SIGNATURE_DATA'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(41970654008328837)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(41971786256328848)
,p_name=>'P16_CLEARED'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(41970550498328836)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(45757410227782526)
,p_name=>'P16_WORKFLOW_STATUS'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(45757583978782527)
,p_name=>'P16_CLEAR_SIGNATURE_DATA_URL'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(45755602418782508)
,p_validation_name=>'Work Complete Required'
,p_validation_sequence=>10
,p_validation=>'P16_CLEAR_WORK_COMPLETE'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Please indicate whether the works are completed or not complete.'
,p_when_button_pressed=>wwv_flow_imp.id(41971964243328850)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(45755711527782509)
,p_validation_name=>'Area Safe Required'
,p_validation_sequence=>20
,p_validation=>'P16_CLEAR_AREA_SAFE'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Please indicate whether it is safe to reinstate plant and equipment.'
,p_when_button_pressed=>wwv_flow_imp.id(41971964243328850)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(45755897998782510)
,p_validation_name=>'Person Name Required'
,p_validation_sequence=>30
,p_validation=>'P16_CLEAR_PERSON_NAME'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Name of Person in Charge is required.'
,p_when_button_pressed=>wwv_flow_imp.id(41971964243328850)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(45755944608782511)
,p_validation_name=>'Signature Required'
,p_validation_sequence=>40
,p_validation=>'P16_CLEAR_SIGNATURE_DATA'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'A signature is required to clear the permit.'
,p_when_button_pressed=>wwv_flow_imp.id(41971964243328850)
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(45756000957782512)
,p_validation_name=>'Permit Still Valid'
,p_validation_sequence=>50
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_count NUMBER;',
'BEGIN',
'    SELECT COUNT(*)',
'    INTO   v_count',
'    FROM   ptw_pro.ptw_lv_permits',
'    WHERE  permit_id       = :P16_PERMIT_ID',
'    AND    workflow_status = ''STARTED''',
'    AND    SYSDATE         < ended_datetime;',
'    RETURN v_count > 0;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>unistr('Permit can no longer be cleared \2014 it may have expired or already been closed.')
,p_when_button_pressed=>wwv_flow_imp.id(41971964243328850)
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(45754945488782501)
,p_name=>'Cancel - Close Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(41971873495328849)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(45755093312782502)
,p_event_id=>wwv_flow_imp.id(45754945488782501)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(45755186137782503)
,p_name=>'Clear Permit - Capture Location and Submit'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(41971964243328850)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(45755261851782504)
,p_event_id=>wwv_flow_imp.id(45755186137782503)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'captureLocationThenSubmit(''CLEAR_PERMIT'');'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(45755480536782506)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Clear Permit'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_sig_blob  BLOB;',
'    v_clob      CLOB;',
'    v_now       DATE := SYSDATE;',
'BEGIN',
'    -- Convert base64 signature PNG to BLOB',
'    IF :P16_CLEAR_SIGNATURE_DATA IS NOT NULL THEN',
'        v_clob     := REPLACE(:P16_CLEAR_SIGNATURE_DATA,',
'                              ''data:image/png;base64,'', '''');',
'        v_sig_blob := apex_web_service.clobbase642blob(v_clob);',
'    END IF;',
'',
'    UPDATE ptw_pro.ptw_lv_permits',
'    SET    clear_work_complete    = :P16_CLEAR_WORK_COMPLETE,',
'           clear_area_safe        = :P16_CLEAR_AREA_SAFE,',
'           clear_person_name      = UPPER(TRIM(:P16_CLEAR_PERSON_NAME)),',
'           clear_company          = UPPER(TRIM(:P16_CLEAR_COMPANY)),',
'           clear_person_mobile    = TRIM(:P16_CLEAR_PERSON_MOBILE),',
'           clear_person_signature = v_sig_blob,',
'           clear_datetime         = v_now,',
'           clear_latitude         = TO_NUMBER(:APP_LATITUDE),',
'           clear_longitude        = TO_NUMBER(:APP_LONGITUDE),',
'           workflow_status        = ''COMPLETED'',',
'           current_step           = ''CLEARANCE'',',
'           completion_date        = v_now,',
'           modified_by            = V(''APP_USER''),',
'           modified_date          = v_now',
'    WHERE  permit_id              = :P16_PERMIT_ID',
'    AND    workflow_status        = ''STARTED''',
'    AND    SYSDATE                < ended_datetime;',
'',
'    IF SQL%ROWCOUNT = 0 THEN',
'        RAISE_APPLICATION_ERROR(-20001,',
'            ''Permit could not be cleared. It may have expired or ''',
'            || ''already been closed. Please refresh the permits list.'');',
'    END IF;',
'',
'    COMMIT;',
'    :P16_CLEARED := ''Y'';',
'    apex_application.g_print_success_message :=',
'        ''Permit '' || :P16_PERMIT_NUMBER || '' cleared successfully.'';',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_error.add_error(',
'            p_message          => ''Error clearing permit: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(41971964243328850)
,p_internal_uid=>45755480536782506
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(45755524966782507)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_01=>'P16_CLEARED'
,p_attribute_02=>'N'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P16_CLEARED'
,p_process_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_process_when2=>'N'
,p_internal_uid=>45755524966782507
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(45755388825782505)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load Permit Data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_status   VARCHAR2(20);',
'    v_ended    DATE;',
'BEGIN',
'    SELECT workflow_status,',
'           ended_datetime,',
'           permit_number,',
'           person_in_charge_name,',
'           supervising_company,',
'           accept_person_mobile,',
'           clear_work_complete,',
'           clear_area_safe,',
'           clear_person_name,',
'           clear_person_mobile,',
'           clear_company,',
'           TO_CHAR(clear_datetime, ''DD-MON-YYYY HH24:MI'')',
'    INTO   v_status,',
'           v_ended,',
'           :P16_PERMIT_NUMBER,',
'           :P16_CLEAR_PERSON_NAME,',
'           :P16_CLEAR_COMPANY,',
'           :P16_CLEAR_PERSON_MOBILE,',
'           :P16_CLEAR_WORK_COMPLETE,',
'           :P16_CLEAR_AREA_SAFE,',
'           :P16_CLEAR_PERSON_NAME,',
'           :P16_CLEAR_PERSON_MOBILE,',
'           :P16_CLEAR_COMPANY,',
'           :P16_CLEAR_DATETIME',
'    FROM   ptw_pro.ptw_lv_permits',
'    WHERE  permit_id = :P16_PERMIT_ID;',
'',
'    -- Guard: must be STARTED or COMPLETED',
'    IF v_status NOT IN (''STARTED'', ''COMPLETED'') THEN',
'        apex_error.add_error(',
'            p_message          => ''This permit cannot be viewed here. Current status: ''',
'                                  || v_status,',
'            p_display_location => apex_error.c_on_error_page',
'        );',
'        RETURN;',
'    END IF;',
'',
'    -- For STARTED: check validity window and default datetime to now',
'    IF v_status = ''STARTED'' THEN',
'        IF SYSDATE >= v_ended THEN',
'            apex_error.add_error(',
'                p_message          => ''This permit has expired (''',
'                                      || TO_CHAR(v_ended, ''DD-MON-YYYY HH24:MI'')',
'                                      || '') and cannot be cleared.'',',
'                p_display_location => apex_error.c_on_error_page',
'            );',
'            RETURN;',
'        END IF;',
'        -- Default datetime to now only when clearing (not yet set)',
'        IF :P16_CLEAR_DATETIME IS NULL THEN',
'            :P16_CLEAR_DATETIME := TO_CHAR(SYSDATE, ''DD-MON-YYYY HH24:MI'');',
'        END IF;',
'    END IF;',
'',
'    -- For COMPLETED: existing clearance data already loaded from SELECT above',
'    -- P16_CLEAR_DATETIME will contain the stored clear_datetime value',
'    IF v_status = ''COMPLETED'' AND :P16_CLEAR_DATETIME IS NOT NULL THEN',
'        :P16_CLEAR_DATETIME := TO_CHAR(',
'                                   TO_DATE(:P16_CLEAR_DATETIME, ''DD-MON-YYYY HH24:MI''),',
'                                   ''DD-MON-YYYY HH24:MI''',
'                               );',
'    END IF;',
'',
'    DECLARE',
'        v_sig  BLOB;',
'        v_clob CLOB;',
'    BEGIN',
'        IF v_status = ''COMPLETED'' THEN',
'            SELECT clear_person_signature',
'            INTO   v_sig',
'            FROM   ptw_pro.ptw_lv_permits',
'            WHERE  permit_id = :P16_PERMIT_ID',
'            AND    clear_person_signature IS NOT NULL',
'            AND    DBMS_LOB.GETLENGTH(clear_person_signature) > 0;',
'',
'            IF v_sig IS NOT NULL AND DBMS_LOB.GETLENGTH(v_sig) > 0 THEN',
'                v_clob := apex_web_service.blob2clobbase64(v_sig);',
'                v_clob := REPLACE(REPLACE(v_clob, CHR(13), ''''), CHR(10), '''');',
'                :P16_CLEAR_SIGNATURE_DATA_URL :=',
'                    ''data:image/png;base64,'' || DBMS_LOB.SUBSTR(v_clob, 32000, 1);',
'            ELSE',
'                :P16_CLEAR_SIGNATURE_DATA_URL := NULL;',
'            END IF;',
'        END IF;',
'',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN',
'            :P16_CLEAR_SIGNATURE_DATA_URL := NULL;',
'        WHEN OTHERS THEN',
'            :P16_CLEAR_SIGNATURE_DATA_URL := NULL;',
'    END;',
'',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        apex_error.add_error(',
'            p_message          => ''Permit not found.'',',
'            p_display_location => apex_error.c_on_error_page',
'        );',
'    WHEN OTHERS THEN',
'        apex_error.add_error(',
'            p_message          => ''Error loading permit data: '' || SQLERRM,',
'            p_display_location => apex_error.c_on_error_page',
'        );',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>45755388825782505
);
wwv_flow_imp.component_end;
end;
/
