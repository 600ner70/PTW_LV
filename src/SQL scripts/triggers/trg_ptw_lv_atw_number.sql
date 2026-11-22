
  CREATE OR REPLACE EDITIONABLE TRIGGER "PTW_PRO"."TRG_PTW_LV_ATW_NUMBER"
BEFORE UPDATE OF status ON ptw_pro.ptw_lv_atw
FOR EACH ROW
 WHEN (NEW.status = 'ISSUED' AND NEW.atw_number IS NULL) DECLARE
    v_prefix VARCHAR2(4);
    v_seq    NUMBER;
    v_year   VARCHAR2(4) := TO_CHAR(:NEW.valid_date, 'YYYY');
BEGIN
    SELECT permit_prefix,
           CASE WHEN last_atw_year = v_year THEN last_atw_seq + 1 ELSE 1 END
    INTO   v_prefix, v_seq
    FROM   ptw_pro.ptw_lv_companies
    WHERE  company_id = :NEW.company_id
    FOR UPDATE;

    IF v_prefix IS NULL THEN
        RAISE_APPLICATION_ERROR(-20201,
            'Cannot generate ATW number: no permit prefix set for this company. '
            || 'Set one on the Company admin page first.');
    END IF;

    UPDATE ptw_pro.ptw_lv_companies
    SET    last_atw_seq  = v_seq,
           last_atw_year = v_year
    WHERE  company_id = :NEW.company_id;

    :NEW.atw_number := 'ATW-' || v_prefix || '/' || v_year || '/' || LPAD(v_seq, 5, '0');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20202,
            'Cannot generate ATW number: company_id ' || :NEW.company_id || ' not found.');
END;
/
ALTER TRIGGER "PTW_PRO"."TRG_PTW_LV_ATW_NUMBER" ENABLE;
