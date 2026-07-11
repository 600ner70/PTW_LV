prompt --application/shared_components/automations/change_workflow_status
begin
--   Manifest
--     AUTOMATION: Change workflow status
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.17'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_shared.create_automation(
 p_id=>wwv_flow_imp.id(41992816828541910)
,p_name=>'Change workflow status'
,p_static_id=>'change-workflow-status'
,p_trigger_type=>'POLLING'
,p_polling_interval=>'FREQ=MINUTELY;INTERVAL=15;BYHOUR=8,9,10,11,12,13,14,15,16,17,18,19'
,p_polling_status=>'ACTIVE'
,p_result_type=>'ALWAYS'
,p_location=>'LOCAL'
,p_use_local_sync_table=>false
,p_include_rowid_column=>false
,p_commit_each_row=>false
,p_error_handling_type=>'ABORT'
);
wwv_flow_imp_shared.create_automation_action(
 p_id=>wwv_flow_imp.id(41993103023541885)
,p_automation_id=>wwv_flow_imp.id(41992816828541910)
,p_name=>'Workflow clean up'
,p_execution_sequence=>10
,p_action_type=>'NATIVE_PLSQL'
,p_action_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_permit_id ptw_pro.ptw_lv_permits.permit_id%TYPE;',
'begin',
'  ptw_pro.ptw_sec_pkg.set_system_context;    -- ADDED: bypass VPD for this trusted housekeeping job',
'',
'  FOR rec_permits IN (SELECT permit_id',
'                      FROM   ptw_pro.ptw_lv_permits',
'                      WHERE  workflow_status = ''STARTED''',
'                      AND    ended_datetime < SYSDATE) LOOP',
'    UPDATE ptw_pro.ptw_lv_permits',
'    SET    workflow_status = ''LAPSED''',
'    WHERE  permit_id = rec_permits.permit_id;',
'  END LOOP;',
'  COMMIT;',
'end;'))
,p_action_clob_language=>'PLSQL'
,p_location=>'LOCAL'
,p_error_message=>'Error with permit clear-up job. Please contact support.'
,p_stop_execution_on_error=>true
);
wwv_flow_imp.component_end;
end;
/
