prompt --application/shared_components/security/authorizations/reader_rights
begin
--   Manifest
--     SECURITY SCHEME: Reader Rights
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.14'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PERMITPRO'
);
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(30177956100539874)
,p_name=>'Reader Rights'
,p_scheme_type=>'NATIVE_FUNCTION_BODY'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_count NUMBER;',
'BEGIN',
'    -- Allow if user has any active PTW role',
'    SELECT COUNT(*) INTO v_count',
'    FROM ptw_pro.ptw_lv_user_roles',
'    WHERE UPPER(username) = UPPER(:APP_USER)',
'      AND is_active = ''Y'';',
'    RETURN v_count > 0;',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        RETURN FALSE;',
'END;'))
,p_error_message=>'You are not authorized to view this application, either because you have not been granted access, or your account has been locked. Please contact the application administrator.'
,p_version_scn=>46409261088274
,p_caching=>'BY_USER_BY_SESSION'
);
wwv_flow_imp.component_end;
end;
/
