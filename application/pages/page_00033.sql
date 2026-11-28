prompt --application/pages/page_00033
begin
--   Manifest
--     PAGE: 00033
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
 p_id=>33
,p_name=>'DRA Sign-off'
,p_alias=>'DRA-SIGN-OFF'
,p_step_title=>'DRA Sign-off'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var draSignaturePad;',
'function ptwToggleNoReason() {',
'    var isNo = apex.item(''P33_CAN_PROCEED'').getValue() === ''NO'';',
'    if (isNo) { apex.item(''P33_NO_REASON'').show(); } else { apex.item(''P33_NO_REASON'').hide(); }',
'}'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.declaration-box {',
'    background: var(--ut-palette-warning-light, #fff8e1);',
'    border-left: 4px solid var(--ut-palette-warning, #f0ad4e);',
'    padding: 1rem 1.25rem;',
'    border-radius: 0 6px 6px 0;',
'    margin-bottom: 1rem;',
'    font-size: 0.9rem;',
'    line-height: 1.5;',
'}',
'',
'.signature-pad-container {',
'    border: 2px solid var(--ut-component-border-color, #d0d0d0);',
'    border-radius: 8px;',
'    background: #ffffff;',
'    padding: 10px;',
'    margin: 10px 0;',
'}',
'',
'.signature-pad {',
'    width: 100%;',
'    height: 150px;',
'    border: 1px dashed #ccc;',
'    border-radius: 4px;',
'    touch-action: none;',
'    cursor: crosshair;',
'}',
'',
'.signature-controls {',
'    display: flex;',
'    gap: 10px;',
'    margin-top: 10px;',
'    justify-content: flex-end;',
'}',
'',
'.signature-controls button {',
'    padding: 6px 12px;',
'    border-radius: 4px;',
'    border: 1px solid #d0d0d0;',
'    background: #f5f5f5;',
'    cursor: pointer;',
'    font-size: 0.875rem;',
'}',
'',
'.signature-controls button:hover {',
'    background: #e0e0e0;',
'}',
''))
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_read_only_when=>'P33_WORKFLOW_STATUS'
,p_read_only_when2=>'DRAFT'
,p_page_component_map=>'25'
,p_created_on=>wwv_flow_imp.dz('20261010181926Z')
,p_last_updated_on=>wwv_flow_imp.dz('20261010191350Z')
,p_created_by=>'PTW_PRO'
,p_last_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(56989887703385714)
,p_plug_name=>'Assessment'
,p_static_id=>'assessment'
,p_parent_plug_id=>wwv_flow_imp.id(44032105751628842)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010191105Z')
,p_updated_on=>wwv_flow_imp.dz('20261010191105Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(44032523332628846)
,p_plug_name=>'Buttons'
,p_static_id=>'buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>110
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010185818Z')
,p_updated_on=>wwv_flow_imp.dz('20261010185819Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(145026564621627087)
,p_plug_name=>'DRA Number / Type Badge'
,p_static_id=>'dra-number-type-badge'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>80
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="margin-bottom: 20px;">',
'    <span class="apex-badge" style="background-color: #3ea055; color: white; padding: 6px 16px; border-radius: 20px; font-weight: 600;">',
'        DRA: &P33_DRA_NUMBER.',
'    </span>',
'</div>'))
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P33_DRA_NUMBER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010182255Z')
,p_updated_on=>wwv_flow_imp.dz('20261010183048Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(145026002689623202)
,p_plug_name=>'Page Header'
,p_static_id=>'page-header'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>70
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_html       CLOB;',
'    l_company_id NUMBER;',
'    l_logo_url   VARCHAR2(500);',
'    l_logo_count NUMBER;',
'    l_override   VARCHAR2(50) := V(''G_OVERRIDE_COMPANY_ID'');',
'BEGIN',
'    -- Derive effective company_id for the current user',
'    IF l_override IS NOT NULL AND TRIM(l_override) IS NOT NULL THEN',
'        BEGIN',
'            l_company_id := TO_NUMBER(TRIM(l_override));',
'        EXCEPTION',
'            WHEN OTHERS THEN l_company_id := NULL;',
'        END;',
'    ELSE',
'        -- Normal user: their own company',
'        -- Super user with no override: NULL (no logo shown)',
'        BEGIN',
'            SELECT company_id',
'            INTO   l_company_id',
'            FROM   ptw_pro.ptw_lv_users',
'            WHERE  UPPER(username) = UPPER(:APP_USER)',
'            AND    is_super_user   = ''N''',
'            AND    is_active       = ''Y'';',
'        EXCEPTION',
'            WHEN NO_DATA_FOUND THEN l_company_id := NULL;',
'        END;',
'    END IF;',
' ',
'    -- Check if a logo file exists for this company',
'    -- (graceful fallback - no broken image if file missing)',
' ',
'    IF l_company_id IS NOT NULL THEN',
'        SELECT COUNT(*) INTO l_logo_count',
'        FROM   apex_application_static_files',
'        WHERE  application_id = :APP_ID',
'        AND    file_name      = ''logo_'' || l_company_id || ''.png'';',
' ',
'        IF l_logo_count > 0 THEN',
'            l_logo_url := V(''APP_FILES'') || ''logo_'' || l_company_id || ''.png'';',
'        END IF;',
'    END IF;',
' ',
'    -- Build header',
'    l_html := ''<div style="margin-bottom:30px;display:flex;''',
'           || ''justify-content:space-between;align-items:center;''',
'           || ''min-height:80px;">''',
'           || ''  <div>''',
'           || ''    <h1 style="font-size:2rem;color:#13294b;''',
'           || ''               margin-bottom:5px;">''',
'           || ''      New Dynamic Risk Assessment''',
'           || ''    </h1>''',
'           || ''    <p style="color:#666;font-size:1rem;">''',
'           || ''      Step 3 of 3 - Can I Proceed Safely?''',
'           || ''    </p>''',
'           || ''  </div>'';',
' ',
'    IF l_logo_url IS NOT NULL THEN',
'        l_html := l_html',
'               || ''  <div style="width:200px;height:60px;display:flex;''',
'               || ''align-items:center;justify-content:flex-end;">''',
'               || ''    <img src="'' || l_logo_url || ''" ''',
'               || ''         alt="Company Logo" ''',
'               || ''         style="max-width:100%;max-height:100%;''',
'               || ''object-fit:contain;" />''',
'               || ''  </div>'';',
'    END IF;',
' ',
'    l_html := l_html || ''</div>'';',
' ',
'    RETURN l_html;',
' ',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        -- Never break Page 12 - fall back to plain header',
'        RETURN ''<div style="margin-bottom:30px;">''',
'            || ''<h1 style="font-size:2rem;color:#13294b;">''',
'            || ''Dynamic Risk Assessment</h1>''',
'            || ''<p style="color:#666;">Step 3 of 3 - Can I Proceed Safely? '';',
'            ',
'END;',
''))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_created_on=>wwv_flow_imp.dz('20261010182237Z')
,p_updated_on=>wwv_flow_imp.dz('20261010183048Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(44032105751628842)
,p_plug_name=>'Proceed Safely'
,p_static_id=>'proceed-safely'
,p_title=>'Stage 3 - Can the work proceed  safely?'
,p_icon_css_classes=>'fa-check-square-o'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent10:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>90
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="declaration-box">',
'  Having completed Stage 1 and identified the hazards and controls in',
'  Stage 2, I confirm my assessment below. If the answer is',
'  <strong>No</strong>, the work must not proceed and I will record why',
'  and inform my supervisor.',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010183048Z')
,p_updated_on=>wwv_flow_imp.dz('20261010183049Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(44032209189628843)
,p_plug_name=>'Signature'
,p_static_id=>'signature'
,p_title=>'Signature'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>100
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="signature-pad-container">',
'  <canvas id="draSignaturePad" class="signature-pad"></canvas>',
'  <div class="signature-controls">',
'   <button type="button" id="BTN_CLEAR_DRA_SIG"',
'            onclick="if (draSignaturePad) { draSignaturePad.clear(); apex.item(''P33_SIGNATURE_DATA'').setValue(''''); }">',
'     Clear</button>',
'  </div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010183048Z')
,p_updated_on=>wwv_flow_imp.dz('20261010183049Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(44032913455628850)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(44032523332628846)
,p_button_name=>'BACK'
,p_static_id=>'back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Back'
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.:13:P13_DRA_ID:&P33_DRA_ID.'
,p_warn_on_unsaved_changes=>null
,p_created_on=>wwv_flow_imp.dz('20261010185818Z')
,p_updated_on=>wwv_flow_imp.dz('20261010185818Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(56988517734385701)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(44032523332628846)
,p_button_name=>'COMPLETE_DRA'
,p_static_id=>'complete-dra_1'
,p_button_static_id=>'BTN_COMPLETE_DRA'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Complete & Sign'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P33_WORKFLOW_STATUS'
,p_button_condition2=>'DRAFT'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_icon_css_classes=>'fa-check'
,p_created_on=>wwv_flow_imp.dz('20261010185818Z')
,p_updated_on=>wwv_flow_imp.dz('20261010185818Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(56988637399385702)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(44032523332628846)
,p_button_name=>'DONE'
,p_static_id=>'done'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Back to DRAs'
,p_button_position=>'NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.:11::'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P33_WORKFLOW_STATUS'
,p_button_condition2=>'DRAFT'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_created_on=>wwv_flow_imp.dz('20261010185818Z')
,p_updated_on=>wwv_flow_imp.dz('20261010185818Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(56989645928385712)
,p_branch_name=>'Back to page 11'
,p_branch_action=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.:11::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(56988517734385701)
,p_branch_sequence=>10
,p_created_on=>wwv_flow_imp.dz('20261010185819Z')
,p_updated_on=>wwv_flow_imp.dz('20261010185819Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44032696582628847)
,p_name=>'P33_CAN_PROCEED'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(56989887703385714)
,p_prompt=>'Can the work proceed safely?'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Yes;Y,No;N'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'cm-binary-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2',
  'page_action_on_selection', 'NONE')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010185818Z')
,p_updated_on=>wwv_flow_imp.dz('20261010191105Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44032453686628845)
,p_name=>'P33_DRA_ID'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010183048Z')
,p_updated_on=>wwv_flow_imp.dz('20261010183048Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44032087535628841)
,p_name=>'P33_DRA_NUMBER'
,p_item_sequence=>50
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010183048Z')
,p_updated_on=>wwv_flow_imp.dz('20261010183048Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44032796921628848)
,p_name=>'P33_NO_REASON'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(56989887703385714)
,p_prompt=>'Why must the work not proceed?'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>1000
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010185818Z')
,p_updated_on=>wwv_flow_imp.dz('20261010191105Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44032355082628844)
,p_name=>'P33_SIGNATURE_DATA'
,p_item_sequence=>60
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010183048Z')
,p_updated_on=>wwv_flow_imp.dz('20261010183048Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44032869681628849)
,p_name=>'P33_SIGNATURE_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(44032209189628843)
,p_prompt=>'Name'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010185818Z')
,p_updated_on=>wwv_flow_imp.dz('20261010185818Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44031800055628839)
,p_name=>'P33_WORKFLOW_STATUS'
,p_item_sequence=>40
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010182210Z')
,p_updated_on=>wwv_flow_imp.dz('20261010183049Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(56989328991385709)
,p_validation_name=>'Reason Required When No'
,p_static_id=>'reason-required-when-no'
,p_validation_sequence=>20
,p_validation=>'NOT (:P33_CAN_PROCEED = ''N'' AND TRIM(:P33_NO_REASON) IS NULL)'
,p_validation2=>'SQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>'Record why the work must not proceed.'
,p_when_button_pressed=>wwv_flow_imp.id(56988517734385701)
,p_associated_item=>wwv_flow_imp.id(44032796921628848)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20261010185818Z')
,p_updated_on=>wwv_flow_imp.dz('20261010185818Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(56989457629385710)
,p_validation_name=>'Signature Required'
,p_static_id=>'signature-required'
,p_validation_sequence=>30
,p_validation=>'P33_SIGNATURE_DATA'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'A Signature is required.'
,p_when_button_pressed=>wwv_flow_imp.id(56988517734385701)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20261010185818Z')
,p_updated_on=>wwv_flow_imp.dz('20261010185818Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(56989289911385708)
,p_validation_name=>'Stage 3 Answer Required'
,p_static_id=>'stage-3-answer-required'
,p_validation_sequence=>10
,p_validation=>'P33_CAN_PROCEED'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'You must answer if you can proceed.',
''))
,p_when_button_pressed=>wwv_flow_imp.id(56988517734385701)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20261010185818Z')
,p_updated_on=>wwv_flow_imp.dz('20261010185818Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(56989069904385706)
,p_name=>'Click Complete'
,p_static_id=>'click-complete'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(56988517734385701)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_created_on=>wwv_flow_imp.dz('20261010185818Z')
,p_updated_on=>wwv_flow_imp.dz('20261010185818Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(56989116981385707)
,p_event_id=>wwv_flow_imp.id(56989069904385706)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'apex.message.clearErrors();',
    'var sig = draSignaturePad ? draSignaturePad.getDataURL() : '''';',
    'if (!sig) {',
    '    apex.message.showErrors([{ type: ''error'', location: ''page'',',
    '                               message: ''Please sign before completing the DRA.'', unsafe: false }]);',
    '} else {',
    '    apex.item(''P33_SIGNATURE_DATA'').setValue(sig);',
    '    var msg = apex.item(''P33_CAN_PROCEED'').getValue() === ''N''',
    '        ? ''Complete this DRA with the answer NO? The work must not proceed.''',
    '        : ''Complete and sign this DRA? It cannot be changed afterwards.'';',
    '    apex.message.confirm(msg, function (ok) {',
    '        if (ok) { captureLocationThenSubmit(''COMPLETE_DRA''); }',
    '    });',
    '}')))).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010185818Z')
