
  CREATE OR REPLACE EDITIONABLE TRIGGER "PTW_PRO"."TRG_PTW_LV_PERMIT_NUMBER"
BEFORE INSERT ON ptw_pro.ptw_lv_permits
FOR EACH ROW
DECLARE
    v_prefix VARCHAR2(4);
    v_seq    NUMBER;
    -- Use the permit's own created_date if already set
    -- (offline sync passes an explicit created_date).
    -- This ensures the year in the permit number always
    -- matches the actual date on the record.
    v_year   VARCHAR2(4) := TO_CHAR(
                                NVL(:NEW.created_date, SYSDATE),
                                'YYYY'
                            );
BEGIN
    -- If permit_number is already set leave it unchanged.
    -- (Handles any manual override or re-insert scenario.)
    IF :NEW.permit_number IS NOT NULL THEN
        RETURN;
    END IF;

    -- company_id must already be stamped by
    -- trg_ptw_lv_permits_company before this trigger fires.
    IF :NEW.company_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20013,
            'Cannot generate permit number: company_id not ' ||
            'set. Check trigger ordering.');
    END IF;

    -- Lock the company row and derive the next sequence
    -- number atomically. FOR UPDATE prevents two concurrent
    -- inserts for the same company getting the same number.
    -- Yearly reset: if last_permit_year differs from current
    -- year (or is NULL = first permit ever for this company)
    -- the sequence resets to 1.
    SELECT permit_prefix,
           CASE
               WHEN last_permit_year = v_year
               THEN last_permit_seq + 1
               ELSE 1
           END
    INTO   v_prefix, v_seq
    FROM   ptw_pro.ptw_lv_companies
    WHERE  company_id = :NEW.company_id
    FOR UPDATE;

    IF v_prefix IS NULL THEN
        RAISE_APPLICATION_ERROR(-20014,
            'Cannot generate permit number: no permit prefix ' ||
            'set for this company. Set a prefix on the ' ||
            'Company admin page first.');
    END IF;

    -- Store the updated sequence back to the company row.
    UPDATE ptw_pro.ptw_lv_companies
    SET    last_permit_seq  = v_seq,
           last_permit_year = v_year
    WHERE  company_id = :NEW.company_id;

    -- Stamp the generated permit number onto the new row.
    :NEW.permit_number := v_prefix
                       || '/' || v_year
                       || '/' || LPAD(v_seq, 5, '0');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20015,
            'Cannot generate permit number: company_id '  ||
            :NEW.company_id || ' not found.');
END trg_ptw_lv_permit_number;

/
ALTER TRIGGER "PTW_PRO"."TRG_PTW_LV_PERMIT_NUMBER" ENABLE;
