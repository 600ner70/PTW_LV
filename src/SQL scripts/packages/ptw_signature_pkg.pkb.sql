
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "PTW_PRO"."PTW_SIGNATURE_PKG" AS

    PROCEDURE save_signature(
        p_permit_id        IN ptw_pro.ptw_lv_permits.permit_id%TYPE,
        p_stage            IN ptw_pro.ptw_signatures.stage%TYPE,
        p_person_name      IN ptw_pro.ptw_signatures.person_name%TYPE,
        p_signature_blob   IN ptw_pro.ptw_signatures.signature_blob%TYPE,
        p_mobile_no        IN ptw_pro.ptw_signatures.mobile_no%TYPE      DEFAULT NULL,
        p_company_name     IN ptw_pro.ptw_signatures.company_name%TYPE   DEFAULT NULL,
        p_event_datetime   IN ptw_pro.ptw_signatures.event_datetime%TYPE DEFAULT SYSDATE,
        p_latitude         IN ptw_pro.ptw_signatures.latitude%TYPE       DEFAULT NULL,
        p_longitude        IN ptw_pro.ptw_signatures.longitude%TYPE      DEFAULT NULL,
        p_auth_to_datetime IN ptw_pro.ptw_signatures.auth_to_datetime%TYPE DEFAULT NULL
    ) IS
        l_company_id ptw_pro.ptw_lv_permits.company_id%TYPE;
    BEGIN
        IF p_stage NOT IN ('AUTH','ACCEPT','CLEAR','CANCEL','CLOSE') THEN
            RAISE_APPLICATION_ERROR(-20060, 'Invalid signature stage: ' || p_stage);
        END IF;

        SELECT company_id INTO l_company_id
        FROM   ptw_pro.ptw_lv_permits
        WHERE  permit_id = p_permit_id;

        MERGE INTO ptw_pro.ptw_signatures sig
        USING (SELECT p_permit_id AS permit_id, p_stage AS stage FROM dual) src
        ON (sig.permit_id = src.permit_id AND sig.stage = src.stage)
        WHEN MATCHED THEN
            UPDATE SET person_name      = p_person_name,
                       signature_blob   = p_signature_blob,
                       mobile_no        = p_mobile_no,
                       company_name     = p_company_name,
                       event_datetime   = p_event_datetime,
                       latitude         = p_latitude,
                       longitude        = p_longitude,
                       auth_to_datetime = p_auth_to_datetime,
                       modified_date    = CURRENT_TIMESTAMP,
                       modified_by      = NVL(V('APP_USER'), USER)
        WHEN NOT MATCHED THEN
            INSERT (permit_id, stage, person_name, signature_blob, mobile_no,
                    company_name, event_datetime, latitude, longitude,
                    auth_to_datetime, company_id, created_by)
            VALUES (p_permit_id, p_stage, p_person_name, p_signature_blob, p_mobile_no,
                    p_company_name, p_event_datetime, p_latitude, p_longitude,
                    p_auth_to_datetime, l_company_id, NVL(V('APP_USER'), USER));

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20061, 'Permit ' || p_permit_id
                || ' not found or not accessible.');
        WHEN OTHERS THEN
            IF SQLCODE IN (-20060, -20061) THEN
                RAISE;
            END IF;
            RAISE_APPLICATION_ERROR(-20062, 'Error saving ' || p_stage
                || ' signature for permit ' || p_permit_id || ': ' || SQLERRM);
    END save_signature;


    PROCEDURE get_signature(
        p_permit_id        IN  ptw_pro.ptw_lv_permits.permit_id%TYPE,
        p_stage            IN  ptw_pro.ptw_signatures.stage%TYPE,
        p_person_name      OUT ptw_pro.ptw_signatures.person_name%TYPE,
        p_signature_blob   OUT ptw_pro.ptw_signatures.signature_blob%TYPE,
        p_mobile_no        OUT ptw_pro.ptw_signatures.mobile_no%TYPE,
        p_company_name     OUT ptw_pro.ptw_signatures.company_name%TYPE,
        p_event_datetime   OUT ptw_pro.ptw_signatures.event_datetime%TYPE,
        p_latitude         OUT ptw_pro.ptw_signatures.latitude%TYPE,
        p_longitude        OUT ptw_pro.ptw_signatures.longitude%TYPE,
        p_auth_to_datetime OUT ptw_pro.ptw_signatures.auth_to_datetime%TYPE
    ) IS
    BEGIN
        SELECT person_name, signature_blob, mobile_no, company_name, event_datetime,
               latitude, longitude, auth_to_datetime
        INTO   p_person_name, p_signature_blob, p_mobile_no, p_company_name, p_event_datetime,
               p_latitude, p_longitude, p_auth_to_datetime
        FROM   ptw_pro.ptw_signatures
        WHERE  permit_id = p_permit_id
        AND    stage     = p_stage;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_person_name      := NULL;
            p_signature_blob   := NULL;
            p_mobile_no        := NULL;
            p_company_name     := NULL;
            p_event_datetime   := NULL;
            p_latitude         := NULL;
            p_longitude        := NULL;
            p_auth_to_datetime := NULL;
    END get_signature;

END ptw_signature_pkg;
/
