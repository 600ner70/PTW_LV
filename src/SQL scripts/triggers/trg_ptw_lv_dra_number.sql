
  CREATE OR REPLACE EDITIONABLE TRIGGER "PTW_PRO"."TRG_PTW_LV_DRA_NUMBER"
BEFORE INSERT ON ptw_pro.ptw_lv_dra_assessments
FOR EACH ROW
FOLLOWS ptw_pro.trg_ptw_lv_dra_company
DECLARE
    v_prefix VARCHAR2(4);
    v_seq    NUMBER;
    v_year   VARCHAR2(4) := TO_CHAR(NVL(:NEW.created_date, SYSDATE), 'YYYY');
BEGIN
    IF :NEW.dra_number IS NOT NULL THEN
        RETURN;
    END IF;

    IF :NEW.company_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20061,
            'Cannot generate DRA number: company_id not set. Check trigger ordering.');
    END IF;

    SELECT permit_prefix,
           CASE WHEN last_dra_year = v_year THEN last_dra_seq + 1 ELSE 1 END
    INTO   v_prefix, v_seq
    FROM   ptw_pro.ptw_lv_companies
    WHERE  company_id = :NEW.company_id
    FOR UPDATE;

    IF v_prefix IS NULL THEN
        RAISE_APPLICATION_ERROR(-20062,
            'Cannot generate DRA number: no permit prefix set for this ' ||
            'company. Set one on the Company admin page first.');
    END IF;

    UPDATE ptw_pro.ptw_lv_companies
    SET    last_dra_seq  = v_seq,
           last_dra_year = v_year
    WHERE  company_id = :NEW.company_id;

    :NEW.dra_number := 'DRA-' || v_prefix || '/' || v_year || '/' || LPAD(v_seq, 5, '0');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20063,
            'Cannot generate DRA number: company_id ' || :NEW.company_id || ' not found.');
END;

/
ALTER TRIGGER "PTW_PRO"."TRG_PTW_LV_DRA_NUMBER" ENABLE;
