prompt --application/pages/page_00019
begin
--   Manifest
--     PAGE: 00019
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
 p_id=>19
,p_name=>'Linked Permits'
,p_alias=>'LINKED-PERMITS'
,p_page_mode=>'MODAL'
,p_step_title=>'Linked Permits'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function ptwRemoveLink(linkId, otherPermitNumber) {',
'    apex.message.confirm(''Remove the link to '' + otherPermitNumber + ''?'', function(ok) {',
'        if (ok) {',
'            apex.page.submit({ request: ''REMOVE_LINK_'' + linkId });',
'        }',
'    });',
'}',
''))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'@media (max-width: 768px) {',
'    .ui-dialog {',
'        width: 96vw !important;',
'        max-width: 96vw !important;',
'        height: 92vh !important;',
'        max-height: 92vh !important;',
'        top: 4vh !important;',
'        left: 2vw !important;',
'        margin: 0 !important;',
'    }',
'    .ui-dialog-content {',
'        max-height: calc(92vh - 110px) !important;',
'        overflow-y: auto !important;',
'        -webkit-overflow-scrolling: touch;',
'    }',
'}'))
,p_step_template=>2100407606326202693
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'03'
,p_created_on=>wwv_flow_imp.dz('20260919164450Z')
,p_last_updated_on=>wwv_flow_imp.dz('20260919174951Z')
,p_created_by=>'PTW_PRO'
,p_last_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(42198630663924539)
,p_plug_name=>'Add Link'
,p_static_id=>'add-links'
,p_title=>'Link to Another Permit'
,p_icon_css_classes=>'fa-plus-circle'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>70
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260919170553Z')
,p_updated_on=>wwv_flow_imp.dz('20260919174950Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(43895596635698001)
,p_plug_name=>'Buttons'
,p_static_id=>'buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>90
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260919170553Z')
,p_updated_on=>wwv_flow_imp.dz('20260919174950Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(42198915809924542)
,p_name=>'Currently Linked'
,p_static_id=>'currently-linked'
,p_title=>'Currently Linked'
,p_template=>4072358936313175081
,p_display_sequence=>60
,p_icon_css_classes=>'fa-link'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT lv.link_id, ',
'       lv.other_permit_id, ',
'       lv.link_note, ',
'       lv.created_by, ',
'       lv.created_date,',
'       op.permit_number, ',
'       t.type_desc, ',
'       op.workflow_status,',
'       ''<button type="button"',
'           class="t-Button t-Button--noLabel t-Button--icon t-Button--danger ptw-action-btn"',
'           title="Remove Link"',
'           onclick="ptwRemoveLink('' || lv.link_id || '', '''''' || op.permit_number || ''''''); return false;">',
'       <span class="t-Icon fa fa-unlink" aria-hidden="true"></span>',
'       </button>'' AS remove_html',
'FROM   ptw_pro.ptw_permit_links_v lv',
'JOIN   ptw_pro.ptw_lv_permits op ON op.permit_id = lv.other_permit_id',
'JOIN   ptw_pro.ptw_types t       ON t.ptw_type   = op.ptw_type',
'WHERE  lv.permit_id = :P19_PERMIT_ID',
'ORDER  BY lv.created_date DESC'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P19_PERMIT_ID'
,p_lazy_loading=>false
,p_query_row_template=>2538654340625403440
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
,p_created_on=>wwv_flow_imp.dz('20260919170553Z')
,p_updated_on=>wwv_flow_imp.dz('20260919174951Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(42199318263924546)
,p_query_column_id=>4
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>70
,p_column_heading=>'Linked By'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_updated_on=>wwv_flow_imp.dz('20260919174951Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(42199472299924547)
,p_query_column_id=>5
,p_column_alias=>'CREATED_DATE'
,p_column_display_sequence=>80
,p_column_heading=>'Linked On'
,p_column_format=>'DD-MON-YYYY HH24:MI'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_updated_on=>wwv_flow_imp.dz('20260919174951Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(42199089980924543)
,p_query_column_id=>1
,p_column_alias=>'LINK_ID'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
,p_updated_on=>wwv_flow_imp.dz('20260919174951Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(42199237390924545)
,p_query_column_id=>3
,p_column_alias=>'LINK_NOTE'
,p_column_display_sequence=>60
,p_column_heading=>'Note'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_updated_on=>wwv_flow_imp.dz('20260919174951Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(42199187173924544)
,p_query_column_id=>2
,p_column_alias=>'OTHER_PERMIT_ID'
,p_column_display_sequence=>20
,p_hidden_column=>'Y'
,p_derived_column=>'N'
,p_updated_on=>wwv_flow_imp.dz('20260919174951Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(42199576592924548)
,p_query_column_id=>6
,p_column_alias=>'PERMIT_NUMBER'
,p_column_display_sequence=>30
,p_column_heading=>'Permit Number'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_updated_on=>wwv_flow_imp.dz('20260919174951Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(43896031669698006)
,p_query_column_id=>9
,p_column_alias=>'REMOVE_HTML'
,p_column_display_sequence=>90
,p_heading_alignment=>'LEFT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_updated_on=>wwv_flow_imp.dz('20260919174951Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(42199611411924549)
,p_query_column_id=>7
,p_column_alias=>'TYPE_DESC'
,p_column_display_sequence=>40
,p_column_heading=>'Type'
,p_column_html_expression=>'  <span class="t-Badge #WORKFLOW_STATUS# t-Badge--lg">#WORKFLOW_STATUS#</span>'
,p_heading_alignment=>'LEFT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_updated_on=>wwv_flow_imp.dz('20260919174951Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(42199752489924550)
,p_query_column_id=>8
,p_column_alias=>'WORKFLOW_STATUS'
,p_column_display_sequence=>50
,p_column_heading=>'Status'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_updated_on=>wwv_flow_imp.dz('20260919174951Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(43895971273698005)
,p_plug_name=>'Page Title'
,p_static_id=>'page-title'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>50
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'  <div style="margin-bottom: 20px;">',
'      <span class="apex-badge" style="background-color: #3ea055; color: white; padding: 6px 16px; border-radius: 20px; font-weight: 600;">',
'          Permit: &P19_PERMIT_NUMBER.',
'      </span>',
'  </div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260919174950Z')
,p_updated_on=>wwv_flow_imp.dz('20260919174951Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(43895676849698002)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(43895596635698001)
,p_button_name=>'CANCEL'
,p_static_id=>'cancel'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:1::'
,p_warn_on_unsaved_changes=>null
,p_created_on=>wwv_flow_imp.dz('20260919170553Z')
,p_updated_on=>wwv_flow_imp.dz('20260919174951Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(43895761170698003)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(43895596635698001)
,p_button_name=>'ADD_LINK'
,p_static_id=>'save'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Link'
,p_button_position=>'CREATE'
,p_icon_css_classes=>'fa-link'
,p_created_on=>wwv_flow_imp.dz('20260919170553Z')
,p_updated_on=>wwv_flow_imp.dz('20260919174951Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(43896246620698008)
,p_branch_name=>'Refresh after add'
,p_branch_action=>'f?p=&APP_ID.:19:&SESSION.::&DEBUG.:19:P19_PERMIT_ID,P19_PERMIT_NUMBER:&P19_PERMIT_ID.,&P19_PERMIT_NUMBER.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(43895761170698003)
,p_branch_sequence=>10
,p_created_on=>wwv_flow_imp.dz('20260919174951Z')
,p_updated_on=>wwv_flow_imp.dz('20260919174951Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(43896343527698009)
,p_branch_name=>'refresh-after-remove'
,p_branch_action=>'f?p=&APP_ID.:19:&SESSION.::&DEBUG.:19:P19_PERMIT_ID:&P19_PERMIT_ID.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
,p_branch_condition_type=>'REQUEST_IN_CONDITION'
,p_branch_condition=>'REMOVE_LINK'
,p_created_on=>wwv_flow_imp.dz('20260919174951Z')
,p_updated_on=>wwv_flow_imp.dz('20260919174951Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(42198890734924541)
,p_name=>'P19_LINK_NOTE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(42198630663924539)
,p_prompt=>'Link Note'
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
,p_created_on=>wwv_flow_imp.dz('20260919170553Z')
,p_updated_on=>wwv_flow_imp.dz('20260919170553Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(42198771919924540)
,p_name=>'P19_LINK_PERMIT_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(42198630663924539)
,p_prompt=>'Permit to link'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('SELECT p.permit_number || '' \2014 '' || p.type_desc || '' \2014 '' || p.site_details AS d,'),
'       p.permit_id AS r',
'FROM   (',
'    SELECT lp.permit_id, lp.permit_number, lp.site_details, t.type_desc',
'    FROM   ptw_pro.ptw_lv_permits lp',
'    JOIN   ptw_pro.ptw_types t ON t.ptw_type = lp.ptw_type',
') p',
'WHERE  p.permit_id != :P19_PERMIT_ID',
'AND    p.permit_id NOT IN (',
'           SELECT other_permit_id FROM ptw_pro.ptw_permit_links_v WHERE permit_id = :P19_PERMIT_ID',
'       )',
'ORDER  BY p.permit_number'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-- Select a link --'
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
,p_created_on=>wwv_flow_imp.dz('20260919170553Z')
,p_updated_on=>wwv_flow_imp.dz('20260919174951Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(42198409773924537)
,p_name=>'P19_PERMIT_ID'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260919170553Z')
,p_updated_on=>wwv_flow_imp.dz('20260919170553Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(42198548828924538)
,p_name=>'P19_PERMIT_NUMBER'
,p_item_sequence=>40
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260919170553Z')
,p_updated_on=>wwv_flow_imp.dz('20260919170553Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(43895807913698004)
,p_process_sequence=>10
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Add Link'
,p_static_id=>'add-link'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_added   BOOLEAN;',
'    l_message VARCHAR2(4000);',
'BEGIN',
'    ptw_pro.ptw_permit_link_pkg.add_link(',
'        p_permit_id        => :P19_PERMIT_ID,',
'        p_linked_permit_id => :P19_LINK_PERMIT_ID,',
'        p_link_note        => :P19_LINK_NOTE,',
'        p_added            => l_added,',
'        p_message          => l_message',
'    );',
'',
'    IF l_added THEN',
'        apex_application.g_print_success_message := l_message;',
'        :P19_LINK_PERMIT_ID := NULL;',
'        :P19_LINK_NOTE      := NULL;',
'    ELSE',
'        apex_error.add_error(',
'            p_message          => l_message,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'    END IF;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(43895761170698003)
,p_internal_uid=>43895807913698004
,p_created_on=>wwv_flow_imp.dz('20260919172555Z')
,p_updated_on=>wwv_flow_imp.dz('20260919174951Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(43896193927698007)
,p_process_sequence=>20
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Remove Link'
,p_static_id=>'remove-link'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'  DECLARE',
'      l_link_id  ptw_pro.ptw_permit_links.link_id%TYPE;',
'      l_removed  BOOLEAN;',
'      l_message  VARCHAR2(4000);',
'  BEGIN',
'      l_link_id := TO_NUMBER(REPLACE(:REQUEST, ''REMOVE_LINK_'', ''''));',
'',
'      ptw_pro.ptw_permit_link_pkg.remove_link(',
'          p_link_id => l_link_id,',
'          p_removed => l_removed,',
'          p_message => l_message',
'      );',
'',
'      IF l_removed THEN',
'          apex_application.g_print_success_message := l_message;',
'      ELSE',
'          apex_error.add_error(',
'              p_message          => l_message,',
'              p_display_location => apex_error.c_inline_in_notification',
'          );',
'      END IF;',
'  END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>':REQUEST LIKE ''REMOVE_LINK_%'''
,p_process_when_type=>'EXPRESSION'
,p_process_when2=>'PLSQL'
,p_internal_uid=>43896193927698007
,p_created_on=>wwv_flow_imp.dz('20260919174951Z')
,p_updated_on=>wwv_flow_imp.dz('20260919174951Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
