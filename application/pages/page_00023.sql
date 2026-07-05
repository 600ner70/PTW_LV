prompt --application/pages/page_00023
begin
--   Manifest
--     PAGE: 00023
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
 p_id=>23
,p_name=>'Permit Types'
,p_alias=>'PERMIT-TYPES'
,p_step_title=>'Permit Types'
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
'.ptw-locked-note {',
'    color: #888;',
'    font-style: italic;',
'    margin-left: 6px;',
'    font-size: 0.9em;',
'}'))
,p_page_css_classes=>'ptw-locked-note'
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(26419849891144614)
,p_protection_level=>'C'
,p_page_component_map=>'25'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(52461800210584415)
,p_plug_name=>'Page Header'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>40
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
'           || ''  <h1>Permit Types</h1>''',
'           || ''  <p>Permit types your company is licensed to use. Use ''',
'           || ''     <strong>Add Type to Company</strong> to make additional ''',
'           || ''     master permit types available to your users.</p>''',
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
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(52461942092584416)
,p_name=>'Permit Types'
,p_title=>'Permit Types'
,p_template=>4072358936313175081
,p_display_sequence=>110
,p_icon_css_classes=>'fa-tags'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_grid_column_span=>6
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT x.type_id,',
'       x.type_desc,',
'       x.company_default,',
'       CASE :P23_SCOPE',
'           WHEN ''COMPANY'' THEN',
'               apex_item.select_list(1, x.company_setting, ''Yes;Y,No;N'',',
'                                      ''class="ptw-company-select"'')',
'               || apex_item.hidden(2, x.type_id)',
'           WHEN ''TEAM'' THEN',
'               apex_item.select_list(1, x.team_setting,',
'                   ''Inherit;INHERIT,Granted;Y,Denied;N'',',
'                   ''class="ptw-team-select"'')',
'               || apex_item.hidden(2, x.type_id)',
'           WHEN ''ENGINEER'' THEN',
'               apex_item.checkbox(1, x.type_id,',
'                   ''class="ptw-competency-checkbox"'' ||',
'                   '' data-type-desc="'' || APEX_ESCAPE.HTML(x.type_desc) || ''"'' ||',
'                   CASE WHEN x.engineer_setting = ''Y'' THEN '' checked="checked"'' END)',
'               || apex_item.hidden(2, x.type_id)',
'       END AS row_control,',
'       x.competency_confirmed_by,',
'       x.competency_confirmed_date',
'FROM (',
'    SELECT pt.type_id,',
'           pt.type_desc,',
'           ct.is_active                   AS company_default,',
'           NVL(ct.is_active, ''N'')         AS company_setting,',
'           NVL(tt.is_active, ''INHERIT'')   AS team_setting,',
'           NVL(ut.is_active, ''N'')         AS engineer_setting,',
'           ut.modified_by                 AS competency_confirmed_by,',
'           ut.modified_date               AS competency_confirmed_date',
'    FROM   ptw_pro.ptw_types pt',
'    JOIN   ptw_pro.ptw_lv_company_types ct',
'           ON ct.type_id = pt.type_id AND ct.company_id = :P23_EFFECTIVE_COMPANY_ID',
'    LEFT JOIN ptw_pro.ptw_lv_team_types tt',
'           ON tt.type_id = pt.type_id AND tt.team_id = :P23_TEAM_ID',
'    LEFT JOIN ptw_pro.ptw_lv_user_types ut',
'           ON ut.type_id = pt.type_id AND ut.user_id = :P23_ENGINEER_ID',
'    WHERE  pt.available = ''Y''',
'    AND    ct.is_active = ''Y''',
') x',
'ORDER BY x.type_desc'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P23_TEAM_ID,P23_ENGINEER_ID,P23_EFFECTIVE_COMPANY_ID'
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
 p_id=>wwv_flow_imp.id(52464597899584442)
