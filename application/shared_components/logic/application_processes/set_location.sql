prompt --application/shared_components/logic/application_processes/set_location
begin
--   Manifest
--     APPLICATION PROCESS: SET_LOCATION
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.6'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_shared.create_flow_process(
 p_id=>wwv_flow_imp.id(34542191130624074)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_name=>'SET_LOCATION'
,p_static_id=>'set-location'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    :APP_LATITUDE  := apex_application.g_x01;',
'    :APP_LONGITUDE := apex_application.g_x02;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_security_scheme=>'MUST_NOT_BE_PUBLIC_USER'
,p_version_scn=>'46527949500970'
,p_created_on=>wwv_flow_imp.dz('20260318194635Z')
,p_updated_on=>wwv_flow_imp.dz('20260318194635Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
