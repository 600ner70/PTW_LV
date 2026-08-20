--------------------------------------------------------------------------------
-- 09_update_generate_ptw_lv_pdf.sql
-- GENERATE_PTW_LV_PDF, rebuilt on top of PTW_PDF_LIB_PKG (see packages/).
-- Same visual output as before. This function now only holds what's
-- genuinely LV-specific: the Equipment Isolation section, the header's
-- extra isolation reference field, and the 5-year retention wording.
-- Everything else — site/work details, checklist, signatures, monitoring,
-- stage history — comes from the shared library.
--
-- COMPILE ORDER: this depends on PTW_PDF_LIB_PKG's SPEC (not body) via
-- its public functions, so run AFTER packages/ptw_pdf_lib_pkg.pks.sql but
-- it does not need the library's BODY to exist yet.
--------------------------------------------------------------------------------
SET DEFINE OFF

CREATE OR REPLACE EDITIONABLE FUNCTION "PTW_PRO"."GENERATE_PTW_LV_PDF" (
    p_permit_id       IN NUMBER,
    p_include_history IN VARCHAR2 DEFAULT 'N'
) RETURN CLOB
IS
    v_permit_number ptw_pro.ptw_lv_permits.permit_number%TYPE;
    v_safety_ref    ptw_pro.ptw_lv_permits.safety_programme_ref_no%TYPE;
    v_iso_serial    ptw_pro.ptw_lv_permits.isolation_diagram_serial_no%TYPE;
    v_company_id    ptw_pro.ptw_lv_permits.company_id%TYPE;
    v_logo_b64      CLOB;
    v_html          CLOB;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_html, TRUE, DBMS_LOB.CALL);

    IF p_permit_id IS NULL THEN
        RETURN '<div class="ptw-lv-report-container"><h2 style="color:red;">No Permit Selected</h2></div>';
    END IF;

    BEGIN
        SELECT permit_number, safety_programme_ref_no, isolation_diagram_serial_no, company_id
        INTO   v_permit_number, v_safety_ref, v_iso_serial, v_company_id
        FROM   ptw_pro.ptw_lv_permits
        WHERE  permit_id = p_permit_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN '<div class="ptw-lv-report-container"><h2 style="color:red;">Permit Not Found</h2>'
                || '<p>Permit ID: ' || p_permit_id || '</p></div>';
    END;

    v_logo_b64 := ptw_pro.ptw_pdf_lib_pkg.get_company_logo_b64(v_company_id);

    v_html := ptw_pro.ptw_pdf_lib_pkg.get_document_head(
        'Permit to Work LV-Electrical - ' || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_permit_number));

    -- ============================================================
    -- HEADER (LV-specific: includes Isolation & Earthing ref)
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-header">
        <div style="display:flex;justify-content:space-between;
                    align-items:center;margin-bottom:8px;">
            <h1 style="margin:0;">Permit to Work &mdash; LV Electrical</h1>';

    IF v_logo_b64 IS NOT NULL THEN
        v_html := v_html || '<img src="data:image/png;base64,';
        DBMS_LOB.APPEND(v_html, v_logo_b64);
        v_html := v_html || '" style="max-height:40px;margin-left:20px;" alt="Company Logo" />';
    END IF;

    v_html := v_html || '
        </div>
        <div class="header-refs">
            <div>Safety Programme Reference No.:<br><strong>'
        || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_safety_ref) || '</strong></div>
            <div>Isolation &amp; Earthing Diagram Serial No.:<br><strong>'
        || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_iso_serial) || '</strong></div>
            <div>Permit to Work No.:<br><strong>'
        || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_permit_number) || '</strong></div>
        </div>
    </div>';

    -- ============================================================
    -- SHARED SECTIONS
    -- ============================================================
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_site_work_details_html(p_permit_id);
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_control_measures_html(p_permit_id);
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_ppe_html(p_permit_id);

    -- ============================================================
    -- LV-SPECIFIC: Equipment Isolation
    -- ============================================================
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_equipment_isolation_html(p_permit_id);

    -- ============================================================
    -- SHARED SECTIONS
    -- ============================================================
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_authorisation_html(p_permit_id);
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_acceptance_html(p_permit_id);
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_clearance_html(p_permit_id);
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_cancellation_html(p_permit_id);

    -- ============================================================
    -- FOOTER (LV-specific: 5-year retention wording)
    -- ============================================================
    v_html := v_html || '
    <div class="footer">
        During the works the Original copy shall be retained by the &lsquo;Authorised Person&rsquo;
        and the copy shall be retained by the &lsquo;Person in Charge&rsquo; of the work and must
        have it available at all times for inspection. On completion of the works, the copy must be
        returned and both parts are signed when cancelling this Permit. Retention period 5 years.
        <br>Generated: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI') ||
        ' &nbsp;|&nbsp; Permit: ' || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_permit_number) || '
    </div>';

    -- ============================================================
    -- MONITORING PAGES (shared, LV-flavoured heading)
    -- ============================================================
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_monitoring_pages_html(
        p_permit_id, 'Low Voltage Monitoring');

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
END generate_ptw_lv_pdf;
/
