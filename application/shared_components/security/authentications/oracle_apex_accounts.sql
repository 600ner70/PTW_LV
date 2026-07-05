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
'    -- Deny login for deactivated users. Deliberately NOT wrapped to',
'    -- swallow errors - a security gate should fail closed, not open,',
'    -- unlike the cleanup block below which intentionally never blocks',
'    -- login over an unrelated cosmetic failure.',
'    DECLARE',
'        l_is_active VARCHAR2(1);',
'    BEGIN',
'        SELECT is_active',
'        INTO   l_is_active',
'        FROM   ptw_pro.ptw_lv_users',
'        WHERE  UPPER(username) = UPPER(:APP_USER);',
'',
'        IF l_is_active = ''N'' THEN',
'            RAISE_APPLICATION_ERROR(-20001,',
'                ''This account has been deactivated. Contact your administrator.'');',
'        END IF;',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN',
'            RAISE_APPLICATION_ERROR(-20002,',
'                ''No user profile found for this account. Contact your administrator.'');',
'    END;',
'',
'    -- Existing cleanup (unchanged) - stray company_id for super users',
'    BEGIN',
'        UPDATE ptw_pro.ptw_lv_users',
'        SET    company_id = NULL',
'        WHERE  UPPER(username) = UPPER(:APP_USER)',
'        AND    is_super_user = ''Y''',
'        AND    company_id IS NOT NULL;',
'',
'        COMMIT;',
'    EXCEPTION',
'        WHEN OTHERS THEN',
'            NULL;',
'    END;',
'END;'))
,p_invalid_session_type=>'LOGIN'
,p_use_secure_cookie_yn=>'N'
,p_ras_mode=>0
,p_version_scn=>49905620414658
);
wwv_flow_imp.component_end;
end;
/
