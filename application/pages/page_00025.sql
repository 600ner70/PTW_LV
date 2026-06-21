prompt --application/pages/page_00025
begin
--   Manifest
--     PAGE: 00025
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
 p_id=>25
,p_name=>'Add Permit Type'
,p_alias=>'ADD-PERMIT-TYPE'
,p_page_mode=>'MODAL'
,p_step_title=>'Add Permit Type'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(function () {',
'    var BINARY_ITEMS = [''P25_AVAILABLE''];',
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
'    $(document).off(''click.binarybadge25'').on(''click.binarybadge25'', ''.binary-badge:not(.binary-readonly)'', function () {',
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
'}());',
''))
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(52418604179182150)
,p_plug_name=>'Permit Type Details'
,p_title=>'Permit Type Details'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>40
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(52460929249584406)
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
 p_id=>wwv_flow_imp.id(52461172915584408)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(52460929249584406)
,p_button_name=>'CANCEL'
,p_button_static_id=>'BTN_CANCEL_P25'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_redirect_url=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.:22::'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(52461089934584407)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(52460929249584406)
,p_button_name=>'SAVE'
,p_button_static_id=>'BTN_SAVE_P25'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'CREATE'
,p_icon_css_classes=>'fa-save'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(52461439650584411)
,p_branch_name=>'Back to page 22'
,p_branch_action=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.:22::'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(52418513607182149)
,p_name=>'P25_TYPE_ID'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(52460479828584401)
,p_name=>'P25_PTW_TYPE'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(52418604179182150)
,p_prompt=>'Type code'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_tag_attributes=>'style="text-transform:uppercase"'
,p_colspan=>6
,p_read_only_when=>'P25_TYPE_ID'
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
 p_id=>wwv_flow_imp.id(52460581646584402)
,p_name=>'P25_TYPE_DESC'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(52418604179182150)
,p_prompt=>'Description'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_read_only_when=>'P25_TYPE_ID'
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
 p_id=>wwv_flow_imp.id(52460659488584403)
,p_name=>'P25_AVAILABLE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(52418604179182150)
,p_item_default=>'Y'
,p_prompt=>'Available?'
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
 p_id=>wwv_flow_imp.id(52460754604584404)
,p_name=>'P25_CREATED_DATE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(52418604179182150)
,p_prompt=>'Date Created'
,p_format_mask=>'DD-MON-YYYY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_colspan=>6
,p_display_when=>'P25_TYPE_ID'
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
 p_id=>wwv_flow_imp.id(52460893928584405)
,p_name=>'P25_COMPANY_COUNT'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(52418604179182150)
,p_prompt=>'Companies Using This Type'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COUNT(*) FROM ptw_pro.ptw_lv_company_types',
'WHERE type_id = :P25_TYPE_ID AND is_active = ''Y'''))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_display_when=>'P25_TYPE_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(52461589023584412)
,p_validation_name=>'Type Code Required'
,p_validation_sequence=>10
,p_validation=>'P25_PTW_TYPE'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Type Code is required.'
,p_when_button_pressed=>wwv_flow_imp.id(52461089934584407)
,p_associated_item=>wwv_flow_imp.id(52460479828584401)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(52461649892584413)
,p_validation_name=>'Description Required'
,p_validation_sequence=>20
,p_validation=>'P25_TYPE_DESC'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Description is required.'
,p_when_button_pressed=>wwv_flow_imp.id(52461089934584407)
,p_associated_item=>wwv_flow_imp.id(52460581646584402)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(52461709490584414)
,p_validation_name=>'Type Code Must Be Unique'
,p_validation_sequence=>30
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_count NUMBER;',
'BEGIN',
'    SELECT COUNT(*) INTO v_count',
'    FROM   ptw_pro.ptw_types',
'    WHERE  UPPER(ptw_type) = UPPER(:P25_PTW_TYPE)',
'    AND    (type_id != :P25_TYPE_ID OR :P25_TYPE_ID IS NULL);',
'    RETURN v_count = 0;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'This Type Code already exists. Please choose a different code.'
,p_when_button_pressed=>wwv_flow_imp.id(52461089934584407)
,p_associated_item=>wwv_flow_imp.id(52460479828584401)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(52461356308584410)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save Permit Type'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'IF :P25_TYPE_ID IS NOT NULL THEN',
'',
'    -- Existing type: ptw_type and type_desc are locked - only',
'    -- available can change.',
'    UPDATE ptw_pro.ptw_types',
'    SET    available = :P25_AVAILABLE',
'    WHERE  type_id = :P25_TYPE_ID;',
'',
'ELSE',
'',
'    -- New type',
'    INSERT INTO ptw_pro.ptw_types (ptw_type, type_desc, available)',
'    VALUES     (:P25_PTW_TYPE, :P25_TYPE_DESC, :P25_AVAILABLE);',
'',
'END IF;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>52461356308584410
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(52461243254584409)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Fetch Permit Type'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    SELECT t.ptw_type,',
'           t.type_desc,',
'           t.available,',
'           TO_CHAR(t.created_date, ''DD-MON-YYYY'') AS created_date,',
'           (SELECT COUNT(*) FROM ptw_pro.ptw_lv_company_types ct',
'             WHERE ct.type_id = t.type_id AND ct.is_active = ''Y'') AS company_count',
'    INTO   :P25_PTW_TYPE,',
'           :P25_TYPE_DESC,',
'           :P25_AVAILABLE,',
'           :P25_CREATED_DATE,',
'           :P25_COMPANY_COUNT',
'    FROM   ptw_pro.ptw_types t',
'    WHERE  type_id = :P25_TYPE_ID;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P25_TYPE_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>52461243254584409
);
wwv_flow_imp.component_end;
end;
/
