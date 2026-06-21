prompt --application/pages/page_00020
begin
--   Manifest
--     PAGE: 00020
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.17'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_page.create_page(
 p_id=>20
,p_name=>'Photo Download'
,p_alias=>'PHOTO-DOWNLOAD'
,p_step_title=>'Photo Download'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40755195550498301)
,p_name=>'P20_PHOTO_ID'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40755372545498303)
,p_name=>'P20_PERMIT_ID'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(40755250521498302)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Stream Photo'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_blob      BLOB;',
'    l_mime_type VARCHAR2(100);',
'    l_file_name VARCHAR2(255);',
'BEGIN',
'    SELECT photo_data, mime_type, file_name',
'    INTO   l_blob, l_mime_type, l_file_name',
'    FROM   ptw_pro.ptw_lv_permit_photos',
'    WHERE  photo_id = TO_NUMBER(:P20_PHOTO_ID);',
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
,p_process_when=>'P20_PHOTO_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>40755250521498302
);
wwv_flow_imp.component_end;
end;
/