,p_updated_on=>wwv_flow_imp.dz('20261010185818Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(56988851121385704)
,p_name=>'On Page Load'
,p_static_id=>'on-page-load'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
,p_created_on=>wwv_flow_imp.dz('20261010185818Z')
,p_updated_on=>wwv_flow_imp.dz('20261010191350Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(56988960141385705)
,p_event_id=>wwv_flow_imp.id(56988851121385704)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'var isReadOnly = apex.item(''P33_WORKFLOW_STATUS'').getValue() !== ''DRAFT'';',
    ' ',
    'initPad(''draSignaturePad'', ''P33_SIGNATURE_DATA'', function (pad) { draSignaturePad = pad; });',
    ' ',
    '// Binary Y/N badges - same pattern as Pages 16 / 24 (ptw-global.css styles)',
    '(function () {',
    '    var BINARY_ITEMS = [''P33_CAN_PROCEED''];',
    '    var BADGES = [',
    '        { val: ''Y'', cls: ''binary-badge-yes'', label: ''\u2713'' },',
    '        { val: ''N'', cls: ''binary-badge-no'',  label: ''\u2717'' }',
    '    ];',
    ' ',
    '    BINARY_ITEMS.forEach(function (itemName) {',
    '        var $fc = $(''#'' + itemName).closest(''.t-Form-fieldContainer'');',
    '        if ($fc.length === 0) return;',
    '        $fc.find(''.binary-badge-row'').remove();',
    ' ',
    '        var currentVal = isReadOnly',
    '            ? (apex.item(itemName).getValue() || '''')',
    '            : ($(''input[name="'' + itemName + ''"]:checked'').val() || '''');',
    ' ',
    '        var $row = $(''<div class="binary-badge-row"></div>'').attr(''data-item'', itemName);',
    '        BADGES.forEach(function (b) {',
    '            $(''<span></span>'')',
    '                .addClass(''binary-badge '' + b.cls)',
    '                .toggleClass(''cm-active'', currentVal === b.val)',
    '                .toggleClass(''binary-readonly'', isReadOnly)',
    '                .attr(''data-value'', b.val)',
    '                .text(b.label)',
    '                .appendTo($row);',
    '        });',
    '        $fc.find(''.t-Form-inputContainer'').append($row);',
    '    });',
    ' ',
    '    $(''.cm-binary-item .apex-item-grid'').hide();',
    ' ',
    '    $(document).off(''click.binarybadge33'').on(''click.binarybadge33'', ''.binary-badge:not(.binary-readonly)'', function () {',
    '        var $badge   = $(this);',
    '        var $row     = $badge.closest(''.binary-badge-row'');',
    '        var itemName = $row.attr(''data-item'');',
    '        var val      = $badge.attr(''data-value'');',
    ' ',
    '        // .trigger(''change'') also fires the "Toggle No Reason" DA',
    '        $(''input[name="'' + itemName + ''"][value="'' + val + ''"]'')',
    '            .prop(''checked'', true).trigger(''change'');',
    ' ',
    '        $row.find(''.binary-badge'').removeClass(''cm-active'');',
    '        $badge.addClass(''cm-active'');',
    '    });',
    '}());',
    ' ',
    'if (isReadOnly) {',
    '    var c = document.getElementById(''draSignaturePad'');',
    '    if (c) { c.style.pointerEvents = ''none''; c.style.opacity = ''0.6''; }',
    '    $(''#BTN_CLEAR_DRA_SIG'').hide();',
    '}',
    '')))).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010185818Z')
