prompt --application/pages/page_00013
begin
--   Manifest
--     PAGE: 00013
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
 p_id=>13
,p_name=>'Hazards & Controls'
,p_alias=>'DRA-HAZARDS-CONTROLS'
,p_step_title=>'Hazards & Controls'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.ptw-dra-category {',
'    font-weight: 700; font-size: 0.9rem; color: #003366;',
'    text-transform: uppercase; letter-spacing: 0.03em;',
'    margin: 1.25rem 0 0.5rem 0; padding-bottom: 0.35rem;',
'    border-bottom: 2px solid var(--ut-palette-neutral-300, #d0d0d0);',
'}',
'.ptw-dra-category:first-child { margin-top: 0; }',
''))
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_read_only_when=>'P13_WORKFLOW_STATUS'
,p_read_only_when2=>'DRAFT'
,p_page_component_map=>'25'
,p_created_on=>wwv_flow_imp.dz('20260920202117Z')
,p_last_updated_on=>wwv_flow_imp.dz('20261104105151Z')
,p_created_by=>'PTW_PRO'
,p_last_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(44030667004628827)
,p_plug_name=>'Buttons'
,p_static_id=>'buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>140
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010180445Z')
,p_updated_on=>wwv_flow_imp.dz('20261010180446Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(88041755943361392)
,p_plug_name=>'DRA Number / Type Badge'
,p_static_id=>'dra-number-type-badge'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>90
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="margin-bottom: 20px;">',
'    <span class="apex-badge" style="background-color: #3ea055; color: white; padding: 6px 16px; border-radius: 20px; font-weight: 600;">',
'        DRA: &P13_DRA_NUMBER.',
'    </span>',
'</div>'))
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P13_DRA_NUMBER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920202450Z')
,p_updated_on=>wwv_flow_imp.dz('20261010180445Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(88042522639362704)
,p_plug_name=>'Stage 1 - Stop & Think'
,p_static_id=>'dra-stage1-region'
,p_title=>'Stage 1 - Stop & Think'
,p_region_name=>'dra-stage1-region'
,p_icon_css_classes=>'fa-question-circle'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent10:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>100
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P13_DRA_ID'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920202503Z')
,p_updated_on=>wwv_flow_imp.dz('20261010180445Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(44030528737628826)
,p_plug_name=>'Other Hazards & Controls'
,p_static_id=>'other-hazards-controls'
,p_title=>'Other Hazards & Controls'
,p_region_name=>'dra-other-region'
,p_icon_css_classes=>'fa-pencil'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent10:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>130
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P13_DRA_ID'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010180445Z')
,p_updated_on=>wwv_flow_imp.dz('20261010180446Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(88041459901359281)
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
'           || ''      Step 2 of 3 - Stop &amp; Think, Hazards &amp; Controls''',
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
'            || ''<p style="color:#666;">Step 2 of 3 - Stop &amp; '' ',
'            || ''Think, Hazards &amp; Controls'';',
'END;',
''))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_created_on=>wwv_flow_imp.dz('20260920202429Z')
,p_updated_on=>wwv_flow_imp.dz('20261010180445Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(44030369405628824)
,p_plug_name=>'Stage 2A - Identify the Hazards'
,p_static_id=>'stage-2a-identify-the-hazards'
,p_title=>'Stage 2A - Identify the Hazards'
,p_region_name=>'dra-hazards-region'
,p_icon_css_classes=>'fa-warning'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent10:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>110
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P13_DRA_ID'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010180445Z')
,p_updated_on=>wwv_flow_imp.dz('20261010180446Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(44030466366628825)
,p_plug_name=>'Stage 2B - Control Measures'
,p_static_id=>'stage-2b-control-measures'
,p_title=>'Stage 2B - Control Measures'
,p_region_name=>'dra-controls-region'
,p_icon_css_classes=>'fa-shield'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent10:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>120
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P13_DRA_ID'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010180445Z')
,p_updated_on=>wwv_flow_imp.dz('20261010180446Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(44030961618628830)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(44030667004628827)
,p_button_name=>'BACK'
,p_static_id=>'back'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Back'
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:12:P12_DRA_ID:&P13_DRA_ID.'
,p_warn_on_unsaved_changes=>null
,p_created_on=>wwv_flow_imp.dz('20261010180445Z')
,p_updated_on=>wwv_flow_imp.dz('20261010180445Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(44031115530628832)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(44030667004628827)
,p_button_name=>'NEXT_STEP'
,p_static_id=>'next-step'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Next Step'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-arrow-right'
,p_created_on=>wwv_flow_imp.dz('20261010180445Z')
,p_updated_on=>wwv_flow_imp.dz('20261104105151Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(44031086920628831)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(44030667004628827)
,p_button_name=>'SAVE_DRAFT'
,p_static_id=>'save-draft'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Save Draft'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P13_WORKFLOW_STATUS'
,p_button_condition2=>'DRAFT'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_created_on=>wwv_flow_imp.dz('20261010180445Z')
,p_updated_on=>wwv_flow_imp.dz('20261010180445Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(44031795253628838)
,p_branch_name=>'Stay on page'
,p_branch_action=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.:13:P13_DRA_ID:&P13_DRA_ID.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(44031086920628831)
,p_branch_sequence=>20
,p_created_on=>wwv_flow_imp.dz('20261010180445Z')
,p_updated_on=>wwv_flow_imp.dz('20261010190200Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(56989761335385713)
,p_branch_name=>'Sign DRA'
,p_branch_action=>'f?p=&APP_ID.:33:&SESSION.::&DEBUG.:33:P33_DRA_ID:&P13_DRA_ID.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(44031115530628832)
,p_branch_sequence=>10
,p_created_on=>wwv_flow_imp.dz('20261010190200Z')
,p_updated_on=>wwv_flow_imp.dz('20261010190200Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44029474561628815)
,p_name=>'P13_CHECKLIST_JSON'
,p_item_sequence=>60
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920203416Z')
,p_updated_on=>wwv_flow_imp.dz('20260920203416Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44030833894628829)
,p_name=>'P13_CONTROL_DETAILS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(44030528737628826)
,p_prompt=>'Other control measures not listed above'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>2000
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010180445Z')
,p_updated_on=>wwv_flow_imp.dz('20261010180445Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44029021213628811)
,p_name=>'P13_DRA_ID'
,p_item_sequence=>40
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920202356Z')
,p_updated_on=>wwv_flow_imp.dz('20260920202356Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44029187216628812)
,p_name=>'P13_DRA_NUMBER'
,p_item_sequence=>50
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920202356Z')
,p_updated_on=>wwv_flow_imp.dz('20261010180445Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44030714592628828)
,p_name=>'P13_HAZARD_DETAILS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(44030528737628826)
,p_prompt=>'Other hazards not listed above'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>2000
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010180445Z')
,p_updated_on=>wwv_flow_imp.dz('20261010180445Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44028956678628810)
,p_name=>'P13_WORKFLOW_STATUS'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920202356Z')
,p_updated_on=>wwv_flow_imp.dz('20261010180445Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(44050137823547121)
,p_validation_name=>'All Stage 1 Questions Must Be Answered'
,p_static_id=>'all-stage-1-questions-must-be-answered'
,p_validation_sequence=>10
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_unanswered_count NUMBER;',
'BEGIN',
'    IF :P13_DRA_ID IS NULL THEN',
'        RETURN TRUE; -- DRA not created yet - nothing to check',
'    END IF;',
' ',
'    SELECT COUNT(*)',
'    INTO   l_unanswered_count',
'    FROM   ptw_pro.ptw_dra_items di',
'    WHERE  di.section_code = ''STAGE1''',
'    AND    di.is_active    = ''Y''',
'    AND    NOT EXISTS (',
'        SELECT 1',
'        FROM   JSON_TABLE(:P13_CHECKLIST_JSON, ''$[*]''',
'                   COLUMNS (',
'                       dra_item_id NUMBER      PATH ''$.dra_item_id'',',
'                       response    VARCHAR2(3) PATH ''$.response''',
'                   )) jt',
'        WHERE  jt.dra_item_id = di.dra_item_id',
'        AND    jt.response IS NOT NULL',
'    );',
' ',
'    RETURN l_unanswered_count = 0;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'All 20 Stage 1 questions must be answered before moving on.'
,p_when_button_pressed=>wwv_flow_imp.id(44031115530628832)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260920202542Z')
,p_updated_on=>wwv_flow_imp.dz('20261010180445Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(44031544626628836)
,p_name=>'Click Next Step'
,p_static_id=>'click-next-step'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(44031115530628832)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_created_on=>wwv_flow_imp.dz('20261010180445Z')
,p_updated_on=>wwv_flow_imp.dz('20261010180445Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(44031635903628837)
,p_event_id=>wwv_flow_imp.id(44031544626628836)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'apex.item(''P13_CHECKLIST_JSON'').setValue(JSON.stringify(PTW.dra.collect()));',
    'apex.page.submit(''NEXT_STEP'');')))).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010180445Z')
,p_updated_on=>wwv_flow_imp.dz('20261010180445Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(44031343049628834)
,p_name=>'Click Save Draft'
,p_static_id=>'click-save-draft'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(44031086920628831)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_created_on=>wwv_flow_imp.dz('20261010180445Z')
,p_updated_on=>wwv_flow_imp.dz('20261010180445Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(44031457333628835)
,p_event_id=>wwv_flow_imp.id(44031343049628834)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'apex.item(''P13_CHECKLIST_JSON'').setValue(JSON.stringify(PTW.dra.collect()));',
    'apex.page.submit(''SAVE_DRAFT'');')))).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010180445Z')
,p_updated_on=>wwv_flow_imp.dz('20261010180445Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(44029214609628813)
,p_name=>'Page Load'
,p_static_id=>'page-load'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
,p_created_on=>wwv_flow_imp.dz('20260920202852Z')
,p_updated_on=>wwv_flow_imp.dz('20261010180445Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(44029348562628814)
,p_event_id=>wwv_flow_imp.id(44029214609628813)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'PTW.dra.load(',
    '    $v(''P13_DRA_ID''),',
    '    { stage1:   ''dra-stage1-region'',',
    '      hazards:  ''dra-hazards-region'',',
    '      controls: ''dra-controls-region'' },',
    '    apex.item(''P13_WORKFLOW_STATUS'').getValue() !== ''DRAFT''',
    ');',
    '')))).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920202852Z')
,p_updated_on=>wwv_flow_imp.dz('20261010180445Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(44055442241627904)
,p_process_sequence=>20
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_DRA_JSON'
,p_static_id=>'get-dra-json'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    htp.prn(''{"items":'' || ptw_pro.ptw_dra_pkg.get_dra_json(apex_application.g_x01) || ''}'');',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>44055442241627904
,p_created_on=>wwv_flow_imp.dz('20260920203910Z')
,p_updated_on=>wwv_flow_imp.dz('20260920203910Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(44031201492628833)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load DRA'
,p_static_id=>'load-dra'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    IF :P13_DRA_ID IS NULL THEN',
'        apex_util.redirect_url(apex_page.get_url(p_page => 11));',
'    END IF;',
' ',
'    SELECT dra_number, workflow_status, hazard_details, control_details',
'    INTO   :P13_DRA_NUMBER, :P13_WORKFLOW_STATUS, :P13_HAZARD_DETAILS, :P13_CONTROL_DETAILS',
'    FROM   ptw_pro.ptw_lv_dra_assessments',
'    WHERE  dra_id = :P13_DRA_ID;',
'    ',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        apex_util.redirect_url(apex_page.get_url(p_page => 11));',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>44031201492628833
,p_created_on=>wwv_flow_imp.dz('20261010180445Z')
,p_updated_on=>wwv_flow_imp.dz('20261010180445Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(44053143640568185)
,p_process_sequence=>10
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save DRA Responses'
,p_static_id=>'save-stage-1-responses'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    ptw_pro.ptw_dra_pkg.save_dra_responses(:P13_DRA_ID, :P13_CHECKLIST_JSON);',
'    ptw_pro.ptw_dra_pkg.save_dra_details(',
'        p_dra_id          => :P13_DRA_ID,',
'        p_hazard_details  => :P13_HAZARD_DETAILS,',
'        p_control_details => :P13_CONTROL_DETAILS);',
'    apex_application.g_print_success_message := ''DRA '' || :P13_DRA_NUMBER || '' saved.'';',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_error.add_error(',
'            p_message          => REGEXP_REPLACE(SQLERRM, ''^ORA-\d+: ''),',
'            p_display_location => apex_error.c_inline_in_notification);',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>wwv_flow_string.join(wwv_flow_t_varchar2(
':REQUEST IN (''SAVE_DRAFT'',''NEXT_STEP'')',
'AND :P13_WORKFLOW_STATUS = ''DRAFT'''))
,p_process_when_type=>'EXPRESSION'
,p_process_when2=>'PLSQL'
,p_internal_uid=>44053143640568185
,p_created_on=>wwv_flow_imp.dz('20260920202912Z')
,p_updated_on=>wwv_flow_imp.dz('20261104104911Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