,p_query_column_id=>1
,p_column_alias=>'TYPE_ID'
,p_column_display_sequence=>70
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(52464132863584438)
,p_query_column_id=>2
,p_column_alias=>'TYPE_DESC'
,p_column_display_sequence=>30
,p_column_heading=>'Description'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(53188057368153104)
,p_query_column_id=>3
,p_column_alias=>'COMPANY_DEFAULT'
,p_column_display_sequence=>80
,p_column_heading=>'Company Default'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(53188481829153108)
,p_query_column_id=>4
,p_column_alias=>'ROW_CONTROL'
,p_column_display_sequence=>120
,p_column_heading=>'Assignment'
,p_heading_alignment=>'LEFT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(53188223192153106)
,p_query_column_id=>5
,p_column_alias=>'COMPETENCY_CONFIRMED_BY'
,p_column_display_sequence=>100
,p_column_heading=>'Competency Confirmed By'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(53188314740153107)
,p_query_column_id=>6
,p_column_alias=>'COMPETENCY_CONFIRMED_DATE'
,p_column_display_sequence=>110
,p_column_heading=>'Competency Confirmed Date'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(52496227297962721)
,p_plug_name=>'Super User Current Company'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>50
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_override  VARCHAR2(50) := V(''G_OVERRIDE_COMPANY_ID'');',
'    v_name      VARCHAR2(200);',
'    v_html      CLOB;',
'BEGIN',
'    IF v_override IS NULL OR v_override = '''' THEN',
'        RETURN NULL;',
'    END IF;',
'',
'    SELECT company_name',
'    INTO   v_name',
'    FROM   ptw_pro.ptw_lv_companies',
'    WHERE  company_id = TO_NUMBER(v_override);',
'',
'    v_html := ''<p><strong>Switched to Company: </strong>'' ',
'           || apex_escape.html(v_name) || ''</p>'';',
'',
'    RETURN v_html;',
'',
'EXCEPTION',
'    WHEN OTHERS THEN RETURN NULL;',
'END;'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_plug_display_condition_type=>'FUNCTION_BODY'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_is_super VARCHAR2(1);',
'BEGIN',
'    SELECT is_super_user INTO v_is_super',
'    FROM   ptw_pro.ptw_lv_users',
'    WHERE  UPPER(username) = UPPER(:APP_USER)',
'    AND    is_active = ''Y'';',
'    RETURN v_is_super = ''Y'';',
'EXCEPTION',
'    WHEN OTHERS THEN RETURN FALSE;',
'END;'))
,p_plug_display_when_cond2=>'PLSQL'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(52464752525584444)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(52461942092584416)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'ABOVE_BOX'
,p_button_alignment=>'RIGHT'
,p_icon_css_classes=>'fa-save'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(52464996995584446)
,p_branch_name=>'Reload Permit Types'
,p_branch_action=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:23::'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53156753085466136)
,p_name=>'P23_SCOPE'
,p_item_sequence=>60
,p_item_default=>'COMPANY'
,p_prompt=>'Scope Selector'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Company;COMPANY,Team;TEAM,Engineer;ENGINEER'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '3',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53156811548466137)
,p_name=>'P23_TEAM_ID'
,p_item_sequence=>70
,p_prompt=>'Team'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT team_name d, team_id r',
'FROM   ptw_pro.ptw_lv_teams',
'WHERE  company_id = :P23_EFFECTIVE_COMPANY_ID  -- same resolution',
'                                           -- pattern as the',
'                                           -- rest of this page',
'AND    is_active = ''Y''',
'ORDER  BY team_name'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-- Select Team --'
,p_cHeight=>1
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53156945295466138)
,p_name=>'P23_ENGINEER_ID'
,p_item_sequence=>80
,p_prompt=>'Engineer'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT first_name || '' '' || last_name || '' ('' || username || '')'' d,',
'       user_id r',
'FROM   ptw_pro.ptw_lv_users',
'WHERE  company_id = :P23_EFFECTIVE_COMPANY_ID',
'AND    is_super_user = ''N''',
'AND    is_active = ''Y''',
'ORDER  BY last_name, first_name'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-- Select Engineer --'
,p_cHeight=>1
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53157013726466139)
,p_name=>'P23_COMPETENCY_ACK'
,p_item_sequence=>100
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53188544069153109)
,p_name=>'P23_EFFECTIVE_COMPANY_ID'
,p_item_sequence=>90
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(53188983958153113)
,p_validation_name=>'Team is not null'
,p_validation_sequence=>10
,p_validation=>'P23_TEAM_ID'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Team must be selected.',
''))
,p_validation_condition=>'P23_SCOPE'
,p_validation_condition2=>'TEAM'
,p_validation_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_associated_item=>wwv_flow_imp.id(53156811548466137)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(53189012131153114)
,p_validation_name=>'Engineer is not null'
,p_validation_sequence=>20
,p_validation=>'P23_ENGINEER_ID'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Engineer must be selected.'
,p_validation_condition=>'P23_SCOPE'
,p_validation_condition2=>'ENGINEER'
,p_validation_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_associated_item=>wwv_flow_imp.id(53156945295466138)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(53157874525466147)
,p_name=>'Session state'
,p_event_sequence=>5
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P23_SCOPE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53157925905466148)
,p_event_id=>wwv_flow_imp.id(53157874525466147)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'NULL;'
,p_attribute_02=>'P23_SCOPE'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(53157168571466140)
,p_name=>'Scope Switch to Team'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P23_SCOPE'
,p_condition_element=>'P23_SCOPE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'TEAM'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53157548128466144)
,p_event_id=>wwv_flow_imp.id(53157168571466140)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'NULL;'
,p_attribute_02=>'P23_SCOPE'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53157607649466145)
,p_event_id=>wwv_flow_imp.id(53157168571466140)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_TEAM_ID'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53157270575466141)
,p_event_id=>wwv_flow_imp.id(53157168571466140)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_TEAM_ID'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53157714910466146)
,p_event_id=>wwv_flow_imp.id(53157168571466140)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(52461942092584416)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53157411209466143)
,p_event_id=>wwv_flow_imp.id(53157168571466140)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(52461942092584416)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(53158060686466149)
,p_name=>'Scope Switch to Engineer'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P23_SCOPE'
,p_condition_element=>'P23_SCOPE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'ENGINEER'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53158141778466150)
,p_event_id=>wwv_flow_imp.id(53158060686466149)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_ENGINEER_ID'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53187850815153102)
,p_event_id=>wwv_flow_imp.id(53158060686466149)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P23_ENGINEER_ID'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53187753629153101)
,p_event_id=>wwv_flow_imp.id(53158060686466149)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(52461942092584416)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53187903083153103)
,p_event_id=>wwv_flow_imp.id(53158060686466149)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(52461942092584416)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(53188781398153111)
,p_name=>'Competency Confirm Dialog'
,p_event_sequence=>30
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.ptw-competency-checkbox'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53188810329153112)
,p_event_id=>wwv_flow_imp.id(53188781398153111)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'EVENT_SOURCE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var $cb = $(this.triggeringElement);',
'var typeDesc = $cb.data("type-desc");',
'',
'apex.confirm(',
'    "Confirm you have personally verified this engineer is " +',
'    "competent to issue " + typeDesc + "?",',
'    function(okPressed) {',
'        if (okPressed) {',
'            // P23_COMPETENCY_ACK is a real page item (unlike the',
'            // per-row checkbox above), so apex.item() is correct',
'            // and Oracle-documented here.',
'            apex.item("P23_COMPETENCY_ACK").setValue("Y");',
'        } else {',
'            $cb.prop("checked", false);',
'        }',
'    }',
');',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(53189215174153116)
,p_name=>'when change Team list'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P23_TEAM_ID'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53189348276153117)
,p_event_id=>wwv_flow_imp.id(53189215174153116)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(52461942092584416)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(53189782609153121)
,p_name=>'when change Engineer list'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P23_ENGINEER_ID'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53189863009153122)
,p_event_id=>wwv_flow_imp.id(53189782609153121)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(52461942092584416)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(53188634878153110)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_override   VARCHAR2(50) := V(''G_OVERRIDE_COMPANY_ID'');',
'    v_company_id NUMBER;',
'BEGIN',
'    IF v_override IS NOT NULL AND TRIM(v_override) IS NOT NULL THEN',
'        v_company_id := TO_NUMBER(TRIM(v_override));',
'    ELSE',
'        BEGIN',
'            SELECT company_id INTO v_company_id',
'            FROM   ptw_pro.ptw_lv_users',
'            WHERE  UPPER(username) = UPPER(SYS_CONTEXT(''APEX$SESSION'', ''APP_USER''))',
'            AND    is_super_user   = ''N''',
'            AND    is_active       = ''Y'';',
'        EXCEPTION',
'            WHEN NO_DATA_FOUND THEN',
'                v_company_id := NULL;',
'        END;',
'    END IF;',
'',
'    :P23_EFFECTIVE_COMPANY_ID := v_company_id;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>53188634878153110
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(52464836682584445)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save Permit Type Assignments'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_company_id NUMBER;',
'    v_override   VARCHAR2(50) := V(''G_OVERRIDE_COMPANY_ID'');',
'    v_exists     NUMBER;',
'    v_used       NUMBER;',
'    v_type_id    NUMBER;',
'    v_new_val    VARCHAR2(10);',
'BEGIN',
'    -- Resolve effective company_id - unchanged from v2 fix',
'    IF v_override IS NOT NULL AND TRIM(v_override) IS NOT NULL THEN',
'       v_company_id := TO_NUMBER(TRIM(v_override));',
'    ELSE',
'        BEGIN',
'           SELECT company_id',
'           INTO   v_company_id',
'           FROM   ptw_pro.ptw_lv_users',
'           WHERE  UPPER(username) = UPPER(SYS_CONTEXT(''APEX$SESSION'', ''APP_USER''))',
'           AND    is_super_user   = ''N''',
'           AND    is_active       = ''Y'';',
'        EXCEPTION',
'            WHEN NO_DATA_FOUND THEN',
'               apex_error.add_error(',
'                   p_message          => ''Unable to determine your company. Contact an administrator.'',',
'                   p_display_location => apex_error.c_inline_in_notification);',
'               RETURN;',
'       END;',
'    END IF;',
'    IF v_company_id IS NULL THEN',
'        apex_error.add_error(',
'        p_message          => ''No active company selected. Use "Set Active Company" first.'',',
'        p_display_location => apex_error.c_inline_in_notification);',
'        RETURN;',
'    END IF;',
'',
'    -- Server-side enforcement of the competency confirm dialog -',
'    -- don''t trust client-side JS alone for a safety attestation',
'    IF :P23_SCOPE = ''ENGINEER'' AND :P23_COMPETENCY_ACK != ''Y'' THEN',
'        -- Only block if at least one row is being SET to Y;',
'        -- unchecking (revoking) doesn''t need the ack.',
'        FOR i IN 1 .. apex_application.g_f02.count LOOP',
'            IF apex_application.g_f01(i) = ''Y'' THEN',
'                apex_error.add_error(',
'                    p_message          => ''Competency must be confirmed before saving.'',',
'                    p_display_location => apex_error.c_inline_in_notification);',
'                RETURN;',
'            END IF;',
'        END LOOP;',
'    END IF;',
'',
'    FOR i IN 1 .. apex_application.g_f02.count LOOP',
'        v_type_id := apex_application.g_f02(i);',
'        v_new_val := apex_application.g_f01(i);',
'        CASE :P23_SCOPE',
'        WHEN ''COMPANY'' THEN',
'',
'            SELECT COUNT(*) INTO v_exists',
'            FROM   ptw_pro.ptw_lv_company_types',
'            WHERE  type_id    = v_type_id',
'            AND    company_id = v_company_id;',
'',
'            IF v_new_val = ''Y'' AND v_exists = 0 THEN',
'                INSERT INTO ptw_pro.ptw_lv_company_types (company_id, type_id, is_active)',
'                VALUES (v_company_id, v_type_id, ''Y'');',
'            ELSIF v_new_val = ''N'' AND v_exists > 0 THEN',
'',
'                SELECT COUNT(*) INTO v_used',
'                FROM   ptw_pro.ptw_lv_permits p',
'                WHERE  p.ptw_type = (SELECT ptw_type FROM ptw_pro.ptw_types',
'                                     WHERE type_id = v_type_id);',
'',
'                IF v_used = 0 THEN',
'                   DELETE FROM ptw_pro.ptw_lv_company_types',
'                   WHERE  type_id    = v_type_id',
'                   AND    company_id = v_company_id;',
'',
'                   -- Cascade: revoking at company level invalidates',
'                   -- any narrower grants (v2 fix, unchanged)',
'                   DELETE FROM ptw_pro.ptw_lv_team_types',
'                   WHERE  company_id = v_company_id',
'                   AND    type_id    = v_type_id;',
'',
'                   DELETE FROM ptw_pro.ptw_lv_user_types',
'                   WHERE  company_id = v_company_id',
'                   AND    type_id    = v_type_id;',
'                END IF;',
'',
'            END IF;',
'',
'        WHEN ''TEAM'' THEN',
'',
'            IF v_new_val = ''INHERIT'' THEN',
'                DELETE FROM ptw_pro.ptw_lv_team_types',
'                WHERE  team_id = :P23_TEAM_ID AND type_id = v_type_id;',
'            ELSE',
'                MERGE INTO ptw_pro.ptw_lv_team_types tt',
'                USING (SELECT v_company_id AS company_id, :P23_TEAM_ID AS team_id,',
'                              v_type_id AS type_id FROM dual) src',
'                ON (tt.team_id = src.team_id AND tt.type_id = src.type_id)',
'                WHEN MATCHED THEN UPDATE SET is_active = v_new_val',
'                WHEN NOT MATCHED THEN INSERT (company_id, team_id, type_id, is_active)',
'                                      VALUES (src.company_id, src.team_id, src.type_id, v_new_val);',
'            END IF;',
'',
'        WHEN ''ENGINEER'' THEN',
'',
'            IF v_new_val = ''Y'' THEN',
'                MERGE INTO ptw_pro.ptw_lv_user_types ut',
'                USING (SELECT v_company_id AS company_id, :P23_ENGINEER_ID AS user_id,',
'                              v_type_id AS type_id FROM dual) src',
'                ON (ut.user_id = src.user_id AND ut.type_id = src.type_id)',
'                WHEN MATCHED THEN UPDATE SET is_active = ''Y''',
'                WHEN NOT MATCHED THEN INSERT (company_id, user_id, type_id, is_active)',
'                                      VALUES (src.company_id, src.user_id, src.type_id, ''Y'');',
'                -- created_by/modified_by stamped automatically -',
'                -- requires trg_ptw_lv_user_types_audit from',
'                -- STEP 0 (confirmed missing, added there)',
'            ELSE',
'                UPDATE ptw_pro.ptw_lv_user_types',
'                SET    is_active = ''N''',
'                WHERE  user_id = :P23_ENGINEER_ID AND type_id = v_type_id;',
'                -- row kept, not deleted - preserves created_by',
'                -- as historical record of original confirmation',
'            END IF;',
'',
'        END CASE;',
'',
'    END LOOP;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(52464752525584444)
,p_process_success_message=>'Permit types updated.'
,p_internal_uid=>52464836682584445
);
wwv_flow_imp.component_end;
end;
/
