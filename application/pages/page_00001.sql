prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
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
'function ptwSuspendPermit(permitId, permitNumber) {',
'',
'$(''<div id="ptwSuspendDialog">'' +',
'    ''<label style="display:block;font-weight:600;font-size:13px;margin-bottom:8px;color:#333;">'' +',
'      ''Suspension Reason <span style="color:#C0392B">*</span>'' +',
'    ''</label>'' +',
'    ''<input type="text" id="ptwSuspendReason" class="apex-item-text" '' +',
'      ''placeholder="e.g. General alarm, scope change, awaiting parts" />'' +',
'  ''</div>'')',
'      .appendTo(''body'')',
'      .dialog({',
'          title: ''Suspend Permit \u2013 '' + permitNumber,',
'          modal:  true,',
'          width:  500,',
'          dialogClass: ''ptw-apex-dialog'',',
'          buttons: [',
'              {',
'                  text:  ''Suspend Permit'',',
'                  ''class'': ''t-Button t-Button--hot'',',
'                  click: function() {',
'                      var reason = $(''#ptwSuspendReason'').val();',
'                      if (!reason || reason.trim() === '''') {',
'                          apex.message.alert(''A suspension reason is required.'');',
'                          return;',
'                      }',
'                      apex.item(''P1_SELECTED_PERMIT_ID'').setValue(permitId);',
'                      apex.item(''P1_SUSPEND_REASON'').setValue(reason.trim());',
'                      $(this).dialog(''close'');',
'                      apex.submit({ request: ''SUSPEND_PERMIT_'' + permitId });',
'                  }',
'              },',
'              {',
'                  text:  ''Cancel'',',
'                  ''class'': ''t-Button'',',
'                  click: function() { $(this).dialog(''close''); }',
'              }',
'          ],',
'          close: function() { $(this).dialog(''destroy'').remove(); }',
'      });',
'}',
'',
'function ptwResumePermit(permitId, permitNumber) {',
'',
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
'              }',
'          ],',
'          close: function() { $(this).dialog(''destroy'').remove(); }',
'      });',
'}',
'',
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
'// Override form submission for offline mode',
'if (!apex.page.submit._original) {',
'    apex.page.submit._original = apex.page.submit;',
'}',
'',
'apex.page.submit = function(options) {',
'    if (ConnectionManager.isOnline) {',
'        apex.page.submit._original(options);',
'    } else {',
'        const formData = apex.page.getValues();',
'        OfflineStorage.saveFormData(apex.page.getId(), formData)',
'            .then((id) => {',
'                apex.message.showPageSuccess(''Data saved offline. Will sync when connected.'');',
'            })',
'            .catch((error) => {',
'                apex.message.showErrors([{',
'                    type: ''error'',',
'                    message: ''Error saving offline: '' + error.message',
'                }]);',
'            });',
'    }',
'};',
'',
''))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.dashboard-card {',
'    background: white;',
'    border-radius: 8px;',
'    padding: 20px;',
'    box-shadow: 0 2px 4px rgba(0,0,0,0.1);',
'    border-left: 4px solid #003366;',
'}',
'',
'.dashboard-card h3 {',
'    margin-top: 0;',
'    color: #003366;',
'    font-size: 1.25rem;',
'    font-weight: 600;',
'}',
'',
'.stat-value {',
'    font-size: 2.5rem;',
'    font-weight: 700;',
'    color: #003366;',
'    line-height: 1;',
'    margin: 10px 0;',
'}',
'',
'.stat-label {',
'    color: #666;',
'    font-size: 0.875rem;',
'    text-transform: uppercase;',
'    letter-spacing: 0.5px;',
'}',
'',
'.status-badge {',
'    display: inline-block;',
'    padding: 4px 12px;',
'    border-radius: 12px;',
'    font-size: 0.75rem;',
'    font-weight: 600;',
'    text-transform: uppercase;',
'}',
'',
'.status-in_progress {',
'    background: #fff3cd;',
'    color: #856404;',
'}',
'',
'.status-completed {',
'    background: #d4edda;',
'    color: #155724;',
'}',
'',
'.status-cancelled {',
'    background: #f8d7da;',
'    color: #721c24;',
'}',
'',
'.status-cleared {',
'    background: #d1ecf1;',
'    color: #0c5460;',
'}',
'',
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
'.status-suspended {',
'    background: #ffe5b4;',
'    color: #7a4200;',
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
''))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'13'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(25226512182353105)
,p_plug_name=>'Page Header'
,p_plug_display_sequence=>40
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center;">',
'    <div>',
'        <h1 style="font-size: 2rem; color: #13294b; margin-bottom: 5px;">',
'            Permit to Work LV-Electrical',
'        </h1>',
'        <p style="color: #666; font-size: 1rem;">',
'            BGIS - Low Voltage Electrical Permit Management',
'        </p>',
'    </div>',
'    <!-- <img src="#APP_FILES#BGIS_Logo.jpg" alt="BGIS" style="height: 60px;"> -->',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(25227059814353110)
,p_plug_name=>'My Permits'
,p_title=>'My Permits'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>50
,p_plug_grid_column_span=>2
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_ret_clob CLOB;',
'BEGIN',
'  SELECT ''<div class="dashboard-card">'' ||',
'         ''<div class="stat-label">My Permits</div>'' ||',
'         ''<div class="stat-value">'' || COUNT(*) || ''</div>'' ||',
'         ''</div>'' as content',
'  INTO   l_ret_clob',
'  FROM   ptw_pro.ptw_lv_permits p',
'  WHERE  EXISTS (                          -- User is NOT an engineer',
'            SELECT 1 FROM ptw_pro.ptw_lv_user_roles',
'            WHERE UPPER(username) = UPPER(V(''APP_USER''))',
'              AND role_name IN (',
'                  ''ADMIN'',''ADMIN_CONTRACT_SUPPORT'',''AUTHORISER'',''READONLY''',
'              )',
'              AND is_active = ''Y''',
'        )',
'        OR',
'        (                                 -- User IS an engineer - own permits only',
'            EXISTS (',
'                SELECT 1 FROM ptw_pro.ptw_lv_user_roles',
'                WHERE UPPER(username) = UPPER(V(''APP_USER''))',
'                  AND role_name = ''ENGINEER''',
'                  AND is_active = ''Y''',
'            )',
'            AND UPPER(p.created_by) = UPPER(V(''APP_USER''))',
'        );',
'',
'  RETURN l_ret_clob;',
'END;',
''))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(25227110134353111)
,p_plug_name=>'In Progress'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>70
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>2
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_ret_clob CLOB;',
'BEGIN',
'  SELECT ''<div class="dashboard-card">'' ||',
'         ''<div class="stat-label">In Progress</div>'' ||',
'         ''<div class="stat-value" style="color: #ffc107;">'' || COUNT(*) || ''</div>'' ||',
'         ''</div>'' as content',
'  INTO   l_ret_clob',
'  FROM   ptw_pro.ptw_lv_permits p',
'  WHERE  p.workflow_status = ''IN_PROGRESS''',
'  AND   EXISTS (                          -- User is NOT an engineer',
'            SELECT 1 FROM ptw_pro.ptw_lv_user_roles',
'            WHERE UPPER(username) = UPPER(V(''APP_USER''))',
'              AND role_name IN (',
'                  ''ADMIN'',''ADMIN_CONTRACT_SUPPORT'',''AUTHORISER'',''READONLY''',
'              )',
'              AND is_active = ''Y''',
'        )',
'        OR',
'        (                                 -- User IS an engineer - own permits only',
'            EXISTS (',
'                SELECT 1 FROM ptw_pro.ptw_lv_user_roles',
'                WHERE UPPER(username) = UPPER(V(''APP_USER''))',
'                  AND role_name = ''ENGINEER''',
'                  AND is_active = ''Y''',
'            )',
'            AND UPPER(p.created_by) = UPPER(V(''APP_USER''))',
'        );',
'',
'  RETURN l_ret_clob;',
'END;',
'',
'',
'',
''))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(25227254221353112)
,p_plug_name=>'Completed'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>90
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>2
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_ret_clob CLOB;',
'BEGIN',
'  SELECT ''<div class="dashboard-card">'' ||',
'         ''<div class="stat-label">Completed</div>'' ||',
'         ''<div class="stat-value" style="color: #28a745;">'' || COUNT(*) || ''</div>'' ||',
'         ''</div>'' as content',
'  INTO   l_ret_clob',
'  FROM   ptw_pro.ptw_lv_permits p',
'  WHERE  workflow_status = ''COMPLETED''',
'  AND   EXISTS (                          -- User is NOT an engineer',
'            SELECT 1 FROM ptw_pro.ptw_lv_user_roles',
'            WHERE UPPER(username) = UPPER(V(''APP_USER''))',
'              AND role_name IN (',
'                  ''ADMIN'',''ADMIN_CONTRACT_SUPPORT'',''AUTHORISER'',''READONLY''',
'              )',
'              AND is_active = ''Y''',
'        )',
'        OR',
'        (                                 -- User IS an engineer - own permits only',
'            EXISTS (',
'                SELECT 1 FROM ptw_pro.ptw_lv_user_roles',
'                WHERE UPPER(username) = UPPER(V(''APP_USER''))',
'                  AND role_name = ''ENGINEER''',
'                  AND is_active = ''Y''',
'            )',
'            AND UPPER(p.created_by) = UPPER(V(''APP_USER''))',
'        );',
'',
'  RETURN l_ret_clob;',
'END;',
'    '))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(25227362750353113)
,p_plug_name=>'This Month'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>110
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>2
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_ret_clob CLOB;',
'BEGIN',
'  SELECT ''<div class="dashboard-card">'' ||',
'         ''<div class="stat-label">This Month</div>'' ||',
'         ''<div class="stat-value" style="color: #17a2b8;">'' || COUNT(*) || ''</div>'' ||',
'         ''</div>'' as content',
'  INTO   l_ret_clob',
'  FROM   ptw_pro.ptw_lv_permits p',
'  WHERE  TRUNC(created_date, ''MM'') = TRUNC(SYSDATE, ''MM'')',
'  AND   EXISTS (                          -- User is NOT an engineer',
'            SELECT 1 FROM ptw_pro.ptw_lv_user_roles',
'            WHERE UPPER(username) = UPPER(V(''APP_USER''))',
'              AND role_name IN (',
'                  ''ADMIN'',''ADMIN_CONTRACT_SUPPORT'',''AUTHORISER'',''READONLY''',
'              )',
'              AND is_active = ''Y''',
'        )',
'        OR',
'        (                                 -- User IS an engineer - own permits only',
'            EXISTS (',
'                SELECT 1 FROM ptw_pro.ptw_lv_user_roles',
'                WHERE UPPER(username) = UPPER(V(''APP_USER''))',
'                  AND role_name = ''ENGINEER''',
'                  AND is_active = ''Y''',
'            )',
'            AND UPPER(p.created_by) = UPPER(V(''APP_USER''))',
'        );',
'',
'  RETURN l_ret_clob;',
'END;',
'    '))
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
,p_plug_display_sequence=>120
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(25227678625353116)
,p_plug_name=>'Recent Permits'
,p_title=>'Recent Permits'
,p_icon_css_classes=>'fa-list'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>130
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    p.permit_id,',
'    p.permit_number,',
'    p.site_details,',
'    p.person_in_charge_name,',
'    p.supervising_company,',
'    p.current_step,',
'    p.workflow_status,',
'    p.created_date,',
'    p.completion_date,',
'    CASE p.workflow_status',
'        WHEN ''IN_PROGRESS'' THEN ''In Progress''',
'        WHEN ''SUSPENDED''   THEN ''Suspended''',
'        WHEN ''COMPLETED''   THEN ''Completed''',
'        WHEN ''CANCELLED''   THEN ''Cancelled''',
'        WHEN ''AUTHORISED''  THEN ''AUthorised''',
'        ELSE p.workflow_status',
'    END as status_display,',
'    CASE workflow_status',
'      WHEN ''LIVE'' THEN',
'        ''<a href="javascript:ptwSuspendPermit('' || permit_id || '','''''' || permit_number || '''''');"',
'           class="t-Button t-Button--small t-Button--noUI t-Button--warning"',
'           title="Suspend Permit">',
'           <span class="fa fa-pause-circle"></span>',
'        </a>''',
'      WHEN ''AUTHORISED'' THEN',
'        ''<a href="javascript:ptwSuspendPermit('' || permit_id || '','''''' || permit_number || '''''');"',
'           class="t-Button t-Button--small t-Button--noUI t-Button--warning"',
'           title="Suspend Permit">',
'           <span class="fa fa-pause-circle"></span>',
'        </a>''',
'      WHEN ''SUSPENDED'' THEN',
'        ''<a href="javascript:ptwResumePermit('' || permit_id || '','''''' || permit_number || '''''');"',
'           class="t-Button t-Button--small t-Button--noUI t-Button--success"',
'           title="Resume Permit">',
'           <span class="fa fa-play-circle"></span>',
'        </a>''',
'      ELSE NULL',
'    END AS workflow_action_html,',
'    CASE p.current_step',
'        WHEN ''SITE_WORK_DETAILS'' THEN ''Step 1: Site and Work Details''',
'        WHEN ''CONTROL_MEASURES''  THEN ''Step 2: Control Measures''',
'        WHEN ''EQUIP_ISOLATION''   THEN ''Step 3: Equipment Isolation''',
'        WHEN ''AUTHORISATION''     THEN ''Step 4: Authorisation''',
'        WHEN ''CLEARANCE''         THEN ''Step 5: Clearance''',
'        ELSE p.current_step',
'    END as step_display,',
'    '''' delete_permit,',
'    '''' view_pdf,',
'    CASE p.workflow_status',
'    WHEN ''COMPLETED'' THEN ',
'      ''class="t-Badge t-Badge--success t-Badge--lg"''',
'    WHEN ''SUSPENDED'' THEN',
'      ''class="t-Badge t-Badge--danger t-Badge--lg"''',
'    WHEN ''AUTHORISED'' THEN',
'      ''class="t-Badge t-Badge--warning t-Badge--lg"''    ',
'    ELSE ',
'      ''class="t-Badge t-Badge--info t-Badge--lg"''  ',
'    END status_badge,',
'    '''' view_history',
'FROM ptw_pro.ptw_lv_permits p',
'WHERE  EXISTS (                          -- User is NOT an engineer',
'            SELECT 1 FROM ptw_pro.ptw_lv_user_roles',
'            WHERE UPPER(username) = UPPER(V(''APP_USER''))',
'              AND role_name IN (',
'                  ''ADMIN'',''ADMIN_CONTRACT_SUPPORT'',''AUTHORISER'',''READONLY''',
'              )',
'              AND is_active = ''Y''',
'        )',
'        OR',
'        (                                 -- User IS an engineer - own permits only',
'            EXISTS (',
'                SELECT 1 FROM ptw_pro.ptw_lv_user_roles',
'                WHERE UPPER(username) = UPPER(V(''APP_USER''))',
'                  AND role_name = ''ENGINEER''',
'                  AND is_active = ''Y''',
'            )',
'            AND UPPER(p.created_by) = UPPER(V(''APP_USER''))',
'        )',
'ORDER BY p.created_date DESC',
''))
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
,p_show_display_row_count=>'Y'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_control_break=>'N'
,p_show_highlight=>'N'
,p_show_computation=>'N'
,p_show_aggregate=>'N'
,p_show_chart=>'N'
,p_show_group_by=>'N'
,p_show_pivot=>'N'
,p_show_flashback=>'N'
,p_show_reset=>'N'
,p_download_auth_scheme=>wwv_flow_imp.id(31534664129175422)
,p_download_formats=>'CSV:XLSX'
,p_enable_mail_download=>'N'
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
,p_column_label=>'Site Details'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(25228161650353121)
,p_db_column_name=>'PERSON_IN_CHARGE_NAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Person In Charge Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(25228255422353122)
,p_db_column_name=>'SUPERVISING_COMPANY'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Supervising Company'
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
 p_id=>wwv_flow_imp.id(25228600919353126)
