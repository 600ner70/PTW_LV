prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
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
 p_id=>1
,p_name=>'Dashboard'
,p_alias=>'HOME'
,p_step_title=>'PTW_PRO'
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
'function ptwDeletePermit(permitId, permitNumber) {',
'    if (!navigator.onLine) {',
'        apex.message.showErrors([{',
'            type: ''error'',',
'            message: ''You are currently offline. Please reconnect to delete a permit.''',
'        }]);',
'        return;',
'    }',
'    apex.message.confirm(''Delete permit '' + permitNumber + ''?'', function(ok) {',
'        if (ok) {',
'            apex.page.submit({ request: ''DELETE_PERMIT_'' + permitId });',
'        }',
'    });',
'}',
'',
'function ptwSuspendPermit(permitId, permitNumber) {',
'    if (!navigator.onLine) {',
'        apex.message.showErrors([{',
'            type: ''error'',',
'            message: ''You are currently offline. Please reconnect to suspend a permit.''',
'        }]);',
'        return;',
'    }',
'    $(''<div id="ptwSuspendDialog">'' +',
'        ''<label style="display:block;font-weight:600;font-size:13px;margin-bottom:8px;color:#333;">'' +',
'          ''Suspension Reason <span style="color:#C0392B">*</span>'' +',
'        ''</label>'' +',
'        ''<input type="text" id="ptwSuspendReason" class="apex-item-text" '' +',
'          ''placeholder="e.g. General alarm, scope change, awaiting parts" />'' +',
'      ''</div>'')',
'          .appendTo(''body'')',
'          .dialog({',
'              title: ''Suspend Permit \u2013 '' + permitNumber,',
'              modal:  true,',
'              width:  500,',
'              dialogClass: ''ptw-apex-dialog'',',
'              buttons: [',
'                  {',
'                      text:  ''Suspend Permit'',',
'                      ''class'': ''t-Button t-Button--hot'',',
'                      click: function() {',
'                          var reason = $(''#ptwSuspendReason'').val();',
'                          if (!reason || reason.trim() === '''') {',
'                              apex.message.alert(''A suspension reason is required.'');',
'                              return;',
'                          }',
'                          apex.item(''P1_SELECTED_PERMIT_ID'').setValue(permitId);',
'                          apex.item(''P1_SUSPEND_REASON'').setValue(reason.trim());',
'                          $(this).dialog(''close'');',
'                          apex.submit({ request: ''SUSPEND_PERMIT_'' + permitId });',
'                      }',
'                  },',
'                  {',
'                      text:  ''Cancel'',',
'                      ''class'': ''t-Button'',',
'                      click: function() { $(this).dialog(''close''); }',
'                  }',
'              ],',
'              close: function() { $(this).dialog(''destroy'').remove(); }',
'          });',
'}',
'',
'function ptwResumePermit(permitId, permitNumber) {',
'    if (!navigator.onLine) {',
'        apex.message.showErrors([{',
'            type: ''error'',',
'            message: ''You are currently offline. Please reconnect to resume a permit.''',
'        }]);',
'        return;',
'    }',
'    $(''<div id="ptwResumeDialog">'' +',
'        ''<p style="margin:0;font-size:14px;color:#333;">Are you sure you want to resume permit '' +',
'        ''<strong>'' + permitNumber + ''</strong>?</p>'' +',
'      ''</div>'')',
'      .appendTo(''body'')',
'      .dialog({',
'          title:       ''Resume Permit \u2013 '' + permitNumber,',
'          modal:       true,',
'          width:       420,',
'          dialogClass: ''ptw-apex-dialog'',',
'          buttons: [',
'              {',
'                  text:  ''Resume Permit'',',
'                  ''class'': ''t-Button t-Button--hot'',',
'                  click: function() {',
'                      $(this).dialog(''close'');',
'                      apex.submit({ request: ''RESUME_PERMIT_'' + permitId });',
'                  }',
'              },',
'              {',
'                  text:  ''Cancel'',',
'                  ''class'': ''t-Button'',',
'                  click: function() { $(this).dialog(''close''); }',
'                  }',
'              ],',
'          close: function() { $(this).dialog(''destroy'').remove(); }',
'      });',
'}',
'',
''))
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Initialize offline storage',
'OfflineStorage.initDB();',
'ConnectionManager.init();',
'',
'// Get location',
'initGeolocation();',
'',
'var isReadOnly = (status !== ''STARTED'');',
''))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.quick-actions {',
'    display: flex;',
'    gap: 10px;',
'    flex-wrap: wrap;',
'}',
'',
'.quick-actions .t-Button {',
'    flex: 1;',
'    min-width: 200px;',
'}',
'',
'/* Dialog wrapper */',
'.ptw-apex-dialog.ui-dialog {',
'    border: none;',
'    border-radius: 6px;',
'    box-shadow: 0 8px 32px rgba(0,0,0,0.35);',
'    overflow: hidden;',
'    padding: 0;',
'}',
'',
unistr('/* Title bar \2014 matches app nav colour */'),
'.ptw-apex-dialog.ui-dialog .ui-dialog-titlebar {',
'    background: #344B5C;',
'    color: #fff;',
'    padding: 14px 20px;',
'    border-bottom: 3px solid #4A9FD4;',
'    font-size: 15px;',
'    font-weight: 600;',
'    letter-spacing: 0.3px;',
'}',
'.ptw-apex-dialog.ui-dialog .ui-dialog-title       { color: #fff; }',
'.ptw-apex-dialog.ui-dialog .ui-dialog-titlebar-close {',
'    color: #fff;',
'    opacity: 0.7;',
'    top: 50%;',
'    transform: translateY(-50%);',
'}',
'.ptw-apex-dialog.ui-dialog .ui-dialog-titlebar-close:hover { opacity: 1; }',
'',
'/* Body */',
'.ptw-apex-dialog.ui-dialog .ui-dialog-content {',
'    padding: 24px 24px 16px 24px;',
'    background: #fff;',
'}',
'',
'.ptw-apex-dialog #ptwSuspendReason {',
'    display: block !important;',
'    width: 100% !important;',
'    height: 44px !important;',
'    font-size: 14px !important;',
'    box-sizing: border-box !important;',
'    margin: 0 !important;',
'}',
'',
'/* Button footer */',
'.ptw-apex-dialog.ui-dialog .ui-dialog-buttonpane {',
'    padding: 12px 24px 16px 24px;',
'    border-top: 1px solid #e8e8e8;',
'    background: #f7f8f9;',
'    margin: 0;',
'}',
'.ptw-apex-dialog.ui-dialog .ui-dialog-buttonpane .ui-dialog-buttonset {',
'    display: flex;',
'    flex-direction: row-reverse;',
'    gap: 10px;',
'}',
'',
'.ptw-action-btn {',
'    border: 2px solid rgba(255, 255, 255, 0.35) !important;',
'    margin-bottom: 8px !important;',
'}',
'',
'.ptw-action-btn--monitor {',
'    background-color: #1a6cb5 !important;',
'    color: #fff !important;',
'    border-color: #1a6cb5 !important;',
'}',
'',
unistr('/* Purple action button \2014 view completed clearance */'),
'.t-Button--purple {',
'    --a-button-background-color: #6f42c1;',
'    --a-button-border-color: #6f42c1;',
'    --a-button-text-color: #ffffff;',
'    background-color: #6f42c1 !important;',
'    border-color: #6f42c1 !important;',
'    color: #ffffff !important;',
'    opacity: 1 !important;',
'}',
'',
'/* Purple badge for COMPLETED permits */',
'.t-Badge--purple {',
'    --a-badge-background: #6f42c1;',
'    --a-badge-text: #ffffff;',
'    --a-badge-border: #6f42c1;',
'    background-color: #6f42c1 !important;',
'    color: #ffffff !important;',
'    border-color: #6f42c1 !important;',
'}',
'',
'@media (max-width: 767px) {',
'    .ptw-desktop-only { display: none !important; }',
'}',
'@media (min-width: 768px) {',
'    .ptw-mobile-only  { display: none !important; }',
'}',
'',
unistr('/* Card container \2014 matches Redwood region surface */'),
'.ptw-permit-card {',
'    border-radius: 8px;',
'    border: 1px solid var(--ut-component-border-color, #e0e0e0);',
'    background: var(--ut-component-background-color);',
'    margin-bottom: 0.75rem;',
'    overflow: hidden;',
'    box-shadow: 0 1px 4px rgba(0,0,0,0.08);',
'}',
'',
unistr('/* Status left-border \2014 reuse same palette as dashboard-card */'),
'.ptw-card-green { border-left: 5px solid var(--ut-palette-success, #3ea055); }',
'.ptw-card-amber { border-left: 5px solid var(--ut-palette-warning, #f0ad4e); }',
'.ptw-card-red   { border-left: 5px solid var(--ut-palette-danger,  #c0392b); }',
'.ptw-card-none  { border-left: 5px solid var(--ut-component-border-color, #e0e0e0); }',
'',
unistr('/* Header row \2014 permit number + badge */'),
'.ptw-card-header {',
'    display: flex;',
'    justify-content: space-between;',
'    align-items: center;',
'    padding: 0.75rem 1rem 0.5rem 1rem;',
'    border-bottom: 1px solid var(--ut-component-border-color, #e0e0e0);',
'    background: var(--ut-region-header-background-color,',
'                    var(--ut-component-background-color));',
'}',
'',
'.ptw-card-permit-number {',
'    font-size: 0.9375rem;',
'    font-weight: 700;',
'    color: #003366; /* matches .workflow-step.active and dashboard h1 */',
'}',
'',
unistr('/* Body \2014 site, PIC, dates */'),
'.ptw-card-body {',
'    padding: 0.6rem 1rem;',
'    font-size: 0.875rem;',
'    color: var(--ut-component-font-color, inherit);',
'    line-height: 1.7;',
'}',
'',
'.ptw-card-label {',
'    font-weight: 600;',
'    color: var(--ut-palette-neutral-600, #595959); /* matches .stat-label */',
'    font-size: 0.75rem;',
'    text-transform: uppercase;',
'    letter-spacing: 0.03em;',
'}',
'',
unistr('/* Action bar \2014 reuses existing ptw-action-btns pattern */'),
'.ptw-card-actions {',
'    display: flex;',
'    gap: 0.4rem;',
'    padding: 0.6rem 1rem 0.75rem 1rem;',
'    border-top: 1px solid var(--ut-component-border-color, #e0e0e0);',
'    background: var(--ut-component-background-color);',
'    flex-wrap: wrap;',
'}',
'',
unistr('/* Touch targets \2014 44px min per WCAG */'),
'.ptw-card-actions a,',
'.ptw-card-actions button {',
'    min-width: 44px;',
'    min-height: 44px;',
'    display: inline-flex;',
'    align-items: center;',
'    justify-content: center;',
'    border-radius: 6px;',
'    font-size: 1.1rem;',
'}',
'',
'#recentPermitsMobile .t-Region-header {',
'    display: flex;',
'    align-items: center;',
'}',
'',
'#recentPermitsMobile .t-Region-headerItems--buttons {',
'    margin-left: auto;',
'}',
'',
'/* Suspend/Resume dialog button styling */',
'.ptw-apex-dialog.ui-dialog .ui-dialog-buttonpane button.t-Button--hot {',
'    background-color: #E0182D !important;',
'    border-color: #E0182D !important;',
'    color: #ffffff !important;',
'    font-weight: 600 !important;',
'    opacity: 1 !important;',
'}',
'',
'.ptw-apex-dialog.ui-dialog .ui-dialog-buttonpane button.t-Button--hot:hover {',
'    background-color: #c0151f !important;',
'    border-color: #c0151f !important;',
'}',
'',
'.ptw-apex-dialog.ui-dialog .ui-dialog-buttonpane button.t-Button {',
'    background-color: #f0f0f0 !important;',
'    border-color: #d0d0d0 !important;',
'    color: #333 !important;',
'    font-weight: 500 !important;',
'    opacity: 1 !important;',
'}',
'',
'.ptw-apex-dialog.ui-dialog .ui-dialog-buttonpane button.t-Button:hover {',
'    background-color: #e0e0e0 !important;',
'}',
'',
'.admin-page-header {',
'    background: linear-gradient(135deg, #003366 0%, #005599 100%);',
'    color: white;',
'    padding: 25px 30px;',
'    border-radius: 8px;',
'    margin-bottom: 25px;',
'}',
'.admin-page-header h1 { margin: 0 0 5px 0; font-size: 1.75rem; font-weight: 700; }',
'.admin-page-header p  { margin: 0; opacity: 0.85; font-size: 0.95rem; }'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'13'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(25226512182353105)
,p_plug_name=>'Page Header'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>40
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_html       CLOB;',
'    l_company_id NUMBER;',
'    l_logo_url   VARCHAR2(500);',
'    l_logo_count NUMBER;',
'    l_override   VARCHAR2(50) := V(''G_OVERRIDE_COMPANY_ID'');',
'BEGIN',
'    -- Derive effective company_id for the current user',
'    IF l_override IS NOT NULL AND TRIM(l_override) IS NOT NULL THEN',
'        BEGIN',
'            l_company_id := TO_NUMBER(TRIM(l_override));',
'        EXCEPTION',
'            WHEN OTHERS THEN l_company_id := NULL;',
'        END;',
'    ELSE',
'        -- Normal user: their own company',
'        -- Super user with no override: NULL (no logo shown)',
'        BEGIN',
'            SELECT company_id',
'            INTO   l_company_id',
'            FROM   ptw_pro.ptw_lv_users',
'            WHERE  UPPER(username) = UPPER(:APP_USER)',
'            AND    is_super_user   = ''N''',
'            AND    is_active       = ''Y'';',
'        EXCEPTION',
'            WHEN NO_DATA_FOUND THEN l_company_id := NULL;',
'        END;',
'    END IF;',
'',
'    -- Check if a logo file exists for this company',
'    -- (graceful fallback - no broken image if file missing)',
'',
'    IF l_company_id IS NOT NULL THEN',
'        SELECT COUNT(*) INTO l_logo_count',
'        FROM   apex_application_static_files',
'        WHERE  application_id = :APP_ID',
'        AND    file_name      = ''logo_'' || l_company_id || ''.png'';',
'',
'        IF l_logo_count > 0 THEN',
'            l_logo_url := V(''APP_FILES'') || ''logo_'' || l_company_id || ''.png'';',
'        END IF;',
'    END IF;',
'',
'    -- Build header',
'    l_html := ''<div style="margin-bottom:30px;display:flex;''',
'           || ''justify-content:space-between;align-items:center;''',
'           || ''min-height:80px;">''',
'           || ''  <div>''',
'           || ''    <h1 style="font-size:2rem;color:#13294b;''',
'           || ''               margin-bottom:5px;">''',
'           || ''      Permit to Work''',
'           || ''    </h1>''',
'           || ''    <p style="color:#666;font-size:1rem;">''',
'           || ''      Low Voltage Electrical Permit Management''',
'           || ''    </p>''',
'           || ''  </div>'';',
'',
'    IF l_logo_url IS NOT NULL THEN',
'        l_html := l_html',
'               || ''  <div style="width:200px;height:60px;display:flex;''',
'               || ''align-items:center;justify-content:flex-end;">''',
'               || ''    <img src="'' || l_logo_url || ''" ''',
'               || ''         alt="Company Logo" ''',
'               || ''         style="max-width:100%;max-height:100%;''',
'               || ''object-fit:contain;" />''',
'               || ''  </div>'';',
'    END IF;',
'',
'    l_html := l_html || ''</div>'';',
'',
'    RETURN l_html;',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        -- Never break Page 1 - fall back to plain header',
'        RETURN ''<div style="margin-bottom:30px;">''',
'            || ''<h1 style="font-size:2rem;color:#13294b;">''',
'            || ''Permit to Work</h1>''',
'            || ''<p style="color:#666;">Low Voltage ''',
'            || ''Electrical Permit Management</p></div>'';',
'END;'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(25227447597353114)
,p_plug_name=>'Quick Actions'
,p_title=>'Quick Actions'
,p_icon_css_classes=>'fa-bolt'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>60
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(25227678625353116)
,p_plug_name=>'Recent Permits'
,p_title=>'Recent Permits'
,p_region_name=>'permits-ir'
,p_region_css_classes=>'ptw-desktop-only'
,p_icon_css_classes=>'fa-list'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>70
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    p.permit_id,',
'    p.permit_number,',
'    p.site_details,',
'    p.supervising_company||'' - ''||p.person_in_charge_name as person_in_charge,',
'    p.current_step,',
'    p.workflow_status,',
'    p.created_date,',
'    p.started_datetime,',
'    p.ended_datetime,',
'    CASE p.workflow_status',
'        WHEN ''IN_PROGRESS'' THEN ''In Progress''',
'        WHEN ''SUSPENDED''   THEN ''Suspended''',
'        WHEN ''COMPLETED''   THEN ''Completed''',
'        WHEN ''CANCELLED''   THEN ''Cancelled''',
'        WHEN ''AUTHORISED''  THEN ''Authorised''',
'        WHEN ''LAPSED''      THEN ''Lapsed''',
'        WHEN ''STARTED''     THEN ''Live''',
'        ELSE p.workflow_status',
'    END AS status_display,',
'    CASE p.current_step',
'        WHEN ''SITE_WORK_DETAILS'' THEN ''Step 1: Site and Work Details''',
'        WHEN ''CONTROL_MEASURES''  THEN ''Step 2: Control Measures''',
'        WHEN ''EQUIP_ISOLATION''   THEN ''Step 3: Equipment Isolation''',
'        WHEN ''AUTHORISATION''     THEN ''Step 4: Authorisation''',
'        WHEN ''CLEARANCE''         THEN ''Step 5: Clearance''',
'        ELSE p.current_step',
'    END AS step_display,',
'    CASE p.workflow_status',
'        WHEN ''COMPLETED''  THEN ''class="t-Badge t-Badge--purple t-Badge--lg"''',
'        WHEN ''SUSPENDED''  THEN ''class="t-Badge t-Badge--danger t-Badge--lg"''',
'        WHEN ''CANCELLED''  THEN  ''class="t-Badge t-Badge--danger t-Badge--lg"''',
'        WHEN ''AUTHORISED'' THEN ''class="t-Badge t-Badge--warning t-Badge--lg"''',
'        WHEN ''STARTED''    THEN ''class="t-Badge t-Badge--success t-Badge--lg"''',
'        WHEN ''LAPSED''     THEN ''class="t-Badge t-Badge--normal t-Badge--lg"''',
'        ELSE                   ''class="t-Badge t-Badge--info t-Badge--lg"''',
'    END AS status_badge,',
'    -- All action buttons combined into one column',
'    ''<div class="ptw-action-btns">'' ||',
'    -- Delete button',
'    CASE',
'        WHEN p.workflow_status NOT IN (''STARTED'',''AUTHORISED'',''COMPLETED'') AND :APP_IS_ADMIN = ''Y''',
'        THEN ''<a href="#" ',
'             class="t-Button t-Button--noLabel t-Button--icon t-Button--danger ptw-action-btn" ',
'             title="Delete Permit"',
'             onclick="ptwDeletePermit('' || p.permit_id || '', '''''' || p.permit_number || ''''''); return false;">',
'             <span class="t-Icon fa fa-trash-o" aria-hidden="true"></span>',
'          </a>''',
'    END ||',
'    -- Suspend/Resume button',
'    CASE p.workflow_status',
'        WHEN ''STARTED'' THEN',
'          CASE WHEN :APP_IS_ENGINEER = ''Y'' THEN',
'            ''<a href="javascript:ptwSuspendPermit('' || p.permit_id || '','''''' || p.permit_number || '''''');"',
'                class="t-Button t-Button--noLabel t-Button--icon t-Button--warning ptw-action-btn"',
'                title="Suspend Permit">',
'                <span class="t-icon fa fa-pause-circle" aria-hidden="true"></span>',
'             </a>''',
'          END',
'        WHEN ''SUSPENDED'' THEN',
'          CASE WHEN :APP_IS_ENGINEER = ''Y'' THEN',
'            ''<a href="javascript:ptwResumePermit('' || p.permit_id || '','''''' || p.permit_number || '''''');"',
'                class="t-Button t-Button--noLabel t-Button--icon t-Button--success ptw-action-btn"',
'                title="Resume Permit">',
'                <span class="t-icon fa fa-play-circle" aria-hidden="true"></span>',
'             </a>''',
'          END',
'--        ELSE ''<span class="ptw-action-placeholder"></span>''',
'    END ||',
'    -- Monitoring button (STARTED only)',
'    CASE',
'        WHEN p.workflow_status = ''STARTED'' AND :APP_IS_ENGINEER = ''Y''',
'        THEN ''<a href="'' || apex_page.get_url(',
'                                p_page   => 15,',
'                                p_items  => ''P15_PERMIT_ID,P15_PTW_TYPE,P15_PERMIT_NUMBER'',',
'                                p_values => p.permit_id || '','' || p.ptw_type || '','' || p.permit_number,',
'                                p_clear_cache => 15',
'                            ) || ''"',
'                 class="t-Button t-Button--noLabel t-Button--icon t-Button--info ptw-action-btn ptw-action-btn--monitor"',
'                 title="Monitoring">',
'                 <span class="t-Icon fa fa-dial-gauge-chart" aria-hidden="true"></span>',
'              </a>''',
'    -- Monitoring button (COMPLETED only)',
'        WHEN p.workflow_status = ''COMPLETED'' AND (:APP_IS_ENGINEER = ''Y'' OR :APP_IS_ADMIN = ''Y'')',
'        THEN ''<a href="'' || apex_page.get_url(',
'                                p_page   => 15,',
'                                p_items  => ''P15_PERMIT_ID,P15_PTW_TYPE,P15_PERMIT_NUMBER'',',
'                                p_values => p.permit_id || '','' || p.ptw_type || '','' || p.permit_number,',
'                                p_clear_cache => 15',
'                            ) || ''"',
'                 class="t-Button t-Button--noLabel t-Button--icon t-Button--purple ptw-action-btn ptw-action-btn--monitor"',
'                 title="View Monitoring">',
'                 <span class="t-Icon fa fa-dial-gauge-chart" aria-hidden="true"></span>',
'              </a>''',
'    END ||',
'    -- Clearance button (STARTED only)',
'    CASE',
'        WHEN p.workflow_status = ''STARTED'' ',
'        AND  SYSDATE < p.ended_datetime',
'        AND  EXISTS (',
'                 SELECT 1 ',
'                 FROM   ptw_pro.ptw_lv_monitoring m',
'                 WHERE  m.permit_id = p.permit_id',
'                 AND    m.monitoring_status = ''COMPLETED''',
'             )',
'        THEN ''<a href="'' || apex_page.get_url(',
'                                p_page   => 16,',
'                                p_items  => ''P16_PERMIT_ID,P16_PERMIT_NUMBER,P16_WORKFLOW_STATUS'',',
'                                p_values => p.permit_id || '','' || p.permit_number || '',STARTED'',',
'                                p_clear_cache => 16',
'                            ) || ''"',
'                 class="t-Button t-Button--noLabel t-Button--icon t-Button--success ptw-action-btn"',
'                 title="Clear Permit">',
'                 <span class="t-Icon fa fa-check-circle" aria-hidden="true"></span>',
'              </a>''',
'        WHEN p.workflow_status = ''COMPLETED''',
'            AND (:APP_IS_ENGINEER = ''Y'' OR :APP_IS_ADMIN = ''Y'')',
'        THEN ''<a href="'' || apex_page.get_url(',
'                            p_page   => 16,',
'                            p_items  => ''P16_PERMIT_ID,P16_PERMIT_NUMBER,P16_WORKFLOW_STATUS'',',
'                            p_values => p.permit_id || '','' || p.permit_number || '',COMPLETED'',',
'                            p_clear_cache => 16',
'                        ) || ''"',
'             class="t-Button t-Button--noLabel t-Button--icon t-Button--purple ptw-action-btn"',
'             title="View Clearance">',
'             <span class="t-Icon fa fa-check-circle" aria-hidden="true"></span>',
'          </a>''',
'    END ||',
'    -- Cancel button (AUTHORISED or STARTED permits only)',
'    CASE',
'        WHEN p.workflow_status IN (''AUTHORISED'', ''STARTED'', ''SUSPENDED'',''CANCELLED'')',
'        THEN ''<a href="'' || apex_page.get_url(',
'                                p_page   => 17,',
'                                p_items  => ''P17_PERMIT_ID,P17_PERMIT_NUMBER'',',
'                                p_values => p.permit_id || '','' || p.permit_number,',
'                                p_clear_cache => 17',
'                            ) || ''"',
'                 class="t-Button t-Button--noLabel t-Button--icon t-Button--danger ptw-action-btn"',
'                 title="Cancel Permit">',
'                 <span class="t-Icon fa fa-ban" aria-hidden="true"></span>',
'              </a>''',
'    END ||',
'    -- PDF button (always shown)',
'    ''<a href="'' || apex_page.get_url(',
'                    p_page   => 300,',
'                    p_items  => ''P300_PERMIT_ID,P300_RETURN_PAGE'',',
'                    p_values => p.permit_id || '',1''',
'                ) || ''"',
'         class="t-Button t-Button--noLabel t-Button--icon t-Button--normal ptw-action-btn"',
'         title="PDF">',
'         <span class="t-Icon fa fa-file-pdf-o" aria-hidden="true"></span>',
'     </a>'' ||',
'    -- History button (always shown)',
'      CASE WHEN :APP_IS_ADMIN = ''Y'' THEN',
'        ''<a href="'' || apex_page.get_url(',
'                       p_page   => 6,',
'                       p_items  => ''P6_PERMIT_ID'',',
'                       p_values => p.permit_id',
'                   ) || ''"',
'          class="t-Button t-Button--noLabel t-Button--icon t-Button--normal ptw-action-btn"',
'          title="Permit History">',
'          <span class="t-Icon fa fa-book" aria-hidden="true"></span>',
'        </a>'' END ||',
'    ''</div>'' AS actions,',
'    p.ptw_type,',
'    CASE',
'        WHEN p.workflow_status = ''STARTED'' AND (p.ended_datetime - SYSDATE) * 24 > 2',
'            THEN ''<span class="t-Badge t-Badge--success t-Badge--lg">''',
'                 || FLOOR((p.ended_datetime - SYSDATE) * 24) || ''h ''',
'                 || MOD(FLOOR((p.ended_datetime - SYSDATE) * 1440), 60) || ''m remaining</span>''',
'        WHEN p.workflow_status = ''STARTED'' AND (p.ended_datetime - SYSDATE) * 24 > 1',
'            THEN ''<span class="t-Badge t-Badge--warning t-Badge--lg">''',
'                 || FLOOR((p.ended_datetime - SYSDATE) * 24) || ''h ''',
'                 || MOD(FLOOR((p.ended_datetime - SYSDATE) * 1440), 60) || ''m remaining</span>''',
'        WHEN p.workflow_status = ''STARTED'' AND (p.ended_datetime - SYSDATE) * 24 <= 1',
'            THEN ''<span class="t-Badge t-Badge--danger t-Badge--lg">''',
'                 || FLOOR((p.ended_datetime - SYSDATE) * 1440) || ''m remaining</span>''',
'    END AS time_remaining',
'FROM ptw_pro.ptw_lv_permits p',
'WHERE',
'    EXISTS (',
'        SELECT 1 FROM ptw_pro.ptw_lv_user_roles_v',
'        WHERE  UPPER(username) = UPPER(V(''APP_USER''))',
'        AND    role_name IN (''ADMIN'', ''ADMIN_USER_SUPPORT'')',
'        AND    is_active = ''Y''',
'    )',
'OR (',
'    EXISTS (',
'        SELECT 1 FROM ptw_pro.ptw_lv_user_roles_v',
'        WHERE  UPPER(username) = UPPER(V(''APP_USER''))',
'        AND    role_name IN (''ADMIN_CONTRACT_SUPPORT'', ''READONLY'')',
'        AND    is_active = ''Y''',
'    )',
')',
'OR (',
'    EXISTS (',
'        SELECT 1 FROM ptw_pro.ptw_lv_user_roles_v',
'        WHERE  UPPER(username) = UPPER(V(''APP_USER''))',
'        AND    role_name = ''ENGINEER''',
'        AND    is_active = ''Y''',
'    )',
'    AND NOT EXISTS (',
'        SELECT 1 FROM ptw_pro.ptw_lv_user_roles_v',
'        WHERE  UPPER(username) = UPPER(V(''APP_USER''))',
'        AND    role_name = ''AUTHORISER''',
'        AND    is_active = ''Y''',
'    )',
'    AND UPPER(p.created_by) = UPPER(V(''APP_USER''))',
')',
'OR (',
'    EXISTS (',
'        SELECT 1 FROM ptw_pro.ptw_lv_user_roles_v',
'        WHERE  UPPER(username) = UPPER(V(''APP_USER''))',
'        AND    role_name = ''AUTHORISER''',
'        AND    is_active = ''Y''',
'    )',
'    AND NOT EXISTS (',
'        SELECT 1 FROM ptw_pro.ptw_lv_user_roles_v',
'        WHERE  UPPER(username) = UPPER(V(''APP_USER''))',
'        AND    role_name = ''ENGINEER''',
'        AND    is_active = ''Y''',
'    )',
'    AND UPPER(p.auth_person_name) = UPPER(V(''APP_USER''))',
')',
'OR (',
'    EXISTS (',
'        SELECT 1 FROM ptw_pro.ptw_lv_user_roles_v',
'        WHERE  UPPER(username) = UPPER(V(''APP_USER''))',
'        AND    role_name = ''ENGINEER''',
'        AND    is_active = ''Y''',
'    )',
'    AND EXISTS (',
'        SELECT 1 FROM ptw_pro.ptw_lv_user_roles_v',
'        WHERE  UPPER(username) = UPPER(V(''APP_USER''))',
'        AND    role_name = ''AUTHORISER''',
'        AND    is_active = ''Y''',
'    )',
'    AND (',
'        UPPER(p.created_by)          = UPPER(V(''APP_USER''))',
'        OR UPPER(p.auth_person_name) = UPPER(V(''APP_USER''))',
'    )',
')',
'ORDER BY p.created_date DESC'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Recent Permits'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(25227729512353117)
,p_max_row_count=>'1000000'
,p_max_rows_per_page=>'15'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_finder_drop_down=>'N'
,p_show_actions_menu=>'N'
,p_report_list_mode=>'NONE'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_enable_mail_download=>'Y'
,p_owner=>'PTW_PRO'
,p_internal_uid=>25227729512353117
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(25227817037353118)
,p_db_column_name=>'PERMIT_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Permit Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(25227948610353119)
,p_db_column_name=>'PERMIT_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Permit Number'
,p_column_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.::P2_PERMIT_ID:#PERMIT_ID#'
,p_column_linktext=>'#PERMIT_NUMBER#'
,p_column_link_attr=>'#STATUS_BADGE#'
,p_allow_hide=>'N'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(25228051405353120)
,p_db_column_name=>'SITE_DETAILS'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Site'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(25228396313353123)
,p_db_column_name=>'CURRENT_STEP'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Current Step'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(25228482194353124)
,p_db_column_name=>'WORKFLOW_STATUS'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(25228515012353125)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Created Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH24:MI'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(25228716348353127)
,p_db_column_name=>'STATUS_DISPLAY'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Status Display'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(25228868344353128)
,p_db_column_name=>'STEP_DISPLAY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Step Display'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(25229198978353131)
,p_db_column_name=>'STATUS_BADGE'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Status Badge'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(40551917328170601)
,p_db_column_name=>'STARTED_DATETIME'
,p_display_order=>180
,p_column_identifier=>'Q'
,p_column_label=>'Start Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH24:MI'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(40552001660170602)
,p_db_column_name=>'ENDED_DATETIME'
,p_display_order=>190
,p_column_identifier=>'R'
,p_column_label=>'End Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH24:MI'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(40552106160170603)
,p_db_column_name=>'PERSON_IN_CHARGE'
,p_display_order=>200
,p_column_identifier=>'S'
,p_column_label=>'Person In Charge'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(40555391702170635)
,p_db_column_name=>'PTW_TYPE'
,p_display_order=>220
,p_column_identifier=>'U'
,p_column_label=>'Permit Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(41969825226328829)
,p_db_column_name=>'ACTIONS'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Actions'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(45756601375782518)
,p_db_column_name=>'TIME_REMAINING'
,p_display_order=>240
,p_column_identifier=>'AB'
,p_column_label=>'Time Remaining'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(26753307670231692)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'267534'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>15
,p_report_columns=>'PERMIT_NUMBER:WORKFLOW_STATUS:TIME_REMAINING:SITE_DETAILS:PERSON_IN_CHARGE:ACTIONS:'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27017265260886523)
,p_plug_name=>'SyncStatus'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>30
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
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(45757618518782528)
,p_name=>'Recent Permits (Mobile)'
,p_title=>'Recent Permits'
,p_region_name=>'recentPermitsMobile'
,p_template=>4072358936313175081
,p_display_sequence=>80
,p_region_css_classes=>'ptw-mobile-only'
,p_icon_css_classes=>'fa-list'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    p.permit_id,',
'    p.permit_number,',
'    p.ptw_type,',
'    p.site_details,',
'    p.supervising_company || '' - '' || p.person_in_charge_name AS person_in_charge,',
'    p.workflow_status,',
'    TO_CHAR(p.started_datetime, ''DD-MON-YYYY HH24:MI'') AS started_datetime,',
'    TO_CHAR(p.ended_datetime,   ''DD-MON-YYYY HH24:MI'') AS ended_datetime,',
'    apex_page.get_url(',
'        p_page   => 2,',
'        p_items  => ''P2_PERMIT_ID'',',
'        p_values => p.permit_id',
'    ) AS permit_link,',
'',
'    -- Status display label',
'    CASE p.workflow_status',
'        WHEN ''IN_PROGRESS'' THEN ''In Progress''',
'        WHEN ''SUSPENDED''   THEN ''Suspended''',
'        WHEN ''COMPLETED''   THEN ''Completed''',
'        WHEN ''CANCELLED''   THEN ''Cancelled''',
'        WHEN ''AUTHORISED''  THEN ''Authorised''',
'        WHEN ''LAPSED''      THEN ''Lapsed''',
'        WHEN ''STARTED''     THEN ''Live''',
'        ELSE p.workflow_status',
'    END AS status_display,',
'',
'    -- Badge class (matches IR exactly including purple for COMPLETED)',
'    CASE p.workflow_status',
'        WHEN ''COMPLETED''  THEN ''t-Badge--purple''',
'        WHEN ''SUSPENDED''  THEN ''t-Badge--danger''',
'        WHEN ''AUTHORISED'' THEN ''t-Badge--warning''',
'        WHEN ''STARTED''    THEN ''t-Badge--success''',
'        WHEN ''LAPSED''     THEN ''t-Badge--normal''',
'        ELSE ''t-Badge--info''',
'    END AS badge_class,',
'',
'    -- Left-border colour class',
'    CASE',
'        WHEN p.workflow_status = ''STARTED'' AND (p.ended_datetime - SYSDATE) * 24 > 2',
'            THEN ''ptw-card-green''',
'        WHEN p.workflow_status = ''STARTED'' AND (p.ended_datetime - SYSDATE) * 24 > 1',
'            THEN ''ptw-card-amber''',
'        WHEN p.workflow_status = ''STARTED'' AND (p.ended_datetime - SYSDATE) * 24 <= 1',
'            THEN ''ptw-card-red''',
'        ELSE ''ptw-card-none''',
'    END AS card_color_class,',
'',
'    -- Time remaining badge (matches IR)',
'    CASE',
'        WHEN p.workflow_status = ''STARTED'' AND (p.ended_datetime - SYSDATE) * 24 > 2',
'            THEN ''<span class="t-Badge t-Badge--success t-Badge--lg">''',
'                 || FLOOR((p.ended_datetime - SYSDATE) * 24) || ''h ''',
'                 || MOD(FLOOR((p.ended_datetime - SYSDATE) * 1440), 60) || ''m remaining</span>''',
'        WHEN p.workflow_status = ''STARTED'' AND (p.ended_datetime - SYSDATE) * 24 > 1',
'            THEN ''<span class="t-Badge t-Badge--warning t-Badge--lg">''',
'                 || FLOOR((p.ended_datetime - SYSDATE) * 24) || ''h ''',
'                 || MOD(FLOOR((p.ended_datetime - SYSDATE) * 1440), 60) || ''m remaining</span>''',
'        WHEN p.workflow_status = ''STARTED'' AND (p.ended_datetime - SYSDATE) * 24 <= 1',
'            THEN ''<span class="t-Badge t-Badge--danger t-Badge--lg">''',
'                 || FLOOR((p.ended_datetime - SYSDATE) * 1440) || ''m remaining</span>''',
'        ELSE NULL',
'    END AS time_remaining,',
'',
'    -- Delete button (admin only, excludes STARTED/AUTHORISED/COMPLETED)',
'    CASE',
'        WHEN p.workflow_status NOT IN (''STARTED'', ''AUTHORISED'', ''COMPLETED'')',
'             AND :APP_IS_ADMIN = ''Y'' THEN',
'            ''<a href="#"',
'                class="t-Button t-Button--noLabel t-Button--icon t-Button--danger ptw-action-btn"',
'                title="Delete Permit"',
'                onclick="ptwDeletePermit('' || p.permit_id || '', '''''' || p.permit_number || ''''''); return false;">',
'                <span class="t-Icon fa fa-trash-o" aria-hidden="true"></span>',
'             </a>''',
'        ELSE NULL',
'    END AS delete_html,',
'',
'    -- Suspend/Resume button (engineer only)',
'    CASE p.workflow_status',
'        WHEN ''STARTED'' THEN',
'            CASE WHEN :APP_IS_ENGINEER = ''Y'' THEN',
'                ''<a href="javascript:ptwSuspendPermit('' || p.permit_id || '','''''' || p.permit_number || '''''');"',
'                    class="t-Button t-Button--noLabel t-Button--icon t-Button--warning ptw-action-btn"',
'                    title="Suspend Permit">',
'                    <span class="t-Icon fa fa-pause-circle" aria-hidden="true"></span>',
'                 </a>''',
'            END',
'        WHEN ''SUSPENDED'' THEN',
'            CASE WHEN :APP_IS_ENGINEER = ''Y'' THEN',
'                ''<a href="javascript:ptwResumePermit('' || p.permit_id || '','''''' || p.permit_number || '''''');"',
'                    class="t-Button t-Button--noLabel t-Button--icon t-Button--success ptw-action-btn"',
'                    title="Resume Permit">',
'                    <span class="t-Icon fa fa-play-circle" aria-hidden="true"></span>',
'                 </a>''',
'            END',
'        ELSE NULL',
'    END AS workflow_action_html,',
'',
'    -- Monitoring button (STARTED + engineer only)',
'    CASE',
'        WHEN p.workflow_status = ''STARTED'' AND :APP_IS_ENGINEER = ''Y'' THEN',
'            ''<a href="'' || apex_page.get_url(',
'                                p_page   => 15,',
'                                p_items  => ''P15_PERMIT_ID,P15_PTW_TYPE,P15_PERMIT_NUMBER'',',
'                                p_values => p.permit_id || '','' || p.ptw_type || '','' || p.permit_number',
'                            ) || ''"',
'                class="t-Button t-Button--noLabel t-Button--icon t-Button--info ptw-action-btn ptw-action-btn--monitor"',
'                title="Monitoring">',
'                <span class="t-Icon fa fa-dial-gauge-chart" aria-hidden="true"></span>',
'             </a>''',
'        WHEN p.workflow_status = ''COMPLETED'' AND (:APP_IS_ENGINEER = ''Y'' OR :APP_IS_ADMIN = ''Y'') THEN',
'            ''<a href="'' || apex_page.get_url(',
'                                p_page   => 15,',
'                                p_items  => ''P15_PERMIT_ID,P15_PTW_TYPE,P15_PERMIT_NUMBER'',',
'                                p_values => p.permit_id || '','' || p.ptw_type || '','' || p.permit_number',
'                            ) || ''"',
'                class="t-Button t-Button--noLabel t-Button--icon t-Button--purple ptw-action-btn ptw-action-btn--monitor"',
'                title="Monitoring">',
'                <span class="t-Icon fa fa-dial-gauge-chart" aria-hidden="true"></span>',
'             </a>''',
'        ELSE NULL',
'    END AS monitoring_html,',
'',
unistr('    -- Clearance button (STARTED = clear, COMPLETED = view \2014 matches IR)'),
'    CASE',
'        WHEN p.workflow_status = ''STARTED'' ',
'        AND  SYSDATE < p.ended_datetime',
'        AND  EXISTS (',
'                 SELECT 1 ',
'                 FROM   ptw_pro.ptw_lv_monitoring m',
'                 WHERE  m.permit_id = p.permit_id',
'                 AND    m.monitoring_status = ''COMPLETED''',
'             )',
'        THEN ''<a href="'' || apex_page.get_url(',
'                                p_page   => 16,',
'                                p_items  => ''P16_PERMIT_ID,P16_PERMIT_NUMBER,P16_WORKFLOW_STATUS'',',
'                                p_values => p.permit_id || '','' || p.permit_number || '',STARTED'',',
'                                p_clear_cache => 16',
'                            ) || ''"',
'                 class="t-Button t-Button--noLabel t-Button--icon t-Button--success ptw-action-btn"',
'                 title="Clear Permit">',
'                 <span class="t-Icon fa fa-check-circle" aria-hidden="true"></span>',
'              </a>''',
'        WHEN p.workflow_status = ''COMPLETED''',
'             AND (:APP_IS_ENGINEER = ''Y'' OR :APP_IS_ADMIN = ''Y'') THEN',
'            ''<a href="'' || apex_page.get_url(',
'                                p_page   => 16,',
'                                p_items  => ''P16_PERMIT_ID,P16_PERMIT_NUMBER,P16_WORKFLOW_STATUS'',',
'                                p_values => p.permit_id || '','' || p.permit_number || '',COMPLETED'',',
'                                p_clear_cache => 16',
'                            ) || ''"',
'                class="t-Button t-Button--noLabel t-Button--icon t-Button--purple ptw-action-btn"',
'                title="View Clearance">',
'                <span class="t-Icon fa fa-check-circle" aria-hidden="true"></span>',
'             </a>''',
'        ELSE NULL',
'    END AS clearance_html,',
'    -- Cancel button (AUTHORISED or STARTED permits only)',
'    CASE',
'        WHEN p.workflow_status IN (''AUTHORISED'', ''STARTED'', ''SUSPENDED'',''CANCELLED'')',
'        THEN ''<a href="'' || apex_page.get_url(',
'                                p_page   => 17,',
'                                p_items  => ''P17_PERMIT_ID,P17_PERMIT_NUMBER'',',
'                                p_values => p.permit_id || '','' || p.permit_number',
'                            ) || ''"',
'                 class="t-Button t-Button--noLabel t-Button--icon t-Button--danger ptw-action-btn"',
'                 title="Cancel Permit">',
'                 <span class="t-Icon fa fa-ban" aria-hidden="true"></span>',
'              </a>''',
'    END AS cancellation_html,',
'',
'    -- PDF button (always shown)',
'    ''<a href="'' || apex_page.get_url(',
'                    p_page   => 300,',
'                    p_items  => ''P300_PERMIT_ID,P300_RETURN_PAGE'',',
'                    p_values => p.permit_id || '',1''',
'                ) || ''"',
'        class="t-Button t-Button--noLabel t-Button--icon t-Button--normal ptw-action-btn"',
'        title="PDF">',
'        <span class="t-Icon fa fa-file-pdf-o" aria-hidden="true"></span>',
'     </a>'' AS view_pdf_html,',
'',
unistr('    -- History button (admin only \2014 matches IR)'),
'    CASE WHEN :APP_IS_ADMIN = ''Y'' THEN',
'        ''<a href="'' || apex_page.get_url(',
'                            p_page   => 6,',
'                            p_items  => ''P6_PERMIT_ID'',',
'                            p_values => p.permit_id',
'                        ) || ''"',
'            class="t-Button t-Button--noLabel t-Button--icon t-Button--normal ptw-action-btn"',
'            title="Permit History">',
'            <span class="t-Icon fa fa-book" aria-hidden="true"></span>',
'         </a>''',
'    END AS view_history_html',
'',
'FROM ptw_pro.ptw_lv_permits p',
'WHERE',
'    EXISTS (',
'        SELECT 1 FROM ptw_pro.ptw_lv_user_roles_v',
'        WHERE  UPPER(username) = UPPER(V(''APP_USER''))',
'        AND    role_name IN (''ADMIN'', ''ADMIN_USER_SUPPORT'')',
'        AND    is_active = ''Y''',
'    )',
'OR (',
'    EXISTS (',
'        SELECT 1 FROM ptw_pro.ptw_lv_user_roles_v',
'        WHERE  UPPER(username) = UPPER(V(''APP_USER''))',
'        AND    role_name IN (''ADMIN_CONTRACT_SUPPORT'', ''READONLY'')',
'        AND    is_active = ''Y''',
'    )',
')',
'OR (',
'    EXISTS (',
'        SELECT 1 FROM ptw_pro.ptw_lv_user_roles_v',
'        WHERE  UPPER(username) = UPPER(V(''APP_USER''))',
'        AND    role_name = ''ENGINEER''',
'        AND    is_active = ''Y''',
'    )',
'    AND NOT EXISTS (',
'        SELECT 1 FROM ptw_pro.ptw_lv_user_roles_v',
'        WHERE  UPPER(username) = UPPER(V(''APP_USER''))',
'        AND    role_name = ''AUTHORISER''',
'        AND    is_active = ''Y''',
'    )',
'    AND UPPER(p.created_by) = UPPER(V(''APP_USER''))',
')',
'OR (',
'    EXISTS (',
'        SELECT 1 FROM ptw_pro.ptw_lv_user_roles_v',
'        WHERE  UPPER(username) = UPPER(V(''APP_USER''))',
'        AND    role_name = ''AUTHORISER''',
'        AND    is_active = ''Y''',
'    )',
'    AND NOT EXISTS (',
'        SELECT 1 FROM ptw_pro.ptw_lv_user_roles_v',
'        WHERE  UPPER(username) = UPPER(V(''APP_USER''))',
'        AND    role_name = ''ENGINEER''',
'        AND    is_active = ''Y''',
'    )',
'    AND UPPER(p.auth_person_name) = UPPER(V(''APP_USER''))',
')',
'OR (',
'    EXISTS (',
'        SELECT 1 FROM ptw_pro.ptw_lv_user_roles_v',
'        WHERE  UPPER(username) = UPPER(V(''APP_USER''))',
'        AND    role_name = ''ENGINEER''',
'        AND    is_active = ''Y''',
'    )',
'    AND EXISTS (',
'        SELECT 1 FROM ptw_pro.ptw_lv_user_roles_v',
'        WHERE  UPPER(username) = UPPER(V(''APP_USER''))',
'        AND    role_name = ''AUTHORISER''',
'        AND    is_active = ''Y''',
'    )',
'    AND (',
'        UPPER(p.created_by)          = UPPER(V(''APP_USER''))',
'        OR UPPER(p.auth_person_name) = UPPER(V(''APP_USER''))',
'    )',
')',
'ORDER BY p.created_date DESC'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_imp.id(46213173237812182)
,p_query_headings_type=>'NO_HEADINGS'
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(45757721225782529)
,p_query_column_id=>1
,p_column_alias=>'PERMIT_ID'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(45757885290782530)
,p_query_column_id=>2
,p_column_alias=>'PERMIT_NUMBER'
,p_column_display_sequence=>20
,p_column_heading=>'Permit Number'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="ptw-permit-card #CARD_COLOR_CLASS#">',
'',
'  <div class="ptw-card-header">',
'    <span class="ptw-card-permit-number">#PERMIT_NUMBER#</span>',
'    <a href="#PERMIT_LINK#" style="text-decoration: none;">',
'      <span class="t-Badge #BADGE_CLASS# t-Badge--lg">#STATUS_DISPLAY#</span>',
'    </a>',
'  </div>',
'',
'  <div class="ptw-card-body">',
'    <div>',
'      <strong class="ptw-card-label">Site</strong><br>',
'      #SITE_DETAILS#',
'    </div>',
'    <div>',
'      <strong class="ptw-card-label">Person in Charge</strong><br>',
'      #PERSON_IN_CHARGE#',
'    </div>',
'    <div>#TIME_REMAINING#</div>',
'  </div>',
'',
'  <div class="ptw-card-actions ptw-action-btns">',
'    #DELETE_HTML#',
'    #WORKFLOW_ACTION_HTML#',
'    #MONITORING_HTML#',
'    #CLEARANCE_HTML#',
'    #CANCELLATION_HTML#',
'    #VIEW_PDF_HTML#',
'    #VIEW_HISTORY_HTML#',
'  </div>',
'',
'</div>'))
,p_heading_alignment=>'LEFT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(45757959258782531)
,p_query_column_id=>3
,p_column_alias=>'PTW_TYPE'
,p_column_display_sequence=>30
,p_hidden_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(45758082678782532)
,p_query_column_id=>4
,p_column_alias=>'SITE_DETAILS'
,p_column_display_sequence=>40
,p_hidden_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(45758180251782533)
,p_query_column_id=>5
,p_column_alias=>'PERSON_IN_CHARGE'
,p_column_display_sequence=>50
,p_hidden_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(45758249720782534)
,p_query_column_id=>6
,p_column_alias=>'WORKFLOW_STATUS'
,p_column_display_sequence=>60
,p_hidden_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(45758323837782535)
,p_query_column_id=>7
,p_column_alias=>'STARTED_DATETIME'
,p_column_display_sequence=>70
,p_hidden_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(45758453363782536)
,p_query_column_id=>8
,p_column_alias=>'ENDED_DATETIME'
,p_column_display_sequence=>80
,p_hidden_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(45759847808782550)
,p_query_column_id=>9
,p_column_alias=>'PERMIT_LINK'
,p_column_display_sequence=>200
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(45758525525782537)
,p_query_column_id=>10
,p_column_alias=>'STATUS_DISPLAY'
,p_column_display_sequence=>90
,p_hidden_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(45758662835782538)
,p_query_column_id=>11
,p_column_alias=>'BADGE_CLASS'
,p_column_display_sequence=>100
,p_hidden_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(45758785416782539)
,p_query_column_id=>12
,p_column_alias=>'CARD_COLOR_CLASS'
,p_column_display_sequence=>110
,p_hidden_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(45758842268782540)
,p_query_column_id=>13
,p_column_alias=>'TIME_REMAINING'
,p_column_display_sequence=>120
,p_hidden_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(45758978685782541)
,p_query_column_id=>14
,p_column_alias=>'DELETE_HTML'
,p_column_display_sequence=>130
,p_hidden_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(45759069091782542)
,p_query_column_id=>15
,p_column_alias=>'WORKFLOW_ACTION_HTML'
,p_column_display_sequence=>140
,p_hidden_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(45759164593782543)
,p_query_column_id=>16
,p_column_alias=>'MONITORING_HTML'
,p_column_display_sequence=>150
,p_hidden_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(45759230238782544)
,p_query_column_id=>17
,p_column_alias=>'CLEARANCE_HTML'
,p_column_display_sequence=>160
,p_hidden_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(47751461247890036)
,p_query_column_id=>18
,p_column_alias=>'CANCELLATION_HTML'
,p_column_display_sequence=>170
,p_hidden_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(45759369398782545)
,p_query_column_id=>19
,p_column_alias=>'VIEW_PDF_HTML'
,p_column_display_sequence=>180
,p_hidden_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(45759419302782546)
,p_query_column_id=>20
,p_column_alias=>'VIEW_HISTORY_HTML'
,p_column_display_sequence=>190
,p_hidden_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(52465325062584450)
,p_plug_name=>'Viewing As (Super User)'
,p_title=>'Viewing As (Super User)'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>50
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_html         CLOB;',
'    l_company_name ptw_pro.ptw_lv_companies.company_name%TYPE;',
'    l_override     VARCHAR2(50) := V(''G_OVERRIDE_COMPANY_ID'');',
'    l_is_super     VARCHAR2(1);',
'BEGIN',
'    BEGIN',
'        SELECT is_super_user',
'        INTO   l_is_super',
'        FROM   ptw_pro.ptw_lv_users',
'        WHERE  UPPER(username) = UPPER(:APP_USER)',
'        AND    is_active = ''Y'';',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN l_is_super := ''N'';',
'    END;',
'',
'    IF l_is_super != ''Y'' OR l_override IS NULL OR l_override = '''' THEN',
'        RETURN NULL;',
'    END IF;',
'',
'    BEGIN',
'        SELECT company_name',
'        INTO   l_company_name',
'        FROM   ptw_pro.ptw_lv_companies',
'        WHERE  company_id = TO_NUMBER(l_override);',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN l_company_name := ''Unknown Company'';',
'    END;',
'',
'    l_html := ''<div class="t-Alert t-Alert--info t-Alert--horizontal t-Alert--defaultIcons">''',
'           || ''  <div class="t-Alert-wrap">''',
'           || ''    <div class="t-Alert-icon"><span class="t-Icon fa-eye"></span></div>''',
'           || ''    <div class="t-Alert-content">''',
'           || ''      <div class="t-Alert-header">''',
'           || ''        <h2 class="t-Alert-title">Viewing As (Super User): ''',
'           ||              apex_escape.html(l_company_name)',
'           || ''        </h2>''',
'           || ''      </div>''',
'           || ''    </div>''',
'           || ''    <div class="t-Alert-buttons">''',
'           || ''      <button type="button" class="t-Button t-Button--hot t-Button--simple"''',
'           || ''              onclick="apex.submit(''''CLEAR_OVERRIDE'''');">''',
'           || ''        Return to Super User View''',
'           || ''      </button>''',
'           || ''    </div>''',
'           || ''  </div>''',
'           || ''</div>'';',
'',
'    RETURN l_html;',
'',
'EXCEPTION',
'    WHEN OTHERS THEN RETURN NULL;',
'END;'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'        SELECT 1',
'        FROM   ptw_pro.ptw_lv_users',
'        WHERE  UPPER(username) = UPPER(:APP_USER)',
'        AND    is_super_user = ''Y'''))
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(25227561481353115)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(25227447597353114)
,p_button_name=>'CREATE_NEW_PERMIT'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create New Permit'
,p_button_redirect_url=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.:14:P14_PERMIT_ID,P14_WORKFLOW_STATUS:&P1_PERMIT_ID.,IN_PROGRESS'
,p_button_css_classes=>'t-Button--large t-Button--stretch ptw-action-btn'
,p_icon_css_classes=>'fa-plus-circle'
,p_grid_new_row=>'Y'
,p_grid_column_span=>6
,p_security_scheme=>wwv_flow_imp.id(31533963716212424)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(40555205308170634)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(25227447597353114)
,p_button_name=>'DOWNLOAD_JOBS'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Download Jobs'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'t-Button--large t-Button--stretch ptw-action-btn'
,p_icon_css_classes=>'fa-cloud-download'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>6
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(45759503889782547)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(45757618518782528)
,p_button_name=>'REFRESH_MOBILE_PERMITS'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Refresh Permits'
,p_button_position=>'EDIT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(45756747804782519)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(25227678625353116)
,p_button_name=>'REFRESH_PERMITS'
,p_button_static_id=>'btn-refresh-permits'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Refresh Permits'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'javascript:apex.region(''permits-ir'').refresh();'
,p_button_execute_validations=>'N'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(25229805851353138)
,p_branch_name=>'Refresh Dashboard After Delete'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:1:P1_PERMIT_ID:&P1_PERMIT_ID.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'REQUEST_IN_CONDITION'
,p_branch_condition=>'DELETE_PERMIT'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(52494338428962702)
,p_branch_name=>'Reload Dashboard'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:1::'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
,p_branch_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_branch_condition=>'CLEAR_OVERRIDE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(25229693304353136)
,p_name=>'P1_PERMIT_ID'
,p_item_sequence=>90
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(31605987809440621)
,p_name=>'P1_SELECTED_PERMIT_ID'
,p_item_sequence=>100
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(31606037892440622)
,p_name=>'P1_SUSPEND_REASON'
,p_item_sequence=>110
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(45756121958782513)
,p_name=>'P1_CLEAR_PERMIT_ID'
,p_item_sequence=>120
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(45759683083782548)
,p_name=>'Refresh Mobile Cards'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(45759503889782547)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(45759769005782549)
,p_event_id=>wwv_flow_imp.id(45759683083782548)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(45757618518782528)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(25229784918353137)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delete Permit'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- DECLARE',
'--     v_permit_id NUMBER;',
'-- BEGIN',
'--     -- Extract permit ID from request (format: DELETE_PERMIT_123)',
'--     v_permit_id := TO_NUMBER(REPLACE(:REQUEST, ''DELETE_PERMIT_'', ''''));',
'',
'--     -- Delete permit (cascades to all related tables)',
'--     DELETE FROM ptw_pro.ptw_lv_permits',
'--     WHERE permit_id = v_permit_id;',
'',
'--     COMMIT;',
'',
'--     apex_application.g_print_success_message := ''Permit deleted successfully.'';',
'',
'-- EXCEPTION',
'--     WHEN OTHERS THEN',
'--         ROLLBACK;',
'--         apex_error.add_error(',
'--             p_message => ''Error deleting permit: '' || SQLERRM,',
'--             p_display_location => apex_error.c_inline_in_notification',
'--         );',
'-- END;',
'',
'DECLARE',
'    v_permit_id NUMBER;',
'BEGIN',
'    apex_debug.message(''REQUEST value: '' || :REQUEST);',
'    ',
'    v_permit_id := TO_NUMBER(REPLACE(:REQUEST, ''DELETE_PERMIT_'', ''''));',
'    ',
'    apex_debug.message(''Permit ID to delete: '' || v_permit_id);',
'',
'    DELETE FROM ptw_pro.ptw_lv_permits',
'    WHERE permit_id = v_permit_id;',
'',
'    apex_debug.message(''Rows deleted: '' || SQL%ROWCOUNT);',
'',
'    COMMIT;',
'',
'    apex_application.g_print_success_message := ''Permit deleted successfully.'';',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_error.add_error(',
'            p_message => ''Error deleting permit: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>':REQUEST LIKE ''DELETE_PERMIT_%'''
,p_process_when_type=>'EXPRESSION'
,p_process_when2=>'PLSQL'
,p_internal_uid=>25229784918353137
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(31606240288440624)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Suspend Permit'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_permit_id NUMBER;',
'BEGIN',
'    -- Extract permit ID from request (format: SUSPEND_PERMIT_123)',
'    v_permit_id := TO_NUMBER(REPLACE(:REQUEST, ''SUSPEND_PERMIT_'', ''''));',
'',
'    IF :P1_SUSPEND_REASON IS NULL OR TRIM(:P1_SUSPEND_REASON) IS NULL THEN',
'        apex_error.add_error(',
'            p_message => ''A suspension reason is required.'',',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RETURN;',
'    END IF;',
'',
'    IF :P1_WORKFLOW_STATUS NOT IN (''STARTED'',''AUTHORISED'') THEN',
'        apex_error.add_error(',
'            p_message => ''A permit must STARTED or AUTHORISED to be suspended.'',',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RETURN;',
'    END IF;',
'',
'    UPDATE ptw_pro.ptw_lv_permits',
'    SET    workflow_status   = ''SUSPENDED'',',
'           suspension_reason = TRIM(:P1_SUSPEND_REASON),',
'           suspended_date    = SYSTIMESTAMP,',
'           suspended_by      = NVL(V(''APP_USER''), USER),',
'           modified_date     = SYSTIMESTAMP,',
'           modified_by       = NVL(V(''APP_USER''), USER)',
'    WHERE  permit_id       = v_permit_id',
'    AND    workflow_status IN (''STARTED'',''AUTHORISED'');',
'',
'    IF SQL%ROWCOUNT = 0 THEN',
'        apex_error.add_error(',
'            p_message => ''Permit could not be suspended. It may already be suspended or completed.'',',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RETURN;',
'    END IF;',
'',
'    COMMIT;',
'    apex_application.g_print_success_message := ''Started Permit suspended successfully.'';',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_error.add_error(',
'            p_message => ''Error suspending permit: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>':REQUEST LIKE ''SUSPEND_PERMIT%'''
,p_process_when_type=>'EXPRESSION'
,p_process_when2=>'PLSQL'
,p_internal_uid=>31606240288440624
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(31606355068440625)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Resume Permit'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_permit_id NUMBER;',
'BEGIN',
'    -- Extract permit ID from request (format: RESUME_PERMIT_123)',
'    v_permit_id := TO_NUMBER(REPLACE(:REQUEST, ''RESUME_PERMIT_'', ''''));',
'',
'    UPDATE ptw_pro.ptw_lv_permits',
'    SET    workflow_status = ''STARTED'',',
'           resumed_date    = SYSTIMESTAMP,',
'           resumed_by      = NVL(V(''APP_USER''), USER),',
'           modified_date   = SYSTIMESTAMP,',
'           modified_by     = NVL(V(''APP_USER''), USER)',
'    WHERE  permit_id       = v_permit_id',
'    AND    workflow_status = ''SUSPENDED'';',
'',
'    IF SQL%ROWCOUNT = 0 THEN',
'        apex_error.add_error(',
'            p_message => ''Permit could not be resumed. It may not be in a suspended state.'',',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RETURN;',
'    END IF;',
'',
'    COMMIT;',
'    apex_application.g_print_success_message := ''Permit resumed successfully.'';',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_error.add_error(',
'            p_message => ''Error resuming permit: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>':REQUEST LIKE ''RESUME_PERMIT%'''
,p_process_when_type=>'EXPRESSION'
,p_process_when2=>'PLSQL'
,p_internal_uid=>31606355068440625
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(52494299876962701)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Clear Company Override'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    APEX_UTIL.SET_SESSION_STATE(''G_OVERRIDE_COMPANY_ID'', NULL);',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CLEAR_OVERRIDE'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_internal_uid=>52494299876962701
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(33350169044951415)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SET_LOCATION'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    :APP_LATITUDE  := apex_application.g_x01;',
'    :APP_LONGITUDE := apex_application.g_x02;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>33350169044951415
);
wwv_flow_imp.component_end;
end;
/
