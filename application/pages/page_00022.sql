prompt --application/pages/page_00022
begin
--   Manifest
--     PAGE: 00022
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
 p_id=>22
,p_name=>'Master Permit Types'
,p_alias=>'MASTER-PERMIT-TYPES'
,p_step_title=>'Master Permit Types'
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
'.admin-page-header p  { margin: 0; opacity: 0.85; font-size: 0.95rem; }'))
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(52412848522131878)
,p_protection_level=>'C'
,p_page_component_map=>'25'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(52417315015182137)
,p_plug_name=>'Page Header'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>30
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
'           || ''  <h1>Master Permit Types</h1>''',
'           || ''  <p>Manage the global list of permit types available across all ''',
'           || ''     companies. Companies must be granted access to a type before ''',
'           || ''     their users can select it on a new permit (see Permit Types ''',
'           || ''     under each company''''s Admin menu).</p>''',
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
 p_id=>wwv_flow_imp.id(52417425903182138)
,p_plug_name=>'Master Permit Types'
,p_title=>'Master Permit Types'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>40
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT t.type_id,',
'       t.ptw_type,',
'       t.type_desc,',
'       CASE t.available WHEN ''Y'' THEN ''Available'' ELSE ''Unavailable'' END AS status,',
'       t.available,',
'       TO_CHAR(t.created_date, ''DD-MON-YYYY'') AS created_date,',
'       (SELECT COUNT(*) FROM ptw_pro.ptw_lv_company_types ct',
'         WHERE ct.type_id = t.type_id AND ct.is_active = ''Y'') AS company_count,',
'       (SELECT COUNT(*) FROM ptw_pro.ptw_lv_permits lp',
'         WHERE lp.ptw_type = t.ptw_type) AS permit_count',
'FROM   ptw_pro.ptw_types t',
'ORDER  BY t.ptw_type'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Master Permit Types'
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
 p_id=>wwv_flow_imp.id(52417575173182139)
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
,p_internal_uid=>52417575173182139
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(52417667044182140)
,p_db_column_name=>'TYPE_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'&nbsp.'
,p_column_link=>'f?p=&APP_ID.:25:&SESSION.::&DEBUG.:25:P25_TYPE_ID:#TYPE_ID#'
,p_column_linktext=>'<span class="fa fa-edit" title="Edit"></span>'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(52417707191182141)
,p_db_column_name=>'PTW_TYPE'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Ptw Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(52417888373182142)
,p_db_column_name=>'TYPE_DESC'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Type Desc'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(52417996163182143)
,p_db_column_name=>'STATUS'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(52418012388182144)
,p_db_column_name=>'AVAILABLE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Available'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(52418174587182145)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created Date'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(52418219153182146)
,p_db_column_name=>'COMPANY_COUNT'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Company Count'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(52418301100182147)
,p_db_column_name=>'PERMIT_COUNT'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Permit Count'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(52457308761504375)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'524574'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'TYPE_ID:PTW_TYPE:TYPE_DESC:STATUS:AVAILABLE:CREATED_DATE:COMPANY_COUNT'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(52418481774182148)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(52417425903182138)
,p_button_name=>'addPermitType'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Permit Type'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:25:&SESSION.::&DEBUG.:25::'
,p_icon_css_classes=>'fa-clipboard-check-alt'
);
wwv_flow_imp.component_end;
end;
/
