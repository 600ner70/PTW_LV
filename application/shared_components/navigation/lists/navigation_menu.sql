prompt --application/shared_components/navigation/lists/navigation_menu
begin
--   Manifest
--     LIST: Navigation Menu
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.17'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(26415021693144587)
,p_name=>'Navigation Menu'
,p_list_status=>'PUBLIC'
,p_version_scn=>47254851861180
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(26426875280144645)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Home'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:2,3,4,5,6,7:::'
,p_list_item_icon=>'fa-home'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(26755508969320362)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Site & Work Details'
,p_list_item_link_target=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:::'
,p_list_item_icon=>'fa-file-o'
,p_security_scheme=>wwv_flow_imp.id(26419849891144614)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'2'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(26974860499788106)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Control Measures & PPE'
,p_list_item_link_target=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:3:::'
,p_list_item_icon=>'fa-file-o'
,p_security_scheme=>wwv_flow_imp.id(26419849891144614)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'3'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(27024968468033618)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Equipment Isolation'
,p_list_item_link_target=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:4:::'
,p_list_item_icon=>'fa-file-o'
,p_security_scheme=>wwv_flow_imp.id(26419849891144614)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'4'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(27361031445194435)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>'Authorisation & Acceptance'
,p_list_item_link_target=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5:::'
,p_list_item_icon=>'fa-file-o'
,p_security_scheme=>wwv_flow_imp.id(26419849891144614)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'5'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(31589599630638717)
,p_list_item_display_sequence=>60
,p_list_item_link_text=>'Admin'
,p_list_item_icon=>'fa-wrench'
,p_security_scheme=>wwv_flow_imp.id(26419849891144614)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(31590083559628236)
,p_list_item_display_sequence=>70
,p_list_item_link_text=>'User Maintenance'
,p_list_item_link_target=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:8:::'
,p_list_item_icon=>'fa-user-wrench'
,p_parent_list_item_id=>wwv_flow_imp.id(31589599630638717)
,p_security_scheme=>wwv_flow_imp.id(26419849891144614)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(52472331257340516)
,p_list_item_display_sequence=>141
,p_list_item_link_text=>'Permit Types'
,p_list_item_link_target=>'f?p=&APP_ID.:23:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-keyboard-o'
,p_parent_list_item_id=>wwv_flow_imp.id(31589599630638717)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'23'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(49781486325693551)
,p_list_item_display_sequence=>90
,p_list_item_link_text=>'Reports'
,p_list_item_icon=>'fa-table-search'
,p_security_scheme=>wwv_flow_imp.id(26419849891144614)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(49754023365978431)
,p_list_item_display_sequence=>91
,p_list_item_link_text=>'Permit Search'
,p_list_item_link_target=>'f?p=&APP_ID.:50:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-area-chart'
,p_parent_list_item_id=>wwv_flow_imp.id(49781486325693551)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'50'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(50549056600996657)
,p_list_item_display_sequence=>101
,p_list_item_link_text=>'Permit Analytics'
,p_list_item_link_target=>'f?p=&APP_ID.:51:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-pie-chart'
,p_parent_list_item_id=>wwv_flow_imp.id(49781486325693551)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'51'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(52452098132289180)
,p_list_item_display_sequence=>121
,p_list_item_link_text=>'Super User Admin'
,p_list_item_icon=>'fa-gear'
,p_security_scheme=>wwv_flow_imp.id(52412848522131878)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(52413161183145953)
,p_list_item_display_sequence=>111
,p_list_item_link_text=>'Companies'
,p_list_item_link_target=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-industry'
,p_parent_list_item_id=>wwv_flow_imp.id(52452098132289180)
,p_security_scheme=>wwv_flow_imp.id(52412848522131878)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'21'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(52453203231436871)
,p_list_item_display_sequence=>131
,p_list_item_link_text=>'Master Permit Types'
,p_list_item_link_target=>'f?p=&APP_ID.:22:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-keyboard-o'
,p_parent_list_item_id=>wwv_flow_imp.id(52452098132289180)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'22'
);
wwv_flow_imp.component_end;
end;
/
