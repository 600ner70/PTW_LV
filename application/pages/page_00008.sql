prompt --application/pages/page_00008
begin
--   Manifest
--     PAGE: 00008
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
''))
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(31533525830252139)
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(30144298864642711)
,p_plug_name=>'Page Header'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>50
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="admin-page-header">',
'    <h1><span class="fa fa-users-cog" style="margin-right:10px;"></span>User Management</h1>',
'    <p>Create and manage user accounts, reset passwords, and assign access roles for the PTW LV-Electrical application.</p>',
'</div>',
'<div class="admin-warning-banner">',
'    <span class="fa fa-exclamation-triangle"></span>',
'    <strong>Administrator Access Only</strong> &mdash;',
'    Changes here affect login access and permissions across the entire PTW application.',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(30144364566642712)
,p_plug_name=>'Role Permissions Matrix'
,p_title=>'Role Permissions Reference'
,p_icon_css_classes=>'fa-shield'
,p_region_template_options=>'#DEFAULT#:is-collapsed:t-Region--scrollBody'
,p_plug_template=>2664334895415463485
,p_plug_display_sequence=>60
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<table class="perm-matrix">',
'    <thead>',
'        <tr>',
'            <th style="width:30%;">Permission</th>',
'            <th>Admin</th>',
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
'            <td class="pm-own">Own Only</td>',
'            <td class="pm-yes">&#10003; All</td>',
'        </tr>',
'        <tr>',
'            <td>Export / Download Reports</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-no">&#10007;</td>',
'            <td class="pm-no">&#10007;</td>',
'        </tr>',
'        <tr>',
'            <td>Delete Permits</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-no">&#10007;</td>',
'            <td class="pm-no">&#10007;</td>',
'            <td class="pm-no">&#10007;</td>',
'        </tr>',
'        <tr>',
'            <td>Create New Permit</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-no">&#10007;</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-no">&#10007;</td>',
'        </tr>',
'        <tr>',
'            <td>Edit Permit (Pages 2-4, 6)</td>',
'            <td class="pm-yes">&#10003; All</td>',
'            <td class="pm-no">View Only</td>',
'            <td class="pm-yes">&#10003; All</td>',
'            <td class="pm-own">Own Only</td>',
'            <td class="pm-no">&#10007;</td>',
'        </tr>',
'        <tr>',
'            <td>Authorise Permit (Page 5)</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-no">&#10007;</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-no">&#10007;</td>',
'            <td class="pm-no">&#10007;</td>',
'        </tr>',
'        <tr>',
'            <td>Generate PDF</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-yes">&#10003;</td>',
'            <td class="pm-no">&#10007;</td>',
'        </tr>',
'        <tr>',
'            <td>User Management (Page 7)</td>',
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
,p_plug_name=>'Create New User'
,p_title=>'Create New User'
,p_region_name=>'R_CREATE_EDIT_USER'
,p_icon_css_classes=>'fa-user-plus'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>70
,p_location=>null
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
,p_plug_display_sequence=>80
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
,p_plug_display_sequence=>90
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    au.user_name as user_name,',
'    au.email,',
'    ur.mobile_no,',
'    au.first_name,',
'    au.last_name,',
'    au.description,',
'    CASE au.account_locked',
'        WHEN ''Y'' THEN ''Locked''',
'        ELSE ''Active''',
'    END                             AS account_status,',
'    ur.role_name,',
'    CASE ur.role_name',
'        WHEN ''ADMIN''',
'            THEN ''Full administrator. All actions, all pages, user management.''',
'        WHEN ''ADMIN_CONTRACT_SUPPORT''',
'            THEN ''Admin support. Full dashboard/reports, export, delete. Read-only permits.''',
'        WHEN ''AUTHORISER''',
'            THEN ''Create, edit and authorise permits. Export reports.''',
'        WHEN ''ENGINEER''',
'            THEN ''Create and edit own permits only. Generate PDF. No export or delete.''',
'        WHEN ''READONLY''',
'            THEN ''View permits and reports only.''',
'        ELSE ''(No PTW role assigned)''',
'    END                             AS role_description,',
'    ur.is_active                    AS role_active,',
'    ur.granted_by,',
'    ur.granted_date,',
'    ur.role_id as role_id,',
'        -- Checksummed edit URL - satisfies SSP without relaxing item protection',
'    APEX_UTIL.PREPARE_URL(',
'        ''f?p='' || :APP_ID || '':8:'' || :APP_SESSION ||',
'        ''::NO:8:P8_SELECTED_USERNAME,P8_ACTION:'' ||',
'        APEX_ESCAPE.HTML(au.user_name) || '',EDIT''',
'    )                                   AS edit_url,',
'    '''' AS actions',
'FROM apex_workspace_apex_users au',
'LEFT JOIN ptw_pro.ptw_lv_user_roles ur',
'    ON UPPER(au.user_name) = UPPER(ur.username)',
'   AND ur.is_active = ''Y''',
'WHERE au.workspace_name = (',
'    SELECT workspace FROM apex_applications',
'    WHERE application_id = :APP_ID',
')',
'ORDER BY au.user_name, ur.role_name'))
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
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
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
 p_id=>wwv_flow_imp.id(30147137048642740)
