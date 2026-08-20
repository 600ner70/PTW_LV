CREATE OR REPLACE PACKAGE ptw_pro.ptw_checklist_pkg AS
    --------------------------------------------------------------------------
    -- Loads the checklist for a permit: every active checklist item for the
    -- permit's PTW_TYPE, left-joined to any existing response. Type is
    -- derived from the permit itself, not passed in, so a permit_id the
    -- caller's VPD context can't see returns NO_DATA_FOUND rather than
    -- letting the caller pick an arbitrary type_id.
    --
    -- Returns a JSON array, e.g.:
    -- [{"checklist_item_id":101,"item_code":"CM_01_SITE_INDUCTION",
    --   "section":"CONTROL_MEASURES","seq":10,"question":"...",
    --   "help":"...","response_type":"TRISTATE","response":"Y"}, ...]
    --------------------------------------------------------------------------
    FUNCTION get_checklist_json(p_permit_id IN ptw_pro.ptw_lv_permits.permit_id%TYPE)
        RETURN CLOB;

    --------------------------------------------------------------------------
    -- Saves responses from a JSON array in the same shape:
    -- [{"checklist_item_id":101,"response":"Y"}, ...]
    -- (extra keys are ignored, so the same payload from get_checklist_json
    -- can be round-tripped straight back in)
    --
    -- company_id is derived from the permit, never taken from the payload.
    --------------------------------------------------------------------------
    PROCEDURE save_checklist_responses(
        p_permit_id IN ptw_pro.ptw_lv_permits.permit_id%TYPE,
        p_json      IN CLOB
    );

END ptw_checklist_pkg;
/
