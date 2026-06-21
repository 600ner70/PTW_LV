prompt --application/pages/page_00007
begin
--   Manifest
--     PAGE: 00007
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
 p_id=>7
,p_name=>'Location'
,p_alias=>'LOCATION'
,p_page_mode=>'MODAL'
,p_step_title=>'Location'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'setTimeout(function() {',
'    var mapCanvas = document.querySelector(''.ol-viewport'');',
'    console.log(''Map canvas:'', mapCanvas);',
'    if (mapCanvas) {',
'        var allDivs = document.querySelectorAll(''div[id]'');',
'        allDivs.forEach(function(d) {',
'            console.log(''Div ID:'', d.id, ''Classes:'', d.className);',
'        });',
'    }',
'}, 5000);'))
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Wait for map to be fully initialised before manipulating it',
'$(document).on(''spatialmapinitialized'', function() {',
'',
'    var mapObj = apex.region(''history_map'').call(''getMapObject'');',
'    if (!mapObj) return;',
'',
'    // Fly to the pin location at 100m zoom',
'    // Coordinates must match what''s in your layer SQL',
'    var lat = &P7_LATITUDE.;',
'    var lng = &P7_LONGITUDE.;',
'',
'    mapObj.flyTo({',
'        center: [ lng, lat ],',
'        zoom:   18,',
'        speed:  2',
'    });',
'});'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.ui-dialog {',
'    border: 2px solid #000000 !important;',
'    border-radius: 4px !important;',
'}'))
,p_step_template=>2100407606326202693
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'17'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(58110169498870687)
,p_plug_name=>'Location'
,p_region_name=>'history_map'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>70
,p_location=>null
,p_lazy_loading=>true
,p_plug_source_type=>'NATIVE_MAP_REGION'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_map_region(
 p_id=>wwv_flow_imp.id(29752025641080897)
,p_region_id=>wwv_flow_imp.id(58110169498870687)
,p_height=>640
,p_tilelayer_type=>'CUSTOM'
,p_tilelayer_name_default=>'osm-bright'
,p_navigation_bar_type=>'FULL'
,p_navigation_bar_position=>'END'
,p_init_position_zoom_type=>'SQL'
,p_init_position_zoom_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT longitude,',
'       latitude,',
'       18 AS zoomlevel',
'FROM   (',
'    SELECT longitude,',
'           latitude,',
'           created_date,',
'           ROW_NUMBER() OVER (ORDER BY created_date DESC) AS rn',
'    FROM   ptw_pro.ptw_stage_locations',
'    WHERE  permit_id    = :P7_PERMIT_ID',
'    AND    permit_stage = :P7_CURRENT_STAGE',
')',
'WHERE rn = 1'))
,p_init_position_geometry_type=>'LONLAT_COLUMNS'
,p_init_position_lon_column=>'LONGITUDE'
,p_init_position_lat_column=>'LATITUDE'
,p_init_zoomlevel_column=>'ZOOMLEVEL'
,p_layer_messages_position=>'BELOW'
,p_show_legend=>false
,p_features=>'SCALE_BAR:INFINITE_MAP:RECTANGLE_ZOOM'
);
wwv_flow_imp_page.create_map_region_layer(
 p_id=>wwv_flow_imp.id(29752518329080894)
,p_map_region_id=>wwv_flow_imp.id(29752025641080897)
,p_name=>'Location'
,p_layer_type=>'POINT'
,p_display_sequence=>10
,p_location=>'LOCAL'
,p_query_type=>'SQL'
,p_layer_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PERMIT_ID,',
'       CASE PERMIT_STAGE',
'        WHEN ''SITE_WORK_DETAILS'' THEN ''Step 1: Site and Work Details''',
'        WHEN ''CONTROL_MEASURES''  THEN ''Step 2: Control Measures''',
'        WHEN ''EQUIP_ISOLATION''   THEN ''Step 3: Equipment Isolation''',
'        WHEN ''AUTHORISATION''     THEN ''Step 4: Authorisation''',
'        WHEN ''COMPLETED''         THEN ''Step 5: Live''',
'        WHEN ''MONITORING''        THEN ''Step 6: Monitoring''',
'        WHEN ''CLEARANCE''         THEN ''Step 7: Clearnace''',
'        WHEN ''CANCELLED''         THEN ''Cancelled''',
'       ELSE PERMIT_STAGE',
'       END as step_display,',
'       LATITUDE,',
'       LONGITUDE,',
'       CREATED_DATE,',
'       CREATED_BY,',
'       PERMIT_STAGE',
'from   (SELECT MAX(psl.CREATED_DATE) created_date,',
'               psl.LONGITUDE,',
'               psl.LATITUDE,',
'               psl.permit_id,',
'               psl.permit_stage,',
'               psl.created_by      ',
'        FROM   PTW_PRO.PTW_STAGE_LOCATIONS psl',
'        WHERE  psl.PERMIT_ID    = :P7_PERMIT_ID ',
'        AND    psl.PERMIT_STAGE = :P7_CURRENT_STAGE',
'        GROUP BY psl.permit_id,',
'                 psl.permit_stage,',
'                 psl.LONGITUDE,',
'                 psl.LATITUDE,',
'                 psl.created_by) map_data',
''))
,p_items_to_submit=>'P7_PERMIT_ID,P7_CURRENT_STAGE,P7_CREATED_DATE'
,p_has_spatial_index=>false
,p_geometry_column_data_type=>'LONLAT_COLUMNS'
,p_longitude_column=>'LONGITUDE'
,p_latitude_column=>'LATITUDE'
,p_fill_color=>'#182bfc'
,p_point_display_type=>'SVG'
,p_point_svg_shape=>'Pin Circle'
,p_point_svg_shape_scale=>'3'
,p_feature_clustering=>false
,p_tooltip_adv_formatting=>false
,p_info_window_adv_formatting=>false
,p_allow_hide=>true
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(33350643652951420)
,p_name=>'P7_CREATED_DATE'
,p_item_sequence=>60
,p_format_mask=>'DD-MON-YYYY HH24:MI'
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(41969669086328827)
,p_name=>'P7_LATITUDE'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(41969726013328828)
,p_name=>'P7_LONGITUDE'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(58097411888997905)
,p_name=>'P7_PERMIT_ID'
,p_item_sequence=>10
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(58097606026997906)
,p_name=>'P7_CURRENT_STAGE'
,p_item_sequence=>50
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(41969583459328826)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load defaults'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT latitude, longitude',
'INTO   :P7_LATITUDE, :P7_LONGITUDE',
'FROM   ptw_pro.ptw_stage_locations',
'WHERE  permit_id    = :P7_PERMIT_ID',
'AND    permit_stage = :P7_CURRENT_STAGE',
'ORDER  BY created_date DESC',
'FETCH  FIRST 1 ROW ONLY;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>41969583459328826
);
wwv_flow_imp.component_end;
end;
/
