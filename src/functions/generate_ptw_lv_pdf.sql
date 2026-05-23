create or replace FUNCTION generate_ptw_lv_pdf (
    p_permit_id       IN NUMBER,
    p_include_history IN VARCHAR2 DEFAULT 'N'
) RETURN CLOB

IS
    v_permit     ptw_pro.ptw_lv_permits%ROWTYPE;
    v_cm         ptw_pro.ptw_lv_control_measures%ROWTYPE;
    v_html       CLOB;
    v_mon_count  NUMBER := 0;
    v_mon_num    NUMBER := 0;

    CURSOR c_isolation IS
        SELECT *
        FROM   ptw_pro.ptw_lv_equipment_isolation
        WHERE  permit_id = p_permit_id
        ORDER  BY row_number;

    CURSOR c_monitoring IS
        SELECT *
        FROM   ptw_pro.ptw_lv_monitoring
        WHERE  permit_id = p_permit_id
        ORDER  BY created_date ASC;

    -- ============================================================
    -- HELPER FUNCTIONS
    -- ============================================================

    FUNCTION safe_val (p_text VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN NVL(REPLACE(REPLACE(SUBSTR(p_text, 1, 4000), '<', '&lt;'), '>', '&gt;'), '-');
    END;

    FUNCTION safe_num (p_num NUMBER) RETURN VARCHAR2 IS
    BEGIN
        RETURN NVL(TO_CHAR(p_num), '-');
    END;

    FUNCTION get_yn (p_value VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE p_value
            WHEN 'Y'  THEN '<span class="status-badge status-yes">Yes</span>'
            WHEN 'N'  THEN '<span class="status-badge status-no">No</span>'
            WHEN 'NA' THEN '<span class="status-badge status-na">N/A</span>'
            ELSE '-'
        END;
    END;

    FUNCTION get_yn_label (p_value VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE p_value
            WHEN 'Y' THEN 'completed'
            WHEN 'N' THEN 'not complete'
            ELSE '(not recorded)'
        END;
    END;

    FUNCTION get_safe_label (p_value VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE p_value
            WHEN 'Y' THEN 'safe'
            WHEN 'N' THEN 'not safe'
            ELSE '(not recorded)'
        END;
    END;

    FUNCTION get_checked (p_value VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE WHEN p_value = 'Y' THEN '&#9745;' ELSE '&#9744;' END;
    END;

    FUNCTION get_cm_tick (p_value VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE p_value WHEN 'Y'  THEN '<span class="tick-mark">&#10003;</span>' ELSE '' END;
    END;

    FUNCTION get_cm_na (p_value VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE p_value WHEN 'NA' THEN '<span class="na-mark">N/A</span>' ELSE '' END;
    END;

    FUNCTION get_cm_no (p_value VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE p_value WHEN 'N'  THEN '<span class="no-mark">&#10007;</span>' ELSE '' END;
    END;

    FUNCTION fmt_datetime (p_date DATE) RETURN VARCHAR2 IS
    BEGIN
        RETURN NVL(TO_CHAR(p_date, 'DD-MON-YYYY HH24:MI'), '-');
    END;

    FUNCTION fmt_date (p_date DATE) RETURN VARCHAR2 IS
    BEGIN
        RETURN NVL(TO_CHAR(p_date, 'DD-MON-YYYY'), '-');
    END;

    FUNCTION get_signature_img (p_blob BLOB) RETURN CLOB IS
        v_base64 CLOB;
        v_result CLOB;
    BEGIN
        IF p_blob IS NULL OR DBMS_LOB.GETLENGTH(p_blob) = 0 THEN
            RETURN TO_CLOB('<p style="color:#999;font-style:italic;text-align:center;'
                        || 'margin:0;padding:15px 0;">No signature captured</p>');
        END IF;
        BEGIN
            v_base64 := APEX_WEB_SERVICE.BLOB2CLOBBASE64(p_blob);
            v_result := TO_CLOB('<img src="data:image/png;base64,');
            DBMS_LOB.APPEND(v_result, v_base64);
            DBMS_LOB.APPEND(v_result, TO_CLOB('" class="signature-image" alt="Signature" />'));
            RETURN v_result;
        EXCEPTION
            WHEN OTHERS THEN
                DECLARE
                    v_chunk    VARCHAR2(32767);
                    v_pos      NUMBER := 1;
                    v_length   NUMBER := DBMS_LOB.GETLENGTH(p_blob);
                    v_chunk_sz NUMBER := 12000;
                BEGIN
                    v_result := TO_CLOB('<img src="data:image/png;base64,');
                    WHILE v_pos <= v_length LOOP
                        v_chunk := UTL_RAW.CAST_TO_VARCHAR2(
                            UTL_ENCODE.BASE64_ENCODE(
                                DBMS_LOB.SUBSTR(p_blob, LEAST(v_chunk_sz, v_length - v_pos + 1), v_pos)
                            )
                        );
                        v_chunk := REPLACE(REPLACE(v_chunk, CHR(10), ''), CHR(13), '');
                        DBMS_LOB.APPEND(v_result, TO_CLOB(v_chunk));
                        v_pos := v_pos + v_chunk_sz;
                    END LOOP;
                    DBMS_LOB.APPEND(v_result, TO_CLOB('" class="signature-image" alt="Signature" />'));
                    RETURN v_result;
                END;
        END;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN TO_CLOB('<p style="color:#c0392b;font-style:italic;text-align:center;'
                        || 'margin:0;font-size:8pt;">Error loading signature</p>');
    END;

-- ============================================================
-- MAIN BODY
-- ============================================================
BEGIN
    IF p_permit_id IS NULL THEN
        RETURN '<div class="ptw-lv-report-container">'
            || '<h2 style="color:red;">No Permit Selected</h2></div>';
    END IF;

    BEGIN
        SELECT * INTO v_permit
        FROM   ptw_pro.ptw_lv_permits
        WHERE  permit_id = p_permit_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN '<div class="ptw-lv-report-container">'
                || '<h2 style="color:red;">Permit Not Found</h2>'
                || '<p>Permit ID: ' || p_permit_id || '</p></div>';
    END;

    BEGIN
        SELECT * INTO v_cm
        FROM   ptw_pro.ptw_lv_control_measures
        WHERE  permit_id = p_permit_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
    END;

    SELECT COUNT(*) INTO v_mon_count
    FROM   ptw_pro.ptw_lv_monitoring
    WHERE  permit_id = p_permit_id;

    -- ============================================================
    -- HTML DOCUMENT + CSS
    -- ============================================================
    v_html := '<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Permit to Work LV-Electrical - ' || safe_val(v_permit.permit_number) || '</title>
<style>
    @page { size: A4; margin: 12mm; }
    body {
        font-family: Arial, Helvetica, sans-serif;
        font-size: 9pt; color: #333; margin: 0; padding: 0;
    }
    .ptw-lv-report-container { max-width: 780px; margin: 0 auto; }

    .ptw-lv-header {
        background: #003366; color: white;
        padding: 12px 16px; border-radius: 4px 4px 0 0;
    }
    .ptw-lv-header h1 {
        margin: 0 0 6px 0; font-size: 13pt;
        letter-spacing: 0.5px; text-transform: uppercase;
    }
    .header-refs {
        display: flex; gap: 10px; font-size: 8pt;
        border-top: 1px solid rgba(255,255,255,0.3);
        padding-top: 6px; margin-top: 4px;
    }
    .header-refs div { flex: 1; }

    .ptw-lv-section { border: 1px solid #c0c0c0; border-top: none; }
    .ptw-lv-section-title {
        background: #003366; color: white;
        padding: 5px 12px; font-weight: 700; font-size: 8.5pt;
        text-transform: uppercase; letter-spacing: 0.3px;
    }
    .ptw-lv-section-subtitle {
        background: #dce6f0; color: #003366;
        padding: 4px 12px; font-weight: 700; font-size: 8pt;
        border-bottom: 1px solid #c0c0c0;
    }

    .ptw-lv-row {
        display: flex; padding: 4px 12px;
        border-bottom: 1px solid #eee; font-size: 8.5pt;
        align-items: flex-start;
    }
    .ptw-lv-row:last-child { border-bottom: none; }
    .ptw-lv-label { width: 42%; font-weight: 600; color: #333; padding-right: 8px; }
    .ptw-lv-value { width: 58%; }

    .ptw-lv-table { width: 100%; border-collapse: collapse; font-size: 8.5pt; }
    .ptw-lv-table th {
        background: #dce6f0; color: #003366;
        padding: 5px 8px; text-align: left; font-weight: 700;
        border: 1px solid #c0c0c0; font-size: 8pt;
    }
    .ptw-lv-table td {
        padding: 4px 8px; border: 1px solid #c0c0c0; vertical-align: middle;
    }
    .cm-number { width: 28px; text-align: center; font-weight: 700; background: #f5f5f5; }
    .cm-tick   { width: 55px; text-align: center; }

    .ppe-grid { display: flex; flex-wrap: wrap; padding: 6px 12px; }
    .ppe-item { width: 50%; padding: 2px 0; font-size: 8.5pt; }

    .status-badge {
        display: inline-block; padding: 1px 7px; border-radius: 8px;
        font-size: 7.5pt; font-weight: 700;
    }
    .status-yes { background: #d4edda; color: #155724; }
    .status-no  { background: #f8d7da; color: #721c24; }
    .status-na  { background: #e2e3e5; color: #383d41; }

    .tick-mark { color: #155724; font-weight: bold; font-size: 11pt; }
    .na-mark   { color: #666; font-style: italic; font-size: 8pt; }
    .no-mark   { color: #dc3545; font-weight: 700; font-size: 11pt; }

    .declaration-box {
        padding: 7px 12px; background: #f8f9fa;
        border-left: 3px solid #003366;
        font-size: 8pt; line-height: 1.6; margin: 0; font-style: italic;
    }

    .signature-box {
        border: 1px solid #bbb; min-height: 55px;
        padding: 4px; text-align: center;
        background: #fff; margin: 3px 0;
    }
    .signature-image { max-width: 100%; max-height: 75px; display: block; margin: 0 auto; }

    .page-break { page-break-before: always; }

    .footer {
        border-top: 1px solid #ddd; margin-top: 6px;
        padding: 6px 12px; font-size: 7pt; color: #888; text-align: center;
    }

    /* ── Permit History section ─────────────────────────────── */
    .history-section {
        border: 1px solid #c0c0c0;
        border-top: none;
        margin-top: 0;
    }
    .history-section .ptw-lv-section-title {
        background: #1a3a5c;
    }
    .history-table {
        width: 100%; border-collapse: collapse; font-size: 8.5pt;
    }
    .history-table th {
        background: #dce6f0; color: #003366;
        padding: 5px 8px; text-align: left; font-weight: 700;
        border: 1px solid #c0c0c0; font-size: 8pt;
    }
    .history-table td {
        padding: 5px 8px; border: 1px solid #c0c0c0;
        vertical-align: middle;
    }
    .history-table tr:nth-child(even) td {
        background: #f7f9fc;
    }
    .history-step-badge {
        display: inline-block;
        background: #003366; color: #fff;
        padding: 2px 8px; border-radius: 10px;
        font-size: 7.5pt; font-weight: 700;
        white-space: nowrap;
    }
    .history-no-data {
        padding: 12px; font-style: italic;
        color: #888; font-size: 8pt; text-align: center;
    }

    @media print {
        body { font-size: 8pt; }
        .ptw-lv-section { page-break-inside: avoid; }
        .history-section { page-break-inside: avoid; }
    }
</style>
</head>
<body>
<div class="ptw-lv-report-container">';

    -- ============================================================
    -- PAGE 1 HEADER
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-header">
        <h1>Permit to Work &mdash; LV Electrical</h1>
        <div class="header-refs">
            <div>Safety Programme Reference No.:<br>
                <strong>' || safe_val(v_permit.safety_programme_ref_no) || '</strong></div>
            <div>Isolation &amp; Earthing Diagram Serial No.:<br>
                <strong>' || safe_val(v_permit.isolation_diagram_serial_no) || '</strong></div>
            <div>Permit to Work No.:<br>
                <strong>' || safe_val(v_permit.permit_number) || '</strong></div>
        </div>
    </div>';

    -- ============================================================
    -- SITE & WORK DETAILS
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Site &amp; Work Details</div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Site details and area of works:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.site_details) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Description of work activity:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.work_description) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Name of Person in Charge:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.person_in_charge_name) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Company responsible for supervising the works:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.supervising_company) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Number of other persons working under this Permit:</div>
            <div class="ptw-lv-value">' || safe_num(v_permit.other_persons_count) || '</div>
        </div>
    </div>';

    -- ============================================================
    -- CONTROL MEASURES (16 items)
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Control Measures</div>
        <table class="ptw-lv-table">
            <thead>
                <tr>
                    <th class="cm-number">No.</th>
                    <th>Control Measure</th>
                    <th class="cm-tick">&#10003; Yes</th>
                    <th class="cm-tick">&#10007; No</th>
                    <th class="cm-tick">N/A</th>
                </tr>
            </thead>
            <tbody>
                <tr><td class="cm-number">1</td>
                    <td>All persons working under this PTW have received and signed, as understood,
                        a suitable site induction?</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_01_site_induction) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_01_site_induction)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_01_site_induction)   || '</td></tr>
                <tr><td class="cm-number">2</td>
                    <td>A suitable and sufficient written risk assessment and method statement for
                        these works, which has already been understood by all persons working under
                        this permit is in place and has been reviewed at the point of works by the
                        person controlling the works. This must include the provision of an emergency
                        evacuation plan.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_02_risk_assessment) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_02_risk_assessment)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_02_risk_assessment)   || '</td></tr>
                <tr><td class="cm-number">3</td>
                    <td>The competence of the people working under the permit has been checked.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_03_competence_checked) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_03_competence_checked)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_03_competence_checked)   || '</td></tr>
                <tr><td class="cm-number">4</td>
                    <td>The person in charge of the works must be made aware of all hazards.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_04_hazards_aware) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_04_hazards_aware)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_04_hazards_aware)   || '</td></tr>
                <tr><td class="cm-number">5</td>
                    <td>Where the use of PPE is identified as a control measure, equipment is in
                        good order.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_05_ppe_identified) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_05_ppe_identified)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_05_ppe_identified)   || '</td></tr>
                <tr><td class="cm-number">6</td>
                    <td>All sources of supply have been isolated, locked off and caution signs
                        fitted.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_06_sources_isolated) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_06_sources_isolated)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_06_sources_isolated)   || '</td></tr>
                <tr><td class="cm-number">7</td>
                    <td>Confirm that all isolated sources of supply have been proved dead using an
                        approved tester and proving unit, where this is not possible the AP must
                        confirm dead at the point of work after the issue of this Permit.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_07_proved_dead) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_07_proved_dead)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_07_proved_dead)   || '</td></tr>
                <tr><td class="cm-number">8</td>
                    <td>All systems checked to ensure any stored energy has been dissipated.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_08_stored_energy) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_08_stored_energy)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_08_stored_energy)   || '</td></tr>
                <tr><td class="cm-number">9</td>
                    <td>Live equipment covered in suitable insulating material, no exposed live
                        parts.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_09_live_covered) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_09_live_covered)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_09_live_covered)   || '</td></tr>
                <tr><td class="cm-number">10</td>
                    <td>Sufficient measures in place to ensure no live equipment is worked on.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_10_no_live_work) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_10_no_live_work)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_10_no_live_work)   || '</td></tr>
                <tr><td class="cm-number">11</td>
                    <td>First aid facilities available.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_11_first_aid) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_11_first_aid)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_11_first_aid)   || '</td></tr>
                <tr><td class="cm-number">12</td>
                    <td>Suitable barriers used to clearly identify the working area.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_12_barriers) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_12_barriers)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_12_barriers)   || '</td></tr>
                <tr><td class="cm-number">13</td>
                    <td>Unrestricted access and egress to the working area.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_13_access_egress) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_13_access_egress)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_13_access_egress)   || '</td></tr>
                <tr><td class="cm-number">14</td>
                    <td>Suitable insulated matting available.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_14_insulated_matting) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_14_insulated_matting)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_14_insulated_matting)   || '</td></tr>
                <tr><td class="cm-number">15</td>
                    <td>Confirm that the calibration of the test equipment is current.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_15_calibration_current) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_15_calibration_current)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_15_calibration_current)   || '</td></tr>
                <tr><td class="cm-number">16</td>
                    <td>Danger signs have been applied to adjacent live equipment.</td>
                    <td class="cm-tick">' || get_cm_tick(v_cm.cm_16_danger_signs) || '</td>
                    <td class="cm-tick">' || get_cm_no(v_cm.cm_16_danger_signs)   || '</td>
                    <td class="cm-tick">' || get_cm_na(v_cm.cm_16_danger_signs)   || '</td></tr>
            </tbody>
        </table>
    </div>';

    -- ============================================================
    -- PPE REQUIREMENTS
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Identify Essential PPE Required To Be Worn</div>
        <div style="font-size:7.5pt;color:#555;padding:4px 12px;font-style:italic;
                    border-bottom:1px solid #eee;">
            This list is not exhaustive &mdash; please refer to risk assessment.
            This Permit MUST be issued for the SHORTEST reasonable period of TIME
            (never usually longer than 12 Hours).
        </div>
        <table style="width:100%;border-collapse:collapse;font-size:8.5pt;">
            <tr>
                <td style="width:50%;padding:3px 12px;">'
                    || get_checked(v_permit.ppe_safety_helmet)     || ' Safety Helmet (Hard Hat)</td>
                <td style="width:50%;padding:3px 12px;">'
                    || get_checked(v_permit.ppe_arc_flash)         || ' Arc Flash PPE</td>
            </tr>
            <tr>
                <td style="padding:3px 12px;">'
                    || get_checked(v_permit.ppe_safety_footwear)   || ' Safety Footwear</td>
                <td style="padding:3px 12px;">'
                    || get_checked(v_permit.ppe_hi_vis)            || ' Hi-Vis Vest/Jkt</td>
            </tr>
            <tr>
                <td style="padding:3px 12px;">'
                    || get_checked(v_permit.ppe_safety_goggles)    || ' Safety Goggles</td>
                <td style="padding:3px 12px;">'
                    || get_checked(v_permit.ppe_insulating_gloves) || ' Electrical Insulating Gloves</td>
            </tr>
            <tr>
                <td style="padding:3px 12px;">'
                    || get_checked(v_permit.ppe_fall_restraint)    || ' Fall Restraint Harness</td>
                <td style="padding:3px 12px;">'
                    || get_checked(v_permit.ppe_fall_arrest)       || ' Fall Arrest Harness</td>
            </tr>
            <tr>
                <td style="padding:3px 12px;">'
                    || get_checked(v_permit.ppe_ear_defenders)     || ' Ear Defenders/Plugs</td>
                <td style="padding:3px 12px;">'
                    || get_checked(v_permit.ppe_safety_gloves)     || ' Safety Gloves</td>
            </tr>
        </table>
    </div>';

    -- ============================================================
    -- EQUIPMENT ISOLATION TABLE
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Equipment Isolation</div>
        <table class="ptw-lv-table">
            <thead>
                <tr>
                    <th style="width:28px;">No.</th>
                    <th>Equipment isolated</th>
                    <th>Means of isolation</th>
                    <th style="width:95px;">Safety lock no.</th>
                </tr>
            </thead>
            <tbody>';

    FOR iso IN c_isolation LOOP
        v_html := v_html || '
                <tr>
                    <td style="text-align:center;font-weight:700;">' || iso.row_number         || '</td>
                    <td>'                                                                        || safe_val(iso.equipment_isolated) || '</td>
                    <td>'                                                                        || safe_val(iso.means_of_isolation)  || '</td>
                    <td>'                                                                        || safe_val(iso.safety_lock_no)      || '</td>
                </tr>';
    END LOOP;

    -- Fill any unused isolation rows up to 4
    FOR i IN (
        SELECT LEVEL AS rn FROM DUAL CONNECT BY LEVEL <= 4
        MINUS
        SELECT row_number
        FROM   ptw_pro.ptw_lv_equipment_isolation
        WHERE  permit_id = p_permit_id
    ) LOOP
        v_html := v_html || '
                <tr>
                    <td style="text-align:center;font-weight:700;">' || i.rn || '</td>
                    <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
                </tr>';
    END LOOP;

    v_html := v_html || '
            </tbody>
        </table>
    </div>';

    -- ============================================================
    -- AUTHORISATION
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Authorisation of this Permit to Work</div>
        <div class="declaration-box">
            I have reviewed all aspects of the task/activity and I am satisfied with the
            arrangements as detailed within the relevant risk assessment and method statement
            that have been put in place and certify that this activity detailed is authorised
            to proceed.
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Authorised Person:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.auth_person_name)   || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Mobile Tel No.:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.auth_person_mobile) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">FROM:</div>
            <div class="ptw-lv-value">' || fmt_datetime(v_permit.started_datetime) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">TO:</div>
            <div class="ptw-lv-value">' || fmt_datetime(v_permit.ended_datetime) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Signature:</div>
            <div class="ptw-lv-value">
                <div class="signature-box">' || get_signature_img(v_permit.auth_person_signature) || '</div>
            </div>
        </div>
    </div>';

    -- ============================================================
    -- ACCEPTANCE
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Acceptance of this Permit to Work</div>
        <div class="declaration-box">
            I certify that I am competent to supervise and undertake the works detailed within
            this Permit to Work and have read and fully understand the documentation associated
            with this work activity.
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Person in Charge of Works:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.accept_person_name)   || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Mobile Tel. No.:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.accept_person_mobile) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Company:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.accept_company) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Date &amp; Time:</div>
            <div class="ptw-lv-value">' || fmt_datetime(v_permit.accept_datetime) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Signature:</div>
            <div class="ptw-lv-value">
                <div class="signature-box">' || get_signature_img(v_permit.accept_person_signature) || '</div>
            </div>
        </div>
    </div>';

    -- ============================================================
    -- CLEARANCE
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Clearance of this Permit to Work</div>
        <div class="declaration-box">
            I certify that the works detailed within this Permit to Work are
            <strong>' || get_yn_label(v_permit.clear_work_complete) || '</strong>.
            The area [has]/[has not] been left in a safe and tidy condition and all waste has
            been removed from site. It is <strong>' || get_safe_label(v_permit.clear_area_safe) || '</strong>
            to reinstate the plant and equipment.
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Works complete:</div>
            <div class="ptw-lv-value">' || get_yn(v_permit.clear_work_complete) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Area left safe and tidy:</div>
            <div class="ptw-lv-value">' ||
                CASE v_permit.clear_area_safe
                    WHEN 'Y' THEN '<span class="status-badge status-yes">Yes</span>'
                    WHEN 'N' THEN '<span class="status-badge status-no">No</span>'
                    ELSE '-'
                END || '
            </div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Person in Charge of Works:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.clear_person_name)   || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Mobile Tel. No.:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.clear_person_mobile) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Company:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.clear_company) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Date &amp; Time:</div>
            <div class="ptw-lv-value">' || fmt_datetime(v_permit.clear_datetime) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Signature:</div>
            <div class="ptw-lv-value">
                <div class="signature-box">' || get_signature_img(v_permit.clear_person_signature) || '</div>
            </div>
        </div>
    </div>';

    -- ============================================================
    -- CANCELLATION
    -- ============================================================
    v_html := v_html || '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Cancellation of this Permit to Work</div>
        <div class="declaration-box">
            I confirm that these works have been
            <strong>' || get_yn_label(v_permit.cancel_work_complete) || '</strong>
            and that I have checked that the place of work has been left in a safe and tidy
            condition. Where the work is not complete a further Permit may be required.
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Works complete:</div>
            <div class="ptw-lv-value">' || get_yn(v_permit.cancel_work_complete) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Authorised Person:</div>
            <div class="ptw-lv-value">' || safe_val(v_permit.cancel_person_name) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Date &amp; Time:</div>
            <div class="ptw-lv-value">' || fmt_datetime(v_permit.cancel_datetime) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Signature:</div>
            <div class="ptw-lv-value">
                <div class="signature-box">' || get_signature_img(v_permit.cancel_person_signature) || '</div>
            </div>
        </div>
    </div>';

    -- ============================================================
    -- PAGE 1 FOOTER
    -- ============================================================
    v_html := v_html || '
    <div class="footer">
        During the works the Original copy shall be retained by the &lsquo;Authorised Person&rsquo;
        and the copy shall be retained by the &lsquo;Person in Charge&rsquo; of the work and must
        have it available at all times for inspection. On completion of the works, the copy must be
        returned and both parts are signed when cancelling this Permit. Retention period 5 years.
        <br>Generated: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI') ||
        ' &nbsp;|&nbsp; Permit: ' || safe_val(v_permit.permit_number) || '
    </div>';

    -- ============================================================
    -- PAGE 2+: LOW VOLTAGE MONITORING
    -- One printed page per monitoring record, in date order.
    -- ============================================================
    FOR v_mon IN c_monitoring LOOP
        v_mon_num := v_mon_num + 1;

        v_html := v_html || '<div class="page-break"></div>'
                         || '<div class="ptw-lv-report-container">';

        v_html := v_html || '<div class="ptw-lv-header">'
                         || '<h1>Low Voltage Monitoring</h1>'
                         || '<div class="header-refs">';
        v_html := v_html || '<div>Permit No.: <strong>'
                         || safe_val(v_permit.permit_number) || '</strong></div>';
        v_html := v_html || '<div>Check: <strong>'
                         || TO_CHAR(v_mon_num) || ' of ' || TO_CHAR(v_mon_count)
                         || '</strong></div>';
        v_html := v_html || '<div>Date: <strong>'
                         || NVL(TO_CHAR(v_mon.monitor_date, 'DD-MON-YYYY'), '-')
                         || '</strong></div>';
        v_html := v_html || '</div></div>';

        v_html := v_html || '<div class="ptw-lv-section">'
                         || '<div class="declaration-box" style="padding:6px 12px;">'
                         || 'The following checks are to be undertaken by the issuer of this permit.'
                         || '</div></div>';

        v_html := v_html || '<div class="ptw-lv-section">'
                         || '<div class="ptw-lv-section-title">Site Monitoring Checks</div>'
                         || '<table class="ptw-lv-table"><thead><tr>'
                         || '<th>Check</th>'
                         || '<th style="width:55px;text-align:center;">Yes</th>'
                         || '<th style="width:55px;text-align:center;">No</th>'
                         || '<th style="width:55px;text-align:center;">N/A</th>'
                         || '<th style="width:90px;">Time of check</th>'
                         || '</tr></thead><tbody>';

        -- Row 1: Is Permit on display?
        v_html := v_html || '<tr><td>Is Permit on display?</td>'
            || '<td style="text-align:center;">' || CASE v_mon.chk_permit_on_display WHEN 'Y'  THEN '<span class="tick-mark">&#10003;</span>' ELSE '' END || '</td>'
            || '<td style="text-align:center;">' || CASE v_mon.chk_permit_on_display WHEN 'N'  THEN '<span class="tick-mark" style="color:#c0392b;">&#10003;</span>' ELSE '' END || '</td>'
            || '<td style="text-align:center;">' || CASE v_mon.chk_permit_on_display WHEN 'NA' THEN '<span class="na-mark">N/A</span>' ELSE '' END || '</td>'
            || '<td>' || NVL(v_mon.chk_permit_time, '') || '</td></tr>';

        -- Row 2: Is Access / Egress clear?
        v_html := v_html || '<tr><td>Is Access / Egress clear?</td>'
            || '<td style="text-align:center;">' || CASE v_mon.chk_access_egress WHEN 'Y'  THEN '<span class="tick-mark">&#10003;</span>' ELSE '' END || '</td>'
            || '<td style="text-align:center;">' || CASE v_mon.chk_access_egress WHEN 'N'  THEN '<span class="tick-mark" style="color:#c0392b;">&#10003;</span>' ELSE '' END || '</td>'
            || '<td style="text-align:center;">' || CASE v_mon.chk_access_egress WHEN 'NA' THEN '<span class="na-mark">N/A</span>' ELSE '' END || '</td>'
            || '<td>' || NVL(v_mon.chk_access_time, '') || '</td></tr>';

        -- Row 3: Are warning signs in place?
        v_html := v_html || '<tr><td>Are warning signs in place?</td>'
            || '<td style="text-align:center;">' || CASE v_mon.chk_warning_signs WHEN 'Y'  THEN '<span class="tick-mark">&#10003;</span>' ELSE '' END || '</td>'
            || '<td style="text-align:center;">' || CASE v_mon.chk_warning_signs WHEN 'N'  THEN '<span class="tick-mark" style="color:#c0392b;">&#10003;</span>' ELSE '' END || '</td>'
            || '<td style="text-align:center;">' || CASE v_mon.chk_warning_signs WHEN 'NA' THEN '<span class="na-mark">N/A</span>' ELSE '' END || '</td>'
            || '<td>' || NVL(v_mon.chk_warning_time, '') || '</td></tr>';

        v_html := v_html || '</tbody></table></div>';

        v_html := v_html || '<div class="ptw-lv-section">'
                         || '<div class="ptw-lv-section-title">'
                         || 'Checks Against Work Processes &amp; Method Statement</div>'
                         || '<div style="font-size:7.5pt;color:#555;padding:5px 12px;'
                         || 'font-style:italic;border-bottom:1px solid #eee;">'
                         || 'Considering the work involved under this Permit, on reading the method '
                         || 'statement detail below an element you wish to check for compliance. '
                         || 'Note: the minimum is one check per task carried out under each Permit, '
                         || 'but more are recommended dependent on activity complexity.</div>'
                         || '<table class="ptw-lv-table"><thead><tr>'
                         || '<th style="width:50%;">Column A &mdash; Detail the item or part of the '
                         || 'method statement you decide to check</th>'
                         || '<th style="width:50%;">Column B &mdash; Detail if all works are being '
                         || 'carried out correctly, or what was found to be non-conforming</th>'
                         || '</tr></thead><tbody>';

        -- Check 1 (always shown)
        v_html := v_html || '
                <tr>
                    <td style="vertical-align:top;">
                        <div style="font-size:8pt;font-weight:700;margin-bottom:3px;">
                            Check 1) Detail of check made:</div>
                        <div>' || NVL(safe_val(v_mon.ms_check1_detail), '&nbsp;') || '</div>
                        <div style="margin-top:6px;font-size:8pt;">
                            <strong>Enter time of check:</strong> '
                            || NVL(v_mon.ms_check1_time, '-') || '</div>
                    </td>
                    <td style="vertical-align:top;">
                        <div><strong>All in order:</strong>&nbsp;&nbsp;' ||
                        CASE v_mon.ms_check1_in_order
                            WHEN 'Y' THEN 'YES &nbsp;/&nbsp; <span style="color:#aaa;">NO</span>'
                            WHEN 'N' THEN '<span style="color:#aaa;">YES</span> &nbsp;/&nbsp; NO'
                            ELSE 'YES &nbsp;/&nbsp; NO'
                        END || '</div>
                        <div style="margin-top:6px;font-size:8pt;"><strong>Comments:</strong><br>'
                            || NVL(safe_val(v_mon.ms_check1_comments), '&nbsp;') || '</div>
                    </td>
                </tr>';

        -- Check 2 (only if data entered)
        IF v_mon.ms_check2_detail IS NOT NULL THEN
            v_html := v_html || '
                <tr>
                    <td style="vertical-align:top;">
                        <div style="font-size:8pt;font-weight:700;margin-bottom:3px;">
                            Check 2) Detail of check made:</div>
                        <div>' || safe_val(v_mon.ms_check2_detail) || '</div>
                        <div style="margin-top:6px;font-size:8pt;">
                            <strong>Enter time of check:</strong> '
                            || NVL(v_mon.ms_check2_time, '-') || '</div>
                    </td>
                    <td style="vertical-align:top;">
                        <div><strong>All in order:</strong>&nbsp;&nbsp;' ||
                        CASE v_mon.ms_check2_in_order
                            WHEN 'Y' THEN 'YES &nbsp;/&nbsp; <span style="color:#aaa;">NO</span>'
                            WHEN 'N' THEN '<span style="color:#aaa;">YES</span> &nbsp;/&nbsp; NO'
                            ELSE 'YES &nbsp;/&nbsp; NO'
                        END || '</div>
                        <div style="margin-top:6px;font-size:8pt;"><strong>Comments:</strong><br>'
                            || NVL(safe_val(v_mon.ms_check2_comments), '&nbsp;') || '</div>
                    </td>
                </tr>';
        END IF;

        -- Check 3 (only if data entered)
        IF v_mon.ms_check3_detail IS NOT NULL THEN
            v_html := v_html || '
                <tr>
                    <td style="vertical-align:top;">
                        <div style="font-size:8pt;font-weight:700;margin-bottom:3px;">
                            Check 3) Detail of check made:</div>
                        <div>' || safe_val(v_mon.ms_check3_detail) || '</div>
                        <div style="margin-top:6px;font-size:8pt;">
                            <strong>Enter time of check:</strong> '
                            || NVL(v_mon.ms_check3_time, '-') || '</div>
                    </td>
                    <td style="vertical-align:top;">
                        <div><strong>All in order:</strong>&nbsp;&nbsp;' ||
                        CASE v_mon.ms_check3_in_order
                            WHEN 'Y' THEN 'YES &nbsp;/&nbsp; <span style="color:#aaa;">NO</span>'
                            WHEN 'N' THEN '<span style="color:#aaa;">YES</span> &nbsp;/&nbsp; NO'
                            ELSE 'YES &nbsp;/&nbsp; NO'
                        END || '</div>
                        <div style="margin-top:6px;font-size:8pt;"><strong>Comments:</strong><br>'
                            || NVL(safe_val(v_mon.ms_check3_comments), '&nbsp;') || '</div>
                    </td>
                </tr>';
        END IF;

        v_html := v_html || '
            </tbody>
        </table>
    </div>

    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Monitoring Sign-Off</div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Monitoring carried out by (Name):</div>
            <div class="ptw-lv-value">' || safe_val(v_mon.monitor_name) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Date:</div>
            <div class="ptw-lv-value">' || fmt_date(v_mon.monitor_date) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">(Print) Signature:</div>
            <div class="ptw-lv-value">
                <div class="signature-box">'
                    || get_signature_img(v_mon.monitor_signature) || '</div>
            </div>
        </div>
    </div>

    <div class="footer">
        Generated: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI') ||
        ' &nbsp;|&nbsp; Permit: ' || safe_val(v_permit.permit_number) || '
    </div>
    </div>'; -- end ptw-lv-report-container (monitoring page)

    END LOOP; -- c_monitoring

    -- ============================================================
    -- PERMIT HISTORY SECTION (only when p_include_history = 'Y')
    -- Uses same query as Page 6 IR — latest record per stage only.
    -- Appended after all monitoring pages as an audit appendix.
    -- ============================================================
    IF NVL(p_include_history, 'N') = 'Y' THEN

        v_html := v_html || '<div class="page-break"></div>
    <div class="ptw-lv-report-container">
    <div class="history-section">
        <div class="ptw-lv-section-title">&#128203; Permit Stage History</div>';

        DECLARE
            v_hist_count NUMBER := 0;
        BEGIN
            SELECT COUNT(*)
            INTO   v_hist_count
            FROM (
                WITH max_row AS (
                    SELECT MAX(created_date) AS max_date,
                           permit_id,
                           permit_stage
                    FROM   ptw_pro.ptw_stage_locations
                    GROUP  BY permit_id, permit_stage
                )
                SELECT sl.permit_stage
                FROM   ptw_pro.ptw_stage_locations sl
                JOIN   max_row mr
                       ON  mr.permit_id    = sl.permit_id
                       AND mr.permit_stage = sl.permit_stage
                       AND mr.max_date     = sl.created_date
                WHERE  sl.permit_id = p_permit_id
            );

            IF v_hist_count = 0 THEN
                v_html := v_html || '
        <div class="history-no-data">No stage history recorded for this permit.</div>';
            ELSE
                v_html := v_html || '
        <table class="history-table">
            <thead>
                <tr>
                    <th style="width:32%;">Stage</th>
                    <th style="width:22%;">Date / Time</th>
                    <th style="width:22%;">Recorded By</th>
                    <th style="width:24%;">GPS Location</th>
                </tr>
            </thead>
            <tbody>';

                FOR r IN (
                    WITH max_row AS (
                        SELECT MAX(created_date) AS max_date,
                               permit_id,
                               permit_stage
                        FROM   ptw_pro.ptw_stage_locations
                        GROUP  BY permit_id, permit_stage
                    )
                    SELECT CASE sl.permit_stage
                               WHEN 'SITE_WORK_DETAILS' THEN 'Step 1: Site &amp; Work Details'
                               WHEN 'CONTROL_MEASURES'  THEN 'Step 2: Control Measures'
                               WHEN 'EQUIP_ISOLATION'   THEN 'Step 3: Equipment Isolation'
                               WHEN 'AUTHORISATION'     THEN 'Step 4: Authorisation'
                               WHEN 'LIVE'              THEN 'Step 5: Live'
                               ELSE NVL(SUBSTR(sl.permit_stage, 1, 100), '-')
                           END                                              AS step_display,
                           TO_CHAR(sl.created_date, 'DD-MON-YYYY HH24:MI') AS created_date,
                           NVL(REPLACE(REPLACE(SUBSTR(sl.created_by, 1, 200),
                                               '<', '&lt;'), '>', '&gt;'), '-') AS created_by,
                           CASE
                               WHEN sl.latitude  IS NOT NULL
                                AND sl.longitude IS NOT NULL
                               THEN TO_CHAR(ROUND(sl.latitude,  5)) || ', '
                                 || TO_CHAR(ROUND(sl.longitude, 5))
                               ELSE 'Not recorded'
                           END AS location_display
                    FROM   ptw_pro.ptw_stage_locations sl
                    JOIN   max_row mr
                           ON  mr.permit_id    = sl.permit_id
                           AND mr.permit_stage = sl.permit_stage
                           AND mr.max_date     = sl.created_date
                    WHERE  sl.permit_id = p_permit_id
                    ORDER  BY sl.created_date ASC
                ) LOOP
                    v_html := v_html || '
                <tr>
                    <td><span class="history-step-badge">'
                        || r.step_display    || '</span></td>
                    <td>' || r.created_date  || '</td>
                    <td>' || r.created_by    || '</td>
                    <td>' || r.location_display || '</td>
                </tr>';
                END LOOP;

                v_html := v_html || '
            </tbody>
        </table>';
            END IF;
        END;

        v_html := v_html || '
    <div class="footer">
        Audit History &nbsp;|&nbsp; Permit: ' || safe_val(v_permit.permit_number) ||
        ' &nbsp;|&nbsp; Generated: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI') || '
    </div>
    </div>'; -- end history-section
    v_html := v_html || '
    </div>'; -- end ptw-lv-report-container (history page)

    END IF; -- p_include_history

    -- Timestamp only when no monitoring records exist
    IF v_mon_count = 0 THEN
        v_html := v_html || '
    <div style="font-size:7pt;color:#aaa;text-align:right;padding:4px 0;">
        Generated: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI') || '
    </div>';
    END IF;

    v_html := v_html || '
</div>
</body>
</html>';

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