prompt --application/shared_components/automations/fire_watch_milestone_reminder
begin
--   Manifest
--     AUTOMATION: Fire Watch Milestone Reminder
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
 p_id=>wwv_flow_imp.id(43192685772591179)
,p_name=>'Fire Watch Milestone Reminder'
,p_static_id=>'fire-watch-milestone-reminder'
,p_trigger_type=>'POLLING'
,p_polling_interval=>'FREQ=MINUTELY;INTERVAL=5'
,p_polling_status=>'ACTIVE'
,p_result_type=>'ALWAYS'
,p_location=>'LOCAL'
,p_error_handling_type=>'ABORT'
,p_created_on=>wwv_flow_imp.dz('20260915210622Z')
,p_updated_on=>wwv_flow_imp.dz('20260915210756Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_shared.create_automation_action(
 p_id=>wwv_flow_imp.id(43193052900591187)
,p_automation_id=>wwv_flow_imp.id(43192685772591179)
,p_name=>'Send fire watch milestone push notifications'
,p_static_id=>'new-action'
,p_execution_sequence=>10
,p_action_type=>'NATIVE_PLSQL'
,p_action_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'                -- Anchor = HW_COMPLETE.signed_datetime (when the hot work itself',
'                -- stopped and the fire watch clock started). Only ever notifies',
'                -- the single NEXT unsigned milestone per permit - matches the',
'                -- sequential sign-off rule already enforced on Page 18.',
'                DECLARE',
'                    CURSOR c_permits IS',
'                        SELECT p.permit_id,',
'                               p.permit_number,',
'                               p.created_by,',
'                               fw.signed_datetime AS hw_complete_dt',
'                        FROM   ptw_pro.ptw_lv_permits p',
'                        JOIN   ptw_pro.ptw_hotwork_fire_watch fw',
'                               ON fw.permit_id      = p.permit_id',
'                               AND fw.milestone_code = ''HW_COMPLETE''',
'                        WHERE  p.workflow_status = ''STARTED''',
'                        AND    p.ptw_type        = ''HOT WORK'';',
'',
'                    TYPE t_milestone IS RECORD (',
'                        code        VARCHAR2(30),',
'                        offset_mins NUMBER,',
'                        label       VARCHAR2(100)',
'                    );',
'                    TYPE t_milestones IS TABLE OF t_milestone;',
'',
'                    -- Offsets are minutes from HW_COMPLETE. CHECK_15MIN/30MIN',
'                    -- milestones are single end-of-hour attestations in the',
'                    -- current data model, not per-15/30-min log entries.',
'                    l_milestones t_milestones := t_milestones(',
'                        t_milestone(''ATTEND_1ST_HR'',        60,  ''Attend First Hour''),',
'                        t_milestone(''CHECK_15MIN_2ND_HR'',   120, ''Check Every 15 Min - Second Hour''),',
'                        t_milestone(''CHECK_30MIN_3RD_HR'',   180, ''Check Every 30 Min - Third Hour''),',
'                        t_milestone(''REINSTATE_4TH_HR'',     240, ''Reinstate Fire Isolation - Fourth Hour''),',
'                        t_milestone(''FIRE_CHECKS_COMPLETE'', 240, ''Completion of Fire Checks'')',
'                    );',
'',
'                    l_signed_count NUMBER;',
'                    l_sent_count   NUMBER;',
'                    l_due_at       DATE;',
'                BEGIN',
'                    apex_session.create_session(',
'                        p_app_id   => 105,',
'                        p_page_id  => 0,',
'                        p_username => ''SYSTEM_AUTOMATION''',
'                    );',
'',
'                    FOR r IN c_permits LOOP',
'                        FOR i IN 1 .. l_milestones.COUNT LOOP',
'',
'                            SELECT COUNT(*) INTO l_signed_count',
'                            FROM   ptw_pro.ptw_hotwork_fire_watch',
'                            WHERE  permit_id      = r.permit_id',
'                            AND    milestone_code = l_milestones(i).code;',
'',
'                            IF l_signed_count = 0 THEN',
'                                l_due_at := r.hw_complete_dt + (l_milestones(i).offset_mins / 1440);',
'',
'                                IF SYSDATE >= l_due_at THEN',
'                                    SELECT COUNT(*) INTO l_sent_count',
'                                    FROM   ptw_pro.ptw_push_notification_log',
'                                    WHERE  permit_id        = r.permit_id',
'                                    AND    notification_key = ''FIREWATCH_'' || l_milestones(i).code;',
'',
'                                    IF l_sent_count = 0 THEN',
'                                        BEGIN',
'                                            apex_pwa.send_push_notification(',
'                                                p_application_id => 105,',
'                                                p_user_name      => r.created_by,',
'                                                p_title          => ''Fire Watch Check Due'',',
'                                                p_body           => ''Permit '' || r.permit_number || '': "'' ||',
'                                                                     l_milestones(i).label || ''" needs signing.'',',
'                                                p_target_url     => apex_page.get_url(',
'                                                                       p_page        => 18,',
'                                                                       p_items       => ''P18_PERMIT_ID,P18_PTW_TYPE,P18_PERMIT_NUMBER,P18_WORKFLOW_STATUS'',',
'                                                                       p_values      => r.permit_id || '',HOT WORK,'' || r.permit_number || '',STARTED'',',
'                                                                       p_clear_cache => 18',
'                                                                     )',
'                                            );',
'',
'                                            INSERT INTO ptw_pro.ptw_push_notification_log',
'                                                (permit_id, notification_key, sent_to_username)',
'                                            VALUES',
'                                                (r.permit_id, ''FIREWATCH_'' || l_milestones(i).code, r.created_by);',
'                                        EXCEPTION',
'                                            WHEN OTHERS THEN',
'                                                apex_automation.log_error(',
'                                                    ''Fire watch push failed for permit '' || r.permit_number ||',
'                                                    '' / '' || l_milestones(i).code || '': '' || SQLERRM',
'                                                );',
'                                        END;',
'                                    END IF;',
'                                END IF;',
'',
'                                EXIT; -- stop at the first unsigned milestone for this permit',
'                            END IF;',
'',
'                        END LOOP;',
'                    END LOOP;',
'',
'                    COMMIT;',
'                END;'))
,p_action_clob_language=>'PLSQL'
,p_location=>'LOCAL'
,p_error_message=>'Error sending fire watch push notifications. Please contact support.'
,p_stop_execution_on_error=>true
,p_created_on=>wwv_flow_imp.dz('20260915210622Z')
,p_updated_on=>wwv_flow_imp.dz('20260915210743Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
