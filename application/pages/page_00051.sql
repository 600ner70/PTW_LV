prompt --application/pages/page_00051
begin
--   Manifest
--     PAGE: 00051
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
 p_id=>51
,p_name=>'Permit Analytics'
,p_alias=>'PERMIT-ANALYTICS'
,p_step_title=>'Permit Analytics'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Refresh all chart and KPI regions after any filter change',
'function p51RefreshCharts() {',
'    apex.region(''p51-bar-company'').refresh();',
'    apex.region(''p51-pie-status'').refresh();',
'    apex.region(''p51-line-trend'').refresh();',
'}',
'',
unistr('// Called by chart bar onclick \2014 filters IR to that company'),
'function p51DrillCompany(companyVal) {',
'    apex.item(''P51_DRILL_COMPANY'').setValue(companyVal);',
'    apex.item(''P51_DRILL_STATUS'').setValue('''');',
'    var banner = document.getElementById(''p51-drill-banner'');',
'    var text   = document.getElementById(''p51-drill-text'');',
'    if (banner && text) {',
'        text.textContent = ''Filtered: Company = '' + companyVal;',
'        banner.classList.add(''active'');',
'    }',
'    apex.region(''p51-results'').refresh();',
'}',
'',
unistr('// Called by chart slice onclick \2014 filters IR to that status'),
'function p51DrillStatus(statusVal) {',
'    apex.item(''P51_DRILL_STATUS'').setValue(statusVal);',
'    apex.item(''P51_DRILL_COMPANY'').setValue('''');',
'    var banner = document.getElementById(''p51-drill-banner'');',
'    var text   = document.getElementById(''p51-drill-text'');',
'    if (banner && text) {',
'        text.textContent = ''Filtered: Status = '' + statusVal;',
'        banner.classList.add(''active'');',
'    }',
'    apex.region(''p51-results'').refresh();',
'}',
'',
'// Called by the Clear link in the drill banner',
'function p51ClearDrill() {',
'    apex.item(''P51_DRILL_STATUS'').setValue('''');',
'    apex.item(''P51_DRILL_COMPANY'').setValue('''');',
'    var banner = document.getElementById(''p51-drill-banner'');',
'    if (banner) banner.classList.remove(''active'');',
'    apex.region(''p51-results'').refresh();',
'}',
''))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.p51-kpi-strip {',
'    display: flex;',
'    gap: 12px;',
'    flex-wrap: wrap;',
'    margin-bottom: 4px;',
'}',
'.p51-kpi-box {',
'    flex: 1;',
'    min-width: 120px;',
'    background: #ffffff;',
'    border: 1px solid #e0e0e0;',
'    border-radius: 6px;',
'    padding: 14px 18px;',
'    text-align: center;',
'    box-shadow: 0 1px 3px rgba(0,0,0,0.06);',
'}',
'.p51-kpi-value {',
'    font-size: 2rem;',
'    font-weight: 700;',
'    color: #003366;',
'    line-height: 1.1;',
'}',
'.p51-kpi-label {',
'    font-size: 0.72rem;',
'    font-weight: 600;',
'    text-transform: uppercase;',
'    letter-spacing: 0.05em;',
'    color: #595959;',
'    margin-top: 4px;',
'}',
'.p51-kpi-box.kpi-live   .p51-kpi-value { color: #28a745; }',
'.p51-kpi-box.kpi-active .p51-kpi-value { color: #17a2b8; }',
'.p51-kpi-box.kpi-done   .p51-kpi-value { color: #6f42c1; }',
'.p51-kpi-box.kpi-cancel .p51-kpi-value { color: #dc3545; }',
'',
'.p51-drill-banner {',
'    display: none;',
'    background: #e8f4fd;',
'    border-left: 4px solid #17a2b8;',
'    padding: 8px 14px;',
'    border-radius: 0 4px 4px 0;',
'    margin-bottom: 8px;',
'    font-size: 0.875rem;',
'    color: #003366;',
'    font-weight: 600;',
'}',
'.p51-drill-banner.active {',
'    display: flex;',
'    justify-content: space-between;',
'    align-items: center;',
'}',
'.p51-drill-clear {',
'    cursor: pointer;',
'    color: #17a2b8;',
'    font-size: 0.8rem;',
'    font-weight: 400;',
'    text-decoration: underline;',
'}',
'',
'.ptw-badge {',
'    display: inline-block;',
'    padding: 3px 10px;',
'    border-radius: 12px;',
'    font-size: 0.72rem;',
'    font-weight: 600;',
'    text-transform: uppercase;',
'}',
'.ptw-badge--live       { background: #28a745; color: #fff; }',
'.ptw-badge--authorised { background: #6c757d; color: #fff; }',
'.ptw-badge--completed  { background: #6f42c1; color: #fff; }',
'.ptw-badge--lapsed     { background: #6c757d; color: #fff; }',
'.ptw-badge--suspended  { background: #fd7e14; color: #fff; }',
'.ptw-badge--cancelled  { background: #dc3545; color: #fff; }',
'.ptw-badge--inprogress { background: #17a2b8; color: #fff; }',
'',
'#p51_active_facets { margin-bottom: 8px; }',
''))
,p_step_template=>2526643373347724467
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(26419849891144614)
,p_protection_level=>'C'
,p_page_component_map=>'22'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(49365002800381911)
,p_name=>'Analytics Results'
,p_title=>'Permit Results'
,p_region_name=>'p51-results'
,p_template=>4072358936313175081
,p_display_sequence=>50
,p_icon_css_classes=>'fa-table'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    p.permit_id,',
'    p.permit_number,',
'    p.status_display,',
'    p.workflow_status,',
'    p.company,',
'    p.person_in_charge,',
'    p.site_details,',
'    p.created_date,',
'    TO_CHAR(p.created_date,    ''DD-Mon-YYYY'')          AS created_display,',
'    TO_CHAR(p.auth_datetime,   ''DD-Mon-YYYY HH24:MI'')  AS authorised_display,',
'    TO_CHAR(p.started_datetime,''DD-Mon-YYYY HH24:MI'')  AS started_display,',
'    TO_CHAR(p.ended_datetime,  ''DD-Mon-YYYY HH24:MI'')  AS ended_display,',
'    TO_CHAR(p.clear_datetime,  ''DD-Mon-YYYY HH24:MI'')  AS cleared_display,',
'    TO_CHAR(p.cancel_datetime, ''DD-Mon-YYYY HH24:MI'')  AS cancelled_display,',
'    p.has_clearance,',
'    p.has_cancellation,',
'    p.has_photos,',
'    ''<span class="ptw-badge '' ||',
'    CASE p.workflow_status',
'        WHEN ''STARTED''     THEN ''ptw-badge--live''',
'        WHEN ''COMPLETED''   THEN ''ptw-badge--completed''',
'        WHEN ''AUTHORISED''  THEN ''ptw-badge--authorised''',
'        WHEN ''LAPSED''      THEN ''ptw-badge--lapsed''',
'        WHEN ''SUSPENDED''   THEN ''ptw-badge--suspended''',
'        WHEN ''CANCELLED''   THEN ''ptw-badge--cancelled''',
'        WHEN ''IN_PROGRESS'' THEN ''ptw-badge--inprogress''',
'        ELSE                    ''ptw-badge--lapsed''',
'    END || ''">'' || p.status_display || ''</span>''        AS status_badge_html,',
'    apex_page.get_url(',
'        p_page   => 2,',
'        p_items  => ''P2_PERMIT_ID'',',
'        p_values => p.permit_id',
'    )                                                   AS permit_link',
'FROM ptw_pro.ptw_lv_analytics_v p',
'WHERE (',
'    :P51_DRILL_STATUS  IS NULL',
'    OR p.workflow_status = :P51_DRILL_STATUS',
')',
'AND (',
'    :P51_DRILL_COMPANY IS NULL',
'    OR p.company        = :P51_DRILL_COMPANY',
')'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P51_DRILL_STATUS,P51_DRILL_COMPANY'
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
 p_id=>wwv_flow_imp.id(49367335075381934)
