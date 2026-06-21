prompt --application/pages/page_00300
begin
--   Manifest
--     PAGE: 00300
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
 p_id=>300
,p_name=>'PTW PDF Report'
,p_alias=>'PTW-PDF-REPORT'
,p_step_title=>'PTW PDF Report'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(function () {',
'    var BINARY_ITEMS = [''P300_INCLUDE_HISTORY''];',
'',
'    var BADGES = [',
unistr('        { val: ''Y'', cls: ''binary-badge-yes'', label: ''\2713'' },'),
unistr('        { val: ''N'', cls: ''binary-badge-no'',  label: ''\2717'' }'),
'    ];',
'',
'    function initBinaryBadges() {',
'        BINARY_ITEMS.forEach(function (itemName) {',
'            var $fc = $(''#'' + itemName).closest(''.t-Form-fieldContainer'');',
'            if ($fc.length === 0) return;',
'',
'            $fc.find(''.binary-badge-row'').remove();',
'',
'            var currentVal = apex.item(itemName).getValue() || ''N'';',
'            var $row = $(''<div class="binary-badge-row"></div>'').attr(''data-item'', itemName);',
'',
'            BADGES.forEach(function (b) {',
'                $(''<span></span>'')',
'                    .addClass(''binary-badge '' + b.cls)',
'                    .toggleClass(''cm-active'', currentVal === b.val)',
'                    .attr(''data-value'', b.val)',
'                    .text(b.label)',
'                    .appendTo($row);',
'            });',
'',
'            $fc.find(''.t-Form-inputContainer'').append($row);',
'        });',
'',
'        $(''.cm-binary-item .apex-item-grid'').hide();',
'        $(''.cm-binary-item .apex-item-radio'').hide();',
'    }',
'',
'    $(document).off(''click.p300binary'').on(''click.p300binary'', ''.cm-binary-item .binary-badge'', function () {',
'        var $badge   = $(this);',
'        var $row     = $badge.closest(''.binary-badge-row'');',
'        var itemName = $row.attr(''data-item'');',
'        var val      = $badge.attr(''data-value'');',
'',
'        // Set the underlying radio value',
'        $(''input[name="'' + itemName + ''"][value="'' + val + ''"]'').prop(''checked'', true).trigger(''change'');',
'',
'        // Update badge highlight',
'        $row.find(''.binary-badge'').removeClass(''cm-active'');',
'        $badge.addClass(''cm-active'');',
'    });',
'',
'    // Run after page loads',
'    apex.jQuery(document).ready(function () {',
'        initBinaryBadges();',
'    });',
'}());'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* =====================================================',
'   GP15 COMMERCIAL GAS SERVICE REPORT - PROFESSIONAL PDF CSS',
'   Optimized for A4 printing with efficient space usage',
'   ===================================================== */',
'',
'/* PRINT SETTINGS */',
'@media print {',
'    .t-Body-nav,',
'    .t-Header,',
'    .apex-button-group,',
'    #print-button-region,',
'    .no-print {',
'        display: none !important;',
'    }',
'    ',
'    .gp15-section {',
'        page-break-inside: avoid;',
'    }',
'    ',
'    h4 {',
'        page-break-after: avoid;',
'    }',
'    ',
'    @page {',
'        size: A4 portrait;',
'        margin: 10mm 12mm 10mm 12mm;',
'    }',
'    ',
'    body {',
'        background: white !important;',
'        -webkit-print-color-adjust: exact;',
'        print-color-adjust: exact;',
'    }',
'}',
'',
'/* MAIN CONTAINER */',
'.gp15-report-container {',
'    max-width: 210mm;',
'    margin: 0 auto;',
'    padding: 0;',
'    background: white;',
'    font-family: ''Segoe UI'', ''Arial'', sans-serif;',
'    font-size: 9pt;',
'    color: #1a1a1a;',
'    line-height: 1.35;',
'    box-shadow: 0 0 15px rgba(0,0,0,0.08);',
'}',
'',
'/* HEADER - Compact professional design */',
'.gp15-header {',
'    background: linear-gradient(135deg, #1a3a5c 0%, #2d5a8c 100%);',
'    color: white;',
'    padding: 18px 25px 16px 25px;',
'    margin-bottom: 0;',
'    border-bottom: 3px solid #0d2942;',
'}',
'',
'.gp15-header h1 {',
'    font-size: 20pt;',
'    margin: 0 0 8px 0;',
'    font-weight: 600;',
'    letter-spacing: 0.5px;',
'    text-transform: uppercase;',
'}',
'',
'.gp15-header .permit-number {',
'    font-size: 14pt;',
'    font-weight: 600;',
'    margin: 6px 0;',
'    background: rgba(255,255,255,0.15);',
'    display: inline-block;',
'    padding: 4px 14px;',
'    border-radius: 4px;',
'    border: 1px solid rgba(255,255,255,0.3);',
'}',
'',
'.gp15-header > div:last-child {',
'    display: flex;',
'    justify-content: space-between;',
'    margin-top: 10px;',
'    font-size: 9.5pt;',
'    opacity: 0.95;',
'}',
'',
'/* COMPANY LOGO */',
'.company-logo {',
'    background: rgba(255,255,255,0.95);',
'    padding: 8px 12px;',
'    border-radius: 4px;',
'    display: inline-flex;',
'    align-items: center;',
'    justify-content: center;',
'    min-height: 50px;',
'    min-width: 120px;',
'    box-shadow: 0 2px 6px rgba(0,0,0,0.15);',
'    margin-bottom: 10px;',
'}',
'',
'.company-logo img {',
'    max-height: 50px;',
'    max-width: 180px;',
'    display: block;',
'}',
'',
'.company-logo:empty::before {',
'    content: ''YOUR COMPANY'';',
'    color: #1a3a5c;',
'    font-weight: 700;',
'    font-size: 12pt;',
'    letter-spacing: 0.8px;',
'}',
'',
'/* SECTIONS - Compact with clear borders */',
'.gp15-section {',
'    margin: 0;',
'    background: white;',
'    border: 1px solid #c8d1db;',
'    border-top: none;',
'}',
'',
'.gp15-section:first-of-type {',
'    border-top: 1px solid #c8d1db;',
'}',
'',
'.gp15-section-title {',
'    background: linear-gradient(to bottom, #e8ecf1 0%, #dce3ea 100%);',
'    padding: 8px 16px;',
'    font-weight: 700;',
'    font-size: 10pt;',
'    color: #1a3a5c;',
'    border-bottom: 2px solid #b0bcc9;',
'    text-transform: uppercase;',
'    letter-spacing: 0.5px;',
'}',
'',
'/* DATA ROWS - Clean and efficient */',
'.gp15-row {',
'    display: flex;',
'    padding: 6px 16px;',
'    border-bottom: 1px solid #e8ecf1;',
'    align-items: center;',
'}',
'',
'.gp15-row:last-child {',
'    border-bottom: none;',
'}',
'',
'.gp15-row:nth-child(even) {',
'    background: #f8f9fb;',
'}',
'',
'.gp15-label {',
'    font-weight: 600;',
'    width: 38%;',
'    padding-right: 12px;',
'    color: #2c3e50;',
'    font-size: 9pt;',
'    flex-shrink: 0;',
'}',
'',
'.gp15-value {',
'    width: 62%;',
'    color: #1a1a1a;',
'    font-size: 9pt;',
'    word-wrap: break-word;',
'}',
'',
'/* TABLES - Professional grid design */',
'.gp15-table {',
'    width: 100%;',
'    border-collapse: collapse;',
'    margin: 0;',
'    font-size: 8.5pt;',
'    background: white;',
'}',
'',
'.gp15-table th {',
'    background: linear-gradient(to bottom, #2c3e50 0%, #1a2836 100%);',
'    color: white;',
'    padding: 7px 6px;',
'    font-weight: 600;',
'    text-align: left;',
'    font-size: 8.5pt;',
'    text-transform: uppercase;',
'    letter-spacing: 0.3px;',
'    border: 1px solid #1a2836;',
'}',
'',
'.gp15-table td {',
'    border: 1px solid #c8d1db;',
'    padding: 6px 6px;',
'    color: #1a1a1a;',
'    vertical-align: middle;',
'}',
'',
'.gp15-table tr:nth-child(even) {',
'    background: #f8f9fb;',
'}',
'',
'.gp15-table td strong {',
'    color: #1a3a5c;',
'    font-weight: 600;',
'}',
'',
'/* Compact table for appliance details */',
'.gp15-table.compact th,',
'.gp15-table.compact td {',
'    padding: 5px 4px;',
'    font-size: 8pt;',
'}',
'',
'/* SUBSECTION HEADERS */',
'h4 {',
'    color: #1a3a5c;',
'    font-size: 9.5pt;',
'    font-weight: 600;',
'    margin: 12px 16px 8px 16px;',
'    padding-bottom: 4px;',
'    border-bottom: 2px solid #3498db;',
'    text-transform: uppercase;',
'    letter-spacing: 0.3px;',
'}',
'',
'/* SIGNATURE BOXES - Clear professional display */',
'.signature-box {',
'    border: 2px solid #b0bcc9;',
'    min-height: 65px;',
'    height: 65px;',
'    padding: 8px;',
'    margin-top: 6px;',
'    background: #fafbfc;',
'    border-radius: 3px;',
'    display: flex;',
'    align-items: center;',
'    justify-content: center;',
'    overflow: hidden;',
'}',
'',
'.signature-image {',
'    max-width: 100%;',
'    max-height: 55px;',
'    display: block;',
'    object-fit: contain;',
'}',
'',
'.signature-box p {',
'    margin: 0;',
'    color: #7f8c9a;',
'    font-style: italic;',
'    font-size: 8.5pt;',
'    text-align: center;',
'}',
'',
'/* SIGNATURE SECTION - Two column grid */',
'.signature-grid {',
'    display: grid;',
'    grid-template-columns: 1fr 1fr;',
'    gap: 16px;',
'    padding: 12px 16px;',
'}',
'',
'.signature-block {',
'    border: 1px solid #dce3ea;',
'    padding: 10px;',
'    background: white;',
'    border-radius: 3px;',
'}',
'',
'.signature-block strong {',
'    display: block;',
'    margin-bottom: 6px;',
'    color: #1a3a5c;',
'    font-size: 9.5pt;',
'}',
'',
'.signature-details {',
'    margin-top: 6px;',
'    font-size: 8.5pt;',
'    line-height: 1.5;',
'    color: #2c3e50;',
'}',
'',
'.signature-details strong {',
'    display: inline;',
'    font-size: 8.5pt;',
'    font-weight: 600;',
'}',
'',
'/* DECLARATION BOX - Prominent notice */',
'.declaration-box {',
'    background: linear-gradient(135deg, #fff9e6 0%, #fff3cc 100%);',
'    border: 2px solid #f5c563;',
'    border-left: 4px solid #e6a023;',
'    padding: 14px 16px;',
'    margin: 12px 16px;',
'    font-weight: 500;',
'    border-radius: 3px;',
'    box-shadow: 0 2px 4px rgba(230, 160, 35, 0.15);',
'}',
'',
'.declaration-box strong {',
'    display: block;',
'    font-size: 10pt;',
'    color: #7d5d1f;',
'    margin-bottom: 8px;',
'    text-transform: uppercase;',
'    letter-spacing: 0.4px;',
'}',
'',
'.declaration-box p {',
'    color: #7d5d1f;',
'    margin: 0;',
'    line-height: 1.5;',
'    font-size: 9pt;',
'}',
'',
'/* GRID LAYOUTS - Compact spacing */',
'.gp15-grid-2 {',
'    display: grid;',
'    grid-template-columns: 1fr 1fr;',
'    gap: 10px;',
'    padding: 10px 16px;',
'}',
'',
'.gp15-grid-3 {',
'    display: grid;',
'    grid-template-columns: 1fr 1fr 1fr;',
'    gap: 10px;',
'    padding: 10px 16px;',
'}',
'',
'/* FOOTER - Minimal professional */',
'.gp15-footer {',
'    text-align: center;',
'    margin-top: 0;',
'    padding: 12px 16px;',
'    background: #f0f3f6;',
'    border-top: 2px solid #b0bcc9;',
'    font-size: 7.5pt;',
'    color: #6c757d;',
'    line-height: 1.4;',
'}',
'',
'.gp15-footer strong {',
'    color: #495057;',
'    font-weight: 600;',
'}',
'',
'/* STATUS BADGES */',
'.status-badge {',
'    display: inline-block;',
'    padding: 3px 10px;',
'    border-radius: 10px;',
'    font-size: 8pt;',
'    font-weight: 600;',
'    text-transform: uppercase;',
'    letter-spacing: 0.2px;',
'}',
'',
'.status-yes {',
'    background: #d4edda;',
'    color: #155724;',
'    border: 1px solid #c3e6cb;',
'}',
'',
'.status-no {',
'    background: #f8d7da;',
'    color: #721c24;',
'    border: 1px solid #f5c6cb;',
'}',
'',
'.status-na {',
'    background: #e2e3e5;',
'    color: #383d41;',
'    border: 1px solid #d6d8db;',
'}',
'',
'/* INFO BOXES - Visual emphasis */',
'.info-box {',
'    background: #e7f3ff;',
'    border: 1px solid #90c9f9;',
'    border-left: 3px solid #2196F3;',
'    padding: 10px 14px;',
'    margin: 10px 16px;',
'    border-radius: 2px;',
'    font-size: 9pt;',
'}',
'',
'.warning-box {',
'    background: #fff9e6;',
'    border: 1px solid #f5d68f;',
'    border-left: 3px solid #ffc107;',
'    padding: 10px 14px;',
'    margin: 10px 16px;',
'    border-radius: 2px;',
'    font-size: 9pt;',
'}',
'',
'.danger-box {',
'    background: #ffe8ea;',
'    border: 1px solid #f5b7bd;',
'    border-left: 3px solid #dc3545;',
'    padding: 10px 14px;',
'    margin: 10px 16px;',
'    border-radius: 2px;',
'    font-size: 9pt;',
'}',
'',
'/* TEXT CONTENT AREAS */',
'.text-content {',
'    padding: 10px 16px;',
'    line-height: 1.5;',
'    font-size: 9pt;',
'}',
'',
'.text-content strong {',
'    color: #1a3a5c;',
'    display: block;',
'    margin-bottom: 4px;',
'}',
'',
'/* COMPACT SECTION PADDING */',
'.gp15-section .gp15-table {',
'    margin: 0;',
'}',
'',
'.gp15-section > .gp15-table:first-child {',
'    border-top: none;',
'}',
'',
'/* APPLIANCE SUBSECTIONS */',
'.appliance-subsection {',
'    margin: 0;',
'    border-top: 1px solid #e8ecf1;',
'}',
'',
'.appliance-subsection:first-child {',
'    border-top: none;',
'}',
'',
'/* GAS SAFE LOGO AREA */',
'.gas-safe-logo {',
'    text-align: right;',
'    font-weight: 700;',
'    color: #c0392b;',
'    font-size: 10pt;',
'    letter-spacing: 0.3px;',
'}',
'',
'/* RESPONSIVE ADJUSTMENTS */',
'@media screen and (max-width: 768px) {',
'    .gp15-report-container {',
'        max-width: 100%;',
'        box-shadow: none;',
'    }',
'    ',
'    .gp15-grid-2,',
'    .gp15-grid-3,',
'    .signature-grid {',
'        grid-template-columns: 1fr;',
'    }',
'    ',
'    .gp15-header {',
'        padding: 15px;',
'    }',
'    ',
'    .gp15-table {',
'        font-size: 7.5pt;',
'    }',
'}',
'',
'/* UTILITY CLASSES */',
'.mb-0 { margin-bottom: 0 !important; }',
'.mt-0 { margin-top: 0 !important; }',
'.no-border-top { border-top: none !important; }',
'.no-border-bottom { border-bottom: none !important; }',
'',
'/* PRINT OPTIMIZATION */',
'@media print {',
'    .gp15-report-container {',
'        box-shadow: none;',
'    }',
'    ',
'    .gp15-section {',
'        page-break-inside: avoid;',
'    }',
'    ',
'    .signature-grid {',
'        page-break-inside: avoid;',
'    }',
'}',
'',
'.ptw-history-binary .t-Form-inputContainer {',
'    display: flex;',
'    justify-content: flex-start;',
'}',
'',
'.ptw-history-binary .binary-badge-row {',
'    margin-top: 6px;',
'    margin-left: 0;',
'}',
''))
,p_step_template=>2979075366320325194
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'25'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(67013347421929736)
,p_plug_name=>'Print Buttons'
,p_region_name=>'print-button-region'
,p_region_css_classes=>'no-print'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>40
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(67013758101929740)
,p_plug_name=>'PTW Report Content'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>50
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    RETURN ptw_pro.generate_ptw_lv_pdf(',
'        p_permit_id       => :P300_PERMIT_ID,',
'        p_include_history => NVL(:P300_INCLUDE_HISTORY, ''N'')',
'    );',
'END;'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_ajax_items_to_submit=>'P300_PERMIT_ID,P300_INCLUDE_HISTORY'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(42026152934651854)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(67013347421929736)
,p_button_name=>'BACK'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Back'
,p_button_redirect_url=>'f?p=&APP_ID.:&P300_RETURN_PAGE.:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-arrow-left'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(42025765972651856)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(67013347421929736)
,p_button_name=>'PRINT_PDF'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Print/Save as PDF'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-print'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(49364719163381908)
,p_name=>'P300_RETURN_PAGE'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(50565118794122734)
,p_name=>'P300_INCLUDE_HISTORY'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(67013347421929736)
,p_item_default=>'N'
,p_prompt=>'Include Permit History?'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Yes;Y,No;N'
,p_display_when=>'P300_RETURN_PAGE'
,p_display_when2=>'50'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>2318601014859922299
,p_item_css_classes=>'cm-binary-item ptw-history-binary no-print'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(67015084508929672)
,p_name=>'P300_PERMIT_ID'
,p_item_sequence=>10
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(42027343623651821)
,p_name=>'New'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(42025765972651856)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(42027840526651816)
,p_event_id=>wwv_flow_imp.id(42027343623651821)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'window.print()'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(50565230556122735)
,p_name=>'Refresh Report on History Toggle'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P300_INCLUDE_HISTORY'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(50565381299122736)
,p_event_id=>wwv_flow_imp.id(50565230556122735)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(67013758101929740)
,p_attribute_01=>'N'
);
wwv_flow_imp.component_end;
end;
/