,p_updated_on=>wwv_flow_imp.dz('20261010191350Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(56989992024385715)
,p_name=>'Show No Reason'
,p_static_id=>'show-no-reason'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P33_CAN_PROCEED'
,p_condition_element=>'P33_CAN_PROCEED'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'N'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_created_on=>wwv_flow_imp.dz('20261010191325Z')
,p_updated_on=>wwv_flow_imp.dz('20261010191325Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(56990118522385717)
,p_event_id=>wwv_flow_imp.id(56989992024385715)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_static_id=>'native-hide'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P33_NO_REASON'
,p_created_on=>wwv_flow_imp.dz('20261010191325Z')
,p_updated_on=>wwv_flow_imp.dz('20261010191325Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(56990063501385716)
,p_event_id=>wwv_flow_imp.id(56989992024385715)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_static_id=>'native-show'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P33_NO_REASON'
,p_created_on=>wwv_flow_imp.dz('20261010191325Z')
,p_updated_on=>wwv_flow_imp.dz('20261010191325Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(56989521421385711)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Complete DRA'
,p_static_id=>'complete-dra'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    ptw_pro.ptw_dra_pkg.complete_dra(',
'        p_dra_id         => :P33_DRA_ID,',
'        p_can_proceed    => CASE :P33_CAN_PROCEED WHEN ''Y'' THEN ''YES''',
'                                                  WHEN ''N'' THEN ''NO'' END,',
'        p_no_reason      => :P33_NO_REASON,',
'        p_signature_name => :P33_SIGNATURE_NAME,',
'        p_signature_b64  => :P33_SIGNATURE_DATA,',
'        p_latitude       => TO_NUMBER(:APP_LATITUDE),',
'        p_longitude      => TO_NUMBER(:APP_LONGITUDE));',
'    apex_application.g_print_success_message :=',
'        CASE :P33_CAN_PROCEED',
'            WHEN ''N''  THEN ''DRA '' || :P33_DRA_NUMBER || '' completed - work must NOT proceed.''',
'            ELSE ''DRA '' || :P33_DRA_NUMBER || '' completed.''',
'        END;',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_error.add_error(',
'            p_message          => REGEXP_REPLACE(SQLERRM, ''^ORA-\d+: ''),',
'            p_display_location => apex_error.c_inline_in_notification);',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(56988517734385701)
,p_internal_uid=>56989521421385711
,p_created_on=>wwv_flow_imp.dz('20261010185819Z')
,p_updated_on=>wwv_flow_imp.dz('20261010185819Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(56988793224385703)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load DRA Sign-off'
,p_static_id=>'load-dra-sign-off'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_sig        BLOB;',
'    l_created_by ptw_pro.ptw_lv_dra_assessments.created_by%TYPE;',
'BEGIN',
'    IF :P33_DRA_ID IS NULL THEN',
'        apex_util.redirect_url(apex_page.get_url(p_page => 11));',
'    END IF;',
' ',
'    SELECT dra_number, workflow_status,',
'           CASE stage3_can_proceed WHEN ''YES'' THEN ''Y'' WHEN ''NO'' THEN ''N'' END,',
'           stage3_no_reason, signature_person_name, signature, created_by',
'    INTO   :P33_DRA_NUMBER, :P33_WORKFLOW_STATUS, :P33_CAN_PROCEED, :P33_NO_REASON,',
'           :P33_SIGNATURE_NAME, l_sig, l_created_by',
'    FROM   ptw_pro.ptw_lv_dra_assessments',
'    WHERE  dra_id = :P33_DRA_ID;',
' ',
'    IF :P33_WORKFLOW_STATUS = ''DRAFT'' THEN',
'        BEGIN',
'            SELECT TRIM(first_name || '' '' || last_name)',
'            INTO   :P33_SIGNATURE_NAME',
'            FROM   ptw_pro.ptw_lv_users',
'            WHERE  UPPER(username) = UPPER(l_created_by);',
'        EXCEPTION',
'            WHEN NO_DATA_FOUND THEN :P33_SIGNATURE_NAME := l_created_by;',
'        END;',
'    ELSIF l_sig IS NOT NULL THEN',
'        :P33_SIGNATURE_DATA := ''data:image/png;base64,'' || apex_web_service.blob2clobbase64(l_sig);',
'    END IF;',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        apex_util.redirect_url(apex_page.get_url(p_page => 11));',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>56988793224385703
,p_created_on=>wwv_flow_imp.dz('20261010185818Z')
,p_updated_on=>wwv_flow_imp.dz('20261010185818Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
