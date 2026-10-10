
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "PTW_PRO"."PTW_AUTH_WORKFLOW_PKG" AS

    ---------------------------------------------------------------------------
    -- Private helpers
    ---------------------------------------------------------------------------
    FUNCTION current_user_name RETURN VARCHAR2 IS
    BEGIN
        RETURN UPPER(NVL(V('APP_USER'), USER));
    END current_user_name;

    FUNCTION b64_to_blob (p_b64 IN CLOB) RETURN BLOB IS
    BEGIN
        IF p_b64 IS NULL OR DBMS_LOB.GETLENGTH(p_b64) = 0 THEN
            RETURN NULL;
        END IF;
        RETURN apex_web_service.clobbase642blob(
                   REGEXP_REPLACE(p_b64, '^data:image/[^;]+;base64,', ''));
    END b64_to_blob;

    FUNCTION user_full_name (p_username IN VARCHAR2) RETURN VARCHAR2 IS
        l_name VARCHAR2(201);
    BEGIN
        SELECT TRIM(first_name || ' ' || last_name)
        INTO   l_name
        FROM   ptw_pro.ptw_lv_users
        WHERE  UPPER(username) = UPPER(p_username);
        RETURN NVL(l_name, p_username);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN p_username;
    END user_full_name;

    PROCEDURE notify (
        p_username IN VARCHAR2,
        p_title    IN VARCHAR2,
        p_body     IN VARCHAR2
    ) IS
    BEGIN
        IF p_username IS NULL THEN
            RETURN;
        END IF;
        apex_pwa.send_push_notification(
            p_application_id => NVL(TO_NUMBER(V('APP_ID')), 105),
            p_user_name      => p_username,
            p_title          => p_title,
            p_body           => p_body
        );
    EXCEPTION
        -- User not subscribed / push not configured: never block the workflow.
        WHEN OTHERS THEN
            apex_debug.warn('ptw_auth_workflow_pkg.notify failed for %s: %s',
                            p_username, SQLERRM);
    END notify;

    ---------------------------------------------------------------------------
    -- Public
    ---------------------------------------------------------------------------
    FUNCTION is_authoriser (p_username IN VARCHAR2) RETURN VARCHAR2 IS
        l_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO   l_count
        FROM   ptw_pro.ptw_lv_user_roles_v
        WHERE  UPPER(username) = UPPER(p_username)
        AND    role_name IN ('AUTHORISER', 'ADMIN')
        AND    is_active = 'Y';
        RETURN CASE WHEN l_count > 0 THEN 'Y' ELSE 'N' END;
    END is_authoriser;

    FUNCTION can_authorise (
        p_permit_id IN ptw_pro.ptw_lv_permits.permit_id%TYPE,
        p_username  IN VARCHAR2
    ) RETURN VARCHAR2 IS
        l_status     ptw_pro.ptw_lv_permits.workflow_status%TYPE;
        l_created_by ptw_pro.ptw_lv_permits.created_by%TYPE;
    BEGIN
        SELECT workflow_status, created_by
        INTO   l_status, l_created_by
        FROM   ptw_pro.ptw_lv_permits
        WHERE  permit_id = p_permit_id;   -- VPD scopes to the caller's company

        IF l_status <> c_awaiting_auth THEN
            RETURN 'N';
        END IF;
        IF UPPER(l_created_by) = UPPER(p_username) THEN
            RETURN 'N';                   -- no self-authorisation
        END IF;
        RETURN is_authoriser(p_username);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN 'N';
    END can_authorise;


    PROCEDURE submit_for_authorisation (
        p_permit_id       IN ptw_pro.ptw_lv_permits.permit_id%TYPE,
        p_requested_auth  IN VARCHAR2,
        p_accept_name     IN ptw_pro.ptw_signatures.person_name%TYPE,
        p_accept_mobile   IN ptw_pro.ptw_signatures.mobile_no%TYPE,
        p_accept_company  IN ptw_pro.ptw_signatures.company_name%TYPE,
        p_accept_sig_b64  IN CLOB,
        p_latitude        IN NUMBER,
        p_longitude       IN NUMBER
    ) IS
        l_user        VARCHAR2(100) := current_user_name;
        l_now         DATE          := SYSDATE;
        l_permit_no   ptw_pro.ptw_lv_permits.permit_number%TYPE;
        l_req_company NUMBER;
        l_permit_co   NUMBER;
    BEGIN
        IF p_requested_auth IS NULL THEN
            RAISE_APPLICATION_ERROR(-20101, 'Select the authoriser to send this permit to.');
        END IF;
        IF UPPER(p_requested_auth) = l_user THEN
            RAISE_APPLICATION_ERROR(-20102, 'You cannot send a permit to yourself for authorisation.');
        END IF;
        IF is_authoriser(p_requested_auth) = 'N' THEN
            RAISE_APPLICATION_ERROR(-20103, 'The selected person is not an active authoriser.');
        END IF;
        IF p_accept_sig_b64 IS NULL THEN
            RAISE_APPLICATION_ERROR(-20104, 'The person in charge must sign the acceptance.');
        END IF;

        SELECT permit_number, company_id
        INTO   l_permit_no, l_permit_co
        FROM   ptw_pro.ptw_lv_permits
        WHERE  permit_id = p_permit_id;

        -- Requested authoriser must belong to the permit's company
        -- (super users acting for another company included).
        SELECT MAX(company_id)
        INTO   l_req_company
        FROM   ptw_pro.ptw_lv_users
        WHERE  UPPER(username) = UPPER(p_requested_auth);
        IF NVL(l_req_company, -1) <> l_permit_co THEN
            RAISE_APPLICATION_ERROR(-20105, 'The selected authoriser does not belong to this company.');
        END IF;

        UPDATE ptw_pro.ptw_lv_permits
        SET    workflow_status         = c_awaiting_auth,
               current_step            = 'AUTHORISATION',
               auth_requested_user     = UPPER(p_requested_auth),
               submitted_for_auth_by   = l_user,
               submitted_for_auth_date = l_now,
               accept_latitude         = p_latitude,
               accept_longitude        = p_longitude,
               modified_by             = l_user,
               modified_date           = CURRENT_TIMESTAMP
        WHERE  permit_id       = p_permit_id
        AND    workflow_status = 'DRAFT';

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20106,
                'Permit ' || l_permit_no || ' is no longer a draft and cannot be submitted.');
        END IF;

        ptw_pro.ptw_signature_pkg.save_signature(
            p_permit_id      => p_permit_id,
            p_stage          => 'ACCEPT',
            p_person_name    => p_accept_name,
            p_signature_blob => b64_to_blob(p_accept_sig_b64),
            p_mobile_no      => p_accept_mobile,
            p_company_name   => p_accept_company,
            p_event_datetime => l_now,
            p_latitude       => p_latitude,
            p_longitude      => p_longitude
        );

        notify(
            p_username => UPPER(p_requested_auth),
            p_title    => 'Permit awaiting your authorisation',
            p_body     => 'Permit ' || l_permit_no || ' has been submitted by '
                          || user_full_name(l_user) || ' and is waiting for you to authorise it.'
        );
    END submit_for_authorisation;


    PROCEDURE authorise (
        p_permit_id     IN ptw_pro.ptw_lv_permits.permit_id%TYPE,
        p_auth_sig_b64  IN CLOB,
        p_latitude      IN NUMBER,
        p_longitude     IN NUMBER
    ) IS
        l_user       VARCHAR2(100) := current_user_name;
        l_now        DATE          := SYSDATE;
        l_mobile     ptw_pro.ptw_lv_users.mobile_no%TYPE;
        l_permit_no  ptw_pro.ptw_lv_permits.permit_number%TYPE;
        l_created_by ptw_pro.ptw_lv_permits.created_by%TYPE;
    BEGIN
        IF can_authorise(p_permit_id, l_user) = 'N' THEN
            RAISE_APPLICATION_ERROR(-20111,
                'You are not able to authorise this permit. It may already have been '
                || 'authorised or rejected, or you created it.');
        END IF;
        IF p_auth_sig_b64 IS NULL THEN
            RAISE_APPLICATION_ERROR(-20112, 'Your signature is required to authorise.');
        END IF;

        BEGIN
            SELECT mobile_no INTO l_mobile
            FROM   ptw_pro.ptw_lv_users
            WHERE  UPPER(username) = l_user;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN l_mobile := NULL;
        END;

        UPDATE ptw_pro.ptw_lv_permits
        SET    workflow_status  = 'AUTHORISED',
               current_step     = 'AUTHORISATION',
               auth_person_name = l_user,      -- legacy column still read by
                                               -- dashboard/visibility filters
               auth_latitude    = p_latitude,
               auth_longitude   = p_longitude,
               modified_by      = l_user,
               modified_date    = CURRENT_TIMESTAMP
        WHERE  permit_id       = p_permit_id
        AND    workflow_status = c_awaiting_auth
        RETURNING permit_number, created_by INTO l_permit_no, l_created_by;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20113,
                'This permit is no longer awaiting authorisation. Please refresh.');
        END IF;

        ptw_pro.ptw_signature_pkg.save_signature(
            p_permit_id      => p_permit_id,
            p_stage          => 'AUTH',
            p_person_name    => l_user,
            p_signature_blob => b64_to_blob(p_auth_sig_b64),
            p_mobile_no      => l_mobile,
            p_event_datetime => l_now,
            p_latitude       => p_latitude,
            p_longitude      => p_longitude
        );

        notify(
            p_username => UPPER(l_created_by),
            p_title    => 'Permit authorised',
            p_body     => 'Permit ' || l_permit_no || ' has been authorised by '
                          || user_full_name(l_user) || '. You can now start it.'
        );
    END authorise;


    PROCEDURE reject (
        p_permit_id IN ptw_pro.ptw_lv_permits.permit_id%TYPE,
        p_reason    IN VARCHAR2
    ) IS
        l_user       VARCHAR2(100) := current_user_name;
        l_permit_no  ptw_pro.ptw_lv_permits.permit_number%TYPE;
        l_created_by ptw_pro.ptw_lv_permits.created_by%TYPE;
    BEGIN
        IF TRIM(p_reason) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20121, 'A reason is required to reject a permit.');
        END IF;
        IF can_authorise(p_permit_id, l_user) = 'N' THEN
            RAISE_APPLICATION_ERROR(-20122,
                'You are not able to reject this permit. It may already have been '
                || 'authorised or rejected, or you created it.');
        END IF;

        UPDATE ptw_pro.ptw_lv_permits
        SET    workflow_status    = 'DRAFT',
               current_step       = 'AUTHORISATION',
               auth_rejected_by   = l_user,
               auth_rejected_date = SYSDATE,
               auth_reject_reason = SUBSTR(TRIM(p_reason), 1, 1000),
               modified_by        = l_user,
               modified_date      = CURRENT_TIMESTAMP
        WHERE  permit_id       = p_permit_id
        AND    workflow_status = c_awaiting_auth
        RETURNING permit_number, created_by INTO l_permit_no, l_created_by;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20123,
                'This permit is no longer awaiting authorisation. Please refresh.');
        END IF;

        -- Force a fresh acceptance signature on resubmission.
        DELETE FROM ptw_pro.ptw_signatures
        WHERE  permit_id = p_permit_id
        AND    stage     = 'ACCEPT';

        notify(
            p_username => UPPER(l_created_by),
            p_title    => 'Permit returned',
            p_body     => 'Permit ' || l_permit_no || ' was returned by '
                          || user_full_name(l_user) || ': ' || SUBSTR(TRIM(p_reason), 1, 150)
        );
    END reject;

END ptw_auth_workflow_pkg;
/
