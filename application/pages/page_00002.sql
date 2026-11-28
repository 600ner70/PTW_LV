prompt --application/pages/page_00002
begin
--   Manifest
--     PAGE: 00002
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
'}());',
'',
'(function () {',
'',
'    var BINARY_ITEMS = [',
'        ''P2_CLIENT_PERMISSION_GRANTED'',',
'        ''P2_AFFECTS_IT_SYSTEMS'',',
'        ''P2_IT_PERMISSION_GRANTED'',',
'        ''P2_FIRE_SYSTEMS_AFFECTED'',',
'        ''P2_FIRE_SYSTEMS_ISOLATED'',',
'        ''P2_FSI_CLIENT_PERMISSION_GRANTED'',',
'        ''P2_FSI_AFFECTS_IT_SYSTEMS'',',
'        ''P2_FSI_IT_PERMISSION_GRANTED'',',
'        ''P2_FSI_FIRE_SYSTEMS_AFFECTED'',',
'        ''P2_FSI_FIRE_SYSTEMS_ISOLATED'',',
'        ''P2_FSI_INSURANCE_NECESSARY''',
'    ];',
'    ',
'    var BADGES = [',
unistr('        { val: ''Y'', cls: ''binary-badge-yes'', label: ''\2713'' },'),
unistr('        { val: ''N'', cls: ''binary-badge-no'',  label: ''\2717'' }'),
'    ];',
'',
'    // Page 2 is editable when status is DRAFT',
'    var status    = apex.item(''P2_WORKFLOW_STATUS'').getValue();',
'    var isReadOnly = (apex.item(''P2_WORKFLOW_STATUS'').getValue() !== ''DRAFT'');',
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
'',
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
'    ',
'    $(''.cm-binary-item .apex-item-grid'').hide();',
'',
'}());',
'',
'function initCMChecklist() {',
'    var $items = $(''.cm-binary-item'');',
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
'});'))
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
'/* ==========================================================',
unistr('   BINARY YES/NO BADGES \2014 Y=green / N=red'),
'   ========================================================== */',
'',
'.cm-binary-item .apex-item-grid {',
'    display: none !important;',
'    pointer-events: none !important;',
'}',
'',
'.binary-badge-row {',
'    display: flex;',
'    gap: 6px;',
'    margin-top: 4px;',
'}',
'',
'.binary-badge {',
'    display: inline-flex;',
'    align-items: center;',
'    justify-content: center;',
'    width: 52px;',
'    height: 34px;',
'    border-radius: 8px;',
'    border: 2px solid #ced4da;',
'    background: #f0f0f0;',
'    color: #aaa;',
'    font-weight: 700;',
'    font-size: 1.3rem;',
'    cursor: pointer;',
'    line-height: 1;',
'    transition: background 0.15s, border-color 0.15s, color 0.15s;',
'    user-select: none;',
'}',
'',
'.binary-badge:hover {',
'    border-color: #999;',
'    background: #e2e6ea;',
'}',
'',
'.binary-badge-yes.cm-active {',
'    background: #28a745;',
'    border-color: #1e7e34;',
'    color: #fff;',
'}',
'',
'.binary-badge-no.cm-active {',
'    background: #dc3545;',
'    border-color: #a71d2a;',
'    color: #fff;',
'}',
'',
'.binary-badge.binary-readonly {',
'    cursor: default;',
'}',
'',
'.binary-badge.binary-readonly:hover {',
'    background: #f0f0f0;',
'    border-color: #ced4da;',
'    color: #aaa;',
'}',
'',
'.binary-badge-yes.cm-active.binary-readonly:hover {',
'    background: #28a745;',
'    border-color: #1e7e34;',
'    color: #fff;',
'}',
'',
'.binary-badge-no.cm-active.binary-readonly:hover {',
'    background: #dc3545;',
'    border-color: #a71d2a;',
'    color: #fff;',
'}',
'',
unistr('/* \2500\2500 Required asterisk on each item \2500\2500 */'),
'.cm-required-star {',
'    color: #c0392b;',
'    font-weight: 700;',
'    margin-left: 2px;',
'}',
'',
'.cm-binary-item .apex-item-grid {',
'    display: none !important;',
'    pointer-events: none !important;',
'}',
'',
'.binary-badge-row {',
'    display: flex;',
'    gap: 6px;',
'    margin-top: 4px;',
'}'))
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'EXPRESSION'
,p_read_only_when=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P2_WORKFLOW_STATUS != ''DRAFT''',
'OR ptw_pro.ptw_lv_is_contract_support(V(''APP_USER'')) = ''Y'''))
,p_read_only_when2=>'PLSQL'
,p_page_component_map=>'25'
,p_last_updated_on=>wwv_flow_imp.dz('20260919190116Z')
,p_last_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(26944035438347711)
,p_plug_name=>'Buttons'
,p_static_id=>'buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>160
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_query_headings_type=>'COLON_DELMITED_LIST'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_updated_on=>wwv_flow_imp.dz('20260919183502Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8877673896853325)
,p_plug_name=>'Cancellation Notice'
,p_static_id=>'cancellation-notice'
,p_title=>'Cancellation Notice'
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--danger'
,p_plug_template=>2040683448887306517
,p_plug_display_sequence=>70
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    r      ptw_pro.ptw_lv_cancellation_reason_v%ROWTYPE;',
'    v_html CLOB;',
'BEGIN',
'    SELECT * INTO r FROM ptw_pro.ptw_lv_cancellation_reason_v WHERE permit_id = :P2_PERMIT_ID;',
'',
'    IF r.is_concern_cancellation = ''Y'' THEN',
'        v_html := ''<div class="ptw-cancel-banner ptw-cancel-banner--concern">''',
'            || ''<strong>This permit was cancelled following a monitoring concern.</strong><br>''',
'            || ''Check failed: '' || r.check_label || ''<br>''',
'            || ''Concern: '' || r.concern_description || ''<br>''',
'            || ''Action taken: '' || r.actions_taken || ''<br>''',
'            || ''Reported by '' || r.concern_person_name',
'            || '' on '' || TO_CHAR(r.concern_datetime, ''DD-Mon-YYYY HH24:MI'')',
'            || ''</div>'';',
'    ELSE',
'        v_html := ''<div class="ptw-cancel-banner">''',
'            || ''<strong>This permit was cancelled.</strong><br>''',
'            || ''Cancelled by '' || r.cancel_person_name',
'            || '' on '' || TO_CHAR(r.cancel_datetime, ''DD-Mon-YYYY HH24:MI'')',
'            || ''</div>'';',
'    END IF;',
'',
'    RETURN v_html;',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        RETURN NULL;',
'END;'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_ajax_items_to_submit=>'P2_PERMIT_ID'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P2_WORKFLOW_STATUS'
,p_plug_display_when_cond2=>'CANCELLED'
,p_created_on=>wwv_flow_imp.dz('20260725184656Z')
,p_updated_on=>wwv_flow_imp.dz('20260820195443Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(26943346862347704)
,p_plug_name=>'Client Permission'
,p_static_id=>'client-permission'
,p_title=>'Client Permission'
,p_icon_css_classes=>'fa-check-square'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>130
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_query_headings_type=>'COLON_DELMITED_LIST'
,p_plug_display_condition_type=>'EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'EXISTS (',
'    SELECT 1',
'    FROM   ptw_pro.ptw_types t',
'    JOIN   ptw_pro.ptw_type_sections ts ON ts.type_id = t.type_id',
'    WHERE  t.ptw_type      = :P2_PTW_TYPE',
'    AND    ts.section_code = ''CLIENT_PERMISSION''',
')'))
,p_plug_display_when_cond2=>'SQL'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_updated_on=>wwv_flow_imp.dz('20260919124432Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24591595204992931)
,p_plug_name=>'Fire & Smoke Systems'
,p_static_id=>'fire-smoke-systems'
,p_title=>'Fire & Smoke Systems'
,p_icon_css_classes=>'fa-fire'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>140
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P2_PTW_TYPE'
,p_plug_display_when_cond2=>'HOT WORK'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260913132349Z')
,p_updated_on=>wwv_flow_imp.dz('20260913132349Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(43896458318698010)
,p_plug_name=>'Fire Systems Isolation Details'
,p_static_id=>'fire-systems-isolation-details'
,p_title=>'Fire Systems Isolation Details'
,p_icon_css_classes=>'fa-fire'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>150
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P2_PTW_TYPE'
,p_plug_display_when_cond2=>'FIRE SYSTEMS ISOLATION'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260919183502Z')
,p_updated_on=>wwv_flow_imp.dz('20260919183503Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(25230494463353144)
,p_plug_name=>'Header Information'
,p_static_id=>'header-information'
,p_title=>'Permit Header Information'
,p_icon_css_classes=>'fa-file-text'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>110
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_query_headings_type=>'COLON_DELMITED_LIST'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P2_PTW_TYPE'
,p_plug_display_when_cond2=>'LV ISOLATION'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_updated_on=>wwv_flow_imp.dz('20260824212029Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(25230364426353143)
,p_plug_name=>'Permit Type Badge'
,p_static_id=>'permit-information-badge'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>90
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'RETURN ptw_pro.ptw_ui_pkg.get_permit_type_badge_html(',
'    p_permit_id => :P2_PERMIT_ID,',
'    p_ptw_type  => :P2_PTW_TYPE',
');'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_updated_on=>wwv_flow_imp.dz('20260824212029Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8879459264853343)
,p_plug_name=>'Permit Number Badge'
,p_static_id=>'permit-number-badge'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>100
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'    <div style="margin-bottom: 20px;">',
'        <span class="apex-badge" style="background-color: #3ea055; color: white; padding: 6px 16px; border-radius: 20px; font-weight: 600;">',
'            Permit: &P2_PERMIT_NUMBER.',
'        </span>',
'    </div>'))
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P2_PERMIT_NUMBER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260824212029Z')
,p_updated_on=>wwv_flow_imp.dz('20260824212029Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(25230894903353148)
,p_plug_name=>'Site & Work Details'
,p_static_id=>'site-work-details'
,p_title=>'Site & Work Details'
,p_icon_css_classes=>'fa-building'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>120
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_query_headings_type=>'COLON_DELMITED_LIST'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_updated_on=>wwv_flow_imp.dz('20260824212029Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27017146064886522)
,p_plug_name=>'SyncStatus'
,p_static_id=>'syncstatus'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>60
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
,p_updated_on=>wwv_flow_imp.dz('20260820195443Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(25229500348353135)
,p_plug_name=>'Workflow Status'
,p_static_id=>'workflow-status'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>80
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'RETURN ptw_pro.ptw_ui_pkg.get_workflow_steps_html(',
'    p_permit_id => :P2_PERMIT_ID,',
'    p_ptw_type  => :P2_PTW_TYPE,',
'    p_current_step => ''SITE_WORK_DETAILS''',
');'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_updated_on=>wwv_flow_imp.dz('20260825202154Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(26944114711347712)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(26944035438347711)
,p_button_name=>'CANCEL'
,p_static_id=>'cancel'
,p_button_static_id=>'BTN_CANCEL_P2'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:2:P1_PERMIT_ID:&P2_PERMIT_ID.'
,p_updated_on=>wwv_flow_imp.dz('20260318194115Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(26944315283347714)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(26944035438347711)
,p_button_name=>'NEXT_STEP'
,p_static_id=>'next-step'
,p_button_static_id=>'BTN_NEXT_STEP_P2'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Next Step'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-arrow-right'
,p_updated_on=>wwv_flow_imp.dz('20260502204721Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(26944216198347713)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(26944035438347711)
,p_button_name=>'SAVE_DRAFT'
,p_static_id=>'save-draft'
,p_button_static_id=>'BTN_SAVE_DRAFT_P2'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Save Draft'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_security_scheme=>wwv_flow_imp.id(31533963716212424)
,p_updated_on=>wwv_flow_imp.dz('20260311202244Z')
,p_updated_by=>'PTW_PRO'
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
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26943599720347706)
,p_name=>'P2_AFFECTS_IT_SYSTEMS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(26943346862347704)
,p_prompt=>'Will these works affect any IT or other business critical systems?'
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
,p_updated_on=>wwv_flow_imp.dz('20260823151912Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(8876071099853309)
,p_name=>'P2_AREA_OF_WORKS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(25230894903353148)
,p_prompt=>'Area Of Works'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>3
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260721205951Z')
,p_updated_on=>wwv_flow_imp.dz('20260721210326Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26943471028347705)
,p_name=>'P2_CLIENT_PERMISSION_GRANTED'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(26943346862347704)
,p_prompt=>'Has the client granted permission for these works to proceed?'
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
,p_updated_on=>wwv_flow_imp.dz('20260823151912Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(25229379255353133)
,p_name=>'P2_CURRENT_STEP'
,p_item_sequence=>20
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24592327833992939)
,p_name=>'P2_FIRE_ALARM_ARRANGEMENTS'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(24591595204992931)
,p_prompt=>'Fire alarm arrangements'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'Details of adequate means of raising the fire alarm during the works and/or during the period when smoke/fire detection and/or suppression systems are inhibited'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260913145950Z')
,p_updated_on=>wwv_flow_imp.dz('20260914214402Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24592293459992938)
,p_name=>'P2_FIRE_PRECAUTIONS_DETAILS'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(24591595204992931)
,p_prompt=>'Fire precaution details'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'Details of adequate fire precautions taken when smoke/fire detection and/or suppression systems have been isolated (fire extinguishers, blankets, etc.)'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260913145950Z')
,p_updated_on=>wwv_flow_imp.dz('20260914214402Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24591655283992932)
,p_name=>'P2_FIRE_SYSTEMS_AFFECTED'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(24591595204992931)
,p_prompt=>'Will any fixed smoke/fire detection or suppression systems be affected by these works?'
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
,p_created_on=>wwv_flow_imp.dz('20260913132349Z')
,p_updated_on=>wwv_flow_imp.dz('20260913135117Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24591799701992933)
,p_name=>'P2_FIRE_SYSTEMS_ISOLATED'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(24591595204992931)
,p_prompt=>'If ''Yes'' have they been isolated or impeded?'
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
,p_created_on=>wwv_flow_imp.dz('20260913132804Z')
,p_updated_on=>wwv_flow_imp.dz('20260913135117Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43896684334698012)
,p_name=>'P2_FSI_AFFECTS_IT_SYSTEMS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(43896458318698010)
,p_prompt=>'Will these works affect any IT or other business critical systems?'
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
,p_created_on=>wwv_flow_imp.dz('20260919183502Z')
,p_updated_on=>wwv_flow_imp.dz('20260919183502Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43896576284698011)
,p_name=>'P2_FSI_CLIENT_PERMISSION_GRANTED'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(43896458318698010)
,p_prompt=>'Has the client granted permission for these works to proceed?'
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
,p_created_on=>wwv_flow_imp.dz('20260919183502Z')
,p_updated_on=>wwv_flow_imp.dz('20260919183502Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43897396723698019)
,p_name=>'P2_FSI_FIRE_ALARM_ARRANGEMENTS'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(43896458318698010)
,p_prompt=>'Fire Alarm Arrangements'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'Details of adequate means of raising the fire alarm during the works and/or during the period when smoke/fire detection and/or suppression systems are inhibited'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260919183503Z')
,p_updated_on=>wwv_flow_imp.dz('20260919183503Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43897221498698018)
,p_name=>'P2_FSI_FIRE_PRECAUTIONS_DETAILS'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(43896458318698010)
,p_prompt=>'Fire Precautions Details'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'Details of adequate fire precautions taken when smoke/fire detection and/or suppression systems have been isolated (fire extinguishers, blankets, etc.)'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260919183502Z')
,p_updated_on=>wwv_flow_imp.dz('20260919183502Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43896858459698014)
,p_name=>'P2_FSI_FIRE_SYSTEMS_AFFECTED'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(43896458318698010)
,p_prompt=>'Will any fixed smoke/fire detection or suppression systems be affected by these works?'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Yes;Y,No;N'
,p_grid_column_css_classes=>'cm-binary-item'
,p_field_template=>3031561666792084173
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2',
  'page_action_on_selection', 'NONE')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260919183502Z')
,p_updated_on=>wwv_flow_imp.dz('20260919183502Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43896945395698015)
,p_name=>'P2_FSI_FIRE_SYSTEMS_ISOLATED'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(43896458318698010)
,p_prompt=>'If ''Yes'' have they been isolated or impeded?'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Yes;Y,No;N'
,p_grid_column_css_classes=>'cm-binary-item'
,p_field_template=>3031561666792084173
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2',
  'page_action_on_selection', 'NONE')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260919183502Z')
,p_updated_on=>wwv_flow_imp.dz('20260919183502Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43897076031698016)
,p_name=>'P2_FSI_INSURANCE_NECESSARY'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(43896458318698010)
,p_prompt=>'Is it necessary to inform the insurance company of this activity?'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Yes;Y,No;N'
,p_grid_column_css_classes=>'cm-binary-item'
,p_field_template=>3031561666792084173
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2',
  'page_action_on_selection', 'NONE')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260919183502Z')
,p_updated_on=>wwv_flow_imp.dz('20260919183502Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43897116250698017)
,p_name=>'P2_FSI_INSURER_INFORMED_DATETIME'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(43896458318698010)
,p_prompt=>'Date and time insurance company informed'
,p_format_mask=>'DD-MON-YYYY HH24:MI'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'Y',
  'use_defaults', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260919183502Z')
,p_updated_on=>wwv_flow_imp.dz('20260919190116Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43897432702698020)
,p_name=>'P2_FSI_ISOLATION_COMMENTS'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(43896458318698010)
,p_prompt=>'Comments'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'Comments and references to associated safety documentation'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260919183503Z')
,p_updated_on=>wwv_flow_imp.dz('20260919183503Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43896725501698013)
,p_name=>'P2_FSI_IT_PERMISSION_GRANTED'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(43896458318698010)
,p_prompt=>'If ''Yes'' has permission been granted to proceed?'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Yes;Y,No;N'
,p_grid_column_css_classes=>'cm-binary-item'
,p_field_template=>3031561666792084173
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2',
  'page_action_on_selection', 'NONE')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260919183502Z')
,p_updated_on=>wwv_flow_imp.dz('20260919183502Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24591819584992934)
,p_name=>'P2_INSURER_INFORMED_DATETIME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(24591595204992931)
,p_prompt=>'Insurer Informed Datetime'
,p_format_mask=>'DD-MON-YYYY HH24:MI'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'Y',
  'use_defaults', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260913132804Z')
,p_updated_on=>wwv_flow_imp.dz('20260913135518Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24591954850992935)
,p_name=>'P2_ISOLATION_COMMENTS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(24591595204992931)
,p_prompt=>'Comments relating to isolations'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260913132804Z')
,p_updated_on=>wwv_flow_imp.dz('20260913132804Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(25230683508353146)
,p_name=>'P2_ISOLATION_DIAGRAM_SERIAL_NO'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(25230494463353144)
,p_prompt=>'Isolation & Earthing Diagram Serial No.'
,p_placeholder=>'Enter serial number'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>100
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_updated_on=>wwv_flow_imp.dz('20260823151912Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(28347563310917048)
,p_name=>'P2_IS_CHANGED'
,p_item_sequence=>20
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26943672440347707)
,p_name=>'P2_IT_PERMISSION_GRANTED'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(26943346862347704)
,p_prompt=>'If ''Yes'' has permission been granted to proceed?'
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
,p_updated_on=>wwv_flow_imp.dz('20260823151912Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26943296650347703)
,p_name=>'P2_OTHER_PERSONS_COUNT'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(25230894903353148)
,p_prompt=>'Number of other persons working under this Permit'
,p_placeholder=>'0'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_updated_on=>wwv_flow_imp.dz('20260823151912Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(25229203963353132)
,p_name=>'P2_PERMIT_ID'
,p_item_sequence=>10
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(25230756080353147)
,p_name=>'P2_PERMIT_NUMBER'
,p_item_sequence=>40
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26943083679347701)
,p_name=>'P2_PERSON_IN_CHARGE_NAME'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(25230894903353148)
,p_prompt=>'Name of Person in Charge'
,p_placeholder=>'Full name of person in charge'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_updated_on=>wwv_flow_imp.dz('20260823151912Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(8878565362853334)
,p_name=>'P2_PTW_TYPE'
,p_item_sequence=>50
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260820195444Z')
,p_updated_on=>wwv_flow_imp.dz('20260820195444Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(25230519318353145)
,p_name=>'P2_SAFETY_PROGRAMME_REF_NO'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(25230494463353144)
,p_prompt=>'Safety Programme Reference No.'
,p_placeholder=>'Enter reference number'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>100
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_updated_on=>wwv_flow_imp.dz('20260823151912Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(25230978574353149)
,p_name=>'P2_SITE_DETAILS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(25230894903353148)
,p_prompt=>'Site'
,p_placeholder=>'Enter full site details and area of works'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_COMBOBOX'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'    SELECT s.site_name d, s.site_id r',
'    FROM   ptw_pro.ptw_lv_sites s',
'    WHERE  s.is_active = ''Y''',
'    ORDER  BY s.site_name'))
,p_cSize=>30
,p_cMaxlength=>500
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'case_sensitive', 'N',
  'fetch_on_search', 'N',
  'infinite_scroll', 'Y',
  'manual_entries_item', 'P2_SITE_NEW_NAME',
  'match_type', 'CONTAINS',
  'min_chars', '0',
  'multi_selection', 'N')).to_clob
,p_updated_on=>wwv_flow_imp.dz('20260823151912Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(8875977704853308)
,p_name=>'P2_SITE_NEW_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(25230894903353148)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260721205950Z')
,p_updated_on=>wwv_flow_imp.dz('20260721205950Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(8878977797853338)
,p_name=>'P2_SPECIALIST_EQUIPMENT_DETAILS'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(25230894903353148)
,p_prompt=>'Specialist Equipment Details'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_display_when=>'P2_PTW_TYPE'
,p_display_when2=>'WORKING AT HEIGHT'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260823145644Z')
,p_updated_on=>wwv_flow_imp.dz('20260823145644Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(26943152825347702)
,p_name=>'P2_SUPERVISING_COMPANY'
,p_is_required=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(25230894903353148)
,p_prompt=>'Company responsible for supervising the works'
,p_placeholder=>'Company name'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_updated_on=>wwv_flow_imp.dz('20260823151912Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(25229474334353134)
,p_name=>'P2_WORKFLOW_STATUS'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(25231084779353150)
,p_name=>'P2_WORK_DESCRIPTION'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(25230894903353148)
,p_prompt=>'Description of work activity'
,p_placeholder=>'Describe the work activity to be carried out'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>2000
,p_cHeight=>3
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_updated_on=>wwv_flow_imp.dz('20260823151912Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(8876123229853310)
,p_validation_name=>'Area of Works Required'
,p_static_id=>'area-of-works-required'
,p_validation_sequence=>20
,p_validation=>'P2_AREA_OF_WORKS'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Area of Works is required.'
,p_associated_item=>wwv_flow_imp.id(8876071099853309)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260721205951Z')
,p_updated_on=>wwv_flow_imp.dz('20260721205951Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(26944608190347717)
,p_validation_name=>'Client Permission Required'
,p_static_id=>'client-permission-required'
,p_validation_sequence=>40
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
':REQUEST = ''NEXT_STEP'' AND EXISTS (',
'    SELECT 1',
'    FROM   ptw_pro.ptw_types t',
'    JOIN   ptw_pro.ptw_type_sections ts ON ts.type_id = t.type_id',
'    WHERE  t.ptw_type      = :P2_PTW_TYPE',
'    AND    ts.section_code = ''CLIENT_PERMISSION''',
')'))
,p_validation2=>'SQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>'Please indicate if the client has granted permission.'
,p_validation_condition=>'P2_PTW_TYPE'
,p_validation_condition2=>'LV ISOLATION'
,p_validation_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_associated_item=>wwv_flow_imp.id(26943471028347705)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_updated_on=>wwv_flow_imp.dz('20260919124433Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(45757125497782523)
,p_validation_name=>'Client permission validation'
,p_static_id=>'client-permission-validation'
,p_validation_sequence=>50
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
':REQUEST = ''NEXT_STEP'' AND EXISTS (',
'    SELECT 1',
'    FROM   ptw_pro.ptw_types t',
'    JOIN   ptw_pro.ptw_type_sections ts ON ts.type_id = t.type_id',
'    WHERE  t.ptw_type      = :P2_PTW_TYPE',
'    AND    ts.section_code = ''CLIENT_PERMISSION''',
')'))
,p_validation2=>'SQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>'Both the mandatory Client Permission questions must be answered'
,p_validation_condition=>':REQUEST = ''NEXT_STEP'' AND :P2_PTW_TYPE = ''LV ISOLATION'''
,p_validation_condition2=>'PLSQL'
,p_validation_condition_type=>'EXPRESSION'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260501145330Z')
,p_updated_on=>wwv_flow_imp.dz('20260919124433Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(24592097688992936)
,p_validation_name=>'Fire Systems Affected'
,p_static_id=>'fire-systems-affected'
,p_validation_sequence=>60
,p_validation=>'P2_FIRE_SYSTEMS_AFFECTED'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'You must say whether Fire system are affected.',
''))
,p_validation_condition=>'P2_PTW_TYPE'
,p_validation_condition2=>'HOT WORK'
,p_validation_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260913140249Z')
,p_updated_on=>wwv_flow_imp.dz('20260913140249Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(24592167471992937)
,p_validation_name=>'Fire Systems Isolated'
,p_static_id=>'fire-systems-isolated'
,p_validation_sequence=>70
,p_validation=>'P2_FIRE_SYSTEMS_ISOLATED'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'You must say whether Fire system are isolated.',
'',
''))
,p_validation_condition=>'P2_PTW_TYPE'
,p_validation_condition2=>'HOT WORK'
,p_validation_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260913140249Z')
,p_updated_on=>wwv_flow_imp.dz('20260913140249Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(26944589701347716)
,p_validation_name=>'Person in Charge Required'
,p_static_id=>'person-in-charge-required'
,p_validation_sequence=>30
,p_validation=>'P2_PERSON_IN_CHARGE_NAME'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Name of Person in Charge is required.'
,p_associated_item=>wwv_flow_imp.id(26943083679347701)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_updated_on=>wwv_flow_imp.dz('20260721205951Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(26944420328347715)
,p_validation_name=>'Site Details Required'
,p_static_id=>'site-details-required'
,p_validation_sequence=>10
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    IF :P2_SITE_DETAILS IS NULL AND :P2_SITE_NEW_NAME IS NULL THEN',
'        RETURN ''Site is required.'';',
'    END IF;',
'    RETURN NULL;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_ERR_TEXT'
,p_associated_item=>wwv_flow_imp.id(25230978574353149)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_updated_on=>wwv_flow_imp.dz('20260721205951Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(28347379433917046)
,p_name=>'Click NEXT STEP'
,p_static_id=>'click-next-step'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(26944315283347714)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_updated_on=>wwv_flow_imp.dz('20260330202134Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33349755492951411)
,p_event_id=>wwv_flow_imp.id(28347379433917046)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'captureLocationThenSubmit(''NEXT_STEP'');')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260311202604Z')
,p_updated_on=>wwv_flow_imp.dz('20260311210235Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(33349958939951413)
,p_name=>'Click SAVE DRAFT'
,p_static_id=>'click-save-draft'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(26944216198347713)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_created_on=>wwv_flow_imp.dz('20260311210419Z')
,p_updated_on=>wwv_flow_imp.dz('20260330202134Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33350005327951414)
,p_event_id=>wwv_flow_imp.id(33349958939951413)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'captureLocationThenSubmit(''SAVE_DRAFT'');',
    '')))).to_clob
,p_created_on=>wwv_flow_imp.dz('20260311210419Z')
,p_updated_on=>wwv_flow_imp.dz('20260311210419Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(43897898239698024)
,p_name=>'show-hide-fsi-insurer-informed'
,p_static_id=>'show-hide-fsi-insurer-informed'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P2_FSI_INSURANCE_NECESSARY'
,p_condition_element=>'P2_FSI_INSURANCE_NECESSARY'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_created_on=>wwv_flow_imp.dz('20260919183503Z')
,p_updated_on=>wwv_flow_imp.dz('20260919185827Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(43898088851698026)
,p_event_id=>wwv_flow_imp.id(43897898239698024)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_static_id=>'native-hide'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_INSURER_INFORMED_DATETIME'
,p_client_condition_type=>'EQUALS'
,p_client_condition_element=>'P2_FSI_INSURANCE_NECESSARY'
,p_client_condition_expression=>'N'
,p_created_on=>wwv_flow_imp.dz('20260919183503Z')
,p_updated_on=>wwv_flow_imp.dz('20260919185827Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(43897982392698025)
,p_event_id=>wwv_flow_imp.id(43897898239698024)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_static_id=>'native-show'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_FSI_INSURER_INFORMED_DATETIME'
,p_client_condition_type=>'EQUALS'
,p_client_condition_element=>'P2_FSI_INSURANCE_NECESSARY'
,p_client_condition_expression=>'Y'
,p_created_on=>wwv_flow_imp.dz('20260919183503Z')
,p_updated_on=>wwv_flow_imp.dz('20260919185131Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(43897590225698021)
,p_name=>'show-hide-fsi-it-permission-question'
,p_static_id=>'show-hide-fsi-it-permission-question'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P2_FSI_AFFECTS_IT_SYSTEMS'
,p_condition_element=>'P2_FSI_AFFECTS_IT_SYSTEMS'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_created_on=>wwv_flow_imp.dz('20260919183503Z')
,p_updated_on=>wwv_flow_imp.dz('20260919185131Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(43897756769698023)
,p_event_id=>wwv_flow_imp.id(43897590225698021)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_static_id=>'native-hide'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_FSI_IT_PERMISSION_GRANTED'
,p_client_condition_type=>'EQUALS'
,p_client_condition_element=>'P2_FSI_AFFECTS_IT_SYSTEMS'
,p_client_condition_expression=>'N'
,p_created_on=>wwv_flow_imp.dz('20260919183503Z')
,p_updated_on=>wwv_flow_imp.dz('20260919185131Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(43897660831698022)
,p_event_id=>wwv_flow_imp.id(43897590225698021)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_static_id=>'native-show'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_FSI_IT_PERMISSION_GRANTED'
,p_client_condition_type=>'EQUALS'
,p_client_condition_element=>'P2_FSI_INSURANCE_NECESSARY'
,p_client_condition_expression=>'Y'
,p_created_on=>wwv_flow_imp.dz('20260919183503Z')
,p_updated_on=>wwv_flow_imp.dz('20260919185131Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26943794986347708)
,p_name=>'Show/Hide IT Permission Question'
,p_static_id=>'show-hide-it-permission-question'
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
 p_id=>wwv_flow_imp.id(26943911056347710)
,p_event_id=>wwv_flow_imp.id(26943794986347708)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_static_id=>'native-hide'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_IT_PERMISSION_GRANTED'
,p_client_condition_type=>'EQUALS'
,p_client_condition_element=>'P2_AFFECTS_IT_SYSTEMS'
,p_client_condition_expression=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26943866082347709)
,p_event_id=>wwv_flow_imp.id(26943794986347708)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_static_id=>'native-show'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_IT_PERMISSION_GRANTED'
,p_client_condition_type=>'EQUALS'
,p_client_condition_element=>'P2_AFFECTS_IT_SYSTEMS'
,p_client_condition_expression=>'Y'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(30143717338642706)
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
'    IF v_is_engineer > 0 AND :P2_PERMIT_ID IS NOT NULL THEN  -- use correct Pn_PERMIT_ID per page',
'',
'        SELECT COUNT(*) INTO v_is_owner',
'        FROM   ptw_pro.ptw_lv_permits',
'        WHERE  permit_id = :P2_PERMIT_ID         -- use correct Pn_PERMIT_ID per page',
'        AND    UPPER(created_by) = UPPER(V(''APP_USER''));',
'',
'        IF v_is_owner = 0 THEN',
'',
'            SELECT COUNT(*) INTO v_is_auth',
'            FROM   ptw_pro.ptw_signatures',
'            WHERE  permit_id = :P2_PERMIT_ID',
'            AND    stage     = ''AUTH''',
'            AND    UPPER(person_name) = UPPER(V(''APP_USER''));  -- check if the engineer is the auth_person',
'',
'          IF v_is_auth = 0 THEN',
'',
'            apex_error.add_error(',
'                p_message          => ''Access denied. You can only edit permits you have created.'',',
'                p_display_location => apex_error.c_inline_in_notification',
'            );',
'            apex_util.redirect_url(',
'                apex_page.get_url(p_page => 1)',
'            );',
'          END IF;',
'',
'        END IF;',
'',
'    END IF;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P2_PERMIT_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>30143717338642706
,p_updated_on=>wwv_flow_imp.dz('20260820191556Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(26944769422347718)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load Permit Data'
,p_static_id=>'load-permit-data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'',
'  :P2_CURRENT_STEP := ''SITE_WORK_DETAILS'';',
'',
'    DECLARE',
'        v_insurer_informed_dt DATE;',
'    BEGIN',
'        SELECT',
'            permit_number, current_step, workflow_status, safety_programme_ref_no,',
'            isolation_diagram_serial_no, site_id, area_of_works, work_description,',
'            person_in_charge_name, supervising_company, other_persons_count,',
'            client_permission_granted, affects_it_systems, it_permission_granted,',
'            specialist_equipment_details, ptw_type,',
'            fire_systems_affected, fire_systems_isolated, insurer_informed_datetime, isolation_comments,',
'            fire_precautions_details, fire_alarm_arrangements,',
'            insurance_necessary',
'        INTO',
'            :P2_PERMIT_NUMBER, :P2_CURRENT_STEP, :P2_WORKFLOW_STATUS, :P2_SAFETY_PROGRAMME_REF_NO,',
'            :P2_ISOLATION_DIAGRAM_SERIAL_NO, :P2_SITE_DETAILS, :P2_AREA_OF_WORKS, :P2_WORK_DESCRIPTION,',
'            :P2_PERSON_IN_CHARGE_NAME, :P2_SUPERVISING_COMPANY, :P2_OTHER_PERSONS_COUNT,',
'            :P2_CLIENT_PERMISSION_GRANTED, :P2_AFFECTS_IT_SYSTEMS, :P2_IT_PERMISSION_GRANTED,',
'            :P2_SPECIALIST_EQUIPMENT_DETAILS, :P2_PTW_TYPE,',
'            :P2_FIRE_SYSTEMS_AFFECTED, :P2_FIRE_SYSTEMS_ISOLATED, v_insurer_informed_dt, :P2_ISOLATION_COMMENTS,',
'            :P2_FIRE_PRECAUTIONS_DETAILS, :P2_FIRE_ALARM_ARRANGEMENTS,',
'            :P2_FSI_INSURANCE_NECESSARY',
'        FROM ptw_pro.ptw_lv_permits',
'        WHERE permit_id = :P2_PERMIT_ID;',
'',
'        IF v_insurer_informed_dt IS NOT NULL THEN',
'            :P2_INSURER_INFORMED_DATETIME     := TO_CHAR(v_insurer_informed_dt, ''DD-MON-YYYY HH24:MI'');',
'            :P2_FSI_INSURER_INFORMED_DATETIME := :P2_INSURER_INFORMED_DATETIME;',
'        END IF;',
'',
'        -- Fire Systems Isolation Details region reuses the same underlying',
'        -- columns as Client Permission / Fire & Smoke Systems (loaded into',
'        -- P2_CLIENT_PERMISSION_GRANTED etc. above) - mirror them into this',
'        -- region''s own items so the screen shows the saved values.',
'        :P2_FSI_CLIENT_PERMISSION_GRANTED := :P2_CLIENT_PERMISSION_GRANTED;',
'        :P2_FSI_AFFECTS_IT_SYSTEMS        := :P2_AFFECTS_IT_SYSTEMS;',
'        :P2_FSI_IT_PERMISSION_GRANTED     := :P2_IT_PERMISSION_GRANTED;',
'        :P2_FSI_FIRE_SYSTEMS_AFFECTED     := :P2_FIRE_SYSTEMS_AFFECTED;',
'        :P2_FSI_FIRE_SYSTEMS_ISOLATED     := :P2_FIRE_SYSTEMS_ISOLATED;',
'        :P2_FSI_FIRE_PRECAUTIONS_DETAILS  := :P2_FIRE_PRECAUTIONS_DETAILS;',
'        :P2_FSI_FIRE_ALARM_ARRANGEMENTS   := :P2_FIRE_ALARM_ARRANGEMENTS;',
'        :P2_FSI_ISOLATION_COMMENTS        := :P2_ISOLATION_COMMENTS;',
'    END;',
'    :G_ACTIVE_PERMIT_ID := :P2_PERMIT_ID;',
'',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        :P2_PERMIT_ID := NULL;',
'        :P2_WORKFLOW_STATUS := ''DRAFT'';',
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
,p_updated_on=>wwv_flow_imp.dz('20260919183503Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(26944820115347719)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save Permit Data (INSERT or UPDATE)'
,p_static_id=>'save-permit-data-insert-or-update'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_site_id        ptw_pro.ptw_lv_sites.site_id%TYPE;',
'    v_permit_id      ptw_pro.ptw_lv_permits.permit_id%TYPE := :P2_PERMIT_ID;',
'    v_permit_number  ptw_pro.ptw_lv_permits.permit_number%TYPE;',
'    v_saved          BOOLEAN;',
'    v_message        VARCHAR2(4000);',
'BEGIN',
'    IF :P2_WORKFLOW_STATUS = ''DRAFT'' THEN',
'        ptw_pro.ptw_permit_save_pkg.save_permit_header(',
'            p_permit_id                   => v_permit_id,',
'            p_ptw_type                    => :P2_PTW_TYPE,',
'            p_workflow_status             => :P2_WORKFLOW_STATUS,',
'            p_safety_programme_ref_no     => :P2_SAFETY_PROGRAMME_REF_NO,',
'            p_isolation_diagram_serial_no => :P2_ISOLATION_DIAGRAM_SERIAL_NO,',
'            p_site_id                     =>  CASE WHEN :P2_SITE_NEW_NAME IS NULL THEN :P2_SITE_DETAILS END,',
'            p_site_new_name               => :P2_SITE_NEW_NAME,',
'            p_area_of_works               => :P2_AREA_OF_WORKS,',
'            p_work_description            => :P2_WORK_DESCRIPTION,',
'            p_person_in_charge_name       => :P2_PERSON_IN_CHARGE_NAME,',
'            p_supervising_company         => :P2_SUPERVISING_COMPANY,',
'            p_other_persons_count         => :P2_OTHER_PERSONS_COUNT,',
'            p_client_permission_granted   => CASE WHEN :P2_PTW_TYPE = ''FIRE SYSTEMS ISOLATION''',
'                                                  THEN :P2_FSI_CLIENT_PERMISSION_GRANTED',
'                                                  ELSE :P2_CLIENT_PERMISSION_GRANTED END,',
'            p_affects_it_systems          => CASE WHEN :P2_PTW_TYPE = ''FIRE SYSTEMS ISOLATION''',
'                                                  THEN :P2_FSI_AFFECTS_IT_SYSTEMS',
'                                                  ELSE :P2_AFFECTS_IT_SYSTEMS END,',
'            p_it_permission_granted       => CASE WHEN :P2_PTW_TYPE = ''FIRE SYSTEMS ISOLATION''',
'                                                  THEN :P2_FSI_IT_PERMISSION_GRANTED',
'                                                  ELSE :P2_IT_PERMISSION_GRANTED END,',
'            p_fire_systems_affected       => CASE WHEN :P2_PTW_TYPE = ''FIRE SYSTEMS ISOLATION''',
'                                                  THEN :P2_FSI_FIRE_SYSTEMS_AFFECTED',
'                                                  ELSE :P2_FIRE_SYSTEMS_AFFECTED END,',
'            p_fire_systems_isolated       => CASE WHEN :P2_PTW_TYPE = ''FIRE SYSTEMS ISOLATION''',
'                                                  THEN :P2_FSI_FIRE_SYSTEMS_ISOLATED',
'                                                  ELSE :P2_FIRE_SYSTEMS_ISOLATED END,',
'            p_insurer_informed_datetime   => TO_DATE(CASE WHEN :P2_PTW_TYPE = ''FIRE SYSTEMS ISOLATION''',
'                                                           THEN :P2_FSI_INSURER_INFORMED_DATETIME',
'                                                           ELSE :P2_INSURER_INFORMED_DATETIME END,',
'                                                      ''DD-MON-YYYY HH24:MI''),',
'            p_isolation_comments          => CASE WHEN :P2_PTW_TYPE = ''FIRE SYSTEMS ISOLATION''',
'                                                  THEN :P2_FSI_ISOLATION_COMMENTS',
'                                                  ELSE :P2_ISOLATION_COMMENTS END,',
'            p_fire_precautions_details    => CASE WHEN :P2_PTW_TYPE = ''FIRE SYSTEMS ISOLATION''',
'                                                  THEN :P2_FSI_FIRE_PRECAUTIONS_DETAILS',
'                                                  ELSE :P2_FIRE_PRECAUTIONS_DETAILS END,',
'            p_fire_alarm_arrangements     => CASE WHEN :P2_PTW_TYPE = ''FIRE SYSTEMS ISOLATION''',
'                                                  THEN :P2_FSI_FIRE_ALARM_ARRANGEMENTS',
'                                                  ELSE :P2_FIRE_ALARM_ARRANGEMENTS END,',
'            p_insurance_necessary         => :P2_FSI_INSURANCE_NECESSARY,',
'            p_specialist_equipment_details => :P2_SPECIALIST_EQUIPMENT_DETAILS,',
'            p_latitude                    => :APP_LATITUDE,',
'            p_longitude                   => :APP_LONGITUDE,',
'            p_resolved_site_id            => v_site_id,',
'            p_permit_number               => v_permit_number,',
'            p_saved                       => v_saved,',
'            p_message                     => v_message',
'        );',
'',
'        IF v_saved THEN',
'            :P2_PERMIT_ID       := v_permit_id;',
'            :P2_PERMIT_NUMBER   := v_permit_number;',
'            :P2_SITE_DETAILS    := v_site_id;',
'            :P2_SITE_NEW_NAME   := NULL;',
'            :P2_CURRENT_STEP    := ''SITE_WORK_DETAILS'';',
'            :P2_WORKFLOW_STATUS := ''DRAFT'';',
'            apex_application.g_print_success_message := v_message;',
'        ELSE',
'            apex_error.add_error(',
'                p_message          => v_message,',
'                p_display_location => apex_error.c_inline_in_notification);',
'            RAISE_APPLICATION_ERROR(-20063, v_message);',
'        END IF;',
'    END IF;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>':REQUEST IN (''SAVE_DRAFT'',''NEXT_STEP'')'
,p_process_when_type=>'EXPRESSION'
,p_process_when2=>'PLSQL'
,p_process_success_message=>'Permit saved successfully.'
,p_security_scheme=>wwv_flow_imp.id(31533963716212424)
,p_internal_uid=>26944820115347719
,p_updated_on=>wwv_flow_imp.dz('20260919183503Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(27017024078886521)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SYNC_OFFLINE_DATA'
,p_static_id=>'sync-offline-data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_data_json     CLOB := apex_application.g_x01;',
'    l_record_id_in  NUMBER := apex_application.g_x03;  -- NULL = INSERT, value = UPDATE',
'    l_json          JSON_OBJECT_T;',
'    v_permit_id     ptw_pro.ptw_lv_permits.permit_id%TYPE := l_record_id_in;',
'    v_site_id       ptw_pro.ptw_lv_sites.site_id%TYPE;',
'    v_permit_number ptw_pro.ptw_lv_permits.permit_number%TYPE;',
'    v_workflow_status ptw_pro.ptw_lv_permits.workflow_status%TYPE;',
'    v_ptw_type      ptw_pro.ptw_lv_permits.ptw_type%TYPE;',
'    v_saved         BOOLEAN;',
'    v_message       VARCHAR2(4000);',
'BEGIN',
'    l_json := JSON_OBJECT_T.parse(l_data_json);',
'    v_ptw_type := l_json.get_string(''P2_PTW_TYPE'');',
'',
'    -- On an UPDATE, we must know the permit''s CURRENT',
'    -- workflow_status from the database - NOT trust a',
'    -- possibly-stale value captured hours ago while offline -',
'    -- so the DRAFT guard inside save_permit_header is checked',
'    -- against live data, same as the online path always does.',
'    IF v_permit_id IS NOT NULL THEN',
'        SELECT workflow_status INTO v_workflow_status',
'        FROM   ptw_pro.ptw_lv_permits WHERE permit_id = v_permit_id;',
'    ELSE',
'        v_workflow_status := ''DRAFT'';  -- new permit, always starts in draft',
'    END IF;',
'',
'    -- Same type-aware swap as the online save process: the offline',
'    -- device stores the Fire Isolation region''s own P2_FSI_* item',
'    -- values in the JSON payload under their own keys, so this pulls',
'    -- from those keys when the permit being synced is a Fire Systems',
'    -- Isolation certificate, and from the generic keys otherwise.',
'    ptw_pro.ptw_permit_save_pkg.save_permit_header(',
'        p_permit_id                   => v_permit_id,',
'        p_ptw_type                    => v_ptw_type,',
'        p_workflow_status             => v_workflow_status,',
'        p_safety_programme_ref_no     => l_json.get_string(''P2_SAFETY_PROGRAMME_REF_NO''),',
'        p_isolation_diagram_serial_no => l_json.get_string(''P2_ISOLATION_DIAGRAM_SERIAL_NO''),',
'        p_site_id                     => CASE WHEN l_json.get_string(''P2_SITE_NEW_NAME'') IS NULL',
'                                           THEN TO_NUMBER(l_json.get_string(''P2_SITE_DETAILS'')) END,',
'        p_site_new_name               => l_json.get_string(''P2_SITE_NEW_NAME''),',
'        p_area_of_works               => l_json.get_string(''P2_AREA_OF_WORKS''),',
'        p_work_description            => l_json.get_string(''P2_WORK_DESCRIPTION''),',
'        p_person_in_charge_name       => l_json.get_string(''P2_PERSON_IN_CHARGE_NAME''),',
'        p_supervising_company         => l_json.get_string(''P2_SUPERVISING_COMPANY''),',
'        p_other_persons_count         => l_json.get_number(''P2_OTHER_PERSONS_COUNT''),',
'        p_client_permission_granted   => CASE WHEN v_ptw_type = ''FIRE SYSTEMS ISOLATION''',
'                                              THEN l_json.get_string(''P2_FSI_CLIENT_PERMISSION_GRANTED'')',
'                                              ELSE l_json.get_string(''P2_CLIENT_PERMISSION_GRANTED'') END,',
'        p_affects_it_systems          => CASE WHEN v_ptw_type = ''FIRE SYSTEMS ISOLATION''',
'                                              THEN l_json.get_string(''P2_FSI_AFFECTS_IT_SYSTEMS'')',
'                                              ELSE l_json.get_string(''P2_AFFECTS_IT_SYSTEMS'') END,',
'        p_it_permission_granted       => CASE WHEN v_ptw_type = ''FIRE SYSTEMS ISOLATION''',
'                                              THEN l_json.get_string(''P2_FSI_IT_PERMISSION_GRANTED'')',
'                                              ELSE l_json.get_string(''P2_IT_PERMISSION_GRANTED'') END,',
'        p_specialist_equipment_details => l_json.get_string(''P2_SPECIALIST_EQUIPMENT_DETAILS''),',
'        p_fire_systems_affected       => CASE WHEN v_ptw_type = ''FIRE SYSTEMS ISOLATION''',
'                                              THEN l_json.get_string(''P2_FSI_FIRE_SYSTEMS_AFFECTED'')',
'                                              ELSE l_json.get_string(''P2_FIRE_SYSTEMS_AFFECTED'') END,',
'        p_fire_systems_isolated       => CASE WHEN v_ptw_type = ''FIRE SYSTEMS ISOLATION''',
'                                              THEN l_json.get_string(''P2_FSI_FIRE_SYSTEMS_ISOLATED'')',
'                                              ELSE l_json.get_string(''P2_FIRE_SYSTEMS_ISOLATED'') END,',
'        p_insurer_informed_datetime   => TO_DATE(CASE WHEN v_ptw_type = ''FIRE SYSTEMS ISOLATION''',
'                                                       THEN l_json.get_string(''P2_FSI_INSURER_INFORMED_DATETIME'')',
'                                                       ELSE l_json.get_string(''P2_INSURER_INFORMED_DATETIME'') END,',
'                                                  ''DD-MON-YYYY HH24:MI''),',
'        p_isolation_comments          => CASE WHEN v_ptw_type = ''FIRE SYSTEMS ISOLATION''',
'                                              THEN l_json.get_string(''P2_FSI_ISOLATION_COMMENTS'')',
'                                              ELSE l_json.get_string(''P2_ISOLATION_COMMENTS'') END,',
'        p_fire_precautions_details    => CASE WHEN v_ptw_type = ''FIRE SYSTEMS ISOLATION''',
'                                              THEN l_json.get_string(''P2_FSI_FIRE_PRECAUTIONS_DETAILS'')',
'                                              ELSE l_json.get_string(''P2_FIRE_PRECAUTIONS_DETAILS'') END,',
'        p_fire_alarm_arrangements     => CASE WHEN v_ptw_type = ''FIRE SYSTEMS ISOLATION''',
'                                              THEN l_json.get_string(''P2_FSI_FIRE_ALARM_ARRANGEMENTS'')',
'                                              ELSE l_json.get_string(''P2_FIRE_ALARM_ARRANGEMENTS'') END,',
'        p_insurance_necessary         => l_json.get_string(''P2_FSI_INSURANCE_NECESSARY''),',
'        p_latitude                    => l_json.get_number(''APP_LATITUDE''),',
'        p_longitude                   => l_json.get_number(''APP_LONGITUDE''),',
'        p_resolved_site_id            => v_site_id,',
'        p_permit_number               => v_permit_number,',
'        p_saved                       => v_saved,',
'        p_message                     => v_message',
'    );',
'',
'    apex_json.open_object;',
'    apex_json.write(''success'', v_saved);',
'    apex_json.write(''message'', v_message);',
'    apex_json.close_object;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'SYNC_OFFLINE_DATA'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_security_scheme=>wwv_flow_imp.id(31533963716212424)
,p_internal_uid=>27017024078886521
,p_updated_on=>wwv_flow_imp.dz('20260919183503Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
