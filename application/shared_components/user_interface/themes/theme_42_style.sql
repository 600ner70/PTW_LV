prompt --application/shared_components/user_interface/themes/theme_42_style
begin
--   Manifest
--     THEME STYLE: 42
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.6'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_shared.create_theme_style(
 p_id=>wwv_flow_imp.id(26968357419599433)
,p_theme_id=>42
,p_name=>'Vita - Slate (copy_1)'
,p_static_id=>'vita-slate-copy'
,p_is_public=>true
,p_is_accessible=>false
,p_theme_roller_input_file_urls=>'#THEME_FILES#less/theme/Vita-Slate.less'
,p_theme_roller_config=>'{"classes":[],"vars":{"@g_Accent-OG":"#a19898"},"customCSS":"","useCustomLess":"N"}'
,p_theme_roller_output_file_url=>'#THEME_DB_FILES#26968357419599433.css'
,p_theme_roller_read_only=>false
,p_created_on=>wwv_flow_imp.dz('20260210191734Z')
,p_updated_on=>wwv_flow_imp.dz('20260210191734Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
