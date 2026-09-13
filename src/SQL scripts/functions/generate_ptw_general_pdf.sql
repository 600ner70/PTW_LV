
  CREATE OR REPLACE EDITIONABLE FUNCTION "PTW_PRO"."GENERATE_PTW_GENERAL_PDF" (
    p_permit_id       IN NUMBER,
    p_include_history IN VARCHAR2 DEFAULT 'N'
) RETURN CLOB
IS
    v_permit_number ptw_pro.ptw_lv_permits.permit_number%TYPE;
    v_company_id    ptw_pro.ptw_lv_permits.company_id%TYPE;
    v_logo_b64      CLOB;
    v_html          CLOB;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_html, TRUE, DBMS_LOB.CALL);

    IF p_permit_id IS NULL THEN
        RETURN '<div class="ptw-lv-report-container"><h2 style="color:red;">No Permit Selected</h2></div>';
    END IF;

    BEGIN
        SELECT permit_number, company_id
        INTO   v_permit_number, v_company_id
        FROM   ptw_pro.ptw_lv_permits
        WHERE  permit_id = p_permit_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN '<div class="ptw-lv-report-container"><h2 style="color:red;">Permit Not Found</h2>'
                || '<p>Permit ID: ' || p_permit_id || '</p></div>';
    END;

    v_logo_b64 := ptw_pro.ptw_pdf_lib_pkg.get_company_logo_b64(v_company_id);

    v_html := ptw_pro.ptw_pdf_lib_pkg.get_document_head(
        'Permit to Work General - ' || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_permit_number), 'GENERAL');

    -- ============================================================
    -- HEADER (General-specific)
    -- Removed: "Safety Programme Reference No." — that's an LV-only
    -- field (isolation/earthing diagram tracking); General's real form
    -- has no equivalent field at all.
    -- Added: the compliance banner that sits directly under the title
    -- on the real form, previously dropped entirely.
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-header">
        <div style="display:flex;justify-content:space-between;
                    align-items:center;margin-bottom:8px;">
            <h1 style="margin:0;">Permit to Work &mdash; General</h1>';

    IF v_logo_b64 IS NOT NULL THEN
        v_html := v_html || '<img src="data:image/png;base64,';
        DBMS_LOB.APPEND(v_html, v_logo_b64);
        v_html := v_html || '" style="max-height:40px;margin-left:20px;" alt="Company Logo" />';
    END IF;

    v_html := v_html || '
        </div>
        <div style="font-size:7.5pt;font-style:italic;font-weight:700;
                    border-top:1px solid rgba(0,0,0,0.15);
                    padding-top:6px;margin-top:4px;">
            All sections of this Permit MUST BE completed and all risk measures fully
            complied with. Permits can only be issued by an authorised person.
        </div>
        <div class="header-refs" style="margin-top:6px;">
            <div>Permit to Work No.:<br><strong>'
        || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_permit_number) || '</strong></div>
        </div>
    </div>';

    -- ============================================================
    -- SHARED SECTIONS — same as LV, no Equipment Isolation between
    -- PPE and Authorisation for General.
    -- ============================================================
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_site_work_details_html(p_permit_id);
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_control_measures_html(p_permit_id);
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_ppe_html(p_permit_id);
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_authorisation_html(p_permit_id, 'GENERAL');
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_acceptance_html(p_permit_id, 'GENERAL');
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_clearance_html(p_permit_id, 'GENERAL');
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_cancellation_html(p_permit_id, 'GENERAL');

    -- ============================================================
    -- FOOTER (General-specific: conditional 1/6-year retention —
    -- taken directly from the source PDF's closure page)
    -- ============================================================
    v_html := v_html || '
    <div class="footer">
        These records must be retained for a minimum of 1 year unless an accident or
        incident has occurred anywhere on site during the time the permit is open, in
        which case the records must be retained for 6 years.
        <br>Generated: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI') ||
        ' &nbsp;|&nbsp; Permit: ' || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_permit_number) || '
    </div>';

    -- ============================================================
    -- MONITORING PAGES — only if this permit type has monitoring at all.
    -- GENERAL's real form has no monitoring page (confirmed against the
    -- source PDF), so this section is skipped for GENERAL now that
    -- PTW_TYPES.HAS_MONITORING controls it rather than being unconditional.
    -- ============================================================
    IF ptw_pro.ptw_pdf_lib_pkg.type_has_monitoring('GENERAL') = 'Y' THEN
        v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_monitoring_pages_html(
            p_permit_id, 'Site Monitoring');
    END IF;

    -- ============================================================
    -- STAGE HISTORY (shared, only when requested)
    -- ============================================================
    IF NVL(p_include_history, 'N') = 'Y' THEN
        v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_stage_history_html(p_permit_id);
    END IF;

    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_document_close;

    RETURN v_html;

EXCEPTION
    WHEN OTHERS THEN
        RETURN '<html><body>'
            || '<h2 style="color:red;">Error Generating Report</h2>'
            || '<p>' || SQLERRM || '</p>'
            || '<pre>' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || '</pre>'
            || '</body></html>';
END generate_ptw_general_pdf;
/
