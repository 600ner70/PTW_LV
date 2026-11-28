prompt --application/pages/page_00012
begin
--   Manifest
--     PAGE: 00012
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
 p_id=>12
,p_name=>'Site & Assessment Details'
,p_alias=>'SITE-ASSESSMENT-DETAILS'
,p_step_title=>'Site & Assessment Details'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function ptwToggleSupervisingCompany() {',
'    var isSub = apex.item(''P12_DRA_TYPE'').getValue() === ''SUBCONTRACTOR'';',
'    $(''#P12_SUPERVISING_COMPANY_CONTAINER, [id*="P12_SUPERVISING_COMPANY"]'')',
'        .closest(''.t-Form-fieldContainer'').toggle(isSub);',
'}'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.ptw-dra-category {',
'    font-weight: 700;',
'    font-size: 0.9rem;',
'    color: #003366;',
'    text-transform: uppercase;',
'    letter-spacing: 0.03em;',
'    margin: 1.25rem 0 0.5rem 0;',
'    padding-bottom: 0.35rem;',
'    border-bottom: 2px solid var(--ut-palette-neutral-300, #d0d0d0);',
'}',
'.ptw-dra-category:first-child { margin-top: 0; }',
''))
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_read_only_when=>'P12_WORKFLOW_STATUS'
,p_read_only_when2=>'DRAFT'
,p_page_component_map=>'25'
,p_created_on=>wwv_flow_imp.dz('20260920161218Z')
,p_last_updated_on=>wwv_flow_imp.dz('20261104104811Z')
,p_created_by=>'PTW_PRO'
,p_last_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(43992645533819426)
,p_plug_name=>'Assessment Details'
,p_static_id=>'assessment-details'
,p_title=>'Assessment Details'
,p_icon_css_classes=>'fa-clipboard'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent12:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>100
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920165511Z')
,p_updated_on=>wwv_flow_imp.dz('20260920210551Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(43992953997819429)
,p_plug_name=>'Buttons'
,p_static_id=>'buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>120
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920165512Z')
,p_updated_on=>wwv_flow_imp.dz('20260920174513Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(43992450278819424)
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
'        DRA: &P12_DRA_NUMBER.',
'    </span>',
'</div>'))
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P12_DRA_NUMBER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920165511Z')
,p_updated_on=>wwv_flow_imp.dz('20260920181045Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(43992364068819423)
,p_plug_name=>'Page Header'
,p_static_id=>'page-header'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>80
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
'           || ''      Step 1 of 3 - Site &amp; Assessment Details''',
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
'            || ''New Dynamic Risk Assessment</h1>''',
'            || ''<p style="color:#666;">Step 1 of 3 - Site &amp; ''',
'            || ''Assessment Details</p></div>'';',
'END;',
''))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_created_on=>wwv_flow_imp.dz('20260920165511Z')
,p_updated_on=>wwv_flow_imp.dz('20260920181045Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(43993024070819430)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(43992953997819429)
,p_button_name=>'BACK'
,p_static_id=>'new'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Back'
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.:11::'
,p_warn_on_unsaved_changes=>null
,p_created_on=>wwv_flow_imp.dz('20260920165512Z')
,p_updated_on=>wwv_flow_imp.dz('20260920174513Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(43994090587819440)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(43992953997819429)
,p_button_name=>'NEXT_STEP'
,p_static_id=>'next-step'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Next Step'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-arrow-right'
,p_created_on=>wwv_flow_imp.dz('20260920174513Z')
,p_updated_on=>wwv_flow_imp.dz('20260920174513Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(43993923249819439)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(43992953997819429)
,p_button_name=>'SAVE_DRAFT'
,p_static_id=>'save-draft'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Save Draft'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P12_WORKFLOW_STATUS'
,p_button_condition2=>'DRAFT'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_created_on=>wwv_flow_imp.dz('20260920174513Z')
,p_updated_on=>wwv_flow_imp.dz('20261104104810Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(44028416838628805)
,p_branch_name=>'Go to Hazards & Controls'
,p_branch_action=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.:13:P13_DRA_ID:&P12_DRA_ID.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(43994090587819440)
,p_branch_sequence=>10
,p_created_on=>wwv_flow_imp.dz('20260920175928Z')
,p_updated_on=>wwv_flow_imp.dz('20261010172847Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(44028561099628806)
,p_branch_name=>'Refresh Current Page (SAVE_DRAFT)'
,p_branch_action=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:12:P12_DRA_ID:&P12_DRA_ID.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(43993923249819439)
,p_branch_sequence=>20
,p_created_on=>wwv_flow_imp.dz('20260920175928Z')
,p_updated_on=>wwv_flow_imp.dz('20261010172847Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43993704435819437)
,p_name=>'P12_CHECKLIST_JSON'
,p_item_sequence=>60
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920174513Z')
,p_updated_on=>wwv_flow_imp.dz('20260920174513Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43992723810819427)
,p_name=>'P12_DRA_ID'
,p_item_sequence=>50
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920165512Z')
,p_updated_on=>wwv_flow_imp.dz('20260920165512Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43992580619819425)
,p_name=>'P12_DRA_NUMBER'
,p_item_sequence=>40
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920165512Z')
,p_updated_on=>wwv_flow_imp.dz('20260920181139Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43993164460819431)
,p_name=>'P12_DRA_TYPE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(43992645533819426)
,p_item_default=>'ENGINEER'
,p_prompt=>'Type of DRA'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Engineer DRA;ENGINEER,Subcontractor DRA;SUBCONTRACTOR'
,p_read_only_when=>'P12_DRA_ID'
,p_read_only_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2',
  'page_action_on_selection', 'NONE')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920173640Z')
,p_updated_on=>wwv_flow_imp.dz('20260920173640Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43993425656819434)
,p_name=>'P12_ENGINEER_NAME'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(43992645533819426)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_name ptw_pro.ptw_lv_users.first_name%TYPE;',
'    v_last ptw_pro.ptw_lv_users.last_name%TYPE;',
'BEGIN',
'    SELECT first_name, last_name',
'    INTO   v_name, v_last',
'    FROM   ptw_pro.ptw_lv_users',
'    WHERE  UPPER(username) = UPPER(:APP_USER);',
'    RETURN v_name || '' '' || v_last;',
'EXCEPTION',
'    WHEN OTHERS THEN RETURN NULL;',
'END;'))
,p_item_default_type=>'FUNCTION_BODY'
,p_item_default_language=>'PLSQL'
,p_prompt=>'Engineer Name'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920173640Z')
,p_updated_on=>wwv_flow_imp.dz('20261010172847Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43993890248819438)
,p_name=>'P12_IS_CHANGED'
,p_item_sequence=>70
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920174513Z')
,p_updated_on=>wwv_flow_imp.dz('20260920174513Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44030176578628822)
,p_name=>'P12_JOB_NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(43992645533819426)
,p_prompt=>'Job Number'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>100
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010172847Z')
,p_updated_on=>wwv_flow_imp.dz('20261010172847Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43993639290819436)
,p_name=>'P12_PERMIT_ID'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(43992645533819426)
,p_prompt=>'Related Permit (optional)'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT permit_number || '' - '' || SUBSTR(work_description, 1, 80) d,',
'       permit_id r',
'FROM   ptw_pro.ptw_lv_permits',
'WHERE  workflow_status NOT IN (''COMPLETED'', ''CANCELLED'', ''LAPSED'')',
'ORDER  BY created_date DESC'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-- Select permit --'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'case_sensitive', 'N',
  'display_as', 'POPUP',
  'fetch_on_search', 'N',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'match_type', 'CONTAINS',
  'min_chars', '0')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920173640Z')
,p_updated_on=>wwv_flow_imp.dz('20261010172847Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43993358210819433)
,p_name=>'P12_SITE_DETAILS'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(43992645533819426)
,p_prompt=>'Task and Work Location Details'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920173640Z')
,p_updated_on=>wwv_flow_imp.dz('20260920173640Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43993264537819432)
,p_name=>'P12_SITE_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(43992645533819426)
,p_prompt=>'Site'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT site_name d, site_id r',
'FROM   ptw_pro.ptw_lv_sites',
'WHERE is_active = ''Y''',
'ORDER BY site_name'))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'case_sensitive', 'N',
  'display_as', 'POPUP',
  'fetch_on_search', 'N',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'match_type', 'CONTAINS',
  'min_chars', '0')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920173640Z')
,p_updated_on=>wwv_flow_imp.dz('20261010172847Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43993544379819435)
,p_name=>'P12_SUPERVISING_COMPANY'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(43992645533819426)
,p_prompt=>'Subcontractor Company'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920173640Z')
,p_updated_on=>wwv_flow_imp.dz('20261010172847Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43992250516819422)
,p_name=>'P12_WORKFLOW_STATUS'
,p_item_sequence=>30
,p_item_default=>'DRAFT'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920161453Z')
,p_updated_on=>wwv_flow_imp.dz('20260920180503Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(43994762968819447)
,p_name=>'Get Location and Next Step'
,p_static_id=>'get-location-and-next-step'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(43994090587819440)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_created_on=>wwv_flow_imp.dz('20260920174513Z')
,p_updated_on=>wwv_flow_imp.dz('20261010172847Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(43994807161819448)
,p_event_id=>wwv_flow_imp.id(43994762968819447)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'captureLocationThenSubmit(''NEXT_STEP'');')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920174513Z')
,p_updated_on=>wwv_flow_imp.dz('20261010172847Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(43994552404819445)
,p_name=>'Get Location and Save Draft'
,p_static_id=>'get-location-and-save-draft'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(43993923249819439)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_created_on=>wwv_flow_imp.dz('20260920174513Z')
,p_updated_on=>wwv_flow_imp.dz('20261010172847Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(43994645208819446)
,p_event_id=>wwv_flow_imp.id(43994552404819445)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'captureLocationThenSubmit(''SAVE_DRAFT'');')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920174513Z')
,p_updated_on=>wwv_flow_imp.dz('20261010172847Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(43994153302819441)
,p_name=>'Load checklists'
,p_static_id=>'load-checklists'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
,p_created_on=>wwv_flow_imp.dz('20260920174513Z')
,p_updated_on=>wwv_flow_imp.dz('20260920202637Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(43994245336819442)
,p_event_id=>wwv_flow_imp.id(43994153302819441)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'ptwToggleSupervisingCompany();')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920174513Z')
,p_updated_on=>wwv_flow_imp.dz('20260920202637Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(43994354997819443)
,p_name=>'Toggle Subcontractor Field'
,p_static_id=>'toggle-subcontractor-field'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P12_DRA_TYPE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_created_on=>wwv_flow_imp.dz('20260920174513Z')
,p_updated_on=>wwv_flow_imp.dz('20260920174513Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(43994461060819444)
,p_event_id=>wwv_flow_imp.id(43994354997819443)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'ptwToggleSupervisingCompany();')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920174513Z')
,p_updated_on=>wwv_flow_imp.dz('20260920174513Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(43995088693819450)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load DRA Header Data'
,p_static_id=>'load-dra-header-data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    SELECT dra_number, dra_type, site_id, site_details, job_number,',
'           engineer_name, supervising_company, permit_id, workflow_status',
'    INTO   :P12_DRA_NUMBER, :P12_DRA_TYPE, :P12_SITE_ID, :P12_SITE_DETAILS,',
'           :P12_JOB_NUMBER, :P12_ENGINEER_NAME, :P12_SUPERVISING_COMPANY,',
'           :P12_PERMIT_ID, :P12_WORKFLOW_STATUS',
'    FROM   ptw_pro.ptw_lv_dra_assessments',
'    WHERE  dra_id = :P12_DRA_ID;',
' ',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        apex_error.add_error(',
'            p_message          => ''DRA not found.'',',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        apex_util.redirect_url(apex_page.get_url(p_page => 11));',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P12_DRA_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>43995088693819450
,p_created_on=>wwv_flow_imp.dz('20260920175928Z')
,p_updated_on=>wwv_flow_imp.dz('20260920180503Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(44028809410628809)
,p_process_sequence=>10
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save DRA Header'
,p_static_id=>'save-dra-header'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_dra_id      ptw_pro.ptw_lv_dra_assessments.dra_id%TYPE := :P12_DRA_ID;',
'    v_dra_number  ptw_pro.ptw_lv_dra_assessments.dra_number%TYPE;',
'    v_saved       BOOLEAN;',
'    v_message     VARCHAR2(4000);',
'BEGIN',
'    ptw_pro.ptw_dra_pkg.save_dra_header(',
'        p_dra_id              => v_dra_id,',
'        p_dra_type            => :P12_DRA_TYPE,',
'        p_workflow_status     => :P12_WORKFLOW_STATUS,',
'        p_site_id             => :P12_SITE_ID,',
'        p_site_details        => :P12_SITE_DETAILS,',
'        p_job_number          => :P12_JOB_NUMBER,',
'        p_engineer_name       => :P12_ENGINEER_NAME,',
'        p_supervising_company => :P12_SUPERVISING_COMPANY,',
'        p_permit_id           => :P12_PERMIT_ID,',
'        p_latitude            => TO_NUMBER(:APP_LATITUDE),',
'        p_longitude           => TO_NUMBER(:APP_LONGITUDE),',
'        p_dra_number          => v_dra_number,',
'        p_saved               => v_saved,',
'        p_message             => v_message',
'    );',
'',
'    IF v_saved THEN',
'        :P12_DRA_ID          := v_dra_id;',
'        :P12_DRA_NUMBER      := v_dra_number;',
'        :P12_WORKFLOW_STATUS := ''DRAFT'';',
'        apex_application.g_print_success_message := v_message;',
'    ELSE',
'        apex_error.add_error(',
'            p_message          => v_message,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'    END IF;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>wwv_flow_string.join(wwv_flow_t_varchar2(
':REQUEST IN (''SAVE_DRAFT'',''NEXT_STEP'')',
'AND :P12_WORKFLOW_STATUS = ''DRAFT'''))
,p_process_when_type=>'EXPRESSION'
,p_process_when2=>'PLSQL'
,p_internal_uid=>44028809410628809
,p_created_on=>wwv_flow_imp.dz('20260920194919Z')
,p_updated_on=>wwv_flow_imp.dz('20261104104811Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
