prompt --application/pages/page_00015
begin
--   Manifest
--     PAGE: 00015
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
 p_id=>15
,p_name=>'Monitoring'
,p_alias=>'MONITORING'
,p_page_mode=>'MODAL'
,p_step_title=>'Monitoring'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(41968861118328819)
,p_plug_name=>'Monitoring'
,p_title=>'Monitoring for &P15_PERMIT_NUMBER.'
,p_region_template_options=>'#DEFAULT#:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>70
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(41968196091328812)
,p_plug_name=>'Monitoring report'
,p_title=>'List'
,p_parent_plug_id=>wwv_flow_imp.id(41968861118328819)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--accent15:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT monitoring_id,',
'       permit_id,',
'       ''LV MONITORING'' AS ptw_type,',
'       monitor_name,',
'       monitor_date,',
'       monitoring_status,',
'       CASE monitoring_status',
'           WHEN ''IN_PROGRESS'' THEN',
'               ''<a href="'' ',
'               || apex_page.get_url(',
'                    p_page        => 10,',
'                    p_clear_cache => ''10'',',
'                    p_items       => ''P10_PERMIT_ID,P10_MONITORING_ID'',',
'                    p_values      => permit_id || '','' || monitoring_id',
'                  )',
'               || ''"><span class="fa fa-pencil" title="Edit"></span></a>''',
'           ELSE',
'               ''<a href="''',
'               || apex_page.get_url(',
'                    p_page        => 10,',
'                    p_clear_cache => ''10'',',
'                    p_items       => ''P10_PERMIT_ID,P10_MONITORING_ID'',',
'                    p_values      => permit_id || '','' || monitoring_id',
'                  )',
'               || ''"><span class="fa fa-eye" title="View"></span></a>''',
'       END AS action_link',
'FROM   ptw_pro.ptw_lv_monitoring',
'WHERE  permit_id = :P15_PERMIT_ID',
'ORDER BY monitor_date DESC'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P15_PERMIT_ID,P15_PTW_TYPE'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'List'
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
 p_id=>wwv_flow_imp.id(41968258127328813)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_finder_drop_down=>'N'
,p_show_actions_menu=>'N'
,p_report_list_mode=>'NONE'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_enable_mail_download=>'Y'
,p_owner=>'PTW_PRO'
,p_internal_uid=>41968258127328813
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(41968331831328814)
,p_db_column_name=>'MONITORING_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Monitoring Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(41968402522328815)
,p_db_column_name=>'PERMIT_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Permit Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(41968536271328816)
,p_db_column_name=>'PTW_TYPE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Ptw Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(41968609653328817)
,p_db_column_name=>'MONITOR_NAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Monitor Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(41968797960328818)
,p_db_column_name=>'MONITOR_DATE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Monitor Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(47752824835890050)
,p_db_column_name=>'MONITORING_STATUS'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Monitoring Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(49364303034381904)
,p_db_column_name=>'ACTION_LINK'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Action'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(41985326222878177)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'419854'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ACTION_LINK:PTW_TYPE:MONITORING_STATUS:MONITOR_NAME:MONITOR_DATE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(41969035350328821)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(41968861118328819)
,p_button_name=>'EXIT'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Exit'
,p_button_position=>'CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(41968968041328820)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(41968861118328819)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create New'
,p_button_position=>'CREATE'
,p_button_redirect_url=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:10:P10_PERMIT_ID:&P15_PERMIT_ID.'
,p_button_condition=>'P15_WORKFLOW_STATUS'
,p_button_condition2=>'STARTED'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(41967839302328809)
,p_name=>'P15_PERMIT_ID'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(41967944550328810)
,p_name=>'P15_PERMIT_NUMBER'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(41968087770328811)
,p_name=>'P15_PTW_TYPE'
,p_item_sequence=>50
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(47748083904890002)
,p_name=>'P15_WORKFLOW_STATUS'
,p_item_sequence=>60
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(47748582226890007)
,p_name=>'Back to Dashboard'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(41969035350328821)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(47748652073890008)
,p_event_id=>wwv_flow_imp.id(47748582226890007)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(47748162967890003)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Populate items'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'  SELECT workflow_status',
'  INTO   :P15_WORKFLOW_STATUS',
'  FROM   ptw_pro.ptw_lv_permits',
'  WHERE  permit_id = :P15_PERMIT_ID;',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    NULL;',
'END;',
'',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>47748162967890003
);
wwv_flow_imp.component_end;
end;
/
