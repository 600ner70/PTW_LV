
  CREATE OR REPLACE EDITIONABLE FUNCTION "PTW_PRO"."GENERATE_PTW_DRA_PDF" (
    p_dra_id IN NUMBER
) RETURN CLOB
IS
    -- Document control values printed in the footer, as on the pad.
    -- Confirm with BGIS: the pad itself says "MONTH & YEAR" for Issue Date.
    c_doc_revision   CONSTANT VARCHAR2(10) := '1';
    c_doc_issue_date CONSTANT VARCHAR2(30) := 'MONTH &amp; YEAR';
    c_doc_retention  CONSTANT VARCHAR2(30) := '3 Months';

    r           ptw_pro.ptw_lv_dra_assessments%ROWTYPE;
    v_site_name ptw_pro.ptw_lv_sites.site_name%TYPE;
    v_permit_no ptw_pro.ptw_lv_permits.permit_number%TYPE;
    v_title     VARCHAR2(100);
    v_logo_b64  CLOB;
    v_html      CLOB;
    v_last_cat  NUMBER := -1;
    v_letter    PLS_INTEGER := 0;

    FUNCTION esc (p VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN ptw_pro.ptw_pdf_lib_pkg.safe_val(p);
    END;

    -- Value or blank (the pad shows empty boxes, not "-")
    FUNCTION val (p VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE WHEN TRIM(p) IS NULL THEN '&nbsp;' ELSE esc(p) END;
    END;

    FUNCTION box (p_checked BOOLEAN) RETURN VARCHAR2 IS
    BEGIN
        RETURN '<span class="dra-box">' || CASE WHEN p_checked THEN '&#10003;' ELSE '&nbsp;' END || '</span>';
    END;

    PROCEDURE ap (p VARCHAR2) IS
    BEGIN
        DBMS_LOB.APPEND(v_html, TO_CLOB(p));
    END;

    -- Four-across label | tick grid, row-major in item_seq order (same
    -- order as the pad). A short last row stretches its final item.
    PROCEDURE tick_grid (p_section VARCHAR2, p_details VARCHAR2) IS
        TYPE t_items IS TABLE OF VARCHAR2(600) INDEX BY PLS_INTEGER;
        TYPE t_flags IS TABLE OF BOOLEAN       INDEX BY PLS_INTEGER;
        l_lbl   t_items;
        l_tick  t_flags;
        l_n     PLS_INTEGER := 0;
        l_cols  CONSTANT PLS_INTEGER := 4;
        l_rows  PLS_INTEGER;
        l_idx   PLS_INTEGER;
        l_left  PLS_INTEGER;
    BEGIN
        FOR i IN (
            SELECT di.question_text, dr.response
            FROM   ptw_pro.ptw_dra_items di
            LEFT JOIN ptw_pro.ptw_dra_responses dr
                   ON dr.dra_item_id = di.dra_item_id AND dr.dra_id = p_dra_id
            WHERE  di.section_code = p_section
            AND    di.is_active = 'Y'
            ORDER  BY di.item_seq
        ) LOOP
            l_n := l_n + 1;
            l_lbl(l_n)  := esc(i.question_text);
            l_tick(l_n) := (i.response = 'Y');
        END LOOP;

        ap('<table class="dra-grid dra-ticks"><colgroup>'
           || '<col style="width:21%"><col style="width:4%"><col style="width:21%"><col style="width:4%">'
           || '<col style="width:21%"><col style="width:4%"><col style="width:21%"><col style="width:4%">'
           || '</colgroup><tbody>');

        l_rows := CEIL(l_n / l_cols);
        FOR rw IN 1 .. l_rows LOOP
            ap('<tr>');
            l_left := l_n - (rw - 1) * l_cols;           -- items left from this row on
            FOR cl IN 1 .. LEAST(l_cols, l_left) LOOP
                l_idx := (rw - 1) * l_cols + cl;
                IF cl = l_left AND l_left < l_cols THEN
                    -- last item of a short final row spans the gap
                    ap('<td class="dra-tl" colspan="' || (1 + 2 * (l_cols - l_left)) || '">' || l_lbl(l_idx)
                       || '</td><td class="dra-tb">' || box(l_tick(l_idx)) || '</td>');
                ELSE
                    ap('<td class="dra-tl">' || l_lbl(l_idx) || '</td><td class="dra-tb">'
                       || box(l_tick(l_idx)) || '</td>');
                END IF;
            END LOOP;
            ap('</tr>');
        END LOOP;

        ap('<tr><td colspan="8" class="dra-details"><span class="dra-small">Details (and any additional Hazard Information)</span>'
           || '<div class="dra-detail-val">' || val(p_details) || '</div></td></tr>'
           || '</tbody></table>');
    END tick_grid;

BEGIN
    IF p_dra_id IS NULL THEN
        RETURN '<div class="ptw-lv-report-container"><h2 style="color:red;">No DRA Selected</h2></div>';
    END IF;

    BEGIN
        SELECT * INTO r
        FROM   ptw_pro.ptw_lv_dra_assessments
        WHERE  dra_id = p_dra_id;            -- VPD scopes to the caller's company
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN '<div class="ptw-lv-report-container"><h2 style="color:red;">DRA Not Found</h2></div>';
    END;

    IF r.site_id IS NOT NULL THEN
        SELECT MAX(site_name) INTO v_site_name FROM ptw_pro.ptw_lv_sites WHERE site_id = r.site_id;
    END IF;
    IF r.permit_id IS NOT NULL THEN
        SELECT MAX(permit_number) INTO v_permit_no FROM ptw_pro.ptw_lv_permits WHERE permit_id = r.permit_id;
    END IF;

    v_title := CASE r.dra_type
                   WHEN 'SUBCONTRACTOR' THEN 'BGIS Subcontractor Dynamic Risk Assessment'
                   ELSE 'BGIS Dynamic Risk Assessment'
               END;

    DBMS_LOB.CREATETEMPORARY(v_html, TRUE, DBMS_LOB.CALL);
    v_logo_b64 := ptw_pro.ptw_pdf_lib_pkg.get_company_logo_b64(r.company_id);
    DBMS_LOB.APPEND(v_html, ptw_pro.ptw_pdf_lib_pkg.get_document_head(
                                v_title || ' - ' || esc(r.dra_number), 'LV ISOLATION'));

    -- ================= Styles (scoped to .dra) =================
    ap('
<style>
  .dra { font-family: Arial, Helvetica, sans-serif; color:#231F20; font-size:7.5pt; line-height:1.25;
         padding:8px 12px 4px; background:#fff; }
  .dra .navy { color:#223F75; }
  .dra table { font-size:inherit; }
  .dra-keep { break-inside:avoid; page-break-inside:avoid; }
  .dra-top { display:flex; justify-content:space-between; align-items:flex-end; margin-bottom:3px; }
  .dra-refs { font-size:7.5pt; color:#555; }
  .dra-refs b { color:#231F20; }
  .dra-logo img { max-height:38px; max-width:180px; display:block; }
  .dra-title { border:1px solid #231F20; text-align:center; font-weight:700; font-size:13pt;
               color:#223F75; padding:1px 0; margin-bottom:3px; }
  .dra-grid { width:100%; border-collapse:collapse; table-layout:fixed; }
  .dra-grid td { border:1px solid #231F20; padding:2px 5px; vertical-align:top; }
  .dra-lbl { color:#231F20; }
  .dra-v { font-weight:700; }
  .dra-before { text-align:center; font-size:10pt; margin:3px 0 0; }
  .dra-s1head { width:100%; border-collapse:collapse; }
  .dra-s1head td { padding:0 2px 2px; font-weight:700; vertical-align:bottom; }
  .dra-stage { color:#223F75; font-size:10.5pt; width:20%; }
  .dra-stt   { color:#223F75; font-size:11pt; text-align:center; }
  .dra-ynh   { width:34px; text-align:center; font-size:8.5pt; }
  .dra-s1 { width:100%; border-collapse:collapse; border:1px solid #231F20; }
  .dra-s1 td { padding:0 5px; height:12px; line-height:1.15; vertical-align:middle; }
  .dra-s1 tr.dra-cat td { border-top:1px solid #231F20; color:#223F75; font-weight:700; padding-top:2px; }
  .dra-s1 td.dra-yn { width:34px; text-align:center; border-left:1px solid #231F20; }
  .dra-box { display:inline-block; width:9px; height:9px; line-height:9px; border:1px solid #231F20;
             text-align:center; font-size:7pt; font-weight:700; color:#223F75; vertical-align:middle; flex-shrink:0; }
  .dra-h2 { color:#223F75; font-weight:700; font-size:10pt; margin:4px 0 0; }
  .dra-sub { font-size:7.5pt; margin-bottom:2px; }
  .dra-small { font-size:7pt; color:#555; }
  .dra-ticks td { padding:0 3px; vertical-align:middle; }
  .dra-ticks td.dra-tl { text-align:center; font-size:7pt; line-height:1.1; }
  .dra-ticks td.dra-tb { text-align:center; padding:1px 0; }
  .dra-details { height:22px; }
  .dra-detail-val { font-weight:700; margin-top:2px; white-space:pre-wrap; }
  .dra-s3 { margin:4px 0 2px; font-size:8pt; display:flex; align-items:flex-end; gap:5px; flex-wrap:nowrap; white-space:nowrap; }
  .dra-s3 .dra-stage { width:auto; }
  .dra-sig { display:inline-block; flex:1; min-width:110px; height:26px; border-bottom:1px solid #231F20; vertical-align:bottom; }
  .dra-sig img { max-height:26px; max-width:200px; display:block; }
  .dra-sig-meta { font-size:7pt; color:#555; margin-top:2px; }
  .dra-no td { height:32px; }
  .dra-no td.dra-no-l { width:30%; }
  .dra-no-h { color:#223F75; font-weight:700; font-size:9pt; }
  .dra-foot { width:72%; margin:5px auto 1px; border-collapse:collapse; font-size:7pt; text-align:center; }
  .dra-foot td { border:1px solid #231F20; padding:1px 4px; font-weight:700; }
  .dra-gen { text-align:center; font-size:6.5pt; color:#888; }
  .dra-banner { padding:4px 8px; margin:4px 0; font-weight:700; text-align:center; border:1px solid; }
  .dra-banner.draft { background:#fff3cd; border-color:#e0b100; color:#7a5c00; }
  .dra-banner.cancel { background:#f8d7da; border-color:#c0392b; color:#721c24; }
  .dra tr, .dra-ticks tr { page-break-inside:avoid; break-inside:avoid; }
  @media print { .dra { padding:0; } }
</style>
<div class="dra">');

    -- ================= Header =================
    ap('<div class="dra-top"><div class="dra-refs">DRA No.: <b>' || esc(r.dra_number) || '</b>'
       || CASE WHEN v_permit_no IS NOT NULL THEN ' &nbsp;|&nbsp; Related Permit: <b>' || esc(v_permit_no) || '</b>' END
       || CASE WHEN r.dra_type = 'SUBCONTRACTOR'
               THEN ' &nbsp;|&nbsp; Subcontractor: <b>' || esc(r.supervising_company) || '</b>' END
       || '</div><div class="dra-logo">');
    IF v_logo_b64 IS NOT NULL THEN
        ap('<img src="data:image/png;base64,');
        DBMS_LOB.APPEND(v_html, v_logo_b64);
        ap('" alt="Company Logo">');
    END IF;
    ap('</div></div>');

    IF r.workflow_status = 'DRAFT' THEN
        ap('<div class="dra-banner draft">DRAFT - this DRA has not been completed and signed</div>');
    ELSIF r.workflow_status = 'CANCELLED' THEN
        ap('<div class="dra-banner cancel">CANCELLED ' || ptw_pro.ptw_pdf_lib_pkg.fmt_datetime(r.cancel_datetime)
           || ' - ' || esc(r.cancel_reason) || '</div>');
    END IF;

    ap('<div class="dra-title">' || v_title || '</div>');

    -- ================= Details grid =================
    ap('<table class="dra-grid"><colgroup><col style="width:50%"><col style="width:27%"><col style="width:23%"></colgroup><tbody>
        <tr><td rowspan="3"><span class="dra-lbl">Task and Work Location Details:</span>
                <div class="dra-v" style="margin-top:3px;white-space:pre-wrap;">' || val(r.site_details) || '</div></td>
            <td colspan="2"><span class="dra-lbl">Engineer Name:</span> <span class="dra-v">' || val(r.engineer_name) || '</span></td></tr>
        <tr><td colspan="2"><span class="dra-lbl">Client Site:</span> <span class="dra-v">' || val(v_site_name) || '</span></td></tr>
        <tr><td><span class="dra-lbl">Job Number:</span> <span class="dra-v">' || val(r.job_number) || '</span></td>
            <td><span class="dra-lbl">Date:</span> <span class="dra-v">' || TO_CHAR(r.assessment_date, 'DD/MM/YYYY') || '</span></td></tr>
        </tbody></table>');

    -- ================= Stage 1 =================
    ap('<div class="dra-before">Before Attempting Work</div>
        <table class="dra-s1head"><tr>
          <td class="dra-stage">Stage 1</td>
          <td class="dra-stt">STOP &amp; THINK</td>
          <td class="dra-ynh">YES</td><td class="dra-ynh navy">NO</td>
        </tr></table>
        <table class="dra-s1"><tbody>');

    FOR q IN (
        SELECT di.category_no, di.category_label, di.question_text, dr.response
        FROM   ptw_pro.ptw_dra_items di
        LEFT JOIN ptw_pro.ptw_dra_responses dr
               ON dr.dra_item_id = di.dra_item_id AND dr.dra_id = p_dra_id
        WHERE  di.section_code = 'STAGE1'
        AND    di.is_active = 'Y'
        ORDER  BY di.item_seq
    ) LOOP
        IF NVL(q.category_no, -1) <> v_last_cat THEN
            v_last_cat := NVL(q.category_no, -1);
            v_letter   := 0;
            ap('<tr class="dra-cat"><td>' || UPPER(esc(q.category_label)) || '</td>'
               || '<td class="dra-yn"></td><td class="dra-yn"></td></tr>');
        END IF;
        v_letter := v_letter + 1;
        ap('<tr><td>' || CHR(96 + v_letter) || ') ' || esc(q.question_text) || '</td>'
           || '<td class="dra-yn">' || box(q.response = 'YES') || '</td>'
           || '<td class="dra-yn">' || box(q.response = 'NO')  || '</td></tr>');
    END LOOP;
    ap('</tbody></table>');

    -- ================= Stage 2A / 2B =================
    ap('<div class="dra-keep"><div class="dra-h2">Stage 2A Identify Hazards</div>
        <div class="dra-sub">From the list below identify applicable HAZARDS and select your CONTROLS before moving to
          <b class="navy">STAGE 3</b> <span class="dra-small">(there may be others not on this list above)</span></div>');
    tick_grid('HAZARDS', r.hazard_details);
    ap('</div>');

    ap('<div class="dra-keep"><div class="dra-h2">Stage 2B Identify Controls</div>');
    tick_grid('CONTROLS', r.control_details);
    ap('</div>');

    -- ================= Stage 3 =================
    ap('<div class="dra-keep"><div class="dra-s3"><span class="dra-stage" style="font-weight:700;">Stage 3</span>
          <span>Can this task be completed with minimal (tolerable) risk to yourself and others?</span>
          <b>YES</b> ' || box(r.stage3_can_proceed = 'YES') ||
        ' <b class="navy">NO</b> ' || box(r.stage3_can_proceed = 'NO') ||
        ' <span>Signature:</span> <span class="dra-sig">');
    IF r.signature IS NOT NULL THEN
        DBMS_LOB.APPEND(v_html, ptw_pro.ptw_pdf_lib_pkg.get_signature_img(r.signature));
    ELSE
        ap('&nbsp;');
    END IF;
    ap('</span></div>');

    ap('<table class="dra-grid dra-no"><tbody><tr>
          <td class="dra-no-l"><div class="dra-no-h">If NO, Do NOT Proceed</div>
              Refer to your supervisor / line manager and record your reasons here:</td>
          <td class="dra-v" style="white-space:pre-wrap;">'
          || CASE WHEN r.stage3_can_proceed = 'NO' THEN val(r.stage3_no_reason) ELSE '&nbsp;' END ||
       '</td></tr></tbody></table>');
    IF r.signed_datetime IS NOT NULL THEN
        ap('<div class="dra-sig-meta">Signed by ' || esc(r.signature_person_name) || ' on '
           || ptw_pro.ptw_pdf_lib_pkg.fmt_datetime(r.signed_datetime) || '</div>');
    END IF;
    ap('</div>');

    -- ================= Footer (document control, as on the pad) =================
    ap('<table class="dra-foot"><tbody>
          <tr><td>Document Title:</td><td>Revision:</td><td>Issue Date:</td><td>Retention Period:</td></tr>
          <tr><td>BGIS Dynamic Risk Assessment</td><td>' || c_doc_revision || '</td><td>'
              || c_doc_issue_date || '</td><td>' || c_doc_retention || '</td></tr>
        </tbody></table>
        <div class="dra-gen">Generated ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI') || ' &nbsp;|&nbsp; '
        || esc(r.dra_number) || '</div>
</div>');

    DBMS_LOB.APPEND(v_html, ptw_pro.ptw_pdf_lib_pkg.get_document_close);
    RETURN v_html;

EXCEPTION
    WHEN OTHERS THEN
        RETURN '<html><body><h2 style="color:red;">Error Generating DRA Report</h2>'
            || '<p>' || SQLERRM || '</p><pre>' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || '</pre></body></html>';
END generate_ptw_dra_pdf;
/
