
  CREATE OR REPLACE EDITIONABLE FUNCTION "PTW_PRO"."GENERATE_PTW_LOA_PDF" (
    p_permit_id       IN NUMBER,
    p_include_history IN VARCHAR2 DEFAULT 'N'
) RETURN CLOB
IS
    v_permit_number   ptw_pro.ptw_lv_permits.permit_number%TYPE;
    v_company_id      ptw_pro.ptw_lv_permits.company_id%TYPE;
    v_client_perm     ptw_pro.ptw_lv_permits.client_permission_granted%TYPE;
    v_affects_it      ptw_pro.ptw_lv_permits.affects_it_systems%TYPE;
    v_it_perm         ptw_pro.ptw_lv_permits.it_permission_granted%TYPE;
    v_logo_b64        CLOB;
    v_html            CLOB;
    v_row_num         NUMBER := 0;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_html, TRUE, DBMS_LOB.CALL);

    IF p_permit_id IS NULL THEN
        RETURN '<div class="ptw-lv-report-container"><h2 style="color:red;">No Permit Selected</h2></div>';
    END IF;

    BEGIN
        SELECT permit_number, company_id, client_permission_granted,
               affects_it_systems, it_permission_granted
        INTO   v_permit_number, v_company_id, v_client_perm,
               v_affects_it, v_it_perm
        FROM   ptw_pro.ptw_lv_permits
        WHERE  permit_id = p_permit_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN '<div class="ptw-lv-report-container"><h2 style="color:red;">Permit Not Found</h2>'
                || '<p>Permit ID: ' || p_permit_id || '</p></div>';
    END;

    v_logo_b64 := ptw_pro.ptw_pdf_lib_pkg.get_company_logo_b64(v_company_id);

    v_html := ptw_pro.ptw_pdf_lib_pkg.get_document_head(
        'Limitation of Access - ' || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_permit_number),
        'LIMITATION OF ACCESS');

    -- ============================================================
    -- HEADER — navy banner (matches the source form's colour bar),
    -- permit number, then a genuinely prominent "NOT a Permit-to-Work"
    -- warning strip (bolder than the source's own small italic line,
    -- per your request), then the caution instruction line verbatim
    -- from the source form (previously missing entirely).
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-header" style="background:#789abd;color:#fff;">
        <div style="display:flex;justify-content:space-between;
                    align-items:center;margin-bottom:8px;">
            <h1 style="margin:0;color:#fff;">Limitation of Access &mdash; Electrical</h1>';

    IF v_logo_b64 IS NOT NULL THEN
        v_html := v_html || '<img src="data:image/png;base64,';
        DBMS_LOB.APPEND(v_html, v_logo_b64);
        v_html := v_html || '" style="max-height:40px;margin-left:20px;background:#fff;padding:3px 6px;border-radius:3px;" alt="Company Logo" />';
    END IF;

    v_html := v_html || '
        </div>
        <div class="header-refs" style="border-top:1px solid rgba(255,255,255,0.25);">
            <div style="color:#fff;">Limitation of Access No.:<br><strong>'
        || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_permit_number) || '</strong></div>
        </div>
    </div>
    <div style="background:#e8b830;color:#1a1a1a;padding:7px 12px;
                font-weight:700;font-size:10.5pt;text-align:center;
                letter-spacing:0.4px;text-transform:uppercase;
                border-bottom:1px solid #c0c0c0;">
        &#9888; This is NOT a Permit-to-Work
    </div>
    <div style="padding:5px 12px;font-size:7.5pt;color:#555;
                border-bottom:1px solid #c0c0c0;">
        This LoA must be correctly authorised. On expiry, return all copies of this LoA
        to the LoA Issuer. Do not leave site until this LoA is cancelled.
    </div>';

    -- ============================================================
    -- SHARED: Site & Work Details
    -- ============================================================
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_site_work_details_html(p_permit_id);

    -- ============================================================
    -- CLIENT PERMISSION — bespoke, self-contained. No shared
    -- ptw_pdf_lib_pkg function currently prints this for any type, so
    -- this is written directly rather than extending shared code.
    -- Wording matches Page 2's P2_CLIENT_PERMISSION_GRANTED /
    -- P2_AFFECTS_IT_SYSTEMS / P2_IT_PERMISSION_GRANTED labels exactly.
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Client Permission</div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Has the client granted permission for these works to proceed?</div>
            <div class="ptw-lv-value">' || ptw_pro.ptw_pdf_lib_pkg.get_yn(v_client_perm) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Will these works affect any IT or other business critical systems?</div>
            <div class="ptw-lv-value">' || ptw_pro.ptw_pdf_lib_pkg.get_yn(v_affects_it) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">If &lsquo;Yes&rsquo;, has permission been granted to proceed?</div>
            <div class="ptw-lv-value">' || ptw_pro.ptw_pdf_lib_pkg.get_yn(v_it_perm) || '</div>
        </div>
    </div>';

    -- ============================================================
    -- CONTROL MEASURES — bespoke 2-column (Tick / N/A) table, matching
    -- the source form exactly. NOT ptw_pdf_lib_pkg.get_control_measures_html
    -- (which renders 3 columns: Yes/No/N/A) — that function is shared by
    -- every type, so it's left untouched; this type just doesn't call it.
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-section section-flow">
        <div class="ptw-lv-section-title">Control Measures which must be in place before issuing this Limitation of Access</div>
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
    -- SHARED: PPE, Equipment Isolation
    -- ============================================================
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_ppe_html(p_permit_id);
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_equipment_isolation_html(p_permit_id);

    -- ============================================================
    -- SHARED: Authorisation / Acceptance / Clearance / Cancellation —
    -- LIMITATION OF ACCESS wording branches already added to
    -- ptw_pdf_lib_pkg (previous fix).
    -- ============================================================
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_authorisation_html(p_permit_id, 'LIMITATION OF ACCESS');
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_acceptance_html(p_permit_id, 'LIMITATION OF ACCESS');
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_clearance_html(p_permit_id, 'LIMITATION OF ACCESS');
    v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_cancellation_html(p_permit_id, 'LIMITATION OF ACCESS');

    -- ============================================================
    -- FOOTER — 5-year retention text, word-for-word from source PDF
    -- ============================================================
    v_html := v_html || '
    <div class="footer">
        During the works the Original copy shall be retained by the &lsquo;Authorised Person&rsquo;
        and the copy shall be retained by the &lsquo;Person in Charge&rsquo; of the work and must
        have it available at all times for inspection. On completion of the works, the copy must be
        returned and both parts are signed when cancelling this Limitation Document. Retention period 5 years.
        <br>Generated: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI') ||
        ' &nbsp;|&nbsp; Limitation of Access: ' || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_permit_number) || '
    </div>';

    IF ptw_pro.ptw_pdf_lib_pkg.type_has_monitoring('LIMITATION OF ACCESS') = 'Y' THEN
        v_html := v_html || ptw_pro.ptw_pdf_lib_pkg.get_monitoring_pages_html(
            p_permit_id, 'Limitation of Access Monitoring');
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
END generate_ptw_loa_pdf;
/
