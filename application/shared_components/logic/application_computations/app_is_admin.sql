prompt --application/shared_components/logic/application_computations/app_is_admin
begin
--   Manifest
--     APPLICATION COMPUTATION: APP_IS_ADMIN
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.17'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_shared.create_flow_computation(
 p_id=>wwv_flow_imp.id(46109066903404734)
,p_computation_sequence=>10
,p_computation_item=>'APP_IS_ADMIN'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_ptw_admin  NUMBER;',
'    v_ws_admin   VARCHAR2(3);',
'BEGIN',
'    -- Check PTW assigned admin roles',
'    SELECT COUNT(*)',
'    INTO   v_ptw_admin',
'    FROM   ptw_pro.ptw_lv_user_roles_v',
'    WHERE  UPPER(username) = UPPER(V(''APP_USER''))',
'    AND    role_name IN (''ADMIN'', ''ADMIN_CONTRACT_SUPPORT'')',
'    AND    is_active = ''Y'';',
'',
'    -- Check workspace administrator (same pattern as Page 8)',
'    BEGIN',
'        SELECT is_admin',
'        INTO   v_ws_admin',
'        FROM   apex_workspace_apex_users',
'        WHERE  UPPER(user_name)  = UPPER(V(''APP_USER''))',
'        AND    workspace_name    = (',
'                   SELECT workspace FROM apex_applications',
'                   WHERE  application_id = :APP_ID',
'               );',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN v_ws_admin := ''No'';',
'    END;',
'',
'    RETURN CASE',
'               WHEN v_ptw_admin > 0 OR v_ws_admin = ''Yes''',
'               THEN ''Y''',
'               ELSE ''N''',
'           END;',
'EXCEPTION',
'    WHEN OTHERS THEN RETURN ''N'';',
'END;'))
,p_version_scn=>46857048022620
);
wwv_flow_imp.component_end;
end;
/
