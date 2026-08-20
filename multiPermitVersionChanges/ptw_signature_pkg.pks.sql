CREATE OR REPLACE PACKAGE ptw_pro.ptw_signature_pkg AS
    --------------------------------------------------------------------------
    -- Not permit-type-variable, just badly normalized — no JSON needed here.
    -- One reusable procedure instead of 4 near-identical DML blocks
    -- (AUTH / ACCEPT / CLEAR / CANCEL) currently living in Page 5 processes.
    -- p_stage must be one of 'AUTH','ACCEPT','CLEAR','CANCEL'.
    -- Pass NULL for fields a given stage doesn't use (e.g. AUTH has no
    -- company_name, CANCEL has neither mobile_no nor company_name — matches
    -- what PTW_LV_PERMITS actually stores today).
    --------------------------------------------------------------------------
    PROCEDURE save_signature(
        p_permit_id       IN ptw_pro.ptw_lv_permits.permit_id%TYPE,
        p_stage           IN ptw_pro.ptw_signatures.stage%TYPE,
        p_person_name     IN ptw_pro.ptw_signatures.person_name%TYPE,
        p_signature_blob  IN ptw_pro.ptw_signatures.signature_blob%TYPE,
        p_mobile_no       IN ptw_pro.ptw_signatures.mobile_no%TYPE     DEFAULT NULL,
        p_company_name    IN ptw_pro.ptw_signatures.company_name%TYPE  DEFAULT NULL,
        p_event_datetime  IN ptw_pro.ptw_signatures.event_datetime%TYPE DEFAULT SYSDATE,
        p_latitude        IN ptw_pro.ptw_signatures.latitude%TYPE      DEFAULT NULL,
        p_longitude       IN ptw_pro.ptw_signatures.longitude%TYPE     DEFAULT NULL
    );

    -- For populating page items when a page re-displays an already-signed stage
    PROCEDURE get_signature(
        p_permit_id       IN  ptw_pro.ptw_lv_permits.permit_id%TYPE,
        p_stage           IN  ptw_pro.ptw_signatures.stage%TYPE,
        p_person_name     OUT ptw_pro.ptw_signatures.person_name%TYPE,
        p_signature_blob  OUT ptw_pro.ptw_signatures.signature_blob%TYPE,
        p_mobile_no       OUT ptw_pro.ptw_signatures.mobile_no%TYPE,
        p_company_name    OUT ptw_pro.ptw_signatures.company_name%TYPE,
        p_event_datetime  OUT ptw_pro.ptw_signatures.event_datetime%TYPE,
        p_latitude        OUT ptw_pro.ptw_signatures.latitude%TYPE,
        p_longitude       OUT ptw_pro.ptw_signatures.longitude%TYPE
    );

END ptw_signature_pkg;
/