,p_query_column_id=>1
,p_column_alias=>'PERMIT_ID'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(49367465681381935)
,p_query_column_id=>2
,p_column_alias=>'PERMIT_NUMBER'
,p_column_display_sequence=>20
,p_column_heading=>'Permit'
,p_column_link=>'f?p=&APP_ID.:2:&APP_SESSION.::&DEBUG.:2:P2_PERMIT_ID:#PERMIT_ID#'
,p_column_linktext=>'#PERMIT_NUMBER#'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(49367524624381936)
,p_query_column_id=>3
,p_column_alias=>'STATUS_DISPLAY'
,p_column_display_sequence=>160
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(49367626089381937)
,p_query_column_id=>4
,p_column_alias=>'WORKFLOW_STATUS'
,p_column_display_sequence=>170
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(49367766201381938)
,p_query_column_id=>5
,p_column_alias=>'COMPANY'
,p_column_display_sequence=>40
,p_column_heading=>'Company'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(49367812721381939)
,p_query_column_id=>6
,p_column_alias=>'PERSON_IN_CHARGE'
,p_column_display_sequence=>50
,p_column_heading=>'Person In Charge'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(49367958426381940)
,p_query_column_id=>7
,p_column_alias=>'SITE_DETAILS'
,p_column_display_sequence=>60
,p_column_heading=>'Site'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(49368040485381941)
,p_query_column_id=>8
,p_column_alias=>'CREATED_DATE'
,p_column_display_sequence=>180
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(49368123122381942)
,p_query_column_id=>9
,p_column_alias=>'CREATED_DISPLAY'
,p_column_display_sequence=>70
,p_column_heading=>'Created'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(49368227142381943)
,p_query_column_id=>10
,p_column_alias=>'AUTHORISED_DISPLAY'
,p_column_display_sequence=>80
,p_column_heading=>'Authorised'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(49368351053381944)
,p_query_column_id=>11
,p_column_alias=>'STARTED_DISPLAY'
,p_column_display_sequence=>90
,p_column_heading=>'Started (LIVE)'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(49368481263381945)
,p_query_column_id=>12
,p_column_alias=>'ENDED_DISPLAY'
,p_column_display_sequence=>100
,p_column_heading=>'Permit Expiry'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(49368564838381946)
,p_query_column_id=>13
,p_column_alias=>'CLEARED_DISPLAY'
,p_column_display_sequence=>110
,p_column_heading=>'Cleared'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(49368638597381947)
,p_query_column_id=>14
,p_column_alias=>'CANCELLED_DISPLAY'
,p_column_display_sequence=>120
,p_column_heading=>'Cancelled'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(49368732489381948)
,p_query_column_id=>15
,p_column_alias=>'HAS_CLEARANCE'
,p_column_display_sequence=>130
,p_column_heading=>'Clearance Data?'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(49368826823381949)
,p_query_column_id=>16
,p_column_alias=>'HAS_CANCELLATION'
,p_column_display_sequence=>140
,p_column_heading=>'Cancellation Data?'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(49368901212381950)
,p_query_column_id=>17
,p_column_alias=>'HAS_PHOTOS'
,p_column_display_sequence=>150
,p_column_heading=>'Photos?'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(50561856444122701)
,p_query_column_id=>18
,p_column_alias=>'STATUS_BADGE_HTML'
,p_column_display_sequence=>30
,p_column_heading=>'Status'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(50561956581122702)
,p_query_column_id=>19
,p_column_alias=>'PERMIT_LINK'
,p_column_display_sequence=>200
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(49367146226381932)
,p_plug_name=>'Filters'
,p_title=>'Filters'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>60
,p_plug_display_point=>'REGION_POSITION_02'
,p_location=>null
,p_plug_source_type=>'NATIVE_FACETED_SEARCH'
,p_filtered_region_id=>wwv_flow_imp.id(49365002800381911)
,p_landmark_label=>'Filters'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'batch_facet_search', 'N',
  'compact_numbers_threshold', '10000',
  'current_facets_selector', '#p51_active_facets',
  'show_charts', 'N',
  'show_current_facets', 'E',
  'show_total_row_count', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(50562546560122708)
