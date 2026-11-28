prompt --application/pages/page_00005
begin
--   Manifest
--     PAGE: 00005
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
 p_id=>5
,p_name=>'Authorisation & Acceptance'
,p_alias=>'AUTHORISATION-ACCEPTANCE'
,p_step_title=>'Authorisation & Acceptance'
,p_autocomplete_on_off=>'OFF'
,p_javascript_file_urls=>'#APP_FILES#offline-storage#MIN#.js'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'let authSignaturePad;',
'let acceptSignaturePad;',
'',
'function initSignaturePads() {',
'    setTimeout(function() {',
'        initPad(''authSignaturePad'',   ''P5_AUTH_SIGNATURE_DATA'',   function(pad) { authSignaturePad   = pad; });',
'        initPad(''acceptSignaturePad'', ''P5_ACCEPT_SIGNATURE_DATA'', function(pad) { acceptSignaturePad = pad; });',
'    }, 200);',
'}',
'',
'function clearAuthSignature() {',
'    if (authSignaturePad) {',
'        authSignaturePad.clear();',
'        apex.item(''P5_AUTH_SIGNATURE_DATA'').setValue('''');',
'    }',
'}',
'',
'function clearAcceptSignature() {',
'    if (acceptSignaturePad) {',
'        acceptSignaturePad.clear();',
'        apex.item(''P5_ACCEPT_SIGNATURE_DATA'').setValue('''');',
'    }',
'}',
'',
'function saveSignatures() {',
'    if (authSignaturePad   && !authSignaturePad.isEmpty)   { apex.item(''P5_AUTH_SIGNATURE_DATA'').setValue(authSignaturePad.getDataURL()); }',
'    if (acceptSignaturePad && !acceptSignaturePad.isEmpty) { apex.item(''P5_ACCEPT_SIGNATURE_DATA'').setValue(acceptSignaturePad.getDataURL()); }',
'}',
'',
'function updateConnectionUI() {',
'    const statusDiv  = document.getElementById(''connection-status'');',
'    const statusIcon = document.getElementById(''status-icon'');',
'    const statusText = document.getElementById(''status-text'');',
'    if (!statusDiv) return;',
'    if (navigator.onLine) {',
'        statusDiv.style.backgroundColor = ''#d4edda'';',
'        statusIcon.innerHTML = ''\u2713'';',
'        statusText.innerHTML = ''Connected'';',
'    } else {',
'        statusDiv.style.backgroundColor = ''#fff3cd'';',
'        statusIcon.innerHTML = ''\u26A0'';',
'        statusText.innerHTML = ''Offline Mode'';',
'    }',
'}',
''))
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'$(document).on(''dialogclose'', function(e) {',
'    console.log(''dialogclose fired'', e);',
'});',
'',
'$(document).on(''apexafterclosedialog'', function(e, data) {',
'    console.log(''apexafterclosedialog fired'', data);',
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
' ',
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
' ',
'.workflow-step {',
'    display: flex;',
'    flex-direction: column;',
'    align-items: center;',
'    position: relative;',
'    z-index: 1;',
'    flex: 1;',
'    gap: 0.5rem;',
'}',
' ',
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
' ',
'.workflow-step.active .step-icon {',
'    background: #003366;',
'    border-color: #003366;',
'    color: #ffffff;',
'    box-shadow: 0 4px 8px rgba(0, 51, 102, 0.2);',
'}',
' ',
'.workflow-step.completed .step-icon {',
'    background: var(--ut-palette-success, #3ea055);',
'    border-color: var(--ut-palette-success, #3ea055);',
'    color: #ffffff;',
'}',
' ',
'.step-text {',
'    font-size: 0.875rem;',
'    text-align: center;',
'    color: var(--ut-palette-neutral-600, #595959);',
'    max-width: 100px;',
'    line-height: 1.3;',
'}',
' ',
'.workflow-step.active .step-text {',
'    color: #003366;',
'    font-weight: 600;',
'}',
' ',
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
' ',
'/* ---- Page-5-specific additions only ---- */',
' ',
'/* Declaration box - uses APEX vars, no hard-coded colours */',
'.declaration-box {',
'    background: var(--ut-palette-warning-light, #fff8e1);',
'    border-left: 4px solid var(--ut-palette-warning, #f0ad4e);',
'    padding: 1rem 1.25rem;',
'    border-radius: 0 6px 6px 0;',
'    margin-bottom: 1rem;',
'    font-size: 0.9rem;',
'    color: var(--ut-component-font-color, #333333);',
'    line-height: 1.5;',
'}',
' ',
'.signature-pad-container {',
'    border: 2px solid var(--ut-component-border-color, #d0d0d0);',
'    border-radius: 8px;',
'    background: #ffffff;',
'    padding: 10px;',
'    margin: 10px 0;',
'}',
'',
'.signature-pad {',
'    width: 100%;',
'    height: 150px;',
'    border: 1px dashed #ccc;',
'    border-radius: 4px;',
'    touch-action: none;',
'    cursor: crosshair;',
'}',
'',
'.signature-controls {',
'    display: flex;',
'    gap: 10px;',
'    margin-top: 10px;',
'    justify-content: flex-end;',
'}',
'',
'.signature-controls button {',
'    padding: 6px 12px;',
'    border-radius: 4px;',
'    border: 1px solid #d0d0d0;',
'    background: #f5f5f5;',
'    cursor: pointer;',
'    font-size: 0.875rem;',
'}',
'',
'.signature-controls button:hover {',
'    background: #e0e0e0;',
'}'))
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_read_only_when=>'P5_WORKFLOW_STATUS'
,p_read_only_when2=>'DRAFT'
,p_page_component_map=>'25'
,p_created_on=>wwv_flow_imp.dz('20260214110324Z')
,p_last_updated_on=>wwv_flow_imp.dz('20260919132507Z')
,p_created_by=>'PTW_PRO'
,p_last_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27355547264033426)
,p_plug_name=>'Acceptance Declaration'
,p_static_id=>'acceptance-declaration'
,p_title=>'Acceptance of this &P5_DOC_TERM.'
,p_icon_css_classes=>'fa-handshake-o'
,p_region_template_options=>'#DEFAULT#:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>250
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="ptw-section-card">',
'    <div class="ptw-section-body">',
'        <div class="declaration-box">',
'            <strong>Acceptance of this &P5_DOC_TERM.:</strong>',
'            I certify that I am competent to supervise and undertake the works',
'            detailed within this &P5_DOC_TERM. and have read and fully understand',
'            the documentation associated with this work activity. I am satisfied',
'            that those personnel who will be employed on the task are properly',
'            equipped and understand the relevant safety and emergency procedures',
'            to be followed and are competent to carry out these works.',
'        </div>',
'    </div>',
'</div>',
''))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260214113631Z')
,p_updated_on=>wwv_flow_imp.dz('20260919132507Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27355431661033425)
,p_plug_name=>'Acceptance Fields'
,p_static_id=>'acceptance-fields'
,p_title=>'Person in Charge of Works Details'
,p_icon_css_classes=>'fa-signature'
,p_region_template_options=>'#DEFAULT#:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>260
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260214113631Z')
,p_updated_on=>wwv_flow_imp.dz('20260919125153Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27356002085033431)
,p_plug_name=>'AccSignature'
,p_static_id=>'accsignature'
,p_parent_plug_id=>wwv_flow_imp.id(27355431661033425)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>70
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="signature-pad-container">',
'    <canvas id="acceptSignaturePad" class="signature-pad"></canvas>',
'    <div class="signature-controls">',
'        <button type="button" id="BTN_CLEAR_ACCEPT_SIG_P5" onclick="clearAcceptSignature()">Clear</button>',
'    </div>',
'    <div class="geo-info" id="acceptGeoInfo"></div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260214114442Z')
,p_updated_on=>wwv_flow_imp.dz('20260913141436Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27354649096033417)
,p_plug_name=>'Authorisation Declaration'
,p_static_id=>'authorisation-declaration'
,p_title=>'Authorisation of this &P5_DOC_TERM.'
,p_icon_css_classes=>'fa-certificate'
,p_region_template_options=>'#DEFAULT#:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>230
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="ptw-section-card">',
'    <div class="ptw-section-body">',
'        <div class="declaration-box">',
'            <strong>Authorisation of this &P5_DOC_TERM.:</strong>',
'            I have reviewed all aspects of the task/activity and I am satisfied',
'            with the arrangements as detailed within the relevant risk assessment',
'            and method statement that have been put in place and certify that',
'            this activity detailed is authorised to proceed. Suitable insurance',
'            is in place, (employers and public liability).',
'        </div>',
'    </div>',
'</div>',
' '))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260214111755Z')
,p_updated_on=>wwv_flow_imp.dz('20260919125153Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27354749922033418)
,p_plug_name=>'Authorisation Fields'
,p_static_id=>'authorisation-fields'
,p_title=>'Authorised Person Details'
,p_icon_css_classes=>'fa-signature'
,p_region_template_options=>'#DEFAULT#:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>240
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260214111940Z')
,p_updated_on=>wwv_flow_imp.dz('20260919125153Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27355228671033423)
,p_plug_name=>'AuthSignature'
,p_static_id=>'authsignature'
,p_title=>'Signature - Authorised Person'
,p_parent_plug_id=>wwv_flow_imp.id(27354749922033418)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>50
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="signature-pad-container">',
'    <canvas id="authSignaturePad" class="signature-pad"></canvas>',
'    <div class="signature-controls">',
'        <button type="button" id="BTN_CLEAR_AUTH_SIG_P5" onclick="clearAuthSignature()">Clear</button>',
'    </div>',
'    <div class="geo-info" id="authGeoInfo"></div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260214112619Z')
,p_updated_on=>wwv_flow_imp.dz('20260408201951Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27356182588033432)
,p_plug_name=>'Buttons'
,p_static_id=>'buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>270
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260214114815Z')
,p_updated_on=>wwv_flow_imp.dz('20260919125153Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(59754344828705381)
,p_plug_name=>'Permit Number Badge'
,p_static_id=>'permit-information-badge'
,p_plug_display_sequence=>220
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="margin-bottom: 20px;">',
'    <span class="apex-badge" style="background-color: #3ea055; color: white; padding: 6px 16px; border-radius: 20px; font-weight: 600;">',
'        Permit: &P5_PERMIT_NUMBER.',
'    </span>',
'</div>'))
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P5_PERMIT_NUMBER'
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260307134727Z')
,p_updated_on=>wwv_flow_imp.dz('20260919125153Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8879760138853346)
,p_plug_name=>'Permit Type Badge'
,p_static_id=>'permit-type-badge'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>210
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'RETURN ptw_pro.ptw_ui_pkg.get_permit_type_badge_html(',
'    p_permit_id => :P5_PERMIT_ID,',
'    p_ptw_type  => :P5_PTW_TYPE',
');'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_created_on=>wwv_flow_imp.dz('20260824212554Z')
,p_updated_on=>wwv_flow_imp.dz('20260919125153Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(37954746372176008)
,p_plug_name=>'Role & Permit Status'
,p_static_id=>'role-permit-status'
,p_title=>'Role & Permit Status'
,p_parent_plug_id=>wwv_flow_imp.id(27354649096033417)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_from_dt       DATE;',
'    v_to_dt         DATE;',
'    v_now           DATE          := SYSDATE;',
'    v_clob          CLOB          := '''';',
'BEGIN',
'    -- Get permit validity window if set',
'    BEGIN',
'        SELECT started_datetime, ended_datetime',
'        INTO   v_from_dt, v_to_dt',
'        FROM   ptw_pro.ptw_lv_permits',
'        WHERE  permit_id = :P5_PERMIT_ID;',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN NULL;',
'    END;',
'',
'    -- Permit validity window (only show if dates are set)',
'    IF v_from_dt IS NOT NULL OR v_to_dt IS NOT NULL THEN',
'        v_clob := v_clob ||',
'            ''<div class="t-Alert t-Alert--info t-Alert--horizontal margin-bottom-sm" role="region">'' ||',
'            ''  <div class="t-Alert-wrap">'' ||',
'            ''    <div class="t-Alert-icon"><span class="t-Icon fa fa-clock-o"></span></div>'' ||',
'            ''    <div class="t-Alert-content">'' ||',
'            ''      <div class="t-Alert-body"><strong>Permit validity window:</strong> '';',
'',
'        IF v_from_dt IS NOT NULL THEN',
'            v_clob := v_clob || ''From '' || TO_CHAR(v_from_dt, ''DD-MON-YYYY HH24:MI'');',
'        END IF;',
'',
'        IF v_to_dt IS NOT NULL THEN',
'            v_clob := v_clob || '' &nbsp;&mdash;&nbsp; To '' || TO_CHAR(v_to_dt, ''DD-MON-YYYY HH24:MI'');',
'        END IF;',
'',
'        IF v_to_dt IS NOT NULL AND v_now > v_to_dt THEN',
'            v_clob := v_clob || '' &nbsp;<strong style="color:var(--ut-palette-danger,#c0392b);">(Expired)</strong>'';',
'        END IF;',
'',
'        v_clob := v_clob ||',
'            ''      </div>'' ||',
'            ''    </div>'' ||',
'            ''  </div>'' ||',
'            ''</div>'';',
'    END IF;',
'',
'    RETURN v_clob;',
'END;'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_created_on=>wwv_flow_imp.dz('20260323211702Z')
,p_updated_on=>wwv_flow_imp.dz('20260411114634Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(59751115845944493)
,p_plug_name=>'SyncStatus'
,p_static_id=>'syncstatus'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>190
,p_plug_item_display_point=>'ABOVE'
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
,p_created_on=>wwv_flow_imp.dz('20260307130736Z')
,p_updated_on=>wwv_flow_imp.dz('20260919125153Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27354510223033416)
,p_plug_name=>'Workflow Progress'
,p_static_id=>'workflow-progress'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>200
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'   RETURN ptw_pro.ptw_ui_pkg.get_workflow_steps_html(',
'       p_permit_id => :P5_PERMIT_ID,',
'       p_ptw_type  => :P5_PTW_TYPE,',
'       p_current_step => ''AUTHORISATION''',
'   );'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_created_on=>wwv_flow_imp.dz('20260214111139Z')
,p_updated_on=>wwv_flow_imp.dz('20260919125153Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(39966392216997139)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(27356182588033432)
,p_button_name=>'AUTHORISE'
,p_static_id=>'authorise'
,p_button_static_id=>'BTN_AUTHORISE_P5'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Authorise'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P5_WORKFLOW_STATUS'
,p_button_condition2=>'DRAFT'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-clipboard-check'
,p_created_on=>wwv_flow_imp.dz('20260406140711Z')
,p_updated_on=>wwv_flow_imp.dz('20260711151016Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(27356264505033433)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(27356182588033432)
,p_button_name=>'BACK'
,p_static_id=>'back'
,p_button_static_id=>'BTN_BACK_P5'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Back'
,p_button_position=>'PREVIOUS'
,p_warn_on_unsaved_changes=>null
,p_created_on=>wwv_flow_imp.dz('20260214114815Z')
,p_updated_on=>wwv_flow_imp.dz('20260825205442Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(31606655096440628)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(27356182588033432)
,p_button_name=>'START_PERMIT'
,p_static_id=>'start-permit'
,p_button_static_id=>'BTN_START_PERMIT_P5'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Start Permit'
,p_button_position=>'NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:9:P9_PERMIT_ID,P9_PERMIT_NUMBER:&P5_PERMIT_ID.,&P5_PERMIT_NUMBER.'
,p_button_condition=>'P5_WORKFLOW_STATUS'
,p_button_condition2=>'AUTHORISED'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-clock-o'
,p_created_on=>wwv_flow_imp.dz('20260305205735Z')
,p_updated_on=>wwv_flow_imp.dz('20260408200040Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(39966797793997143)
,p_branch_name=>'Refresh page after submit'
,p_branch_action=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5:P5_PERMIT_ID:&P5_PERMIT_ID.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(39966392216997139)
,p_branch_sequence=>10
,p_created_on=>wwv_flow_imp.dz('20260408200300Z')
,p_updated_on=>wwv_flow_imp.dz('20260408220804Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27355874180033429)
,p_name=>'P5_ACCEPT_COMPANY'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(27355431661033425)
,p_prompt=>'Company'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260214114442Z')
,p_updated_on=>wwv_flow_imp.dz('20260913141436Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27355946358033430)
,p_name=>'P5_ACCEPT_DATETIME'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(27355431661033425)
,p_item_default=>'SELECT TO_CHAR(SYSDATE,''DD-MON-YYYY HH24:MI'') FROM dual;'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Date & Time'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260214114442Z')
,p_updated_on=>wwv_flow_imp.dz('20260913141436Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27354339224033414)
,p_name=>'P5_ACCEPT_LATITUDE'
,p_item_sequence=>130
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260214110919Z')
,p_updated_on=>wwv_flow_imp.dz('20260401204242Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27354445860033415)
,p_name=>'P5_ACCEPT_LONGITUDE'
,p_item_sequence=>140
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260214110919Z')
,p_updated_on=>wwv_flow_imp.dz('20260401204242Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27355762469033428)
,p_name=>'P5_ACCEPT_PERSON_MOBILE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(27355431661033425)
,p_prompt=>'Mobile Tel. No.'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260214114442Z')
,p_updated_on=>wwv_flow_imp.dz('20260913141436Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27355610155033427)
,p_name=>'P5_ACCEPT_PERSON_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(27355431661033425)
,p_prompt=>'Name'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260214114442Z')
,p_updated_on=>wwv_flow_imp.dz('20260913141436Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27354075256033411)
,p_name=>'P5_ACCEPT_SIGNATURE_DATA'
,p_item_sequence=>100
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260214110919Z')
,p_updated_on=>wwv_flow_imp.dz('20260401204242Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(33351141764951425)
,p_name=>'P5_AUTH_DATETIME'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(27354749922033418)
,p_prompt=>'Authorisation Date'
,p_format_mask=>'DD-MON-YYYY HH24:MI'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_cMaxlength=>20
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'Y',
  'use_defaults', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260321132412Z')
,p_updated_on=>wwv_flow_imp.dz('20260326205018Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27354116465033412)
,p_name=>'P5_AUTH_LATITUDE'
,p_item_sequence=>110
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260214110919Z')
,p_updated_on=>wwv_flow_imp.dz('20260401204242Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27354271702033413)
,p_name=>'P5_AUTH_LONGITUDE'
,p_item_sequence=>120
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260214110919Z')
,p_updated_on=>wwv_flow_imp.dz('20260401204242Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(37955311718176014)
,p_name=>'P5_AUTH_PERSON_DISPLAY'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(27354749922033418)
,p_prompt=>'Authorising Person'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P5_WORKFLOW_STATUS'
,p_display_when2=>'DRAFT'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260324214225Z')
,p_updated_on=>wwv_flow_imp.dz('20260711151016Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27354949910033420)
,p_name=>'P5_AUTH_PERSON_MOBILE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(27354749922033418)
,p_prompt=>'Mobile Tel No.'
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
,p_created_on=>wwv_flow_imp.dz('20260214112619Z')
,p_updated_on=>wwv_flow_imp.dz('20260323210607Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(33352343405951437)
,p_name=>'P5_AUTH_PERSON_SELECT'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(27354749922033418)
,p_prompt=>'Authorising person'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'PTW_AUTHORISED_PERSONS'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-- Select Authorising Person --'
,p_cHeight=>1
,p_colspan=>6
,p_display_when=>'P5_WORKFLOW_STATUS'
,p_display_when2=>'DRAFT'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260322101330Z')
,p_updated_on=>wwv_flow_imp.dz('20260711151016Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27353970594033410)
,p_name=>'P5_AUTH_SIGNATURE_DATA'
,p_item_sequence=>90
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260214110919Z')
,p_updated_on=>wwv_flow_imp.dz('20260401204242Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(8880121691853350)
,p_name=>'P5_BACK_URL'
,p_item_sequence=>170
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260825205442Z')
,p_updated_on=>wwv_flow_imp.dz('20260825205442Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30143615815642705)
,p_name=>'P5_CURRENT_STEP'
,p_item_sequence=>60
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260228135016Z')
,p_updated_on=>wwv_flow_imp.dz('20260401204242Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(42197901263924532)
,p_name=>'P5_DOC_TERM'
,p_item_sequence=>180
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260919125153Z')
,p_updated_on=>wwv_flow_imp.dz('20260919125153Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30143518277642704)
,p_name=>'P5_IS_CHANGED'
,p_item_sequence=>50
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260228135016Z')
,p_updated_on=>wwv_flow_imp.dz('20260401204242Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27353728149033408)
,p_name=>'P5_PERMIT_ID'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260214110919Z')
,p_updated_on=>wwv_flow_imp.dz('20260214110919Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27353854481033409)
,p_name=>'P5_PERMIT_NUMBER'
,p_item_sequence=>80
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260214110919Z')
,p_updated_on=>wwv_flow_imp.dz('20260401204242Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(8879869352853347)
,p_name=>'P5_PTW_TYPE'
,p_item_sequence=>160
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260824212555Z')
,p_updated_on=>wwv_flow_imp.dz('20260824212701Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(39963128282997107)
,p_name=>'P5_REDIRECT_URL'
,p_item_sequence=>40
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260401204241Z')
,p_updated_on=>wwv_flow_imp.dz('20260401204241Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(33350836721951422)
,p_name=>'P5_USER_CAN_AUTHORISE'
,p_item_sequence=>150
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260321132412Z')
,p_updated_on=>wwv_flow_imp.dz('20260401204242Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(31607494167440636)
,p_name=>'P5_WORKFLOW_STATUS'
,p_item_sequence=>70
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260307143310Z')
,p_updated_on=>wwv_flow_imp.dz('20260401204242Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(37958766966176048)
,p_validation_name=>'Accept person cannot be NULL'
,p_static_id=>'accept-person-cannot-be-null'
,p_validation_sequence=>58
,p_validation=>'P5_ACCEPT_PERSON_NAME'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Person in Charge cannot be blank.'
,p_when_button_pressed=>wwv_flow_imp.id(39966392216997139)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260331192453Z')
,p_updated_on=>wwv_flow_imp.dz('20260408195559Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(37958677119176047)
,p_validation_name=>'Accept Signature required'
,p_static_id=>'accept-signature-required'
,p_validation_sequence=>38
,p_validation=>'P5_ACCEPT_SIGNATURE_DATA'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Person in charge signature is required.'
,p_when_button_pressed=>wwv_flow_imp.id(39966392216997139)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260331192453Z')
,p_updated_on=>wwv_flow_imp.dz('20260408195559Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(27356670959033437)
,p_validation_name=>'Auth Person Name Required'
,p_static_id=>'auth-person-name-required'
,p_validation_sequence=>20
,p_validation=>'P5_AUTH_PERSON_SELECT'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Authorised person name is required.'
,p_when_button_pressed=>wwv_flow_imp.id(39966392216997139)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260214120339Z')
,p_updated_on=>wwv_flow_imp.dz('20260408195559Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(27356727784033438)
,p_validation_name=>'Auth Signature Required'
,p_static_id=>'auth-signature-required'
,p_validation_sequence=>48
,p_validation=>'P5_AUTH_SIGNATURE_DATA'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Authorised person signature is required.'
,p_when_button_pressed=>wwv_flow_imp.id(39966392216997139)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260214120339Z')
,p_updated_on=>wwv_flow_imp.dz('20260408195559Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(33352170367951435)
,p_validation_name=>'No Self-Authorisation'
,p_static_id=>'no-self-authorisation'
,p_validation_sequence=>27
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'  DECLARE',
'    l_name VARCHAR2(200);',
'  BEGIN',
'    BEGIN',
'      SELECT first_name || '' '' || last_name',
'      INTO   l_name',
'      FROM   ptw_pro.ptw_lv_user_roles_v',
'      WHERE  username = :P5_AUTH_PERSON_SELECT;',
'    EXCEPTION',
'      WHEN OTHERS THEN l_name := NULL; ',
'    END;',
'    RETURN NOT (',
'        l_name  IS NOT NULL AND',
'        l_name IS NOT NULL AND',
'        UPPER(TRIM(l_name)) = UPPER(TRIM(:P5_ACCEPT_PERSON_NAME))',
'    );',
'  END;',
'EXCEPTION',
'    WHEN OTHERS THEN RETURN TRUE;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'The Authorised Person and Person in Charge of Works cannot be the same individual. A permit must not be self-authorised.'
,p_when_button_pressed=>wwv_flow_imp.id(39966392216997139)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260321164703Z')
,p_updated_on=>wwv_flow_imp.dz('20260408195559Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(27356512824033436)
,p_validation_name=>'Permit ID Required'
,p_static_id=>'permit-id-required'
,p_validation_sequence=>10
,p_validation=>'P5_PERMIT_ID'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Permit ID is required.'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260214115655Z')
,p_updated_on=>wwv_flow_imp.dz('20260214115655Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(37954826633176009)
,p_name=>'Authorisors mobile No load'
,p_static_id=>'authorisors-mobile-no-load'
,p_event_sequence=>90
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P5_AUTH_PERSON_SELECT'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_created_on=>wwv_flow_imp.dz('20260323213701Z')
,p_updated_on=>wwv_flow_imp.dz('20260408221850Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(37954991974176010)
,p_event_id=>wwv_flow_imp.id(37954826633176009)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_static_id=>'native-execute-plsql-code'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'items_to_return', 'P5_AUTH_PERSON_MOBILE',
  'items_to_submit', 'P5_AUTH_PERSON_SELECT',
  'language', 'PLSQL',
  'plsql_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'BEGIN',
    '    SELECT first_name||'' ''||last_name, mobile_no',
    '    INTO   :P5_AUTH_PERSON_DISPLAY, :P5_AUTH_PERSON_MOBILE',
    '    FROM   ptw_pro.ptw_lv_users',
    '    WHERE  UPPER(username) = UPPER(:P5_AUTH_PERSON_SELECT);',
    'EXCEPTION',
    '    WHEN NO_DATA_FOUND THEN NULL;',
    'END;')),
  'show_processing', 'Y',
  'suppress_change_event', 'N')).to_clob
,p_wait_for_result=>'Y'
,p_created_on=>wwv_flow_imp.dz('20260323213701Z')
,p_updated_on=>wwv_flow_imp.dz('20260408221850Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(24588539339992901)
,p_name=>'Back Button Click'
,p_static_id=>'back-button-click'
,p_event_sequence=>130
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(27356264505033433)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_created_on=>wwv_flow_imp.dz('20260825205442Z')
,p_updated_on=>wwv_flow_imp.dz('20260825205442Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(24588673895992902)
,p_event_id=>wwv_flow_imp.id(24588539339992901)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'apex.navigation.redirect($v(''P5_BACK_URL''));')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260825205442Z')
,p_updated_on=>wwv_flow_imp.dz('20260825205442Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(39962598630997101)
,p_name=>'Click the Authorise button'
,p_static_id=>'click-the-authorise-button'
,p_event_sequence=>110
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(39966392216997139)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_created_on=>wwv_flow_imp.dz('20260331203835Z')
,p_updated_on=>wwv_flow_imp.dz('20260504220912Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(39962698061997102)
,p_event_id=>wwv_flow_imp.id(39962598630997101)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'ptwShowAuthoriseDeclaration();',
    '',
    '',
    '')))).to_clob
,p_created_on=>wwv_flow_imp.dz('20260331203835Z')
,p_updated_on=>wwv_flow_imp.dz('20260504220912Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(33352838421951442)
,p_name=>'Initialise page'
,p_static_id=>'initialise-page'
,p_event_sequence=>2
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
,p_created_on=>wwv_flow_imp.dz('20260323201349Z')
,p_updated_on=>wwv_flow_imp.dz('20260711151016Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33353070566951444)
,p_event_id=>wwv_flow_imp.id(33352838421951442)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_name=>'Connection UI'
,p_static_id=>'connection-ui'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'updateConnectionUI();',
    'window.addEventListener(''online'',  updateConnectionUI);',
    'window.addEventListener(''offline'', updateConnectionUI);',
    '',
    'window.addEventListener(''resize'', function() {',
    '    initSignaturePads();',
    '});')))).to_clob
,p_created_on=>wwv_flow_imp.dz('20260323201349Z')
,p_updated_on=>wwv_flow_imp.dz('20260411121737Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(37955275603176013)
,p_event_id=>wwv_flow_imp.id(33352838421951442)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_name=>'Load Signatures'
,p_static_id=>'load-signatures'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'var authData   = apex.item(''P5_AUTH_SIGNATURE_DATA'').getValue();',
    'var acceptData = apex.item(''P5_ACCEPT_SIGNATURE_DATA'').getValue();',
    '',
    'if (authData) {',
    '    loadSignature(authSignaturePad,',
    '        document.getElementById(''authSignaturePad''),',
    '        ''data:image/png;base64,'' + authData);',
    '}',
    'if (acceptData) {',
    '    loadSignature(acceptSignaturePad,',
    '        document.getElementById(''acceptSignaturePad''),',
    '        ''data:image/png;base64,'' + acceptData);',
    '}')))).to_clob
,p_server_condition_type=>'NEVER'
,p_created_on=>wwv_flow_imp.dz('20260324210957Z')
,p_updated_on=>wwv_flow_imp.dz('20260411122025Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(37955420884176015)
,p_event_id=>wwv_flow_imp.id(33352838421951442)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_name=>'Load the Auth person details'
,p_static_id=>'load-the-auth-person-details'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'items_to_return', 'P5_AUTH_PERSON_DISPLAY,P5_AUTH_PERSON_MOBILE',
  'items_to_submit', 'P5_AUTH_PERSON_SELECT',
  'language', 'PLSQL',
  'plsql_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'BEGIN',
    '    SELECT mobile_no,',
    '           first_name || '' '' || last_name',
    '    INTO   :P5_AUTH_PERSON_MOBILE,',
    '           :P5_AUTH_PERSON_DISPLAY',
    '    FROM   ptw_pro.ptw_lv_users',
    '    WHERE  UPPER(username) = UPPER(:P5_AUTH_PERSON_SELECT);',
    'EXCEPTION',
    '    WHEN NO_DATA_FOUND THEN',
    '        :P5_AUTH_PERSON_MOBILE  := NULL;',
    '        :P5_AUTH_PERSON_DISPLAY := NULL;',
    'END;')),
  'show_processing', 'Y',
  'suppress_change_event', 'N')).to_clob
,p_wait_for_result=>'Y'
,p_created_on=>wwv_flow_imp.dz('20260324214226Z')
,p_updated_on=>wwv_flow_imp.dz('20260411121737Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33353132786951445)
,p_event_id=>wwv_flow_imp.id(33352838421951442)
,p_event_result=>'TRUE'
,p_action_sequence=>70
,p_name=>'Manage Offline'
,p_static_id=>'manage-offline'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'OfflineStorage.initDB();',
    'ConnectionManager.init();')))).to_clob
,p_created_on=>wwv_flow_imp.dz('20260323201349Z')
,p_updated_on=>wwv_flow_imp.dz('20260411121737Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33352979633951443)
,p_event_id=>wwv_flow_imp.id(33352838421951442)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_name=>'Signatures'
,p_static_id=>'signatures'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'initSignaturePads();',
    '',
    '// If read-only, disable canvases after pads have initialised',
    'setTimeout(function() {',
    '    var status = apex.item(''P5_WORKFLOW_STATUS'').getValue();',
    '    if (status !== ''DRAFT'' && status !== '''') {',
    '        [''authSignaturePad'', ''acceptSignaturePad''].forEach(function(id) {',
    '            var canvas = document.getElementById(id);',
    '            if (canvas) {',
    '                canvas.style.pointerEvents = ''none'';',
    '                canvas.style.opacity       = ''0.6'';',
    '                canvas.style.cursor        = ''not-allowed'';',
    '                canvas.title               = ''This permit is read-only'';',
    '            }',
    '        });',
    '    }',
    '}, 250);')))).to_clob
,p_created_on=>wwv_flow_imp.dz('20260323201349Z')
,p_updated_on=>wwv_flow_imp.dz('20260711151016Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(31607259171440634)
,p_name=>'Save Signatures'
,p_static_id=>'save-signatures'
,p_event_sequence=>30
,p_triggering_element_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_element=>'document'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'custom'
,p_bind_event_type_custom=>'apexbeforepagesubmit'
,p_created_on=>wwv_flow_imp.dz('20260307125618Z')
,p_updated_on=>wwv_flow_imp.dz('20260323202302Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33353206048951446)
,p_event_id=>wwv_flow_imp.id(31607259171440634)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'saveSignatures();',
    '')))).to_clob
,p_created_on=>wwv_flow_imp.dz('20260323202302Z')
,p_updated_on=>wwv_flow_imp.dz('20260323202302Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(37954230775176003)
,p_name=>'Set Page Read-Only when not DRAFT'
,p_static_id=>'set-page-read-only-when-not-draft'
,p_event_sequence=>70
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
,p_display_when_type=>'EXPRESSION'
,p_display_when_cond=>':P5_WORKFLOW_STATUS IN (''AUTHORISED'', ''STARTED'')'
,p_display_when_cond2=>'PLSQL'
,p_created_on=>wwv_flow_imp.dz('20260323204447Z')
,p_updated_on=>wwv_flow_imp.dz('20260825212858Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(37954370773176004)
,p_event_id=>wwv_flow_imp.id(37954230775176003)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    ' // Disable signature canvases',
    ' [''authSignaturePad'', ''acceptSignaturePad''].forEach(function(id) {',
    '     var canvas = document.getElementById(id);',
    '     if (canvas) {',
    '         canvas.style.pointerEvents = ''none'';',
    '         canvas.style.opacity       = ''0.6'';',
    '         canvas.style.cursor        = ''not-allowed'';',
    '         canvas.title               = ''This permit is read-only'';',
    '             }',
    '     });',
    '// Hide Clear Signature buttons',
    '$(''#BTN_CLEAR_AUTH_SIG_P5, #BTN_CLEAR_ACCEPT_SIG_P5'').hide();',
    '// Hide Save Draft and Authorise buttons when read-only',
    '//$(''#BTN_SAVE_DRAFT_P5, #BTN_START_PERMIT_P5'').hide();',
    '',
    '')))).to_clob
,p_created_on=>wwv_flow_imp.dz('20260323204447Z')
,p_updated_on=>wwv_flow_imp.dz('20260825212858Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(39967216755997148)
,p_name=>'When Start permit screen closed'
,p_static_id=>'when-start-permit-screen-closed'
,p_event_sequence=>120
,p_triggering_element_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_element=>'document'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
,p_created_on=>wwv_flow_imp.dz('20260411111900Z')
,p_updated_on=>wwv_flow_imp.dz('20260428215828Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(39967324340997149)
,p_event_id=>wwv_flow_imp.id(39967216755997148)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_static_id=>'native-refresh'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'JAVASCRIPT_EXPRESSION'
,p_affected_elements=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.navigation.redirect(apex.util.makeApplicationUrl({',
'    pageId: 5',
'}));'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'maintain_pagination', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260411111900Z')
,p_updated_on=>wwv_flow_imp.dz('20260428215828Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(24588919001992905)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Compute Back URL'
,p_static_id=>'compute-back-url'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE ',
'  l_target_page NUMBER; ',
'BEGIN ',
'  IF :P5_PTW_TYPE IN (''LV ISOLATION'', ''WORKING AT HEIGHT'') THEN ',
'    l_target_page := 4; -- Equipment Isolation ',
'  ELSE l_target_page := 3; -- Control Measures ',
'  END IF; ',
'  ',
'  :P5_BACK_URL := apex_page.get_url( p_page => l_target_page, p_items => ''P'' || l_target_page || ''_PERMIT_ID'', p_values => :P5_PERMIT_ID ); ',
'END; '))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>24588919001992905
,p_created_on=>wwv_flow_imp.dz('20260829140959Z')
,p_updated_on=>wwv_flow_imp.dz('20260829140959Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(27356851819033439)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load Authorisation and Acceptance Data'
,p_static_id=>'load-authorisation-and-acceptance-data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    :P5_CURRENT_STEP := ''AUTHORISATION'';',
'',
'    BEGIN',
'        SELECT permit_number, workflow_status, ptw_type',
'        INTO   :P5_PERMIT_NUMBER, :P5_WORKFLOW_STATUS, :P5_PTW_TYPE',
'        FROM   ptw_pro.ptw_lv_permits',
'        WHERE  permit_id = :P5_PERMIT_ID;',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN',
'            :P5_WORKFLOW_STATUS := ''DRAFT'';',
'    END;',
'',
'    :G_ACTIVE_PERMIT_ID := :P5_PERMIT_ID;',
'',
'    :P5_DOC_TERM := CASE WHEN :P5_PTW_TYPE = ''LIMITATION OF ACCESS'' THEN ''Limitation of Access'' ELSE ''Permit to Work'' END;',
'',
'    DECLARE',
'        v_auth_sig        BLOB;',
'        v_accept_sig      BLOB;',
'        v_na_company      ptw_pro.ptw_signatures.company_name%TYPE;',
'        v_auth_lat        ptw_pro.ptw_signatures.latitude%TYPE;',
'        v_auth_lng        ptw_pro.ptw_signatures.longitude%TYPE;',
'        v_auth_to_dt      ptw_pro.ptw_signatures.auth_to_datetime%TYPE;',
'        v_na_accept_to_dt ptw_pro.ptw_signatures.auth_to_datetime%TYPE;',
'        v_auth_dt         ptw_pro.ptw_signatures.event_datetime%TYPE;',
'        v_accept_dt       ptw_pro.ptw_signatures.event_datetime%TYPE;',
'    BEGIN',
'        ptw_pro.ptw_signature_pkg.get_signature(:P5_PERMIT_ID, ''AUTH'',',
'            :P5_AUTH_PERSON_SELECT, v_auth_sig, :P5_AUTH_PERSON_MOBILE, v_na_company,',
'            v_auth_dt, :P5_AUTH_LATITUDE, :P5_AUTH_LONGITUDE, v_auth_to_dt);',
'',
'        ptw_pro.ptw_signature_pkg.get_signature(:P5_PERMIT_ID, ''ACCEPT'',',
'            :P5_ACCEPT_PERSON_NAME, v_accept_sig, :P5_ACCEPT_PERSON_MOBILE, :P5_ACCEPT_COMPANY,',
'            v_accept_dt, :P5_ACCEPT_LATITUDE, :P5_ACCEPT_LONGITUDE, v_na_accept_to_dt);',
'',
'        IF v_accept_dt IS NULL THEN',
'            :P5_ACCEPT_DATETIME := TO_CHAR(SYSDATE, ''DD-MON-YYYY HH24:MI'');',
'        ELSE',
'            :P5_ACCEPT_DATETIME := TO_CHAR(v_accept_dt, ''DD-MON-YYYY HH24:MI'');',
'        END IF;',
'',
'        IF v_auth_dt IS NULL THEN',
'            :P5_AUTH_DATETIME := TO_CHAR(SYSDATE, ''DD-MON-YYYY HH24:MI'');',
'        ELSE',
'            :P5_AUTH_DATETIME := TO_CHAR(v_auth_dt, ''DD-MON-YYYY HH24:MI'');',
'        END IF;',
'',
'        IF :P5_ACCEPT_COMPANY IS NULL AND :P5_ACCEPT_PERSON_NAME IS NULL THEN',
'            BEGIN',
'                SELECT person_in_charge_name, supervising_company',
'                INTO   :P5_ACCEPT_PERSON_NAME, :P5_ACCEPT_COMPANY',
'                FROM   ptw_pro.ptw_lv_permits',
'                WHERE  permit_id = :P5_PERMIT_ID;',
'            EXCEPTION',
'                WHEN OTHERS THEN NULL;',
'            END;',
'        END IF;',
'',
'        IF v_auth_sig IS NOT NULL THEN',
'            :P5_AUTH_SIGNATURE_DATA := ''data:image/png;base64,''',
'                || apex_web_service.blob2clobbase64(v_auth_sig);',
'        END IF;',
'',
'        IF v_accept_sig IS NOT NULL THEN',
'            :P5_ACCEPT_SIGNATURE_DATA := ''data:image/png;base64,''',
'                || apex_web_service.blob2clobbase64(v_accept_sig);',
'        END IF;',
'    END;',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        apex_error.add_error(',
'            p_message => ''Error loading authorisation data: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>27356851819033439
,p_created_on=>wwv_flow_imp.dz('20260214120339Z')
,p_updated_on=>wwv_flow_imp.dz('20260919125153Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(27356922514033440)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save Authorisation and Acceptance Data'
,p_static_id=>'save-authorisation-and-acceptance-data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_auth_sig_blob   BLOB;',
'    v_accept_sig_blob BLOB;',
'    v_auth_mobile     ptw_pro.ptw_lv_users.mobile_no%TYPE;',
'',
'    FUNCTION base64_to_blob(p_base64 CLOB) RETURN BLOB IS',
'        v_blob BLOB;',
'        v_clob CLOB;',
'    BEGIN',
'        IF p_base64 IS NULL THEN',
'            RETURN NULL;',
'        END IF;',
'        v_clob := REGEXP_REPLACE(p_base64, ''^data:image/[^;]+;base64,'', '''');',
'        v_blob := apex_web_service.clobbase642blob(v_clob);',
'        RETURN v_blob;',
'    END base64_to_blob;',
'',
'BEGIN',
'    v_auth_sig_blob   := base64_to_blob(:P5_AUTH_SIGNATURE_DATA);',
'    v_accept_sig_blob := base64_to_blob(:P5_ACCEPT_SIGNATURE_DATA);',
'',
'    -- Resolve auth person''s mobile_no first; scalar subqueries can''t be',
'    -- used as bare PL/SQL expressions in a named-parameter call (PLS-00103).',
'    BEGIN',
'        SELECT mobile_no',
'        INTO   v_auth_mobile',
'        FROM   ptw_pro.ptw_lv_users',
'        WHERE  UPPER(username) = UPPER(:P5_AUTH_PERSON_SELECT);',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN',
'            v_auth_mobile := NULL;',
'        WHEN TOO_MANY_ROWS THEN',
'            v_auth_mobile := NULL;',
'    END;',
'',
'    ptw_pro.ptw_signature_pkg.save_signature(',
'        p_permit_id      => :P5_PERMIT_ID,',
'        p_stage          => ''AUTH'',',
'        p_person_name    => UPPER(:P5_AUTH_PERSON_SELECT),',
'        --   was: (SELECT first_name || '' '' || last_name FROM ptw_pro.ptw_lv_users',
unistr('        --         WHERE UPPER(username) = UPPER(:P5_AUTH_PERSON_SELECT)) \2014 left as'),
'        --   username per the original''s own commented-out alternative',
'        p_signature_blob => v_auth_sig_blob,',
'        p_mobile_no      => v_auth_mobile,',
'        p_event_datetime => TO_DATE(:P5_AUTH_DATETIME, ''DD-MON-YYYY HH24:MI''),',
'        p_latitude       => :APP_LATITUDE,',
'        p_longitude      => :APP_LONGITUDE',
'    );',
'',
'    ptw_pro.ptw_signature_pkg.save_signature(',
'        p_permit_id      => :P5_PERMIT_ID,',
'        p_stage          => ''ACCEPT'',',
'        p_person_name    => :P5_ACCEPT_PERSON_NAME,',
'        p_signature_blob => v_accept_sig_blob,',
'        p_mobile_no      => :P5_ACCEPT_PERSON_MOBILE,',
'        p_company_name   => :P5_ACCEPT_COMPANY,',
'        p_event_datetime => TO_DATE(:P5_ACCEPT_DATETIME, ''DD-MON-YYYY HH24:MI''),',
'        p_latitude       => :APP_LATITUDE,',
'        p_longitude      => :APP_LONGITUDE',
'    );',
'',
'    UPDATE ptw_pro.ptw_lv_permits',
'    SET    workflow_status = ''AUTHORISED'',',
'           current_step    = ''AUTHORISATION'',',
'           auth_latitude      = TO_NUMBER(:APP_LATITUDE),',
'           auth_longitude     = TO_NUMBER(:APP_LONGITUDE),',
'           accept_latitude      = TO_NUMBER(:APP_LATITUDE),',
'           accept_longitude     = TO_NUMBER(:APP_LONGITUDE),',
'           modified_by     = NVL(V(''APP_USER''), USER),',
'           modified_date   = CURRENT_TIMESTAMP',
'    WHERE  permit_id = :P5_PERMIT_ID;',
'',
'    COMMIT;',
'',
'    apex_application.g_print_success_message :=',
'        CASE WHEN :REQUEST = ''AUTHORISE''',
'             THEN ''Permit '' || :P5_PERMIT_NUMBER || '' has been authorised.''',
'             ELSE ''Permit '' || :P5_PERMIT_NUMBER || '' saved successfully.''',
'        END;',
'',
'    :P5_WORKFLOW_STATUS := ''AUTHORISED'';',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_error.add_error(',
'            p_message => ''Error saving authorisation data: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P5_WORKFLOW_STATUS'
,p_process_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_process_when2=>'DRAFT'
,p_internal_uid=>27356922514033440
,p_created_on=>wwv_flow_imp.dz('20260214120339Z')
,p_updated_on=>wwv_flow_imp.dz('20260829150811Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
