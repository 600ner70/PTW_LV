prompt --application/pages/page_00005
begin
--   Manifest
--     PAGE: 00005
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.14'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PERMITPRO'
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
'function initPad(canvasId, itemName, callback) {',
'    const canvas = document.getElementById(canvasId);',
'    if (!canvas) return;',
'',
'    const regionBody   = canvas.closest(''.t-Region-body'') || canvas.closest(''.t-ContentBody'') || canvas.parentElement;',
'    const displayWidth = regionBody ? regionBody.offsetWidth - 24 : 300;',
'    const screenWidth  = window.innerWidth;',
'    const displayHeight = screenWidth < 768 ? 100 : 150;',
'',
'    // No DPR scaling - keep it simple, 1:1 pixel ratio',
'    canvas.width  = displayWidth;',
'    canvas.height = displayHeight;',
'',
'    canvas.setAttribute(''style'',',
'        ''width:''  + displayWidth  + ''px !important;'' +',
'        ''height:'' + displayHeight + ''px !important;'' +',
'        ''border: 1px dashed var(--ut-component-border-color, #ccc);'' +',
'        ''border-radius: 4px;'' +',
'        ''touch-action: none;'' +',
'        ''cursor: crosshair;'' +',
'        ''display: block;''',
'    );',
'',
'    const ctx = canvas.getContext(''2d'');',
'    ctx.strokeStyle = ''#000000'';',
'    ctx.lineWidth   = 2;',
'    ctx.lineCap     = ''round'';',
'    ctx.lineJoin    = ''round'';',
'',
'    const pad = new SignaturePad(canvas, ctx);',
'    callback(pad);',
'',
'    const existingSig = $v(itemName);',
'    if (existingSig) {',
'        loadSignature(pad, canvas, existingSig);',
'    }',
'}',
'',
'function SignaturePad(canvas, ctx) {',
'    this.canvas  = canvas;',
'    this.ctx     = ctx;',
'    this.drawing = false;',
'    this.isEmpty = true;',
'',
'    this.ctx.strokeStyle = ''#000000'';',
'    this.ctx.lineWidth   = 2;',
'    this.ctx.lineCap     = ''round'';',
'    this.ctx.lineJoin    = ''round'';',
'',
'    this.canvas.addEventListener(''mousedown'',  (e) => this.startDrawing(e));',
'    this.canvas.addEventListener(''mousemove'',  (e) => this.draw(e));',
'    this.canvas.addEventListener(''mouseup'',    ()  => this.stopDrawing());',
'    this.canvas.addEventListener(''mouseout'',   ()  => this.stopDrawing());',
'',
'    this.canvas.addEventListener(''touchstart'', (e) => { e.preventDefault(); this.startDrawing(e.touches[0]); });',
'    this.canvas.addEventListener(''touchmove'',  (e) => { e.preventDefault(); this.draw(e.touches[0]); });',
'    this.canvas.addEventListener(''touchend'',   ()  => this.stopDrawing());',
'',
'    this.startDrawing = function(e) {',
'        this.drawing = true;',
'        this.isEmpty = false;',
'        const rect = this.canvas.getBoundingClientRect();',
'        this.ctx.beginPath();',
'        this.ctx.moveTo(e.clientX - rect.left, e.clientY - rect.top);',
'    };',
'',
'    this.draw = function(e) {',
'        if (!this.drawing) return;',
'        const rect = this.canvas.getBoundingClientRect();',
'        this.ctx.lineTo(e.clientX - rect.left, e.clientY - rect.top);',
'        this.ctx.stroke();',
'    };',
'',
'    this.stopDrawing = function() { this.drawing = false; };',
'',
'    this.clear = function() {',
'        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);',
'        this.isEmpty = true;',
'    };',
'',
'    this.getDataURL = function() {',
'        return this.isEmpty ? '''' : this.canvas.toDataURL(''image/png'');',
'    };',
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
'function loadSignature(pad, canvas, dataURL) {',
'    if (!pad || !dataURL) return;',
'    const img = new Image();',
'    img.onload = function() {',
'        const dw = canvas.width;',
'        const dh = canvas.height;',
'        if (dw === 0 || dh === 0) return;',
'        pad.ctx.clearRect(0, 0, dw, dh);',
'        pad.ctx.drawImage(img, 0, 0, dw, dh);',
'        pad.isEmpty = false;',
'    };',
'    img.src = dataURL;',
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
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_read_only_when=>'P5_WORKFLOW_STATUS'
,p_read_only_when2=>'IN_PROGRESS'
,p_page_component_map=>'25'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27354510223033416)
,p_plug_name=>'Workflow Progress'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>180
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="ptw-workflow-progress">',
'    <div class="workflow-step completed" data-step="1">',
'        <span class="step-icon">&#10003;</span>',
'        <span class="step-text">Site &amp; Work Details</span>',
'    </div>',
'    <div class="workflow-step completed" data-step="2">',
'        <span class="step-icon">&#10003;</span>',
'        <span class="step-text">Control Measures</span>',
'    </div>',
'    <div class="workflow-step completed" data-step="3">',
'        <span class="step-icon">&#10003;</span>',
'        <span class="step-text">Equipment Isolation</span>',
'    </div>',
'    <div class="workflow-step active" data-step="4">',
'        <span class="step-icon">4</span>',
'        <span class="step-text">Authorisation</span>',
'    </div>',
'    <div class="workflow-step" data-step="5">',
'        <span class="step-icon">5</span>',
'        <span class="step-text">Clearance</span>',
'    </div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27354649096033417)
,p_plug_name=>'Authorisation Declaration'
,p_title=>'Authorisation of this Permit to Work'
,p_icon_css_classes=>'fa-certificate'
,p_region_template_options=>'#DEFAULT#:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>220
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="ptw-section-card">',
'    <div class="ptw-section-body">',
'        <div class="declaration-box">',
'            <strong>Authorisation of this Permit to Work:</strong>',
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
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(37954746372176008)
,p_plug_name=>'Role & Permit Status'
,p_title=>'Role & Permit Status'
,p_parent_plug_id=>wwv_flow_imp.id(27354649096033417)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    -- v_role          VARCHAR2(50);',
'    -- v_can_authorise BOOLEAN       := FALSE;',
'    v_from_dt       DATE;',
'    v_to_dt         DATE;',
'    v_now           DATE          := SYSDATE;',
'    v_clob          CLOB          := '''';',
'BEGIN',
'    -- Get the current user''s PTW role',
'    -- BEGIN',
'    --     SELECT role_name',
'    --     INTO   v_role',
'    --     FROM   ptw_pro.ptw_lv_user_roles',
'    --     WHERE  UPPER(username) = UPPER(V(''APP_USER''))',
'    --     AND    is_active        = ''Y''',
'    --     AND    ROWNUM           = 1;',
'    -- EXCEPTION',
'    --     WHEN NO_DATA_FOUND THEN v_role := NULL;',
'    -- END;',
'',
'    -- v_can_authorise := v_role IN (''ADMIN'', ''AUTHORISER'');',
'',
'    -- Get permit validity window if set',
'    BEGIN',
'        SELECT auth_from_datetime, auth_to_datetime',
'        INTO   v_from_dt, v_to_dt',
'        FROM   ptw_pro.ptw_lv_permits',
'        WHERE  permit_id = :P5_PERMIT_ID;',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN NULL;',
'    END;',
'',
'    -- Role message',
'    -- IF v_can_authorise THEN',
'        -- v_clob := v_clob ||',
'        --     ''<div class="t-Alert t-Alert--success t-Alert--horizontal margin-bottom-sm" role="region">'' ||',
'        --     ''  <div class="t-Alert-wrap">'' ||',
'        --     ''    <div class="t-Alert-icon"><span class="t-Icon fa fa-check-circle"></span></div>'' ||',
'        --     ''    <div class="t-Alert-content">'' ||',
'        --     ''      <div class="t-Alert-body">You have <strong>'' || APEX_ESCAPE.HTML(v_role) || ''</strong>'' ||',
'        --     ''      permission &mdash; you may sign off this permit.</div>'' ||',
'        --     ''    </div>'' ||',
'        --     ''  </div>'' ||',
'        --     ''</div>'';',
'    -- ELSE',
'    --     v_clob := v_clob ||',
'    --         ''<div class="t-Alert t-Alert--warning t-Alert--horizontal margin-bottom-sm" role="region">'' ||',
'    --         ''  <div class="t-Alert-wrap">'' ||',
'    --         ''    <div class="t-Alert-icon"><span class="t-Icon fa fa-warning"></span></div>'' ||',
'    --         ''    <div class="t-Alert-content">'' ||',
'    --         ''      <div class="t-Alert-body">Your role does not permit authorisation.'' ||',
'    --         ''      Select an authorised person from the list below.</div>'' ||',
'    --         ''    </div>'' ||',
'    --         ''  </div>'' ||',
'    --         ''</div>'';',
'    -- END IF;',
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
'            v_clob := v_clob || ''From '' || TO_CHAR(v_from_dt, ''DD-Mon-YYYY HH24:MI'');',
'        END IF;',
'',
'        IF v_to_dt IS NOT NULL THEN',
'            v_clob := v_clob || '' &nbsp;&mdash;&nbsp; To '' || TO_CHAR(v_to_dt, ''DD-Mon-YYYY HH24:MI'');',
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
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27354749922033418)
,p_plug_name=>'Authorisation Fields'
,p_title=>'Authorised Person Details'
,p_icon_css_classes=>'fa-signature'
,p_region_template_options=>'#DEFAULT#:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>230
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27355228671033423)
,p_plug_name=>'AuthSignature'
,p_title=>'Signature - Authorised Person'
,p_parent_plug_id=>wwv_flow_imp.id(27354749922033418)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>50
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="signature-pad-container">',
'    <canvas id="authSignaturePad" class="signature-pad"></canvas>',
'    <div class="signature-controls">',
'        <button type="button" onclick="clearAuthSignature()">Clear</button>',
'    </div>',
'    <div class="geo-info" id="authGeoInfo"></div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27355431661033425)
,p_plug_name=>'Acceptance Fields'
,p_title=>'Person in Charge of Works Details'
,p_icon_css_classes=>'fa-signature'
,p_region_template_options=>'#DEFAULT#:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>210
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27356002085033431)
,p_plug_name=>'AccSignature'
,p_parent_plug_id=>wwv_flow_imp.id(27355431661033425)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>70
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="signature-pad-container">',
'    <canvas id="acceptSignaturePad" class="signature-pad"></canvas>',
'    <div class="signature-controls">',
'        <button type="button" onclick="clearAcceptSignature()">Clear</button>',
'    </div>',
'    <div class="geo-info" id="acceptGeoInfo"></div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27355547264033426)
,p_plug_name=>'Acceptance Declaration'
,p_title=>'Acceptance of this Permit to Work'
,p_icon_css_classes=>'fa-handshake-o'
,p_region_template_options=>'#DEFAULT#:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>200
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="ptw-section-card">',
'    <div class="ptw-section-body">',
'        <div class="declaration-box">',
'            <strong>Acceptance of this Permit to Work:</strong>',
'            I certify that I am competent to supervise and undertake the works',
'            detailed within this Permit to Work and have read and fully understand',
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
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27356182588033432)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>240
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(59751115845944493)
,p_plug_name=>'SyncStatus'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>170
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
 p_id=>wwv_flow_imp.id(59754344828705381)