,p_plug_name=>'Chart Controls'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>60
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div id="p51_active_facets" style="margin-bottom:6px;"></div>',
'<div id="p51-drill-banner" class="p51-drill-banner">',
'    <span id="p51-drill-text">Filtered by chart selection</span>',
'    <span class="p51-drill-clear" onclick="p51ClearDrill()">&#10005; Clear filter</span>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(50562661707122709)
,p_plug_name=>'Permits by Company'
,p_title=>'Permits by Company'
,p_region_name=>'p51-bar-company'
,p_icon_css_classes=>'fa-bar-chart'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'Y'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>70
,p_plug_grid_column_span=>6
,p_location=>null
,p_plug_source_type=>'NATIVE_JET_CHART'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(50562720136122710)
,p_region_id=>wwv_flow_imp.id(50562661707122709)
,p_chart_type=>'bar'
,p_height=>'320'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_connect_nulls=>'Y'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_legend_rendered=>'off'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(50562869798122711)
,p_chart_id=>wwv_flow_imp.id(50562720136122710)
,p_seq=>10
,p_name=>'Permits'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    company          AS label,',
'    COUNT(*)         AS permit_count',
'FROM ptw_pro.ptw_lv_analytics_v',
'GROUP BY company',
'ORDER BY COUNT(*) DESC',
'FETCH FIRST 15 ROWS ONLY'))
,p_items_value_column_name=>'PERMIT_COUNT'
,p_items_label_column_name=>'LABEL'
,p_color=>'#344b5c'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_link_target=>'javascript:p51DrillCompany(''#LABEL#'');'
,p_link_target_type=>'REDIRECT_URL'
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(50562921409122712)
,p_chart_id=>wwv_flow_imp.id(50562720136122710)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_tick_label_rotation=>'auto'
,p_tick_label_position=>'outside'
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(50563034779122713)
,p_chart_id=>wwv_flow_imp.id(50562720136122710)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_format_type=>'decimal'
,p_decimal_places=>0
,p_format_scaling=>'none'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(50563124160122714)
,p_plug_name=>'Permits by Status'
,p_title=>'Permits by Status'
,p_region_name=>'p51-pie-status'
,p_icon_css_classes=>'fa-pie-chart'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'Y'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>80
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>6
,p_location=>null
,p_plug_source_type=>'NATIVE_JET_CHART'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(50563288667122715)
,p_region_id=>wwv_flow_imp.id(50563124160122714)
,p_chart_type=>'pie'
,p_height=>'320'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_value_format_type=>'decimal'
,p_value_decimal_places=>0
,p_value_format_scaling=>'none'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_value=>true
,p_legend_rendered=>'on'
,p_legend_position=>'auto'
,p_pie_other_threshold=>0
,p_pie_selection_effect=>'highlight'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(50563338076122716)
,p_chart_id=>wwv_flow_imp.id(50563288667122715)
,p_seq=>10
,p_name=>'Status Breakdown'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    status_display   AS label,',
'    workflow_status  AS status_val,',
'    COUNT(*)         AS permit_count,',
'    status_colour    AS series_color',
'FROM ptw_pro.ptw_lv_analytics_v',
'GROUP BY status_display, workflow_status, status_colour',
'ORDER BY COUNT(*) DESC'))
,p_items_value_column_name=>'PERMIT_COUNT'
,p_items_label_column_name=>'LABEL'
,p_color=>'#SERIES_COLOR#'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'LABEL'
,p_link_target=>'javascript:p51DrillStatus(''#STATUS_VAL#'');'
,p_link_target_type=>'REDIRECT_URL'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(50563603389122719)
,p_plug_name=>'Permit Trend'
,p_region_name=>'p51-line-trend'
,p_icon_css_classes=>'fa-line-chart'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'Y'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>90
,p_location=>null
,p_plug_source_type=>'NATIVE_JET_CHART'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(50563765858122720)
,p_region_id=>wwv_flow_imp.id(50563603389122719)
,p_chart_type=>'line'
,p_height=>'280'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_connect_nulls=>'Y'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_legend_rendered=>'off'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(50563859619122721)
,p_chart_id=>wwv_flow_imp.id(50563765858122720)
,p_seq=>10
,p_name=>'Total Permits'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    CASE :P51_TIME_GROUPING',
'        WHEN ''DAILY''  THEN TO_CHAR(group_daily,   ''DD-Mon-YYYY'')',
'        WHEN ''WEEKLY'' THEN ''Wk '' || TO_CHAR(group_weekly, ''IW YYYY'')',
'        ELSE               TO_CHAR(group_monthly,  ''Mon-YYYY'')',
'    END              AS period_label,',
'    CASE :P51_TIME_GROUPING',
'        WHEN ''DAILY''  THEN group_daily',
'        WHEN ''WEEKLY'' THEN group_weekly',
'        ELSE               group_monthly',
'    END              AS period_date,',
'    COUNT(*)         AS permit_count',
'FROM ptw_pro.ptw_lv_analytics_v',
'GROUP BY',
'    CASE :P51_TIME_GROUPING',
'        WHEN ''DAILY''  THEN group_daily',
'        WHEN ''WEEKLY'' THEN group_weekly',
'        ELSE               group_monthly',
'    END,',
'    CASE :P51_TIME_GROUPING',
'        WHEN ''DAILY''  THEN TO_CHAR(group_daily,   ''DD-Mon-YYYY'')',
'        WHEN ''WEEKLY'' THEN ''Wk '' || TO_CHAR(group_weekly, ''IW YYYY'')',
'        ELSE               TO_CHAR(group_monthly,  ''Mon-YYYY'')',
'    END',
'ORDER BY',
'    CASE :P51_TIME_GROUPING',
'        WHEN ''DAILY''  THEN group_daily',
'        WHEN ''WEEKLY'' THEN group_weekly',
'        ELSE               group_monthly',
'    END'))
,p_ajax_items_to_submit=>'P51_TIME_GROUPING, P51_WORKFLOW_STATUS,P51_COMPANY, P51_SITE_DETAILS,P51_PERSON_IN_CHARGE, P51_CREATED_DATE, P51_SEARCH'
,p_items_value_column_name=>'PERMIT_COUNT'
,p_items_label_column_name=>'PERIOD_LABEL'
,p_color=>'#4a9fd4'
,p_line_style=>'solid'
,p_line_type=>'auto'
,p_marker_rendered=>'auto'
,p_marker_shape=>'auto'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(50563952723122722)
,p_chart_id=>wwv_flow_imp.id(50563765858122720)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_tick_label_rotation=>'auto'
,p_tick_label_position=>'outside'
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(50564054709122723)
,p_chart_id=>wwv_flow_imp.id(50563765858122720)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_format_type=>'decimal'
,p_decimal_places=>0
,p_format_scaling=>'none'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(49364851127381909)
,p_name=>'P51_DRILL_STATUS'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(49364990378381910)
,p_name=>'P51_DRILL_COMPANY'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(49367252259381933)
,p_name=>'P51_SEARCH'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(49367146226381932)
,p_prompt=>'Search'
,p_source=>'PERMIT_NUMBER, SITE_DETAILS, COMPANY,PERSON_IN_CHARGE, STATUS_DISPLAY, WORKFLOW_STATUS'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_SEARCH'
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'input_field', 'FACET',
  'search_type', 'ROW')).to_clob
