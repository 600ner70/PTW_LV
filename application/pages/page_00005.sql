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
'    initPad(''authSignaturePad'',   ''P5_AUTH_SIGNATURE_DATA'',   function(pad) { authSignaturePad = pad; });',
'    initPad(''acceptSignaturePad'', ''P5_ACCEPT_SIGNATURE_DATA'', function(pad) { acceptSignaturePad = pad; });',
'}',
'',
'function initPad(canvasId, itemName, callback) {',
'    const canvas = document.getElementById(canvasId);',
'    if (!canvas) return;',
'',
'    const container     = canvas.parentElement;',
'    const displayWidth  = container ? container.offsetWidth - 20 : 300;',
'',
'    // Determine height purely from screen width - no CSS interference',
'    const screenWidth   = window.innerWidth;',
'    const displayHeight = screenWidth < 768 ? 100 : 150;',
'',
'    const dpr = window.devicePixelRatio || 1;',
'',
'    // Set canvas internal pixel dimensions',
'    canvas.width  = displayWidth  * dpr;',
'    canvas.height = displayHeight * dpr;',
'',
'    // Force inline style - overrides everything',
'    canvas.setAttribute(''style'',',
'        ''width:''  + displayWidth  + ''px !important;'' +',
'        ''height:'' + displayHeight + ''px !important;'' +',
'        ''border: 1px dashed #ccc;'' +',
'        ''border-radius: 4px;'' +',
'        ''touch-action: none;'' +',
'        ''cursor: crosshair;'' +',
'        ''display: block;''',
'    );',
'',
'    const ctx = canvas.getContext(''2d'');',
'    ctx.setTransform(1, 0, 0, 1, 0, 0);',
'    ctx.scale(dpr, dpr);',
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
'    this.canvas = canvas;',
'    this.ctx = ctx;',
'    this.drawing = false;',
'    this.isEmpty = true;',
'',
'    this.ctx.strokeStyle = ''#000000'';',
'    this.ctx.lineWidth = 2;',
'    this.ctx.lineCap = ''round'';',
'    this.ctx.lineJoin = ''round'';',
'',
'    this.canvas.addEventListener(''mousedown'', (e) => this.startDrawing(e));',
'    this.canvas.addEventListener(''mousemove'', (e) => this.draw(e));',
'    this.canvas.addEventListener(''mouseup'', () => this.stopDrawing());',
'    this.canvas.addEventListener(''mouseout'', () => this.stopDrawing());',
'',
'    this.canvas.addEventListener(''touchstart'', (e) => {',
'        e.preventDefault();',
'        this.startDrawing(e.touches[0]);',
'    });',
'    this.canvas.addEventListener(''touchmove'', (e) => {',
'        e.preventDefault();',
'        this.draw(e.touches[0]);',
'    });',
'    this.canvas.addEventListener(''touchend'', () => this.stopDrawing());',
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
'    this.stopDrawing = function() {',
'        this.drawing = false;',
'    };',
'',
'    this.clear = function() {',
'        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);',
'        this.isEmpty = true;',
'    };',
'',
'    this.getDataURL = function() {',
'        if (this.isEmpty) return '''';',
'        return this.canvas.toDataURL(''image/png'');',
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
'    if (!dataURL) return;',
'    const img = new Image();',
'    img.onload = function() {',
'        const displayWidth  = parseFloat(canvas.style.width)  || canvas.offsetWidth  || 300;',
'        const displayHeight = parseFloat(canvas.style.height) || canvas.offsetHeight || 100;',
'',
'        if (displayWidth === 0 || displayHeight === 0) {',
'            console.warn(''loadSignature: zero dimensions on '' + canvas.id);',
'            return;',
'        }',
'',
'        pad.ctx.clearRect(0, 0, displayWidth, displayHeight);',
'        pad.ctx.drawImage(img, 0, 0, displayWidth, displayHeight);',
'        pad.isEmpty = false;',
'    };',
'    img.onerror = function() {',
'        console.warn(''loadSignature: failed to load image for '' + canvas.id);',
'    };',
'    img.src = dataURL;',
'}',
'',
'function saveSignatures() {',
'    if (authSignaturePad && !authSignaturePad.isEmpty) {',
'        apex.item(''P5_AUTH_SIGNATURE_DATA'').setValue(authSignaturePad.getDataURL());',
'    }',
'    if (acceptSignaturePad && !acceptSignaturePad.isEmpty) {',
'        apex.item(''P5_ACCEPT_SIGNATURE_DATA'').setValue(acceptSignaturePad.getDataURL());',
'    }',
'}',
'',
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
'function setPageReadOnly() {',
'    const status = $v(''P5_WORKFLOW_STATUS'');',
'    const isReadOnly = (status !== ''IN_PROGRESS'' && status !== '''');',
'    ',
'    if (!isReadOnly) return;',
'',
'    // Disable signature canvases',
'    [''authSignaturePad'', ''acceptSignaturePad''].forEach(function(id) {',
'        const canvas = document.getElementById(id);',
'        if (canvas) {',
'            canvas.style.pointerEvents = ''none'';',
'            canvas.style.opacity       = ''0.6'';',
'            canvas.style.cursor        = ''not-allowed'';',
'            canvas.title               = ''This permit is read-only'';',
'        }',
'    });',
'',
'    // Hide clear signature buttons',
'    document.querySelectorAll(''.signature-controls button'').forEach(function(btn) {',
'        btn.style.display = ''none'';',
'    });',
'',
'    // Hide submit buttons by Static ID',
'    $(''#BTN_SAVE_DRAFT'').hide();',
'}'))
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'$(document).ready(function() {',
'    initSignaturePads();',
'    setPageReadOnly();',
'    updateConnectionUI();',
'',
'    window.addEventListener(''online'', updateConnectionUI);',
'    window.addEventListener(''offline'', updateConnectionUI);',
'});',
'',
'// Save signatures before page submits',
'apex.jQuery(document).on(''apexbeforepagesubmit'', function() {',
'    saveSignatures();',
'});',
'',
'// Initialize offline storage',
'OfflineStorage.initDB();',
'ConnectionManager.init();',
'',
'// Offline handler for SAVE_DRAFT button - capture phase',
'(function() {',
'    var btn = document.querySelector(''[data-otel-label="SAVE_DRAFT"]'');',
'    if (!btn) return;',
'    btn.addEventListener(''click'', function(e) {',
'        if (navigator.onLine) return;',
'        e.stopImmediatePropagation();',
'        e.preventDefault();',
'        var formData = {};',
'        apex.jQuery(''form'').serializeArray().forEach(function(i) { ',
'            formData[i.name] = i.value; ',
'        });',
'        OfflineStorage.saveFormData(''5'', formData, apex.jQuery(''#P5_PERMIT_ID'').val() || null)',
'            .then(function() {',
'                apex.message.showPageSuccess(''Data saved offline. Will sync when reconnected.'');',
'            })',
'            .catch(function(err) {',
'                apex.message.showErrors([{',
'                    type: ''error'', ',
'                    message: ''Offline save error: '' + err.message',
'                }]);',
'            });',
'    }, true);',
'}());',
'',
'window.addEventListener(''resize'', function() {',
'    setTimeout(function() {',
'        const authSig   = $v(''P5_AUTH_SIGNATURE_DATA'');',
'        const acceptSig = $v(''P5_ACCEPT_SIGNATURE_DATA'');',
'        initSignaturePads();',
'        if (authSig)   apex.item(''P5_AUTH_SIGNATURE_DATA'').setValue(authSig);',
'        if (acceptSig) apex.item(''P5_ACCEPT_SIGNATURE_DATA'').setValue(acceptSig);',
'    }, 300);',
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
'    .signature-pad {',
'        height: 100px;',
'    }',
'}',
'',
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
'    /* NO height here - JavaScript controls this */',
'    border: 1px dashed #ccc;',
'    border-radius: 4px;',
'    touch-action: none;',
'    cursor: crosshair;',
'    display: block;',
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
'}',
'',
'.declaration-box {',
'    padding: 15px;',
'    background: #f8f9fa;',
'    border-left: 4px solid #003366;',
'    border-radius: 4px;',
'    margin-bottom: 15px;',
'    font-size: 0.9rem;',
'    line-height: 1.6;',
'}',
'',
'.geo-info {',
'    font-size: 0.75rem;',
'    color: #999;',
'    margin-top: 5px;',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_read_only_when=>'P5_WORKFLOW_STATUS'
,p_read_only_when2=>'IN_PROGRESS'
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27354510223033416)
,p_plug_name=>'Workflow Progress'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>150
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="ptw-workflow-progress">',
'    <div class="workflow-step completed" data-step="1">',
'        <span class="step-icon">&#10003;</span>',
'        <span class="step-text">Site & Work Details</span>',
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
'</div>',
''))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27354649096033417)
,p_plug_name=>'Authorisation Declaration'
,p_title=>'Authorisation of this Permit to Work'
,p_icon_css_classes=>'fa-certificate'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>190
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="declaration-box">',
'    <strong>Authorisation of this Permit to Work:</strong> I have reviewed all aspects of the task/activity and I am satisfied with the arrangements as detailed within the relevant risk assessment and method statement that have been put in place and '
||'certify that this activity detailed is authorised to proceed. Suitable insurance is in place, (employers and public liability).',
'</div>',
'',
' '))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27354749922033418)
,p_plug_name=>'Authorisation Fields'
,p_title=>'Authorised Person Details'
,p_icon_css_classes=>'fa-signature'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>200
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27355228671033423)
,p_plug_name=>'AuthSignature'
,p_parent_plug_id=>wwv_flow_imp.id(27354749922033418)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>60
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="signature-pad-container">',
'    <canvas id="authSignaturePad" class="signature-pad"></canvas>',
'    <div class="signature-controls">',
'        <button type="button" onclick="clearAuthSignature()">Clear</button>',
'    </div>',
'    <div class="geo-info" id="authGeoInfo"></div>',
'</div>',
''))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27355431661033425)
,p_plug_name=>'Acceptance Fields'
,p_title=>'Person in Charge of Works Details'
,p_icon_css_classes=>'fa-signature'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>180
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
,p_plug_display_sequence=>50
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
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>170
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="declaration-box">',
'    <strong>Acceptance of this Permit to Work:</strong> I certify that I am competent to supervise and undertake the works detailed within this Permit to Work and have read and fully understand the documentation associated with this work activity. I '
||'am satisfied that those personnel who will be employed on the task are properly equipped and understand the relevant safety and emergency procedures to be followed and are competent to carry out these works.',
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
,p_plug_display_sequence=>210
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
,p_plug_display_sequence=>140
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
,p_plug_display_sequence=>160
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
 p_id=>wwv_flow_imp.id(27356376023033434)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(27356182588033432)
