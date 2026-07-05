prompt --application/pages/page_00024
begin
--   Manifest
--     PAGE: 00024
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
 p_id=>24
,p_name=>'Edit Company'
,p_alias=>'EDIT-COMPANY'
,p_page_mode=>'MODAL'
,p_step_title=>'Add/Edit Company'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(function () {',
'    var BINARY_ITEMS = [''P24_IS_ACTIVE''];',
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
,p_required_role=>wwv_flow_imp.id(52412848522131878)
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(52415430252182118)
,p_plug_name=>'Company Details'
,p_title=>'Company Details'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>40
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(52416089146182124)
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
 p_id=>wwv_flow_imp.id(52416260898182126)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(52416089146182124)
,p_button_name=>'CANCEL'
,p_button_static_id=>'BTN_CANCEL_P24'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.:21::'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(52416184904182125)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(52416089146182124)
,p_button_name=>'SAVE'
,p_button_static_id=>'BTN_SAVE_P24'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'CREATE'
,p_icon_css_classes=>'fa-save'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(52416510073182129)
,p_branch_name=>'Return to Page 21'
,p_branch_action=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.:21::'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(52415360719182117)
,p_name=>'P24_COMPANY_ID'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(52415521718182119)
,p_name=>'P24_COMPANY_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(52415430252182118)
,p_prompt=>'Company Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_colspan=>3
,p_read_only_when=>'P24_COMPANY_ID'
,p_read_only_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(52415614297182120)
,p_name=>'P24_COMPANY_CODE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(52415430252182118)
,p_prompt=>'Company Code'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_tag_attributes=>'style="text-transform:uppercase"'
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_read_only_when=>'P24_COMPANY_ID'
,p_read_only_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(52415733172182121)
,p_name=>'P24_IS_ACTIVE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(52415430252182118)
,p_item_default=>'Y'
,p_prompt=>'Active?'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Yes;Y,No;N'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-binary-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(52415835734182122)
,p_name=>'P24_CREATED_DATE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(52415430252182118)
,p_prompt=>'Date Created'
,p_format_mask=>'DD-MON-YYYY HH24:MI'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P24_COMPANY_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(52415992923182123)
,p_name=>'P24_USER_COUNT'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(52415430252182118)
,p_prompt=>'Users in this Company'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COUNT(*) ',
'FROM   ptw_pro.ptw_lv_users',
'WHERE  company_id = :P24_COMPANY_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_display_when=>'P24_COMPANY_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'Informational only - helps super user judge whether a company can safely be deleted'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(52495863962962717)
,p_name=>'P24_PERMIT_PREFIX'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(52415430252182118)
,p_prompt=>'Permit Number Prefix'
,p_placeholder=>'e.g. MWM'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>4
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_display_when=>'P24_COMPANY_ID'
,p_display_when_type=>'ITEM_IS_NULL'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(52495959704962718)
,p_name=>'P24_PERMIT_PREFIX_DISPLAY'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(52415430252182118)
,p_prompt=>'Permit Prefix Display'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_tag_attributes=>'style="text-transform:uppercase"'
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_display_when=>'P24_COMPANY_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(52496313590962722)
,p_name=>'P24_HEADER_TEXT'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(52415430252182118)
,p_prompt=>'Header Text'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(52416641408182130)
,p_validation_name=>'Company Name Required'
,p_validation_sequence=>10
,p_validation=>'P24_COMPANY_NAME'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Company Name is required.'
,p_when_button_pressed=>wwv_flow_imp.id(52416184904182125)
,p_associated_item=>wwv_flow_imp.id(52415521718182119)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(52416710609182131)
,p_validation_name=>'Company Code Must Be Unique'
,p_validation_sequence=>20
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_count NUMBER;',
'BEGIN',
'    -- company_code has a UNIQUE constraint but is nullable;',
'    -- NULLs don''t violate uniqueness, so only check when a',
'    -- value is actually entered.',
'    IF :P24_COMPANY_CODE IS NULL THEN',
'        RETURN TRUE;',
'    END IF;',
'',
'    SELECT COUNT(*) INTO v_count',
'    FROM   ptw_pro.ptw_lv_companies',
'    WHERE  UPPER(company_code) = UPPER(:P24_COMPANY_CODE)',
'    AND    (company_id != :P24_COMPANY_ID OR :P24_COMPANY_ID IS NULL);',
'    RETURN v_count = 0;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'This Company Code is already in use by another company. Please choose a different code, or leave it blank.'
,p_when_button_pressed=>wwv_flow_imp.id(52416184904182125)
,p_associated_item=>wwv_flow_imp.id(52415614297182120)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(52496007143962719)
,p_validation_name=>'Prefix Required and Valid'
,p_validation_sequence=>30
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_prefix VARCHAR2(4) := TRIM(:P24_PERMIT_PREFIX);',
'BEGIN',
'    -- Only validate in create mode (item is hidden on edit)',
'    IF :P24_COMPANY_ID IS NOT NULL THEN',
'        RETURN TRUE;',
'    END IF;',
'',
'    RETURN v_prefix IS NOT NULL',
'       AND LENGTH(v_prefix) BETWEEN 1 AND 4',
'       AND UPPER(v_prefix) = v_prefix;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'Permit Number Prefix is required and must be 1-4 uppercase letters (e.g. MWM).'
,p_associated_item=>wwv_flow_imp.id(52495863962962717)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(52496175209962720)
,p_validation_name=>'Prefix Must Be Unique'
,p_validation_sequence=>40
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_count NUMBER;',
'BEGIN',
'    -- Only validate in create mode',
'    IF :P24_COMPANY_ID IS NOT NULL THEN',
'        RETURN TRUE;',
'    END IF;',
'',
'    SELECT COUNT(*) INTO v_count',
'    FROM   ptw_pro.ptw_lv_companies',
'    WHERE  UPPER(permit_prefix) = UPPER(TRIM(:P24_PERMIT_PREFIX));',
'',
'    RETURN v_count = 0;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'This prefix is already used by another company. Please choose a different one.'
,p_associated_item=>wwv_flow_imp.id(52495863962962717)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(52416461002182128)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save Company'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'IF :P24_COMPANY_ID IS NOT NULL THEN',
'',
'    DECLARE',
'        l_db_comp_is_active VARCHAR2(1);',
'    BEGIN',
'        --',
'        SELECT is_active',
'        INTO   l_db_comp_is_active',
'        FROM   ptw_pro.ptw_lv_companies',
'        WHERE  company_id = :P24_COMPANY_ID;',
'        --',
'        IF l_db_comp_is_active != :P24_IS_ACTIVE THEN',
'            --',
'            UPDATE ptw_pro.ptw_lv_companies',
'            SET    is_active = :P24_IS_ACTIVE',
'            WHERE  company_id = :P24_COMPANY_ID;',
'        END IF;',
'    END;',
'',
'ELSE',
'',
'    INSERT INTO ptw_pro.ptw_lv_companies',
'        (company_name, company_code, is_active, permit_prefix, header_text)',
'    VALUES (',
'        :P24_COMPANY_NAME,',
'        :P24_COMPANY_CODE,',
'        :P24_IS_ACTIVE,',
'        :P24_PERMIT_PREFIX,',
'        :P24_HEADER_TEXT',
'    );',
'',
'END IF;',
'',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>52416461002182128
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(52416338328182127)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Fetch Company'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    --',
'    SELECT c.company_name,',
'           c.company_code,',
'           c.permit_prefix,',
'           c.is_active,',
'           c.header_text,',
'           TO_CHAR(c.created_date, ''DD-MON-YYYY'') AS created_date,',
'           (SELECT COUNT(*) FROM ptw_pro.ptw_lv_users u',
'             WHERE u.company_id = c.company_id)   AS user_count',
'    INTO   :P24_COMPANY_NAME,',
'           :P24_COMPANY_CODE,',
'           :P24_PERMIT_PREFIX_DISPLAY,',
'           :P24_IS_ACTIVE,',
'           :P24_HEADER_TEXT,',
'           :P24_CREATED_DATE,',
'           :P24_USER_COUNT',
'    FROM   ptw_pro.ptw_lv_companies c',
'    WHERE  company_id = :P24_COMPANY_ID',
'    ORDER  BY c.company_name;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P24_COMPANY_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>52416338328182127
);
wwv_flow_imp.component_end;
end;
/
