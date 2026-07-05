prompt --application/pages/page_00008
begin
--   Manifest
--     PAGE: 00008
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
 p_id=>8
,p_name=>'User Managerment'
,p_alias=>'ADMIN-USERS'
,p_step_title=>'User Managerment'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.admin-page-header {',
'    background: linear-gradient(135deg, #003366 0%, #005599 100%);',
'    color: white;',
'    padding: 25px 30px;',
'    border-radius: 8px;',
'    margin-bottom: 25px;',
'}',
'.admin-page-header h1 { margin: 0 0 5px 0; font-size: 1.75rem; font-weight: 700; }',
'.admin-page-header p  { margin: 0; opacity: 0.85; font-size: 0.95rem; }',
'',
'.admin-warning-banner {',
'    background: #fff3cd;',
'    border-left: 4px solid #ffc107;',
'    padding: 12px 16px;',
'    border-radius: 4px;',
'    margin-bottom: 20px;',
'    color: #856404;',
'    font-weight: 500;',
'}',
'.admin-warning-banner .fa { margin-right: 8px; }',
'',
'.role-badge {',
'    display: inline-block;',
'    padding: 3px 10px;',
'    border-radius: 12px;',
'    font-size: 0.72rem;',
'    font-weight: 700;',
'    text-transform: uppercase;',
'    letter-spacing: 0.5px;',
'    white-space: nowrap;',
'}',
'.role-ADMIN                  { background: #dc3545; color: white; }',
'.role-ADMIN_CONTRACT_SUPPORT { background: #fd7e14; color: white; }',
'.role-AUTHORISER             { background: #6610f2; color: white; }',
'.role-ENGINEER               { background: #007bff; color: white; }',
'.role-READONLY               { background: #6c757d; color: white; }',
'',
'.active-badge {',
'    display: inline-block;',
'    padding: 3px 10px;',
'    border-radius: 12px;',
'    font-size: 0.75rem;',
'    font-weight: 600;',
'    text-transform: uppercase;',
'}',
'.active-Y { background: #d4edda; color: #155724; }',
'.active-N { background: #f8d7da; color: #721c24; }',
'',
'.role-desc-box {',
'    background: #e8f4fd;',
'    border-left: 3px solid #007bff;',
'    padding: 8px 12px;',
'    border-radius: 4px;',
'    font-size: 0.875rem;',
'    color: #004085;',
'    margin-top: 5px;',
'    min-height: 36px;',
'}',
'',
'.perm-matrix {',
'    width: 100%;',
'    border-collapse: collapse;',
'    font-size: 0.82rem;',
'    margin-top: 5px;',
'}',
'.perm-matrix th {',
'    background: #003366;',
'    color: white;',
'    padding: 8px 10px;',
'    text-align: center;',
'    font-weight: 600;',
'}',
'.perm-matrix th:first-child { text-align: left; }',
'.perm-matrix td {',
'    padding: 6px 10px;',
'    border-bottom: 1px solid #e0e0e0;',
'    text-align: center;',
'}',
'.perm-matrix td:first-child { text-align: left; font-weight: 500; }',
'.perm-matrix tr:nth-child(even) { background: #f8f9fa; }',
'.pm-yes  { color: #155724; font-weight: 700; font-size: 1rem; }',
'.pm-no   { color: #adb5bd; font-size: 1rem; }',
'.pm-own  { color: #856404; font-weight: 600; font-size: 0.8rem; }',
'',
'/* New role badge for ADMIN_USER_SUPPORT - pink, distinct from ADMIN red */',
'.role-ADMIN_USER_SUPPORT { background: #e83e8c; color: white; }',
' ',
'/* Roles sub-region table - matches existing .cm-checklist pattern */',
'.role-assignments-table {',
'    width: 100%;',
'    border-collapse: collapse;',
'    font-size: 0.85rem;',
'    margin-top: 10px;',
'}',
'.role-assignments-table th {',
'    background: #003366;   /* matches app primary colour */',
'    color: white;',
'    padding: 8px 12px;',
'    text-align: left;',
'    font-weight: 600;',
'    font-size: 0.82rem;',
'}',
'.role-assignments-table td {',
'    padding: 8px 12px;',
'    border-bottom: 1px solid #e0e0e0;',
'    vertical-align: middle;',
'}',
'.role-assignments-table tr:nth-child(even) { background: #f8f9fa; }',
'.role-assignments-table tr:hover           { background: #e8f4fd; }',
' ',
'/* Checkbox group role selector - consistent with existing form items */',
'.p8-role-group .apex-item-option {',
'    display: inline-flex;',
'    align-items: center;',
'    margin: 4px 12px 4px 0;',
'    padding: 6px 12px;',
'    border: 1px solid #dee2e6;',
'    border-radius: 6px;',
'    background: #f8f9fa;',
'    cursor: pointer;',
'    transition: all 0.2s ease;',
'}',
'.p8-role-group .apex-item-option:hover {',
'    border-color: #003366;',
'    background: #e8f0f8;',
'}',
' ',
'/* Account deactivation warning - shown via DA when P8_IS_ACTIVE = N */',
'.account-inactive-warning {',
'    background: #f8d7da;',
'    border-left: 4px solid #dc3545;   /* matches .active-N colour */',
'    padding: 10px 14px;',
'    border-radius: 4px;',
'    margin-top: 8px;',
'    color: #721c24;',
'    font-size: 0.85rem;',
'    display: none;',
'}',
'.account-inactive-warning.visible { display: block; }',
'',
'.t-Form-inputContainer input.text_field,',
'.t-Form-inputContainer input[type="text"],',
'.t-Form-inputContainer .apex-item-text {',
'    line-height: 1.5;',
'    padding-bottom: 4px;',
'}',
'',
'/* Modern role checkbox cards */',
'.p8-role-group .apex-item-option {',
'    display: inline-flex;',
'    align-items: flex-start;',
'    margin: 6px;',
'    padding: 10px 14px;',
'    border: 2px solid #dee2e6;',
'    border-radius: 8px;',
'    background: #f8f9fa;',
'    cursor: pointer;',
'    transition: all 0.2s ease;',
'    min-width: 280px;',
'    vertical-align: top;',
'}',
'',
'.p8-role-group .apex-item-option:hover {',
'    border-color: #003366;',
'    background: #e8f0f8;',
'    box-shadow: 0 2px 6px rgba(0,51,102,0.15);',
'}',
'',
'.p8-role-group .apex-item-option input[type="checkbox"] {',
'    margin-right: 10px;',
'    margin-top: 3px;',
'    width: 16px;',
'    height: 16px;',
'    accent-color: #003366;',
'    flex-shrink: 0;',
'    cursor: pointer;',
'}',
'',
'.p8-role-group .apex-item-option label {',
'    cursor: pointer;',
'    font-size: 0.82rem;',
'    line-height: 1.4;',
'    color: #333;',
'    font-weight: 400;',
'}',
'',
'/* Highlight selected role cards */',
'.p8-role-group .apex-item-option:has(input:checked) {',
'    border-color: #003366;',
'    background: #e8f0f8;',
'    box-shadow: 0 2px 8px rgba(0,51,102,0.2);',
'}',
'',
'.p8-role-group .apex-item-option:has(input:checked) label {',
'    color: #003366;',
'    font-weight: 600;',
'}',
'',
'/* Role permissions summary box */',
'.role-desc-box {',
'    background: #e8f4fd;',
'    border-left: 3px solid #003366;',
'    padding: 10px 14px;',
'    border-radius: 4px;',
'    font-size: 0.875rem;',
'    color: #004085;',
'    margin-top: 5px;',
'    min-height: 36px;',
'    line-height: 1.6;',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(26419849891144614)
,p_protection_level=>'C'
,p_page_component_map=>'25'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(30144298864642711)
,p_plug_name=>'Page Header'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>50
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_is_admin  VARCHAR2(1) := ''N'';',
'    l_html      CLOB;',
'BEGIN',
'    BEGIN',
'        SELECT CASE is_admin WHEN ''Yes'' THEN ''Y'' ELSE ''N'' END',
'        INTO   l_is_admin',
'        FROM   apex_workspace_apex_users',
'        WHERE  UPPER(user_name)  = UPPER(V(''APP_USER''))',
'        AND    workspace_name    = (',
'                   SELECT workspace FROM apex_applications',
'                   WHERE  application_id = :APP_ID',
'               );',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN l_is_admin := ''N'';',
'    END;',
'',
'    l_html := ''<div class="admin-page-header">''',
'           || ''  <div style="display:flex; justify-content:space-between; align-items:center;">''',
'           || ''    <div>''',
'           || ''      <h1><span class="fa fa-users-cog" style="margin-right:10px;"></span>User Management</h1>''',
'           || ''      <p>Edit user profiles, manage role assignments and account status. ''',
'           || ''         New users must be created directly in the APEX Workspace by a system administrator.</p>''',
'           || ''    </div>'';',
'',
'    IF l_is_admin = ''Y'' THEN',
'        l_html := l_html',
'               || ''<div style="flex-shrink:0; margin-left:20px;">''',
'               || ''  <span style="background:#dc3545; color:white;''',
'               || ''             display:inline-flex; align-items:center;''',
'               || ''             padding:6px 16px; border-radius:20px;''',
'               || ''             font-size:0.78rem; font-weight:700;''',
'               || ''             letter-spacing:0.5px; text-transform:uppercase;''',
'               || ''             box-shadow:0 2px 4px rgba(0,0,0,0.3);''',
'               || ''             white-space:nowrap;">''',
'               || ''  <span class="fa fa-shield" style="margin-right:8px; font-size:0.9rem;"></span>''',
'               || ''  Workspace Administrator''',
'               || ''</span>''',
'               || ''</div>'';',
'    END IF;',
'',
'    l_html := l_html',
'           || ''  </div>''',
'           || ''</div>'';',
'',
'    RETURN l_html;',
'END;'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(30144364566642712)
,p_plug_name=>'Role Permissions Matrix'
,p_title=>'Role Permissions Reference'
,p_icon_css_classes=>'fa-shield'
,p_region_template_options=>'#DEFAULT#:is-collapsed:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>2664334895415463485
,p_plug_display_sequence=>60
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<table class="perm-matrix">',
'    <thead>',
'        <tr>',
'            <th style="width:30%;">Permission</th>',
'            <th>Admin</th>',
'            <th>User Support</th>',
'            <th>Contract Support</th>',
'            <th>Authoriser</th>',
'            <th>Engineer</th>',
'            <th>Read Only</th>',
'        </tr>',
'    </thead>',
'    <tbody>',
'        <tr>',
'            <td>View Dashboard</td>',
'            <td class="pm-yes">&#10003; All</td>',
'            <td class="pm-yes">&#10003; All</td>',
'            <td class="pm-yes">&#10003; All</td>',
'            <td class="pm-yes">&#10003; All</td>',
'            <td class="pm-own">Own Only</td>',
'            <td class="pm-yes">&#10003; All</td>',
'        </tr>',
'        <tr>',
'            <td>Export / Download Reports</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-no">&#10007;</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-no">&#10007;</td>',
'            <td class="pm-no">&#10007;</td>',
'        </tr>',
'        <tr>',
'            <td>Delete Permits</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-no">&#10007;</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-no">&#10007;</td>',
'            <td class="pm-no">&#10007;</td>',
'            <td class="pm-no">&#10007;</td>',
'        </tr>',
'        <tr>',
'            <td>Create New Permit</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-no">&#10007;</td>',
'            <td class="pm-no">&#10007;</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-no">&#10007;</td>',
'        </tr>',
'        <tr>',
'            <td>Edit Permit (Pages 2-4, 6)</td>',
'            <td class="pm-yes">&#10003; All</td>',
'            <td class="pm-no">&#10007;</td>',
'            <td class="pm-no">View Only</td>',
'            <td class="pm-yes">&#10003; All</td>',
'            <td class="pm-own">Own Only</td>',
'            <td class="pm-no">&#10007;</td>',
'        </tr>',
'        <tr>',
'            <td>Authorise Permit (Page 5)</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-no">&#10007;</td>',
'            <td class="pm-no">&#10007;</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-no">&#10007;</td>',
'            <td class="pm-no">&#10007;</td>',
'        </tr>',
'        <tr>',
'            <td>Generate PDF</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-no">&#10007;</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-no">&#10007;</td>',
'        </tr>',
'        <tr>',
'            <td>User Management</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-no">&#10007;</td>',
'            <td class="pm-no">&#10007;</td>',
'            <td class="pm-no">&#10007;</td>',
'            <td class="pm-no">&#10007;</td>',
'        </tr>',
'    </tbody>',
'</table>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(30144419171642713)
,p_plug_name=>'Edit User Details'
,p_title=>'Edit User Details'
,p_region_name=>'R_EDIT_USER'
,p_icon_css_classes=>'fa-user-edit'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>70
,p_location=>null
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P8_SELECTED_USERNAME'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(30145873358642727)
,p_plug_name=>'Reset Password'
,p_title=>'Reset User Password'
,p_icon_css_classes=>'fa-key'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>100
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p style="color:#555; margin-top:0;">',
'    To reset a password for an existing user, enter their exact username',
'    and a new temporary password below. Advise the user to change their',
'    password on first login. This does not affect the user&rsquo;s role or',
'    account status.',
'</p>',
''))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(30146348111642732)
,p_plug_name=>'Current Users Report'
,p_title=>'Current Application Users'
,p_icon_css_classes=>'fa-list-alt'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>110
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    au.user_name,',
'    u.email_address                                        AS email,',
'    u.mobile_no,',
'    u.first_name,',
'    u.last_name,',
'    u.job_title                                            AS description,',
'    CASE u.is_active',
'        WHEN ''Y'' THEN ''Active''',
'        ELSE ''Deactivated''',
'    END                                                    AS account_status,',
'    CASE au.account_locked',
'      WHEN ''Yes'' THEN',
'        ''<span class="fa fa-lock fa-lg" style="color:#dc3545;" title="Account locked"></span>''',
'      ELSE',
'        ''<span class="fa fa-unlock fa-lg" style="color:#28a745;" title="Account unlocked"></span>''',
'    END  AS account_status_icon,',
'    -- Aggregate all active roles for this user',
'    LISTAGG(',
'        CASE ur.is_active',
'            WHEN ''Y'' THEN r.role_name',
'            ELSE r.role_name || '' (inactive)''',
'        END, '', ''',
'    ) WITHIN GROUP (ORDER BY r.display_order)              AS roles,',
'    -- Edit URL',
'    APEX_UTIL.PREPARE_URL(',
'        ''f?p='' || :APP_ID || '':8:'' || :APP_SESSION ||',
'        ''::NO::P8_SELECTED_USERNAME:'' ||',
'        APEX_ESCAPE.HTML(au.user_name)',
'    )                                                      AS edit_url,',
'    ''''                                                     AS actions',
'FROM   apex_workspace_apex_users             au',
'LEFT JOIN ptw_pro.ptw_lv_users               u',
'    ON UPPER(u.username)  = UPPER(au.user_name)',
'LEFT JOIN ptw_pro.ptw_lv_user_role_assignments ur',
'    ON ur.user_id         = u.user_id',
'LEFT JOIN ptw_pro.ptw_lv_roles               r',
'    ON r.role_id          = ur.role_id',
'WHERE  au.workspace_name  = (',
'           SELECT workspace FROM apex_applications',
'           WHERE  application_id = :APP_ID',
'       )',
'AND    u.is_active IS NOT NULL',
'AND (',
'    -- Super user, no override: see everyone (unrestricted)',
'    (',
'        EXISTS (SELECT 1 FROM ptw_pro.ptw_lv_users su',
'                 WHERE UPPER(su.username) = UPPER(:APP_USER)',
'                 AND   su.is_super_user = ''Y'' AND su.is_active = ''Y'')',
'        AND (V(''G_OVERRIDE_COMPANY_ID'') IS NULL OR V(''G_OVERRIDE_COMPANY_ID'') = '''')',
'    )',
'    OR',
'    -- Everyone else (normal users, or super users WITH an',
'    -- override): see only your "effective company"',
'    u.company_id = NVL(',
'        TO_NUMBER(V(''G_OVERRIDE_COMPANY_ID'')),',
'        (SELECT company_id FROM ptw_pro.ptw_lv_users',
'          WHERE UPPER(username) = UPPER(:APP_USER))',
'    )',
')',
'GROUP  BY',
'    au.user_name, u.email_address, u.mobile_no,',
'    u.first_name, u.last_name, u.job_title, u.is_active,',
'    au.account_locked',
'ORDER  BY au.user_name'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Current Application Users'
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
 p_id=>wwv_flow_imp.id(30146472761642733)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_actions_menu=>'N'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_enable_mail_download=>'Y'
