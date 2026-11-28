prompt --application/pages/page_00006
begin
--   Manifest
--     PAGE: 00006
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
 p_id=>6
,p_name=>'Permit History'
,p_alias=>'CHANGE-HISTORY'
,p_page_mode=>'MODAL'
,p_step_title=>'Permit History'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>2100407606326202693
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'25'
,p_created_on=>wwv_flow_imp.dz('20260228101732Z')
,p_last_updated_on=>wwv_flow_imp.dz('20260913164251Z')
,p_created_by=>'PTW_PRO'
,p_last_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8877776759853326)
,p_plug_name=>'Cancellation Notice'
,p_static_id=>'cancellation-notice'
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--danger'
,p_plug_template=>2040683448887306517
,p_plug_display_sequence=>30
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    r      ptw_pro.ptw_lv_cancellation_reason_v%ROWTYPE;',
'    v_html CLOB;',
'BEGIN',
'    SELECT * INTO r FROM ptw_pro.ptw_lv_cancellation_reason_v WHERE permit_id = :P6_PERMIT_ID;',
'',
'    IF r.is_concern_cancellation = ''Y'' THEN',
'        v_html := ''<div class="ptw-cancel-banner ptw-cancel-banner--concern">''',
'            || ''<strong>This permit was cancelled following a monitoring concern.</strong><br>''',
'            || ''Check failed: '' || r.check_label || ''<br>''',
'            || ''Concern: '' || r.concern_description || ''<br>''',
'            || ''Action taken: '' || r.actions_taken || ''<br>''',
'            || ''Reported by '' || r.concern_person_name',
'            || '' on '' || TO_CHAR(r.concern_datetime, ''DD-Mon-YYYY HH24:MI'')',
'            || ''</div>'';',
'    ELSE',
'        v_html := ''<div class="ptw-cancel-banner">''',
'            || ''<strong>This permit was cancelled.</strong><br>''',
'            || ''Cancelled by '' || r.cancel_person_name',
'            || '' on '' || TO_CHAR(r.cancel_datetime, ''DD-Mon-YYYY HH24:MI'')',
'            || ''</div>'';',
'    END IF;',
'',
'    RETURN v_html;',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        RETURN NULL;',
'END;'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_ajax_items_to_submit=>'P6_PERMIT_ID'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>'SELECT 1 FROM ptw_pro.ptw_lv_cancellation_reason_v WHERE permit_id = :P6_PERMIT_ID'
,p_created_on=>wwv_flow_imp.dz('20260725185830Z')
,p_updated_on=>wwv_flow_imp.dz('20260725191512Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(58090811857005130)
,p_plug_name=>'Permit History'
,p_static_id=>'permit-history'
,p_icon_css_classes=>'fa-history'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'WITH max_row AS ',
'  (',
'    SELECT MAX(created_date) max_date,',
'           permit_id,',
'           permit_stage',
'    FROM   ptw_pro.ptw_stage_locations',
'    GROUP BY permit_id,',
'             permit_stage',
'  )',
'select sl.PERMIT_ID,',
'       CASE sl.PERMIT_STAGE',
'        WHEN ''SITE_WORK_DETAILS''  THEN ''Site and Work Details''',
'        WHEN ''CONTROL_MEASURES''   THEN ''Control Measures''',
'        WHEN ''EQUIP_ISOLATION''    THEN ''Equipment Isolation''',
'        WHEN ''AUTHORISATION''      THEN ''Authorisation''',
'        WHEN ''LIVE''               THEN ''Live''',
'        WHEN ''MONITORING''         THEN ''Monitoring''',
'        WHEN ''MONITORING_CONCERN'' THEN ''Monitoring Concern''',
'        WHEN ''CLEARANCE''          THEN ''Clearance''',
'        WHEN ''CANCELLED''          THEN ''Cancelled''',
'        WHEN ''FIREWATCH_HW_COMPLETE''          THEN ''Fire Watch: Hot Works Completed''',
'        WHEN ''FIREWATCH_ATTEND_1ST_HR''        THEN ''Fire Watch: 100% Attendance (1st Hour)''',
'        WHEN ''FIREWATCH_CHECK_15MIN_2ND_HR''   THEN ''Fire Watch: Checked Every 15 Min (2nd Hour)''',
'        WHEN ''FIREWATCH_CHECK_30MIN_3RD_HR''   THEN ''Fire Watch: Checked Every 30 Min (3rd Hour)''',
'        WHEN ''FIREWATCH_REINSTATE_4TH_HR''     THEN ''Fire Watch: Reinstate Isolation (4th Hour)''',
'        WHEN ''FIREWATCH_FIRE_CHECKS_COMPLETE'' THEN ''Fire Watch: Completion of Fire Checks''',
'       ELSE sl.PERMIT_STAGE',
'       END as step_display,',
'       sl.LATITUDE,',
'       sl.LONGITUDE,',
'       TO_CHAR(sl.CREATED_DATE, ''DD-MON-YYYY HH24:MI'') AS CREATED_DATE,',
'       sl.CREATED_BY,',
'       sl.PERMIT_STAGE',
'from   ptw_pro.ptw_stage_locations sl',
'join   max_row mr on mr.permit_id = sl.permit_id',
'  and mr.permit_stage = sl.permit_stage',
'  and mr.max_date = sl.created_date ',
'where  sl.PERMIT_ID = :P6_PERMIT_ID',
'order by sl.created_date DESC'))
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
,p_created_on=>wwv_flow_imp.dz('20260228101732Z')
,p_updated_on=>wwv_flow_imp.dz('20260913164251Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(58090849057005131)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_actions_menu=>'N'
,p_report_list_mode=>'NONE'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_enable_mail_download=>'Y'
,p_internal_uid=>58090849057005131
,p_created_on=>wwv_flow_imp.dz('20260228101732Z')
,p_updated_on=>wwv_flow_imp.dz('20260421201326Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
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
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260228101732Z')
,p_updated_on=>wwv_flow_imp.dz('20260228101732Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(33350742505951421)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Created Date'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260318224741Z')
,p_updated_on=>wwv_flow_imp.dz('20260318224741Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
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
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260228101732Z')
,p_updated_on=>wwv_flow_imp.dz('20260228101732Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
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
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260228101732Z')
,p_updated_on=>wwv_flow_imp.dz('20260228101732Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(58090946778005132)
,p_db_column_name=>'PERMIT_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'&nbsp;'
,p_column_link=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:7:P7_PERMIT_ID,P7_CURRENT_STAGE,P7_CREATED_DATE:#PERMIT_ID#,#PERMIT_STAGE#,#CREATED_DATE#'
,p_column_linktext=>'<span class="fa fa-globe" title="Map"></span>'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260228101732Z')
,p_updated_on=>wwv_flow_imp.dz('20260318220408Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
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
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260228101732Z')
,p_updated_on=>wwv_flow_imp.dz('20260228101732Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
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
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260228101732Z')
,p_updated_on=>wwv_flow_imp.dz('20260228101732Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(58110799769791971)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'283634'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STEP_DISPLAY:CREATED_BY:CREATED_DATE:PERMIT_ID:'
,p_created_on=>wwv_flow_imp.dz('20260228101732Z')
,p_updated_on=>wwv_flow_imp.dz('20260318225048Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(58095076771005044)
,p_name=>'P6_PERMIT_ID'
,p_item_sequence=>10
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
,p_created_on=>wwv_flow_imp.dz('20260228101733Z')
,p_updated_on=>wwv_flow_imp.dz('20260228101733Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