,p_db_column_name=>'COMPLETION_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Completion Date'
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
 p_id=>wwv_flow_imp.id(25228961534353129)
,p_db_column_name=>'DELETE_PERMIT'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'&nbsp;'
,p_column_link=>'#'
,p_column_linktext=>'<span class="fa fa-trash"  title="Delete"></span>'
,p_column_link_attr=>'onclick=" var pid = ''#PERMIT_ID#'';   apex.message.confirm(''Delete permit #PERMIT_NUMBER# ?'', function(ok){     if(ok){       apex.item(''P1_PERMIT_ID'').setValue(pid);       apex.page.submit({ request: ''DELETE_PERMIT'' });     }   });   return false;"'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_column_alignment=>'CENTER'
,p_display_condition_type=>'FUNCTION_BODY'
,p_display_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'  DECLARE',
'    l_count NUMBER := 0;',
'  BEGIN  ',
'    SELECT COUNT(*) ',
'    INTO   l_count',
'    FROM   ptw_pro.ptw_lv_user_roles',
'    WHERE UPPER(username) = UPPER(V(''APP_USER''))',
'    AND role_name IN (''ADMIN'',''ADMIN_CONTRACT_SUPPORT'')',
'    AND is_active = ''Y'';',
'',
'    IF l_count > 0 THEN',
'      RETURN TRUE;',
'    ELSE',
'      RETURN FALSE;',
'    END IF;',
'  EXCEPTION',
'    WHEN OTHERS THEN',
'      RETURN FALSE;',
'  END;',
'END;'))
,p_display_condition2=>'PLSQL'
,p_use_as_row_header=>'N'
,p_security_scheme=>wwv_flow_imp.id(31534463148185252)
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(25229096177353130)
,p_db_column_name=>'VIEW_PDF'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'&nbsp;'
,p_column_link=>'#'
,p_column_linktext=>'<span class="fa fa-file-pdf-o" title="View PDF"></span>'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_column_alignment=>'CENTER'
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
 p_id=>wwv_flow_imp.id(31605881962440620)