,p_owner=>'PTW_PRO'
,p_internal_uid=>30146472761642733
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(30146577209642734)
,p_db_column_name=>'USER_NAME'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Username'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(30146657386642735)
,p_db_column_name=>'EMAIL'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Email Address'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(33349011612951404)
,p_db_column_name=>'MOBILE_NO'
,p_display_order=>30
,p_column_identifier=>'O'
,p_column_label=>'Mobile No'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(30146799896642736)
,p_db_column_name=>'FIRST_NAME'
,p_display_order=>40
,p_column_identifier=>'C'
,p_column_label=>'First Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(30146893986642737)
,p_db_column_name=>'LAST_NAME'
,p_display_order=>50
,p_column_identifier=>'D'
,p_column_label=>'Last Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(30146903995642738)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'Job Title'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(30147090798642739)
,p_db_column_name=>'ACCOUNT_STATUS'
,p_display_order=>70
,p_column_identifier=>'F'
,p_column_label=>'Account Status'
,p_column_html_expression=>'<span class="active-badge active-#ACCOUNT_STATUS#">#ACCOUNT_STATUS#</span>'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(30147770270642746)
,p_db_column_name=>'ACTIONS'
,p_display_order=>140
,p_column_identifier=>'M'
,p_column_label=>'Actions'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<a href="#EDIT_URL#"',
'   class="t-Button t-Button--small t-Button--icon t-Button--noUI"',
'   title="Edit User"',
'   onclick="apex.page.cancelWarnOnUnsavedChanges();',
'            apex.navigation.redirect(this.href); return false;">',
'    <span class="fa fa-edit"></span>',
'</a>'))
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(30147829890642747)
,p_db_column_name=>'EDIT_URL'
,p_display_order=>150
,p_column_identifier=>'N'
,p_column_label=>'Edit Url'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(39964380753997119)
,p_db_column_name=>'ROLES'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Roles'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(39965718241997133)
,p_db_column_name=>'ACCOUNT_STATUS_ICON'
,p_display_order=>170
,p_column_identifier=>'R'
,p_column_label=>'Account Locked?'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(31598082560718882)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'315981'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'USER_NAME:EMAIL:MOBILE_NO:FIRST_NAME:LAST_NAME:DESCRIPTION:ACCOUNT_STATUS:ACCOUNT_STATUS_ICON:ACTIONS:'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(39963457956997110)
,p_name=>'User Role Assignments'
,p_title=>'Current Role Assignments'
,p_template=>4072358936313175081
,p_display_sequence=>90
,p_icon_css_classes=>'fa-shield'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    r.role_name,',
'    r.role_description,',
'    ur.is_active                                       AS role_active,',
'    TO_CHAR(ur.granted_date, ''DD-MON-YYYY HH24:MI'')   AS granted_date,',
'    ur.granted_by,',
'    ur.user_role_id,',
'    -- Toggle button HTML',
'    CASE ur.is_active',
'        WHEN ''Y'' THEN',
'            ''<a href="javascript:apex.confirm(''''Deactivate '' ||',
'            APEX_ESCAPE.HTML(r.role_name) ||',
'            '' role for this user?'''',''''DEACTIVATE_ROLE_'' ||',
'            ur.user_role_id || '''''');" '' ||',
'            ''class="t-Button t-Button--small t-Button--danger t-Button--iconLeft" '' ||',
'            ''title="Deactivate Role">'' ||',
'            ''<span class="fa fa-ban"></span> Deactivate</a>''',
'        ELSE',
'            ''<a href="javascript:apex.confirm(''''Reactivate '' ||',
'            APEX_ESCAPE.HTML(r.role_name) ||',
'            '' role for this user?'''',''''REACTIVATE_ROLE_'' ||',
'            ur.user_role_id || '''''');" '' ||',
'            ''class="t-Button t-Button--small t-Button--success t-Button--iconLeft" '' ||',
'            ''title="Reactivate Role">'' ||',
'            ''<span class="fa fa-check"></span> Reactivate</a>''',
'    END AS role_action',
'FROM   ptw_pro.ptw_lv_user_role_assignments  ur',
'JOIN   ptw_pro.ptw_lv_roles                  r',
'    ON r.role_id = ur.role_id',
'JOIN   ptw_pro.ptw_lv_users                  u',
'    ON u.user_id = ur.user_id',
'WHERE  UPPER(u.username) = UPPER(:P8_SELECTED_USERNAME)',
'ORDER  BY r.display_order, ur.is_active DESC'))
,p_display_when_condition=>'P8_SELECTED_USERNAME'
,p_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P8_SELECTED_USERNAME'
,p_lazy_loading=>false
,p_query_row_template=>2538654340625403440
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
 p_id=>wwv_flow_imp.id(39963536611997111)