,p_fc_show_chart=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(50562044170122703)
,p_name=>'P51_WORKFLOW_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(49367146226381932)
,p_prompt=>'Workflow Status'
,p_source=>'WORKFLOW_STATUS'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov_sort_direction=>'ASC'
,p_item_template_options=>'#DEFAULT#'
,p_fc_show_label=>true
,p_fc_collapsible=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>7
,p_fc_filter_values=>false
,p_fc_sort_by_top_counts=>true
,p_fc_show_selected_first=>false
,p_fc_show_chart=>true
,p_fc_initial_chart=>false
,p_fc_actions_filter=>true
,p_fc_display_as=>'INLINE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(50562189267122704)
,p_name=>'P51_COMPANY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(49367146226381932)
,p_prompt=>'Company'
,p_source=>'COMPANY'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov_sort_direction=>'ASC'
,p_item_template_options=>'#DEFAULT#'
,p_fc_show_label=>true
,p_fc_collapsible=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>7
,p_fc_filter_values=>false
,p_fc_sort_by_top_counts=>true
,p_fc_show_selected_first=>false
,p_fc_show_chart=>true
,p_fc_initial_chart=>false
,p_fc_actions_filter=>true
,p_fc_display_as=>'INLINE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(50562252886122705)
,p_name=>'P51_PERSON_IN_CHARGE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(49367146226381932)
,p_prompt=>'Person In Charge'
,p_source=>'PERSON_IN_CHARGE'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov_sort_direction=>'ASC'
,p_item_template_options=>'#DEFAULT#'
,p_fc_show_label=>true
,p_fc_collapsible=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>7
,p_fc_filter_values=>false
,p_fc_sort_by_top_counts=>true
,p_fc_show_selected_first=>false
,p_fc_show_chart=>true
,p_fc_initial_chart=>false
,p_fc_actions_filter=>true
,p_fc_display_as=>'INLINE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(50562364304122706)
,p_name=>'P51_SITE_DETAILS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(49367146226381932)
,p_prompt=>'Site Details'
,p_source=>'SITE_DETAILS'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov_sort_direction=>'ASC'
,p_item_template_options=>'#DEFAULT#'
,p_fc_show_label=>true
,p_fc_collapsible=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>7
,p_fc_filter_values=>false
,p_fc_sort_by_top_counts=>true
,p_fc_show_selected_first=>false
,p_fc_show_chart=>true
,p_fc_initial_chart=>false
,p_fc_actions_filter=>true
,p_fc_display_as=>'INLINE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(50562461208122707)
,p_name=>'P51_CREATED_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(49367146226381932)
,p_prompt=>'Created Date'
,p_format_mask=>'DD-MON-YYYY'
,p_source=>'CREATED_DATE'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_RANGE'
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'manual_entry', 'N',
  'select_multiple', 'N')).to_clob