,p_plug_name=>'Permit Information Badge'
,p_plug_display_sequence=>190
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
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(31606655096440628)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(27356182588033432)
,p_button_name=>'AUTHORISE'
,p_button_static_id=>'BTN_START_PERMIT_P5'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Authorise Permit'
,p_button_position=>'NEXT'
,p_icon_css_classes=>'fa-clipboard-check'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(27356264505033433)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(27356182588033432)
,p_button_name=>'BACK'
,p_button_static_id=>'BTN_BACK_P5'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Back'
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:4:P4_PERMIT_ID:&P5_PERMIT_ID.'
,p_icon_css_classes=>'fa-arrow-left'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(37958944543176050)
,p_branch_name=>'Go To Page 9'
,p_branch_action=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:9:P9_PERMIT_ID,P9_PERMIT_NUMBER:&P5_PERMIT_ID.,&P5_PERMIT_NUMBER.'
,p_branch_point=>'BEFORE_COMPUTATION'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(31606655096440628)
,p_branch_sequence=>20
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27353728149033408)
,p_name=>'P5_PERMIT_ID'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27353854481033409)
,p_name=>'P5_PERMIT_NUMBER'
,p_item_sequence=>70
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27353970594033410)
,p_name=>'P5_AUTH_SIGNATURE_DATA'
,p_item_sequence=>80
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27354075256033411)
,p_name=>'P5_ACCEPT_SIGNATURE_DATA'
,p_item_sequence=>90
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27354116465033412)
,p_name=>'P5_AUTH_LATITUDE'
,p_item_sequence=>100
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27354271702033413)
,p_name=>'P5_AUTH_LONGITUDE'
,p_item_sequence=>110
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27354339224033414)
,p_name=>'P5_ACCEPT_LATITUDE'
,p_item_sequence=>120
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27354445860033415)
,p_name=>'P5_ACCEPT_LONGITUDE'
,p_item_sequence=>130
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27354949910033420)
,p_name=>'P5_AUTH_PERSON_MOBILE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(27354749922033418)
,p_prompt=>'Mobile Tel No.'
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
 p_id=>wwv_flow_imp.id(27355610155033427)