,p_query_column_id=>1
,p_column_alias=>'ROLE_NAME'
,p_column_display_sequence=>10
,p_column_heading=>'Role'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(39963676820997112)
,p_query_column_id=>2
,p_column_alias=>'ROLE_DESCRIPTION'
,p_column_display_sequence=>20
,p_column_heading=>'Description'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(39963754602997113)
,p_query_column_id=>3
,p_column_alias=>'ROLE_ACTIVE'
,p_column_display_sequence=>30
,p_column_heading=>'Active'
,p_column_html_expression=>'<span class="active-badge active-#ROLE_ACTIVE#">#ROLE_ACTIVE#</span>'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(39963806760997114)
,p_query_column_id=>4
,p_column_alias=>'GRANTED_DATE'
,p_column_display_sequence=>40
,p_column_heading=>'Granted Date'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(39963995635997115)
,p_query_column_id=>5
,p_column_alias=>'GRANTED_BY'
,p_column_display_sequence=>50
,p_column_heading=>'Granted By'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(39964062478997116)
,p_query_column_id=>6
,p_column_alias=>'USER_ROLE_ID'
,p_column_display_sequence=>60
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(39964118131997117)
,p_query_column_id=>7
,p_column_alias=>'ROLE_ACTION'
,p_column_display_sequence=>70
,p_column_heading=>'Action'
,p_heading_alignment=>'LEFT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(39964404866997120)
,p_plug_name=>'Select a User'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>80
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="text-align:center; padding:30px; color:#6c757d;">',
'         <span class="fa fa-users" style="font-size:2rem; display:block;',
'               margin-bottom:10px; color:#dee2e6;"></span>',
'         Select a user from the <strong>Current Application Users</strong>',
'         report below to view and edit their details.',
'</div>'))
,p_plug_display_condition_type=>'ITEM_IS_NULL'
,p_plug_display_when_condition=>'P8_SELECTED_USERNAME'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(30146281021642731)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(30145873358642727)
,p_button_name=>'RESET_PASSWORD'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Reset Password'
,p_icon_css_classes=>'fa-key'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(39965438036997130)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_button_name=>'UNLOCK_ACCOUNT'
,p_button_static_id=>'B_UNLOCK_ACCOUNT'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Unlock Account'
,p_button_position=>'NEXT'
,p_button_condition=>'P8_ACCOUNT_LOCKED'
,p_button_condition2=>'Yes'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-unlock'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(39964728616997123)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_button_name=>'UPDATE_USER'
,p_button_static_id=>'B_UPDATE_USER'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save Changes'
,p_button_position=>'NEXT'
,p_icon_css_classes=>'fa-save'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(39964865413997124)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:8::'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(31605201579440614)
,p_branch_name=>'Refresh after Update'
,p_branch_action=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:8:P8_SELECTED_USERNAME:&P8_SELECTED_USERNAME.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
,p_branch_condition_type=>'EXPRESSION'
,p_branch_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':REQUEST = ''RESET_PASSWORD''',
'OR :REQUEST = ''UNLOCK_ACCOUNT''',
'OR :REQUEST LIKE ''DEACTIVATE_ROLE_%''',
'OR :REQUEST LIKE ''REACTIVATE_ROLE_%''',
'OR :REQUEST = ''UPDATE_USER'''))
,p_branch_condition_text=>'PLSQL'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30144037802642709)
,p_name=>'P8_SELECTED_USERNAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30144610683642715)
,p_name=>'P8_EMAIL'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Email Address'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_colspan=>6
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30144751562642716)
,p_name=>'P8_FIRST_NAME'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_use_cache_before_default=>'NO'
,p_prompt=>'First Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>100
,p_colspan=>4
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30144890448642717)
,p_name=>'P8_LAST_NAME'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Last Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>100
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30144926327642718)
,p_name=>'P8_DESCRIPTION'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Description / Job Title'
,p_placeholder=>'e.g. Electrical Engineer'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30145261701642721)
,p_name=>'P8_ROLE'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_prompt=>'Access Role'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'       r.role_name   || '' - '' || r.role_description  AS display_value,',
'       r.role_name                                    AS return_value',
'FROM   ptw_pro.ptw_lv_roles r',
'WHERE  r.is_active = ''Y''',
'AND    -- ADMIN role not visible because you can''t assign it to anyone',
'       r.role_name != ''ADMIN''',
'ORDER BY r.display_order'))
,p_colspan=>12
,p_field_template=>1609122147107268652
,p_item_css_classes=>'p8-role-group'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30145303184642722)
,p_name=>'P8_IS_ACTIVE'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Account Status'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:Active;Y,Inactive;N'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_help_text=>'Setting to Inactive locks the APEX account AND deactivates ALL role assignments. Roles must be manually re-enabled after reactivation.'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30145404528642723)
,p_name=>'P8_ROLE_DESCRIPTION'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_prompt=>'Role Permissions Summary'
,p_source=>'<div class="role-desc-box">&P8_ROLE_DESCRIPTION.</div>'''
,p_source_type=>'STATIC'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_protection_level=>'I'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'format', 'HTML',
  'send_on_page_submit', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30145991782642728)
