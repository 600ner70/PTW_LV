prompt --application/pages/page_00050
begin
--   Manifest
--     PAGE: 00050
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
 p_id=>50
,p_name=>'Permit Search'
,p_alias=>'PERMIT-SEARCH'
,p_step_title=>'Permit Search'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.ptw-badge {',
'    display: inline-block;',
'    padding: 4px 12px;',
'    border-radius: 12px;',
'    font-size: 0.75rem;',
'    font-weight: 600;',
'    text-transform: uppercase;',
'}',
'.ptw-badge--live       { background: #28a745; color: #ffffff; }',
'.ptw-badge--authorised { background: #6c757d; color: #ffffff; }',
'.ptw-badge--completed  { background: #6f42c1; color: #ffffff; }',
'.ptw-badge--lapsed     { background: #6c757d; color: #ffffff; }',
'.ptw-badge--suspended { background:  #fd7e14; color: #ffffff; }',
'.ptw-badge--cancelled  { background: #dc3545; color: #ffffff; }',
'.ptw-badge--inprogress { background: #17a2b8; color: #ffffff; }',
'',
unistr('/* Permit number link \2014 match page 1 teal */'),
'.t-Card-title a {',
'    color: #1a6cb5 !important;',
'    text-decoration: none !important;',
'    font-weight: 600 !important;',
'}',
'.t-Card-title a:hover {',
'    text-decoration: underline !important;',
'}'))
,p_step_template=>2526643373347724467
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(26419849891144614)
,p_protection_level=>'C'
,p_page_component_map=>'22'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(49754433545978464)
,p_plug_name=>'Search Results'
,p_region_template_options=>'#DEFAULT#:t-CardsRegion--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2072724515482255512
,p_plug_display_sequence=>40
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    p.permit_id,',
'    p.permit_number,',
'    p.site_details,',
'    p.area_of_works,',
'    p.work_description,',
'    p.supervising_company || '' - '' || p.person_in_charge_name AS person_in_charge,',
'    p.supervising_company,',
'    p.person_in_charge_name,',
'    p.workflow_status,',
'    p.created_by,',
'    p.auth_person_name,',
'    p.started_datetime,',
'    p.ended_datetime,',
'    p.created_date,',
'    p.ptw_type,',
'    ''<span class="ptw-badge '' ||',
'    CASE p.workflow_status',
'        WHEN ''STARTED''     THEN ''ptw-badge--live''',
'        WHEN ''COMPLETED''   THEN ''ptw-badge--completed''',
'        WHEN ''AUTHORISED''  THEN ''ptw-badge--authorised''',
'        WHEN ''LAPSED''      THEN ''ptw-badge--lapsed''',
'        WHEN ''SUSPENDED''   THEN ''ptw-badge--suspended''',
'        WHEN ''CANCELLED''   THEN ''ptw-badge--cancelled''',
'        WHEN ''IN_PROGRESS'' THEN ''ptw-badge--inprogress''',
'        ELSE ''ptw-badge--lapsed''',
'    END || ''">'' ||',
'    CASE p.workflow_status',
'        WHEN ''STARTED''     THEN ''Live''',
'        WHEN ''COMPLETED''   THEN ''Completed''',
'        WHEN ''AUTHORISED''  THEN ''Authorised''',
'        WHEN ''LAPSED''      THEN ''Lapsed''',
'        WHEN ''SUSPENDED''   THEN ''Suspended''',
'        WHEN ''CANCELLED''   THEN ''Cancelled''',
'        WHEN ''IN_PROGRESS'' THEN ''In Progress''',
'        ELSE p.workflow_status',
'    END || ''</span>'' AS status_badge_html,',
'    apex_page.get_url(',
'        p_page   => 300,',
'        p_items  => ''P300_PERMIT_ID,P300_RETURN_PAGE'',',
'        p_values => p.permit_id || '',50''',
'    ) AS pdf_url',
'FROM ptw_pro.ptw_lv_permits p'))
,p_query_order_by_type=>'ITEM'
,p_query_order_by=>'{"orderBys":[{"key":"PERMIT_ID","expr":"\"PERMIT_ID\" asc"},{"key":"PERSON_IN_CHARGE","expr":"\"PERSON_IN_CHARGE\" asc"},{"key":"WORKFLOW_STATUS","expr":"\"WORKFLOW_STATUS\" asc"},{"key":"CREATED_DATE","expr":"\"CREATED_DATE\" desc"}],"itemName":"P50'
||'_ORDER_BY"}'
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_plug_query_num_rows_type=>'SCROLL'
,p_show_total_row_count=>false
,p_pagination_display_position=>'BOTTOM_RIGHT'
);
wwv_flow_imp_page.create_card(
 p_id=>wwv_flow_imp.id(49758489812978507)
,p_region_id=>wwv_flow_imp.id(49754433545978464)
,p_layout_type=>'GRID'
,p_title_adv_formatting=>true
,p_title_html_expr=>'<a href="&PDF_URL.">&PERMIT_NUMBER.</a>'
,p_sub_title_adv_formatting=>true
,p_sub_title_html_expr=>'&STATUS_BADGE_HTML!RAW.'
,p_body_adv_formatting=>true
,p_body_html_expr=>wwv_flow_string.join(wwv_flow_t_varchar2(
'&PERSON_IN_CHARGE.<br>',
'&SITE_DETAILS!RAW.'))
,p_second_body_adv_formatting=>false
,p_media_adv_formatting=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(49754560449978464)
,p_plug_name=>'Search'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader js-addHiddenHeadingRoleDesc:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_02'
,p_location=>null
,p_plug_source_type=>'NATIVE_FACETED_SEARCH'
,p_filtered_region_id=>wwv_flow_imp.id(49754433545978464)
,p_landmark_label=>'Filters'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'batch_facet_search', 'N',
  'compact_numbers_threshold', '10000',
  'current_facets_selector', '#active_facets',
  'display_chart_for_top_n_values', '10',
  'show_charts', 'Y',
  'show_current_facets', 'E',
  'show_total_row_count', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(49757275480978489)
,p_plug_name=>'Button Bar'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noPadding:t-ButtonRegion--noUI'
,p_escape_on_http_output=>'Y'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>10
,p_query_type=>'SQL'
,p_plug_source=>'<div id="active_facets"></div>'
,p_plug_query_num_rows=>15
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(49757786603978498)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(49757275480978489)
,p_button_name=>'RESET'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Reset'
,p_button_position=>'NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:50:&APP_SESSION.::&DEBUG.:RR,50::'
,p_icon_css_classes=>'fa-undo'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(49364510900381906)
,p_name=>'P50_SITE_DETAILS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(49754560449978464)
,p_prompt=>'Sites'
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
 p_id=>wwv_flow_imp.id(49364658669381907)
,p_name=>'P50_CREATED_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(49754560449978464)
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
 p_id=>wwv_flow_imp.id(49754946303978478)
,p_name=>'P50_SEARCH'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(49754560449978464)
,p_prompt=>'Search'
,p_source=>'PERMIT_NUMBER,SITE_DETAILS,AREA_OF_WORKS,WORK_DESCRIPTION,PERSON_IN_CHARGE,SUPERVISING_COMPANY,PERSON_IN_CHARGE_NAME,WORKFLOW_STATUS,STATUS_DISPLAY,STATUS_CLASS,CREATED_BY,AUTH_PERSON_NAME,CURRENT_STEP,STEP_DISPLAY,PTW_TYPE'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_SEARCH'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'collapsed_search_field', 'N',
  'input_field', 'FACET',
  'search_type', 'ROW')).to_clob
