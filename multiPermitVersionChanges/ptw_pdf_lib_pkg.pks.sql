CREATE OR REPLACE PACKAGE ptw_pro.ptw_pdf_lib_pkg AS
    --------------------------------------------------------------------------
    -- Shared PDF plumbing used by every per-type PDF function
    -- (GENERATE_PTW_LV_PDF, GENERATE_PTW_GENERAL_PDF, and whatever comes
    -- next). Nothing in here is permit-content that a customer would want
    -- to customise — it's formatting helpers, signature rendering, and the
    -- sections that are genuinely identical regardless of permit type
    -- (site/work details, signature stages, monitoring, stage history).
    --
    -- A type's own PDF function stays free to skip any of these and write
    -- bespoke HTML instead — nothing here is mandatory to call.
    --------------------------------------------------------------------------

    -- ---- Formatting helpers -------------------------------------------
    FUNCTION safe_val (p_text VARCHAR2) RETURN VARCHAR2;
    FUNCTION safe_num (p_num NUMBER) RETURN VARCHAR2;
    FUNCTION get_yn (p_value VARCHAR2) RETURN VARCHAR2;
    FUNCTION get_yn_label (p_value VARCHAR2) RETURN VARCHAR2;
    FUNCTION get_safe_label (p_value VARCHAR2) RETURN VARCHAR2;
    FUNCTION get_checked (p_value VARCHAR2) RETURN VARCHAR2;
    FUNCTION get_cm_tick (p_value VARCHAR2) RETURN VARCHAR2;
    FUNCTION get_cm_na (p_value VARCHAR2) RETURN VARCHAR2;
    FUNCTION get_cm_no (p_value VARCHAR2) RETURN VARCHAR2;
    FUNCTION fmt_datetime (p_date DATE) RETURN VARCHAR2;
    FUNCTION fmt_date (p_date DATE) RETURN VARCHAR2;
    FUNCTION get_signature_img (p_blob BLOB) RETURN CLOB;

    -- ---- Document chrome -------------------------------------------------
    -- Returns <!DOCTYPE html>...<style>...</style></head><body><div class="ptw-lv-report-container">
    -- Shared CSS, single source of truth for the visual look and feel.
    FUNCTION get_document_head (p_document_title VARCHAR2) RETURN CLOB;

    -- Returns </div></body></html>
    FUNCTION get_document_close RETURN CLOB;

    -- Base64 company logo, or NULL if this company has none uploaded.
    FUNCTION get_company_logo_b64 (p_company_id NUMBER) RETURN CLOB;

    -- ---- Sections identical across permit types --------------------------
    FUNCTION get_site_work_details_html (p_permit_id NUMBER) RETURN CLOB;
    FUNCTION get_control_measures_html  (p_permit_id NUMBER) RETURN CLOB;
    FUNCTION get_ppe_html               (p_permit_id NUMBER) RETURN CLOB;
    FUNCTION get_equipment_isolation_html (p_permit_id NUMBER) RETURN CLOB;
    FUNCTION get_authorisation_html     (p_permit_id NUMBER) RETURN CLOB;
    FUNCTION get_acceptance_html        (p_permit_id NUMBER) RETURN CLOB;
    FUNCTION get_clearance_html         (p_permit_id NUMBER) RETURN CLOB;
    FUNCTION get_cancellation_html      (p_permit_id NUMBER) RETURN CLOB;

    -- All monitoring visit pages, including the trailing "Generated" stamp
    -- when there are none. p_page_heading lets a type use different wording
    -- (e.g. "Low Voltage Monitoring" vs "Site Monitoring").
    FUNCTION get_monitoring_pages_html (
        p_permit_id    NUMBER,
        p_page_heading VARCHAR2 DEFAULT 'Site Monitoring'
    ) RETURN CLOB;

    FUNCTION get_stage_history_html (p_permit_id NUMBER) RETURN CLOB;

END ptw_pdf_lib_pkg;
/