,p_fc_show_label=>true
,p_fc_collapsible=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_chart=>false
,p_fc_display_as=>'INLINE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(50564173043122724)
,p_name=>'P51_TIME_GROUPING'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(50563603389122719)
,p_item_default=>'MONTHLY'
,p_prompt=>'Group By'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:Monthly;MONTHLY,Weekly;WEEKLY,Daily;DAILY'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(50564285901122725)
,p_name=>'Facet Change - Refresh Charts'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(49365002800381911)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(50564313343122726)
,p_event_id=>wwv_flow_imp.id(50564285901122725)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'p51RefreshCharts();'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(50564469247122727)
,p_name=>'Time Grouping Change'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P51_TIME_GROUPING'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(50564568660122728)
,p_event_id=>wwv_flow_imp.id(50564469247122727)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(50563603389122719)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(50564658304122729)
,p_name=>'Drill Company - Refresh Report'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P51_DRILL_COMPANY'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(50564712982122730)
,p_event_id=>wwv_flow_imp.id(50564658304122729)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(49365002800381911)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(50564848440122731)
,p_name=>'Drill Status - Refresh Report'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P51_DRILL_STATUS'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(50564927828122732)
,p_event_id=>wwv_flow_imp.id(50564848440122731)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(49365002800381911)
,p_attribute_01=>'N'
);
wwv_flow_imp.component_end;
end;
/
