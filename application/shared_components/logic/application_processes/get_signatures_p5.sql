prompt --application/shared_components/logic/application_processes/get_signatures_p5
begin
--   Manifest
--     APPLICATION PROCESS: GET_SIGNATURES_P5
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.15'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_shared.create_flow_process(
 p_id=>wwv_flow_imp.id(38142264028353790)
,p_process_sequence=>1
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_SIGNATURES_P5'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_auth_blob   BLOB;',
'    v_accept_blob BLOB;',
'    v_auth_b64    CLOB;',
'    v_accept_b64  CLOB;',
'BEGIN',
'    SELECT auth_person_signature,',
'           accept_person_signature',
'    INTO   v_auth_blob,',
'           v_accept_blob',
'    FROM   ptw_pro.ptw_lv_permits',
'    WHERE  permit_id = :P5_PERMIT_ID;',
'',
'    IF v_auth_blob IS NOT NULL AND DBMS_LOB.GETLENGTH(v_auth_blob) > 0 THEN',
'        v_auth_b64 := apex_web_service.blob2clobbase64(v_auth_blob);',
'    END IF;',
'',
'    IF v_accept_blob IS NOT NULL AND DBMS_LOB.GETLENGTH(v_accept_blob) > 0 THEN',
'        v_accept_b64 := apex_web_service.blob2clobbase64(v_accept_blob);',
'    END IF;',
'',
'    apex_json.open_object;',
'    apex_json.write(''authSig'',   v_auth_b64);',
'    apex_json.write(''acceptSig'', v_accept_b64);',
'    apex_json.close_object;',
'',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        apex_json.open_object;',
'        apex_json.write(''authSig'',   '''');',
'        apex_json.write(''acceptSig'', '''');',
'        apex_json.close_object;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_security_scheme=>'MUST_NOT_BE_PUBLIC_USER'
,p_version_scn=>46572808513163
);
wwv_flow_imp.component_end;
end;
/
