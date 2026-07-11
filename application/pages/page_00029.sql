prompt --application/pages/page_00029
begin
--   Manifest
--     PAGE: 00029
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
 p_id=>29
,p_name=>'Edit Team'
,p_alias=>'EDIT-TEAM'
,p_page_mode=>'MODAL'
,p_step_title=>'Edit Team'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(function () {',
'    var BINARY_ITEMS = [''P29_IS_ACTIVE''];',
'',
'    var BADGES = [',
unistr('        { val: ''Y'', cls: ''binary-badge-yes'', label: ''\2713'' },'),
unistr('        { val: ''N'', cls: ''binary-badge-no'',  label: ''\2717'' }'),
'    ];',
'',
'    BINARY_ITEMS.forEach(function (itemName) {',
'        var $fc = $(''#'' + itemName).closest(''.t-Form-fieldContainer'');',
'        if ($fc.length === 0) return;',
'',
'        $fc.find(''.binary-badge-row'').remove();',
'',
'        var currentVal = $(''input[name="'' + itemName + ''"]:checked'').val() || '''';',
'',
'        var $row = $(''<div class="binary-badge-row"></div>'').attr(''data-item'', itemName);',
'',
'        BADGES.forEach(function (b) {',
'            $(''<span></span>'')',
'                .addClass(''binary-badge '' + b.cls)',
'                .toggleClass(''cm-active'', currentVal === b.val)',
'                .attr(''data-value'', b.val)',
'                .text(b.label)',
'                .appendTo($row);',
'        });',
'',
'        $fc.find(''.t-Form-inputContainer'').append($row);',
'    });',
'',
'    $(''.cm-binary-item .apex-item-grid'').hide();',
'',
'    $(document).off(''click.binarybadge24'').on(''click.binarybadge24'', ''.binary-badge:not(.binary-readonly)'', function () {',
'        var $badge   = $(this);',
'        var $row     = $badge.closest(''.binary-badge-row'');',
'        var itemName = $row.attr(''data-item'');',
'        var val      = $badge.attr(''data-value'');',
'',
'        $(''input[name="'' + itemName + ''"][value="'' + val + ''"]'')',
'            .prop(''checked'', true).trigger(''change'');',
'',
'        $row.find(''.binary-badge'').removeClass(''cm-active'');',
'        $badge.addClass(''cm-active'');',
'    });',
'}());'))
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'03'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(53154704361466116)
,p_plug_name=>'Edit Team'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>40
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(53155863399466127)
,p_name=>'Team Permit Types'
,p_title=>'Team Permit Types'
,p_parent_plug_id=>wwv_flow_imp.id(53154704361466116)
,p_template=>4072358936313175081
,p_display_sequence=>10
,p_icon_css_classes=>'fa-clipboard-list'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'SUB_REGIONS'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ct.type_id,',
'       pt.type_desc,',
'       NVL(tt.is_active, ''INHERIT'') AS current_setting',
'FROM   ptw_pro.ptw_lv_company_types ct',
'JOIN   ptw_pro.ptw_types pt ON pt.type_id = ct.type_id',
'LEFT JOIN ptw_pro.ptw_lv_team_types tt',
'       ON tt.team_id = :P29_TEAM_ID AND tt.type_id = ct.type_id',
'WHERE  ct.is_active = ''Y''',
'ORDER  BY pt.type_desc',
''))
,p_display_when_condition=>'P29_TEAM_ID'
,p_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P29_TEAM_ID'
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
 p_id=>wwv_flow_imp.id(53155985179466128)
