prompt --application/shared_components/automations/expire_authority_to_work
begin
--   Manifest
--     AUTOMATION: Expire Authority to Work
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
 p_id=>wwv_flow_imp.id(57339813340048855)
,p_name=>'Expire Authority to Work'
,p_static_id=>'expire-authority-to-work'
,p_trigger_type=>'POLLING'
,p_polling_interval=>'FREQ=MINUTELY;INTERVAL=20'
,p_polling_status=>'ACTIVE'
,p_result_type=>'ALWAYS'
,p_location=>'LOCAL'
,p_error_handling_type=>'ABORT'
,p_created_on=>wwv_flow_imp.dz('20261017162646Z')
,p_updated_on=>wwv_flow_imp.dz('20261103140309Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_shared.create_automation_action(
 p_id=>wwv_flow_imp.id(57340231123048875)
,p_automation_id=>wwv_flow_imp.id(57339813340048855)
,p_name=>'Expiration code'
,p_static_id=>'new-action'
,p_execution_sequence=>10
,p_action_type=>'NATIVE_PLSQL'
,p_action_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_expired   NUMBER;',
'    l_cancelled NUMBER;',
'BEGIN',
'    apex_session.create_session(',
'        p_app_id   => 105,',
'        p_page_id  => 0,',
'        p_username => ''SYSTEM_AUTOMATION'');',
'',
'    ptw_pro.ptw_atw_pkg.expire_atws(',
'        p_expired   => l_expired,',
'        p_cancelled => l_cancelled);',
'',
'    apex_automation.log_info(',
'        ''ATW expired: '' || l_expired || '', drafts cancelled: '' || l_cancelled);',
'',
'    apex_session.delete_session;',
'END;'))
,p_action_clob_language=>'PLSQL'
,p_location=>'LOCAL'
,p_stop_execution_on_error=>true
,p_created_on=>wwv_flow_imp.dz('20261017162647Z')
,p_updated_on=>wwv_flow_imp.dz('20261017162754Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