,p_name=>'P8_RESET_USERNAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(30145873358642727)
,p_prompt=>'Username to Reset'
,p_placeholder=>'Enter exact username...'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>100
,p_colspan=>4
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30146023157642729)
,p_name=>'P8_NEW_PASSWORD'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(30145873358642727)
,p_prompt=>'New Password'
,p_display_as=>'NATIVE_PASSWORD'
,p_cSize=>30
,p_cMaxlength=>100
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'submit_when_enter_pressed', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30146138398642730)
,p_name=>'P8_CONFIRM_NEW_PASSWORD'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(30145873358642727)
,p_prompt=>'Confirm New Password'
,p_display_as=>'NATIVE_PASSWORD'
,p_cSize=>30
,p_cMaxlength=>100
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'submit_when_enter_pressed', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(33348933592951403)
,p_name=>'P8_MOBILE_NO'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Mobile No'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(39964554847997121)
,p_name=>'P8_EDIT_USER_HEADER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="edit-user-header">',
'         <span class="fa fa-user"></span>',
'         Editing user: &P8_SELECTED_USERNAME.',
'       </div>'))
,p_source_type=>'STATIC'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_colspan=>12
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'format', 'HTML',
  'send_on_page_submit', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(39964665833997122)
,p_name=>'P8_INACTIVE_WARNING'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="account-inactive-warning" id="P8_INACTIVE_WARNING_DIV">',
'         <span class="fa fa-exclamation-triangle"></span>',
'         <strong>Warning:</strong> Setting this account to Inactive will',
'         lock the APEX login AND deactivate ALL role assignments.',
'         Roles must be manually re-enabled after reactivation.',
'       </div>'))
,p_source_type=>'STATIC'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_colspan=>12
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'format', 'HTML',
  'send_on_page_submit', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(39965323727997129)
