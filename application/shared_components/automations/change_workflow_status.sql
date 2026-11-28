prompt --application/shared_components/automations/change_workflow_status
begin
--   Manifest
--     AUTOMATION: Change workflow status
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.6'
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
,p_commit_each_row=>false
,p_error_handling_type=>'ABORT'
,p_created_on=>wwv_flow_imp.dz('20260421214017Z')
,p_updated_on=>wwv_flow_imp.dz('20260719143826Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_shared.create_automation_action(
 p_id=>wwv_flow_imp.id(41993103023541885)
,p_automation_id=>wwv_flow_imp.id(41992816828541910)
,p_name=>'Workflow clean up'
,p_static_id=>'workflow-clean-up'
,p_execution_sequence=>10
,p_action_type=>'NATIVE_PLSQL'
,p_action_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'BEGIN',
'  apex_session.create_session(',
'    p_app_id   => 105,',
'    p_page_id  => 0,',
'    p_username => ''SYSTEM_AUTOMATION''',
'  );',
'',
'  UPDATE ptw_pro.ptw_lv_permits',
'  SET    workflow_status = ''LAPSED''',
'  WHERE  workflow_status = ''STARTED''',
'  AND    ended_datetime < SYSDATE;',
'',
'  COMMIT;',
'END;'))
,p_action_clob_language=>'PLSQL'
,p_location=>'LOCAL'
,p_error_message=>'Error with permit clear-up job. Please contact support.'
,p_stop_execution_on_error=>true
,p_created_on=>wwv_flow_imp.dz('20260421214017Z')
,p_updated_on=>wwv_flow_imp.dz('20260719143820Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
