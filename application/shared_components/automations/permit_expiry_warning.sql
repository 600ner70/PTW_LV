prompt --application/shared_components/automations/permit_expiry_warning
begin
--   Manifest
--     AUTOMATION: Permit Expiry Warning
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
 p_id=>wwv_flow_imp.id(43190341683550768)
,p_name=>'Permit Expiry Warning'
,p_static_id=>'permit-expiry-warning'
,p_trigger_type=>'POLLING'
,p_polling_interval=>'FREQ=MINUTELY;INTERVAL=15'
,p_polling_status=>'ACTIVE'
,p_result_type=>'ALWAYS'
,p_location=>'LOCAL'
,p_error_handling_type=>'ABORT'
,p_created_on=>wwv_flow_imp.dz('20260915205938Z')
,p_updated_on=>wwv_flow_imp.dz('20261010135153Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_shared.create_automation_action(
 p_id=>wwv_flow_imp.id(43190719016550788)
,p_automation_id=>wwv_flow_imp.id(43190341683550768)
,p_name=>'Send expiry warning push notifications'
,p_static_id=>'new-action'
,p_execution_sequence=>10
,p_action_type=>'NATIVE_PLSQL'
,p_action_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'                -- Window is a full hour wide, run every 15 min, so a permit',
'                -- entering the last-hour window is always caught on the next',
'                -- run even if it slips past the exact 60-minute mark.',
'                DECLARE',
'                    CURSOR c_expiring IS',
'                        SELECT p.permit_id,',
'                               p.permit_number,',
'                               p.created_by,',
'                               p.ended_datetime',
'                        FROM   ptw_pro.ptw_lv_permits p',
'                        WHERE  p.workflow_status = ''STARTED''',
'                        AND    p.ended_datetime BETWEEN SYSDATE AND SYSDATE + (1/24)',
'                        AND    NOT EXISTS (',
'                                 SELECT 1',
'                                 FROM   ptw_pro.ptw_push_notification_log l',
'                                 WHERE  l.permit_id        = p.permit_id',
'                                 AND    l.notification_key = ''EXPIRY_1HR''',
'                               );',
'                BEGIN',
'                    apex_session.create_session(',
'                        p_app_id   => 105,',
'                        p_page_id  => 0,',
'                        p_username => ''SYSTEM_AUTOMATION''',
'                    );',
'',
'                    FOR r IN c_expiring LOOP',
'                        BEGIN',
'                            apex_pwa.send_push_notification(',
'                                p_application_id => 105,',
'                                p_user_name      => r.created_by,',
'                                p_title          => ''Permit Expiring Soon'',',
'                                p_body           => ''Permit '' || r.permit_number || '' expires at '' ||',
'                                                       TO_CHAR(r.ended_datetime, ''DD-MON-YYYY HH24:MI'') ||',
'                                                       ''. Please clear it before then.''',
'                            );',
'',
'                            INSERT INTO ptw_pro.ptw_push_notification_log',
'                                (permit_id, notification_key, sent_to_username)',
'                            VALUES',
'                                (r.permit_id, ''EXPIRY_1HR'', r.created_by);',
'                        EXCEPTION',
'                            -- Per-row handling: one bad/unsubscribed user must not',
'                            -- stop the rest of the batch from being notified.',
'                            WHEN OTHERS THEN',
'                                apex_automation.log_error(',
'                                    ''Expiry push failed for permit '' || r.permit_number ||',
'                                    '': '' || SQLERRM',
'                                );',
'                        END;',
'                    END LOOP;',
'',
'                    COMMIT;',
'                END;'))
,p_action_clob_language=>'PLSQL'
,p_location=>'LOCAL'
,p_error_message=>'Error sending permit expiry push notifications. Please contact support.'
,p_stop_execution_on_error=>true
,p_created_on=>wwv_flow_imp.dz('20260915205938Z')
,p_updated_on=>wwv_flow_imp.dz('20261010135149Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
