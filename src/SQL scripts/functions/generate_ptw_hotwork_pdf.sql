
  CREATE OR REPLACE EDITIONABLE FUNCTION "PTW_PRO"."GENERATE_PTW_HOTWORK_PDF" (
    p_permit_id       IN NUMBER,
    p_include_history IN VARCHAR2 DEFAULT 'N'
) RETURN CLOB
IS
    v_permit_number   ptw_pro.ptw_lv_permits.permit_number%TYPE;
    v_safety_ref      ptw_pro.ptw_lv_permits.safety_programme_ref_no%TYPE;
    v_fire_affected   ptw_pro.ptw_lv_permits.fire_systems_affected%TYPE;
    v_fire_isolated   ptw_pro.ptw_lv_permits.fire_systems_isolated%TYPE;
    v_insurer_dt      ptw_pro.ptw_lv_permits.insurer_informed_datetime%TYPE;
    v_iso_comments    ptw_pro.ptw_lv_permits.isolation_comments%TYPE;
    v_fire_precautions ptw_pro.ptw_lv_permits.fire_precautions_details%TYPE;
    v_fire_alarm      ptw_pro.ptw_lv_permits.fire_alarm_arrangements%TYPE;
    v_company_id      ptw_pro.ptw_lv_permits.company_id%TYPE;
    v_logo_b64        CLOB;
    v_html            CLOB;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_html, TRUE, DBMS_LOB.CALL);

    IF p_permit_id IS NULL THEN
        RETURN '<div class="ptw-lv-report-container"><h2 style="color:red;">No Permit Selected</h2></div>';
    END IF;

    BEGIN
        SELECT permit_number, safety_programme_ref_no, fire_systems_affected,
               fire_systems_isolated, insurer_informed_datetime, isolation_comments,
               fire_precautions_details, fire_alarm_arrangements, company_id
        INTO   v_permit_number, v_safety_ref, v_fire_affected,
               v_fire_isolated, v_insurer_dt, v_iso_comments,
               v_fire_precautions, v_fire_alarm, v_company_id
        FROM   ptw_pro.ptw_lv_permits
        WHERE  permit_id = p_permit_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN '<div class="ptw-lv-report-container"><h2 style="color:red;">Permit Not Found</h2>'
                || '<p>Permit ID: ' || p_permit_id || '</p></div>';
    END;

    v_logo_b64 := ptw_pro.ptw_pdf_lib_pkg.get_company_logo_b64(v_company_id);

    v_html := ptw_pro.ptw_pdf_lib_pkg.get_document_head(
        'Permit to Work Hot Work - ' || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_permit_number));

    -- ============================================================
    -- HEADER (Hot Work-specific: Safety Programme Ref + Permit No.
    -- only — no isolation diagram serial, that's LV-only)
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-header">
        <div style="display:flex;justify-content:space-between;
                    align-items:center;margin-bottom:8px;">
            <h1 style="margin:0;">Permit to Work &mdash; Hot Work</h1>';

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
            <div>Permit to Work No.:<br><strong>'
        || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_permit_number) || '</strong></div>
        </div>
    </div>';

    -- ============================================================
    -- SHARED: Site & Work Details — comes first, matching the real
    -- form's own top-to-bottom order (site/person/description/persons
    -- count rows come before the fire-system questions)
    -- ============================================================
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_site_work_details_html(p_permit_id);

    -- ============================================================
    -- HOT WORK-SPECIFIC: Fire/smoke systems affected/isolated + insurer
    -- notified + isolation comments. Styled to match the shared section
    -- pattern (ptw-lv-section / ptw-lv-section-title) instead of an
    -- ad-hoc box, so it reads consistently with Site & Work Details and
    -- Control Measures rather than looking bolted on. Printed even when
    -- blank so the field's presence on the physical form is visible on
    -- the printed permit, not silently dropped.
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-section section-flow">
        <div class="ptw-lv-section-title">Fire &amp; Smoke Systems</div>
        <div style="padding:8px 12px;">
            <strong>Will any fixed smoke/fire detection or suppression systems be affected
            by these works?</strong> ' || ptw_pro.ptw_pdf_lib_pkg.get_yn_label(v_fire_affected) || '
            &nbsp;&nbsp;<strong>If &lsquo;Yes&rsquo; have they been isolated or impeded?</strong> '
        || ptw_pro.ptw_pdf_lib_pkg.get_yn_label(v_fire_isolated) || '
            <br><strong>Date and time insuring company informed:</strong> '
        || ptw_pro.ptw_pdf_lib_pkg.fmt_datetime(v_insurer_dt) || '
            <br><strong>Comments relating to isolations:</strong> '
        || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_iso_comments) || '
        </div>
    </div>';

    -- ============================================================
    -- SHARED: Control Measures (the 9 numbered items)
    -- ============================================================
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_control_measures_html(p_permit_id);

    -- ============================================================
    -- HOT WORK-SPECIFIC: the two isolation detail fields — these sit
    -- immediately AFTER the numbered Control Measures list on the real
    -- form, not grouped with the Yes/No questions above it. Same
    -- section styling as the box above, for consistency.
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-section section-flow">
        <div class="ptw-lv-section-title">Fire &amp; Smoke System Isolation Details</div>
        <div style="padding:8px 12px;">
            <strong>Details of adequate fire precautions taken when smoke/fire detection
            and/or suppression systems have been isolated (fire extinguishers, blankets, etc.):</strong><br>'
        || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_fire_precautions) || '
            <br><br><strong>Details of adequate means of raising the fire alarm during the works
            and/or during the period when smoke/fire detection and/or suppression systems are
            inhibited:</strong><br>'
        || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_fire_alarm) || '
        </div>
    </div>';

    -- ============================================================
    -- HOT WORK-SPECIFIC: Fire watch log — reads the 6 milestone
    -- signatures from PTW_HOTWORK_FIRE_WATCH. Blank cells for
    -- anything not yet signed, matching the paper form's blank
    -- boxes rather than hiding rows that haven't happened yet.
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-section section-flow">
        <div class="ptw-lv-section-title">Fire Watch Procedures</div>
        <table class="ptw-lv-table" style="font-size:8pt;">
            <thead><tr><th>Milestone</th><th>Signed By</th><th>Date/Time</th><th>Signature</th></tr></thead>
            <tbody>';

    FOR fw_row IN (
        SELECT m.label, fw.signed_by, fw.signed_datetime, fw.signature_blob
        FROM   (SELECT 1 seq, 'HW_COMPLETE' milestone_code, 'Hot Works Completed' label FROM dual UNION ALL
                SELECT 2, 'ATTEND_1ST_HR', '100% Attendance (1st Hour)' FROM dual UNION ALL
                SELECT 3, 'CHECK_15MIN_2ND_HR', 'Checked Every 15 Min (2nd Hour)' FROM dual UNION ALL
                SELECT 4, 'CHECK_30MIN_3RD_HR', 'Checked Every 30 Min (3rd Hour)' FROM dual UNION ALL
                SELECT 5, 'REINSTATE_4TH_HR', 'Reinstate Isolation (4th Hour)' FROM dual UNION ALL
                SELECT 6, 'FIRE_CHECKS_COMPLETE', 'Completion of Fire Checks' FROM dual) m
        LEFT JOIN ptw_pro.ptw_hotwork_fire_watch fw
               ON fw.permit_id = p_permit_id AND fw.milestone_code = m.milestone_code
        ORDER BY m.seq
    ) LOOP
        DBMS_LOB.APPEND(v_html, TO_CLOB(
            '<tr><td><strong style="color:#c0392b;">' || fw_row.label || '</strong></td><td>'
            || ptw_pro.ptw_pdf_lib_pkg.safe_val(fw_row.signed_by) || '</td><td>'
            || ptw_pro.ptw_pdf_lib_pkg.fmt_datetime(fw_row.signed_datetime) || '</td><td>'));
        DBMS_LOB.APPEND(v_html, TO_CLOB(ptw_pro.ptw_pdf_lib_pkg.get_signature_img(fw_row.signature_blob)));
        DBMS_LOB.APPEND(v_html, TO_CLOB('</td></tr>'));
    END LOOP;

    v_html := v_html || '
            </tbody>
        </table>
    </div>';
    -- ============================================================
    -- SHARED: PPE
    -- ============================================================
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_ppe_html(p_permit_id);

    -- ============================================================
    -- HOT WORK HAS EQUIPMENT ISOLATION TOO (confirmed from the real
    -- form — same 4-row table as LV/WAH)
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
    -- FOOTER (5-year retention — word-for-word from the source PDF)
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
    -- MONITORING PAGES — gated on PTW_TYPES.HAS_MONITORING, same
    -- pattern as General/WAH. Already 'Y' for Hot Work (type_id 96).
    -- ============================================================
    IF ptw_pro.ptw_pdf_lib_pkg.type_has_monitoring('HOT WORK') = 'Y' THEN
        v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_monitoring_pages_html(
            p_permit_id, 'Hotwork Monitoring');
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
END generate_ptw_hotwork_pdf;
/
