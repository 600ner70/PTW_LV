CREATE OR REPLACE PACKAGE BODY ptw_pro.ptw_pdf_lib_pkg AS

    --------------------------------------------------------------------------
    -- FORMATTING HELPERS
    --------------------------------------------------------------------------

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

    --------------------------------------------------------------------------
    -- DOCUMENT CHROME
    --------------------------------------------------------------------------

    FUNCTION get_document_head (p_document_title VARCHAR2) RETURN CLOB IS
    BEGIN
        RETURN '<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>' || safe_val(p_document_title) || '</title>
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

    .history-section { border: 1px solid #c0c0c0; border-top: none; margin-top: 0; }
    .history-section .ptw-lv-section-title { background: #1a3a5c; }
    .history-table { width: 100%; border-collapse: collapse; font-size: 8.5pt; }
    .history-table th {
        background: #dce6f0; color: #003366;
        padding: 5px 8px; text-align: left; font-weight: 700;
        border: 1px solid #c0c0c0; font-size: 8pt;
    }
    .history-table td {
        padding: 5px 8px; border: 1px solid #c0c0c0; vertical-align: middle;
    }
    .history-table tr:nth-child(even) td { background: #f7f9fc; }
    .history-step-badge {
        display: inline-block; background: #003366; color: #fff;
        padding: 2px 8px; border-radius: 10px;
        font-size: 7.5pt; font-weight: 700; white-space: nowrap;
    }
    .history-no-data {
        padding: 12px; font-style: italic; color: #888;
        font-size: 8pt; text-align: center;
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
    END get_document_head;

    FUNCTION get_document_close RETURN CLOB IS
    BEGIN
        RETURN '</div></body></html>';
    END get_document_close;

    FUNCTION get_company_logo_b64 (p_company_id NUMBER) RETURN CLOB IS
        v_logo_blob BLOB;
        v_logo_b64  CLOB;
    BEGIN
        SELECT file_content
        INTO   v_logo_blob
        FROM   apex_application_static_files
        WHERE  application_id = (
                SELECT application_id FROM apex_applications WHERE alias = 'PTW-PRO'
            )
        AND    file_name = 'logo_' || p_company_id || '.png';

        v_logo_b64 := apex_web_service.blob2clobbase64(v_logo_blob);
        RETURN REPLACE(REPLACE(v_logo_b64, CHR(10), ''), CHR(13), '');
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL; -- no logo for this company - render PDF without one
    END get_company_logo_b64;

    --------------------------------------------------------------------------
    -- SECTIONS IDENTICAL ACROSS PERMIT TYPES
    --------------------------------------------------------------------------

    FUNCTION get_site_work_details_html (p_permit_id NUMBER) RETURN CLOB IS
        v_area_of_works     ptw_pro.ptw_lv_permits.area_of_works%TYPE;
        v_work_description  ptw_pro.ptw_lv_permits.work_description%TYPE;
        v_pic_name          ptw_pro.ptw_lv_permits.person_in_charge_name%TYPE;
        v_company           ptw_pro.ptw_lv_permits.supervising_company%TYPE;
        v_other_persons     ptw_pro.ptw_lv_permits.other_persons_count%TYPE;
        v_site_id           ptw_pro.ptw_lv_permits.site_id%TYPE;
        v_site_details_txt  ptw_pro.ptw_lv_permits.site_details%TYPE;
        v_site_name         VARCHAR2(500);
    BEGIN
        SELECT area_of_works, work_description, person_in_charge_name,
               supervising_company, other_persons_count, site_id, site_details
        INTO   v_area_of_works, v_work_description, v_pic_name,
               v_company, v_other_persons, v_site_id, v_site_details_txt
        FROM   ptw_pro.ptw_lv_permits
        WHERE  permit_id = p_permit_id;

        BEGIN
            SELECT site_name INTO v_site_name
            FROM   ptw_pro.ptw_lv_sites WHERE site_id = v_site_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN v_site_name := v_site_details_txt;
        END;

        RETURN '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Site &amp; Work Details</div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Site details and area of works:</div>
            <div class="ptw-lv-value">' || safe_val(v_site_name || ' - ' || v_area_of_works) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Description of work activity:</div>
            <div class="ptw-lv-value">' || safe_val(v_work_description) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Name of Person in Charge:</div>
            <div class="ptw-lv-value">' || safe_val(v_pic_name) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Company responsible for supervising the works:</div>
            <div class="ptw-lv-value">' || safe_val(v_company) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Number of other persons working under this Permit:</div>
            <div class="ptw-lv-value">' || safe_num(v_other_persons) || '</div>
        </div>
    </div>';
    END get_site_work_details_html;


    FUNCTION get_control_measures_html (p_permit_id NUMBER) RETURN CLOB IS
        v_html    CLOB;
        v_row_num NUMBER := 0;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(v_html, TRUE, DBMS_LOB.CALL);
        v_html := '
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
                    <td>' || safe_val(cm_item.question_text) || '</td>
                    <td class="cm-tick">' || get_cm_tick(cm_item.response) || '</td>
                    <td class="cm-tick">' || get_cm_no(cm_item.response)   || '</td>
                    <td class="cm-tick">' || get_cm_na(cm_item.response)   || '</td></tr>'));
        END LOOP;

        v_html := v_html || '
            </tbody>
        </table>
    </div>';
        RETURN v_html;
    END get_control_measures_html;


    FUNCTION get_ppe_html (p_permit_id NUMBER) RETURN CLOB IS
        v_html    CLOB;
        v_ppe_col NUMBER := 0;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(v_html, TRUE, DBMS_LOB.CALL);
        v_html := '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Identify Essential PPE Required To Be Worn</div>
        <div style="font-size:7.5pt;color:#555;padding:4px 12px;font-style:italic;
                    border-bottom:1px solid #eee;">
            This list is not exhaustive &mdash; please refer to risk assessment.
            This Permit MUST be issued for the SHORTEST reasonable period of TIME
            (never usually longer than 12 Hours).
        </div>
        <table style="width:100%;border-collapse:collapse;font-size:8.5pt;">';

        FOR ppe_item IN (
            SELECT ci.item_seq, ci.question_text, cr.response
            FROM   ptw_pro.ptw_checklist_items ci
            JOIN   ptw_pro.ptw_lv_permits p ON p.permit_id = p_permit_id
            JOIN   ptw_pro.ptw_types t       ON t.ptw_type = p.ptw_type AND t.type_id = ci.type_id
            LEFT JOIN ptw_pro.ptw_checklist_responses cr
                   ON cr.checklist_item_id = ci.checklist_item_id AND cr.permit_id = p_permit_id
            WHERE  ci.section_code = 'PPE'
            AND    ci.is_active = 'Y'
            ORDER BY ci.item_seq
        ) LOOP
            IF MOD(v_ppe_col, 2) = 0 THEN
                DBMS_LOB.APPEND(v_html, TO_CLOB('<tr>'));
            END IF;
            DBMS_LOB.APPEND(v_html, TO_CLOB(
                '<td style="width:50%;padding:3px 12px;">'
                || get_checked(ppe_item.response) || ' ' || safe_val(ppe_item.question_text) || '</td>'));
            IF MOD(v_ppe_col, 2) = 1 THEN
                DBMS_LOB.APPEND(v_html, TO_CLOB('</tr>'));
            END IF;
            v_ppe_col := v_ppe_col + 1;
        END LOOP;
        IF MOD(v_ppe_col, 2) = 1 THEN
            DBMS_LOB.APPEND(v_html, TO_CLOB('<td>&nbsp;</td></tr>'));
        END IF;

        v_html := v_html || '
        </table>
    </div>';
        RETURN v_html;
    END get_ppe_html;


    FUNCTION get_equipment_isolation_html (p_permit_id NUMBER) RETURN CLOB IS
        v_html CLOB;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(v_html, TRUE, DBMS_LOB.CALL);
        v_html := '
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

        FOR iso IN (
            SELECT row_number, equipment_isolated, means_of_isolation, safety_lock_no
            FROM   ptw_pro.ptw_lv_equipment_isolation
            WHERE  permit_id = p_permit_id
            ORDER  BY row_number
        ) LOOP
            DBMS_LOB.APPEND(v_html, TO_CLOB('
                <tr>
                    <td style="text-align:center;font-weight:700;">' || iso.row_number || '</td>
                    <td>' || safe_val(iso.equipment_isolated) || '</td>
                    <td>' || safe_val(iso.means_of_isolation)  || '</td>
                    <td>' || safe_val(iso.safety_lock_no)      || '</td>
                </tr>'));
        END LOOP;

        FOR i IN (
            SELECT LEVEL AS rn FROM DUAL CONNECT BY LEVEL <= 4
            MINUS
            SELECT row_number FROM ptw_pro.ptw_lv_equipment_isolation WHERE permit_id = p_permit_id
        ) LOOP
            DBMS_LOB.APPEND(v_html, TO_CLOB('
                <tr>
                    <td style="text-align:center;font-weight:700;">' || i.rn || '</td>
                    <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
                </tr>'));
        END LOOP;

        v_html := v_html || '
            </tbody>
        </table>
    </div>';
        RETURN v_html;
    END get_equipment_isolation_html;


    FUNCTION get_authorisation_html (p_permit_id NUMBER) RETURN CLOB IS
        v_auth_name    ptw_pro.ptw_signatures.person_name%TYPE;
        v_auth_sig     ptw_pro.ptw_signatures.signature_blob%TYPE;
        v_auth_mobile  ptw_pro.ptw_signatures.mobile_no%TYPE;
        v_auth_dt      ptw_pro.ptw_signatures.event_datetime%TYPE;
        v_na_company   ptw_pro.ptw_signatures.company_name%TYPE;
        v_na_lat       ptw_pro.ptw_signatures.latitude%TYPE;
        v_na_lng       ptw_pro.ptw_signatures.longitude%TYPE;
        v_fullname     VARCHAR2(200);
        v_started      DATE;
        v_ended        DATE;
    BEGIN
        ptw_pro.ptw_signature_pkg.get_signature(p_permit_id, 'AUTH',
            v_auth_name, v_auth_sig, v_auth_mobile, v_na_company, v_auth_dt, v_na_lat, v_na_lng);

        SELECT started_datetime, ended_datetime INTO v_started, v_ended
        FROM   ptw_pro.ptw_lv_permits WHERE permit_id = p_permit_id;

        BEGIN
            SELECT first_name || ' ' || last_name INTO v_fullname
            FROM   ptw_pro.ptw_lv_users WHERE UPPER(username) = UPPER(v_auth_name);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN v_fullname := v_auth_name;
            WHEN OTHERS THEN v_fullname := v_auth_name;
        END;

        RETURN '
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
            <div class="ptw-lv-value">' || safe_val(v_fullname) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Mobile Tel No.:</div>
            <div class="ptw-lv-value">' || safe_val(v_auth_mobile) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">FROM:</div>
            <div class="ptw-lv-value">' || fmt_datetime(v_started) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">TO:</div>
            <div class="ptw-lv-value">' || fmt_datetime(v_ended) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Signature:</div>
            <div class="ptw-lv-value">
                <div class="signature-box">' || get_signature_img(v_auth_sig) || '</div>
            </div>
        </div>
    </div>';
    END get_authorisation_html;


    FUNCTION get_acceptance_html (p_permit_id NUMBER) RETURN CLOB IS
        v_name    ptw_pro.ptw_signatures.person_name%TYPE;
        v_sig     ptw_pro.ptw_signatures.signature_blob%TYPE;
        v_mobile  ptw_pro.ptw_signatures.mobile_no%TYPE;
        v_company ptw_pro.ptw_signatures.company_name%TYPE;
        v_dt      ptw_pro.ptw_signatures.event_datetime%TYPE;
        v_na_lat  ptw_pro.ptw_signatures.latitude%TYPE;
        v_na_lng  ptw_pro.ptw_signatures.longitude%TYPE;
    BEGIN
        ptw_pro.ptw_signature_pkg.get_signature(p_permit_id, 'ACCEPT',
            v_name, v_sig, v_mobile, v_company, v_dt, v_na_lat, v_na_lng);

        RETURN '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Acceptance of this Permit to Work</div>
        <div class="declaration-box">
            I certify that I am competent to supervise and undertake the works detailed within
            this Permit to Work and have read and fully understand the documentation associated
            with this work activity.
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Person in Charge of Works:</div>
            <div class="ptw-lv-value">' || safe_val(v_name) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Mobile Tel. No.:</div>
            <div class="ptw-lv-value">' || safe_val(v_mobile) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Company:</div>
            <div class="ptw-lv-value">' || safe_val(v_company) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Date &amp; Time:</div>
            <div class="ptw-lv-value">' || fmt_datetime(v_dt) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Signature:</div>
            <div class="ptw-lv-value">
                <div class="signature-box">' || get_signature_img(v_sig) || '</div>
            </div>
        </div>
    </div>';
    END get_acceptance_html;


    FUNCTION get_clearance_html (p_permit_id NUMBER) RETURN CLOB IS
        v_name    ptw_pro.ptw_signatures.person_name%TYPE;
        v_sig     ptw_pro.ptw_signatures.signature_blob%TYPE;
        v_mobile  ptw_pro.ptw_signatures.mobile_no%TYPE;
        v_company ptw_pro.ptw_signatures.company_name%TYPE;
        v_dt      ptw_pro.ptw_signatures.event_datetime%TYPE;
        v_na_lat  ptw_pro.ptw_signatures.latitude%TYPE;
        v_na_lng  ptw_pro.ptw_signatures.longitude%TYPE;
        v_work_complete ptw_pro.ptw_lv_permits.clear_work_complete%TYPE;
        v_area_safe     ptw_pro.ptw_lv_permits.clear_area_safe%TYPE;
    BEGIN
        ptw_pro.ptw_signature_pkg.get_signature(p_permit_id, 'CLEAR',
            v_name, v_sig, v_mobile, v_company, v_dt, v_na_lat, v_na_lng);

        SELECT clear_work_complete, clear_area_safe
        INTO   v_work_complete, v_area_safe
        FROM   ptw_pro.ptw_lv_permits WHERE permit_id = p_permit_id;

        RETURN '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Clearance of this Permit to Work</div>
        <div class="declaration-box">
            I certify that the works detailed within this Permit to Work are
            <strong>' || get_yn_label(v_work_complete) || '</strong>.
            The area [has]/[has not] been left in a safe and tidy condition and all waste has
            been removed from site. It is <strong>' || get_safe_label(v_area_safe) || '</strong>
            to reinstate the plant and equipment.
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Works complete:</div>
            <div class="ptw-lv-value">' || get_yn(v_work_complete) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Area left safe and tidy:</div>
            <div class="ptw-lv-value">' ||
                CASE v_area_safe
                    WHEN 'Y' THEN '<span class="status-badge status-yes">Yes</span>'
                    WHEN 'N' THEN '<span class="status-badge status-no">No</span>'
                    ELSE '-'
                END || '
            </div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Person in Charge of Works:</div>
            <div class="ptw-lv-value">' || safe_val(v_name) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Mobile Tel. No.:</div>
            <div class="ptw-lv-value">' || safe_val(v_mobile) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Company:</div>
            <div class="ptw-lv-value">' || safe_val(v_company) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Date &amp; Time:</div>
            <div class="ptw-lv-value">' || fmt_datetime(v_dt) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Signature:</div>
            <div class="ptw-lv-value">
                <div class="signature-box">' || get_signature_img(v_sig) || '</div>
            </div>
        </div>
    </div>';
    END get_clearance_html;


    FUNCTION get_cancellation_html (p_permit_id NUMBER) RETURN CLOB IS
        v_name    ptw_pro.ptw_signatures.person_name%TYPE;
        v_sig     ptw_pro.ptw_signatures.signature_blob%TYPE;
        v_na_mobile  ptw_pro.ptw_signatures.mobile_no%TYPE;
        v_na_company ptw_pro.ptw_signatures.company_name%TYPE;
        v_dt      ptw_pro.ptw_signatures.event_datetime%TYPE;
        v_na_lat  ptw_pro.ptw_signatures.latitude%TYPE;
        v_na_lng  ptw_pro.ptw_signatures.longitude%TYPE;
        v_work_complete ptw_pro.ptw_lv_permits.cancel_work_complete%TYPE;
        v_html    CLOB;
        r         ptw_pro.ptw_lv_cancellation_reason_v%ROWTYPE;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(v_html, TRUE, DBMS_LOB.CALL);

        ptw_pro.ptw_signature_pkg.get_signature(p_permit_id, 'CANCEL',
            v_name, v_sig, v_na_mobile, v_na_company, v_dt, v_na_lat, v_na_lng);

        SELECT cancel_work_complete INTO v_work_complete
        FROM   ptw_pro.ptw_lv_permits WHERE permit_id = p_permit_id;

        -- Reason for cancellation (only when the cancellation traces back
        -- to a failed monitoring check with a concern raised)
        BEGIN
            SELECT * INTO r FROM ptw_pro.ptw_lv_cancellation_reason_v WHERE permit_id = p_permit_id;
            IF r.is_concern_cancellation = 'Y' THEN
                v_html := v_html || '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Reason for Cancellation</div>
        <div class="ptw-lv-row"><div class="ptw-lv-label">Check failed:</div>
            <div class="ptw-lv-value">' || safe_val(r.check_label) || '</div></div>
        <div class="ptw-lv-row"><div class="ptw-lv-label">Concern raised:</div>
            <div class="ptw-lv-value">' || safe_val(r.concern_description) || '</div></div>
        <div class="ptw-lv-row"><div class="ptw-lv-label">Action taken:</div>
            <div class="ptw-lv-value">' || safe_val(r.actions_taken) || '</div></div>
        <div class="ptw-lv-row"><div class="ptw-lv-label">Reported by:</div>
            <div class="ptw-lv-value">' || safe_val(r.concern_person_name) || '</div></div>
        <div class="ptw-lv-row"><div class="ptw-lv-label">Date &amp; Time:</div>
            <div class="ptw-lv-value">' || fmt_datetime(r.concern_datetime) || '</div></div>
        <div class="ptw-lv-row"><div class="ptw-lv-label">Signature:</div>
            <div class="ptw-lv-value"><div class="signature-box">'
            || get_signature_img(r.concern_signature) || '</div></div></div>
    </div>';
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
        END;

        v_html := v_html || '
    <div class="ptw-lv-section">
        <div class="ptw-lv-section-title">Cancellation of this Permit to Work</div>
        <div class="declaration-box">
            I confirm that these works have been
            <strong>' || get_yn_label(v_work_complete) || '</strong>
            and that I have checked that the place of work has been left in a safe and tidy
            condition. Where the work is not complete a further Permit may be required.
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Works complete:</div>
            <div class="ptw-lv-value">' || get_yn(v_work_complete) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Authorised Person:</div>
            <div class="ptw-lv-value">' || safe_val(v_name) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Date &amp; Time:</div>
            <div class="ptw-lv-value">' || fmt_datetime(v_dt) || '</div>
        </div>
        <div class="ptw-lv-row">
            <div class="ptw-lv-label">Signature:</div>
            <div class="ptw-lv-value">
                <div class="signature-box">' || get_signature_img(v_sig) || '</div>
            </div>
        </div>
    </div>';
        RETURN v_html;
    END get_cancellation_html;


    FUNCTION get_monitoring_pages_html (
        p_permit_id    NUMBER,
        p_page_heading VARCHAR2 DEFAULT 'Site Monitoring'
    ) RETURN CLOB IS
        v_html      CLOB;
        v_mon_count NUMBER := 0;
        v_mon_num   NUMBER := 0;
        v_permit_number ptw_pro.ptw_lv_permits.permit_number%TYPE;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(v_html, TRUE, DBMS_LOB.CALL);

        SELECT permit_number INTO v_permit_number
        FROM   ptw_pro.ptw_lv_permits WHERE permit_id = p_permit_id;

        SELECT COUNT(*) INTO v_mon_count
        FROM   ptw_pro.ptw_lv_monitoring WHERE permit_id = p_permit_id;

        FOR v_mon IN (
            SELECT * FROM ptw_pro.ptw_lv_monitoring
            WHERE  permit_id = p_permit_id
            ORDER  BY created_date ASC
        ) LOOP
            v_mon_num := v_mon_num + 1;

            v_html := v_html || '<div class="page-break"></div><div class="ptw-lv-report-container">';
            v_html := v_html || '<div class="ptw-lv-header"><h1>' || safe_val(p_page_heading) || '</h1>'
                             || '<div class="header-refs">';
            v_html := v_html || '<div>Permit No.: <strong>' || safe_val(v_permit_number) || '</strong></div>';
            v_html := v_html || '<div>Check: <strong>' || TO_CHAR(v_mon_num) || ' of ' || TO_CHAR(v_mon_count) || '</strong></div>';
            v_html := v_html || '<div>Date: <strong>' || NVL(TO_CHAR(v_mon.monitor_date, 'DD-MON-YYYY'), '-') || '</strong></div>';
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

            v_html := v_html || '<tr><td>Is Permit on display?</td>'
                || '<td style="text-align:center;">' || CASE v_mon.chk_permit_on_display WHEN 'Y'  THEN '<span class="tick-mark">&#10003;</span>' ELSE '' END || '</td>'
                || '<td style="text-align:center;">' || CASE v_mon.chk_permit_on_display WHEN 'N'  THEN '<span class="tick-mark" style="color:#c0392b;">&#10003;</span>' ELSE '' END || '</td>'
                || '<td style="text-align:center;">' || CASE v_mon.chk_permit_on_display WHEN 'NA' THEN '<span class="na-mark">N/A</span>' ELSE '' END || '</td>'
                || '<td>' || NVL(v_mon.chk_permit_time, '') || '</td></tr>';

            v_html := v_html || '<tr><td>Is Access / Egress clear?</td>'
                || '<td style="text-align:center;">' || CASE v_mon.chk_access_egress WHEN 'Y'  THEN '<span class="tick-mark">&#10003;</span>' ELSE '' END || '</td>'
                || '<td style="text-align:center;">' || CASE v_mon.chk_access_egress WHEN 'N'  THEN '<span class="tick-mark" style="color:#c0392b;">&#10003;</span>' ELSE '' END || '</td>'
                || '<td style="text-align:center;">' || CASE v_mon.chk_access_egress WHEN 'NA' THEN '<span class="na-mark">N/A</span>' ELSE '' END || '</td>'
                || '<td>' || NVL(v_mon.chk_access_time, '') || '</td></tr>';

            v_html := v_html || '<tr><td>Are warning signs in place?</td>'
                || '<td style="text-align:center;">' || CASE v_mon.chk_warning_signs WHEN 'Y'  THEN '<span class="tick-mark">&#10003;</span>' ELSE '' END || '</td>'
                || '<td style="text-align:center;">' || CASE v_mon.chk_warning_signs WHEN 'N'  THEN '<span class="tick-mark" style="color:#c0392b;">&#10003;</span>' ELSE '' END || '</td>'
                || '<td style="text-align:center;">' || CASE v_mon.chk_warning_signs WHEN 'NA' THEN '<span class="na-mark">N/A</span>' ELSE '' END || '</td>'
                || '<td>' || NVL(v_mon.chk_warning_time, '') || '</td></tr>';

            v_html := v_html || '</tbody></table></div>';

            v_html := v_html || '<div class="ptw-lv-section">'
                             || '<div class="ptw-lv-section-title">Checks Against Work Processes &amp; Method Statement</div>'
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

            FOR chk IN (
                SELECT check_seq, detail, check_time, in_order, comments
                FROM   ptw_pro.ptw_monitoring_checks
                WHERE  monitoring_id = v_mon.monitoring_id
                ORDER  BY check_seq
            ) LOOP
                DBMS_LOB.APPEND(v_html, TO_CLOB('
                <tr>
                    <td style="vertical-align:top;">
                        <div style="font-size:8pt;font-weight:700;margin-bottom:3px;">
                            Check ' || chk.check_seq || ') Detail of check made:</div>
                        <div>' || NVL(safe_val(chk.detail), '&nbsp;') || '</div>
                        <div style="margin-top:6px;font-size:8pt;">
                            <strong>Enter time of check:</strong> '
                            || NVL(chk.check_time, '-') || '</div>
                    </td>
                    <td style="vertical-align:top;">
                        <div><strong>All in order:</strong>&nbsp;&nbsp;' ||
                        CASE chk.in_order
                            WHEN 'Y' THEN 'YES &nbsp;/&nbsp; <span style="color:#aaa;">NO</span>'
                            WHEN 'N' THEN '<span style="color:#aaa;">YES</span> &nbsp;/&nbsp; NO'
                            ELSE 'YES &nbsp;/&nbsp; NO'
                        END || '</div>
                        <div style="margin-top:6px;font-size:8pt;"><strong>Comments:</strong><br>'
                            || NVL(safe_val(chk.comments), '&nbsp;') || '</div>
                    </td>
                </tr>'));
            END LOOP;

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
                <div class="signature-box">' || get_signature_img(v_mon.monitor_signature) || '</div>
            </div>
        </div>
    </div>

    <div class="footer">
        Generated: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI') ||
        ' &nbsp;|&nbsp; Permit: ' || safe_val(v_permit_number) || '
    </div>
    </div>';
        END LOOP;

        IF v_mon_count = 0 THEN
            v_html := v_html || '
    <div style="font-size:7pt;color:#aaa;text-align:right;padding:4px 0;">
        Generated: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI') || '
    </div>';
        END IF;

        RETURN v_html;
    END get_monitoring_pages_html;


    FUNCTION get_stage_history_html (p_permit_id NUMBER) RETURN CLOB IS
        v_html       CLOB;
        v_hist_count NUMBER := 0;
        v_permit_number ptw_pro.ptw_lv_permits.permit_number%TYPE;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(v_html, TRUE, DBMS_LOB.CALL);

        SELECT permit_number INTO v_permit_number
        FROM   ptw_pro.ptw_lv_permits WHERE permit_id = p_permit_id;

        v_html := '<div class="page-break"></div>
    <div class="ptw-lv-report-container">
    <div class="history-section">
        <div class="ptw-lv-section-title">&#128203; Permit Stage History</div>';

        SELECT COUNT(*) INTO v_hist_count
        FROM (
            WITH max_row AS (
                SELECT MAX(created_date) AS max_date, permit_id, permit_stage
                FROM   ptw_pro.ptw_stage_locations
                GROUP  BY permit_id, permit_stage
            )
            SELECT sl.permit_stage
            FROM   ptw_pro.ptw_stage_locations sl
            JOIN   max_row mr ON mr.permit_id = sl.permit_id
                             AND mr.permit_stage = sl.permit_stage
                             AND mr.max_date = sl.created_date
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
                    SELECT MAX(created_date) AS max_date, permit_id, permit_stage
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
                       END AS step_display,
                       TO_CHAR(sl.created_date, 'DD-MON-YYYY HH24:MI') AS created_date,
                       NVL(REPLACE(REPLACE(SUBSTR(sl.created_by, 1, 200), '<', '&lt;'), '>', '&gt;'), '-') AS created_by,
                       CASE
                           WHEN sl.latitude IS NOT NULL AND sl.longitude IS NOT NULL
                           THEN TO_CHAR(ROUND(sl.latitude, 5)) || ', ' || TO_CHAR(ROUND(sl.longitude, 5))
                           ELSE 'Not recorded'
                       END AS location_display
                FROM   ptw_pro.ptw_stage_locations sl
                JOIN   max_row mr ON mr.permit_id = sl.permit_id
                                 AND mr.permit_stage = sl.permit_stage
                                 AND mr.max_date = sl.created_date
                WHERE  sl.permit_id = p_permit_id
                ORDER  BY sl.created_date ASC
            ) LOOP
                v_html := v_html || '
                <tr>
                    <td><span class="history-step-badge">' || r.step_display || '</span></td>
                    <td>' || r.created_date  || '</td>
                    <td>' || r.created_by    || '</td>
                    <td>' || r.location_display || '</td>
                </tr>';
            END LOOP;

            v_html := v_html || '
            </tbody>
        </table>';
        END IF;

        v_html := v_html || '
    <div class="footer">
        Audit History &nbsp;|&nbsp; Permit: ' || safe_val(v_permit_number) ||
        ' &nbsp;|&nbsp; Generated: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI') || '
    </div>
    </div>
    </div>';
        RETURN v_html;
    END get_stage_history_html;

END ptw_pdf_lib_pkg;
/
