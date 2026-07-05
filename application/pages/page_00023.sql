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
,p_display_sequence=>60
,p_icon_css_classes=>'fa-tags'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_grid_column_span=>6
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT x.type_id,',
'       x.ptw_type,',
'       x.type_desc,',
'       x.permit_count,',
'       CASE',
'           WHEN x.permit_count = 0 THEN',
'               apex_item.select_list(1, x.current_assigned, ''Yes;Y,No;N'',',
'                                      ''class="ptw-assigned-select"'')',
'               || apex_item.hidden(2, x.type_id)',
'           ELSE',
'               (CASE x.current_assigned WHEN ''Y'' THEN ''Yes'' ELSE ''No'' END)',
'               || '' <span class="ptw-locked-note">(in use - cannot remove)</span>''',
'       END AS assigned',
'FROM (',
'    SELECT t.type_id,',
'           t.ptw_type,',
'           t.type_desc,',
'           NVL((SELECT ct.is_active FROM ptw_pro.ptw_lv_company_types ct',
'                 WHERE ct.type_id = t.type_id), ''N'') AS current_assigned,',
'           (SELECT COUNT(*) FROM ptw_pro.ptw_lv_permits p',
'             WHERE p.ptw_type = t.ptw_type) AS permit_count',
'    FROM   ptw_pro.ptw_types t',
'    WHERE  t.available = ''Y''',
'       OR  EXISTS (SELECT 1 FROM ptw_pro.ptw_lv_company_types ct',
'                     WHERE ct.type_id = t.type_id)',
') x',
'ORDER BY x.ptw_type'))
,p_display_when_condition=>'G_OVERRIDE_COMPANY_ID'
,p_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_ajax_enabled=>'Y'
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
 p_id=>wwv_flow_imp.id(52464004838584437)
,p_query_column_id=>2
,p_column_alias=>'PTW_TYPE'
,p_column_display_sequence=>20
,p_column_heading=>'Type Code'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(52464132863584438)
,p_query_column_id=>3
,p_column_alias=>'TYPE_DESC'
,p_column_display_sequence=>30
,p_column_heading=>'Description'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(52464474529584441)
,p_query_column_id=>4
,p_column_alias=>'PERMIT_COUNT'
,p_column_display_sequence=>60
,p_column_heading=>'Permits Using This Type'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(52464630543584443)
,p_query_column_id=>5
,p_column_alias=>'ASSIGNED'
,p_column_display_sequence=>80
,p_column_heading=>'Assigned to us'
,p_heading_alignment=>'LEFT'
,p_display_as=>'WITHOUT_MODIFICATION'
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
'    v_new_val    VARCHAR2(1);',
'BEGIN',
'    -- Resolve effective company_id: Super User override takes priority,',
'    -- same pattern as the rest of this page (see report region above)',
'    IF v_override IS NOT NULL AND TRIM(v_override) IS NOT NULL THEN',
'        v_company_id := TO_NUMBER(TRIM(v_override));',
'    ELSE',
'        BEGIN',
'            SELECT company_id',
'            INTO   v_company_id',
'            FROM   ptw_pro.ptw_lv_users',
'            WHERE  UPPER(username) = UPPER(SYS_CONTEXT(''APEX$SESSION'', ''APP_USER''))',
'            AND    is_super_user   = ''N''',
'            AND    is_active       = ''Y'';',
'        EXCEPTION',
'            WHEN NO_DATA_FOUND THEN',
'                DECLARE',
'                    v_is_super VARCHAR2(1);',
'                BEGIN',
'                    SELECT is_super_user INTO v_is_super',
'                    FROM   ptw_pro.ptw_lv_users',
'                    WHERE  UPPER(username) = UPPER(SYS_CONTEXT(''APEX$SESSION'', ''APP_USER''))',
'                    AND    is_active = ''Y'';',
'',
'                    IF v_is_super = ''Y'' THEN',
'                        apex_error.add_error(',
'                            p_message          => ''No active company selected. Use "Set Active Company" first.'',',
'                            p_display_location => apex_error.c_inline_in_notification);',
'                    ELSE',
'                        apex_error.add_error(',
'                            p_message          => ''Unable to determine your company. Contact an administrator.'',',
'                            p_display_location => apex_error.c_inline_in_notification);',
'                    END IF;',
'                EXCEPTION',
'                    WHEN NO_DATA_FOUND THEN',
'                        apex_error.add_error(',
'                            p_message          => ''User account not found or inactive.'',',
'                            p_display_location => apex_error.c_inline_in_notification);',
'                END;',
'                RETURN;',
'        END;',
'    END IF;',
'',
'    IF v_company_id IS NULL THEN',
'        apex_error.add_error(',
'            p_message          => ''No active company selected. Use "Set Active Company" first.'',',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RETURN;',
'    END IF;',
'',
'    FOR i IN 1 .. apex_application.g_f02.count LOOP',
'        v_type_id := apex_application.g_f02(i);',
'        v_new_val := apex_application.g_f01(i);',
'',
'        -- Explicit company_id filter: VPD does NOT scope this for super',
'        -- users (company_policy returns NULL/no-restriction for them),',
'        -- so this check must be company-safe on its own, independent of VPD.',
'        SELECT COUNT(*) INTO v_exists',
'        FROM   ptw_pro.ptw_lv_company_types',
'        WHERE  type_id    = v_type_id',
'        AND    company_id = v_company_id;',
'',
'        IF v_new_val = ''Y'' AND v_exists = 0 THEN',
'',
'            INSERT INTO ptw_pro.ptw_lv_company_types (company_id, type_id, is_active)',
'            VALUES (v_company_id, v_type_id, ''Y'');',
'',
'        ELSIF v_new_val = ''N'' AND v_exists > 0 THEN',
'',
'            SELECT COUNT(*) INTO v_used',
'            FROM   ptw_pro.ptw_lv_permits p',
'            WHERE  p.ptw_type = (SELECT ptw_type FROM ptw_pro.ptw_types',
'                                   WHERE type_id = v_type_id);',
'',
'            IF v_used = 0 THEN',
'                DELETE FROM ptw_pro.ptw_lv_company_types',
'                WHERE  type_id    = v_type_id',
'                AND    company_id = v_company_id;',
'',
'                DELETE FROM ptw_pro.ptw_lv_team_types',
'                WHERE  company_id = v_company_id',
'                AND    type_id    = v_type_id;',
'',
'                DELETE FROM ptw_pro.ptw_lv_user_types',
'                WHERE  company_id = v_company_id',
'                AND    type_id    = v_type_id;',
'            END IF;',
'',
'        END IF;',
'',
'    END LOOP;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(52464752525584444)
,p_process_success_message=>'Permit types updated.'
,p_internal_uid=>52464836682584445
);
wwv_flow_imp.component_end;
end;
/
