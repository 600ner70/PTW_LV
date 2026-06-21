prompt --application/shared_components/security/authentications/oracle_apex_accounts
begin
--   Manifest
--     AUTHENTICATION: Oracle APEX Accounts
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.17'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_shared.create_authentication(
 p_id=>wwv_flow_imp.id(26414203820144584)
,p_name=>'Oracle APEX Accounts'
,p_scheme_type=>'NATIVE_APEX_ACCOUNTS'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    UPDATE ptw_pro.ptw_lv_users',
'    SET    company_id = NULL',
'    WHERE  UPPER(username) = UPPER(:APP_USER)',
'    AND    is_super_user = ''Y''',
'    AND    company_id IS NOT NULL;',
'',
'    COMMIT;',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        -- Never block login over this cleanup - log and',
'        -- continue. (No dedicated log table exists yet; if',
'        -- one is added later for app-wide error logging,',
'        -- write to it here instead of silently swallowing.)',
'        NULL;',
'END;'))
,p_invalid_session_type=>'LOGIN'
,p_use_secure_cookie_yn=>'N'
,p_ras_mode=>0
,p_version_scn=>47330703342339
);
wwv_flow_imp.component_end;
end;
/
