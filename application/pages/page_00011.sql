prompt --application/pages/page_00011
begin
--   Manifest
--     PAGE: 00011
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.6'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_page.create_page(
 p_id=>11
,p_name=>'Dynamic Risk Assessments'
,p_alias=>'DRA-DASHBOARD'
,p_step_title=>'Dynamic Risk Assessments'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function ptwCancelDra(draId, draNumber) {',
'    if (!navigator.onLine) {',
'        apex.message.showErrors([{',
'            type: ''error'',',
'            message: ''You are currently offline. Please reconnect to cancel a DRA.''',
'        }]);',
'        return;',
'    }',
'    $(''<div id="ptwCancelDraDialog">'' +',
'        ''<label style="display:block;font-weight:600;font-size:13px;margin-bottom:8px;color:#333;">'' +',
'          ''Cancellation Reason <span style="color:#C0392B">*</span>'' +',
'        ''</label>'' +',
'        ''<input type="text" id="ptwCancelDraReason" class="apex-item-text" '' +',
'          ''placeholder="e.g. started in error, duplicate" />'' +',
'      ''</div>'')',
'      .appendTo(''body'')',
'      .dialog({',
unistr('          title: ''Cancel DRA \2013 '' + draNumber,'),
'          modal:  true,',
'          width:  500,',
'          dialogClass: ''ptw-apex-dialog'',',
'          buttons: [',
'              {',
'                  text:  ''Cancel DRA'',',
'                  ''class'': ''t-Button t-Button--hot'',',
'                  click: function() {',
'                      var reason = $(''#ptwCancelDraReason'').val();',
'                      if (!reason || reason.trim() === '''') {',
'                          apex.message.alert(''A cancellation reason is required.'');',
'                          return;',
'                      }',
'                      apex.item(''P11_SELECTED_DRA_ID'').setValue(draId);',
'                      apex.item(''P11_CANCEL_REASON'').setValue(reason.trim());',
'                      $(this).dialog(''close'');',
'                      apex.submit({ request: ''CANCEL_DRA_'' + draId });',
'                  }',
'              },',
'              {',
'                  text:  ''Keep DRA'',',
'                  ''class'': ''t-Button'',',
'                  click: function() { $(this).dialog(''close''); }',
'              }',
'          ],',
'          close: function() { $(this).dialog(''destroy'').remove(); }',
'      });',
'}'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.quick-actions {',
'    display: flex;',
'    gap: 10px;',
'    flex-wrap: wrap;',
'}',
'.quick-actions .t-Button {',
'    flex: 1;',
'    min-width: 200px;',
'}',
' ',
'/* Purple badge/button - COMPLETED (view-only), matches Page 1 */',
'.t-Badge--purple {',
'    --a-badge-background: #6f42c1;',
'    --a-badge-text: #ffffff;',
'    --a-badge-border: #6f42c1;',
'    background-color: #6f42c1 !important;',
'    color: #ffffff !important;',
'    border-color: #6f42c1 !important;',
'}',
'.t-Button--purple {',
'    --a-button-background-color: #6f42c1;',
'    --a-button-border-color: #6f42c1;',
'    --a-button-text-color: #ffffff;',
'    background-color: #6f42c1 !important;',
'    border-color: #6f42c1 !important;',
'    color: #ffffff !important;',
'    opacity: 1 !important;',
'}',
' ',
'@media (max-width: 767px) {',
'    .ptw-desktop-only { display: none !important; }',
'}',
'@media (min-width: 768px) {',
'    .ptw-mobile-only  { display: none !important; }',
'}',
' ',
'/* Card container - matches Redwood region surface, same as Page 1 */',
'.ptw-permit-card {',
'    border-radius: 8px;',
'    border: 1px solid var(--ut-component-border-color, #e0e0e0);',
'    background: var(--ut-component-background-color);',
'    margin-bottom: 0.75rem;',
'    overflow: hidden;',
'    box-shadow: 0 1px 4px rgba(0,0,0,0.08);',
'}',
' ',
'/* Status left-border - DRAFT/COMPLETED/CANCELLED instead of the',
'   time-remaining countdown colours permits use (a DRA doesn''t expire) */',
'.ptw-card-draft     { border-left: 5px solid var(--ut-palette-warning, #f0ad4e); }',
'.ptw-card-completed { border-left: 5px solid var(--ut-palette-success, #3ea055); }',
'.ptw-card-cancelled { border-left: 5px solid var(--ut-palette-danger,  #c0392b); }',
' ',
'.ptw-card-header {',
'    display: flex;',
'    justify-content: space-between;',
'    align-items: center;',
'    padding: 0.75rem 1rem 0.5rem 1rem;',
'    border-bottom: 1px solid var(--ut-component-border-color, #e0e0e0);',
'    background: var(--ut-region-header-background-color,',
'                    var(--ut-component-background-color));',
'}',
'.ptw-card-permit-number {',
'    font-size: 0.9375rem;',
'    font-weight: 700;',
'    color: #003366;',
'}',
'.ptw-card-body {',
'    padding: 0.6rem 1rem;',
'    font-size: 0.875rem;',
'    color: var(--ut-component-font-color, inherit);',
'    line-height: 1.7;',
'}',
'.ptw-card-label {',
'    font-weight: 600;',
'    color: var(--ut-palette-neutral-600, #595959);',
'    font-size: 0.75rem;',
'    text-transform: uppercase;',
'    letter-spacing: 0.03em;',
'}',
'.ptw-card-actions {',
'    display: flex;',
'    gap: 0.4rem;',
'    padding: 0.6rem 1rem 0.75rem 1rem;',
'    border-top: 1px solid var(--ut-component-border-color, #e0e0e0);',
'    background: var(--ut-component-background-color);',
'    flex-wrap: wrap;',
'}',
'.ptw-card-actions a,',
'.ptw-card-actions button {',
'    min-width: 44px;',
'    min-height: 44px;',
'    display: inline-flex;',
'    align-items: center;',
'    justify-content: center;',
'    border-radius: 6px;',
'    font-size: 1.1rem;',
'}',
' ',
'#recentDrasMobile .t-Region-header {',
'    display: flex;',
'    align-items: center;',
'}',
'#recentDrasMobile .t-Region-headerItems--buttons {',
'    margin-left: auto;',
'}',
' ',
'/* Cancel dialog input - matches Page 1''s suspend/resume dialogs */',
'.ptw-apex-dialog #ptwCancelDraReason {',
'    display: block !important;',
'    width: 100% !important;',
'    height: 44px !important;',
'    font-size: 14px !important;',
'    box-sizing: border-box !important;',
'    margin: 0 !important;',
'}'))
,p_step_template=>4072355960268175073
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'25'
,p_created_on=>wwv_flow_imp.dz('20260920150252Z')
,p_last_updated_on=>wwv_flow_imp.dz('20261010202023Z')
,p_created_by=>'PTW_PRO'
,p_last_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(43898694962698032)
,p_plug_name=>'Page Header'
,p_static_id=>'page-header'
,p_region_name=>'page-header'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>50
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_html       CLOB;',
'    l_company_id NUMBER;',
'    l_logo_url   VARCHAR2(500);',
'    l_logo_count NUMBER;',
'    l_override   VARCHAR2(50) := V(''G_OVERRIDE_COMPANY_ID'');',
'BEGIN',
'    -- Derive effective company_id for the current user',
'    IF l_override IS NOT NULL AND TRIM(l_override) IS NOT NULL THEN',
'        BEGIN',
'            l_company_id := TO_NUMBER(TRIM(l_override));',
'        EXCEPTION',
'            WHEN OTHERS THEN l_company_id := NULL;',
'        END;',
'    ELSE',
'        -- Normal user: their own company',
'        -- Super user with no override: NULL (no logo shown)',
'        BEGIN',
'            SELECT company_id',
'            INTO   l_company_id',
'            FROM   ptw_pro.ptw_lv_users',
'            WHERE  UPPER(username) = UPPER(:APP_USER)',
'            AND    is_super_user   = ''N''',
'            AND    is_active       = ''Y'';',
'        EXCEPTION',
'            WHEN NO_DATA_FOUND THEN l_company_id := NULL;',
'        END;',
'    END IF;',
' ',
'    -- Check if a logo file exists for this company',
'    -- (graceful fallback - no broken image if file missing)',
' ',
'    IF l_company_id IS NOT NULL THEN',
'        SELECT COUNT(*) INTO l_logo_count',
'        FROM   apex_application_static_files',
'        WHERE  application_id = :APP_ID',
'        AND    file_name      = ''logo_'' || l_company_id || ''.png'';',
' ',
'        IF l_logo_count > 0 THEN',
'            l_logo_url := V(''APP_FILES'') || ''logo_'' || l_company_id || ''.png'';',
'        END IF;',
'    END IF;',
' ',
'    -- Build header',
'    l_html := ''<div style="margin-bottom:30px;display:flex;''',
'           || ''justify-content:space-between;align-items:center;''',
'           || ''min-height:80px;">''',
'           || ''  <div>''',
'           || ''    <h1 style="font-size:2rem;color:#13294b;''',
'           || ''               margin-bottom:5px;">''',
'           || ''      Dynamic Risk Assessments''',
'           || ''    </h1>''',
'           || ''    <p style="color:#666;font-size:1rem;">''',
'           || ''      Dynamic Risk Assessment (Stop &amp; Think) Records''',
'           || ''    </p>''',
'           || ''  </div>'';',
' ',
'    IF l_logo_url IS NOT NULL THEN',
'        l_html := l_html',
'               || ''  <div style="width:200px;height:60px;display:flex;''',
'               || ''align-items:center;justify-content:flex-end;">''',
'               || ''    <img src="'' || l_logo_url || ''" ''',
'               || ''         alt="Company Logo" ''',
'               || ''         style="max-width:100%;max-height:100%;''',
'               || ''object-fit:contain;" />''',
'               || ''  </div>'';',
'    END IF;',
' ',
'    l_html := l_html || ''</div>'';',
' ',
'    RETURN l_html;',
' ',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        -- Never break Page 11 - fall back to plain header',
'        RETURN ''<div style="margin-bottom:30px;">''',
'            || ''<h1 style="font-size:2rem;color:#13294b;">''',
'            || ''Dynamic Risk Assessments</h1>''',
'            || ''<p style="color:#666;">Dynamic Risk Assessment ''',
'            || ''(Stop &amp; Think) Records</p></div>'';',
'END;'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_created_on=>wwv_flow_imp.dz('20260920154410Z')
,p_updated_on=>wwv_flow_imp.dz('20260920154411Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(43898727346698033)
,p_plug_name=>'Quick Actions'
,p_static_id=>'quick-actions'
,p_title=>'Quick Actions'
,p_icon_css_classes=>'fa-bolt'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>60
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_display_condition_type=>'EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':APP_IS_ADMIN = ''Y'' OR :APP_IS_ENGINEER = ''Y''',
'OR :APP_IS_AUTHORISER = ''Y'''))
,p_plug_display_when_cond2=>'PLSQL'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920154410Z')
,p_updated_on=>wwv_flow_imp.dz('20260920211658Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(43898835304698034)
,p_plug_name=>'Recent DRAs'
,p_static_id=>'recent-dras'
,p_title=>'Recent DRAs'
,p_region_css_classes=>'ptw-desktop-only'
,p_icon_css_classes=>'fa-list'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>80
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    d.dra_id,',
'    d.dra_number,',
'    d.dra_type,',
'    CASE d.dra_type',
'        WHEN ''ENGINEER''     THEN ''Engineer DRA''',
'        ELSE ''Subcontractor DRA''',
'    END AS type_display,',
'    COALESCE(s.site_name, d.site_details) AS site_details,',
'    d.job_number,',
'    d.engineer_name,',
'    d.supervising_company,',
'    TO_CHAR(d.assessment_date,''DD-MON-YYYY HH24:MI'') as assessment_date,',
'    d.permit_id,',
'    d.workflow_status,',
'    CASE d.workflow_status',
'        WHEN ''DRAFT''     THEN ''Draft''',
'        WHEN ''COMPLETED'' THEN ''Completed''',
'        WHEN ''CANCELLED'' THEN ''Cancelled''',
'    END AS status_display,',
'    CASE d.workflow_status',
'        WHEN ''DRAFT''     THEN ''class="t-Badge t-Badge--warning t-Badge--lg"''',
'        WHEN ''COMPLETED'' THEN ''class="t-Badge t-Badge--purple t-Badge--lg"''',
'        WHEN ''CANCELLED'' THEN ''class="t-Badge t-Badge--danger t-Badge--lg"''',
'    END AS status_badge,',
'    ''<div class="ptw-action-btns">'' ||',
'    -- Continue editing (DRAFT only, own DRA or Admin)',
'    CASE',
'        WHEN d.workflow_status = ''DRAFT''',
'             AND (UPPER(d.created_by) = UPPER(V(''APP_USER'')) OR :APP_IS_ADMIN = ''Y'')',
'        THEN ''<a href="'' || apex_page.get_url(',
'                    p_page   => 12,',
'                    p_items  => ''P12_DRA_ID'',',
'                    p_values => d.dra_id,',
'                    p_clear_cache => 12',
'                ) || ''"',
'             class="t-Button t-Button--noLabel t-Button--icon t-Button--warning ptw-action-btn"',
'             title="Continue">',
'             <span class="t-Icon fa fa-pencil" aria-hidden="true"></span>',
'          </a>''',
'    END ||',
'    -- View / PDF (COMPLETED only)',
'    ''<a href="'' || apex_page.get_url(',
'                    p_page   => 301,',
'                    p_items  => ''P301_DRA_ID'',',
'                    p_values => d.dra_id,',
'                    p_clear_cache => 301',
'                ) || ''"',
'             class="t-Button t-Button--noLabel t-Button--icon t-Button--normal ptw-action-btn"',
'             title="View / PDF">',
'             <span class="t-Icon fa fa-file-pdf-o" aria-hidden="true"></span>',
'          </a>''',
'    ||',
'    -- Cancel (DRAFT only, own DRA or Admin)',
'    CASE',
'        WHEN d.workflow_status = ''DRAFT''',
'             AND (UPPER(d.created_by) = UPPER(V(''APP_USER'')) OR :APP_IS_ADMIN = ''Y'')',
'        THEN ''<a href="#"',
'             class="t-Button t-Button--noLabel t-Button--icon t-Button--danger ptw-action-btn"',
'             title="Cancel DRA"',
'             onclick="ptwCancelDra('' || d.dra_id || '', '''''' || d.dra_number || ''''''); return false;">',
'             <span class="t-Icon fa fa-ban" aria-hidden="true"></span>',
'          </a>''',
'    END ||',
'    -- Related permit, if linked',
'    CASE',
'        WHEN d.permit_id IS NOT NULL',
'        THEN ''<a href="'' || apex_page.get_url(',
'                    p_page   => 2,',
'                    p_items  => ''P2_PERMIT_ID'',',
'                    p_values => d.permit_id',
'                ) || ''"',
'             class="t-Button t-Button--noLabel t-Button--icon t-Button--normal ptw-action-btn"',
'             title="Related Permit">',
'             <span class="t-Icon fa fa-link" aria-hidden="true"></span>',
'          </a>''',
'    END ||',
'    ''</div>'' AS actions',
'FROM   ptw_pro.ptw_lv_dra_assessments d',
'LEFT JOIN ptw_pro.ptw_lv_sites s ON s.site_id = d.site_id',
'WHERE  d.workflow_status != ''CANCELLED''',
'AND    (',
'           :APP_IS_ADMIN = ''Y'' OR :APP_IS_AUTHORISER = ''Y''',
'           OR UPPER(d.created_by) = UPPER(V(''APP_USER''))',
'       )',
'ORDER BY d.created_date DESC'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Recent DRAs'
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
,p_ai_enabled=>false
,p_created_on=>wwv_flow_imp.dz('20260920154410Z')
,p_updated_on=>wwv_flow_imp.dz('20261010193954Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(43898976964698035)
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_finder_drop_down=>'N'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_internal_uid=>43898976964698035
,p_created_on=>wwv_flow_imp.dz('20260920154411Z')
,p_updated_on=>wwv_flow_imp.dz('20261010181100Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(43900322103698049)
,p_db_column_name=>'ACTIONS'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Actions'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260920154411Z')
,p_updated_on=>wwv_flow_imp.dz('20260920154411Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(44029536450628816)
,p_db_column_name=>'ASSESSMENT_DATE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Assessment Date'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260920211356Z')
,p_updated_on=>wwv_flow_imp.dz('20260920211356Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(43899005273698036)
,p_db_column_name=>'DRA_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Dra Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260920154411Z')
,p_updated_on=>wwv_flow_imp.dz('20260920154411Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(43899127029698037)
,p_db_column_name=>'DRA_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Dra Number'
,p_column_link=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:12:P12_DRA_ID:#DRA_ID#'
,p_column_linktext=>'#DRA_NUMBER#'
,p_column_link_attr=>'#STATUS_BADGE#'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260920154411Z')
,p_updated_on=>wwv_flow_imp.dz('20261010181100Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(43899249487698038)
,p_db_column_name=>'DRA_TYPE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Dra Type'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260920154411Z')
,p_updated_on=>wwv_flow_imp.dz('20260920154411Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(43899602255698042)
,p_db_column_name=>'ENGINEER_NAME'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Engineer'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260920154411Z')
,p_updated_on=>wwv_flow_imp.dz('20260920154411Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(43899530481698041)
,p_db_column_name=>'JOB_NUMBER'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Job Number'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260920154411Z')
,p_updated_on=>wwv_flow_imp.dz('20260920154411Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(43899915489698045)
,p_db_column_name=>'PERMIT_ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Permit Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260920154411Z')
,p_updated_on=>wwv_flow_imp.dz('20260920154411Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(43899460921698040)
,p_db_column_name=>'SITE_DETAILS'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Site'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260920154411Z')
,p_updated_on=>wwv_flow_imp.dz('20260920154411Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(43900200679698048)
,p_db_column_name=>'STATUS_BADGE'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Status Badge'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260920154411Z')
,p_updated_on=>wwv_flow_imp.dz('20260920154411Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(43900116644698047)
,p_db_column_name=>'STATUS_DISPLAY'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260920154411Z')
,p_updated_on=>wwv_flow_imp.dz('20260920154411Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(43899789513698043)
,p_db_column_name=>'SUPERVISING_COMPANY'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Company'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260920154411Z')
,p_updated_on=>wwv_flow_imp.dz('20260920154411Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(43899320792698039)
,p_db_column_name=>'TYPE_DISPLAY'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260920154411Z')
,p_updated_on=>wwv_flow_imp.dz('20260920154411Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(43900056033698046)
,p_db_column_name=>'WORKFLOW_STATUS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Workflow Status'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_available_clientside=>'N'
,p_created_on=>wwv_flow_imp.dz('20260920154411Z')
,p_updated_on=>wwv_flow_imp.dz('20260920154411Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(44009318233871822)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'DRA_NUMBER:STATUS_DISPLAY:TYPE_DISPLAY:SITE_DETAILS:JOB_NUMBER:ENGINEER_NAME:SUPERVISING_COMPANY:ASSESSMENT_DATE:ACTIONS'
,p_created_on=>wwv_flow_imp.dz('20260920154629Z')
,p_updated_on=>wwv_flow_imp.dz('20260920211500Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(43900454485698050)
,p_name=>'Recent DRAs (Mobile)'
,p_static_id=>'recent-dras-mobile'
,p_title=>'Recent DRAs'
,p_template=>4072358936313175081
,p_display_sequence=>90
,p_region_css_classes=>'ptw-mobile-only'
,p_icon_css_classes=>'fa-list'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    d.dra_id,',
'    d.dra_number,',
'    d.dra_type,',
'    CASE d.dra_type',
'        WHEN ''ENGINEER''     THEN ''Engineer DRA''',
'        ELSE ''Subcontractor DRA''',
'    END AS type_display,',
'    COALESCE(s.site_name, d.site_details) AS site_details,',
'    d.job_number,',
'    d.engineer_name,',
'    d.supervising_company,',
'    TO_CHAR(d.assessment_date, ''DD-MON-YYYY'') AS assessment_date_display,',
'    d.permit_id,',
'    d.workflow_status,',
'    -- Card left-border colour class',
'    CASE d.workflow_status',
'        WHEN ''DRAFT''     THEN ''ptw-card-draft''',
'        WHEN ''COMPLETED'' THEN ''ptw-card-completed''',
'        WHEN ''CANCELLED'' THEN ''ptw-card-cancelled''',
'    END AS card_color_class,',
'    -- Status badge',
'    CASE d.workflow_status',
'        WHEN ''DRAFT''     THEN ''Draft''',
'        WHEN ''COMPLETED'' THEN ''Completed''',
'        WHEN ''CANCELLED'' THEN ''Cancelled''',
'    END AS status_display,',
'    CASE d.workflow_status',
'        WHEN ''DRAFT''     THEN ''t-Badge--warning''',
'        WHEN ''COMPLETED'' THEN ''t-Badge--purple''',
'        WHEN ''CANCELLED'' THEN ''t-Badge--danger''',
'    END AS badge_class,',
'    -- Continue editing (DRAFT only, own DRA or Admin)',
'    CASE',
'        WHEN d.workflow_status = ''DRAFT''',
'             AND (UPPER(d.created_by) = UPPER(V(''APP_USER'')) OR :APP_IS_ADMIN = ''Y'')',
'        THEN ''<a href="'' || apex_page.get_url(',
'                    p_page   => 12,',
'                    p_items  => ''P12_DRA_ID'',',
'                    p_values => d.dra_id,',
'                    p_clear_cache => 12',
'                ) || ''"',
'             class="t-Button t-Button--noLabel t-Button--icon t-Button--warning ptw-action-btn"',
'             title="Continue">',
'             <span class="t-Icon fa fa-pencil" aria-hidden="true"></span>',
'          </a>''',
'    END AS continue_html,',
'    -- View / PDF',
'    ''<a href="'' || apex_page.get_url(',
'                    p_page   => 301,',
'                    p_items  => ''P301_DRA_ID'',',
'                    p_values => d.dra_id,',
'                    p_clear_cache => 301',
'                ) || ''"',
'             class="t-Button t-Button--noLabel t-Button--icon t-Button--normal ptw-action-btn"',
'             title="View / PDF">',
'             <span class="t-Icon fa fa-file-pdf-o" aria-hidden="true"></span>',
'          </a>'' AS pdf_html,',
'    -- Cancel (DRAFT only, own DRA or Admin)',
'    CASE',
'        WHEN d.workflow_status = ''DRAFT''',
'             AND (UPPER(d.created_by) = UPPER(V(''APP_USER'')) OR :APP_IS_ADMIN = ''Y'')',
'        THEN ''<a href="#"',
'             class="t-Button t-Button--noLabel t-Button--icon t-Button--danger ptw-action-btn"',
'             title="Cancel DRA"',
'             onclick="ptwCancelDra('' || d.dra_id || '', '''''' || d.dra_number || ''''''); return false;">',
'             <span class="t-Icon fa fa-ban" aria-hidden="true"></span>',
'          </a>''',
'    END AS cancel_html,',
'    -- Related permit, if linked',
'    CASE',
'        WHEN d.permit_id IS NOT NULL',
'        THEN ''<a href="'' || apex_page.get_url(',
'                    p_page   => 2,',
'                    p_items  => ''P2_PERMIT_ID'',',
'                    p_values => d.permit_id',
'                ) || ''"',
'             class="t-Button t-Button--noLabel t-Button--icon t-Button--normal ptw-action-btn"',
'             title="Related Permit">',
'             <span class="t-Icon fa fa-link" aria-hidden="true"></span>',
'          </a>''',
'    END AS link_html',
'FROM   ptw_pro.ptw_lv_dra_assessments d',
'LEFT JOIN ptw_pro.ptw_lv_sites s ON s.site_id = d.site_id',
'WHERE  d.workflow_status != ''CANCELLED''',
'AND    (',
'           :APP_IS_ADMIN = ''Y'' OR :APP_IS_AUTHORISER = ''Y''',
'           OR UPPER(d.created_by) = UPPER(V(''APP_USER''))',
'       )',
'ORDER BY d.created_date DESC'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2538654340625403440
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
,p_created_on=>wwv_flow_imp.dz('20260920154410Z')
,p_updated_on=>wwv_flow_imp.dz('20261010202023Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(43990952526819409)
,p_query_column_id=>9
,p_column_alias=>'ASSESSMENT_DATE_DISPLAY'
,p_column_display_sequence=>90
,p_hidden_column=>'Y'
,p_derived_column=>'N'
,p_updated_on=>wwv_flow_imp.dz('20260920154412Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(43991476136819414)
,p_query_column_id=>14
,p_column_alias=>'BADGE_CLASS'
,p_column_display_sequence=>140
,p_hidden_column=>'Y'
,p_derived_column=>'N'
,p_updated_on=>wwv_flow_imp.dz('20260920154412Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(43991763463819417)
,p_query_column_id=>17
,p_column_alias=>'CANCEL_HTML'
,p_column_display_sequence=>170
,p_hidden_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_updated_on=>wwv_flow_imp.dz('20260920154412Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(43991247954819412)
,p_query_column_id=>12
,p_column_alias=>'CARD_COLOR_CLASS'
,p_column_display_sequence=>120
,p_hidden_column=>'Y'
,p_derived_column=>'N'
,p_updated_on=>wwv_flow_imp.dz('20260920154412Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(43991540682819415)
,p_query_column_id=>15
,p_column_alias=>'CONTINUE_HTML'
,p_column_display_sequence=>150
,p_hidden_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_updated_on=>wwv_flow_imp.dz('20260920154412Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(43990185403819401)
,p_query_column_id=>1
,p_column_alias=>'DRA_ID'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
,p_updated_on=>wwv_flow_imp.dz('20260920154411Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(43990260988819402)
,p_query_column_id=>2
,p_column_alias=>'DRA_NUMBER'
,p_column_display_sequence=>20
,p_column_heading=>'Dra Number'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="ptw-permit-card #CARD_COLOR_CLASS#">',
' ',
'  <div class="ptw-card-header">',
'    <span class="ptw-card-permit-number">#DRA_NUMBER#</span>',
'    <span class="t-Badge #BADGE_CLASS# t-Badge--lg">#STATUS_DISPLAY#</span>',
'  </div>',
'  <div style="padding:0 1rem;">',
'    <span class="apex-badge" style="background-color:#5a6b7a;color:white;',
'        padding:2px 10px;border-radius:12px;font-weight:600;font-size:0.75rem;">',
'      #TYPE_DISPLAY#',
'    </span>',
'  </div>',
'  <div class="ptw-card-body">',
'    <div>',
'      <strong class="ptw-card-label">Site</strong><br>',
'      #SITE_DETAILS#',
'    </div>',
'    <div>',
'      <strong class="ptw-card-label">Engineer</strong><br>',
'      #ENGINEER_NAME#',
'    </div>',
'    <div>',
'      <strong class="ptw-card-label">Date</strong><br>',
'      #ASSESSMENT_DATE_DISPLAY#',
'    </div>',
'  </div>',
' ',
'  <div class="ptw-card-actions ptw-action-btns">',
'    #CONTINUE_HTML#',
'    #PDF_HTML#',
'    #CANCEL_HTML#',
'    #LINK_HTML#',
'  </div>',
' ',
'</div>'))
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_updated_on=>wwv_flow_imp.dz('20260920154411Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(43990355326819403)
,p_query_column_id=>3
,p_column_alias=>'DRA_TYPE'
,p_column_display_sequence=>30
,p_hidden_column=>'Y'
,p_derived_column=>'N'
,p_updated_on=>wwv_flow_imp.dz('20260920154411Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(43990755809819407)
,p_query_column_id=>7
,p_column_alias=>'ENGINEER_NAME'
,p_column_display_sequence=>70
,p_hidden_column=>'Y'
,p_derived_column=>'N'
,p_updated_on=>wwv_flow_imp.dz('20260920154412Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(43990603254819406)
,p_query_column_id=>6
,p_column_alias=>'JOB_NUMBER'
,p_column_display_sequence=>60
,p_hidden_column=>'Y'
,p_derived_column=>'N'
,p_updated_on=>wwv_flow_imp.dz('20260920154412Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(43991867530819418)
,p_query_column_id=>18
,p_column_alias=>'LINK_HTML'
,p_column_display_sequence=>180
,p_hidden_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_updated_on=>wwv_flow_imp.dz('20260920154412Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(43991662240819416)
,p_query_column_id=>16
,p_column_alias=>'PDF_HTML'
,p_column_display_sequence=>160
,p_hidden_column=>'Y'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_updated_on=>wwv_flow_imp.dz('20260920154412Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(43991073940819410)
,p_query_column_id=>10
,p_column_alias=>'PERMIT_ID'
,p_column_display_sequence=>100
,p_hidden_column=>'Y'
,p_derived_column=>'N'
,p_updated_on=>wwv_flow_imp.dz('20260920154412Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(43990549531819405)
,p_query_column_id=>5
,p_column_alias=>'SITE_DETAILS'
,p_column_display_sequence=>50
,p_hidden_column=>'Y'
,p_derived_column=>'N'
,p_updated_on=>wwv_flow_imp.dz('20260920154411Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(43991369095819413)
,p_query_column_id=>13
,p_column_alias=>'STATUS_DISPLAY'
,p_column_display_sequence=>130
,p_hidden_column=>'Y'
,p_derived_column=>'N'
,p_updated_on=>wwv_flow_imp.dz('20260920154412Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(43990865757819408)
,p_query_column_id=>8
,p_column_alias=>'SUPERVISING_COMPANY'
,p_column_display_sequence=>80
,p_hidden_column=>'Y'
,p_derived_column=>'N'
,p_updated_on=>wwv_flow_imp.dz('20260920154412Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(43990435936819404)
,p_query_column_id=>4
,p_column_alias=>'TYPE_DISPLAY'
,p_column_display_sequence=>40
,p_hidden_column=>'Y'
,p_derived_column=>'N'
,p_updated_on=>wwv_flow_imp.dz('20260920154411Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(43991196140819411)
,p_query_column_id=>11
,p_column_alias=>'WORKFLOW_STATUS'
,p_column_display_sequence=>110
,p_hidden_column=>'Y'
,p_derived_column=>'N'
,p_updated_on=>wwv_flow_imp.dz('20260920154412Z')
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(44028762880628808)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(43898727346698033)
,p_button_name=>'CREATE_DRA'
,p_static_id=>'create-dra'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create New DRA'
,p_button_redirect_url=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:12:P12_WORKFLOW_STATUS:DRAFT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa fa-plus-circle'
,p_grid_new_row=>'Y'
,p_grid_column_span=>12
,p_created_on=>wwv_flow_imp.dz('20260920180842Z')
,p_updated_on=>wwv_flow_imp.dz('20260920181341Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43992078159819420)
,p_name=>'P11_CANCEL_REASON'
,p_item_sequence=>40
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920154411Z')
,p_updated_on=>wwv_flow_imp.dz('20260920154411Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43991945284819419)
,p_name=>'P11_SELECTED_DRA_ID'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260920154411Z')
,p_updated_on=>wwv_flow_imp.dz('20260920154411Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(43992168029819421)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Cancel DRA'
,p_static_id=>'cancel-dra'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_dra_id ptw_pro.ptw_lv_dra_assessments.dra_id%TYPE := :P11_SELECTED_DRA_ID;',
'BEGIN',
'    ptw_pro.ptw_dra_pkg.cancel_dra(',
'        p_dra_id => l_dra_id,',
'        p_reason => :P11_CANCEL_REASON',
'    );',
'    apex_util.set_session_state(''P11_SELECTED_DRA_ID'', NULL);',
'    apex_util.set_session_state(''P11_CANCEL_REASON'', NULL);',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        apex_error.add_error(',
'            p_message          => SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>':REQUEST like ''CANCEL_DRA_%'''
,p_process_when_type=>'EXPRESSION'
,p_process_when2=>'PLSQL'
,p_process_success_message=>'DRA cancelled.'
,p_internal_uid=>43992168029819421
,p_created_on=>wwv_flow_imp.dz('20260920154411Z')
,p_updated_on=>wwv_flow_imp.dz('20260920154411Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