,p_name=>'P8_ACCOUNT_LOCKED'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(39965819671997134)
,p_name=>'P8_IS_WORKSPACE_ADMIN'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53156691206466135)
,p_name=>'P8_TEAM_ID'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_prompt=>'Team '
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT team_name d, team_id r',
'             FROM   ptw_pro.ptw_lv_teams',
'             WHERE  company_id = :effective_company_id  -- same resolution as rest of page',
'             AND    is_active = ''Y''',
'             ORDER  BY team_name'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-- Team Selection --'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(30147927396642748)
,p_validation_name=>'Username Required'
,p_validation_sequence=>10
,p_validation=>'P8_USERNAME'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Username is required.'
,p_validation_condition=>'CREATE_USER'
,p_validation_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(30148130475642750)
,p_validation_name=>'Role Required'
,p_validation_sequence=>30
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P8_ROLE IS NOT NULL ',
'OR :P8_IS_WORKSPACE_ADMIN = ''Y'''))
,p_validation2=>'PLSQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>'Please select an access role for this user.'
,p_validation_condition=>':REQUEST = ''UPDATE_USER'''
,p_validation_condition2=>'PLSQL'
,p_validation_condition_type=>'EXPRESSION'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(31604223540440604)
,p_validation_name=>'Reset Username Required'
,p_validation_sequence=>70
,p_validation=>'P8_RESET_USERNAME'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Please enter the username to reset.'
,p_validation_condition=>'RESET_PASSWORD'
,p_validation_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_associated_item=>wwv_flow_imp.id(30145991782642728)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(31604422759440606)
,p_validation_name=>'Password Complexity'
,p_validation_sequence=>90
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_pwd VARCHAR2(100);',
'BEGIN',
'    v_pwd := CASE WHEN :REQUEST = ''CREATE_USER'' THEN :P8_PASSWORD',
'                  ELSE :P8_NEW_PASSWORD END;',
'    IF v_pwd IS NULL THEN RETURN NULL; END IF;',
'    IF LENGTH(v_pwd) < 8 THEN',
'        RETURN ''Password must be at least 8 characters.'';',
'    END IF;',
'    IF REGEXP_INSTR(v_pwd,''[0-9]'') = 0 THEN',
'        RETURN ''Password must contain at least one number.'';',
'    END IF;',
'    IF REGEXP_INSTR(v_pwd,''[A-Z]'') = 0 THEN',
'        RETURN ''Password must contain at least one uppercase letter.'';',
'    END IF;',
'    RETURN NULL;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_ERR_TEXT'
,p_validation_condition=>':REQUEST = ''RESET_PASSWORD'''
,p_validation_condition2=>'PLSQL'
,p_validation_condition_type=>'EXPRESSION'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(31605361620440615)
,p_name=>'Populate Role Description when Role changes'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P8_ROLE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(31605432461440616)
,p_event_id=>wwv_flow_imp.id(31605361620440615)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P8_ROLE,P8_ROLE_DESCRIPTION'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var selectedRoles = ($v(''P8_ROLE'') || '''').split('':'').filter(Boolean);',
'var desc = {',
'    ''ADMIN''                 : ''Full administrator. All actions, all pages, user management.'',',
'    ''ADMIN_USER_SUPPORT''    : ''User support admin. Edit users, reset passwords, manage roles. Cannot create users.'',',
'    ''ADMIN_CONTRACT_SUPPORT'': ''Admin support. Full dashboard/reports, export, delete. Permit pages read-only.'',',
'    ''AUTHORISER''            : ''Create, edit and authorise all permits. Export reports.'',',
'    ''ENGINEER''              : ''Create and edit own permits only. Generate PDF. No export or delete.'',',
'    ''READONLY''              : ''View permits and reports only.''',
'};',
'if (selectedRoles.length === 0) {',
'    $s(''P8_ROLE_DESCRIPTION'',',
'       ''<em style="color:#6c757d;">Select one or more roles to see permissions.</em>'');',
'} else {',
'    var summary = selectedRoles.map(function(r) {',
'        return ''<strong>'' + r + ''</strong>: '' + (desc[r] || r);',
'    }).join(''<br>'');',
'    $s(''P8_ROLE_DESCRIPTION'', summary);',
'}'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(39964911527997125)
,p_name=>'Show account deactivation warning'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P8_IS_ACTIVE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(39965099061997126)
,p_event_id=>wwv_flow_imp.id(39964911527997125)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if ($v(''P8_IS_ACTIVE'') === ''N'') {',
'    $(''#P8_INACTIVE_WARNING_DIV'').addClass(''visible'');',
'} else {',
'    $(''#P8_INACTIVE_WARNING_DIV'').removeClass(''visible'');',
'}'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(39965121194997127)
,p_name=>'When the page loads and reloads'
,p_event_sequence=>30
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_display_when_cond=>'P8_SELECTED_USERNAME'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(39965285764997128)
,p_event_id=>wwv_flow_imp.id(39965121194997127)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_username VARCHAR2(100);',
'BEGIN',
'    l_username := UPPER(:P8_SELECTED_USERNAME);',
'',
'    BEGIN',
'        ptw_pro.ptw_sec_pkg.check_user_in_company(l_username);',
'    EXCEPTION',
'        WHEN OTHERS THEN',
'            apex_error.add_error(',
'                p_message          => ''Access denied: this user does not belong to your company.'',',
'                p_display_location => apex_error.c_inline_in_notification',
'            );',
'            RETURN;',
'    END;',
'',
'    -- Verify user exists in APEX',
'    DECLARE',
'        l_count NUMBER;',
'    BEGIN',
'        SELECT COUNT(*) INTO l_count',
'        FROM   apex_workspace_apex_users',
'        WHERE  UPPER(user_name)  = l_username',
'        AND    workspace_name    = (',
'                   SELECT workspace FROM apex_applications',
'                   WHERE  application_id = :APP_ID',
'               );',
'        IF l_count = 0 THEN',
'            apex_error.add_error(',
'                p_message          => ''User not found: '' || :P8_SELECTED_USERNAME,',
'                p_display_location => apex_error.c_inline_in_notification',
'            );',
'            RETURN;',
'        END IF;',
'',
'        SELECT au.account_locked',
'        INTO   :P8_ACCOUNT_LOCKED',
'        FROM   apex_workspace_apex_users au',
'        WHERE  UPPER(au.user_name) = l_username',
'        AND    au.workspace_name   = (SELECT workspace ',
'                                      FROM   apex_applications',
'                                      WHERE  application_id = :APP_ID);',
'    END;',
'',
'    -- Load profile from ptw_lv_users (primary source)',
'    BEGIN',
'        SELECT u.first_name,',
'               u.last_name,',
'               u.email_address,',
'               u.mobile_no,',
'               u.job_title,',
'               u.is_active',
'        INTO   :P8_FIRST_NAME,',
'               :P8_LAST_NAME,',
'               :P8_EMAIL,',
'               :P8_MOBILE_NO,',
'               :P8_DESCRIPTION,',
'               :P8_IS_ACTIVE',
'        FROM   ptw_pro.ptw_lv_users u',
'        WHERE  UPPER(u.username) = l_username;',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN',
'            -- No profile row yet - fall back to APEX account data',
'            BEGIN',
'                SELECT au.email,',
'                       au.first_name,',
'                       au.last_name,',
'                       au.description',
'                INTO   :P8_EMAIL,',
'                       :P8_FIRST_NAME,',
'                       :P8_LAST_NAME,',
'                       :P8_DESCRIPTION',
'                FROM   apex_workspace_apex_users au',
'                WHERE  UPPER(au.user_name) = l_username',
'                AND    au.workspace_name   = (',
'                           SELECT workspace FROM apex_applications',
'                           WHERE  application_id = :APP_ID',
'                       );',
'            EXCEPTION',
'                WHEN NO_DATA_FOUND THEN NULL;',
'            END;',
'            :P8_IS_ACTIVE := ''Y'';',
'    END;',
'',
'    -- Load active role assignments as colon-delimited string',
'    BEGIN',
'        SELECT LISTAGG(r.role_name, '':'')',
'                   WITHIN GROUP (ORDER BY r.display_order)',
'        INTO   :P8_ROLE',
'        FROM   ptw_pro.ptw_lv_user_role_assignments  ur',
'        JOIN   ptw_pro.ptw_lv_roles                  r',
'            ON r.role_id  = ur.role_id',
'        JOIN   ptw_pro.ptw_lv_users                  u',
'            ON u.user_id  = ur.user_id',
'        WHERE  UPPER(u.username) = l_username',
'        AND    ur.is_active      = ''Y'';',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN',
'            :P8_ROLE := NULL;',
'    END;',
'',
'END;'))
,p_attribute_02=>'P8_SELECTED_USERNAME'
,p_attribute_03=>'P8_FIRST_NAME,P8_LAST_NAME,P8_EMAIL,P8_MOBILE_NO,P8_DESCRIPTION,P8_IS_ACTIVE,P8_ROLE,P8_ACCOUNT_LOCKED,P8_IS_WORKSPACE_ADMIN'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(31604779831440609)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update Existing APEX User'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_user_id          NUMBER;',
'    l_user_name        VARCHAR2(100);',
'    l_developer_role   VARCHAR2(200);',
'    l_caller_role      VARCHAR2(50);',
'    l_admin_role_count NUMBER;',
'    l_oper_role_count  NUMBER;',
'BEGIN',
'    IF :P8_SELECTED_USERNAME IS NULL THEN',
'        apex_error.add_error(',
'            p_message          => ''No user selected.'',',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RETURN;',
'    END IF;',
'',
'    ptw_pro.ptw_sec_pkg.check_user_in_company(:P8_SELECTED_USERNAME);',
'',
'    l_user_name := UPPER(:P8_SELECTED_USERNAME);',
'',
'    -- Get caller''s highest role for restriction checks',
'    BEGIN',
'        SELECT role_name',
'        INTO   l_caller_role',
'        FROM   ptw_pro.ptw_lv_user_roles_v',
'        WHERE  UPPER(username) = UPPER(V(''APP_USER''))',
'        AND    is_active       = ''Y''',
'        AND    ROWNUM          = 1;',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN l_caller_role := NULL;',
'    END;',
'',
'    -- ADMIN_USER_SUPPORT cannot assign ADMIN role',
'    IF l_caller_role = ''ADMIN_USER_SUPPORT''',
'    AND INSTR('':'' || :P8_ROLE || '':'', '':ADMIN:'') > 0 THEN',
'        apex_error.add_error(',
'            p_message          => ''You do not have permission to assign the Administrator role.'',',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RETURN;',
'    END IF;',
'',
'    -- Cannot edit own account',
'    IF UPPER(l_user_name) = UPPER(V(''APP_USER'')) AND :P8_IS_WORKSPACE_ADMIN != ''Y'' THEN',
'        apex_error.add_error(',
'            p_message          => ''You cannot edit your own account.'',',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RETURN;',
'    END IF;',
'',
'    -- Validate: admin roles cannot be combined with operational roles',
'    SELECT COUNT(*) INTO l_admin_role_count',
'    FROM   TABLE(apex_string.split(:P8_ROLE, '':''))',
'    WHERE  TRIM(column_value) IN (''ADMIN'', ''ADMIN_USER_SUPPORT'');',
'',
'    SELECT COUNT(*) INTO l_oper_role_count',
'    FROM   TABLE(apex_string.split(:P8_ROLE, '':''))',
'    WHERE  TRIM(column_value) IN (',
'               ''AUTHORISER'', ''ENGINEER'',',
'               ''ADMIN_CONTRACT_SUPPORT'', ''READONLY''',
'           );',
'',
'    IF l_admin_role_count > 0 AND l_oper_role_count > 0 THEN',
'        apex_error.add_error(',
'            p_message          => ''Administrator roles cannot be combined with operational roles.'',',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RETURN;',
'    END IF;',
'',
'    -- Get APEX user_id',
'    l_user_id := APEX_UTIL.GET_USER_ID(p_username => l_user_name);',
'    IF l_user_id IS NULL THEN',
'        apex_error.add_error(',
'            p_message          => ''Could not resolve user ID for: '' || l_user_name,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RETURN;',
'    END IF;',
'',
'    -- Preserve developer role',
'    BEGIN',
'        l_developer_role := APEX_UTIL.GET_USER_ROLES(p_username => l_user_name);',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN l_developer_role := NULL;',
'    END;',
'',
'    -- Update APEX account',
'    APEX_UTIL.EDIT_USER(',
'        p_user_id         => l_user_id,',
'        p_user_name       => l_user_name,',
'        p_first_name      => :P8_FIRST_NAME,',
'        p_last_name       => :P8_LAST_NAME,',
'        p_email_address   => :P8_EMAIL,',
'        p_developer_roles => l_developer_role,',
'        p_description     => :P8_DESCRIPTION',
'    );',
'',
'    -- Lock or unlock APEX account',
'    IF :P8_IS_ACTIVE = ''N'' THEN',
'        APEX_UTIL.LOCK_ACCOUNT(p_user_name => l_user_name);',
'    ELSE',
'        APEX_UTIL.UNLOCK_ACCOUNT(p_user_name => l_user_name);',
'    END IF;',
'',
'    -- Update ptw_lv_users profile',
'    UPDATE ptw_pro.ptw_lv_users',
'    SET    first_name     = :P8_FIRST_NAME,',
'           last_name      = :P8_LAST_NAME,',
'           email_address  = :P8_EMAIL,',
'           mobile_no      = :P8_MOBILE_NO,',
'           job_title      = :P8_DESCRIPTION,',
'           is_active      = :P8_IS_ACTIVE,',
'           modified_date  = CURRENT_TIMESTAMP,',
'           modified_by    = NVL(V(''APP_USER''), USER)',
'    WHERE  UPPER(username) = l_user_name;',
'',
'    -- If account deactivated: deactivate ALL role assignments',
'    IF :P8_IS_ACTIVE = ''N'' THEN',
'        UPDATE ptw_pro.ptw_lv_user_role_assignments ur',
'        SET    ur.is_active     = ''N'',',
'               ur.modified_date = CURRENT_TIMESTAMP,',
'               ur.modified_by   = NVL(V(''APP_USER''), USER)',
'        WHERE  ur.user_id = (',
'                   SELECT user_id FROM ptw_pro.ptw_lv_users',
'                   WHERE  UPPER(username) = l_user_name',
'               );',
'    ELSE',
'        -- Account active: sync role assignments from checkbox group',
'        -- Step 1: Deactivate roles NOT in the selected set',
'        UPDATE ptw_pro.ptw_lv_user_role_assignments ur',
'        SET    ur.is_active     = ''N'',',
'               ur.modified_date = CURRENT_TIMESTAMP,',
'               ur.modified_by   = NVL(V(''APP_USER''), USER)',
'        WHERE  ur.user_id = (',
'                   SELECT user_id FROM ptw_pro.ptw_lv_users',
'                   WHERE  UPPER(username) = l_user_name',
'               )',
'        AND    ur.role_id NOT IN (',
'                   SELECT r.role_id',
'                   FROM   ptw_pro.ptw_lv_roles r',
'                   JOIN   TABLE(apex_string.split(:P8_ROLE, '':'')) s',
'                       ON r.role_name = TRIM(s.column_value)',
'               );',
'',
'        -- Step 2: Insert or reactivate roles in the selected set',
'        FOR r IN (',
'            SELECT TRIM(column_value) AS role_name',
'            FROM   TABLE(apex_string.split(:P8_ROLE, '':''))',
'            WHERE  TRIM(column_value) IS NOT NULL',
'        ) LOOP',
'            MERGE INTO ptw_pro.ptw_lv_user_role_assignments ur',
'            USING (',
'                SELECT u.user_id, rl.role_id',
'                FROM   ptw_pro.ptw_lv_users  u',
'                CROSS JOIN ptw_pro.ptw_lv_roles rl',
'                WHERE  UPPER(u.username) = l_user_name',
'                AND    rl.role_name      = r.role_name',
'            ) src',
'            ON (ur.user_id = src.user_id AND ur.role_id = src.role_id)',
'            WHEN MATCHED THEN',
'                UPDATE SET ur.is_active     = ''Y'',',
'                           ur.modified_date = CURRENT_TIMESTAMP,',
'                           ur.modified_by   = NVL(V(''APP_USER''), USER)',
'            WHEN NOT MATCHED THEN',
'                INSERT (user_id, role_id, is_active, granted_by, granted_date)',
'                VALUES (src.user_id, src.role_id, ''Y'',',
'                        NVL(V(''APP_USER''), USER), CURRENT_TIMESTAMP);',
'        END LOOP;',
'    END IF;',
'',
'    COMMIT;',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_error.add_error(',
'            p_message          => ''Error updating user: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RAISE;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'UPDATE_USER'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_process_success_message=>'User &P8_USERNAME. updated successfully.'
,p_internal_uid=>31604779831440609
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(31604889274440610)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Reset User Password'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- Minimal approach: only need user_id to call EDIT_USER for password reset.',
'-- Password-only update - developer roles preserved via GET_USER_ROLES.',
'DECLARE',
'    l_user_id        NUMBER;',
'    l_user_name      VARCHAR2(100);',
'    l_developer_role VARCHAR2(200);',
'BEGIN',
'    -- Step 1: Verify user exists in this workspace and get username',
'    BEGIN',
'        SELECT user_name',
'        INTO   l_user_name',
'        FROM   apex_workspace_apex_users',
'        WHERE  UPPER(user_name) = UPPER(:P8_RESET_USERNAME);',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN',
'            apex_error.add_error(',
'                p_message          => ''User not found: '' || :P8_RESET_USERNAME ||',
'                                      ''. Please verify the username.'',',
'                p_display_location => apex_error.c_inline_in_notification',
'            );',
'            RETURN;',
'    END;',
'',
'    ptw_pro.ptw_sec_pkg.check_user_in_company(l_user_name);',
'',
'    -- Step 1b: Get the numeric user_id needed by EDIT_USER',
'    l_user_id := APEX_UTIL.GET_USER_ID(p_username => l_user_name);',
'',
'    IF l_user_id IS NULL THEN',
'        apex_error.add_error(',
'            p_message          => ''Could not resolve user ID for: '' || :P8_RESET_USERNAME,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RETURN;',
'    END IF;',
'',
'    -- Step 2: Preserve existing developer role.',
'    -- Wrapped in exception handler as GET_USER_ROLES raises NO_DATA_FOUND',
'    -- for end users who have no developer/admin roles assigned.',
'    BEGIN',
'        l_developer_role := APEX_UTIL.GET_USER_ROLES(p_username => l_user_name);',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN',
'            l_developer_role := NULL;',
'    END;',
'',
'    -- Step 3: Update password only',
'    APEX_UTIL.EDIT_USER(',
'        p_user_id         => l_user_id,',
'        p_user_name       => l_user_name,',
'        p_web_password    => :P8_NEW_PASSWORD,',
'        p_new_password    => :P8_NEW_PASSWORD,',
'        p_developer_roles => l_developer_role',
'    );',
'',
'    COMMIT;',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_error.add_error(',
'            p_message          => ''Error resetting password: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RAISE;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'RESET_PASSWORD'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_process_success_message=>'Password reset successfully for &P8_RESET_USERNAME.'
,p_internal_uid=>31604889274440610
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(31604947175440611)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Deactivate User Role'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_user_role_id NUMBER;',
'    l_username     VARCHAR2(100);',
'BEGIN',
'    l_user_role_id := TO_NUMBER(',
'                          REPLACE(:REQUEST, ''DEACTIVATE_ROLE_'', '''')',
'                      );',
'',
'    SELECT u.username',
'    INTO   l_username',
'    FROM   ptw_pro.ptw_lv_user_role_assignments ur',
'    JOIN   ptw_pro.ptw_lv_users u ON u.user_id = ur.user_id',
'    WHERE  ur.user_role_id = l_user_role_id;',
' ',
'    ptw_pro.ptw_sec_pkg.check_user_in_company(l_username);',
' ',
'    UPDATE ptw_pro.ptw_lv_user_role_assignments',
'    SET    is_active     = ''N'',',
'           modified_date = CURRENT_TIMESTAMP,',
'           modified_by   = NVL(V(''APP_USER''), USER)',
'    WHERE  user_role_id  = l_user_role_id;',
' ',
'    COMMIT;',
'    apex_application.g_print_success_message := ''Role deactivated successfully.'';',
' ',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        apex_error.add_error(',
'            p_message          => ''Role assignment not found.'',',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_error.add_error(',
'            p_message          => ''Error deactivating role: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>':REQUEST LIKE ''DEACTIVATE_ROLE_%'''
,p_process_when_type=>'EXPRESSION'
,p_process_when2=>'PLSQL'
,p_internal_uid=>31604947175440611
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(39964238595997118)
,p_process_sequence=>45
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Reactivate User Role'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_user_role_id NUMBER;',
'    l_username     VARCHAR2(100);',
'BEGIN',
'    l_user_role_id := TO_NUMBER(',
'                          REPLACE(:REQUEST, ''REACTIVATE_ROLE_'', '''')',
'                      );',
'',
'    SELECT u.username',
'    INTO   l_username',
'    FROM   ptw_pro.ptw_lv_user_role_assignments ur',
'    JOIN   ptw_pro.ptw_lv_users u ON u.user_id = ur.user_id',
'    WHERE  ur.user_role_id = l_user_role_id;',
' ',
'    ptw_pro.ptw_sec_pkg.check_user_in_company(l_username);',
' ',
'    UPDATE ptw_pro.ptw_lv_user_role_assignments',
'    SET    is_active     = ''N'',',
'           modified_date = CURRENT_TIMESTAMP,',
'           modified_by   = NVL(V(''APP_USER''), USER)',
'    WHERE  user_role_id  = l_user_role_id;',
' ',
'    COMMIT;',
'    apex_application.g_print_success_message := ''Role reactivated successfully.'';',
' ',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        apex_error.add_error(',
'            p_message          => ''Role assignment not found.'',',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_error.add_error(',
'            p_message          => ''Error reactivating role: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>':REQUEST LIKE ''REACTIVATE_ROLE_%'''
,p_process_when_type=>'EXPRESSION'
,p_process_when2=>'PLSQL'
,p_internal_uid=>39964238595997118
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(31605021950440612)
,p_process_sequence=>60
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Clear Password Fields After Submit'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    :P8_PASSWORD             := NULL;',
'    :P8_CONFIRM_PASSWORD     := NULL;',
'    :P8_NEW_PASSWORD         := NULL;',
'    :P8_CONFIRM_NEW_PASSWORD := NULL;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>':REQUEST IN (''CREATE_USER'', ''RESET_PASSWORD'')'
,p_process_when_type=>'EXPRESSION'
,p_process_when2=>'PLSQL'
,p_internal_uid=>31605021950440612
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(39965532747997131)
,p_process_sequence=>70
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Unlock User Account'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_username VARCHAR2(100);',
'BEGIN',
'    l_username := UPPER(:P8_SELECTED_USERNAME);',
'',
'    IF l_username IS NULL THEN',
'        apex_error.add_error(',
'            p_message          => ''No user selected.'',',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RETURN;',
'    END IF;',
'',
'    ptw_pro.ptw_sec_pkg.check_user_in_company(l_username);',
'',
'    -- Unlock APEX account',
'    APEX_UTIL.UNLOCK_ACCOUNT(p_user_name => l_username);',
'',
'    -- Reactivate ptw_lv_users profile record',
'    UPDATE ptw_pro.ptw_lv_users',
'    SET    is_active     = ''Y'',',
'           modified_date = CURRENT_TIMESTAMP,',
'           modified_by   = NVL(V(''APP_USER''), USER)',
'    WHERE  UPPER(username) = l_username;',
'',
'    COMMIT;',
'    apex_application.g_print_success_message :=',
'        ''Account for '' || l_username || '' has been unlocked successfully.'';',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_error.add_error(',
'            p_message          => ''Error unlocking account: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(39965438036997130)
,p_internal_uid=>39965532747997131
);
wwv_flow_imp.component_end;
end;
/