,p_db_column_name=>'ROLE_NAME'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>'PTW Role'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<span class="role-badge role-#ROLE_NAME#">#ROLE_NAME#</span>',
''))
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(30147270245642741)
,p_db_column_name=>'ROLE_DESCRIPTION'
,p_display_order=>90
,p_column_identifier=>'H'
,p_column_label=>'Role Summary'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(30147339474642742)
,p_db_column_name=>'ROLE_ACTIVE'
,p_display_order=>100
,p_column_identifier=>'I'
,p_column_label=>'Role Active'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<span class="active-badge active-#ROLE_ACTIVE#">#ROLE_ACTIVE#</span>',
''))
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(30147438586642743)
,p_db_column_name=>'GRANTED_BY'
,p_display_order=>110
,p_column_identifier=>'J'
,p_column_label=>'Granted By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(30147595472642744)
,p_db_column_name=>'GRANTED_DATE'
,p_display_order=>120
,p_column_identifier=>'K'
,p_column_label=>'Granted Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH24:MI'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(30147684102642745)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>130
,p_column_identifier=>'L'
,p_column_label=>'Role Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(30147770270642746)
,p_db_column_name=>'ACTIONS'
,p_display_order=>140
,p_column_identifier=>'M'
,p_column_label=>'Actions'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="white-space:nowrap;">',
'    <a href="#EDIT_URL#"',
'       class="t-Button t-Button--small t-Button--icon t-Button--noUI"',
'       title="Edit User"',
'       onclick="apex.page.cancelWarnOnUnsavedChanges(); apex.navigation.redirect(this.href); return false;">',
'        <span class="fa fa-edit"></span>',
'    </a>',
'    <a href="javascript:apex.confirm(''Deactivate PTW role for #USER_NAME#? The user will keep their APEX login but lose their PTW role.'',''DEACTIVATE_ROLE_#ROLE_ID#'');"',
'       class="t-Button t-Button--small t-Button--icon t-Button--noUI"',
'       style="color:#dc3545;"',
'       title="Deactivate Role">',
'        <span class="fa fa-ban"></span>',
'    </a>',
'</div>'))
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
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(31598082560718882)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'315981'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'USER_NAME:EMAIL:MOBILE_NO:FIRST_NAME:LAST_NAME:DESCRIPTION:ACCOUNT_STATUS:ROLE_NAME:ROLE_DESCRIPTION:ROLE_ACTIVE:GRANTED_BY:GRANTED_DATE:ACTIONS:'
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
 p_id=>wwv_flow_imp.id(30145596659642724)