,p_db_column_name=>'VIEW_HISTORY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'&nbsp;'
,p_column_link=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:6:P6_PERMIT_ID:#PERMIT_ID#'
,p_column_linktext=>'<span class="fa fa-book" title="History"></span>'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(31606126180440623)
,p_db_column_name=>'WORKFLOW_ACTION_HTML'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'&nbsp;'
,p_column_html_expression=>'#WORKFLOW_ACTION_HTML#'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_heading_alignment=>'LEFT'
,p_column_alignment=>'CENTER'
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
,p_report_columns=>'PERMIT_NUMBER:WORKFLOW_STATUS:COMPLETION_DATE:SUPERVISING_COMPANY:PERSON_IN_CHARGE_NAME:SITE_DETAILS:STEP_DISPLAY:DELETE_PERMIT:WORKFLOW_ACTION_HTML:VIEW_PDF:VIEW_HISTORY:'
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
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(31606444150440626)
,p_plug_name=>'Suspended'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>80
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>2
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_ret_clob CLOB;',
'BEGIN',
'    SELECT ''<div class="dashboard-card" style="border-left-color: #FF8C00;">''||',
'           ''<div class="stat-label">Suspended</div>''||',
'           ''<div class="stat-value" style="color: #FF8C00;">'' || COUNT(*) || ''</div>''||',
'           ''</div>''',
'    INTO   l_ret_clob',
'    FROM   ptw_pro.ptw_lv_permits ',
'    WHERE  workflow_status = ''SUSPENDED'';',
'',
'    RETURN l_ret_clob;',
'END;'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(31607536474440637)
,p_plug_name=>'Live!'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>60
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>2
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_ret_clob CLOB;',
'BEGIN',
'  SELECT ''<div class="dashboard-card">'' ||',
'         ''<div class="stat-label">Live</div>'' ||',
'         ''<div class="stat-value" style="color: #28a745;">'' || COUNT(*) || ''</div>'' ||',
'         ''</div>'' as content',
'  INTO   l_ret_clob',
'  FROM   ptw_pro.ptw_lv_permits p',
'  WHERE  workflow_status = ''LIVE''',
'  AND   EXISTS (                          -- User is NOT an engineer',
'            SELECT 1 FROM ptw_pro.ptw_lv_user_roles',
'            WHERE UPPER(username) = UPPER(V(''APP_USER''))',
'              AND role_name IN (',
'                  ''ADMIN'',''ADMIN_CONTRACT_SUPPORT'',''AUTHORISER'',''READONLY''',
'              )',
'              AND is_active = ''Y''',
'        )',
'        OR',
'        (                                 -- User IS an engineer - own permits only',
'            EXISTS (',
'                SELECT 1 FROM ptw_pro.ptw_lv_user_roles',
'                WHERE UPPER(username) = UPPER(V(''APP_USER''))',
'                  AND role_name = ''ENGINEER''',
'                  AND is_active = ''Y''',
'            )',
'            AND UPPER(p.created_by) = UPPER(V(''APP_USER''))',
'        );',
'',
'  RETURN l_ret_clob;',
'END;',
'    '))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
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
,p_button_redirect_url=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_PERMIT_ID,P2_WORKFLOW_STATUS:&P1_PERMIT_ID.,IN_PROGRESS'
,p_button_css_classes=>'t-Button--large t-Button--stretch'
,p_icon_css_classes=>'fa-plus-circle'
,p_grid_new_row=>'Y'
,p_security_scheme=>wwv_flow_imp.id(31533963716212424)
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
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(25229693304353136)
,p_name=>'P1_PERMIT_ID'
,p_item_sequence=>140
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(31605987809440621)
,p_name=>'P1_SELECTED_PERMIT_ID'
,p_item_sequence=>150
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(31606037892440622)
,p_name=>'P1_SUSPEND_REASON'
,p_item_sequence=>160
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(25229784918353137)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delete Permit'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_permit_id NUMBER;',
'BEGIN',
'    -- Extract permit ID from request (format: DELETE_PERMIT_123)',
'    v_permit_id := TO_NUMBER(REPLACE(:REQUEST, ''DELETE_PERMIT_'', ''''));',
'',
'    -- Delete permit (cascades to all related tables)',
'    DELETE FROM ptw_pro.ptw_lv_permits',
'    WHERE permit_id = v_permit_id;',
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
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'DELETE_PERMIT'
,p_process_when_type=>'REQUEST_IN_CONDITION'
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
'    IF :P1_WORKFLOW_STATUS NOT IN (''LIVE'',''AUTHORISED'') THEN',
'        apex_error.add_error(',
'            p_message => ''A permit must LIVE or AUTHORISED to be suspended.'',',
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
'    AND    workflow_status IN (''LIVE'',''AUTHORISED'');',
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
'    apex_application.g_print_success_message := ''Live Permit suspended successfully.'';',
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
'    SET    workflow_status = DECODE(auth_to_datetime, NULL, ''AUTHORISED'', ''LIVE''),',
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
