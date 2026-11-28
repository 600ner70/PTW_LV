prompt --application/pages/page_00018
begin
--   Manifest
--     PAGE: 00018
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
 p_id=>18
,p_name=>'Fire Watch'
,p_alias=>'FIRE-WATCH'
,p_page_mode=>'MODAL'
,p_step_title=>'Fire Watch'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var p18SigPad = null;',
'',
'function p18InitSig() {',
'    var canvas = document.getElementById(''p18SigCanvas'');',
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
'    p18SigPad = new SignaturePad(canvas, ctx);',
'}',
'',
'function p18ClearSig() {',
'    if (p18SigPad) { p18SigPad.clear(); }',
'}',
'',
'function p18SaveSig() {',
'    if (!p18SigPad || p18SigPad.isEmpty) {',
'        apex.item(''P18_SIGNATURE_DATA'').setValue('''');',
'    } else {',
'        apex.item(''P18_SIGNATURE_DATA'').setValue(p18SigPad.getDataURL());',
'    }',
'}',
'',
'apex.jQuery(document).on(''apexbeforepagesubmit'', function () {',
'    p18SaveSig();',
'});',
'',
'var p18ResizeTimer = null;',
'window.addEventListener(''resize'', function () {',
'    if (p18ResizeTimer) { clearTimeout(p18ResizeTimer); }',
'    p18ResizeTimer = setTimeout(function () {',
'        var hadContent = p18SigPad && !p18SigPad.isEmpty;',
'        var existingData = hadContent ? p18SigPad.getDataURL() : null;',
'        p18InitSig();',
'        if (existingData) {',
'            loadSignature(p18SigPad, document.getElementById(''p18SigCanvas''), existingData);',
'        }',
'    }, 200);',
'});',
''))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'@media (max-width: 768px) {',
'    .ui-dialog {',
'        width: 96vw !important;',
'        max-width: 96vw !important;',
'        height: 92vh !important;',
'        max-height: 92vh !important;',
'        top: 4vh !important;',
'        left: 2vw !important;',
'        margin: 0 !important;',
'    }',
'    .ui-dialog-content {',
'        max-height: calc(92vh - 110px) !important;',
'        overflow-y: auto !important;',
'        -webkit-overflow-scrolling: touch;',
'    }',
'}'))
,p_step_template=>2100407606326202693
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'23'
,p_created_on=>wwv_flow_imp.dz('20260913161323Z')
,p_last_updated_on=>wwv_flow_imp.dz('20260914202619Z')
,p_created_by=>'PTW_PRO'
,p_last_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(42195387780924506)
,p_plug_name=>'All Complete'
,p_static_id=>'all-complete'
,p_title=>'All Complete'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>140
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>'All fire watch checks complete'
,p_plug_display_condition_type=>'ITEM_IS_NULL'
,p_plug_display_when_condition=>'P18_MILESTONE_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260913182946Z')
,p_updated_on=>wwv_flow_imp.dz('20260914201614Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(42195615155924509)
,p_plug_name=>'Buttons'
,p_static_id=>'buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>150
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260913182946Z')
,p_updated_on=>wwv_flow_imp.dz('20260914201614Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(42195126333924504)
,p_plug_name=>'Current Check'
,p_static_id=>'current-check'
,p_title=>'Current Check'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>130
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_display_condition_type=>'EXPRESSION'
,p_plug_display_when_condition=>':P18_MILESTONE_CODE IS NOT NULL AND :P18_WORKFLOW_STATUS = ''STARTED'''
,p_plug_display_when_cond2=>'PLSQL'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260913174455Z')
,p_updated_on=>wwv_flow_imp.dz('20260914201614Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(42194928701924502)
,p_plug_name=>'History'
,p_static_id=>'history'
,p_title=>'History'
,p_region_template_options=>'#DEFAULT#:t-CardsRegion--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2072724515482255512
,p_plug_display_sequence=>120
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT m.seq, m.label,',
'       CASE',
'           WHEN fw.milestone_code IS NOT NULL THEN',
'               ''<span style="display:inline-flex;align-items:center;gap:8px;">''',
'               || ''<span style="display:inline-flex;align-items:center;justify-content:center;''',
'               || ''width:22px;height:22px;border-radius:50%;background:#28a745;color:#fff;''',
'               || ''font-size:13px;flex-shrink:0;">&#10003;</span>''',
'               || ''<span style="font-weight:600;">'' || m.label || ''</span></span>''',
'           ELSE',
'               ''<span style="display:inline-flex;align-items:center;gap:8px;">''',
'               || ''<span style="display:inline-flex;align-items:center;justify-content:center;''',
'               || ''width:22px;height:22px;border-radius:50%;background:#e9ecef;color:#6c757d;''',
'               || ''font-size:12px;font-weight:700;flex-shrink:0;">'' || m.seq || ''</span>''',
'               || ''<span style="color:#6c757d;">'' || m.label || ''</span></span>''',
'       END AS title_html,',
'       CASE',
'           WHEN fw.milestone_code IS NOT NULL THEN',
'               ''<div style="display:flex;gap:12px;align-items:center;''',
'               || ''border-left:3px solid #28a745;padding:4px 0 4px 10px;">''',
'               || ''<img src="data:image/png;base64,''',
'               || APEX_WEB_SERVICE.BLOB2CLOBBASE64(fw.signature_blob)',
'               || ''" style="height:48px;max-width:130px;border:1px solid #dee2e6;''',
'               || ''border-radius:6px;background:#fff;padding:2px;flex-shrink:0;" alt="Signature" />''',
'               || ''<div style="font-size:12.5px;line-height:1.4;">''',
'               || ''<div style="font-weight:600;color:#343a40;">'' || APEX_ESCAPE.HTML(fw.signed_by) || ''</div>''',
'               || ''<div style="color:#868e96;">'' || TO_CHAR(fw.signed_datetime, ''DD Mon YYYY HH24:MI'') || ''</div>''',
'               || ''</div></div>''',
'           ELSE',
'               TO_CLOB(',
'               ''<div style="border-left:3px dashed #dee2e6;padding:8px 0 8px 10px;''',
'               || ''color:#adb5bd;font-style:italic;font-size:12.5px;">Awaiting sign-off</div>'')',
'       END AS body_html',
'FROM   (SELECT 1 seq, ''HW_COMPLETE'' code, ''Hot Works Completed'' label FROM dual UNION ALL',
unistr('        SELECT 2, ''ATTEND_1ST_HR'', ''100% Attendance \2014 First Hour'' FROM dual UNION ALL'),
unistr('        SELECT 3, ''CHECK_15MIN_2ND_HR'', ''Checked Every 15 Min \2014 Second Hour'' FROM dual UNION ALL'),
unistr('        SELECT 4, ''CHECK_30MIN_3RD_HR'', ''Checked Every 30 Min \2014 Third Hour'' FROM dual UNION ALL'),
unistr('        SELECT 5, ''REINSTATE_4TH_HR'', ''Reinstate Fire Isolation \2014 Fourth Hour'' FROM dual UNION ALL'),
'        SELECT 6, ''FIRE_CHECKS_COMPLETE'', ''Completion of Fire Checks'' FROM dual) m',
'LEFT JOIN ptw_pro.ptw_hotwork_fire_watch fw',
'       ON fw.permit_id = :P18_PERMIT_ID AND fw.milestone_code = m.code',
'ORDER BY m.seq'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_ajax_items_to_submit=>'P18_PERMIT_ID'
,p_plug_query_num_rows_type=>'SCROLL'
,p_show_total_row_count=>false
,p_created_on=>wwv_flow_imp.dz('20260913174455Z')
,p_updated_on=>wwv_flow_imp.dz('20260914201614Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_card(
 p_id=>wwv_flow_imp.id(42195038625924503)
,p_region_id=>wwv_flow_imp.id(42194928701924502)
,p_layout_type=>'GRID'
,p_title_adv_formatting=>true
,p_title_html_expr=>'&TITLE_HTML!RAW.'
,p_sub_title_adv_formatting=>false
,p_body_adv_formatting=>true
,p_body_html_expr=>'&BODY_HTML!RAW.'
,p_second_body_adv_formatting=>false
,p_media_adv_formatting=>false
,p_updated_on=>wwv_flow_imp.dz('20260913184627Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(42196744031924520)
,p_plug_name=>'Page Title'
,p_static_id=>'page-title'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>110
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'    <div style="margin-bottom: 20px;">',
'        <span class="apex-badge" style="background-color: #3ea055; color: white; padding: 6px 16px; border-radius: 20px; font-weight: 600;">',
'            Permit: &P18_PERMIT_NUMBER.',
'        </span>',
'    </div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260914201614Z')
,p_updated_on=>wwv_flow_imp.dz('20260914201738Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(42196289010924515)
,p_plug_name=>'Signature'
,p_static_id=>'signature'
,p_title=>'Signature'
,p_parent_plug_id=>wwv_flow_imp.id(42195126333924504)
,p_icon_css_classes=>'fa-pencil-square-o'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="p18-sig-wrapper">',
'  <label class="t-Form-label" style="display:block;margin-bottom:6px;">',
'    Signing: &P18_MILESTONE_LABEL. <span style="color:#C0392B;" aria-hidden="true">*</span>',
'  </label>',
'  <canvas id="p18SigCanvas"></canvas>',
'  <button type="button" class="t-Button t-Button--small t-Button--simple"',
'          id="p18ClearSigBtn" style="margin-top:6px;" onclick="p18ClearSig()">',
'    <span class="fa fa-eraser" aria-hidden="true"></span> Clear Signature',
'  </button>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260913185304Z')
,p_updated_on=>wwv_flow_imp.dz('20260913185835Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(42196486936924517)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(42195615155924509)
,p_button_name=>'CANCEL'
,p_static_id=>'cancel'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:1::'
,p_warn_on_unsaved_changes=>null
,p_created_on=>wwv_flow_imp.dz('20260913185835Z')
,p_updated_on=>wwv_flow_imp.dz('20260913185835Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(42195725549924510)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(42195615155924509)
,p_button_name=>'SIGN_MILESTONE'
,p_static_id=>'sign-milestone'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Sign Milestone'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>':P18_MILESTONE_CODE IS NOT NULL AND :P18_WORKFLOW_STATUS = ''STARTED'''
,p_button_condition2=>'PLSQL'
,p_button_condition_type=>'EXPRESSION'
,p_created_on=>wwv_flow_imp.dz('20260913182946Z')
,p_updated_on=>wwv_flow_imp.dz('20260914195549Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24593149418992947)
,p_name=>'P18_MILESTONE_CODE'
,p_item_sequence=>60
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260913174455Z')
,p_updated_on=>wwv_flow_imp.dz('20260913174455Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24593239595992948)
,p_name=>'P18_MILESTONE_LABEL'
,p_item_sequence=>70
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260913174455Z')
,p_updated_on=>wwv_flow_imp.dz('20260913174455Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(42195208119924505)
,p_name=>'P18_MILESTONE_PERSON_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(42195126333924504)
,p_prompt=>'Fire check by'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260913182946Z')
,p_updated_on=>wwv_flow_imp.dz('20260913185442Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24592453787992940)
,p_name=>'P18_PERMIT_ID'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260913161954Z')
,p_updated_on=>wwv_flow_imp.dz('20260913161954Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24592666349992942)
,p_name=>'P18_PERMIT_NUMBER'
,p_item_sequence=>50
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260913161954Z')
,p_updated_on=>wwv_flow_imp.dz('20260913161954Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24592575331992941)
,p_name=>'P18_PTW_TYPE'
,p_item_sequence=>40
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260913161954Z')
,p_updated_on=>wwv_flow_imp.dz('20260913163118Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(24593393571992949)
,p_name=>'P18_SIGNATURE_DATA'
,p_item_sequence=>80
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260913174455Z')
,p_updated_on=>wwv_flow_imp.dz('20260913174455Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(42196676363924519)
,p_name=>'P18_WORKFLOW_STATUS'
,p_item_sequence=>100
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260914195549Z')
,p_updated_on=>wwv_flow_imp.dz('20260914195549Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(42196377938924516)
,p_validation_name=>'Name required'
,p_static_id=>'name-required'
,p_validation_sequence=>10
,p_validation=>'P18_MILESTONE_PERSON_NAME'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Person''s name doing fire check must be entered.',
''))
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260913185548Z')
,p_updated_on=>wwv_flow_imp.dz('20260913185548Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(42195476234924507)
,p_name=>'Load signatures'
,p_static_id=>'load-signatures'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
,p_created_on=>wwv_flow_imp.dz('20260913182947Z')
,p_updated_on=>wwv_flow_imp.dz('20260914202311Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(42195540401924508)
,p_event_id=>wwv_flow_imp.id(42195476234924507)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'setTimeout(function () {',
    '    p18InitSig();',
    '}, 350);')))).to_clob
,p_created_on=>wwv_flow_imp.dz('20260913182947Z')
,p_updated_on=>wwv_flow_imp.dz('20260914202311Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(42195800057924511)
,p_name=>'Sign Milestone - Capture Location and Submit'
,p_static_id=>'sign-milestone-capture-location-and-submit'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(42195725549924510)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_created_on=>wwv_flow_imp.dz('20260913182947Z')
,p_updated_on=>wwv_flow_imp.dz('20260913182947Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(42195942479924512)
,p_event_id=>wwv_flow_imp.id(42195800057924511)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'captureLocationThenSubmit(''SIGN_MILESTONE'');')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260913182947Z')
,p_updated_on=>wwv_flow_imp.dz('20260913182947Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(42194849397924501)
,p_process_sequence=>10
,p_process_point=>'BEFORE_BOX_BODY'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load process'
,p_static_id=>'load-process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    CURSOR c_milestones IS',
'        SELECT 1 seq, ''HW_COMPLETE'' code, ''Hot Works Completed'' label FROM dual UNION ALL',
unistr('        SELECT 2, ''ATTEND_1ST_HR'', ''100% Attendance \2014 First Hour'' FROM dual UNION ALL'),
unistr('        SELECT 3, ''CHECK_15MIN_2ND_HR'', ''Checked Every 15 Min \2014 Second Hour'' FROM dual UNION ALL'),
unistr('        SELECT 4, ''CHECK_30MIN_3RD_HR'', ''Checked Every 30 Min \2014 Third Hour'' FROM dual UNION ALL'),
unistr('        SELECT 5, ''REINSTATE_4TH_HR'', ''Reinstate Fire Isolation \2014 Fourth Hour'' FROM dual UNION ALL'),
'        SELECT 6, ''FIRE_CHECKS_COMPLETE'', ''Completion of Fire Checks'' FROM dual;',
'    l_count PLS_INTEGER;',
'BEGIN',
'',
'    :P18_MILESTONE_CODE  := NULL;',
'    :P18_MILESTONE_LABEL := NULL;',
'',
'    FOR m IN c_milestones LOOP',
'        SELECT COUNT(*) INTO l_count',
'        FROM   ptw_pro.ptw_hotwork_fire_watch',
'        WHERE  permit_id = :P18_PERMIT_ID AND milestone_code = m.code;',
'',
'        IF l_count = 0 THEN',
'            :P18_MILESTONE_CODE  := m.code;',
'            :P18_MILESTONE_LABEL := m.label;',
'            EXIT;',
'        END IF;',
'    END LOOP;',
unistr('    -- Both stay NULL if all six are already signed \2014 the "current check"'),
'    -- region''s server-side condition hides itself in that case.',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>42194849397924501
,p_created_on=>wwv_flow_imp.dz('20260913174455Z')
,p_updated_on=>wwv_flow_imp.dz('20260914201830Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(42196065422924513)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Sign'
,p_static_id=>'sign'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_company_id ptw_pro.ptw_lv_permits.company_id%TYPE;',
'    l_this_idx   PLS_INTEGER;',
'    l_prev_code  VARCHAR2(30);',
'    l_prev_count NUMBER := 0;',
'    l_sig_blob   BLOB;',
'    l_clob       CLOB;',
'BEGIN',
'    SELECT company_id INTO l_company_id',
'    FROM   ptw_pro.ptw_lv_permits WHERE permit_id = :P18_PERMIT_ID;',
'',
'    l_this_idx := CASE :P18_MILESTONE_CODE',
'        WHEN ''HW_COMPLETE''          THEN 1',
'        WHEN ''ATTEND_1ST_HR''        THEN 2',
'        WHEN ''CHECK_15MIN_2ND_HR''   THEN 3',
'        WHEN ''CHECK_30MIN_3RD_HR''   THEN 4',
'        WHEN ''REINSTATE_4TH_HR''     THEN 5',
'        WHEN ''FIRE_CHECKS_COMPLETE'' THEN 6',
'    END;',
'',
'    l_prev_code := CASE :P18_MILESTONE_CODE',
'        WHEN ''ATTEND_1ST_HR''        THEN ''HW_COMPLETE''',
'        WHEN ''CHECK_15MIN_2ND_HR''   THEN ''ATTEND_1ST_HR''',
'        WHEN ''CHECK_30MIN_3RD_HR''   THEN ''CHECK_15MIN_2ND_HR''',
'        WHEN ''REINSTATE_4TH_HR''     THEN ''CHECK_30MIN_3RD_HR''',
'        WHEN ''FIRE_CHECKS_COMPLETE'' THEN ''REINSTATE_4TH_HR''',
unistr('        -- HW_COMPLETE has no predecessor \2014 stays NULL, so the check below is skipped'),
'    END;',
'',
'    IF l_prev_code IS NOT NULL THEN',
'        SELECT COUNT(*) INTO l_prev_count',
'        FROM   ptw_pro.ptw_hotwork_fire_watch',
'        WHERE  permit_id = :P18_PERMIT_ID AND milestone_code = l_prev_code;',
'    END IF;',
'',
'    IF l_prev_code IS NOT NULL AND l_prev_count = 0 THEN',
'        apex_error.add_error(',
'            p_message => ''The previous fire watch check must be signed first.'',',
'            p_display_location => apex_error.c_inline_in_notification);',
'        RAISE_APPLICATION_ERROR(-20064, ''Fire watch milestones must be signed in order.'');',
'    END IF;',
'',
'    IF :P18_SIGNATURE_DATA IS NOT NULL AND :P18_MILESTONE_PERSON_NAME IS NOT NULL THEN',
'        l_clob     := REPLACE(:P18_SIGNATURE_DATA, ''data:image/png;base64,'', '''');',
'        l_sig_blob := apex_web_service.clobbase642blob(l_clob);',
'    ELSE',
'        apex_error.add_error(',
'            p_message => ''A name and signature are both required.'',',
'            p_display_location => apex_error.c_inline_in_notification);',
'        RAISE_APPLICATION_ERROR(-20066, ''Name and signature are required to sign a fire watch check.'');',
'    END IF;',
'',
'    BEGIN',
'        INSERT INTO ptw_pro.ptw_hotwork_fire_watch (',
'            permit_id, milestone_code, milestone_seq, signed_by,',
'            signed_datetime, signature_blob, latitude, longitude, company_id',
'        ) VALUES (',
'            :P18_PERMIT_ID, :P18_MILESTONE_CODE, l_this_idx,',
'            UPPER(TRIM(:P18_MILESTONE_PERSON_NAME)),',
'            SYSDATE, l_sig_blob, TO_NUMBER(:APP_LATITUDE), TO_NUMBER(:APP_LONGITUDE), l_company_id',
'        );',
'    EXCEPTION',
'        WHEN DUP_VAL_ON_INDEX THEN',
'            RAISE_APPLICATION_ERROR(-20065, ''This fire watch check has already been signed.'');',
'    END;',
'',
'    -- Every milestone also drops its own entry into the general permit',
unistr('    -- history table \2014 PTW_STAGE_LOCATIONS records where key lifecycle'),
'    -- events happened, and each fire watch check is one of those, not',
'    -- just the final sign-off.',
'    INSERT INTO ptw_pro.ptw_stage_locations (',
'        permit_id, permit_stage, latitude, longitude, created_date, created_by, company_id',
'    ) VALUES (',
'        :P18_PERMIT_ID, ''FIREWATCH_'' || :P18_MILESTONE_CODE,',
'        TO_NUMBER(:APP_LATITUDE), TO_NUMBER(:APP_LONGITUDE),',
'        SYSDATE, NVL(V(''APP_USER''), USER), l_company_id',
'    );',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(42195725549924510)
,p_internal_uid=>42196065422924513
,p_created_on=>wwv_flow_imp.dz('20260913182947Z')
,p_updated_on=>wwv_flow_imp.dz('20260913182947Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(24592918276992945)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SIGN_ACTION'
,p_static_id=>'sign-action'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_company_id ptw_pro.ptw_lv_permits.company_id%TYPE;',
'    l_this_idx   PLS_INTEGER;',
'    l_prev_code  VARCHAR2(30);',
'    l_prev_ok    VARCHAR2(1) := ''Y'';',
'BEGIN',
'    SELECT company_id INTO l_company_id',
'    FROM   ptw_pro.ptw_lv_permits WHERE permit_id = :PNN_PERMIT_ID;',
'',
'    l_this_idx := CASE :PNN_MILESTONE_CODE',
'        WHEN ''HW_COMPLETE''          THEN 1',
'        WHEN ''ATTEND_1ST_HR''        THEN 2',
'        WHEN ''CHECK_15MIN_2ND_HR''   THEN 3',
'        WHEN ''CHECK_30MIN_3RD_HR''   THEN 4',
'        WHEN ''REINSTATE_4TH_HR''     THEN 5',
'        WHEN ''FIRE_CHECKS_COMPLETE'' THEN 6',
'    END;',
'',
'    l_prev_code := CASE :PNN_MILESTONE_CODE',
'        WHEN ''ATTEND_1ST_HR''        THEN ''HW_COMPLETE''',
'        WHEN ''CHECK_15MIN_2ND_HR''   THEN ''ATTEND_1ST_HR''',
'        WHEN ''CHECK_30MIN_3RD_HR''   THEN ''CHECK_15MIN_2ND_HR''',
'        WHEN ''REINSTATE_4TH_HR''     THEN ''CHECK_30MIN_3RD_HR''',
'        WHEN ''FIRE_CHECKS_COMPLETE'' THEN ''REINSTATE_4TH_HR''',
unistr('        -- HW_COMPLETE has no predecessor \2014 stays NULL, so the check below is skipped'),
'    END;',
'',
'    IF l_prev_code IS NOT NULL THEN',
'        SELECT NVL(MAX(''Y''), ''N'') INTO l_prev_ok',
'        FROM   ptw_pro.ptw_hotwork_fire_watch',
'        WHERE  permit_id = :PNN_PERMIT_ID',
'        AND    milestone_code = l_prev_code;',
'    END IF;',
'',
'    IF l_prev_ok != ''Y'' THEN',
'        apex_error.add_error(',
'            p_message => ''The previous fire watch check must be signed first.'',',
'            p_display_location => apex_error.c_inline_in_notification);',
'        RAISE_APPLICATION_ERROR(-20064, ''Fire watch milestones must be signed in order.'');',
'    END IF;',
'',
'    BEGIN',
'        INSERT INTO ptw_pro.ptw_hotwork_fire_watch (',
'            permit_id, milestone_code, milestone_seq, signed_by,',
'            signed_datetime, latitude, longitude, company_id',
'        ) VALUES (',
'            :PNN_PERMIT_ID, :PNN_MILESTONE_CODE, l_this_idx, NVL(V(''APP_USER''), USER),',
'            SYSDATE, :APP_LATITUDE, :APP_LONGITUDE, l_company_id',
'        );',
'    EXCEPTION',
'        WHEN DUP_VAL_ON_INDEX THEN',
'            RAISE_APPLICATION_ERROR(-20065, ''This fire watch check has already been signed.'');',
'    END;',
'',
'    -- Every milestone also drops its own entry into the general permit',
unistr('    -- history table \2014 PTW_STAGE_LOCATIONS records where key lifecycle'),
'    -- events happened, and each fire watch check is one of those, not',
'    -- just the final sign-off.',
'    INSERT INTO ptw_pro.ptw_stage_locations (',
'        permit_id, permit_stage, latitude, longitude, created_date, created_by, company_id',
'    ) VALUES (',
'        :PNN_PERMIT_ID, ''FIREWATCH_'' || :PNN_MILESTONE_CODE, :APP_LATITUDE, :APP_LONGITUDE,',
'        SYSDATE, NVL(V(''APP_USER''), USER), l_company_id',
'    );',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>24592918276992945
,p_created_on=>wwv_flow_imp.dz('20260913161954Z')
,p_updated_on=>wwv_flow_imp.dz('20260913161954Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
