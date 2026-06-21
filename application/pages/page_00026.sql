prompt --application/pages/page_00026
begin
--   Manifest
--     PAGE: 00026
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
 p_id=>26
,p_name=>'Add Permit Types to Company'
,p_alias=>'ADD-PERMIT-TYPES-TO-COMPANY'
,p_page_mode=>'MODAL'
,p_step_title=>'Add Permit Types to Company'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(26419849891144614)
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'03'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(52462951010584426)
,p_name=>'Available Permit Types'
,p_title=>'Available Permit Types'
,p_template=>4501440665235496320
,p_display_sequence=>30
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT apex_item.checkbox(1, t.type_id) AS select_type,',
'       t.ptw_type,',
'       t.type_desc',
'FROM   ptw_pro.ptw_types t',
'WHERE  t.available = ''Y''',
'AND    t.type_id NOT IN (',
'         SELECT ct.type_id FROM ptw_pro.ptw_lv_company_types ct',
'       )',
'ORDER  BY t.ptw_type'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2538654340625403440
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'Your company already has access to all available permit types.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(52463010163584427)
,p_query_column_id=>1
,p_column_alias=>'SELECT_TYPE'
,p_column_display_sequence=>10
,p_heading_alignment=>'LEFT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(52463169230584428)
,p_query_column_id=>2
,p_column_alias=>'PTW_TYPE'
,p_column_display_sequence=>20
,p_column_heading=>'Type Code'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(52463270765584429)
,p_query_column_id=>3
,p_column_alias=>'TYPE_DESC'
,p_column_display_sequence=>30
,p_column_heading=>'Description'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(52463483258584431)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>40
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(52463685601584433)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(52463483258584431)
,p_button_name=>'CANCEL'
,p_button_static_id=>'BTN_CANCEL_P26'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:23::'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(52463555906584432)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(52463483258584431)
,p_button_name=>'SAVE'
,p_button_static_id=>'BTN_SAVE_P26'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'CREATE'
,p_icon_css_classes=>'fa-save'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(52463885424584435)
,p_branch_name=>'Back to page 23'
,p_branch_action=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:23::'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(52463784902584434)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Add Selected Permit Types'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_company_id NUMBER;',
'BEGIN',
'    SELECT company_id',
'    INTO   v_company_id',
'    FROM   ptw_pro.ptw_lv_users',
'    WHERE  UPPER(username) = UPPER(SYS_CONTEXT(''APEX$SESSION'', ''APP_USER''));',
' ',
'    FOR i IN 1 .. apex_application.g_f01.count LOOP',
'        INSERT INTO ptw_pro.ptw_lv_company_types (company_id, type_id, is_active)',
'        VALUES (v_company_id, apex_application.g_f01(i), ''Y'');',
'    END LOOP;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(52463555906584432)
,p_internal_uid=>52463784902584434
);
wwv_flow_imp.component_end;
end;
/