,p_button_sequence=>120
,p_button_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_button_name=>'CREATE_USER'
,p_button_static_id=>'B_CREATE_USER'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create User'
,p_button_condition=>'P8_ACTION'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_button_css_classes=>'t-Button--large'
,p_icon_css_classes=>'fa-user-plus'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(30145657720642725)
,p_button_sequence=>130
,p_button_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_button_name=>'UPDATE_USER'
,p_button_static_id=>'B_UPDATE_USER'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save Changes'
,p_button_condition=>'P8_ACTION'
,p_button_condition2=>'EDIT'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_button_css_classes=>'t-Button--large'
,p_icon_css_classes=>'fa-save'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(30145708278642726)
,p_button_sequence=>140
,p_button_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_button_name=>'CANCEL_EDIT'
,p_button_static_id=>'B_CANCEL_EDIT'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_redirect_url=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:8::'
,p_button_condition=>'P8_ACTION'
,p_button_condition2=>'EDIT'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(31605142501440613)
,p_branch_name=>'Refresh after Create / Reset / Deactivate'
,p_branch_action=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:8::'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'EXPRESSION'
,p_branch_condition=>':REQUEST IN (''CREATE_USER'', ''RESET_PASSWORD'', ''DEACTIVATE_ROLE'')'
,p_branch_condition_text=>'PLSQL'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(31605201579440614)
,p_branch_name=>'Refresh after Update'
,p_branch_action=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:8::'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
,p_branch_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_branch_condition=>'UPDATE_USER'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30144037802642709)
,p_name=>'P8_SELECTED_USERNAME'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30144109246642710)
,p_name=>'P8_ACTION'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30144599534642714)
,p_name=>'P8_USERNAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_prompt=>'Username'
,p_placeholder=>'e.g. john.smith@bgis.com'
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
 p_id=>wwv_flow_imp.id(30144610683642715)
,p_name=>'P8_EMAIL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_prompt=>'Email Address'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_begin_on_new_line=>'N'
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
 p_id=>wwv_flow_imp.id(30144751562642716)
,p_name=>'P8_FIRST_NAME'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_prompt=>'First Name'
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
 p_id=>wwv_flow_imp.id(30144890448642717)
,p_name=>'P8_LAST_NAME'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_prompt=>'Last Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>100
,p_begin_on_new_line=>'N'
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
 p_id=>wwv_flow_imp.id(30144926327642718)
,p_name=>'P8_DESCRIPTION'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_prompt=>'Description / Job Title'
,p_placeholder=>'e.g. Electrical Engineer'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30145092277642719)
,p_name=>'P8_PASSWORD'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_prompt=>'Password'
,p_display_as=>'NATIVE_PASSWORD'
,p_cSize=>30
,p_cMaxlength=>100
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Required when creating a new user.',
'Leave blank when editing to keep the existing password.'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'submit_when_enter_pressed', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30145197855642720)
,p_name=>'P8_CONFIRM_PASSWORD'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_prompt=>'Confirm Password'
,p_display_as=>'NATIVE_PASSWORD'
,p_cSize=>30
,p_cMaxlength=>100
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'submit_when_enter_pressed', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30145261701642721)
,p_name=>'P8_ROLE'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_prompt=>'Access Role'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:Administrator;ADMIN,Admin - Contract Support;ADMIN_CONTRACT_SUPPORT,Authorisor;AUTHORISER,Engineer;ENGINEER,Read Only;READONLY'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select Role -'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30145303184642722)
,p_name=>'P8_IS_ACTIVE'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_prompt=>'Account Status'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:Active;Y,Inactive;N'
,p_cHeight=>1
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30145404528642723)
,p_name=>'P8_ROLE_DESCRIPTION'
,p_item_sequence=>110
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
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(30144419171642713)
,p_prompt=>'Mobile No'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
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
 p_id=>wwv_flow_imp.id(30148054991642749)
