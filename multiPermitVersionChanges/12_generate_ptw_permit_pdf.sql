--------------------------------------------------------------------------------
-- 12_generate_ptw_permit_pdf.sql
-- Single entry point for pages/reports that need a permit's PDF — looks up
-- the permit's type and calls the matching per-type function. Adding a new
-- permit type later means: write its GENERATE_PTW_<TYPE>_PDF function using
-- PTW_PDF_LIB_PKG, then add one WHEN branch here. Nothing else changes.
--
-- Deliberately a standalone function, not part of PTW_PDF_LIB_PKG — it
-- depends on GENERATE_PTW_LV_PDF and GENERATE_PTW_GENERAL_PDF actually
-- existing, so it must compile AFTER them. Keeping it separate from the
-- library avoids that ordering constraint leaking into the library itself.
--
-- Point Page 300 (the PDF viewer) at this function instead of calling
-- GENERATE_PTW_LV_PDF directly.
--------------------------------------------------------------------------------
SET DEFINE OFF
CREATE OR REPLACE EDITIONABLE FUNCTION "PTW_PRO"."GENERATE_PTW_PERMIT_PDF" (
    p_permit_id       IN NUMBER,
    p_include_history IN VARCHAR2 DEFAULT 'N'
) RETURN CLOB
IS
    v_ptw_type ptw_pro.ptw_lv_permits.ptw_type%TYPE;
BEGIN
    IF p_permit_id IS NULL THEN
        RETURN '<div class="ptw-lv-report-container"><h2 style="color:red;">No Permit Selected</h2></div>';
    END IF;

    BEGIN
        SELECT ptw_type INTO v_ptw_type
        FROM   ptw_pro.ptw_lv_permits
        WHERE  permit_id = p_permit_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN '<div class="ptw-lv-report-container"><h2 style="color:red;">Permit Not Found</h2>'
                || '<p>Permit ID: ' || p_permit_id || '</p></div>';
    END;

    CASE v_ptw_type
        WHEN 'LV ISOLATION' THEN
            RETURN ptw_pro.generate_ptw_lv_pdf(p_permit_id, p_include_history);
        WHEN 'GENERAL' THEN
            RETURN ptw_pro.generate_ptw_general_pdf(p_permit_id, p_include_history);
        ELSE
            RETURN '<div class="ptw-lv-report-container">'
                || '<h2 style="color:red;">No PDF template defined for permit type: '
                || ptw_pro.ptw_pdf_lib_pkg.safe_val(v_ptw_type) || '</h2></div>';
    END CASE;
END generate_ptw_permit_pdf;
/
