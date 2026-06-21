prompt --workspace/credentials/app_105_push_notifications_credentials
begin
--   Manifest
--     CREDENTIAL: App 105 Push Notifications Credentials
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.17'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_imp_workspace.create_credential(
 p_id=>wwv_flow_imp.id(30175822546549151)
,p_name=>'App 105 Push Notifications Credentials'
,p_static_id=>'App_105_Push_Notifications_Credentials'
,p_authentication_type=>'KEY_PAIR'
,p_prompt_on_install=>false
);
wwv_flow_imp.component_end;
end;
/
