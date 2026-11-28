prompt --application/pages/page_00031
begin
--   Manifest
--     PAGE: 00031
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
 p_id=>31
,p_name=>'Site Management'
,p_alias=>'SITE-MANAGEMENT'
,p_step_title=>'Site Management'
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
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(26419849891144614)
,p_protection_level=>'C'
,p_page_component_map=>'25'
,p_created_on=>wwv_flow_imp.dz('20260721210833Z')
,p_last_updated_on=>wwv_flow_imp.dz('20260723103526Z')
,p_created_by=>'PTW_PRO'
,p_last_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(62142161404885561)
,p_plug_name=>'Page Header'
,p_static_id=>'page-header'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>30
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_html CLOB;',
'BEGIN',
'    l_html := ''<div class="admin-page-header">''',
'           || ''  <h1>Site Management</h1>''',
'           || ''  <p>Manage sites within your company and raise permits on them.</p>''',
'           || ''</div>'';',
'    RETURN l_html;',
'END;'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_created_on=>wwv_flow_imp.dz('20260721210833Z')
,p_updated_on=>wwv_flow_imp.dz('20260721211051Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(62142209806885562)
,p_plug_name=>'Sites'
,p_static_id=>'teams'
,p_title=>'Sites'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>40
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'  SELECT s.site_id,',
'         s.site_name,',
'         CASE s.is_active WHEN ''Y'' THEN ''Active'' ELSE ''Inactive'' END AS status,',
'         s.is_active,',
'         (SELECT COUNT(*) FROM ptw_pro.ptw_lv_permits p',
'           WHERE p.site_id = s.site_id)             AS permit_count,',
'         TO_CHAR(s.created_date, ''DD-MON-YYYY HH24:MI'') AS created_date,',
'         s.created_by,',
'         TO_CHAR(s.modified_date, ''DD-MON-YYYY HH24:MI'') AS modified_date,',
'         s.modified_by',
'  FROM   ptw_pro.ptw_lv_sites s',
'  ORDER  BY s.site_name'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Sites'
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
,p_ai_enabled=>false
,p_created_on=>wwv_flow_imp.dz('20260721210833Z')
,p_updated_on=>wwv_flow_imp.dz('20260723103526Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(62142339392885563)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_internal_uid=>62142339392885563
,p_created_on=>wwv_flow_imp.dz('20260721210833Z')
,p_updated_on=>wwv_flow_imp.dz('20260723103526Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(62143074583885570)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>50
,p_column_identifier=>'G'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260721210833Z')
,p_updated_on=>wwv_flow_imp.dz('20260721214108Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(62142933372885569)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>40
,p_column_identifier=>'F'
,p_column_label=>'Created Date'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260721210833Z')
,p_updated_on=>wwv_flow_imp.dz('20260721214108Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(62142802223885567)
,p_db_column_name=>'IS_ACTIVE'
,p_display_order=>30
,p_column_identifier=>'D'
,p_column_label=>'Is Active'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260721210833Z')
,p_updated_on=>wwv_flow_imp.dz('20260721214108Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(62143252297885572)
,p_db_column_name=>'MODIFIED_BY'
,p_display_order=>70
,p_column_identifier=>'I'
,p_column_label=>'Modified By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260721210833Z')
,p_updated_on=>wwv_flow_imp.dz('20260721214108Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(62143105304885571)
,p_db_column_name=>'MODIFIED_DATE'
,p_display_order=>60
,p_column_identifier=>'H'
,p_column_label=>'Modified Date'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260721210833Z')
,p_updated_on=>wwv_flow_imp.dz('20260721214108Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(8876473179853313)
,p_db_column_name=>'PERMIT_COUNT'
,p_display_order=>100
,p_column_identifier=>'L'
,p_column_label=>'Permit Count'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260721210933Z')
,p_updated_on=>wwv_flow_imp.dz('20260721214108Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(8876235946853311)
,p_db_column_name=>'SITE_ID'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>'Edit'
,p_column_link=>'f?p=&APP_ID.:32:&SESSION.::&DEBUG.:32:P32_SITE_ID:#SITE_ID#'
,p_column_linktext=>'<span class="fa fa-edit" title="Edit"></span>'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260721210933Z')
,p_updated_on=>wwv_flow_imp.dz('20260721214223Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(8876396718853312)
,p_db_column_name=>'SITE_NAME'
,p_display_order=>90
,p_column_identifier=>'K'
,p_column_label=>'Site Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260721210933Z')
,p_updated_on=>wwv_flow_imp.dz('20260721214108Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(62142632608885566)
,p_db_column_name=>'STATUS'
,p_display_order=>20
,p_column_identifier=>'C'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260721210833Z')
,p_updated_on=>wwv_flow_imp.dz('20260721214108Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(62152722442927577)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'531639'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SITE_ID:SITE_NAME:STATUS:IS_ACTIVE:PERMIT_COUNT:CREATED_DATE:CREATED_BY:MODIFIED_DATE:MODIFIED_BY'
,p_created_on=>wwv_flow_imp.dz('20260721210833Z')
,p_updated_on=>wwv_flow_imp.dz('20260723103526Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(8993988316419555)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(62142209806885562)
,p_button_name=>'CREATE'
,p_static_id=>'create'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create Site'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:32:&SESSION.::&DEBUG.:32::'
,p_icon_css_classes=>'fa-users'
,p_created_on=>wwv_flow_imp.dz('20260721210833Z')
,p_updated_on=>wwv_flow_imp.dz('20260721213436Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(62149117733885688)
,p_name=>'P31_SITE_ID'
,p_item_sequence=>60
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260721210834Z')
,p_updated_on=>wwv_flow_imp.dz('20260721210933Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