,p_query_column_id=>1
,p_column_alias=>'TYPE_ID'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(53156099608466129)
,p_query_column_id=>2
,p_column_alias=>'TYPE_DESC'
,p_column_display_sequence=>20
,p_column_heading=>'Type Desc'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(53156116063466130)
,p_query_column_id=>3
,p_column_alias=>'CURRENT_SETTING'
,p_column_display_sequence=>30
,p_column_heading=>'Current Setting'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(53155495338466123)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>50
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(53155537068466124)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(53155495338466123)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:27:&SESSION.::&DEBUG.:27::'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(53155632757466125)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(53155495338466123)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'CREATE'
,p_icon_css_classes=>'fa-save'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(53156502329466134)
,p_branch_name=>'Return to page 27'
,p_branch_action=>'f?p=&APP_ID.:27:&SESSION.::&DEBUG.:27:P27_TEAM_ID:&P29_TEAM_ID.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53154838250466117)
,p_name=>'P29_TEAM_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(53154704361466116)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53154959043466118)
,p_name=>'P29_TEAM_NAME'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(53154704361466116)
,p_prompt=>'Team Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53155091552466119)
,p_name=>'P29_IS_ACTIVE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(53154704361466116)
,p_prompt=>'Is Active'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Active;Y,Inactive;N'
,p_colspan=>3
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-binary-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53155139463466120)
,p_name=>'P29_CREATED_DATE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(53154704361466116)
,p_prompt=>'Created Date'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53155268193466121)
,p_name=>'P29_ENGINEER_COUNT'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(53154704361466116)
,p_prompt=>'Engineer Count'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'Number of engineers currently assigned'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53190083971153124)
,p_name=>'P29_COMPANY_ID'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(53156352428466132)
,p_validation_name=>'Team name required'
,p_validation_sequence=>10
,p_validation=>'P29_TEAM_NAME'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Team name is mandatory.',
''))
,p_when_button_pressed=>wwv_flow_imp.id(53155632757466125)
,p_associated_item=>wwv_flow_imp.id(53154959043466118)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(53156409402466133)
,p_validation_name=>'Team name must be unique'
,p_validation_sequence=>20
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_count NUMBER;',
'BEGIN',
'    SELECT COUNT(*) INTO v_count',
'    FROM   ptw_pro.ptw_lv_teams',
'    WHERE  UPPER(team_name) = UPPER(:P29_TEAM_NAME)',
'    AND    company_id = :P29_COMPANY_ID',
'    AND    (team_id != :P29_TEAM_ID OR :P29_TEAM_ID IS NULL);',
'',
'    IF v_count > 0 THEN',
'        RETURN ''This Team Name is already in use for this company. Please choose a different name.'';',
'    END IF;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_ERR_TEXT'
,p_when_button_pressed=>wwv_flow_imp.id(53155632757466125)
,p_associated_item=>wwv_flow_imp.id(53154959043466118)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(53190184013153125)
,p_validation_name=>'Company required for Super User'
,p_validation_sequence=>30
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    IF :P29_COMPANY_ID IS NULL THEN',
'        RETURN ''Unable to determine which company this team belongs to. ''',
'            || ''If you are a Super User, please select an Active Company ''',
'            || ''(Admin > Set Active Company) before creating a team.'';',
'    END IF;',
'    RETURN NULL;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_ERR_TEXT'
,p_when_button_pressed=>wwv_flow_imp.id(53155632757466125)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(53189108372153115)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT team_name,',
'       is_Active,',
'       company_id,',
'       created_date',
'INTO   :P29_TEAM_NAME,',
'       :P29_IS_ACTIVE,',
'       :P29_COMPANY_ID,',
'       :P29_CREATED_DATE',
'FROM   ptw_pro.ptw_lv_teams',
'WHERE  team_id = :P29_TEAM_ID;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P29_TEAM_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>53189108372153115
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(53189921635153123)
,p_process_sequence=>20
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Super User check'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    SELECT CASE',
'               WHEN is_super_user = ''Y'' AND (V(''G_OVERRIDE_COMPANY_ID'') IS NULL OR V(''G_OVERRIDE_COMPANY_ID'') = '''')',
'                   THEN NULL',
'               WHEN is_super_user = ''Y''',
'                   THEN TO_NUMBER(V(''G_OVERRIDE_COMPANY_ID''))',
'               ELSE company_id',
'           END',
'    INTO :P29_COMPANY_ID',
'    FROM ptw_pro.ptw_lv_users',
'    WHERE UPPER(username) = UPPER(:APP_USER) AND is_active = ''Y'';',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN :P29_COMPANY_ID := NULL;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P29_TEAM_ID'
,p_process_when_type=>'ITEM_IS_NULL'
,p_internal_uid=>53189921635153123
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(53156211220466131)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save Team'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    IF :P29_TEAM_ID IS NULL THEN',
'',
'        -- CREATE: company_id comes from P29_COMPANY_ID, resolved earlier by',
'        -- "Determine Effective Company" and guaranteed NOT NULL by the',
'        -- "Company Required for Super User" validation before we ever get here.',
'        INSERT INTO ptw_pro.ptw_lv_teams (company_id, team_name, is_active)',
'        VALUES (:P29_COMPANY_ID, :P29_TEAM_NAME, :P29_IS_ACTIVE)',
'        RETURNING team_id INTO :P29_TEAM_ID;',
'',
'    ELSE',
'',
'        -- UPDATE: company_id is intentionally NOT in the SET list.',
'        -- A team''s company is fixed at creation; this form has no control',
'        -- to reassign it, and the VPD policy''s update_check would reject',
'        -- a cross-company UPDATE attempt anyway.',
'        UPDATE ptw_pro.ptw_lv_teams',
'        SET    team_name     = :P29_TEAM_NAME,',
'               is_active     = :P29_IS_ACTIVE,',
'               modified_date = SYSTIMESTAMP,',
'               modified_by   = :APP_USER',
'        WHERE  team_id = :P29_TEAM_ID;',
'',
'    END IF;',
'',
'EXCEPTION',
'    WHEN DUP_VAL_ON_INDEX THEN',
'        -- Belt-and-braces: UQ_PTW_LV_TEAMS (company_id, team_name) catches',
'        -- any race condition the app-level uniqueness validation missed',
'        -- (e.g. two concurrent saves). Same friendly message either way.',
'        apex_error.add_error(',
'            p_message          => ''This Team Name is already in use for this company. Please choose a different name.'',',
'            p_display_location => apex_error.c_inline_in_notification);',
'',
'    WHEN OTHERS THEN',
'        apex_error.add_error(',
'            p_message          => ''Unable to save team: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification);',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(53155632757466125)
,p_internal_uid=>53156211220466131
);
wwv_flow_imp.component_end;
end;
/
