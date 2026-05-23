prompt --application/shared_components/user_interface/theme_style
begin
--   Manifest
--     THEME STYLE: 105
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.16'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_shared.create_theme_style(
 p_id=>wwv_flow_imp.id(26968357419599433)
,p_theme_id=>42
,p_name=>'Vita - Slate (copy_1)'
,p_is_public=>true
,p_is_accessible=>false
,p_theme_roller_input_file_urls=>'#THEME_FILES#less/theme/Vita-Slate.less'
,p_theme_roller_config=>'{"classes":[],"vars":{"@g_Accent-OG":"#a19898"},"customCSS":"","useCustomLess":"N"}'
,p_theme_roller_output_file_url=>'#THEME_DB_FILES#26968357419599433.css'
,p_theme_roller_read_only=>false
);
wwv_flow_imp_shared.create_theme_style(
 p_id=>wwv_flow_imp.id(50885304458215946)
,p_theme_id=>101
,p_name=>'Vita - Slate (copy_1)'
,p_is_public=>true
,p_is_accessible=>false
,p_theme_roller_input_file_urls=>'#THEME_FILES#less/theme/Vita-Slate.less'
,p_theme_roller_config=>'{"classes":[],"vars":{"@g_Accent-OG":"#a19898","@g_Focus":"#37628a","@g_Nav_Style":"light","@g_Nav-BG":"#a19898","@g_Nav-FG":"#242424","@g_Nav-Active-BG":"#beb6b6","@g_Nav-Active-FG":"#000000"},"customCSS":"","useCustomLess":"N"}'
,p_theme_roller_output_file_url=>'#THEME_DB_FILES#24124499684701170.css'
,p_theme_roller_read_only=>false
);
wwv_flow_imp.component_end;
end;
/
