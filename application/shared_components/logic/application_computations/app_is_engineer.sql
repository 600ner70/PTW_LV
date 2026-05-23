prompt --application/shared_components/logic/application_computations/app_is_engineer
begin
--   Manifest
--     APPLICATION COMPUTATION: APP_IS_ENGINEER
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.16'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_shared.create_flow_computation(
 p_id=>wwv_flow_imp.id(46108373139319593)
,p_computation_sequence=>10
,p_computation_item=>'APP_IS_ENGINEER'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_count NUMBER;',
'BEGIN',
'    SELECT COUNT(*) INTO v_count',
'    FROM   ptw_pro.ptw_lv_user_roles_v',
'    WHERE  UPPER(username) = UPPER(V(''APP_USER''))',
'    AND    role_name       = ''ENGINEER''',
'    AND    is_active       = ''Y'';',
'    RETURN CASE WHEN v_count > 0 THEN ''Y'' ELSE ''N'' END;',
'END;'))
,p_version_scn=>46857048030146
);
wwv_flow_imp.component_end;
end;
/
