prompt --application/pages/page_00010
begin
--   Manifest
--     PAGE: 00010
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.15'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_page.create_page(
 p_id=>10
,p_name=>'Global Page_bkup'
,p_alias=>'GLOBAL-PAGE-BKUP'
,p_step_title=>'Global Page_bkup'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'D'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(58176562884596293)
,p_name=>'P10_LONGITUDE'
,p_item_sequence=>10
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(58176673571596294)
,p_name=>'P10_LATITUDE'
,p_item_sequence=>20
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(32947227864243135)
,p_name=>'Capture Lat & Long'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
,p_display_when_type=>'EXPRESSION'
,p_display_when_cond=>':APP_PAGE_ID = 1'
,p_display_when_cond2=>'PLSQL'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32948172271243128)
,p_event_id=>wwv_flow_imp.id(32947227864243135)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_LONGITUDE,P10_LATITUDE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Get user''s current location using browser geolocation',
'if (navigator.geolocation) {',
'    navigator.geolocation.getCurrentPosition(',
'        function(position) {',
'            // Success - set the page items',
'            apex.item("P10_LATITUDE").setValue(position.coords.latitude);',
'            apex.item("P10_LONGITUDE").setValue(position.coords.longitude);',
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
 p_id=>wwv_flow_imp.id(32947706548243131)
,p_event_id=>wwv_flow_imp.id(32947227864243135)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'NULL;'
,p_attribute_03=>'P10_LONGITUDE,P10_LATITUDE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp.component_end;
end;
/
