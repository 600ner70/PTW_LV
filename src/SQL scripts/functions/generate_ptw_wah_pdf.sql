
  CREATE OR REPLACE EDITIONABLE FUNCTION "PTW_PRO"."GENERATE_PTW_WAH_PDF" (
    p_permit_id       IN NUMBER,
    p_include_history IN VARCHAR2 DEFAULT 'N'
) RETURN CLOB
IS
    v_permit_number ptw_pro.ptw_lv_permits.permit_number%TYPE;
    v_specialist_eq ptw_pro.ptw_lv_permits.specialist_equipment_details%TYPE;
    v_company_id    ptw_pro.ptw_lv_permits.company_id%TYPE;
    v_logo_b64      CLOB;
    v_html          CLOB;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_html, TRUE, DBMS_LOB.CALL);

    IF p_permit_id IS NULL THEN
        RETURN '<div class="ptw-lv-report-container"><h2 style="color:red;">No Permit Selected</h2></div>';
    END IF;

    BEGIN
        SELECT permit_number, specialist_equipment_details, company_id
        INTO   v_permit_number, v_specialist_eq, v_company_id
        FROM   ptw_pro.ptw_lv_permits
        WHERE  permit_id = p_permit_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN '<div class="ptw-lv-report-container"><h2 style="color:red;">Permit Not Found</h2>'
                || '<p>Permit ID: ' || p_permit_id || '</p></div>';
    END;

    v_logo_b64 := ptw_pro.ptw_pdf_lib_pkg.get_company_logo_b64(v_company_id);

    v_html := ptw_pro.ptw_pdf_lib_pkg.get_document_head(
        'Permit to Work Working at Height - ' || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_permit_number));

    -- ============================================================
    -- HEADER (WAH-specific: no Safety Programme Ref, no Isolation
    -- Diagram Serial - neither field exists on this form. Only
    -- the Permit No. reference, matching what the real form
    -- actually shows.)
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-header">
        <div style="display:flex;justify-content:space-between;
                    align-items:center;margin-bottom:8px;">
            <h1 style="margin:0;">Permit to Work &mdash; Working at Height</h1>';

    IF v_logo_b64 IS NOT NULL THEN
        v_html := v_html || '<img src="data:image/png;base64,';
        DBMS_LOB.APPEND(v_html, v_logo_b64);
        v_html := v_html || '" style="max-height:40px;margin-left:20px;" alt="Company Logo" />';
    END IF;

    v_html := v_html || '
        </div>
        <div class="header-refs">
            <div>Permit to Work No.:<br><strong>'
        || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_permit_number) || '</strong></div>
        </div>
    </div>';

    -- ============================================================
    -- WAH-SPECIFIC: Specialist Equipment (no equivalent on LV or
    -- General - printed as its own paragraph, not crammed into
    -- the short-reference header-refs box above, since it's
    -- free-text and can run to a few sentences)
    -- ============================================================
    IF v_specialist_eq IS NOT NULL THEN
        v_html := v_html || '
        <div class="section" style="margin:10px 0;padding:10px 15px;
                    border:1px solid #e0e0e0;border-radius:4px;background:#f8f9fa;">
            <strong>Details of Specialist Equipment / Dedicated Access Required
            (Cradle, generator, etc.):</strong><br>'
            || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_specialist_eq) || '
        </div>';
    END IF;

    -- ============================================================
    -- SHARED SECTIONS
    -- ============================================================
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_site_work_details_html(p_permit_id);
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_control_measures_html(p_permit_id);
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_ppe_html(p_permit_id);

    -- ============================================================
    -- WAH HAS EQUIPMENT ISOLATION TOO (confirmed from the real
    -- form - same 4-row table as LV, not General-style absence)
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
    -- FOOTER (5-year retention - confirmed word-for-word match to
    -- LV's wording, independently verified against the real WAH
    -- PDF, not assumed)
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
    -- MONITORING PAGES (shared, WAH-flavoured heading - WAH has
    -- monitoring per Phase 3's ptw_type_sections seed)
    -- ============================================================
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_monitoring_pages_html(
        p_permit_id, 'Working at Height Monitoring');

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
END generate_ptw_wah_pdf;
/
