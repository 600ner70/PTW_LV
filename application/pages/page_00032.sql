prompt --application/pages/page_00032
begin
--   Manifest
--     PAGE: 00032
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
 p_id=>32
,p_name=>'Edit Site'
,p_alias=>'EDIT-SITE'
,p_page_mode=>'MODAL'
,p_step_title=>'Edit Site'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(function () {',
'    var BINARY_ITEMS = [''P32_IS_ACTIVE''];',
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
,p_step_template=>2100407606326202693
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'16'
,p_created_on=>wwv_flow_imp.dz('20260721212150Z')
,p_last_updated_on=>wwv_flow_imp.dz('20260725115352Z')
,p_created_by=>'PTW_PRO'
,p_last_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(62155428895965293)
,p_plug_name=>'Buttons'
,p_static_id=>'buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>50
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260721212150Z')
,p_updated_on=>wwv_flow_imp.dz('20260721212150Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(62154637918965286)
,p_plug_name=>'Edit Site'
,p_static_id=>'edit-team'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>40
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260721212150Z')
,p_updated_on=>wwv_flow_imp.dz('20260721212150Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9000752635499178)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(62155428895965293)
,p_button_name=>'CANCEL'
,p_static_id=>'cancel'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:31:&SESSION.::&DEBUG.:31::'
,p_created_on=>wwv_flow_imp.dz('20260721212150Z')
,p_updated_on=>wwv_flow_imp.dz('20260721213746Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9001159878499179)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(62155428895965293)
,p_button_name=>'SAVE'
,p_static_id=>'save'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'CREATE'
,p_icon_css_classes=>'fa-save'
,p_created_on=>wwv_flow_imp.dz('20260721212150Z')
,p_updated_on=>wwv_flow_imp.dz('20260721212150Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(9008246474499211)
,p_branch_name=>'Return to page 31'
,p_branch_action=>'f?p=&APP_ID.:31:&SESSION.::&DEBUG.:31:P31_SITE_ID:&P32_SITE_ID.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_created_on=>wwv_flow_imp.dz('20260721212150Z')
,p_updated_on=>wwv_flow_imp.dz('20260721213042Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(62195437138652324)
,p_name=>'P32_COMPANY_ID'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260721212150Z')
,p_updated_on=>wwv_flow_imp.dz('20260721212150Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(62157182674965303)
,p_name=>'P32_CREATED_DATE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(62154637918965286)
,p_prompt=>'Created Date'
,p_format_mask=>'DD-MON-YYYY HH24:MI:SS'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_colspan=>6
,p_display_when=>'P32_SITE_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260721212150Z')
,p_updated_on=>wwv_flow_imp.dz('20260725115215Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(62157134763965302)
,p_name=>'P32_IS_ACTIVE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(62154637918965286)
,p_prompt=>'Is Active'
,p_source_type=>'ALWAYS_NULL'
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
,p_created_on=>wwv_flow_imp.dz('20260721212150Z')
,p_updated_on=>wwv_flow_imp.dz('20260721212150Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(62157311404965304)
,p_name=>'P32_PERMIT_COUNT'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(62154637918965286)
,p_prompt=>'Permit Count'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_display_when=>'P32_SITE_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'Number of permits currently assigned'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260721212150Z')
,p_updated_on=>wwv_flow_imp.dz('20260725115216Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(62156881461965300)
,p_name=>'P32_SITE_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(62154637918965286)
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260721212150Z')
,p_updated_on=>wwv_flow_imp.dz('20260721213042Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(62157002254965301)
,p_name=>'P32_SITE_NAME'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(62154637918965286)
,p_prompt=>'Site Name'
,p_source_type=>'ALWAYS_NULL'
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
,p_created_on=>wwv_flow_imp.dz('20260721212150Z')
,p_updated_on=>wwv_flow_imp.dz('20260721213042Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(9006590531499205)
,p_validation_name=>'Company required for Super User'
,p_static_id=>'company-required-for-super-user'
,p_validation_sequence=>30
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    IF :P32_COMPANY_ID IS NULL THEN',
'        RETURN ''Unable to determine which company this site belongs to. ''',
'            || ''If you are a Super User, please select an Active Company ''',
'            || ''(Admin > Set Active Company) before creating a site.'';',
'    END IF;',
'    RETURN NULL;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_ERR_TEXT'
,p_when_button_pressed=>wwv_flow_imp.id(9001159878499179)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260721212150Z')
,p_updated_on=>wwv_flow_imp.dz('20260721213634Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(9006183278499204)
,p_validation_name=>'Site name must be unique'
,p_static_id=>'team-name-must-be-unique'
,p_validation_sequence=>20
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_count NUMBER;',
'BEGIN',
'    SELECT COUNT(*) INTO v_count',
'    FROM   ptw_pro.ptw_lv_sites',
'    WHERE  UPPER(site_name) = UPPER(:P32_SITE_NAME)',
'    AND    company_id = :P32_COMPANY_ID',
'    AND    (site_id != :P32_SITE_ID OR :P32_SITE_ID IS NULL);',
'',
'    IF v_count > 0 THEN',
'        RETURN ''This Site is already in use for this company. Please choose a different name.'';',
'    END IF;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_ERR_TEXT'
,p_when_button_pressed=>wwv_flow_imp.id(9001159878499179)
,p_associated_item=>wwv_flow_imp.id(62157002254965301)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260721212150Z')
,p_updated_on=>wwv_flow_imp.dz('20260721213042Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(9005771327499202)
,p_validation_name=>'Site name required'
,p_static_id=>'team-name-required'
,p_validation_sequence=>10
,p_validation=>'P32_SITE_NAME'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Site name is mandatory.',
''))
,p_when_button_pressed=>wwv_flow_imp.id(9001159878499179)
,p_associated_item=>wwv_flow_imp.id(62157002254965301)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260721212150Z')
,p_updated_on=>wwv_flow_imp.dz('20260721213042Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(9007354511499208)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load data'
,p_static_id=>'load-data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT s.site_name,',
'       s.is_Active,',
'       s.company_id,',
'       TO_CHAR(s.created_date,''DD-MON-YYYY HH24:MI'') as created_date,',
'      (SELECT COUNT(*) FROM ptw_pro.ptw_lv_permits p',
'       WHERE p.site_id = s.site_id) ',
'INTO   :P32_SITE_NAME,',
'       :P32_IS_ACTIVE,',
'       :P32_COMPANY_ID,',
'       :P32_CREATED_DATE,',
'       :P32_PERMIT_COUNT',
'FROM   ptw_pro.ptw_lv_sites s',
'WHERE  s.site_id = :P32_SITE_ID;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P32_SITE_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>9007354511499208
,p_created_on=>wwv_flow_imp.dz('20260721212150Z')
,p_updated_on=>wwv_flow_imp.dz('20260725115352Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(9006973169499206)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save Site'
,p_static_id=>'save-team'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    IF :P32_SITE_ID IS NULL THEN',
'',
'        -- CREATE: company_id comes from P32_COMPANY_ID, resolved earlier by',
'        -- "Determine Effective Company" and guaranteed NOT NULL by the',
'        -- "Company Required for Super User" validation before we ever get here.',
'        INSERT INTO ptw_pro.ptw_lv_sites (company_id, site_name, is_active)',
'        VALUES (:P32_COMPANY_ID, :P32_SITE_NAME, :P32_IS_ACTIVE)',
'        RETURNING site_id INTO :P32_SITE_ID;',
'',
'    ELSE',
'',
'        -- UPDATE: company_id is intentionally NOT in the SET list.',
'        -- A team''s company is fixed at creation; this form has no control',
'        -- to reassign it, and the VPD policy''s update_check would reject',
'        -- a cross-company UPDATE attempt anyway.',
'        UPDATE ptw_pro.ptw_lv_sites',
'        SET    site_name     = :P32_SITE_NAME,',
'               is_active     = :P32_IS_ACTIVE,',
'               modified_date = SYSTIMESTAMP,',
'               modified_by   = :APP_USER',
'        WHERE  site_id       = :P32_SITE_ID;',
'',
'    END IF;',
'',
'EXCEPTION',
'    WHEN DUP_VAL_ON_INDEX THEN',
'        -- Belt-and-braces: UQ_PTW_LV_TEAMS (company_id, team_name) catches',
'        -- any race condition the app-level uniqueness validation missed',
'        -- (e.g. two concurrent saves). Same friendly message either way.',
'        apex_error.add_error(',
'            p_message          => ''This site is already in use for this company. Please choose a different name.'',',
'            p_display_location => apex_error.c_inline_in_notification);',
'',
'    WHEN OTHERS THEN',
'        apex_error.add_error(',
'            p_message          => ''Unable to save site: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification);',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(9001159878499179)
,p_internal_uid=>9006973169499206
,p_created_on=>wwv_flow_imp.dz('20260721212150Z')
,p_updated_on=>wwv_flow_imp.dz('20260721213341Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(9007763861499209)
,p_process_sequence=>20
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Super User check'
,p_static_id=>'super-user-check'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    SELECT CASE',
'               WHEN is_super_user = ''Y'' AND (V(''G_OVERRIDE_COMPANY_ID'') IS NULL OR V(''G_OVERRIDE_COMPANY_ID'') = '''')',
'                   THEN NULL',
'               WHEN is_super_user = ''Y''',
'                   THEN TO_NUMBER(V(''G_OVERRIDE_COMPANY_ID''))',
'               ELSE company_id',
'           END',
'    INTO :P32_COMPANY_ID',
'    FROM ptw_pro.ptw_lv_users',
'    WHERE UPPER(username) = UPPER(:APP_USER) AND is_active = ''Y'';',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN :P32_COMPANY_ID := NULL;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P32_SITE_ID'
,p_process_when_type=>'ITEM_IS_NULL'
,p_internal_uid=>9007763861499209
,p_created_on=>wwv_flow_imp.dz('20260721212150Z')
,p_updated_on=>wwv_flow_imp.dz('20260721213042Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
