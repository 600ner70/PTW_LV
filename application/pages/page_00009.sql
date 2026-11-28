prompt --application/pages/page_00009
begin
--   Manifest
--     PAGE: 00009
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
 p_id=>9
,p_name=>'Start Permit'
,p_alias=>'START-PERMIT'
,p_page_mode=>'MODAL'
,p_step_title=>'Start Permit -  &P9_PERMIT_NUMBER.'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(function () {',
'    var BADGES = [',
'        { val: ''Y'', cls: ''binary-badge-yes'', label: ''\u2713'' },',
'        { val: ''N'', cls: ''binary-badge-no'',  label: ''\u2717'' }',
'    ];',
'    [''P9_DRA_REQUIRED''].forEach(function (itemName) {',
'        var $fc = $(''#'' + itemName).closest(''.t-Form-fieldContainer'');',
'        if ($fc.length === 0) return;',
'        $fc.find(''.binary-badge-row'').remove();',
'        var currentVal = $(''input[name="'' + itemName + ''"]:checked'').val() || '''';',
'        var $row = $(''<div class="binary-badge-row"></div>'').attr(''data-item'', itemName);',
'        BADGES.forEach(function (b) {',
'            $(''<span></span>'')',
'                .addClass(''binary-badge '' + b.cls)',
'                .toggleClass(''cm-active'', currentVal === b.val)',
'                .attr(''data-value'', b.val)',
'                .text(b.label)',
'                .appendTo($row);',
'        });',
'        $fc.find(''.t-Form-inputContainer'').append($row);',
'    });',
'    $(''.cm-binary-item .apex-item-grid'').hide();',
'    $(document).off(''click.binarybadge9'').on(''click.binarybadge9'', ''.binary-badge:not(.binary-readonly)'', function () {',
'        var $badge = $(this), $row = $badge.closest(''.binary-badge-row'');',
'        $(''input[name="'' + $row.attr(''data-item'') + ''"][value="'' + $badge.attr(''data-value'') + ''"]'')',
'            .prop(''checked'', true).trigger(''change'');   // fires the Show DRA picker DA',
'        $row.find(''.binary-badge'').removeClass(''cm-active'');',
'        $badge.addClass(''cm-active'');',
'    });',
'}());'))
,p_step_template=>2100407606326202693
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'16'
,p_created_on=>wwv_flow_imp.dz('20260305210111Z')
,p_last_updated_on=>wwv_flow_imp.dz('20261010193558Z')
,p_created_by=>'PTW_PRO'
,p_last_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(37956800412176029)
,p_plug_name=>'Buttons'
,p_static_id=>'buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>130
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260331184005Z')
,p_updated_on=>wwv_flow_imp.dz('20261010193557Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(37956111549176022)
,p_plug_name=>'Immediate Dates'
,p_static_id=>'immediate-dates'
,p_icon_css_classes=>'fa-clock-o'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>120
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div id="p9ImmediateDates" class="t-Alert t-Alert--info t-Alert--horizontal">',
'  <div class="t-Alert-wrap">',
'    <div class="t-Alert-icon"><span class="t-Icon fa fa-clock-o"></span></div>',
'    <div class="t-Alert-content">',
'      <div class="t-Alert-body">',
'        Permit will be valid: <strong id="p9ImmFrom"></strong> &mdash; <strong id="p9ImmTo"></strong>',
'      </div>',
'    </div>',
'  </div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260331184005Z')
,p_updated_on=>wwv_flow_imp.dz('20261010193557Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(90823356109525380)
,p_plug_name=>'Permit Duration Notice'
,p_static_id=>'permit-duration-notice'
,p_icon_css_classes=>'fa-clock-o'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>80
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="ptw-section-card">',
'    <div class="ptw-section-body">',
'        <div class="declaration-box">',
'            This Permit <strong>MUST</strong> be issued for the <strong>SHORTEST</strong> reasonable period of TIME (never usually longer than 12 Hours).',
'        </div>',
'    </div>',
'</div>',
''))
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260305211037Z')
,p_updated_on=>wwv_flow_imp.dz('20261010193557Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(37956912458176030)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(37956800412176029)
,p_button_name=>'CANCEL'
,p_static_id=>'cancel'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_warn_on_unsaved_changes=>null
,p_created_on=>wwv_flow_imp.dz('20260331184005Z')
,p_updated_on=>wwv_flow_imp.dz('20260331200040Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(37957245700176033)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(37956800412176029)
,p_button_name=>'START_PERMIT'
,p_static_id=>'start-permit'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Start Permit'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-play-circle'
,p_created_on=>wwv_flow_imp.dz('20260331184005Z')
,p_updated_on=>wwv_flow_imp.dz('20260331200040Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(45757381141782525)
,p_branch_name=>'Back to dashboard'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:1::'
,p_branch_point=>'BEFORE_COMPUTATION'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_branch_condition=>'START_PERMIT'
,p_created_on=>wwv_flow_imp.dz('20260505195049Z')
,p_updated_on=>wwv_flow_imp.dz('20260505195049Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(56990361696385719)
,p_name=>'P9_DRA_ID'
,p_item_sequence=>70
,p_prompt=>'Completed DRA for this work'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT d.dra_number || '' - '' || d.engineer_name',
'       || '' - '' || TO_CHAR(d.signed_datetime, ''DD-MON HH24:MI'') d,',
'       d.dra_id r',
'FROM   ptw_pro.ptw_lv_dra_assessments d',
'WHERE  d.workflow_status    = ''COMPLETED''',
'AND    d.stage3_can_proceed = ''YES''',
'AND    (   d.permit_id = :P9_PERMIT_ID',
'        OR (d.permit_id IS NULL AND d.signed_datetime >= SYSDATE - 1))',
'ORDER  BY CASE WHEN d.permit_id = :P9_PERMIT_ID THEN 0 ELSE 1 END,',
'          d.signed_datetime DESC'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-- Select DRA --'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_inline_help_text=>'Only completed DRAs that say the work can proceed are listed. Complete one from Dynamic Risk Assessments, choosing this permit as the Related Permit, then reopen Start Permit.'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
,p_created_on=>wwv_flow_imp.dz('20261010193557Z')
,p_updated_on=>wwv_flow_imp.dz('20261010193557Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(56990277140385718)
,p_name=>'P9_DRA_REQUIRED'
,p_item_sequence=>60
,p_prompt=>'Is a Dynamic Risk Assessment (DRA) needed for this work?'
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
,p_created_on=>wwv_flow_imp.dz('20261010193557Z')
,p_updated_on=>wwv_flow_imp.dz('20261010193557Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(32190723937428243)
,p_name=>'P9_END_DATE'
,p_item_sequence=>110
,p_prompt=>'END (Date & Time)'
,p_format_mask=>'DD-MON-YYYY HH24:MI'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'Y',
  'use_defaults', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260305211233Z')
,p_updated_on=>wwv_flow_imp.dz('20261010193557Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(37955802975176019)
,p_name=>'P9_PERMIT_ID'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260331181700Z')
,p_updated_on=>wwv_flow_imp.dz('20260331181700Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(37955933568176020)
,p_name=>'P9_PERMIT_NUMBER'
,p_item_sequence=>40
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260331181700Z')
,p_updated_on=>wwv_flow_imp.dz('20260411132611Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(32190486101430887)
,p_name=>'P9_START_DATE'
,p_item_sequence=>100
,p_prompt=>'START (Date & Time)'
,p_format_mask=>'DD-MON-YYYY HH24:MI'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'Y',
  'use_defaults', 'Y')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260305211207Z')
,p_updated_on=>wwv_flow_imp.dz('20261010193557Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(37956092869176021)
,p_name=>'P9_START_MODE'
,p_item_sequence=>90
,p_prompt=>'Choose the permit validity window'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'PTW_START_MODE'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2',
  'page_action_on_selection', 'NONE')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260331181700Z')
,p_updated_on=>wwv_flow_imp.dz('20261010193557Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(41970267257328833)
,p_name=>'P9_WORKFLOW_STATUS'
,p_item_sequence=>50
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260428211325Z')
,p_updated_on=>wwv_flow_imp.dz('20260428211325Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(56990841830385724)
,p_validation_name=>'DRA Answer Required'
,p_static_id=>'dra-answer-required'
,p_validation_sequence=>50
,p_validation=>'P9_DRA_REQUIRED'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Say whether a DRA is needed for this work.'
,p_when_button_pressed=>wwv_flow_imp.id(37957245700176033)
,p_associated_item=>wwv_flow_imp.id(56990277140385718)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20261010193557Z')
,p_updated_on=>wwv_flow_imp.dz('20261010193557Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(56990935956385725)
,p_validation_name=>'DRA Selected'
,p_static_id=>'dra-selected'
,p_validation_sequence=>60
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P9_DRA_REQUIRED = ''N''',
'OR (:P9_DRA_ID IS NOT NULL',
'AND ptw_pro.ptw_dra_pkg.can_use_for_permit(:P9_DRA_ID, :P9_PERMIT_ID) = ''Y'')'))
,p_validation2=>'SQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>'Select a completed DRA that says the work can proceed.'
,p_associated_item=>wwv_flow_imp.id(56990361696385719)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20261010193557Z')
,p_updated_on=>wwv_flow_imp.dz('20261010193557Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(37957713806176038)
,p_validation_name=>'End after Start'
,p_static_id=>'end-after-start'
,p_validation_sequence=>30
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'  IF :P9_END_DATE <= :P9_START_DATE THEN',
'    RETURN ''End Date must be after Start Date.'';',
'  END IF;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_ERR_TEXT'
,p_validation_condition=>'P9_START_MODE'
,p_validation_condition2=>'SCHEDULED'
,p_validation_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260331184005Z')
,p_updated_on=>wwv_flow_imp.dz('20260331184005Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(37957664630176037)
,p_validation_name=>'End Date Required (Scheduled)'
,p_static_id=>'end-date-required-scheduled'
,p_validation_sequence=>20
,p_validation=>'P9_END_DATE'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'End date is required.'
,p_validation_condition=>'P9_START_MODE'
,p_validation_condition2=>'SCHEDULED'
,p_validation_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260331184005Z')
,p_updated_on=>wwv_flow_imp.dz('20260331184005Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(37957836247176039)
,p_validation_name=>'Max of 12 hours'
,p_static_id=>'max-of-12-hours'
,p_validation_sequence=>40
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    RETURN NOT (',
'        :P9_START_MODE = ''SCHEDULED'' AND',
'        :P9_START_DATE IS NOT NULL AND',
'        :P9_END_DATE IS NOT NULL AND',
'        (TO_DATE(:P9_END_DATE, ''DD-MON-YYYY HH24:MI'') - ',
'         TO_DATE(:P9_START_DATE, ''DD-MON-YYYY HH24:MI'')) * 24 > 12',
'    );',
'EXCEPTION WHEN OTHERS THEN RETURN TRUE;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'A permit can only be open for maximum of 12 hours.'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260331184005Z')
,p_updated_on=>wwv_flow_imp.dz('20260331184005Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(37957549216176036)
,p_validation_name=>'Start Date Required (Scheduled)'
,p_static_id=>'start-date-required-scheduled'
,p_validation_sequence=>10
,p_validation=>'P9_START_DATE'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Start Date is required.'
,p_validation_condition=>'P9_START_MODE'
,p_validation_condition2=>'SCHEDULED'
,p_validation_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260331184005Z')
,p_updated_on=>wwv_flow_imp.dz('20260331184005Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(37956604539176027)
,p_name=>'Auto-calc End Date on Start Date change'
,p_static_id=>'auto-calc-end-date-on-start-date-change'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P9_START_DATE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_created_on=>wwv_flow_imp.dz('20260331184005Z')
,p_updated_on=>wwv_flow_imp.dz('20260331184005Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(37956712007176028)
,p_event_id=>wwv_flow_imp.id(37956604539176027)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'var startVal = apex.item(''P9_START_DATE'').getValue();',
    'if (startVal) {',
    '    var sd = new Date(startVal.replace(',
    '        /(\d{2})-([A-Z]{3})-(\d{4}) (\d{2}):(\d{2})/,',
    '        function(_, d, mon, y, h, mi) {',
    '            var mns = {JAN:0,FEB:1,MAR:2,APR:3,MAY:4,JUN:5,JUL:6,AUG:7,SEP:8,OCT:9,NOV:10,DEC:11};',
    '            return y + ''-'' + String(mns[mon]+1).padStart(2,''0'') + ''-'' + d + ''T'' + h + '':'' + mi;',
    '        }',
    '    ));',
    '    var ed = new Date(sd.getTime() + 12 * 60 * 60 * 1000);',
    '    var m = [''JAN'',''FEB'',''MAR'',''APR'',''MAY'',''JUN'',''JUL'',''AUG'',''SEP'',''OCT'',''NOV'',''DEC''];',
    '    var fmtd = String(ed.getDate()).padStart(2,''0'') + ''-'' + m[ed.getMonth()] + ''-''',
    '               + ed.getFullYear() + '' '' + String(ed.getHours()).padStart(2,''0'')',
    '               + '':'' + String(ed.getMinutes()).padStart(2,''0'');',
    '    apex.item(''P9_END_DATE'').setValue(fmtd);',
    '}')))).to_clob
,p_created_on=>wwv_flow_imp.dz('20260331184005Z')
,p_updated_on=>wwv_flow_imp.dz('20260331184005Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(37957003350176031)
,p_name=>'Cancel processing'
,p_static_id=>'cancel-processing'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(37956912458176030)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_created_on=>wwv_flow_imp.dz('20260331184005Z')
,p_updated_on=>wwv_flow_imp.dz('20260331184005Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(37957164218176032)
,p_event_id=>wwv_flow_imp.id(37957003350176031)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-dialog-close'
,p_action=>'NATIVE_DIALOG_CLOSE'
,p_created_on=>wwv_flow_imp.dz('20260331184005Z')
,p_updated_on=>wwv_flow_imp.dz('20260331184005Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(37956270772176023)
,p_name=>'Set Immediate Dates on Load'
,p_static_id=>'set-immediate-dates-on-load'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
,p_created_on=>wwv_flow_imp.dz('20260331184005Z')
,p_updated_on=>wwv_flow_imp.dz('20260331184005Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(37956389107176024)
,p_event_id=>wwv_flow_imp.id(37956270772176023)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'var now    = new Date();',
    'var toDate = new Date(now.getTime() + 12 * 60 * 60 * 1000);',
    'function fmtDt(d) {',
    '    var m = [''JAN'',''FEB'',''MAR'',''APR'',''MAY'',''JUN'',''JUL'',''AUG'',''SEP'',''OCT'',''NOV'',''DEC''];',
    '    return String(d.getDate()).padStart(2,''0'') + ''-'' + m[d.getMonth()] + ''-'' + d.getFullYear()',
    '           + '' '' + String(d.getHours()).padStart(2,''0'') + '':'' + String(d.getMinutes()).padStart(2,''0'');',
    '}',
    '$(''#p9ImmFrom'').text(fmtDt(now));',
    '$(''#p9ImmTo'').text(fmtDt(toDate));',
    '',
    '// Default radio to IMMEDIATE',
    'apex.item(''P9_START_MODE'').setValue(''IMMEDIATE'');',
    '$(''#p9ImmediateDates'').show();',
    '$(''[id*="P9_START_DATE"], [id*="P9_END_DATE"]'').closest(''.t-Form-fieldContainer'').hide();',
    '',
    '// Pre-populate date pickers with calculated values',
    'apex.item(''P9_START_DATE'').setValue(fmtDt(now));',
    'apex.item(''P9_END_DATE'').setValue(fmtDt(toDate));')))).to_clob
,p_created_on=>wwv_flow_imp.dz('20260331184005Z')
,p_updated_on=>wwv_flow_imp.dz('20260331184005Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(56990454792385720)
,p_name=>'Show DRA picker'
,p_static_id=>'show-dra-picker'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P9_DRA_REQUIRED'
,p_condition_element=>'P9_DRA_REQUIRED'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_created_on=>wwv_flow_imp.dz('20261010193557Z')
,p_updated_on=>wwv_flow_imp.dz('20261010193557Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(56990773992385723)
,p_event_id=>wwv_flow_imp.id(56990454792385720)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_static_id=>'native-clear'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P9_DRA_ID'
,p_created_on=>wwv_flow_imp.dz('20261010193557Z')
,p_updated_on=>wwv_flow_imp.dz('20261010193557Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(56990673698385722)
,p_event_id=>wwv_flow_imp.id(56990454792385720)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_static_id=>'native-hide'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P9_DRA_ID'
,p_created_on=>wwv_flow_imp.dz('20261010193557Z')
,p_updated_on=>wwv_flow_imp.dz('20261010193557Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(56990581060385721)
,p_event_id=>wwv_flow_imp.id(56990454792385720)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_static_id=>'native-show'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P9_DRA_ID'
,p_created_on=>wwv_flow_imp.dz('20261010193557Z')
,p_updated_on=>wwv_flow_imp.dz('20261010193557Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(37957343314176034)
,p_name=>'Start the permit'
,p_static_id=>'start-the-permit'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(37957245700176033)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_created_on=>wwv_flow_imp.dz('20260331184005Z')
,p_updated_on=>wwv_flow_imp.dz('20260331184005Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(37957411066176035)
,p_event_id=>wwv_flow_imp.id(37957343314176034)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'captureLocationThenSubmit(''START_PERMIT'');')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260331184005Z')
,p_updated_on=>wwv_flow_imp.dz('20260331184005Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(37956436560176025)
,p_name=>'Toggle Date Fields on Mode Change'
,p_static_id=>'toggle-date-fields-on-mode-change'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P9_START_MODE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_created_on=>wwv_flow_imp.dz('20260331184005Z')
,p_updated_on=>wwv_flow_imp.dz('20260331184005Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(37956524938176026)
,p_event_id=>wwv_flow_imp.id(37956436560176025)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'if (apex.item(''P9_START_MODE'').getValue() === ''IMMEDIATE'') {',
    '    $(''#p9ImmediateDates'').show();',
    '    $(''[id*="P9_START_DATE"], [id*="P9_END_DATE"]'').closest(''.t-Form-fieldContainer'').hide();',
    '} else {',
    '    $(''#p9ImmediateDates'').hide();',
    '    $(''[id*="P9_START_DATE"], [id*="P9_END_DATE"]'').closest(''.t-Form-fieldContainer'').show();',
    '}')))).to_clob
,p_created_on=>wwv_flow_imp.dz('20260331184005Z')
,p_updated_on=>wwv_flow_imp.dz('20260331184005Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(37958131306176042)
,p_process_sequence=>20
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_static_id=>'close-dialog'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'items_to_return', 'P9_WORKFLOW_STATUS',
  'show_success_messages', 'N')).to_clob
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_type=>'NEVER'
,p_internal_uid=>37958131306176042
,p_created_on=>wwv_flow_imp.dz('20260331184406Z')
,p_updated_on=>wwv_flow_imp.dz('20260505195049Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(37957981155176040)
,p_process_sequence=>10
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Start Permit'
,p_static_id=>'start-permit'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_from_dt DATE;',
'    v_to_dt   DATE;',
'    v_now     DATE := SYSDATE;',
'BEGIN',
'    IF :P9_START_MODE = ''IMMEDIATE'' THEN',
'        v_from_dt := v_now;',
'        v_to_dt   := v_now + 12/24;',
'    ELSE',
'        v_from_dt := TO_DATE(:P9_START_DATE, ''DD-MON-YYYY HH24:MI'');',
'        v_to_dt   := TO_DATE(:P9_END_DATE,   ''DD-MON-YYYY HH24:MI'');',
'    END IF;',
'',
'    UPDATE ptw_pro.ptw_lv_permits',
'    SET    workflow_status    = ''STARTED'',',
'           current_step       = ''LIVE'',',
'           started_datetime   = v_from_dt,',
'           ended_datetime     = v_to_dt,',
'           dra_required       = :P9_DRA_REQUIRED,',
'           started_latitude   = TO_NUMBER(:APP_LATITUDE),',
'           started_longitude  = TO_NUMBER(:APP_LONGITUDE),',
'           modified_by        = V(''APP_USER''),',
'           modified_date      = v_now',
'    WHERE  permit_id = :P9_PERMIT_ID',
'    AND    workflow_status = ''AUTHORISED'';',
'',
'    IF SQL%ROWCOUNT = 0 THEN',
'        RAISE_APPLICATION_ERROR(-20001, ''Permit is not authorised or has already been started.'');',
'    END IF;',
'',
'    IF :P9_DRA_REQUIRED = ''Y'' THEN',
'        ptw_pro.ptw_dra_pkg.link_to_permit(:P9_DRA_ID, :P9_PERMIT_ID);',
'    END IF;',
' ',
'    COMMIT;',
'    :P9_WORKFLOW_STATUS := ''STARTED'';',
'    apex_application.g_print_success_message := ''Permit started successfully.'';',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_error.add_error(',
'            p_message          => ''Error starting permit: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'START_PERMIT'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_internal_uid=>37957981155176040
,p_created_on=>wwv_flow_imp.dz('20260331184006Z')
,p_updated_on=>wwv_flow_imp.dz('20261010193558Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