,p_validation_name=>'Email Required'
,p_validation_sequence=>20
,p_validation=>'P8_EMAIL'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Email address is required.'
,p_validation_condition=>'CREATE_USER'
,p_validation_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(30148130475642750)
,p_validation_name=>'Role Required'
,p_validation_sequence=>30
,p_validation=>'P8_ROLE'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Please select an access role for this user.'
,p_validation_condition=>':REQUEST IN (''CREATE_USER'', ''UPDATE_USER'')'
,p_validation_condition2=>'PLSQL'
,p_validation_condition_type=>'EXPRESSION'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(31603924507440601)
,p_validation_name=>'Password Required'
,p_validation_sequence=>40
,p_validation=>':P8_PASSWORD IS NOT NULL'
,p_validation2=>'PLSQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>'Password is required when creating a new user.'
,p_validation_condition=>'CREATE_USER'
,p_validation_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_associated_item=>wwv_flow_imp.id(30145092277642719)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(31604087252440602)
,p_validation_name=>'Passwords Match'
,p_validation_sequence=>50
,p_validation=>':P8_PASSWORD = :P8_CONFIRM_PASSWORD'
,p_validation2=>'PLSQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>'Password and Confirm Password do not match.'
,p_validation_condition=>':REQUEST IN (''CREATE_USER'',''UPDATE_USER'') AND :P8_PASSWORD IS NOT NULL'
,p_validation_condition2=>'PLSQL'
,p_validation_condition_type=>'EXPRESSION'
,p_associated_item=>wwv_flow_imp.id(30145197855642720)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(31604121172440603)
,p_validation_name=>'New Passwords Match'
,p_validation_sequence=>60
,p_validation=>':P8_NEW_PASSWORD = :P8_CONFIRM_NEW_PASSWORD'
,p_validation2=>'PLSQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>'New Password and Confirm Password do not match.'
,p_validation_condition=>'RESET_PASSWORD'
,p_validation_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_associated_item=>wwv_flow_imp.id(30146138398642730)
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
 p_id=>wwv_flow_imp.id(31604380577440605)
