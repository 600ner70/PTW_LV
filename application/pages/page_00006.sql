prompt --application/pages/page_00006
begin
--   Manifest
--     PAGE: 00006
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
 p_id=>6
,p_name=>'Change History'
,p_alias=>'CHANGE-HISTORY'
,p_page_mode=>'MODAL'
,p_step_title=>'Change History'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(58090811857005130)
,p_plug_name=>'Change History'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>20
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PERMIT_ID,',
'       CASE PERMIT_STAGE',
'         WHEN ''CLIENT_OPERATIVE'' THEN ''Step 1: Client & Operative''',
'         WHEN ''APPLIANCES'' THEN ''Step 2: Appliances''',
'         WHEN ''SAFETY_VENTILATION'' THEN ''Step 3: Safety & Ventilation''',
'         WHEN ''COMBUSTION'' THEN ''Step 4: Combustion''',
'         WHEN ''ADDITIONAL_WORK'' THEN ''Step 5: Additional Work''',
'         WHEN ''SIGN_REVIEW'' THEN ''Step 6: Sign & Review''',
'       ELSE PERMIT_STAGE',
'       END as step_display,',
'       LATITUDE,',
'       LONGITUDE,',
'       CREATED_DATE,',
'       CREATED_BY,',
'       PERMIT_STAGE',
'from   GP15_STAGE_LOCATIONS',
'where  PERMIT_ID = :P6_PERMIT_ID',
'order by created_date DESC'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P6_PERMIT_ID'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
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
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(58090849057005131)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'PERMITPRO'
,p_internal_uid=>58090849057005131
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(58090946778005132)
,p_db_column_name=>'PERMIT_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'&nbsp;'
,p_column_link=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:10:P10_PERMIT_ID,P10_CURRENT_STAGE:#PERMIT_ID#,#PERMIT_STAGE#'
,p_column_linktext=>'<span class="fa fa-globe" title="Map"></span>'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(58091215081005134)
,p_db_column_name=>'LATITUDE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Latitude'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(58091292072005135)
,p_db_column_name=>'LONGITUDE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Longitude'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(58091352593005136)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Created Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH24:MI'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(58091536270005137)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(58091967249005142)
,p_db_column_name=>'STEP_DISPLAY'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Step Display'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(58092134160005143)
,p_db_column_name=>'PERMIT_STAGE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Permit Stage'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(58110799769791971)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'283634'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_DISPLAY:CREATED_DATE:CREATED_BY:PERMIT_ID:'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(58095076771005044)
,p_name=>'P6_PERMIT_ID'
,p_item_sequence=>10
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp.component_end;
end;
/
