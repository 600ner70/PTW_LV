prompt --application/pages/page_00016
begin
--   Manifest
--     PAGE: 00016
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
 p_id=>16
,p_name=>'&P16_BANNER_TITLE.'
,p_alias=>'CLEAR-PERMIT'
,p_page_mode=>'MODAL'
,p_step_title=>'&P16_BANNER_TITLE.'
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
'',
'var p16EngSigPad = null;',
'',
'function p16InitEngSig() {',
'    var canvas = document.getElementById(''p16EngSigCanvas'');',
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
'    p16EngSigPad = new SignaturePad(canvas, ctx);',
'}',
'',
'function p16ClearEngSig() {',
'    if (p16EngSigPad) { p16EngSigPad.clear(); }',
'}',
'',
'function p16SaveEngSig() {',
'    if (!p16EngSigPad || p16EngSigPad.isEmpty) {',
'        apex.item(''P16_CLEAR_ENG_SIGNATURE_DATA'').setValue('''');',
'    } else {',
'        apex.item(''P16_CLEAR_ENG_SIGNATURE_DATA'').setValue(p16EngSigPad.getDataURL());',
'    }',
'}',
''))
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('// \2500\2500 Shared state \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'var p16Status  = apex.item(''P16_WORKFLOW_STATUS'').getValue();',
'var isReadOnly = (p16Status !== ''STARTED'' && p16Status !== ''LAPSED'');',
'var isGeneral = (apex.item(''P16_PTW_TYPE'').getValue() === ''GENERAL'');',
'',
'if (isReadOnly) { ',
'    apex.item(''P16_LATE_CLEAR_REASON'').disable(); ',
'}',
'',
'if (isGeneral) {',
'    $(''#p16-decl-tidy-para'').hide();',
'    $(''#p16-decl-isolations-para'').show();',
'}',
'',
unistr('// \2500\2500 Signature pad init \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
unistr('// \2500\2500 Signature pad init \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'setTimeout(function () {',
'    p16InitSig();',
'',
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
'    if (isGeneral) {',
'        p16InitEngSig();',
'        if (p16EngSigPad) { p16EngSigPad.clear(); }',
'        var existingEngSig = apex.item(''P16_CLEAR_ENG_SIGNATURE_DATA_URL'').getValue();',
'        if (existingEngSig) {',
'            loadSignature(p16EngSigPad, document.getElementById(''p16EngSigCanvas''), existingEngSig);',
'',
'            if (isReadOnly) {',
'                var engCanvas = document.getElementById(''p16EngSigCanvas'');',
'                if (engCanvas) {',
'                    engCanvas.style.pointerEvents = ''none'';',
'                    engCanvas.style.opacity       = ''0.85'';',
'                    engCanvas.style.cursor        = ''not-allowed'';',
'                    engCanvas.title               = ''Signature locked'';',
'                }',
'                var engClearBtn = document.getElementById(''p16EngClearSigBtn'');',
'                if (engClearBtn) engClearBtn.style.display = ''none'';',
'            }',
'        } else if (isReadOnly) {',
'            var engCanvas2 = document.getElementById(''p16EngSigCanvas'');',
'            if (engCanvas2) {',
'                engCanvas2.style.pointerEvents = ''none'';',
'                engCanvas2.style.opacity       = ''0.85'';',
'                engCanvas2.style.cursor        = ''not-allowed'';',
'            }',
'        }',
'    }',
'',
'}, 350);',
'',
unistr('// \2500\2500 Save signature before submit \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'apex.jQuery(document).on(''apexbeforepagesubmit'', function () {',
'    p16SaveSig();',
'    if (isGeneral) { p16SaveEngSig(); }',
'});',
unistr('// \2500\2500 Binary Y/N badges \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'(function () {',
'',
'    var BINARY_ITEMS = [',
'        ''P16_CLEAR_WORK_COMPLETE'',',
'        ''P16_CLEAR_AREA_SAFE'',',
'        ''P16_CLEAR_ISOLATIONS_REMOVED''',
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
'(function () {',
'    var itemName = ''P16_CLEAR_SYSTEM_REACTIVATED'';',
'    var $fc = $(''#'' + itemName).closest(''.t-Form-fieldContainer'');',
'    if ($fc.length === 0) return;',
'',
'    var TRISTATE_BADGES = [',
'        { val: ''NA'', cls: ''cm-badge-na'',  label: ''N/A'' },',
'        { val: ''Y'',  cls: ''cm-badge-yes'', label: ''\u2713'' },',
'        { val: ''N'',  cls: ''cm-badge-no'',  label: ''\u2717'' }',
'    ];',
'',
'    $fc.find(''.cm-badge-row'').remove();',
'',
'    var currentVal = '''';',
'    if (!isReadOnly) {',
'        currentVal = $(''input[name="'' + itemName + ''"]:checked'').val() || '''';',
'    } else {',
'        currentVal = apex.item(itemName).getValue() || '''';',
'    }',
'',
'    var $row = $(''<div class="cm-badge-row"></div>'').attr(''data-item'', itemName);',
'',
'    TRISTATE_BADGES.forEach(function (b) {',
'        $(''<span></span>'')',
'            .addClass(''cm-badge '' + b.cls)',
'            .toggleClass(''cm-active'', currentVal === b.val)',
'            .toggleClass(''cm-badge-readonly'', isReadOnly)',
'            .attr(''data-value'', b.val)',
'            .text(b.label)',
'            .appendTo($row);',
'    });',
'',
'    $fc.find(''.t-Form-inputContainer'').append($row);',
'    $(''.cm-tristate-item .apex-item-grid'').hide();',
'',
'    $(document).off(''click.p16tristate'').on(''click.p16tristate'', ''.cm-badge:not(.cm-badge-readonly)'', function () {',
'        var $badge = $(this);',
'        var $row2  = $badge.closest(''.cm-badge-row'');',
'        var name   = $row2.attr(''data-item'');',
'        var val    = $badge.attr(''data-value'');',
'',
'        $(''input[name="'' + name + ''"][value="'' + val + ''"]'').prop(''checked'', true).trigger(''change'');',
'',
'        $row2.find(''.cm-badge'').removeClass(''cm-active'');',
'        $badge.addClass(''cm-active'');',
'    });',
'}());',
'',
unistr('// \2500\2500 Lock text fields in read-only mode \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'if (isReadOnly) {',
'    var readOnlyItems = [',
'        ''P16_CLEAR_PERSON_NAME'',',
'        ''P16_CLEAR_PERSON_MOBILE'',',
'        ''P16_CLEAR_COMPANY'',',
'        ''P16_CLEAR_DATETIME'',',
'        ''P16_CLEAR_ENG_PERSON_NAME''',
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
'',
'    var isoVal = apex.item(''P16_CLEAR_ISOLATIONS_REMOVED'').getValue();',
'    var $iso = $(''#p16-decl-isolations'');',
'    if (isoVal === ''Y'') {',
'        $iso.text(''been'').css(''color'', ''#1e7e34'');',
'    } else if (isoVal === ''N'') {',
'        $iso.text(''not been'').css(''color'', ''#a71d2a'');',
'    } else {',
'        $iso.text(''been / not been'').css(''color'', ''#344B5C'');',
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
,p_step_template=>2100407606326202693
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(31533963716212424)
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'16'
,p_created_on=>wwv_flow_imp.dz('20260429191554Z')
,p_last_updated_on=>wwv_flow_imp.dz('20261010133310Z')
,p_created_by=>'PTW_PRO'
,p_last_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(41970736729328838)
,p_plug_name=>'Buttons'
,p_static_id=>'buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>180
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260429192839Z')
,p_updated_on=>wwv_flow_imp.dz('20261010133310Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(41970462082328835)
,p_plug_name=>'Declaration'
,p_static_id=>'declaration'
,p_title=>'Declaration'
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>130
,p_plug_item_display_point=>'ABOVE'
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
'  <p id="p16-decl-tidy-para" style="margin:0;">',
'    The work area <strong id="p16-decl-area-tidy">has / has not</strong> been left in a safe and tidy condition,',
'    all temporary measures have been removed, and all waste has been cleared from site.',
'    This Permit to Work is hereby surrendered and closed.',
'  </p>',
'  <p id="p16-decl-isolations-para" style="margin:0 0 10px 0; display:none;">',
'    I confirm that my personal isolations have <strong id="p16-decl-isolations">been / not been</strong> removed.',
'  </p>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260429192839Z')
,p_updated_on=>wwv_flow_imp.dz('20261010133310Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24589711427992913)
,p_plug_name=>'Engineer'
,p_static_id=>'engineer'
,p_title=>'Engineer'
,p_region_template_options=>'#DEFAULT#:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>160
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P16_PTW_TYPE'
,p_plug_display_when_cond2=>'GENERAL'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260830131020Z')
,p_updated_on=>wwv_flow_imp.dz('20261010133310Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24590026801992916)
,p_plug_name=>'Engineer Signature'
,p_static_id=>'engineer-signature'
,p_title=>unistr('Signature \2013 Engineer')
,p_icon_css_classes=>'fa-pencil'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>170
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="p16-sig-wrapper">',
'   <label class="t-Form-label" style="display:block;margin-bottom:6px;">',
'     Signature <span style="color:#C0392B;" aria-hidden="true">*</span>',
'   </label>',
'  <canvas id="p16EngSigCanvas"></canvas>',
'  <button type="button"',
'          class="t-Button t-Button--small t-Button--simple"',
'          id="p16EngClearSigBtn"',
'          style="margin-top:6px;"',
'          onclick="p16ClearEngSig()">',
'    <span class="fa fa-eraser" aria-hidden="true"></span> Clear Signature',
'  </button>',
'</div>'))
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P16_PTW_TYPE'
,p_plug_display_when_cond2=>'GENERAL'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260830131020Z')
,p_updated_on=>wwv_flow_imp.dz('20261010133310Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(44029737206628818)
,p_plug_name=>'Late Clearance Warning'
,p_static_id=>'late-clearance-warning'
,p_title=>'Cleared after expiry'
,p_region_name=>'p16-late-warning'
,p_region_template_options=>'#DEFAULT#:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--warning'
,p_plug_template=>2040683448887306517
,p_plug_display_sequence=>120
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p style="margin:0;">',
'  This permit''s validity window ended at <strong>&P16_ENDED_DISPLAY.</strong>.',
'  Clearance after that time is recorded as <strong>cleared after expiry</strong>',
'  and needs a reason.',
'</p>',
''))
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P16_IS_LATE'
,p_plug_display_when_cond2=>'Y'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010133310Z')
,p_updated_on=>wwv_flow_imp.dz('20261010133310Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(41970349812328834)
,p_plug_name=>'Permit Info Banner'
,p_static_id=>'permit-info-banner'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>110
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>'<h2 class="t-Alert-title">&P16_BANNER_TITLE.</h2>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260429192839Z')
,p_updated_on=>wwv_flow_imp.dz('20261010133310Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(41970550498328836)
,p_plug_name=>'Person in Charge of Works'
,p_static_id=>'person-in-charge-of-works'
,p_title=>'Person in Charge of Works'
,p_icon_css_classes=>'fa-user'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>140
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260429192839Z')
,p_updated_on=>wwv_flow_imp.dz('20261010133310Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(41970654008328837)
,p_plug_name=>'Signature'
,p_static_id=>'signature'
,p_title=>unistr('Signature \2013 Person in Charge of Works')
,p_icon_css_classes=>'fa-pencil'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>150
,p_plug_item_display_point=>'ABOVE'
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
,p_created_on=>wwv_flow_imp.dz('20260429192839Z')
,p_updated_on=>wwv_flow_imp.dz('20261010133310Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(41971873495328849)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(41970736729328838)
,p_button_name=>'CANCEL'
,p_static_id=>'cancel'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_warn_on_unsaved_changes=>null
,p_created_on=>wwv_flow_imp.dz('20260429194329Z')
,p_updated_on=>wwv_flow_imp.dz('20260429194329Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(41971964243328850)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(41970736729328838)
,p_button_name=>'CLEAR_PERMIT'
,p_static_id=>'clear-permit'
,p_button_static_id=>'BTN_CLEAR_PERMIT_P16'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'&P16_CLEAR_BUTTON_LABEL.'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-check-circle'
,p_created_on=>wwv_flow_imp.dz('20260429194329Z')
,p_updated_on=>wwv_flow_imp.dz('20260830135843Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
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
,p_created_on=>wwv_flow_imp.dz('20260510130105Z')
,p_updated_on=>wwv_flow_imp.dz('20260510130105Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24589418929992910)
,p_name=>'P16_BANNER_TITLE'
,p_item_sequence=>70
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260830131020Z')
,p_updated_on=>wwv_flow_imp.dz('20260830131020Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(41971786256328848)
,p_name=>'P16_CLEARED'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(41970550498328836)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260429194329Z')
,p_updated_on=>wwv_flow_imp.dz('20260429194329Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(41971120202328842)
,p_name=>'P16_CLEAR_AREA_SAFE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(41970462082328835)
,p_prompt=>'It is safe to reinstate plant and equipment?'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Safe to reinstate plant and equipment;Y,NOT Safe to reinstate;N'
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-binary-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2',
  'page_action_on_selection', 'NONE')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260429194329Z')
,p_updated_on=>wwv_flow_imp.dz('20260505202646Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24590326182992919)
,p_name=>'P16_CLEAR_BUTTON_LABEL'
,p_item_sequence=>80
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260830135843Z')
,p_updated_on=>wwv_flow_imp.dz('20260830135843Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(41971361135328844)
,p_name=>'P16_CLEAR_COMPANY'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(41970550498328836)
,p_prompt=>'Company'
,p_placeholder=>'Company Name'
,p_source_type=>'ALWAYS_NULL'
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
,p_created_on=>wwv_flow_imp.dz('20260429194329Z')
,p_updated_on=>wwv_flow_imp.dz('20260429194329Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(41971556521328846)
,p_name=>'P16_CLEAR_DATETIME'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(41970550498328836)
,p_prompt=>'Time / Date'
,p_source_type=>'ALWAYS_NULL'
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
,p_created_on=>wwv_flow_imp.dz('20260429194329Z')
,p_updated_on=>wwv_flow_imp.dz('20260429194329Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24589862481992914)
,p_name=>'P16_CLEAR_ENG_PERSON_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(24589711427992913)
,p_prompt=>'Engineer Name'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_display_when=>'P16_PTW_TYPE'
,p_display_when2=>'GENERAL'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260830131020Z')
,p_updated_on=>wwv_flow_imp.dz('20260830140304Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24590177354992917)
,p_name=>'P16_CLEAR_ENG_SIGNATURE_DATA'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(24590026801992916)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260830131020Z')
,p_updated_on=>wwv_flow_imp.dz('20260830131020Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24589975656992915)
,p_name=>'P16_CLEAR_ENG_SIGNATURE_DATA_URL'
,p_item_sequence=>50
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_display_when=>'P16_PTW_TYPE'
,p_display_when2=>'GENERAL'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260830131020Z')
,p_updated_on=>wwv_flow_imp.dz('20260830131020Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24589657921992912)
,p_name=>'P16_CLEAR_ISOLATIONS_REMOVED'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(41970462082328835)
,p_prompt=>'Isolations Removed'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Yes;Y,No;N'
,p_display_when=>'P16_PTW_TYPE'
,p_display_when2=>'GENERAL'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-binary-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2',
  'page_action_on_selection', 'NONE')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260830131020Z')
,p_updated_on=>wwv_flow_imp.dz('20260830135047Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(41971460280328845)
,p_name=>'P16_CLEAR_PERSON_MOBILE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(41970550498328836)
,p_prompt=>'Mobile Tel. No.'
,p_placeholder=>'07700 900000'
,p_source_type=>'ALWAYS_NULL'
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
,p_created_on=>wwv_flow_imp.dz('20260429194329Z')
,p_updated_on=>wwv_flow_imp.dz('20260429194329Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(41971205189328843)
,p_name=>'P16_CLEAR_PERSON_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(41970550498328836)
,p_prompt=>'Name'
,p_placeholder=>'Full name of person in charge'
,p_source_type=>'ALWAYS_NULL'
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
,p_created_on=>wwv_flow_imp.dz('20260429194329Z')
,p_updated_on=>wwv_flow_imp.dz('20260429194329Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(41971678908328847)
,p_name=>'P16_CLEAR_SIGNATURE_DATA'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(41970654008328837)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260429194329Z')
,p_updated_on=>wwv_flow_imp.dz('20260429194329Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(45757583978782527)
,p_name=>'P16_CLEAR_SIGNATURE_DATA_URL'
,p_item_sequence=>40
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260505214926Z')
,p_updated_on=>wwv_flow_imp.dz('20260505214926Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24589542987992911)
,p_name=>'P16_CLEAR_SYSTEM_REACTIVATED'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(41970462082328835)
,p_prompt=>'System(s) are reactivated/serviceable?'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Yes;Y,No;N,N/A;NA'
,p_display_when=>'P16_PTW_TYPE'
,p_display_when2=>'GENERAL'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-tristate-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '3',
  'page_action_on_selection', 'NONE')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260830131020Z')
,p_updated_on=>wwv_flow_imp.dz('20260830135250Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(41971091989328841)
,p_name=>'P16_CLEAR_WORK_COMPLETE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(41970462082328835)
,p_prompt=>'Works are completed?'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Completed;Y,Not Complete;N'
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-binary-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2',
  'page_action_on_selection', 'NONE')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260429192839Z')
,p_updated_on=>wwv_flow_imp.dz('20260505202646Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44029804260628819)
,p_name=>'P16_ENDED_DISPLAY'
,p_item_sequence=>100
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010133310Z')
,p_updated_on=>wwv_flow_imp.dz('20261010133310Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44029654793628817)
,p_name=>'P16_IS_LATE'
,p_item_sequence=>90
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010133310Z')
,p_updated_on=>wwv_flow_imp.dz('20261010133310Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44029904185628820)
,p_name=>'P16_LATE_CLEAR_REASON'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(44029737206628818)
,p_prompt=>'Reason for clearing after expiry'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>1000
,p_cHeight=>3
,p_display_when=>'P16_IS_LATE'
,p_display_when2=>'Y'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010133310Z')
,p_updated_on=>wwv_flow_imp.dz('20261010133310Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(41970853732328839)
,p_name=>'P16_PERMIT_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(41970550498328836)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260429192839Z')
,p_updated_on=>wwv_flow_imp.dz('20260429192839Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(41970924705328840)
,p_name=>'P16_PERMIT_NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(41970550498328836)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260429192839Z')
,p_updated_on=>wwv_flow_imp.dz('20260429192839Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24589345899992909)
,p_name=>'P16_PTW_TYPE'
,p_item_sequence=>60
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260830120916Z')
,p_updated_on=>wwv_flow_imp.dz('20260830131021Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(45757410227782526)
,p_name=>'P16_WORKFLOW_STATUS'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260505201759Z')
,p_updated_on=>wwv_flow_imp.dz('20260505201759Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(45755711527782509)
,p_validation_name=>'Area Safe Required'
,p_static_id=>'area-safe-required'
,p_validation_sequence=>20
,p_validation=>'P16_CLEAR_AREA_SAFE'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Please indicate whether it is safe to reinstate plant and equipment.'
,p_when_button_pressed=>wwv_flow_imp.id(41971964243328850)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260429195424Z')
,p_updated_on=>wwv_flow_imp.dz('20260429195424Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(24590579485992921)
,p_validation_name=>'Engineers signature required'
,p_static_id=>'engineers-signature-required'
,p_validation_sequence=>50
,p_validation=>'P16_CLEAR_ENG_SIGNATURE_DATA'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'A signature is required from the Engineer to clear the permit.'
,p_validation_condition=>'P16_PTW_TYPE'
,p_validation_condition2=>'GENERAL'
,p_validation_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_when_button_pressed=>wwv_flow_imp.id(41971964243328850)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260830175759Z')
,p_updated_on=>wwv_flow_imp.dz('20260830175759Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(24593071897992946)
,p_validation_name=>'Hot Work Fire Watch Must Be Complete'
,p_static_id=>'hot-work-fire-watch-must-be-complete'
,p_validation_sequence=>80
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'            DECLARE',
'                l_count NUMBER;',
'            BEGIN',
'                IF :P16_PTW_TYPE NOT IN (''HOT WORK'', ''FIRE SYSTEMS ISOLATION'') THEN',
'                    RETURN TRUE;',
'                END IF;',
'',
'                SELECT COUNT(*) INTO l_count',
'                FROM   ptw_pro.ptw_hotwork_fire_watch',
'                WHERE  permit_id = :P16_PERMIT_ID',
'                AND    milestone_code = ''FIRE_CHECKS_COMPLETE'';',
'',
'                RETURN l_count > 0;',
'            END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'All fire watch checks must be signed off before this permit can be cleared.'
,p_validation_condition=>'   :REQUEST = ''CLEAR_PERMIT'' AND :P16_PTW_TYPE IN (''HOT WORK'', ''FIRE SYSTEMS ISOLATION'')'
,p_validation_condition2=>'PLSQL'
,p_validation_condition_type=>'EXPRESSION'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260913165232Z')
,p_updated_on=>wwv_flow_imp.dz('20260919201236Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(24590270782992918)
,p_validation_name=>'Isolations Removed Required'
,p_static_id=>'isolations-removed-required'
,p_validation_sequence=>70
,p_validation=>'P16_CLEAR_ISOLATIONS_REMOVED'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Please indicate whether personal isolations have been removed.'
,p_validation_condition=>'P16_PTW_TYPE'
,p_validation_condition2=>'GENERAL'
,p_validation_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_when_button_pressed=>wwv_flow_imp.id(41971964243328850)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260830134119Z')
,p_updated_on=>wwv_flow_imp.dz('20260830175759Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(44030036605628821)
,p_validation_name=>'Late Clearance Reason Required'
,p_static_id=>'late-clearance-reason-required'
,p_validation_sequence=>90
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_ended DATE;',
'BEGIN',
'    SELECT ended_datetime INTO v_ended',
'    FROM   ptw_pro.ptw_lv_permits',
'    WHERE  permit_id = :P16_PERMIT_ID;',
' ',
'    RETURN NOT ( SYSDATE >= v_ended',
'                 AND TRIM(:P16_LATE_CLEAR_REASON) IS NULL );',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'Please give a reason for clearing this permit after it expired.'
,p_when_button_pressed=>wwv_flow_imp.id(41971964243328850)
,p_associated_item=>wwv_flow_imp.id(44029904185628820)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20261010133310Z')
,p_updated_on=>wwv_flow_imp.dz('20261010133310Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(45756000957782512)
,p_validation_name=>'Permit Can Be Cleared'
,p_static_id=>'permit-still-valid'
,p_validation_sequence=>60
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_count NUMBER;',
'BEGIN',
'    SELECT COUNT(*)',
'    INTO   v_count',
'    FROM   ptw_pro.ptw_lv_permits',
'    WHERE  permit_id       = :P16_PERMIT_ID',
'    AND    workflow_status IN (''STARTED'', ''LAPSED'');',
'    RETURN v_count > 0;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'This permit can no longer be cleared - it has already been completed or cancelled.'
,p_when_button_pressed=>wwv_flow_imp.id(41971964243328850)
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260429195424Z')
,p_updated_on=>wwv_flow_imp.dz('20261010133310Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(45755897998782510)
,p_validation_name=>'Person Name Required'
,p_static_id=>'person-name-required'
,p_validation_sequence=>30
,p_validation=>'P16_CLEAR_PERSON_NAME'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Name of Person in Charge is required.'
,p_when_button_pressed=>wwv_flow_imp.id(41971964243328850)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260429195424Z')
,p_updated_on=>wwv_flow_imp.dz('20260429195424Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(45755944608782511)
,p_validation_name=>'Signature Required'
,p_static_id=>'signature-required'
,p_validation_sequence=>40
,p_validation=>'P16_CLEAR_SIGNATURE_DATA'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'A signature is required to clear the permit.'
,p_when_button_pressed=>wwv_flow_imp.id(41971964243328850)
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260429195424Z')
,p_updated_on=>wwv_flow_imp.dz('20260429195424Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(45755602418782508)
,p_validation_name=>'Work Complete Required'
,p_static_id=>'work-complete-required'
,p_validation_sequence=>10
,p_validation=>'P16_CLEAR_WORK_COMPLETE'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Please indicate whether the works are completed or not complete.'
,p_when_button_pressed=>wwv_flow_imp.id(41971964243328850)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260429195424Z')
,p_updated_on=>wwv_flow_imp.dz('20260429195424Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(45754945488782501)
,p_name=>'Cancel - Close Dialog'
,p_static_id=>'cancel-close-dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(41971873495328849)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_created_on=>wwv_flow_imp.dz('20260429194330Z')
,p_updated_on=>wwv_flow_imp.dz('20260429194330Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(45755093312782502)
,p_event_id=>wwv_flow_imp.id(45754945488782501)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-dialog-cancel'
,p_action=>'NATIVE_DIALOG_CANCEL'
,p_created_on=>wwv_flow_imp.dz('20260429194330Z')
,p_updated_on=>wwv_flow_imp.dz('20260429194330Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(45755186137782503)
,p_name=>'Clear Permit - Capture Location and Submit'
,p_static_id=>'clear-permit-capture-location-and-submit'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(41971964243328850)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_created_on=>wwv_flow_imp.dz('20260429194530Z')
,p_updated_on=>wwv_flow_imp.dz('20260429194530Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(45755261851782504)
,p_event_id=>wwv_flow_imp.id(45755186137782503)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'captureLocationThenSubmit(''CLEAR_PERMIT'');')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260429194530Z')
,p_updated_on=>wwv_flow_imp.dz('20260429194530Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(45755480536782506)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Clear Permit'
,p_static_id=>'clear-permit'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_sig_blob  BLOB;',
'    v_clob      CLOB;',
'    v_now       DATE := SYSDATE;',
'BEGIN',
'    IF :P16_CLEAR_SIGNATURE_DATA IS NOT NULL THEN',
'        v_clob     := REPLACE(:P16_CLEAR_SIGNATURE_DATA, ''data:image/png;base64,'', '''');',
'        v_sig_blob := apex_web_service.clobbase642blob(v_clob);',
'    END IF;',
'',
'    -- Guarded status transition stays on PTW_LV_PERMITS, same race-condition',
'    -- protection as before (workflow_status/expiry check + ROWCOUNT).',
'    UPDATE ptw_pro.ptw_lv_permits',
'    SET    clear_work_complete = :P16_CLEAR_WORK_COMPLETE,',
'           clear_area_safe     = :P16_CLEAR_AREA_SAFE,',
'           clear_isolations_removed = :P16_CLEAR_ISOLATIONS_REMOVED,',
'           clear_system_reactivated = :P16_CLEAR_SYSTEM_REACTIVATED,',
'           workflow_status     = ''COMPLETED'',',
'           current_step        = ''CLEARANCE'',',
'           clear_latitude      = TO_NUMBER(:APP_LATITUDE),',
'           clear_longitude     = TO_NUMBER(:APP_LONGITUDE),',
'           completion_date     = v_now,',
'           modified_by         = V(''APP_USER''),',
'           modified_date       = v_now,',
'           cleared_late        = CASE WHEN v_now >= ended_datetime',
'                                 THEN ''Y'' ELSE ''N'' END,',
'           late_clear_reason   = CASE WHEN v_now >= ended_datetime',
'                                 THEN TRIM(:P16_LATE_CLEAR_REASON) END',
'    WHERE  permit_id           = :P16_PERMIT_ID',
'    AND    workflow_status     IN (''STARTED'', ''LAPSED'');',
'',
'    IF SQL%ROWCOUNT = 0 THEN',
'        RAISE_APPLICATION_ERROR(-20001,',
'          ''Permit could not be cleared. It may already have been completed ''',
'          || ''or cancelled. Please refresh the permits list.'');',
'    END IF;',
'',
'    ptw_pro.ptw_signature_pkg.save_signature(',
'        p_permit_id      => :P16_PERMIT_ID,',
'        p_stage          => ''CLEAR'',',
'        p_person_name    => UPPER(TRIM(:P16_CLEAR_PERSON_NAME)),',
'        p_signature_blob => v_sig_blob,',
'        p_mobile_no      => TRIM(:P16_CLEAR_PERSON_MOBILE),',
'        p_company_name   => UPPER(TRIM(:P16_CLEAR_COMPANY)),',
'        p_event_datetime => v_now,',
'        p_latitude       => TO_NUMBER(:APP_LATITUDE),',
'        p_longitude      => TO_NUMBER(:APP_LONGITUDE)',
'    );',
'',
'    IF :P16_CLEAR_ENG_SIGNATURE_DATA IS NOT NULL OR :P16_CLEAR_ENG_PERSON_NAME IS NOT NULL THEN',
'        DECLARE',
'            v_eng_sig_blob BLOB;',
'            v_eng_clob     CLOB;',
'        BEGIN',
'            IF :P16_CLEAR_ENG_SIGNATURE_DATA IS NOT NULL THEN',
'                v_eng_clob     := REPLACE(:P16_CLEAR_ENG_SIGNATURE_DATA, ''data:image/png;base64,'', '''');',
'                v_eng_sig_blob := apex_web_service.clobbase642blob(v_eng_clob);',
'            END IF;',
'',
'            ptw_pro.ptw_signature_pkg.save_signature(',
'                p_permit_id      => :P16_PERMIT_ID,',
'                p_stage          => ''CLR_ENG'',',
'                p_person_name    => UPPER(TRIM(:P16_CLEAR_ENG_PERSON_NAME)),',
'                p_signature_blob => v_eng_sig_blob,',
'                p_event_datetime => v_now,',
'                p_latitude       => TO_NUMBER(:APP_LATITUDE),',
'                p_longitude      => TO_NUMBER(:APP_LONGITUDE)',
'            );',
'        END;',
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
,p_created_on=>wwv_flow_imp.dz('20260429195424Z')
,p_updated_on=>wwv_flow_imp.dz('20261010133310Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(45755524966782507)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_static_id=>'close-dialog'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'items_to_return', 'P16_CLEARED',
  'show_success_messages', 'N')).to_clob
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P16_CLEARED'
,p_process_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_process_when2=>'N'
,p_internal_uid=>45755524966782507
,p_created_on=>wwv_flow_imp.dz('20260429195424Z')
,p_updated_on=>wwv_flow_imp.dz('20260510130657Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(45755388825782505)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load Permit Data'
,p_static_id=>'load-permit-data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_status        VARCHAR2(20);',
'    v_ended         DATE;',
'    v_sig           BLOB;',
'    v_eng_sig       BLOB;',
'    v_na_lat        ptw_pro.ptw_signatures.latitude%TYPE;',
'    v_na_lng        ptw_pro.ptw_signatures.longitude%TYPE;',
'    v_na_mobile     ptw_pro.ptw_signatures.mobile_no%TYPE;',
'    v_na_company    ptw_pro.ptw_signatures.company_name%TYPE;',
'    v_na_dt         DATE;',
'    v_na_auth_to_dt  ptw_pro.ptw_signatures.auth_to_datetime%TYPE; ',
'    v_late_reason  ptw_pro.ptw_lv_permits.late_clear_reason%TYPE;',
'    v_cleared_late ptw_pro.ptw_lv_permits.cleared_late%TYPE;',
'BEGIN',
'',
'    SELECT workflow_status, ended_datetime, permit_number,',
'           person_in_charge_name, supervising_company, ptw_type,',
'           late_clear_reason, cleared_late',
'    INTO   v_status, v_ended, :P16_PERMIT_NUMBER,',
'           :P16_CLEAR_PERSON_NAME, :P16_CLEAR_COMPANY, :P16_PTW_TYPE,',
'           v_late_reason, v_cleared_late',
'    FROM   ptw_pro.ptw_lv_permits',
'    WHERE  permit_id = :P16_PERMIT_ID;',
'',
'    :P16_WORKFLOW_STATUS := v_status;',
'    :P16_ENDED_DISPLAY   := TO_CHAR(v_ended, ''DD-MON-YYYY HH24:MI'');',
'',
'    :P16_BANNER_TITLE := CASE :P16_PTW_TYPE',
'                          WHEN ''GENERAL''               THEN ''Completion of Works''',
'                          WHEN ''LIMITATION OF ACCESS''  THEN ''Clearance of this Limitation of Access''',
'                          ELSE ''Clearance of Permit to Work''',
'                         END;',
'',
'    :P16_CLEAR_BUTTON_LABEL := CASE WHEN :P16_PTW_TYPE = ''GENERAL''',
'                                    THEN ''Complete''',
'                                    ELSE ''Clear Permit''',
'                               END;',
'                               ',
'    IF v_status NOT IN (''STARTED'', ''LAPSED'', ''COMPLETED'') THEN',
'        apex_error.add_error(',
'            p_message          => ''This permit cannot be viewed here. Current status: '' || v_status,',
'            p_display_location => apex_error.c_on_error_page',
'        );',
'        RETURN;',
'    END IF;',
'',
'    IF v_status IN (''STARTED'', ''LAPSED'') THEN',
'        :P16_IS_LATE := CASE WHEN SYSDATE >= v_ended THEN ''Y'' ELSE ''N'' END;',
'        :P16_CLEAR_DATETIME := TO_CHAR(SYSDATE, ''DD-MON-YYYY HH24:MI'');',
'    END IF;',
'',
'    IF v_status = ''COMPLETED'' THEN',
'',
'        :P16_IS_LATE           := v_cleared_late;',
'        :P16_LATE_CLEAR_REASON := v_late_reason;',
'        ptw_pro.ptw_signature_pkg.get_signature(:P16_PERMIT_ID, ''CLEAR'',',
'            :P16_CLEAR_PERSON_NAME, v_sig, :P16_CLEAR_PERSON_MOBILE, :P16_CLEAR_COMPANY,',
'            :P16_CLEAR_DATETIME, v_na_lat, v_na_lng, v_na_auth_to_dt);',
'',
'        SELECT clear_work_complete, clear_area_safe,',
'               clear_isolations_removed, clear_system_reactivated',
'        INTO   :P16_CLEAR_WORK_COMPLETE, :P16_CLEAR_AREA_SAFE,',
'               :P16_CLEAR_ISOLATIONS_REMOVED, :P16_CLEAR_SYSTEM_REACTIVATED',
'        FROM   ptw_pro.ptw_lv_permits',
'        WHERE  permit_id = :P16_PERMIT_ID;',
'',
'        IF v_sig IS NOT NULL AND DBMS_LOB.GETLENGTH(v_sig) > 0 THEN',
'            :P16_CLEAR_SIGNATURE_DATA_URL := ''data:image/png;base64,''',
'                || apex_web_service.blob2clobbase64(v_sig);',
'        END IF;',
'',
'        IF :P16_PTW_TYPE = ''GENERAL'' THEN',
'            BEGIN',
'                ptw_pro.ptw_signature_pkg.get_signature(:P16_PERMIT_ID, ''CLR_ENG'',',
'                    :P16_CLEAR_ENG_PERSON_NAME, v_eng_sig, v_na_mobile, v_na_company,',
'                    v_na_dt, v_na_lat, v_na_lng, v_na_auth_to_dt);',
'                IF v_eng_sig IS NOT NULL AND DBMS_LOB.GETLENGTH(v_eng_sig) > 0 THEN',
'                    :P16_CLEAR_ENG_SIGNATURE_DATA_URL := ''data:image/png;base64,''',
'                        || apex_web_service.blob2clobbase64(v_eng_sig);',
'                END IF;',
'            EXCEPTION',
'                WHEN NO_DATA_FOUND THEN NULL; -- Engineer signature is optional',
'            END;',
'        END IF;',
'    END IF;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>45755388825782505
,p_created_on=>wwv_flow_imp.dz('20260429194530Z')
,p_updated_on=>wwv_flow_imp.dz('20261010133310Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
