
  CREATE OR REPLACE EDITIONABLE FUNCTION "PTW_PRO"."GENERATE_PTW_FIREISOLATION_PDF" (
    p_permit_id       IN NUMBER,
    p_include_history IN VARCHAR2 DEFAULT 'N'
) RETURN CLOB
IS
    v_permit_number        ptw_pro.ptw_lv_permits.permit_number%TYPE;
    v_company_id           ptw_pro.ptw_lv_permits.company_id%TYPE;
    v_client_perm          ptw_pro.ptw_lv_permits.client_permission_granted%TYPE;
    v_affects_it           ptw_pro.ptw_lv_permits.affects_it_systems%TYPE;
    v_it_perm              ptw_pro.ptw_lv_permits.it_permission_granted%TYPE;
    v_fire_affected        ptw_pro.ptw_lv_permits.fire_systems_affected%TYPE;
    v_fire_isolated        ptw_pro.ptw_lv_permits.fire_systems_isolated%TYPE;
    v_insurance_necessary  ptw_pro.ptw_lv_permits.insurance_necessary%TYPE;
    v_insurer_informed_dt  ptw_pro.ptw_lv_permits.insurer_informed_datetime%TYPE;
    v_isolation_comments   ptw_pro.ptw_lv_permits.isolation_comments%TYPE;
    v_fire_precautions     ptw_pro.ptw_lv_permits.fire_precautions_details%TYPE;
    v_fire_alarm_arr       ptw_pro.ptw_lv_permits.fire_alarm_arrangements%TYPE;
    v_xref_permit_number   ptw_pro.ptw_lv_permits.permit_number%TYPE;
    v_logo_b64             CLOB;
    v_html                 CLOB;
    v_row_num              NUMBER := 0;