,p_fc_collapsible=>false
,p_fc_initial_collapsed=>false
,p_fc_show_chart=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(49755365841978483)
,p_name=>'P50_WORKFLOW_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(49754560449978464)
,p_prompt=>'Workflow Status'
,p_source=>'WORKFLOW_STATUS'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Live;STARTED,Authorised;AUTHORISED,Completed;COMPLETED,Lapsed;LAPSED,In Progress;IN_PROGRESS,Suspended;SUSPENDED,Cancelled;CANCELLED'
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
 p_id=>wwv_flow_imp.id(49756939978978488)
,p_name=>'P50_PTW_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(49754560449978464)
,p_prompt=>'Ptw Type'
,p_source=>'PTW_TYPE'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov_sort_direction=>'ASC'
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
 p_id=>wwv_flow_imp.id(49758999036978511)
,p_name=>'P50_ORDER_BY'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(49754433545978464)
,p_item_display_point=>'ORDER_BY_ITEM'
,p_item_default=>'PERMIT_ID'
,p_prompt=>'Order By'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Permit Number;PERMIT_ID,Person In Charge;PERSON_IN_CHARGE,Workflow Status;WORKFLOW_STATUS,Created Date;CREATED_DATE'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(50565011258122733)
,p_name=>'P50_PERSON_IN_CHARGE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(49754560449978464)
,p_prompt=>'Person In Charge'
,p_source=>'PERSON_IN_CHARGE_NAME'
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
wwv_flow_imp.component_end;
end;
/
