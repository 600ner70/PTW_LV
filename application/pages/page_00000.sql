prompt --application/pages/page_00000
begin
--   Manifest
--     PAGE: 00000
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.14'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PERMITPRO'
);
wwv_flow_imp_page.create_page(
 p_id=>0
,p_name=>'Global Page'
,p_step_title=>'Global Page'
,p_autocomplete_on_off=>'OFF'
,p_javascript_file_urls=>'#APP_FILES#offline-nav#MIN#.js'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'D'
,p_page_component_map=>'14'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(25229985303353139)
,p_name=>'P0_LONGITUDE'
,p_item_sequence=>10
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(25230095990353140)
,p_name=>'P0_LATITUDE'
,p_item_sequence=>20
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(25230140327353141)
,p_name=>'Capture Lat & Long'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
,p_display_when_type=>'EXPRESSION'
,p_display_when_cond=>':APP_PAGE_ID = 1'
,p_display_when_cond2=>'PLSQL'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(25230243711353142)
,p_event_id=>wwv_flow_imp.id(25230140327353141)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P0_LONGITUDE,P0_LATITUDE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Get user''s current location using browser geolocation',
'if (navigator.geolocation) {',
'    navigator.geolocation.getCurrentPosition(',
'        function(position) {',
'            // Success - set the page items',
'            apex.item("P0_LATITUDE").setValue(position.coords.latitude);',
'            apex.item("P0_LONGITUDE").setValue(position.coords.longitude);',
'            ',
'            console.log("Location set: " + position.coords.latitude + ", " + position.coords.longitude);',
'        },',
'        function(error) {',
'            // Error handling',
'            console.error("Geolocation error: " + error.message);',
'            apex.message.showErrors([{',
'                type: "error",',
'                location: "page",',
'                message: "Unable to get location: " + error.message',
'            }]);',
'        },',
'        {',
'            enableHighAccuracy: true,',
'            timeout: 10000,',
'            maximumAge: 0',
'        }',
'    );',
'} else {',
'    apex.message.showErrors([{',
'        type: "error",',
'        location: "page",',
'        message: "Geolocation is not supported by this browser"',
'    }]);',
'}'))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(28347215850917045)
,p_event_id=>wwv_flow_imp.id(25230140327353141)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'NULL;'
,p_attribute_03=>'P0_LONGITUDE,P0_LATITUDE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp.component_end;
end;
/