BEGIN
    DBMS_LOB.CREATETEMPORARY(v_html, TRUE, DBMS_LOB.CALL);

    IF p_permit_id IS NULL THEN
        RETURN '<div class="ptw-lv-report-container"><h2 style="color:red;">No Permit Selected</h2></div>';
    END IF;

    BEGIN
        SELECT permit_number, company_id, client_permission_granted,
               affects_it_systems, it_permission_granted,
               fire_systems_affected, fire_systems_isolated,
               insurance_necessary, insurer_informed_datetime, isolation_comments,
               fire_precautions_details, fire_alarm_arrangements
        INTO   v_permit_number, v_company_id, v_client_perm,
               v_affects_it, v_it_perm,
               v_fire_affected, v_fire_isolated,
               v_insurance_necessary, v_insurer_informed_dt, v_isolation_comments,
               v_fire_precautions, v_fire_alarm_arr
        FROM   ptw_pro.ptw_lv_permits
        WHERE  permit_id = p_permit_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN '<div class="ptw-lv-report-container"><h2 style="color:red;">Permit Not Found</h2>'
                || '<p>Permit ID: ' || p_permit_id || '</p></div>';
    END;

    -- Cross-reference: the linked permit (via PTW_PERMIT_LINKS_V) whose
    -- own type is HOT WORK, shown as a header banner reference only -
    -- no data is pulled in from that permit. If more than one is linked
    -- (unusual but not prevented), the most recently created link wins.
    BEGIN
        SELECT op.permit_number
        INTO   v_xref_permit_number
        FROM   ptw_pro.ptw_permit_links_v lv
        JOIN   ptw_pro.ptw_lv_permits op ON op.permit_id = lv.other_permit_id
        WHERE  lv.permit_id = p_permit_id
        AND    op.ptw_type  = 'HOT WORK'
        ORDER  BY lv.created_date DESC
        FETCH FIRST 1 ROW ONLY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_xref_permit_number := NULL;
    END;

    v_logo_b64 := ptw_pro.ptw_pdf_lib_pkg.get_company_logo_b64(v_company_id);

    v_html := ptw_pro.ptw_pdf_lib_pkg.get_document_head(
        'Fire Systems Isolation - ' || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_permit_number),
        'FIRE SYSTEMS ISOLATION');

    -- ============================================================
    -- HEADER - cross-reference banner (mirrors the source form's own
    -- top banner: "Fire Isolation: Hot Work Permit No. ___ has been
    -- raised to supplement this Fire Isolation Certificate. No. ___"),
    -- title, then the caution strip (present on the source, missing
    -- from v1).
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-header">
        <div style="display:flex;justify-content:space-between;
                    align-items:center;margin-bottom:8px;">
            <h1 style="margin:0;">Fire Systems Isolation Certificate</h1>';

    IF v_logo_b64 IS NOT NULL THEN
        v_html := v_html || '<img src="data:image/png;base64,';
        DBMS_LOB.APPEND(v_html, v_logo_b64);
        v_html := v_html || '" style="max-height:40px;margin-left:20px;" alt="Company Logo" />';
    END IF;

    v_html := v_html || '
        </div>
        <div class="header-refs">
            <div>Certificate No.:<br><strong>'
        || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_permit_number) || '</strong></div>
            <div>Hot Work Permit No.:<br><strong>' ||
                NVL(ptw_pro.ptw_pdf_lib_pkg.safe_val(v_xref_permit_number), 'Not linked') || '</strong></div>
        </div>
    </div>
    <div style="padding:5px 12px;font-size:7.5pt;color:#555;
                border-bottom:1px solid #c0c0c0;">
        This certificate must be correctly authorised. On expiry, return all copies of this certificate
        to the certificate Issuer. Do not leave site until this certificate is cancelled.
    </div>';

    -- ============================================================
    -- SHARED: Site & Work Details
    -- ============================================================
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_site_work_details_html(p_permit_id);

    -- ============================================================
    -- CLIENT PERMISSION / IT SYSTEMS / FIRE SYSTEMS / INSURANCE -
    -- bespoke, self-contained. Covers every question in the source
    -- form's top block that isn't already in Site & Work Details.
    --
    -- Rendered as a bordered 2-question-per-row grid (.ptw-lv-detail-grid,
    -- shared with Site & Work Details above - see
    -- ptw_pdf_lib_pkg.get_document_head) instead of one full-width
    -- question per row, matching the denser grid look of the source
    -- form's own Yes/No question block.
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Client Permission / Fire &amp; Smoke Systems / Insurance</div>
        <table class="ptw-lv-detail-grid">
            <tr>
                <td class="g-label">Has the client granted permission for these works to proceed?</td>
                <td class="g-value">' || ptw_pro.ptw_pdf_lib_pkg.get_yn(v_client_perm) || '</td>
                <td class="g-label">Is it necessary to inform the insurance company of this activity?</td>
                <td class="g-value">' || ptw_pro.ptw_pdf_lib_pkg.get_yn(v_insurance_necessary) || '</td>
            </tr>';

    IF v_insurance_necessary = 'Y' THEN
        v_html := v_html || '
            <tr>
                <td class="g-label-wide">Date and time insurance company informed</td>
                <td class="g-value-wide" colspan="3">' || ptw_pro.ptw_pdf_lib_pkg.fmt_datetime(v_insurer_informed_dt) || '</td>
            </tr>';
    END IF;

    v_html := v_html || '
            <tr>
                <td class="g-label">Will any fixed smoke/fire detection or suppression systems be affected?</td>
                <td class="g-value">' || ptw_pro.ptw_pdf_lib_pkg.get_yn(v_fire_affected) || '</td>
                <td class="g-label">If &lsquo;Yes&rsquo;, have they been isolated or impeded?</td>
                <td class="g-value">' || ptw_pro.ptw_pdf_lib_pkg.get_yn(v_fire_isolated) || '</td>
            </tr>
            <tr>
                <td class="g-label">Will these works affect any IT or other business critical systems?</td>
                <td class="g-value">' || ptw_pro.ptw_pdf_lib_pkg.get_yn(v_affects_it) || '</td>
                <td class="g-label">If &lsquo;Yes&rsquo;, has permission been granted to proceed?</td>
                <td class="g-value">' || ptw_pro.ptw_pdf_lib_pkg.get_yn(v_it_perm) || '</td>
            </tr>
        </table>';

    v_html := v_html || '
    </div>';

    -- ============================================================
    -- FIRE PRECAUTIONS / FIRE ALARM ARRANGEMENTS - free text, both
    -- present on the source form under the Client Permission block.
    -- ============================================================
    IF v_fire_precautions IS NOT NULL OR v_fire_alarm_arr IS NOT NULL THEN
        v_html := v_html || '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Fire Precautions &amp; Alarm Arrangements</div>';

        IF v_fire_precautions IS NOT NULL THEN
            v_html := v_html || '
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Details of adequate fire precautions taken when smoke/fire detection and/or suppression systems have been isolated (fire extinguishers, blankets, etc.)</div>
            <div class="ptw-lv-value">' || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_fire_precautions) || '</div>
        </div>';
        END IF;

        IF v_fire_alarm_arr IS NOT NULL THEN
            v_html := v_html || '
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Details of adequate means of raising the fire alarm during the works and/or during the period when smoke/fire detection and/or suppression systems are inhibited</div>
            <div class="ptw-lv-value">' || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_fire_alarm_arr) || '</div>
        </div>';
        END IF;

        v_html := v_html || '
    </div>';
    END IF;

    -- ============================================================
    -- CONTROL MEASURES - bespoke 2-column (Tick / N/A) table, matching
    -- the source form (which has no "No" column, only Tick/N/A). NOT
    -- ptw_pdf_lib_pkg.get_control_measures_html (3-column, shared and
    -- untouched for every other type).
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-section section-flow">
        <div class="ptw-lv-section-title">Control Measures which must be in place before issuing this Fire Systems Isolation Certificate</div>
        <table class="ptw-lv-table">
            <thead>
                <tr>
                    <th class="cm-number">No.</th>
                    <th>Control Measure</th>
                    <th class="cm-tick">Tick, confirming compliance</th>
                    <th class="cm-tick">N/A</th>
                </tr>
            </thead>
            <tbody>';

    FOR cm_item IN (
        SELECT ci.item_seq, ci.question_text, cr.response
        FROM   ptw_pro.ptw_checklist_items ci
        JOIN   ptw_pro.ptw_lv_permits p ON p.permit_id = p_permit_id
        JOIN   ptw_pro.ptw_types t       ON t.ptw_type = p.ptw_type AND t.type_id = ci.type_id
        LEFT JOIN ptw_pro.ptw_checklist_responses cr
               ON cr.checklist_item_id = ci.checklist_item_id AND cr.permit_id = p_permit_id
        WHERE  ci.section_code = 'CONTROL_MEASURES'
        AND    ci.is_active = 'Y'
        ORDER BY ci.item_seq
    ) LOOP
        v_row_num := v_row_num + 1;
        DBMS_LOB.APPEND(v_html, TO_CLOB('
                <tr><td class="cm-number">' || v_row_num || '</td>
                    <td>' || ptw_pro.ptw_pdf_lib_pkg.safe_val(cm_item.question_text) || '</td>
                    <td class="cm-tick">' || ptw_pro.ptw_pdf_lib_pkg.get_cm_tick(cm_item.response) || '</td>
                    <td class="cm-tick">' || ptw_pro.ptw_pdf_lib_pkg.get_cm_na(cm_item.response)   || '</td></tr>'));
    END LOOP;

    v_html := v_html || '
            </tbody>
        </table>
    </div>';

    -- ============================================================
    -- FIRE WATCH PROCEDURES - this certificate's OWN sign-offs only
    -- (PTW_HOTWORK_FIRE_WATCH.permit_id = p_permit_id). Same table,
    -- same 6 milestones, same query shape as
    -- GENERATE_PTW_HOTWORK_PDF - see v5 note above.
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
    -- SHARED: Equipment Isolation - relabelled for this type
    -- ============================================================
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_equipment_isolation_html(p_permit_id, 'FIRE SYSTEMS ISOLATION');

    -- ============================================================
    -- COMMENTS
    -- ============================================================
    IF v_isolation_comments IS NOT NULL THEN
        v_html := v_html || '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Comments &amp; References to Associated Safety Documentation</div>
        <div class="ptw-lv-value" style="padding:6px 12px;">' || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_isolation_comments) || '</div>
    </div>';
    END IF;

    -- ============================================================
    -- SHARED: Authorisation / Acceptance / Clearance / Cancellation
    -- - falls through to the existing DEFAULT wording branch.
    -- ============================================================
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_authorisation_html(p_permit_id, 'FIRE SYSTEMS ISOLATION');
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_acceptance_html(p_permit_id, 'FIRE SYSTEMS ISOLATION');
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_clearance_html(p_permit_id, 'FIRE SYSTEMS ISOLATION');
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_cancellation_html(p_permit_id, 'FIRE SYSTEMS ISOLATION');

    -- ============================================================
    -- FOOTER - 5-year retention text, word-for-word from source PDF
    -- ============================================================
    v_html := v_html || '
    <div class="footer">
        During the works the Original copy shall be retained by the &lsquo;Authorised Person&rsquo;
        and the copy shall be retained by the &lsquo;Person in Charge&rsquo; of the work and must
        have it available at all times for inspection. On completion of the works, the copy must be
        returned and both parts are signed when cancelling this Permit. Retention period 5 years.
        <br>Generated: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI') ||
        ' &nbsp;|&nbsp; Fire Systems Isolation Certificate: ' || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_permit_number) || '
    </div>';

    -- ============================================================
    -- MONITORING - corrected from v1: this type DOES have monitoring.
    -- ============================================================
    IF ptw_pro.ptw_pdf_lib_pkg.type_has_monitoring('FIRE SYSTEMS ISOLATION') = 'Y' THEN
        v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_monitoring_pages_html(
            p_permit_id, 'Fire System Isolation Monitoring', 'FIRE SYSTEMS ISOLATION');
    END IF;

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
END generate_ptw_fireisolation_pdf;
/
