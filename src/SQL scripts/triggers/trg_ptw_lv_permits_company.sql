
  CREATE OR REPLACE EDITIONABLE TRIGGER "PTW_PRO"."TRG_PTW_LV_PERMITS_COMPANY"
BEFORE INSERT ON ptw_pro.ptw_lv_permits
FOR EACH ROW
 WHEN (NEW.company_id IS NULL) DECLARE
    v_app_user      VARCHAR2(255);
    v_company_id    ptw_pro.ptw_lv_users.company_id%TYPE;
    v_is_super_user ptw_pro.ptw_lv_users.is_super_user%TYPE;
    v_override      VARCHAR2(50);
BEGIN
    v_app_user := SYS_CONTEXT('APEX$SESSION', 'APP_USER');

    SELECT company_id, is_super_user
    INTO   v_company_id, v_is_super_user
    FROM   ptw_pro.ptw_lv_users
    WHERE  UPPER(username) = UPPER(v_app_user)
    AND    is_active = 'Y';

    IF v_is_super_user = 'Y' THEN
        v_override := V('G_OVERRIDE_COMPANY_ID');
        IF v_override IS NULL OR v_override = '' THEN
            RAISE_APPLICATION_ERROR(-20010,
                'Super User: please select a company before creating a permit.');
        END IF;
        :NEW.company_id := TO_NUMBER(v_override);
    ELSE
        IF v_company_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20011,
                'Your user account is not assigned to a company. Contact your administrator.');
        END IF;
        :NEW.company_id := v_company_id;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20012,
            'Unable to determine company for this permit.');
END;

/
ALTER TRIGGER "PTW_PRO"."TRG_PTW_LV_PERMITS_COMPANY" ENABLE;