,p_button_name=>'SAVE_DRAFT'
,p_button_static_id=>'BTN_SAVE_DRAFT_P5'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Save Draft'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(31606655096440628)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(27356182588033432)
,p_button_name=>'START_PERMIT'
,p_button_static_id=>'BTN_START_PERMIT_P5'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Start Permit'
,p_button_position=>'NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:::'
,p_button_condition=>'P5_AUTH_SIGNATURE_DATA'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-clipboard-check'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(27356401274033435)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(27356182588033432)
,p_button_name=>'NEXT_STEP'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Next Step'
,p_button_position=>'NEXT'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-arrow-right'
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
 p_id=>wwv_flow_imp.id(27357123316033442)
,p_branch_name=>'Refresh Current Page'
,p_branch_action=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5:P5_PERMIT_ID:&P5_PERMIT_ID.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_branch_condition=>'SAVE_DRAFT'
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
 p_id=>wwv_flow_imp.id(27354800372033419)
,p_name=>'P5_AUTH_PERSON_NAME'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(27354749922033418)
,p_prompt=>'Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
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
 p_id=>wwv_flow_imp.id(27354949910033420)
,p_name=>'P5_AUTH_PERSON_MOBILE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(27354749922033418)
,p_prompt=>'Mobile Tel No.'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>50
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
 p_id=>wwv_flow_imp.id(27355610155033427)
