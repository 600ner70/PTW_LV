prompt --application/pages/page_00021
begin
--   Manifest
--     PAGE: 00021
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
 p_id=>21
,p_name=>'Companies'
,p_alias=>'COMPANIES'
,p_step_title=>'Companies'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(function () {',
'    var BINARY_ITEMS = [''P21_IS_ACTIVE''];',
'',
'    var BADGES = [',
unistr('        { val: ''Y'', cls: ''binary-badge-yes'', label: ''\2713'' },'),
unistr('        { val: ''N'', cls: ''binary-badge-no'',  label: ''\2717'' }'),
'    ];',
'',
'    BINARY_ITEMS.forEach(function (itemName) {',
'        var $fc = $(''#'' + itemName).closest(''.t-Form-fieldContainer'');',
'        if ($fc.length === 0) return;',
'',
'        $fc.find(''.binary-badge-row'').remove();',
'',
'        var currentVal = $(''input[name="'' + itemName + ''"]:checked'').val() || '''';',
'',
'        var $row = $(''<div class="binary-badge-row"></div>'').attr(''data-item'', itemName);',
'',
'        BADGES.forEach(function (b) {',
'            $(''<span></span>'')',
'                .addClass(''binary-badge '' + b.cls)',
'                .toggleClass(''cm-active'', currentVal === b.val)',
'                .attr(''data-value'', b.val)',
'                .text(b.label)',
'                .appendTo($row);',
'        });',
'',
'        $fc.find(''.t-Form-inputContainer'').append($row);',
'    });',
'',
'    $(''.cm-binary-item .apex-item-grid'').hide();',
'',
'    $(document).off(''click.binarybadge21'').on(''click.binarybadge21'', ''.binary-badge:not(.binary-readonly)'', function () {',
'        var $badge   = $(this);',
'        var $row     = $badge.closest(''.binary-badge-row'');',
'        var itemName = $row.attr(''data-item'');',
'        var val      = $badge.attr(''data-value'');',
'',
'        $(''input[name="'' + itemName + ''"][value="'' + val + ''"]'')',
'            .prop(''checked'', true).trigger(''change'');',
'',
'        $row.find(''.binary-badge'').removeClass(''cm-active'');',
'        $badge.addClass(''cm-active'');',
'    });',
'}());'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.admin-page-header {',
'    background: linear-gradient(135deg, #003366 0%, #005599 100%);',
'    color: white;',
'    padding: 25px 30px;',
'    border-radius: 8px;',
'    margin-bottom: 25px;',
'}',
'.admin-page-header h1 { margin: 0 0 5px 0; font-size: 1.75rem; font-weight: 700; }',
'.admin-page-header p  { margin: 0; opacity: 0.85; font-size: 0.95rem; }'))
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(52412848522131878)
,p_protection_level=>'C'
,p_page_component_map=>'25'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(50565856142122741)
,p_plug_name=>'Page Header'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>50
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_is_admin  VARCHAR2(1) := ''N'';',
'    l_html      CLOB;',
'BEGIN',
'    BEGIN',
'        SELECT CASE is_admin WHEN ''Yes'' THEN ''Y'' ELSE ''N'' END',
'        INTO   l_is_admin',
'        FROM   apex_workspace_apex_users',
'        WHERE  UPPER(user_name)  = UPPER(V(''APP_USER''))',
'        AND    workspace_name    = (',
'                   SELECT workspace FROM apex_applications',
'                   WHERE  application_id = :APP_ID',
'               );',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN l_is_admin := ''N'';',
'    END;',
'',
'    l_html := ''<div class="admin-page-header">''',
'           || ''  <div style="display:flex; justify-content:space-between; align-items:center;">''',
'           || ''    <div>''',
'           || ''      <h1>Companies</h1>''',
'           || ''      <p>Manage companies using this application. Each user belongs to ''',
'           || ''         one company, or is a Super User with access to all companies.</p>''',
'           || ''    </div>'';',
'',
'    IF l_is_admin = ''Y'' THEN',
'        l_html := l_html',
'               || ''<div style="flex-shrink:0; margin-left:20px;">''',
'               || ''  <span style="background:#dc3545; color:white;''',
'               || ''             display:inline-flex; align-items:center;''',
'               || ''             padding:6px 16px; border-radius:20px;''',
'               || ''             font-size:0.78rem; font-weight:700;''',
'               || ''             letter-spacing:0.5px; text-transform:uppercase;''',
'               || ''             box-shadow:0 2px 4px rgba(0,0,0,0.3);''',
'               || ''             white-space:nowrap;">''',
'               || ''  <span class="fa fa-shield" style="margin-right:8px; font-size:0.9rem;"></span>''',
'               || ''  Workspace Administrator''',
'               || ''</span>''',
'               || ''</div>'';',
'    END IF;',
'',
'    l_html := l_html',
'           || ''  </div>''',
'           || ''</div>'';',
'',
'    RETURN l_html;',
'END;'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(50565961300122742)
,p_plug_name=>'Companies'
,p_title=>'Companies'
,p_icon_css_classes=>'fa-building'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>70
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT c.company_id,',
'       c.company_name,',
'       c.company_code,',
'       CASE c.is_active WHEN ''Y'' THEN ''Active'' ELSE ''Inactive'' END AS status,',
'       c.is_active,',
'       TO_CHAR(c.created_date, ''DD-MON-YYYY HH24:MI'') AS created_date,',
'       created_by,',
'       TO_CHAR(c.modified_date, ''DD-MON-YYYY HH24:MI'') AS modified_date,',
'       modified_by,',
'       (SELECT COUNT(*) FROM ptw_pro.ptw_lv_users u',
'         WHERE u.company_id = c.company_id)   AS user_count,',
'       (SELECT COUNT(*) FROM ptw_pro.ptw_lv_permits p',
'         WHERE p.company_id = c.company_id)   AS permit_count',
'FROM   ptw_pro.ptw_lv_companies c',
'ORDER  BY c.company_name'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Companies'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(50566022873122743)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'PTW_PRO'
,p_internal_uid=>50566022873122743
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(50566130078122744)
,p_db_column_name=>'COMPANY_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'&nbsp.'
,p_column_link=>'f?p=&APP_ID.:24:&SESSION.::&DEBUG.:21:P24_COMPANY_ID:#COMPANY_ID#'
,p_column_linktext=>'<span class="fa fa-edit" title="Edit"></span>'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(50566296045122745)
,p_db_column_name=>'COMPANY_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Company Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(50566394348122746)
,p_db_column_name=>'COMPANY_CODE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Company Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(50566406422122747)
,p_db_column_name=>'STATUS'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(50566552114122748)
,p_db_column_name=>'IS_ACTIVE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Is Active'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(50566679465122749)
,p_db_column_name=>'CREATED_DATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Created Date'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(50566708303122750)
,p_db_column_name=>'USER_COUNT'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'User Count'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(52413753494182101)
,p_db_column_name=>'PERMIT_COUNT'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Permit Count'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(52416837009182132)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(52417094992182134)
,p_db_column_name=>'MODIFIED_BY'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Modified By'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(52417295055182136)
,p_db_column_name=>'MODIFIED_DATE'
,p_display_order=>120
,p_column_identifier=>'M'
,p_column_label=>'Modified Date'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(52427205848351061)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'524273'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'COMPANY_ID:COMPANY_NAME:COMPANY_CODE:STATUS:CREATED_DATE:CREATED_BY:MODIFIED_DATE:MODIFIED_BY:USER_COUNT:PERMIT_COUNT:'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(52415135982182115)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(50565961300122742)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add New Company'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:24:&SESSION.::&DEBUG.:24::'
,p_icon_css_classes=>'fa-building-o'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(52414881846182112)
,p_branch_name=>'Refresh the page'
,p_branch_action=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.:21::'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(50565756370122740)
,p_name=>'P21_COMPANY_ID'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp.component_end;
end;
/