,p_name=>'P5_ACCEPT_PERSON_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(27355431661033425)
,p_prompt=>'Name'
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
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27355762469033428)
,p_name=>'P5_ACCEPT_PERSON_MOBILE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(27355431661033425)
,p_prompt=>'Mobile Tel. No.'
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
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27355874180033429)
,p_name=>'P5_ACCEPT_COMPANY'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(27355431661033425)
,p_prompt=>'Company'
,p_source=>'The Company Limited'
,p_source_type=>'STATIC'
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
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27355946358033430)
,p_name=>'P5_ACCEPT_DATETIME'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(27355431661033425)
,p_item_default=>'SELECT TO_CHAR(SYSDATE,''DD-MON-YYYY HH24:MI'') FROM dual;'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Date & Time'
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
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30143518277642704)
,p_name=>'P5_IS_CHANGED'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30143615815642705)
,p_name=>'P5_CURRENT_STEP'
,p_item_sequence=>50
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(31607494167440636)
,p_name=>'P5_WORKFLOW_STATUS'
,p_item_sequence=>60
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(33350836721951422)
,p_name=>'P5_USER_CAN_AUTHORISE'
,p_item_sequence=>140
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(33351141764951425)
,p_name=>'P5_AUTH_DATETIME'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(27354749922033418)
,p_prompt=>'Authorisation Date'
,p_format_mask=>'DD-MON-YYYY HH24:MI'
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
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(33352343405951437)
,p_name=>'P5_AUTH_PERSON_SELECT'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(27354749922033418)
,p_prompt=>'Authorising person'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'PTW_AUTHORISED_PERSONS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT u.first_name || '' '' || u.last_name || '' ('' || u.role_name || '')'' AS display_value,',
'       u.role_id                                                        AS return_value,',
'       mobile_no',
'FROM   ptw_pro.ptw_lv_user_roles u',
'WHERE  u.role_name IN (''ADMIN'', ''AUTHORISER'')',
'AND    u.is_active = ''Y''',
'ORDER BY u.last_name, u.first_name;'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-- Select Authorising Person --'
,p_cHeight=>1
,p_colspan=>6
,p_display_when=>'P5_WORKFLOW_STATUS'
,p_display_when2=>'IN_PROGRESS'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(37955311718176014)
,p_name=>'P5_AUTH_PERSON_DISPLAY'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(27354749922033418)
,p_prompt=>'Authorising Person'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_display_when=>'P5_WORKFLOW_STATUS'
,p_display_when2=>'IN_PROGRESS'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(37955698093176017)
,p_name=>'P5_AUTH_TO_DATETIME'
,p_item_sequence=>150
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(37955773514176018)
,p_name=>'P5_AUTH_FROM_DATETIME'
,p_item_sequence=>160
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(27356512824033436)
,p_validation_name=>'Permit ID Required'
,p_validation_sequence=>10
,p_validation=>'P5_PERMIT_ID'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Permit ID is required.'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(27356670959033437)
,p_validation_name=>'Auth Person Name Required'
,p_validation_sequence=>20
,p_validation=>'P5_AUTH_PERSON_SELECT'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Authorised person name is required.'
,p_when_button_pressed=>wwv_flow_imp.id(31606655096440628)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(33351958224951433)
,p_validation_name=>'Auth TO Datetime Required'
,p_validation_sequence=>22
,p_validation=>'P5_AUTH_TO_DATETIME'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Permit expiry date and time (TO) is required.'
,p_validation_condition_type=>'NEVER'
,p_when_button_pressed=>wwv_flow_imp.id(31606655096440628)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(33352170367951435)
,p_validation_name=>'No Self-Authorisation'
,p_validation_sequence=>27
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'  DECLARE',
'    l_name VARCHAR2(200);',
'  BEGIN',
'    BEGIN',
'      SELECT first_name || '' '' || last_name',
'      INTO   l_name',
'      FROM   ptw_pro.ptw_lv_user_roles',
'      WHERE  role_id = :P5_AUTH_PERSON_SELECT;',
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
,p_when_button_pressed=>wwv_flow_imp.id(31606655096440628)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(33352284097951436)
,p_validation_name=>'Current User Must Be Authoriser'
,p_validation_sequence=>28
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_count NUMBER;',
'BEGIN',
'    SELECT COUNT(*) INTO v_count',
'    FROM   ptw_pro.ptw_lv_user_roles',
'    WHERE  UPPER(username) = UPPER(V(''APP_USER''))',
'    AND    role_name IN (''ADMIN'', ''AUTHORISER'')',
'    AND    is_active = ''Y'';',
'    RETURN v_count > 0;',
'EXCEPTION',
'    WHEN OTHERS THEN RETURN FALSE;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'You do not have permission to authorise this permit. Only users with the Authoriser or Admin role may sign off.'
,p_validation_condition_type=>'NEVER'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(37958677119176047)
,p_validation_name=>'Accept Signature required'
,p_validation_sequence=>38
,p_validation=>'P5_ACCEPT_SIGNATURE_DATA'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Person in charge signature is required.'
,p_when_button_pressed=>wwv_flow_imp.id(31606655096440628)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(27356727784033438)
,p_validation_name=>'Auth Signature Required'
,p_validation_sequence=>48
,p_validation=>'P5_AUTH_SIGNATURE_DATA'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Authorised person signature is required.'
,p_when_button_pressed=>wwv_flow_imp.id(31606655096440628)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(37958766966176048)
,p_validation_name=>'Accept person cannot be NULL'
,p_validation_sequence=>58
,p_validation=>'P5_ACCEPT_PERSON_NAME'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Person in Charge cannot be blank.'
,p_when_button_pressed=>wwv_flow_imp.id(31606655096440628)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(37958833334176049)
,p_validation_name=>'Auth person cannot be blank'
,p_validation_sequence=>68
,p_validation=>'P5_AUTH_PERSON_DISPLAY'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Must have an Authorising person selected.'
,p_when_button_pressed=>wwv_flow_imp.id(31606655096440628)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(33352838421951442)
,p_name=>'Initialise page'
,p_event_sequence=>2
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33352979633951443)
,p_event_id=>wwv_flow_imp.id(33352838421951442)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Signatures'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'initSignaturePads();',
'',
'// If read-only, disable canvases after pads have initialised',
'setTimeout(function() {',
'    var status = apex.item(''P5_WORKFLOW_STATUS'').getValue();',
'    if (status !== ''IN_PROGRESS'' && status !== '''') {',
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
'}, 250);'))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(37955420884176015)
,p_event_id=>wwv_flow_imp.id(33352838421951442)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'Load the Auth person details'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    SELECT ur.mobile_no,',
'           ur.first_name || '' '' || ur.last_name',
'    INTO   :P5_AUTH_PERSON_MOBILE,',
'           :P5_AUTH_PERSON_DISPLAY',
'    FROM   ptw_pro.ptw_lv_user_roles ur',
'    WHERE  ur.role_id   = :P5_AUTH_PERSON_SELECT;',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        :P5_AUTH_PERSON_MOBILE  := NULL;',
'        :P5_AUTH_PERSON_DISPLAY := NULL;',
'END;'))
,p_attribute_02=>'P5_AUTH_PERSON_SELECT'
,p_attribute_03=>'P5_AUTH_PERSON_DISPLAY,P5_AUTH_PERSON_MOBILE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(37955275603176013)
,p_event_id=>wwv_flow_imp.id(33352838421951442)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_name=>'Load Signatures'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var permitId = apex.item(''P5_PERMIT_ID'').getValue();',
'if (!permitId) { return; }',
'',
'apex.server.process(''GET_SIGNATURES_P5'', ',
'    { pageItems: ''#P5_PERMIT_ID'' },',
'    {',
'        success: function(data) {',
'            if (data.authSig) {',
'                loadSignature(authSignaturePad,',
'                    document.getElementById(''authSignaturePad''),',
'                    ''data:image/png;base64,'' + data.authSig);',
'            }',
'            if (data.acceptSig) {',
'                loadSignature(acceptSignaturePad,',
'                    document.getElementById(''acceptSignaturePad''),',
'                    ''data:image/png;base64,'' + data.acceptSig);',
'            }',
'        },',
'        error: function(xhr) {',
'            console.warn(''GET_SIGNATURES_P5 failed:'', xhr);',
'        }',
'    }',
');'))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33353070566951444)
,p_event_id=>wwv_flow_imp.id(33352838421951442)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_name=>'Connection UI'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'updateConnectionUI();',
'window.addEventListener(''online'',  updateConnectionUI);',
'window.addEventListener(''offline'', updateConnectionUI);',
'',
'window.addEventListener(''resize'', function() {',
'    initSignaturePads();',
'});'))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33353132786951445)
,p_event_id=>wwv_flow_imp.id(33352838421951442)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_name=>'Manage Offline'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'OfflineStorage.initDB();',
'ConnectionManager.init();'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(33351313843951427)
,p_name=>'Check Authoriser Role on Page Load'
,p_event_sequence=>5
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33351491196951428)
,p_event_id=>wwv_flow_imp.id(33351313843951427)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_count NUMBER;',
'BEGIN',
'    SELECT COUNT(*) INTO v_count',
'    FROM   ptw_pro.ptw_lv_user_roles',
'    WHERE  UPPER(username) = UPPER(V(''APP_USER''))',
'    AND    role_name IN (''ADMIN'', ''AUTHORISER'')',
'    AND    is_active = ''Y'';',
'    :P5_USER_CAN_AUTHORISE := CASE WHEN v_count > 0 THEN ''Y'' ELSE ''N'' END;',
'EXCEPTION WHEN OTHERS THEN',
'    :P5_USER_CAN_AUTHORISE := ''N'';',
'END;'))
,p_attribute_03=>'P5_USER_CAN_AUTHORISE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(33351711749951431)
,p_name=>'Start Mode Change'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P5_AUTH_START_MODE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33351848879951432)
,p_event_id=>wwv_flow_imp.id(33351711749951431)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'ptw_onStartModeChange();'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(31607259171440634)
,p_name=>'Save Signatures'
,p_event_sequence=>30
,p_triggering_element_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_element=>'document'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'custom'
,p_bind_event_type_custom=>'apexbeforepagesubmit'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33353206048951446)
,p_event_id=>wwv_flow_imp.id(31607259171440634)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'saveSignatures();',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(33353556837951449)
,p_name=>'Clear Auth Signature Button'
,p_event_sequence=>50
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'#BTN_CLEAR_AUTH_SIG_P5'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33353632247951450)
,p_event_id=>wwv_flow_imp.id(33353556837951449)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'clearAuthSignature();'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(37954011611176001)
,p_name=>'Clear Acceptance Signature Button'
,p_event_sequence=>60
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'#BTN_CLEAR_ACCEPT_SIG_P5'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(37954106363176002)
,p_event_id=>wwv_flow_imp.id(37954011611176001)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'clearAcceptSignature();'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(37954230775176003)
,p_name=>'Set Page Read-Only when not IN_PROGRESS'
,p_event_sequence=>70
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'apex.item(''P5_WORKFLOW_STATUS'').getValue() !== ''IN_PROGRESS'' && apex.item(''P5_WORKFLOW_STATUS'').getValue() !== '''''
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(37954370773176004)
,p_event_id=>wwv_flow_imp.id(37954230775176003)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// // Disable signature canvases',
'// [''authSignaturePad'', ''acceptSignaturePad''].forEach(function(id) {',
'//     var canvas = document.getElementById(id);',
'//     if (canvas) {',
'//         canvas.style.pointerEvents = ''none'';',
'//         canvas.style.opacity       = ''0.6'';',
'//         canvas.style.cursor        = ''not-allowed'';',
'//         canvas.title               = ''This permit is read-only'';',
'//             }',
'//     });',
'// Hide Clear Signature buttons',
'$(''#BTN_CLEAR_AUTH_SIG_P5, #BTN_CLEAR_ACCEPT_SIG_P5'').hide();',
'// Hide Save Draft and Authorise buttons when read-only',
'$(''#BTN_SAVE_DRAFT_P5, #BTN_START_PERMIT_P5'').hide();',
'// Disable all editable items via APEX API',
'apex.item(''P5_AUTH_PERSON_SELECT'').disable();',
'apex.item(''P5_AUTH_DATETIME'').disable();',
'apex.item(''P5_ACCEPT_PERSON_NAME'').disable();',
'apex.item(''P5_ACCEPT_PERSON_COMPANY'').disable();',
'apex.item(''P5_ACCEPT_DATETIME'').disable();',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(37954826633176009)
,p_name=>'Authorisors mobile No load'
,p_event_sequence=>90
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P5_AUTH_PERSON_SELECT'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(37954991974176010)
,p_event_id=>wwv_flow_imp.id(37954826633176009)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'  SELECT mobile_no',
'  INTO   :P5_AUTH_PERSON_MOBILE',
'  FROM   ptw_pro.ptw_lv_user_roles',
'  WHERE  role_id = :P5_AUTH_PERSON_SELECT;',
'EXCEPTION',
'  WHEN NO_DATA_FOUND THEN',
'    NULL;',
'END;'))
,p_attribute_02=>'P5_AUTH_PERSON_SELECT'
,p_attribute_03=>'P5_AUTH_PERSON_MOBILE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(37958295450176043)
,p_name=>'Refresh After Start Permit'
,p_event_sequence=>100
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(27356182588033432)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(37958305888176044)
,p_event_id=>wwv_flow_imp.id(37958295450176043)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(27354510223033416)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(27356922514033440)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save Authorisation and Acceptance Data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_auth_sig_blob BLOB;',
'    v_accept_sig_blob BLOB;',
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
'    v_auth_sig_blob := base64_to_blob(:P5_AUTH_SIGNATURE_DATA);',
'    v_accept_sig_blob := base64_to_blob(:P5_ACCEPT_SIGNATURE_DATA);',
'',
'      UPDATE ptw_pro.ptw_lv_permits',
'      SET auth_person_name = :P5_AUTH_PERSON_SELECT,',
'          auth_person_signature = v_auth_sig_blob,',
'          auth_person_mobile = :P5_AUTH_PERSON_MOBILE,',
'          auth_from_datetime = TO_DATE(:P5_AUTH_FROM_DATETIME, ''DD-MON-YYYY HH24:MI''),',
'          auth_to_datetime = TO_DATE(:P5_AUTH_TO_DATETIME, ''DD-MON-YYYY HH24:MI''),',
'          auth_latitude = :APP_LATITUDE,',
'          auth_longitude = :APP_LONGITUDE,',
'          accept_person_name = :P5_ACCEPT_PERSON_NAME,',
'          accept_person_signature = v_accept_sig_blob,',
'          accept_person_mobile = :P5_ACCEPT_PERSON_MOBILE,',
'          accept_company = :P5_ACCEPT_COMPANY,',
'          accept_datetime = TO_DATE(:P5_ACCEPT_DATETIME,''DD-MON-YYYY HH24:MI''),',
'          accept_latitude = :APP_LATITUDE,',
'          accept_longitude = :APP_LONGITUDE,',
'          workflow_status = ''AUTHORISED'',',
'          current_step = ''AUTHORISATION'',',
'          modified_by = NVL(V(''APP_USER''), USER),',
'          modified_date = CURRENT_TIMESTAMP',
'      WHERE permit_id = :P5_PERMIT_ID;',
'',
'      COMMIT;',
'',
'    apex_application.g_print_success_message :=',
'        CASE WHEN :REQUEST = ''AUTHORISE''',
'             THEN ''Permit '' || :P5_PERMIT_NUMBER || '' has been authorised.''',
'             ELSE ''Permit '' || :P5_PERMIT_NUMBER || '' saved successfully.''',
'        END;',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_error.add_error(',
'            p_message => ''Error saving authorisation data: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'--        RAISE;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(31606655096440628)
,p_internal_uid=>27356922514033440
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(27356851819033439)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load Authorisation and Acceptance Data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    :P5_CURRENT_STEP := ''AUTHORISATION'';',
'    SELECT',
'        permit_number,',
'        auth_person_name,',
'        auth_person_mobile,',
'        auth_latitude,',
'        auth_longitude,',
'        TO_CHAR(auth_from_datetime, ''DD-MON-YYYY HH24:MI''),',
'        accept_person_name,',
'        accept_person_mobile,',
'        accept_company,',
'        TO_CHAR(accept_datetime, ''DD-MON-YYYY HH24:MI''),',
'        accept_latitude,',
'        accept_longitude,',
'        workflow_status',
'    INTO',
'        :P5_PERMIT_NUMBER,',
'        :P5_AUTH_PERSON_SELECT,',
'        :P5_AUTH_PERSON_MOBILE,',
'        :P5_AUTH_LATITUDE,',
'        :P5_AUTH_LONGITUDE,',
'        :P5_AUTH_DATETIME,',
'        :P5_ACCEPT_PERSON_NAME,',
'        :P5_ACCEPT_PERSON_MOBILE,',
'        :P5_ACCEPT_COMPANY,',
'        :P5_ACCEPT_DATETIME,',
'        :P5_ACCEPT_LATITUDE,',
'        :P5_ACCEPT_LONGITUDE,',
'        :P5_WORKFLOW_STATUS',
'    FROM ptw_pro.ptw_lv_permits',
'    WHERE permit_id = :P5_PERMIT_ID;',
'',
'    IF :P5_ACCEPT_DATETIME IS NULL THEN',
'        :P5_ACCEPT_DATETIME := TO_CHAR(SYSDATE, ''DD-MON-YYYY HH24:MI'');',
'    END IF;',
'    IF :P5_AUTH_DATETIME IS NULL THEN',
'        :P5_AUTH_DATETIME := TO_CHAR(SYSDATE, ''DD-MON-YYYY HH24:MI'');',
'    END IF;',
'',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        :P5_ACCEPT_DATETIME := TO_CHAR(SYSDATE, ''DD-MON-YYYY HH24:MI'');',
'        :P5_AUTH_DATETIME := TO_CHAR(SYSDATE, ''DD-MON-YYYY HH24:MI'');',
'        :P5_WORKFLOW_STATUS := ''IN_PROGRESS'';',
'END;',
'',
'IF :P5_ACCEPT_COMPANY IS NULL AND :P5_ACCEPT_PERSON_NAME IS NULL THEN',
'    --',
'    BEGIN',
'      SELECT person_in_charge_name, supervising_company',
'      INTO   :P5_ACCEPT_PERSON_NAME, :P5_ACCEPT_COMPANY',
'      FROM   ptw_pro.ptw_lv_permits',
'      WHERE  permit_id = :P5_PERMIT_ID;',
'    EXCEPTION',
'      WHEN OTHERS THEN',
'        NULL;',
'    END;',
'END IF;',
'',
'',
'',
'',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>27356851819033439
);
wwv_flow_imp.component_end;
end;
/