,p_name=>'P5_ACCEPT_PERSON_NAME'
,p_item_sequence=>10
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
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27355762469033428)
,p_name=>'P5_ACCEPT_PERSON_MOBILE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(27355431661033425)
,p_prompt=>'Mobile Tel. No.'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27355874180033429)
,p_name=>'P5_ACCEPT_COMPANY'
,p_item_sequence=>30
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
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27355946358033430)
,p_name=>'P5_ACCEPT_DATETIME'
,p_item_sequence=>40
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
  'send_on_page_submit', 'Y',
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
,p_validation=>'P5_AUTH_PERSON_NAME'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Authorised person name is required.'
,p_validation_condition=>'START_PERMIT'
,p_validation_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(27356727784033438)
,p_validation_name=>'Auth Signature Required'
,p_validation_sequence=>30
,p_validation=>'P5_AUTH_SIGNATURE_DATA'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Authorised person signature is required.'
,p_validation_condition=>'START_PERMIT'
,p_validation_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(31606875799440630)
,p_name=>'Check Status of Page'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(27356376023033434)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(31606997498440631)
,p_event_id=>wwv_flow_imp.id(31606875799440630)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P5_IS_CHANGED'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if (apex.page.isChanged()) {',
'    // do something, e.g. enable a save button',
'    apex.item(''P5_IS_CHANGED'').setValue(''Y'');',
'} else {',
'    apex.item(''P5_IS_CHANGED'').setValue(''N'');',
'}'))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(31607081770440632)
,p_event_id=>wwv_flow_imp.id(31606875799440630)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'NULL;'
,p_attribute_02=>'P5_IS_CHANGED'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(31607101265440633)
,p_event_id=>wwv_flow_imp.id(31606875799440630)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'captureLocationThenSubmit(''SAVE_DRAFT'');'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(31607259171440634)
,p_name=>'Save Signatures'
,p_event_sequence=>30
,p_bind_type=>'bind'
,p_bind_event_type=>'apexbeforepagesubmit'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(31607385457440635)
,p_event_id=>wwv_flow_imp.id(31607259171440634)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'saveSignatures();'
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
'--    IF :P5_IS_CHANGED = ''Y'' THEN',
'',
'      UPDATE ptw_pro.ptw_lv_permits',
'      SET auth_person_name = :P5_AUTH_PERSON_NAME,',
'          auth_person_signature = v_auth_sig_blob,',
'          auth_person_mobile = :P5_AUTH_PERSON_MOBILE,',
'--          auth_from_datetime = TO_DATE(:P5_AUTH_FROM_DATETIME, ''DD-MON-YYYY HH24:MI''),',
'--          auth_to_datetime = TO_DATE(:P5_AUTH_TO_DATETIME, ''DD-MON-YYYY HH24:MI''),',
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
'          modified_by = NVL(V(''APP_USER''), USER),',
'          modified_date = CURRENT_TIMESTAMP',
'      WHERE permit_id = :P5_PERMIT_ID;',
'',
'      COMMIT;',
'--    END IF;',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_error.add_error(',
'            p_message => ''Error saving authorisation data: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RAISE;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>':REQUEST IN (''SAVE_DRAFT'',''NEXT_STEP'',''START_PERMIT'')'
,p_process_when_type=>'EXPRESSION'
,p_process_when2=>'PLSQL'
,p_process_success_message=>'Authorisation and acceptance data saved.'
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
'        accept_person_name,',
'        accept_person_mobile,',
'        accept_company,',
'        TO_CHAR(accept_datetime,''DD-MON-YYYY HH24:MI''),',
'        accept_latitude,',
'        accept_longitude,',
'        workflow_status',
'    INTO',
'        :P5_PERMIT_NUMBER,',
'        :P5_AUTH_PERSON_NAME,',
'        :P5_AUTH_PERSON_MOBILE,',
'        :P5_AUTH_LATITUDE,',
'        :P5_AUTH_LONGITUDE,',
'        :P5_ACCEPT_PERSON_NAME,',
'        :P5_ACCEPT_PERSON_MOBILE,',
'        :P5_ACCEPT_COMPANY,',
'        :P5_ACCEPT_DATETIME,',
'        :P5_ACCEPT_LATITUDE,',
'        :P5_ACCEPT_LONGITUDE,',
'        :P5_WORKFLOW_STATUS',
'    FROM ptw_pro.ptw_lv_permits',
'    WHERE permit_id = :P5_PERMIT_ID;',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        :P5_ACCEPT_DATETIME := TO_CHAR(SYSDATE,''DD-MON-YYYY HH24:MI'');',
'END;',
'',
'BEGIN',
'  SELECT',
'    CASE',
'      WHEN auth_person_signature IS NOT NULL AND DBMS_LOB.GETLENGTH(auth_person_signature) > 0 THEN',
'        ''data:image/png;base64,'' || apex_web_service.blob2clobbase64(auth_person_signature)',
'      ELSE NULL',
'    END,',
'    CASE',
'      WHEN accept_person_signature IS NOT NULL AND DBMS_LOB.GETLENGTH(accept_person_signature) > 0 THEN',
'        ''data:image/png;base64,'' || apex_web_service.blob2clobbase64(accept_person_signature)',
'      ELSE NULL',
'    END',
'    INTO',
'     :P5_AUTH_SIGNATURE_DATA,',
'     :P5_ACCEPT_SIGNATURE_DATA',
'  FROM ptw_pro.ptw_lv_permits',
'  WHERE permit_id = :P5_PERMIT_ID;',
'EXCEPTION',
'  WHEN NO_DATA_FOUND THEN NULL;',
'END;',
'',
'-- Load existing signatures as base64',
'BEGIN',
'  SELECT ur.mobile_no, ur.first_name||'' ''||ur.last_name',
'  INTO   :P5_AUTH_PERSON_MOBILE, :P5_ACCEPT_PERSON_NAME',
'  FROM   apex_workspace_apex_users au',
'  LEFT JOIN ptw_pro.ptw_lv_user_roles ur ON UPPER(au.user_name) = UPPER(ur.username)',
'    AND ur.is_active = ''Y''',
'  WHERE UPPER(ur.username) = UPPER(NVL(V(''APP_USER''), USER))',
'  AND   au.workspace_name = (SELECT workspace ',
'                             FROM   apex_applications',
'                             WHERE  application_id = :APP_ID);',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    NULL;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>27356851819033439
);
wwv_flow_imp.component_end;
end;
/