,p_validation_name=>'No Duplicate Username'
,p_validation_sequence=>80
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_count NUMBER;',
'BEGIN',
'    SELECT COUNT(*) INTO v_count',
'    FROM apex_workspace_apex_users',
'    WHERE UPPER(user_name) = UPPER(:P8_USERNAME)',
'      AND workspace_name = (',
'          SELECT workspace FROM apex_applications',
'          WHERE application_id = :APP_ID',
'      );',
'    IF v_count > 0 THEN',
'        RETURN ''Username already exists. Edit the existing user or choose a different username.'';',
'    END IF;',
'    RETURN NULL;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_ERR_TEXT'
,p_validation_condition=>'CREATE_USER'
,p_validation_condition_type=>'REQUEST_EQUALS_CONDITION'
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
,p_validation_condition=>':REQUEST IN (''CREATE_USER'', ''RESET_PASSWORD'')'
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
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P8_ROLE,P8_ROLE_DESCRIPTION'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var desc = {',
'    ''ADMIN'':',
'        ''Full administrator. All permits, all pages, user management, export, delete, PDF.'',',
'    ''ADMIN_CONTRACT_SUPPORT'':',
'        ''Admin support. Full dashboard and reports, can export, can delete permits. '' +',
'        ''Permit pages (2-6) are READ-ONLY. Cannot create or edit permits. No admin page.'',',
'    ''AUTHORISER'':',
'        ''Can create, edit and authorise all permits. Can export reports. '' +',
'        ''Cannot delete permits. No admin page.'',',
'    ''ENGINEER'':',
'        ''Can create permits and edit ONLY their own permits. '' +',
'        ''Dashboard shows own permits only. Can generate PDF. '' +',
'        ''Cannot export, delete, or authorise. No admin page.'',',
'    ''READONLY'':',
'        ''Can view all permits and reports. No create, edit, delete, export, PDF, or admin.''',
'};',
'var role = $v(''P8_ROLE'');',
'$s(''P8_ROLE_DESCRIPTION'', desc[role] || ''Select a role to see permissions.'');',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(31605554456440617)
,p_name=>'Toggle Create/Edit mode form labels and buttons on page load'
,p_event_sequence=>20
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(31605659616440618)
,p_event_id=>wwv_flow_imp.id(31605554456440617)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P8_USERNAME,P8_ROLE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if ($v(''P8_ACTION'') === ''EDIT'') {',
'    $(''#R_CREATE_EDIT_USER .t-Region-headerText'')',
'        .text(''Edit User: '' + $v(''P8_USERNAME''));',
'    $(''#B_CREATE_USER'').hide();',
'    $(''#B_UPDATE_USER'').show();',
'    $(''#B_CANCEL_EDIT'').show();',
'    // Disable username field in edit mode (cannot rename a user)',
'    apex.item(''P8_USERNAME'').disable();',
'} else {',
'    $(''#R_CREATE_EDIT_USER .t-Region-headerText'').text(''Create New User'');',
'    $(''#B_UPDATE_USER'').hide();',
'    $(''#B_CANCEL_EDIT'').hide();',
'    $(''#B_CREATE_USER'').show();',
'    apex.item(''P8_USERNAME'').enable();',
'}',
'// Trigger the role description on load too',
'apex.item(''P8_ROLE'').element.trigger(''change'');'))
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(31604612552440608)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Create New APEX User'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    APEX_UTIL.CREATE_USER(',
'        p_user_name      => UPPER(:P8_USERNAME),',
'        p_email_address  => :P8_EMAIL,',
'        p_first_name     => :P8_FIRST_NAME,',
'        p_last_name      => :P8_LAST_NAME,',
'        p_description    => :P8_DESCRIPTION,',
'        p_web_password   => :P8_PASSWORD,',
'        p_account_locked => ''N'',',
'        p_account_expiry => NULL',
'    );',
'',
'    MERGE INTO ptw_pro.ptw_lv_user_roles ur',
'    USING DUAL',
'    ON (UPPER(ur.username) = UPPER(:P8_USERNAME) AND ur.role_name = :P8_ROLE)',
'    WHEN MATCHED THEN',
'        UPDATE SET is_active = :P8_IS_ACTIVE, modified_date = CURRENT_TIMESTAMP, mobile_no = :P8_MOBILE_NO, email_address = :P8_EMAIL, first_name = :P8_FIRST_NAME, last_name = :P8_LAST_NAME',
'    WHEN NOT MATCHED THEN',
'        INSERT (username, role_name, is_active, granted_by, granted_date, mobile_no, email_address, first_name, last_name)',
'        VALUES (UPPER(:P8_USERNAME), :P8_ROLE, :P8_IS_ACTIVE,',
'                NVL(V(''APP_USER''), USER), CURRENT_TIMESTAMP, :P8_MOBILE_NO, :P8_EMAIL, :P8_FIRST_NAME, :P8_LAST_NAME);',
'',
'    COMMIT;',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_error.add_error(',
'            p_message => ''Error creating user: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RAISE;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE_USER'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_process_success_message=>'User &P8_USERNAME. created successfully.'
,p_internal_uid=>31604612552440608
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(31604779831440609)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Update Existing APEX User'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_user_id        NUMBER;',
'    l_user_name      VARCHAR2(100);',
'    l_developer_role VARCHAR2(200);',
'BEGIN',
'    -- Use P8_SELECTED_USERNAME as the reliable identifier.',
'    -- P8_USERNAME is NULL at submit time because the Load User',
'    -- Before Header process doesn''t fire on form submission.',
'    IF :P8_SELECTED_USERNAME IS NULL THEN',
'        apex_error.add_error(',
'            p_message          => ''No user selected.'',',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RETURN;',
'    END IF;',
'',
'    l_user_name := UPPER(:P8_SELECTED_USERNAME);',
'',
'    -- Get numeric user_id needed by EDIT_USER',
'    l_user_id := APEX_UTIL.GET_USER_ID(p_username => l_user_name);',
'',
'    IF l_user_id IS NULL THEN',
'        apex_error.add_error(',
'            p_message          => ''Could not resolve user ID for: '' || l_user_name,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RETURN;',
'    END IF;',
'',
'    -- Preserve existing developer role (end users have none - handle gracefully)',
'    BEGIN',
'        l_developer_role := APEX_UTIL.GET_USER_ROLES(p_username => l_user_name);',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN',
'            l_developer_role := NULL;',
'    END;',
'',
'    -- Update APEX account fields',
'    APEX_UTIL.EDIT_USER(',
'        p_user_id         => l_user_id,',
'        p_user_name       => l_user_name,',
'        p_first_name      => :P8_FIRST_NAME,',
'        p_last_name       => :P8_LAST_NAME,',
'        p_web_password    => :P8_PASSWORD,',
'        p_new_password    => :P8_PASSWORD,',
'        p_email_address   => :P8_EMAIL,',
'        p_developer_roles => l_developer_role,',
'        p_description     => :P8_DESCRIPTION',
'    );',
'',
'    -- Lock or unlock account',
'    IF :P8_IS_ACTIVE = ''N'' THEN',
'        APEX_UTIL.LOCK_ACCOUNT(p_user_name => l_user_name);',
'    ELSE',
'        APEX_UTIL.UNLOCK_ACCOUNT(p_user_name => l_user_name);',
'    END IF;',
'',
'    -- Update PTW role table',
'    UPDATE ptw_pro.ptw_lv_user_roles',
'    SET    is_active     = ''N'',',
'           mobile_no  = :P8_MOBILE_NO,',
'           email_address = :P8_EMAIL,',
'           modified_date = CURRENT_TIMESTAMP,',
'           first_name = :P8_FIRST_NAME,',
'           last_name = :P8_LAST_NAME',
'    WHERE  UPPER(username) = l_user_name',
'      AND  role_name != :P8_ROLE;',
'',
'    MERGE INTO ptw_pro.ptw_lv_user_roles ur',
'    USING DUAL',
'    ON    (UPPER(ur.username) = l_user_name AND ur.role_name = :P8_ROLE)',
'    WHEN MATCHED THEN',
'        UPDATE SET is_active     = :P8_IS_ACTIVE,',
'                   mobile_no  = :P8_MOBILE_NO,',
'                   email_address = :P8_EMAIL,',
'                   modified_date = CURRENT_TIMESTAMP,',
'                   first_name = :P8_FIRST_NAME,',
'                   last_name = :P8_LAST_NAME',
'    WHEN NOT MATCHED THEN',
'        INSERT (username, role_name, is_active, granted_by, granted_date, mobile_no, email_Address, first_name, last_name)',
'        VALUES (l_user_name, :P8_ROLE, :P8_IS_ACTIVE,',
'                NVL(V(''APP_USER''), USER), CURRENT_TIMESTAMP, :P8_MOBILE_NO, :P8_EMAIL, :P8_FIRST_NAME, :P8_LAST_NAME);',
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
'    v_role_id NUMBER;',
'BEGIN',
'    v_role_id := TO_NUMBER(REPLACE(:REQUEST, ''DEACTIVATE_ROLE_'', ''''));',
'',
'    UPDATE ptw_pro.ptw_lv_user_roles',
'    SET is_active = ''N'', modified_date = CURRENT_TIMESTAMP',
'    WHERE role_id = v_role_id;',
'',
'    COMMIT;',
'    apex_application.g_print_success_message := ''Role deactivated successfully.'';',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_error.add_error(',
'            p_message => ''Error deactivating role: '' || SQLERRM,',
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
 p_id=>wwv_flow_imp.id(31605021950440612)
,p_process_sequence=>50
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
 p_id=>wwv_flow_imp.id(31605798992440619)
,p_process_sequence=>5
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Initialise Form Defaults'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    :P8_IS_ACTIVE := ''Y'';',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P8_ACTION'
,p_process_when_type=>'ITEM_IS_NULL'
,p_internal_uid=>31605798992440619
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(31604569827440607)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load User for Edit'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    SELECT user_name, email, description',
'    INTO :P8_USERNAME, :P8_EMAIL, :P8_DESCRIPTION',
'    FROM apex_workspace_apex_users',
'    WHERE UPPER(user_name) = UPPER(:P8_SELECTED_USERNAME)',
'      AND workspace_name = (',
'          SELECT workspace FROM apex_applications WHERE application_id = :APP_ID',
'      );',
'',
'    BEGIN',
'        SELECT role_name, is_active, mobile_no, first_name, last_name',
'        INTO :P8_ROLE, :P8_IS_ACTIVE, :P8_MOBILE_NO, :P8_FIRST_NAME, :P8_LAST_NAME',
'        FROM ptw_pro.ptw_lv_user_roles',
'        WHERE UPPER(username) = UPPER(:P8_SELECTED_USERNAME)',
'          AND is_active = ''Y''',
'        FETCH FIRST 1 ROW ONLY;',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN',
'            :P8_ROLE := NULL;',
'            :P8_IS_ACTIVE := ''Y'';',
'    END;',
'',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        apex_error.add_error(',
'            p_message => ''User not found: '' || :P8_SELECTED_USERNAME,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>':P8_ACTION = ''EDIT'' AND :P8_SELECTED_USERNAME IS NOT NULL'
,p_process_when_type=>'EXPRESSION'
,p_process_when2=>'PLSQL'
,p_internal_uid=>31604569827440607
);
wwv_flow_imp.component_end;
end;
/
