prompt --application/pages/page_00035
begin
--   Manifest
--     PAGE: 00035
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
 p_id=>35
,p_name=>'ATW Register'
,p_alias=>'ATW-REGISTER'
,p_step_title=>'ATW Register'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(57338469143019020)
,p_protection_level=>'C'
,p_page_component_map=>'18'
,p_created_on=>wwv_flow_imp.dz('20261017171201Z')
,p_last_updated_on=>wwv_flow_imp.dz('20261017184446Z')
,p_created_by=>'PTW_PRO'
,p_last_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(56993095377385746)
,p_plug_name=>'Authorities to Work'
,p_static_id=>'authorities-to-work'
,p_title=>'Authorities to Work'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>50
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT a.atw_id,',
'       NVL(a.atw_number, ''Not issued'')              AS atw_number,',
'       a.holder_name,',
'       a.holder_employer,',
'       a.site_name,',
'       a.effective_status,',
'       CASE a.effective_status',
'           WHEN ''ON_SITE''     THEN ''On site''',
'           WHEN ''ISSUED''      THEN ''Issued, not checked in''',
'           WHEN ''CHECKED_OUT'' THEN ''Checked out''',
'           WHEN ''EXPIRED''     THEN CASE a.not_checked_out WHEN ''Y''',
'                                        THEN ''Expired (never checked out)''',
'                                        ELSE ''Expired'' END',
'           WHEN ''REVOKED''     THEN ''Revoked''',
'           WHEN ''REQUESTED''   THEN ''Requested''',
'           WHEN ''DRAFT''       THEN ''Draft''',
'           WHEN ''CANCELLED''   THEN ''Cancelled''',
'       END                                          AS status_label,',
'       CASE a.effective_status',
'           WHEN ''ON_SITE''     THEN ''t-Badge--success''',
'           WHEN ''ISSUED''      THEN ''t-Badge--warning''',
'           WHEN ''REVOKED''     THEN ''t-Badge--danger''',
'           WHEN ''EXPIRED''     THEN ''t-Badge--danger''',
'           WHEN ''CHECKED_OUT'' THEN ''t-Badge--normal''',
'           ELSE                    ''t-Badge--info''',
'       END                                          AS badge_class,',
'       TO_CHAR(a.check_in_datetime,  ''HH24:MI'')     AS checked_in,',
'       TO_CHAR(a.check_out_datetime, ''HH24:MI'')     AS checked_out,',
'       a.issuer_name,',
'       CASE WHEN a.status IN (''DRAFT'', ''REQUESTED'')',
'            THEN apex_page.get_url(p_page => 36, p_clear_cache => ''36'',',
'                                   p_items => ''P36_ATW_ID'', p_values => a.atw_id)',
'            ELSE apex_page.get_url(p_page => 37, p_clear_cache => ''37'',',
'                                   p_items => ''P37_ATW_NUMBER'', p_values => a.atw_number)',
'       END                                          AS link_url',
'FROM   ptw_pro.ptw_lv_atw_v a',
'WHERE  a.valid_date = TO_DATE(:P35_DATE, ''DD-MON-YYYY'')',
'AND    a.status    <> ''CANCELLED'''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P35_DATE'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Authorities to Work'
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
,p_created_on=>wwv_flow_imp.dz('20261017172655Z')
,p_updated_on=>wwv_flow_imp.dz('20261017184446Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(56993148189385747)
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_internal_uid=>56993148189385747
,p_created_on=>wwv_flow_imp.dz('20261017172656Z')
,p_updated_on=>wwv_flow_imp.dz('20261017184446Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(56993270326385748)
,p_db_column_name=>'ATW_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Atw Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20261017172656Z')
,p_updated_on=>wwv_flow_imp.dz('20261017172656Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(56993390997385749)
,p_db_column_name=>'ATW_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Atw Number'
,p_column_link=>'#LINK_URL#'
,p_column_linktext=>'#ATW_NUMBER#'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20261017172656Z')
,p_updated_on=>wwv_flow_imp.dz('20261017172656Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(57349759709381105)
,p_db_column_name=>'BADGE_CLASS'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Badge Class'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20261017172656Z')
,p_updated_on=>wwv_flow_imp.dz('20261017172656Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(57349837686381106)
,p_db_column_name=>'CHECKED_IN'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Checked In'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20261017172656Z')
,p_updated_on=>wwv_flow_imp.dz('20261017172656Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(57349931932381107)
,p_db_column_name=>'CHECKED_OUT'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Checked Out'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20261017172656Z')
,p_updated_on=>wwv_flow_imp.dz('20261017172656Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(57349515238381103)
,p_db_column_name=>'EFFECTIVE_STATUS'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Effective Status'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20261017172656Z')
,p_updated_on=>wwv_flow_imp.dz('20261017172656Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(57349371256381101)
,p_db_column_name=>'HOLDER_EMPLOYER'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Holder Employer'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20261017172656Z')
,p_updated_on=>wwv_flow_imp.dz('20261017172656Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(56993438915385750)
,p_db_column_name=>'HOLDER_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Holder Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20261017172656Z')
,p_updated_on=>wwv_flow_imp.dz('20261017172656Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(57350096977381108)
,p_db_column_name=>'ISSUER_NAME'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Issuer Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20261017172656Z')
,p_updated_on=>wwv_flow_imp.dz('20261017172656Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(57350158133381109)
,p_db_column_name=>'LINK_URL'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Link Url'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20261017172656Z')
,p_updated_on=>wwv_flow_imp.dz('20261017172656Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(57349457350381102)
,p_db_column_name=>'SITE_NAME'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Site Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20261017172656Z')
,p_updated_on=>wwv_flow_imp.dz('20261017172656Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(57349659645381104)
,p_db_column_name=>'STATUS_LABEL'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Status'
,p_column_html_expression=>'<span class="t-Badge #BADGE_CLASS#">#STATUS_LABEL#</span>'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20261017172656Z')
,p_updated_on=>wwv_flow_imp.dz('20261017172656Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(57379039783876840)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ATW_ID:ATW_NUMBER:HOLDER_NAME:HOLDER_EMPLOYER:SITE_NAME:EFFECTIVE_STATUS:STATUS_LABEL:BADGE_CLASS:CHECKED_IN:CHECKED_OUT:ISSUER_NAME:LINK_URL'
,p_created_on=>wwv_flow_imp.dz('20261017184446Z')
,p_updated_on=>wwv_flow_imp.dz('20261017184446Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(56992648873385742)
,p_plug_name=>'Filter'
,p_static_id=>'filter'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>30
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017172655Z')
,p_updated_on=>wwv_flow_imp.dz('20261017172655Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(56992755822385743)
,p_name=>'On site now'
,p_static_id=>'on-site-now'
,p_title=>'On site now'
,p_template=>4072358936313175081
,p_display_sequence=>40
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-BadgeList--large:t-BadgeList--fixed:t-BadgeList--circular'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT site_name,',
'       COUNT(*) AS on_site',
'FROM   ptw_pro.ptw_lv_atw_v',
'WHERE  valid_date       = TO_DATE(:P35_DATE, ''DD-MON-YYYY'')',
'AND    effective_status = ''ON_SITE''',
'GROUP  BY site_name',
'ORDER  BY site_name'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P35_DATE'
,p_lazy_loading=>false
,p_query_row_template=>2104643962563030528
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'Nobody is checked in.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
,p_created_on=>wwv_flow_imp.dz('20261017172655Z')
,p_updated_on=>wwv_flow_imp.dz('20261017172656Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(56992914931385745)
,p_query_column_id=>2
,p_column_alias=>'ON_SITE'
,p_column_display_sequence=>20
,p_column_heading=>'On Site'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_updated_on=>wwv_flow_imp.dz('20261017172656Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(56992822168385744)
,p_query_column_id=>1
,p_column_alias=>'SITE_NAME'
,p_column_display_sequence=>10
,p_column_heading=>'Site Name'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_updated_on=>wwv_flow_imp.dz('20261017172656Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(57350570153381113)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(56993095377385746)
,p_button_name=>'ISSUE_ATW'
,p_static_id=>'issue-atw'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Issue Authority to Work'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:36:&SESSION.::&DEBUG.:36::'
,p_warn_on_unsaved_changes=>null
,p_created_on=>wwv_flow_imp.dz('20261017173346Z')
,p_updated_on=>wwv_flow_imp.dz('20261017174309Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(56992559635385741)
,p_name=>'P35_DATE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(56992648873385742)
,p_item_default=>'TO_CHAR(ptw_pro.ptw_atw_pkg.local_today, ''DD-MON-YYYY'')'
,p_item_default_type=>'EXPRESSION'
,p_item_default_language=>'PLSQL'
,p_prompt=>'Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017172655Z')
,p_updated_on=>wwv_flow_imp.dz('20261017172655Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(57350212819381110)
,p_name=>'Refresh regions On site now and Authorities to Work'
,p_static_id=>'refresh-regions-on-site-now-and-authorities-to-work'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P35_DATE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_created_on=>wwv_flow_imp.dz('20261017172655Z')
,p_updated_on=>wwv_flow_imp.dz('20261017172655Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(57350385673381111)
,p_event_id=>wwv_flow_imp.id(57350212819381110)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-refresh'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(56992755822385743)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'maintain_pagination', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017172655Z')
,p_updated_on=>wwv_flow_imp.dz('20261017172655Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(57350401688381112)
,p_event_id=>wwv_flow_imp.id(57350212819381110)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_static_id=>'native-refresh_1'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(56993095377385746)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'maintain_pagination', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261017172655Z')
,p_updated_on=>wwv_flow_imp.dz('20261017172655Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
