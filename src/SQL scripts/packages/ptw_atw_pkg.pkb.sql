
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "PTW_PRO"."PTW_ATW_PKG" AS

    ---------------------------------------------------------------------------
    -- Private types / helpers
    ---------------------------------------------------------------------------
    -- NOTE: private functions (app_user, yn, user_full_name, ...) cannot be
    -- called inside SQL statements (PLS-00231). Every SQL statement below
    -- uses local variables computed beforehand.
    SUBTYPE t_atw IS ptw_pro.ptw_lv_atw%ROWTYPE;

    c_live_statuses CONSTANT VARCHAR2(100) := ':ISSUED:ON_SITE:CHECKED_OUT:';

    FUNCTION app_user RETURN VARCHAR2 IS
    BEGIN
        RETURN UPPER(NVL(V('APP_USER'), USER));
    END app_user;

    FUNCTION is_live (p_status IN VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN INSTR(c_live_statuses, ':' || p_status || ':') > 0;
    END is_live;

    FUNCTION has_any_role (
        p_username IN VARCHAR2,
        p_roles    IN apex_t_varchar2
    ) RETURN VARCHAR2 IS
        l_count NUMBER;
    BEGIN
        IF p_username IS NULL THEN
            RETURN 'N';
        END IF;
        SELECT COUNT(*)
        INTO   l_count
        FROM   ptw_pro.ptw_lv_user_roles_v
        WHERE  UPPER(username) = UPPER(p_username)
        AND    role_name IN (SELECT column_value FROM TABLE(p_roles))
        AND    is_active = 'Y';
        RETURN CASE WHEN l_count > 0 THEN 'Y' ELSE 'N' END;
    END has_any_role;

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

    FUNCTION holder_username (p_user_id IN NUMBER) RETURN VARCHAR2 IS
        l_username ptw_pro.ptw_lv_users.username%TYPE;
    BEGIN
        SELECT UPPER(username) INTO l_username
        FROM   ptw_pro.ptw_lv_users
        WHERE  user_id = p_user_id;
        RETURN l_username;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN NULL;
    END holder_username;

    -- Lock and return the ATW. VPD hides other companies' (and, for
    -- contractors, other holders') rows, so "not found" covers both.
    FUNCTION get_for_update (p_atw_id IN ptw_pro.ptw_lv_atw.atw_id%TYPE) RETURN t_atw IS
        l_row t_atw;
    BEGIN
        SELECT *
        INTO   l_row
        FROM   ptw_pro.ptw_lv_atw
        WHERE  atw_id = p_atw_id
        FOR UPDATE;
        RETURN l_row;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20204,
                'Authority to Work ' || p_atw_id || ' not found or not accessible.');
    END get_for_update;

    PROCEDURE log_event (
        p_atw_id     IN NUMBER,
        p_event_type IN VARCHAR2,
        p_on_behalf  IN VARCHAR2 DEFAULT 'N',
        p_latitude   IN NUMBER   DEFAULT NULL,
        p_longitude  IN NUMBER   DEFAULT NULL,
        p_notes      IN VARCHAR2 DEFAULT NULL
    ) IS
        l_now DATE          := local_now;
        l_by  VARCHAR2(255) := app_user;
    BEGIN
        INSERT INTO ptw_pro.ptw_lv_atw_events
            (atw_id, event_type, event_datetime, event_by, on_behalf,
             latitude, longitude, notes)
        VALUES
            (p_atw_id, p_event_type, l_now, l_by, NVL(p_on_behalf, 'N'),
             p_latitude, p_longitude, SUBSTR(p_notes, 1, 1000));
    END log_event;

    -- Same behaviour as ptw_auth_workflow_pkg.notify: never blocks the workflow.
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
        WHEN OTHERS THEN
            apex_debug.warn('ptw_atw_pkg.notify failed for %s: %s', p_username, SQLERRM);
    END notify;

    PROCEDURE assert_issuer IS
    BEGIN
        IF is_issuer(app_user) = 'N' THEN
            RAISE_APPLICATION_ERROR(-20203,
                'You do not have permission to issue or change an Authority to Work.');
        END IF;
    END assert_issuer;

    -- Holder must be an active CONTRACTOR in the caller's effective company,
    -- and must not be the issuer. Returns the user row for the snapshot.
    FUNCTION get_valid_holder (p_holder_user_id IN NUMBER) RETURN ptw_pro.ptw_lv_users%ROWTYPE IS
        l_user ptw_pro.ptw_lv_users%ROWTYPE;
    BEGIN
        IF p_holder_user_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20205, 'Select the contractor this Authority to Work is for.');
        END IF;

        BEGIN
            SELECT * INTO l_user
            FROM   ptw_pro.ptw_lv_users
            WHERE  user_id   = p_holder_user_id
            AND    is_active = 'Y'
            AND    company_id = ptw_pro.ptw_sec_pkg.get_effective_company_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20205,
                    'The selected contractor is not an active user in this company.');
        END;

        IF is_contractor(l_user.username) = 'N' THEN
            RAISE_APPLICATION_ERROR(-20205,
                'The selected user does not have the CONTRACTOR role.');
        END IF;
        IF UPPER(l_user.username) = app_user THEN
            RAISE_APPLICATION_ERROR(-20206, 'You cannot issue an Authority to Work to yourself.');
        END IF;
        IF TRIM(l_user.employer_name) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20207,
                'Record the contractor''s employer on their user profile before issuing.');
        END IF;
        RETURN l_user;
    END get_valid_holder;

    PROCEDURE assert_site (p_site_id IN NUMBER) IS
        l_count NUMBER;
    BEGIN
        -- PTW_LV_SITES is VPD-protected: only the caller's company's sites match.
        SELECT COUNT(*) INTO l_count
        FROM   ptw_pro.ptw_lv_sites
        WHERE  site_id   = p_site_id
        AND    is_active = 'Y';
        IF l_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20209, 'Select an active site.');
        END IF;
    END assert_site;

    FUNCTION yn (p_val IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE WHEN UPPER(p_val) = 'Y' THEN 'Y' ELSE 'N' END;
    END yn;

    FUNCTION fmt_date (p_date IN DATE) RETURN VARCHAR2 IS
    BEGIN
        RETURN TO_CHAR(p_date, 'DD-MON-YYYY');
    END fmt_date;

    FUNCTION fmt_time (p_date IN DATE) RETURN VARCHAR2 IS
    BEGIN
        RETURN TO_CHAR(p_date, 'HH24:MI');
    END fmt_time;

    -- Internal check-in used by check_in and issue_atw(p_check_in_now => 'Y').
    PROCEDURE do_check_in (
        p_row        IN t_atw,
        p_on_behalf  IN VARCHAR2,
        p_latitude   IN NUMBER,
        p_longitude  IN NUMBER
    ) IS
        l_now DATE := local_now;
    BEGIN
        UPDATE ptw_pro.ptw_lv_atw
        SET    status             = 'ON_SITE',
               check_in_datetime  = l_now,
               check_out_datetime = NULL
        WHERE  atw_id = p_row.atw_id;

        log_event(p_row.atw_id, 'CHECK_IN', p_on_behalf, p_latitude, p_longitude);
    END do_check_in;


    ---------------------------------------------------------------------------
    -- Public: time
    ---------------------------------------------------------------------------
    FUNCTION local_now RETURN DATE IS
    BEGIN
        RETURN CAST(SYSTIMESTAMP AT TIME ZONE c_tz AS DATE);
    END local_now;

    FUNCTION local_today RETURN DATE IS
    BEGIN
        RETURN TRUNC(local_now);
    END local_today;


    ---------------------------------------------------------------------------
    -- Public: roles
    ---------------------------------------------------------------------------
    FUNCTION is_issuer (p_username IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN has_any_role(p_username, apex_t_varchar2('ADMIN', 'AUTHORISER', 'ATW_ISSUER'));
    END is_issuer;

    FUNCTION is_contractor (p_username IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN has_any_role(p_username, apex_t_varchar2('CONTRACTOR'));
    END is_contractor;

    FUNCTION can_verify (p_username IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN has_any_role(p_username,
                            apex_t_varchar2('ADMIN', 'AUTHORISER', 'ATW_ISSUER', 'SECURITY'));
    END can_verify;

    FUNCTION effective_status (
        p_status     IN ptw_pro.ptw_lv_atw.status%TYPE,
        p_valid_date IN ptw_pro.ptw_lv_atw.valid_date%TYPE
    ) RETURN VARCHAR2 IS
    BEGIN
        IF is_live(p_status) AND p_valid_date < local_today THEN
            RETURN 'EXPIRED';
        END IF;
        RETURN p_status;
    END effective_status;


    ---------------------------------------------------------------------------
    -- Public: issuer actions
    ---------------------------------------------------------------------------
    PROCEDURE save_draft (
        p_atw_id            IN OUT ptw_pro.ptw_lv_atw.atw_id%TYPE,
        p_site_id           IN     ptw_pro.ptw_lv_atw.site_id%TYPE,
        p_holder_user_id    IN     ptw_pro.ptw_lv_atw.holder_user_id%TYPE,
        p_work_description  IN     ptw_pro.ptw_lv_atw.work_description%TYPE,
        p_rams_reference    IN     ptw_pro.ptw_lv_atw.rams_reference%TYPE,
        p_induction_ok      IN     ptw_pro.ptw_lv_atw.induction_ok%TYPE,
        p_ssow_ok           IN     ptw_pro.ptw_lv_atw.ssow_ok%TYPE,
        p_competence_ok     IN     ptw_pro.ptw_lv_atw.competence_ok%TYPE,
        p_equipment_ppe_ok  IN     ptw_pro.ptw_lv_atw.equipment_ppe_ok%TYPE,
        p_issuer_notes      IN     ptw_pro.ptw_lv_atw.issuer_notes%TYPE
    ) IS
        l_today  DATE        := local_today;
        l_ind    VARCHAR2(1) := yn(p_induction_ok);
        l_ssow   VARCHAR2(1) := yn(p_ssow_ok);
        l_comp   VARCHAR2(1) := yn(p_competence_ok);
        l_ppe    VARCHAR2(1) := yn(p_equipment_ppe_ok);
        l_holder ptw_pro.ptw_lv_users%ROWTYPE;
        l_row    t_atw;
    BEGIN
        assert_issuer;
        assert_site(p_site_id);
        l_holder := get_valid_holder(p_holder_user_id);

        IF p_atw_id IS NULL THEN
            INSERT INTO ptw_pro.ptw_lv_atw (
                site_id, holder_user_id, holder_name, holder_employer, holder_mobile,
                valid_date, work_description, rams_reference,
                induction_ok, ssow_ok, competence_ok, equipment_ppe_ok,
                issuer_notes, status
            ) VALUES (
                p_site_id, l_holder.user_id,
                TRIM(l_holder.first_name || ' ' || l_holder.last_name),
                TRIM(l_holder.employer_name), l_holder.mobile_no,
                l_today, TRIM(p_work_description), TRIM(p_rams_reference),
                l_ind, l_ssow, l_comp, l_ppe,
                TRIM(p_issuer_notes), 'DRAFT'
            )
            RETURNING atw_id INTO p_atw_id;

            log_event(p_atw_id, 'CREATED');
        ELSE
            l_row := get_for_update(p_atw_id);

            IF l_row.status NOT IN ('DRAFT', 'REQUESTED') THEN
                RAISE_APPLICATION_ERROR(-20210,
                    'This Authority to Work is ' || l_row.status || ' and can no longer be edited.');
            END IF;
            IF l_row.valid_date <> l_today THEN
                RAISE_APPLICATION_ERROR(-20211,
                    'This Authority to Work was for ' || fmt_date(l_row.valid_date)
                    || '. Cancel it and start a new one for today.');
            END IF;
            IF l_row.status = 'REQUESTED' AND l_row.holder_user_id <> p_holder_user_id THEN
                RAISE_APPLICATION_ERROR(-20205,
                    'A contractor''s request cannot be moved to a different person.');
            END IF;

            UPDATE ptw_pro.ptw_lv_atw
            SET    site_id          = p_site_id,
                   holder_user_id   = l_holder.user_id,
                   holder_name      = TRIM(l_holder.first_name || ' ' || l_holder.last_name),
                   holder_employer  = TRIM(l_holder.employer_name),
                   holder_mobile    = l_holder.mobile_no,
                   work_description = TRIM(p_work_description),
                   rams_reference   = TRIM(p_rams_reference),
                   induction_ok     = l_ind,
                   ssow_ok          = l_ssow,
                   competence_ok    = l_comp,
                   equipment_ppe_ok = l_ppe,
                   issuer_notes     = TRIM(p_issuer_notes)
            WHERE  atw_id = p_atw_id;

            log_event(p_atw_id, 'UPDATED');
        END IF;

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20208,
                l_holder.first_name || ' ' || l_holder.last_name
                || ' already has an Authority to Work for today. Open it from the ATW register instead.');
    END save_draft;


    PROCEDURE issue_atw (
        p_atw_id          IN ptw_pro.ptw_lv_atw.atw_id%TYPE,
        p_issuer_sig_b64  IN CLOB,
        p_latitude        IN NUMBER   DEFAULT NULL,
        p_longitude       IN NUMBER   DEFAULT NULL,
        p_check_in_now    IN VARCHAR2 DEFAULT 'N'
    ) IS
        l_user     VARCHAR2(255) := app_user;
        l_now      DATE          := local_now;
        l_name     VARCHAR2(201);
        l_token    ptw_pro.ptw_lv_atw.verify_token%TYPE;
        l_row      t_atw;
        l_holder   ptw_pro.ptw_lv_users%ROWTYPE;
        l_missing  VARCHAR2(400);
        l_number   ptw_pro.ptw_lv_atw.atw_number%TYPE;
        l_site     ptw_pro.ptw_lv_sites.site_name%TYPE;
    BEGIN
        assert_issuer;
        l_row := get_for_update(p_atw_id);

        IF l_row.status NOT IN ('DRAFT', 'REQUESTED') THEN
            RAISE_APPLICATION_ERROR(-20210,
                'This Authority to Work is ' || l_row.status || ' and cannot be issued.');
        END IF;
        IF l_row.valid_date <> local_today THEN
            RAISE_APPLICATION_ERROR(-20211,
                'This Authority to Work was for ' || fmt_date(l_row.valid_date)
                || '. An ATW can only be issued on the day it is valid.');
        END IF;

        IF l_row.induction_ok     = 'N' THEN l_missing := l_missing || ', Site induction';        END IF;
        IF l_row.ssow_ok          = 'N' THEN l_missing := l_missing || ', Safe system of work';   END IF;
        IF l_row.competence_ok    = 'N' THEN l_missing := l_missing || ', Competence';            END IF;
        IF l_row.equipment_ppe_ok = 'N' THEN l_missing := l_missing || ', Equipment and PPE';     END IF;
        IF l_missing IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20212,
                'All four checks must be confirmed before issuing. Outstanding: '
                || LTRIM(l_missing, ', ') || '.');
        END IF;

        IF p_issuer_sig_b64 IS NULL OR DBMS_LOB.GETLENGTH(p_issuer_sig_b64) = 0 THEN
            RAISE_APPLICATION_ERROR(-20213, 'Your signature is required to issue.');
        END IF;

        -- Re-validate the holder at the moment of issue (role / active /
        -- employer may have changed since the draft was saved).
        l_holder := get_valid_holder(l_row.holder_user_id);
        l_name   := user_full_name(l_user);
        l_token  := LOWER(RAWTOHEX(SYS.DBMS_CRYPTO.RANDOMBYTES(16)));

        UPDATE ptw_pro.ptw_lv_atw
        SET    status           = 'ISSUED',
               holder_name      = TRIM(l_holder.first_name || ' ' || l_holder.last_name),
               holder_employer  = TRIM(l_holder.employer_name),
               holder_mobile    = l_holder.mobile_no,
               issued_by        = l_user,
               issuer_name      = l_name,
               issued_datetime  = l_now,
               issuer_signature = apex_web_service.clobbase642blob(
                                      REGEXP_REPLACE(p_issuer_sig_b64, '^data:image/[^;]+;base64,', '')),
               issue_latitude   = p_latitude,
               issue_longitude  = p_longitude,
               verify_token     = l_token
        WHERE  atw_id = p_atw_id
        RETURNING atw_number INTO l_number;

        log_event(p_atw_id, 'ISSUED', 'N', p_latitude, p_longitude);

        IF UPPER(p_check_in_now) = 'Y' THEN
            l_row.status := 'ISSUED';
            do_check_in(l_row, 'Y', p_latitude, p_longitude);
        END IF;

        SELECT site_name INTO l_site
        FROM   ptw_pro.ptw_lv_sites
        WHERE  site_id = l_row.site_id;

        notify(
            p_username => UPPER(l_holder.username),
            p_title    => 'Authority to Work issued',
            p_body     => 'Your Authority to Work ' || l_number || ' for ' || l_site
                          || ' is valid today (' || fmt_date(l_row.valid_date) || '). '
                          || 'Open PTW-PRO to show your pass'
                          || CASE WHEN UPPER(p_check_in_now) = 'Y' THEN '.' ELSE ' and check in.' END
        );

    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE BETWEEN -20239 AND -20200 THEN
                RAISE;
            END IF;
            RAISE_APPLICATION_ERROR(-20214, 'Error issuing Authority to Work: ' || SQLERRM);
    END issue_atw;


    PROCEDURE revoke_atw (
        p_atw_id  IN ptw_pro.ptw_lv_atw.atw_id%TYPE,
        p_reason  IN ptw_pro.ptw_lv_atw.revoke_reason%TYPE
    ) IS
        l_row  t_atw;
        l_user VARCHAR2(255) := app_user;
        l_now  DATE          := local_now;
    BEGIN
        assert_issuer;
        l_row := get_for_update(p_atw_id);

        IF NOT is_live(l_row.status) THEN
            RAISE_APPLICATION_ERROR(-20220,
                'Only an issued Authority to Work can be revoked (this one is ' || l_row.status || ').');
        END IF;
        IF TRIM(p_reason) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20221, 'Record the reason for revoking.');
        END IF;

        UPDATE ptw_pro.ptw_lv_atw
        SET    status           = 'REVOKED',
               revoked_by       = l_user,
               revoked_datetime = l_now,
               revoke_reason    = TRIM(p_reason),
               not_checked_out  = CASE WHEN status = 'ON_SITE' THEN 'Y' ELSE 'N' END
        WHERE  atw_id = p_atw_id;

        log_event(p_atw_id, 'REVOKED', 'N', NULL, NULL, p_reason);

        notify(
            p_username => holder_username(l_row.holder_user_id),
            p_title    => 'Authority to Work revoked',
            p_body     => 'Your Authority to Work ' || l_row.atw_number
                          || ' has been revoked. Stop work and speak to the BGIS site contact.'
        );
    END revoke_atw;


    PROCEDURE cancel_atw (
        p_atw_id  IN ptw_pro.ptw_lv_atw.atw_id%TYPE,
        p_reason  IN VARCHAR2 DEFAULT NULL
    ) IS
        l_row t_atw;
    BEGIN
        l_row := get_for_update(p_atw_id);

        IF l_row.status NOT IN ('DRAFT', 'REQUESTED') THEN
            RAISE_APPLICATION_ERROR(-20222,
                'Only a draft or requested Authority to Work can be cancelled. Use Revoke instead.');
        END IF;
        -- Issuers can cancel anything; a contractor can withdraw their own request.
        IF is_issuer(app_user) = 'N'
           AND NOT (l_row.status = 'REQUESTED' AND UPPER(l_row.requested_by) = app_user)
        THEN
            RAISE_APPLICATION_ERROR(-20203,
                'You do not have permission to cancel this Authority to Work.');
        END IF;

        UPDATE ptw_pro.ptw_lv_atw
        SET    status = 'CANCELLED'
        WHERE  atw_id = p_atw_id;

        log_event(p_atw_id, 'CANCELLED', 'N', NULL, NULL, p_reason);
    END cancel_atw;


    ---------------------------------------------------------------------------
    -- Public: holder / on-behalf actions
    ---------------------------------------------------------------------------
    PROCEDURE check_in (
        p_atw_id     IN ptw_pro.ptw_lv_atw.atw_id%TYPE,
        p_latitude   IN NUMBER DEFAULT NULL,
        p_longitude  IN NUMBER DEFAULT NULL
    ) IS
        l_row       t_atw;
        l_is_holder BOOLEAN;
    BEGIN
        l_row := get_for_update(p_atw_id);
        l_is_holder := NVL(holder_username(l_row.holder_user_id), '~') = app_user;

        IF NOT l_is_holder AND is_issuer(app_user) = 'N' THEN
            RAISE_APPLICATION_ERROR(-20215, 'Only the pass holder or BGIS site staff can check in.');
        END IF;
        IF l_row.status = 'ON_SITE' THEN
            RAISE_APPLICATION_ERROR(-20216, 'Already checked in.');
        END IF;
        IF l_row.status NOT IN ('ISSUED', 'CHECKED_OUT') THEN
            RAISE_APPLICATION_ERROR(-20217,
                'This Authority to Work is ' || l_row.status || ' - check in is not possible.');
        END IF;
        IF l_row.valid_date <> local_today THEN
            RAISE_APPLICATION_ERROR(-20218,
                'This Authority to Work was valid for ' || fmt_date(l_row.valid_date)
                || ' only. A new one must be issued.');
        END IF;

        do_check_in(l_row, CASE WHEN l_is_holder THEN 'N' ELSE 'Y' END, p_latitude, p_longitude);
    END check_in;


    PROCEDURE check_out (
        p_atw_id     IN ptw_pro.ptw_lv_atw.atw_id%TYPE,
        p_latitude   IN NUMBER DEFAULT NULL,
        p_longitude  IN NUMBER DEFAULT NULL
    ) IS
        l_row       t_atw;
        l_is_holder BOOLEAN;
        l_now       DATE := local_now;
    BEGIN
        l_row := get_for_update(p_atw_id);
        l_is_holder := NVL(holder_username(l_row.holder_user_id), '~') = app_user;

        IF NOT l_is_holder AND is_issuer(app_user) = 'N' THEN
            RAISE_APPLICATION_ERROR(-20215, 'Only the pass holder or BGIS site staff can check out.');
        END IF;
        -- Deliberately no date check: someone who forgot to check out before
        -- midnight can still record when they actually left.
        IF l_row.status <> 'ON_SITE' THEN
            RAISE_APPLICATION_ERROR(-20219, 'Not currently checked in.');
        END IF;

        UPDATE ptw_pro.ptw_lv_atw
        SET    status             = 'CHECKED_OUT',
               check_out_datetime = l_now
        WHERE  atw_id = p_atw_id;

        log_event(p_atw_id, 'CHECK_OUT', CASE WHEN l_is_holder THEN 'N' ELSE 'Y' END,
                  p_latitude, p_longitude);
    END check_out;


    ---------------------------------------------------------------------------
    -- Public: phase 2 contractor request
    ---------------------------------------------------------------------------
    PROCEDURE save_request (
        p_atw_id            IN OUT ptw_pro.ptw_lv_atw.atw_id%TYPE,
        p_site_id           IN     ptw_pro.ptw_lv_atw.site_id%TYPE,
        p_work_description  IN     ptw_pro.ptw_lv_atw.work_description%TYPE,
        p_rams_reference    IN     ptw_pro.ptw_lv_atw.rams_reference%TYPE
    ) IS
        l_user  ptw_pro.ptw_lv_users%ROWTYPE;
        l_row   t_atw;
        l_me    VARCHAR2(255) := app_user;
        l_today DATE          := local_today;
        l_now   DATE          := local_now;
    BEGIN
        IF is_contractor(l_me) = 'N' THEN
            RAISE_APPLICATION_ERROR(-20223, 'Only contractors can request an Authority to Work.');
        END IF;
        assert_site(p_site_id);

        SELECT * INTO l_user
        FROM   ptw_pro.ptw_lv_users
        WHERE  UPPER(username) = l_me;

        IF p_atw_id IS NULL THEN
            INSERT INTO ptw_pro.ptw_lv_atw (
                site_id, holder_user_id, holder_name, holder_employer, holder_mobile,
                valid_date, work_description, rams_reference, status,
                requested_by, requested_datetime
            ) VALUES (
                p_site_id, l_user.user_id,
                TRIM(l_user.first_name || ' ' || l_user.last_name),
                NVL(TRIM(l_user.employer_name), '-'), l_user.mobile_no,
                l_today, TRIM(p_work_description), TRIM(p_rams_reference), 'REQUESTED',
                l_me, l_now
            )
            RETURNING atw_id INTO p_atw_id;

            log_event(p_atw_id, 'REQUESTED');
        ELSE
            l_row := get_for_update(p_atw_id);
            IF l_row.status <> 'REQUESTED' OR UPPER(l_row.requested_by) <> l_me THEN
                RAISE_APPLICATION_ERROR(-20224, 'This request can no longer be changed.');
            END IF;

            UPDATE ptw_pro.ptw_lv_atw
            SET    site_id          = p_site_id,
                   work_description = TRIM(p_work_description),
                   rams_reference   = TRIM(p_rams_reference)
            WHERE  atw_id = p_atw_id;

            log_event(p_atw_id, 'UPDATED');
        END IF;

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20208,
                'You already have an Authority to Work (or request) for today.');
    END save_request;


    ---------------------------------------------------------------------------
    -- Public: pass / verify
    ---------------------------------------------------------------------------
    FUNCTION get_today_atw_id (p_username IN VARCHAR2) RETURN NUMBER IS
        l_today  DATE := local_today;
        l_atw_id NUMBER;
    BEGIN
        SELECT a.atw_id
        INTO   l_atw_id
        FROM   ptw_pro.ptw_lv_atw   a
        JOIN   ptw_pro.ptw_lv_users u ON u.user_id = a.holder_user_id
        WHERE  UPPER(u.username) = UPPER(p_username)
        AND    a.valid_date      = l_today
        AND    a.status         <> 'CANCELLED'
        -- a live one wins over a revoked one issued earlier the same day
        ORDER  BY CASE WHEN a.status = 'REVOKED' THEN 1 ELSE 0 END, a.atw_id DESC
        FETCH FIRST 1 ROW ONLY;
        RETURN l_atw_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN NULL;
    END get_today_atw_id;


    FUNCTION verify_url (p_token IN VARCHAR2) RETURN VARCHAR2 IS
        l_url VARCHAR2(4000);
    BEGIN
        IF p_token IS NULL THEN
            RETURN NULL;
        END IF;
        -- Absolute friendly URL to the verify page, then strip the session
        -- and checksum so the QR code works in any session (or none - APEX
        -- sends the scanner to login and back via Deep Linking).
        -- REQUIRES on the verify page: Page Access Protection = Unrestricted,
        -- P37_TOKEN Session State Protection = Unrestricted. See spec doc.
        l_url := apex_page.get_url(
                     p_page         => 'ATW-VERIFY',
                     p_items        => 'P37_TOKEN',
                     p_values       => p_token,
                     p_plain_url    => TRUE,
                     p_absolute_url => TRUE);
        l_url := REGEXP_REPLACE(l_url, '([?&])(session|cs|clear)=[^&]*', '\1');
        l_url := REGEXP_REPLACE(l_url, '&{2,}', '&');
        l_url := REGEXP_REPLACE(l_url, '\?&', '?');
        l_url := REGEXP_REPLACE(l_url, '[?&]$', '');
        RETURN l_url;
    END verify_url;


    FUNCTION render_pass (p_atw_id IN ptw_pro.ptw_lv_atw.atw_id%TYPE) RETURN CLOB IS
        l_html       CLOB;
        l_row        t_atw;
        l_site       ptw_pro.ptw_lv_sites.site_name%TYPE;
        l_eff        VARCHAR2(20);
        l_label      VARCHAR2(60);
        l_sub        VARCHAR2(200);
        l_logo       VARCHAR2(500);
        l_logo_count NUMBER;
        l_qr         CLOB;
        l_now        DATE := local_now;
        l_permits    VARCHAR2(4000);

        FUNCTION esc (p IN VARCHAR2) RETURN VARCHAR2 IS
        BEGIN
            RETURN apex_escape.html(p);
        END esc;

        FUNCTION check_li (p_flag IN VARCHAR2, p_text IN VARCHAR2) RETURN VARCHAR2 IS
        BEGIN
            RETURN '<li class="ptw-atw-check' || CASE WHEN p_flag = 'Y' THEN ' is-ok' END || '">'
                || '<span class="fa ' || CASE WHEN p_flag = 'Y' THEN 'fa-check-circle' ELSE 'fa-circle-o' END
                || '" aria-hidden="true"></span><span>' || esc(p_text) || '</span></li>';
        END check_li;

        FUNCTION meta (p_label IN VARCHAR2, p_value IN VARCHAR2) RETURN VARCHAR2 IS
        BEGIN
            RETURN '<div class="ptw-atw-meta-item"><dt>' || esc(p_label) || '</dt><dd>'
                || NVL(esc(p_value), '&ndash;') || '</dd></div>';
        END meta;
    BEGIN
        BEGIN
            SELECT * INTO l_row FROM ptw_pro.ptw_lv_atw WHERE atw_id = p_atw_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN '<div class="ptw-atw-empty"><span class="fa fa-id-card-o" aria-hidden="true"></span>'
                    || '<p>Authority to Work not found.</p></div>';
        END;

        -- Holder, or staff who may verify. (VPD already limits contractors
        -- to their own rows; this is the explicit app-level check.)
        IF NVL(holder_username(l_row.holder_user_id), '~') <> app_user AND can_verify(app_user) = 'N' THEN
            RAISE_APPLICATION_ERROR(-20226, 'You cannot view this Authority to Work.');
        END IF;

        SELECT site_name INTO l_site FROM ptw_pro.ptw_lv_sites WHERE site_id = l_row.site_id;

        l_eff := effective_status(l_row.status, l_row.valid_date);
        l_permits := live_permit_numbers(l_row.atw_id);

        CASE l_eff
            WHEN 'ON_SITE'     THEN l_label := 'On site';
                                    l_sub   := 'Checked in ' || fmt_time(l_row.check_in_datetime);
            WHEN 'ISSUED'      THEN l_label := 'Valid, not checked in';
                                    l_sub   := 'Issued ' || fmt_time(l_row.issued_datetime);
            WHEN 'CHECKED_OUT' THEN l_label := 'Checked out';
                                    l_sub   := 'Left site ' || fmt_time(l_row.check_out_datetime);
            WHEN 'EXPIRED'     THEN l_label := 'Expired';
                                    l_sub   := 'Was valid ' || fmt_date(l_row.valid_date) || ' only';
            WHEN 'REVOKED'     THEN l_label := 'Revoked: stop work';
                                    l_sub   := 'Revoked ' || fmt_time(l_row.revoked_datetime);
            WHEN 'REQUESTED'   THEN l_label := 'Requested';
                                    l_sub   := 'Waiting for BGIS checks';
            WHEN 'DRAFT'       THEN l_label := 'Being prepared';
                                    l_sub   := 'Waiting for BGIS checks';
            ELSE                    l_label := INITCAP(REPLACE(l_eff, '_', ' '));
        END CASE;

        -- Company logo (same convention as the dashboard header: logo_<company_id>.png)
        SELECT COUNT(*) INTO l_logo_count
        FROM   apex_application_static_files
        WHERE  application_id = NVL(TO_NUMBER(V('APP_ID')), 105)
        AND    file_name      = 'logo_' || l_row.company_id || '.png';
        IF l_logo_count > 0 THEN
            l_logo := V('APP_FILES') || 'logo_' || l_row.company_id || '.png';
        END IF;

        IF l_row.verify_token IS NOT NULL THEN
            l_qr := apex_barcode.get_qrcode_svg(
                        p_value            => verify_url(l_row.verify_token),
                        p_size             => 200,
                        p_quiet            => 2,
                        p_foreground_color => '#13294b',
                        p_background_color => '#ffffff');
        END IF;

        l_html := '<article class="ptw-atw-pass ptw-atw--' || LOWER(l_eff) || '"'
            || ' data-status="'     || l_eff || '"'
            || ' data-valid-date="' || TO_CHAR(l_row.valid_date, 'YYYY-MM-DD') || '"'
            || ' data-rendered="'   || TO_CHAR(l_now, 'YYYY-MM-DD"T"HH24:MI:SS') || '"'
            || ' aria-label="Authority to Work ' || esc(l_row.atw_number) || '">'

            -- Header band
            || '<header class="ptw-atw-head">'
            ||   CASE WHEN l_logo IS NOT NULL
                      THEN '<img class="ptw-atw-logo" src="' || l_logo || '" alt="">' END
            ||   '<div class="ptw-atw-head-text">'
            ||     '<span class="ptw-atw-title">Authority to Work</span>'
            ||     '<span class="ptw-atw-number">' || NVL(esc(l_row.atw_number), 'Not yet issued') || '</span>'
            ||   '</div>'
            || '</header>'

            -- Live status band: animated + ticking clock = not a screenshot
            || '<div class="ptw-atw-status" role="status">'
            ||   '<span class="ptw-atw-dot" aria-hidden="true"></span>'
            ||   '<span class="ptw-atw-status-text"><strong>' || esc(l_label) || '</strong>'
            ||     CASE WHEN l_sub IS NOT NULL THEN '<small>' || esc(l_sub) || '</small>' END
            ||   '</span>'
            ||   '<time class="ptw-atw-clock" aria-hidden="true"></time>'
            || '</div>'

            -- Holder
            || '<section class="ptw-atw-body">'
            ||   '<div class="ptw-atw-who">'
            ||     '<div class="ptw-atw-holder">'
            ||       '<div class="ptw-atw-name">'     || esc(l_row.holder_name)     || '</div>'
            ||       '<div class="ptw-atw-employer">' || esc(l_row.holder_employer) || '</div>'
            ||     '</div>'
            -- "Valid for above date only": the date is the thing a checker looks for
            ||     '<div class="ptw-atw-date" title="Valid ' || fmt_date(l_row.valid_date) || ' only">'
            ||       '<span class="ptw-atw-date-dow">' || TO_CHAR(l_row.valid_date, 'Dy', 'NLS_DATE_LANGUAGE=ENGLISH') || '</span>'
            ||       '<span class="ptw-atw-date-day">' || TO_CHAR(l_row.valid_date, 'FMDD') || '</span>'
            ||       '<span class="ptw-atw-date-mon">' || TO_CHAR(l_row.valid_date, 'Mon YYYY', 'NLS_DATE_LANGUAGE=ENGLISH') || '</span>'
            ||     '</div>'
            ||   '</div>'
            ||   '<dl class="ptw-atw-meta">'
            ||     meta('Site', l_site)
            ||     meta('Issued by', l_row.issuer_name)
            ||     CASE WHEN l_permits IS NOT NULL THEN meta('Person in Charge on', l_permits) END
            ||     CASE WHEN l_row.rams_reference IS NOT NULL THEN meta('RAMS ref', l_row.rams_reference) END
            ||   '</dl>'
            ||   '<ul class="ptw-atw-checks">'
            ||     check_li(l_row.induction_ok,     'Site induction completed')
            ||     check_li(l_row.ssow_ok,          'Safe system of work approved')
            ||     check_li(l_row.competence_ok,    'Competence checked')
            ||     check_li(l_row.equipment_ppe_ok, 'Equipment and PPE checked')
            ||   '</ul>'
            || '</section>';

        IF l_qr IS NOT NULL THEN
            l_html := l_html
                || '<section class="ptw-atw-qr" aria-label="Verification QR code">'
                || l_qr
                || '<span class="ptw-atw-qr-hint">Site staff: scan to check live status</span>'
                || '</section>';
        END IF;

        l_html := l_html
            || '<footer class="ptw-atw-foot">'
            ||   '<span>Valid for the date shown only.</span>'
            ||   '<span>Check out when you leave site.</span>'
            ||   '<span class="ptw-atw-offline" hidden>Offline &ndash; showing status as at '
            ||     fmt_time(l_now) || '</span>'
            || '</footer>'
            || '</article>';

        RETURN l_html;
    END render_pass;


    FUNCTION verify_scan (p_token_or_url IN VARCHAR2) RETURN NUMBER IS
        l_token  VARCHAR2(32);
        l_atw_id NUMBER;
    BEGIN
        IF can_verify(app_user) = 'N' THEN
            RAISE_APPLICATION_ERROR(-20225, 'You do not have permission to verify Authority to Work passes.');
        END IF;

        -- Accept either the raw token or the full URL from the QR code.
        l_token := REGEXP_SUBSTR(LOWER(p_token_or_url), '[0-9a-f]{32}');
        IF l_token IS NULL THEN
            RETURN NULL;
        END IF;

        BEGIN
            SELECT atw_id INTO l_atw_id
            FROM   ptw_pro.ptw_lv_atw
            WHERE  verify_token = l_token;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN RETURN NULL;
        END;

        log_event(l_atw_id, 'VERIFIED');
        RETURN l_atw_id;
    END verify_scan;


    ---------------------------------------------------------------------------
    -- Public: PTW integration
    ---------------------------------------------------------------------------
    FUNCTION has_valid_atw (
        p_username IN VARCHAR2,
        p_site_id  IN ptw_pro.ptw_lv_atw.site_id%TYPE
    ) RETURN VARCHAR2 IS
        l_today DATE := local_today;
        l_count NUMBER;
    BEGIN
        IF is_contractor(p_username) = 'N' THEN
            RETURN 'X';
        END IF;
        SELECT COUNT(*)
        INTO   l_count
        FROM   ptw_pro.ptw_lv_atw   a
        JOIN   ptw_pro.ptw_lv_users u ON u.user_id = a.holder_user_id
        WHERE  UPPER(u.username) = UPPER(p_username)
        AND    a.site_id         = p_site_id
        AND    a.valid_date      = l_today
        AND    a.status          = 'ON_SITE';
        RETURN CASE WHEN l_count > 0 THEN 'Y' ELSE 'N' END;
    END has_valid_atw;


    FUNCTION validate_permit_people (
        p_site_id             IN ptw_pro.ptw_lv_permits.site_id%TYPE,
        p_pic_is_bgis         IN VARCHAR2,
        p_atw_id              IN ptw_pro.ptw_lv_atw.atw_id%TYPE,
        p_supervising_company IN ptw_pro.ptw_lv_permits.supervising_company%TYPE,
        p_other_persons_count IN ptw_pro.ptw_lv_permits.other_persons_count%TYPE
    ) RETURN VARCHAR2 IS
        l_today  DATE := local_today;
        l_atw    t_atw;
        l_others NUMBER;
    BEGIN
        IF c_ptw_enforce = 'N' OR UPPER(p_pic_is_bgis) = 'Y' THEN
            RETURN NULL;
        END IF;

        IF p_site_id IS NULL THEN
            RETURN 'Select an existing site. A contractor Person in Charge must be checked in '
                || 'at the site with an Authority to Work.';
        END IF;
        IF p_atw_id IS NULL THEN
            RETURN 'Select the Person in Charge from contractors checked in at this site today, '
                || 'or mark the Person in Charge as BGIS staff.';
        END IF;

        BEGIN
            SELECT * INTO l_atw FROM ptw_pro.ptw_lv_atw WHERE atw_id = p_atw_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN 'The selected Authority to Work could not be found.';
        END;

        IF effective_status(l_atw.status, l_atw.valid_date) <> 'ON_SITE' THEN
            RETURN l_atw.holder_name || ' is not checked in with a valid Authority to Work ('
                || LOWER(REPLACE(effective_status(l_atw.status, l_atw.valid_date), '_', ' ')) || ').';
        END IF;
        IF l_atw.site_id <> p_site_id THEN
            RETURN l_atw.holder_name || '''s Authority to Work is for a different site.';
        END IF;

        IF UPPER(TRIM(p_supervising_company)) <> UPPER(TRIM(l_atw.holder_employer)) THEN
            RETURN 'Company responsible must be ' || l_atw.holder_employer
                || ', the employer on ' || l_atw.holder_name || '''s Authority to Work.';
        END IF;

        -- Everyone working needs their own ATW: other persons from the same
        -- employer checked in at this site today, excluding the PIC.
        IF NVL(p_other_persons_count, 0) > 0 THEN
            SELECT COUNT(*)
            INTO   l_others
            FROM   ptw_pro.ptw_lv_atw a
            WHERE  a.site_id    = p_site_id
            AND    a.valid_date = l_today
            AND    a.status     = 'ON_SITE'
            AND    a.atw_id    <> l_atw.atw_id
            AND    UPPER(TRIM(a.holder_employer)) = UPPER(TRIM(l_atw.holder_employer));

            IF p_other_persons_count > l_others THEN
                RETURN 'The permit lists ' || p_other_persons_count || ' other person(s), but only '
                    || l_others || ' other ' || l_atw.holder_employer
                    || ' staff are checked in at this site with an Authority to Work. '
                    || 'Everyone working must have their own.';
            END IF;
        END IF;

        RETURN NULL;
    END validate_permit_people;


    FUNCTION permit_atw_problem (
        p_permit_id IN ptw_pro.ptw_lv_permits.permit_id%TYPE
    ) RETURN VARCHAR2 IS
        l_site_id  ptw_pro.ptw_lv_permits.site_id%TYPE;
        l_bgis     ptw_pro.ptw_lv_permits.pic_is_bgis%TYPE;
        l_atw_id   ptw_pro.ptw_lv_permits.atw_id%TYPE;
        l_company  ptw_pro.ptw_lv_permits.supervising_company%TYPE;
        l_others   ptw_pro.ptw_lv_permits.other_persons_count%TYPE;
    BEGIN
        SELECT site_id, pic_is_bgis, atw_id, supervising_company, other_persons_count
        INTO   l_site_id, l_bgis, l_atw_id, l_company, l_others
        FROM   ptw_pro.ptw_lv_permits
        WHERE  permit_id = p_permit_id;

        RETURN validate_permit_people(l_site_id, l_bgis, l_atw_id, l_company, l_others);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Permit not found.';
    END permit_atw_problem;


    PROCEDURE assert_permit_atw (
        p_permit_id IN ptw_pro.ptw_lv_permits.permit_id%TYPE
    ) IS
        l_problem VARCHAR2(4000) := permit_atw_problem(p_permit_id);
    BEGIN
        IF l_problem IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20230, l_problem);
        END IF;
    END assert_permit_atw;


    PROCEDURE set_permit_pic (
        p_permit_id   IN ptw_pro.ptw_lv_permits.permit_id%TYPE,
        p_pic_is_bgis IN VARCHAR2,
        p_atw_id      IN ptw_pro.ptw_lv_atw.atw_id%TYPE
    ) IS
        l_status  ptw_pro.ptw_lv_permits.workflow_status%TYPE;
        l_old_atw ptw_pro.ptw_lv_permits.atw_id%TYPE;
        l_number  ptw_pro.ptw_lv_permits.permit_number%TYPE;
        l_atw     t_atw;
    BEGIN
        SELECT workflow_status, atw_id, permit_number
        INTO   l_status, l_old_atw, l_number
        FROM   ptw_pro.ptw_lv_permits
        WHERE  permit_id = p_permit_id
        FOR UPDATE;

        IF l_status <> 'DRAFT' THEN
            RETURN;                 -- same rule as Page 2: read-only after draft
        END IF;

        IF UPPER(p_pic_is_bgis) = 'Y' OR p_atw_id IS NULL THEN
            UPDATE ptw_pro.ptw_lv_permits
            SET    pic_is_bgis = CASE WHEN UPPER(p_pic_is_bgis) = 'Y' THEN 'Y' ELSE 'N' END,
                   atw_id      = NULL
            WHERE  permit_id = p_permit_id;
            RETURN;
        END IF;

        SELECT * INTO l_atw FROM ptw_pro.ptw_lv_atw WHERE atw_id = p_atw_id;

        UPDATE ptw_pro.ptw_lv_permits
        SET    pic_is_bgis           = 'N',
               atw_id                = l_atw.atw_id,
               person_in_charge_name = l_atw.holder_name,
               supervising_company   = l_atw.holder_employer
        WHERE  permit_id = p_permit_id;

        IF NVL(l_old_atw, -1) <> l_atw.atw_id THEN
            log_event(l_atw.atw_id, 'PERMIT_LINKED', 'N', NULL, NULL,
                      'Person in Charge on permit ' || l_number);
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20204, 'Permit or Authority to Work not found or not accessible.');
    END set_permit_pic;


    FUNCTION live_permit_numbers (
        p_atw_id IN ptw_pro.ptw_lv_atw.atw_id%TYPE
    ) RETURN VARCHAR2 IS
        l_list VARCHAR2(4000);
    BEGIN
        SELECT LISTAGG(permit_number, ', ') WITHIN GROUP (ORDER BY permit_number)
        INTO   l_list
        FROM   ptw_pro.ptw_lv_permits
        WHERE  atw_id = p_atw_id
        AND    workflow_status IN ('AWAITING_AUTH', 'AUTHORISED', 'STARTED', 'SUSPENDED');
        RETURN l_list;
    END live_permit_numbers;


    ---------------------------------------------------------------------------
    -- Public: automation
    ---------------------------------------------------------------------------
    PROCEDURE expire_atws (p_expired OUT NUMBER, p_cancelled OUT NUMBER) IS
        TYPE t_ids IS TABLE OF ptw_pro.ptw_lv_atw.atw_id%TYPE;
        l_today   DATE          := local_today;
        l_now     DATE          := local_now;
        l_by      VARCHAR2(255) := app_user;
        l_expired t_ids;
        l_cancel  t_ids;
    BEGIN
        UPDATE ptw_pro.ptw_lv_atw
        SET    status           = 'EXPIRED',
               expired_datetime = l_now,
               not_checked_out  = CASE WHEN status = 'ON_SITE' THEN 'Y' ELSE 'N' END
        WHERE  status IN ('ISSUED', 'ON_SITE', 'CHECKED_OUT')
        AND    valid_date < l_today
        RETURNING atw_id BULK COLLECT INTO l_expired;

        FORALL i IN 1 .. l_expired.COUNT
            INSERT INTO ptw_pro.ptw_lv_atw_events
                (atw_id, event_type, event_datetime, event_by)
            VALUES
                (l_expired(i), 'EXPIRED', l_now, l_by);

        UPDATE ptw_pro.ptw_lv_atw
        SET    status = 'CANCELLED'
        WHERE  status IN ('DRAFT', 'REQUESTED')
        AND    valid_date < l_today
        RETURNING atw_id BULK COLLECT INTO l_cancel;

        FORALL i IN 1 .. l_cancel.COUNT
            INSERT INTO ptw_pro.ptw_lv_atw_events
                (atw_id, event_type, event_datetime, event_by, notes)
            VALUES
                (l_cancel(i), 'CANCELLED', l_now, l_by, 'Not issued on the day - auto cancelled');

        p_expired   := l_expired.COUNT;
        p_cancelled := l_cancel.COUNT;
    END expire_atws;


    ---------------------------------------------------------------------------
    -- VPD holder policy
    ---------------------------------------------------------------------------
    FUNCTION holder_policy (
        p_schema IN VARCHAR2,
        p_object IN VARCHAR2
    ) RETURN VARCHAR2 IS
        l_app_user  VARCHAR2(255) := V('APP_USER');
        l_user_id   ptw_pro.ptw_lv_users.user_id%TYPE;
        l_super     ptw_pro.ptw_lv_users.is_super_user%TYPE;
        l_contract  NUMBER;
        l_other     NUMBER;
    BEGIN
        -- No APEX session: PTW_COMPANY_POLICY already fails closed.
        IF l_app_user IS NULL THEN
            RETURN NULL;
        END IF;

        SELECT user_id, is_super_user
        INTO   l_user_id, l_super
        FROM   ptw_pro.ptw_lv_users
        WHERE  UPPER(username) = UPPER(l_app_user)
        AND    is_active = 'Y';

        IF l_super = 'Y' THEN
            RETURN NULL;
        END IF;

        SELECT COUNT(CASE WHEN r.role_name  = 'CONTRACTOR' THEN 1 END),
               COUNT(CASE WHEN r.role_name <> 'CONTRACTOR' THEN 1 END)
        INTO   l_contract, l_other
        FROM   ptw_pro.ptw_lv_user_role_assignments ur
        JOIN   ptw_pro.ptw_lv_roles r ON r.role_id = ur.role_id
        WHERE  ur.user_id   = l_user_id
        AND    ur.is_active = 'Y'
        AND    r.is_active  = 'Y';

        IF l_contract = 0 OR l_other > 0 THEN
            RETURN NULL;              -- staff: company policy only
        END IF;

        IF UPPER(p_object) = 'PTW_LV_ATW' THEN
            RETURN 'holder_user_id = ' || l_user_id;
        ELSE
            RETURN 'atw_id IN (SELECT a.atw_id FROM ptw_pro.ptw_lv_atw a WHERE a.holder_user_id = '
                   || l_user_id || ')';
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN '1=2';             -- unknown / inactive user: fail closed
    END holder_policy;

END ptw_atw_pkg;
/
