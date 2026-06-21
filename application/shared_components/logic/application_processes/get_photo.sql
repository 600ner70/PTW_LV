prompt --application/shared_components/logic/application_processes/get_photo
begin
--   Manifest
--     APPLICATION PROCESS: GET_PHOTO
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.17'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_shared.create_flow_process(
 p_id=>wwv_flow_imp.id(40754350770548208)
,p_process_sequence=>1
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_PHOTO'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_blob      BLOB;',
'    l_mime_type VARCHAR2(100);',
'    l_file_name VARCHAR2(255);',
'BEGIN',
'    SELECT photo_data, mime_type, file_name',
'    INTO   l_blob, l_mime_type, l_file_name',
'    FROM   ptw_pro.ptw_lv_permit_photos',
'    WHERE  photo_id = TO_NUMBER(apex_application.g_x01);',
'',
'    owa_util.mime_header(NVL(l_mime_type, ''image/jpeg''), FALSE);',
'    htp.p(''Content-Length: '' || DBMS_LOB.GETLENGTH(l_blob));',
'    htp.p(''Content-Disposition: inline; filename="'' || NVL(l_file_name, ''photo.jpg'') || ''"'');',
'    htp.p(''Cache-Control: private, max-age=3600'');',
'    owa_util.http_header_close;',
'    wpg_docload.download_file(l_blob);',
'    apex_application.stop_apex_engine;',
'',
'EXCEPTION',
'    WHEN apex_application.e_stop_apex_engine THEN RAISE;',
'    WHEN NO_DATA_FOUND THEN apex_application.stop_apex_engine;',
'    WHEN OTHERS THEN apex_application.stop_apex_engine;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'APPLICATION_PROCESS=GET_PHOTO'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_version_scn=>46727925656725
);
wwv_flow_imp.component_end;
end;
/
