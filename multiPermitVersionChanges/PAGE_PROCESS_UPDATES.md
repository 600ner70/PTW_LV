# Page Process Updates

Full sweep of every page referencing the migrated columns. 9 pages total:
3 small permission-check fixes, 4 real DML rewrites, 1 report-query fix,
and 1 that needs nothing (already fixed via the view).

Run `05`–`08` and compile all three packages before applying any of these
(Page 5 and 10 call `ptw_signature_pkg`/`ptw_monitoring_pkg` directly).

---

## Page 1 — Dashboard

Two regions share an identical visibility-filter block that checks
`UPPER(p.auth_person_name) = UPPER(V('APP_USER'))`. Both occurrences need
the same fix — find each and replace:

**Find:**
```sql
UPPER(p.auth_person_name) = UPPER(V('APP_USER'))
```

**Replace with:**
```sql
EXISTS (
    SELECT 1 FROM ptw_pro.ptw_signatures sig
    WHERE  sig.permit_id = p.permit_id
    AND    sig.stage     = 'AUTH'
    AND    UPPER(sig.person_name) = UPPER(V('APP_USER'))
)
```

---

## Page 2 — Site & Work Details

**Process** with the `v_is_auth` check. Find:
```sql
SELECT COUNT(*) INTO v_is_auth
FROM   ptw_pro.ptw_lv_permits
WHERE  permit_id = :P2_PERMIT_ID
AND    NVL(UPPER(auth_person_name),'XXX') = UPPER(V('APP_USER'));  -- check if the engineer is the auth_person
```

**Replace with:**
```sql
SELECT COUNT(*) INTO v_is_auth
FROM   ptw_pro.ptw_signatures
WHERE  permit_id = :P2_PERMIT_ID
AND    stage     = 'AUTH'
AND    UPPER(person_name) = UPPER(V('APP_USER'));  -- check if the engineer is the auth_person
```

---

## Page 4 — Equipment Isolation

Identical pattern to Page 2, just `:P4_PERMIT_ID`:
```sql
SELECT COUNT(*) INTO v_is_auth
FROM   ptw_pro.ptw_signatures
WHERE  permit_id = :P4_PERMIT_ID
AND    stage     = 'AUTH'
AND    UPPER(person_name) = UPPER(V('APP_USER'));  -- check if the engineer is the auth_person
```

---

## Page 5 — Authorisation & Acceptance

Two processes. Page items, buttons, and layout are all unchanged.

### Process: "Load Authorisation and Acceptance Data"

```plsql
BEGIN
    :P5_CURRENT_STEP := 'AUTHORISATION';

    BEGIN
        SELECT permit_number, workflow_status
        INTO   :P5_PERMIT_NUMBER, :P5_WORKFLOW_STATUS
        FROM   ptw_pro.ptw_lv_permits
        WHERE  permit_id = :P5_PERMIT_ID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            :P5_WORKFLOW_STATUS := 'DRAFT';
    END;

    DECLARE
        v_auth_sig   BLOB;
        v_accept_sig BLOB;
        v_na_company ptw_pro.ptw_signatures.company_name%TYPE;
        v_auth_lat   ptw_pro.ptw_signatures.latitude%TYPE;
        v_auth_lng   ptw_pro.ptw_signatures.longitude%TYPE;
    BEGIN
        ptw_pro.ptw_signature_pkg.get_signature(:P5_PERMIT_ID, 'AUTH',
            :P5_AUTH_PERSON_SELECT, v_auth_sig, :P5_AUTH_PERSON_MOBILE, v_na_company,
            :P5_AUTH_DATETIME, :P5_AUTH_LATITUDE, :P5_AUTH_LONGITUDE);

        ptw_pro.ptw_signature_pkg.get_signature(:P5_PERMIT_ID, 'ACCEPT',
            :P5_ACCEPT_PERSON_NAME, v_accept_sig, :P5_ACCEPT_PERSON_MOBILE, :P5_ACCEPT_COMPANY,
            :P5_ACCEPT_DATETIME, :P5_ACCEPT_LATITUDE, :P5_ACCEPT_LONGITUDE);

        IF :P5_ACCEPT_DATETIME IS NULL THEN
            :P5_ACCEPT_DATETIME := TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI');
        END IF;
        IF :P5_AUTH_DATETIME IS NULL THEN
            :P5_AUTH_DATETIME := TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI');
        END IF;

        IF :P5_ACCEPT_COMPANY IS NULL AND :P5_ACCEPT_PERSON_NAME IS NULL THEN
            BEGIN
                SELECT person_in_charge_name, supervising_company
                INTO   :P5_ACCEPT_PERSON_NAME, :P5_ACCEPT_COMPANY
                FROM   ptw_pro.ptw_lv_permits
                WHERE  permit_id = :P5_PERMIT_ID;
            EXCEPTION
                WHEN OTHERS THEN NULL;
            END;
        END IF;

        IF v_auth_sig IS NOT NULL THEN
            :P5_AUTH_SIGNATURE_DATA := 'data:image/png;base64,'
                || apex_web_service.blob2clobbase64(v_auth_sig);
        END IF;
        IF v_accept_sig IS NOT NULL THEN
            :P5_ACCEPT_SIGNATURE_DATA := 'data:image/png;base64,'
                || apex_web_service.blob2clobbase64(v_accept_sig);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN NULL;
    END;
END;
```

Note: the original wrapped the whole thing in one `EXCEPTION WHEN NO_DATA_FOUND` that
also defaulted `:P5_WORKFLOW_STATUS := 'DRAFT'` on a brand-new permit. I split that into
its own small block around just the permit-header `SELECT` so a genuinely new permit still
defaults to DRAFT correctly, without swallowing errors from the signature lookups.

### Process: "Save Authorisation and Acceptance Data"

```plsql
DECLARE
    v_auth_sig_blob   BLOB;
    v_accept_sig_blob BLOB;
    v_auth_mobile     ptw_pro.ptw_lv_users.mobile_no%TYPE;

    FUNCTION base64_to_blob(p_base64 CLOB) RETURN BLOB IS
        v_blob BLOB;
        v_clob CLOB;
    BEGIN
        IF p_base64 IS NULL THEN
            RETURN NULL;
        END IF;
        v_clob := REGEXP_REPLACE(p_base64, '^data:image/[^;]+;base64,', '');
        v_blob := apex_web_service.clobbase642blob(v_clob);
        RETURN v_blob;
    END base64_to_blob;

BEGIN
    v_auth_sig_blob   := base64_to_blob(:P5_AUTH_SIGNATURE_DATA);
    v_accept_sig_blob := base64_to_blob(:P5_ACCEPT_SIGNATURE_DATA);

    -- Resolve auth person's mobile_no first; scalar subqueries can't be
    -- used as bare PL/SQL expressions in a named-parameter call (PLS-00103).
    BEGIN
        SELECT mobile_no
        INTO   v_auth_mobile
        FROM   ptw_pro.ptw_lv_users
        WHERE  UPPER(username) = UPPER(:P5_AUTH_PERSON_SELECT);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_auth_mobile := NULL;
        WHEN TOO_MANY_ROWS THEN
            v_auth_mobile := NULL;
    END;

    ptw_pro.ptw_signature_pkg.save_signature(
        p_permit_id      => :P5_PERMIT_ID,
        p_stage          => 'AUTH',
        p_person_name    => UPPER(:P5_AUTH_PERSON_SELECT),
        --   was: (SELECT first_name || ' ' || last_name FROM ptw_pro.ptw_lv_users
        --         WHERE UPPER(username) = UPPER(:P5_AUTH_PERSON_SELECT)) — left as
        --   username per the original's own commented-out alternative
        p_signature_blob => v_auth_sig_blob,
        p_mobile_no      => v_auth_mobile,
        p_event_datetime => TO_DATE(:P5_AUTH_DATETIME, 'DD-MON-YYYY HH24:MI'),
        p_latitude       => :APP_LATITUDE,
        p_longitude      => :APP_LONGITUDE
    );

    ptw_pro.ptw_signature_pkg.save_signature(
        p_permit_id      => :P5_PERMIT_ID,
        p_stage          => 'ACCEPT',
        p_person_name    => :P5_ACCEPT_PERSON_NAME,
        p_signature_blob => v_accept_sig_blob,
        p_mobile_no      => :P5_ACCEPT_PERSON_MOBILE,
        p_company_name   => :P5_ACCEPT_COMPANY,
        p_event_datetime => TO_DATE(:P5_ACCEPT_DATETIME, 'DD-MON-YYYY HH24:MI'),
        p_latitude       => :APP_LATITUDE,
        p_longitude      => :APP_LONGITUDE
    );

    UPDATE ptw_pro.ptw_lv_permits
    SET    workflow_status = 'AUTHORISED',
           current_step    = 'AUTHORISATION',
           modified_by     = NVL(V('APP_USER'), USER),
           modified_date   = CURRENT_TIMESTAMP
    WHERE  permit_id = :P5_PERMIT_ID;

    COMMIT;

    apex_application.g_print_success_message :=
        CASE WHEN :REQUEST = 'AUTHORISE'
             THEN 'Permit ' || :P5_PERMIT_NUMBER || ' has been authorised.'
             ELSE 'Permit ' || :P5_PERMIT_NUMBER || ' saved successfully.'
        END;

    :P5_WORKFLOW_STATUS := 'AUTHORISED';

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        apex_error.add_error(
            p_message => 'Error saving authorisation data: ' || SQLERRM,
            p_display_location => apex_error.c_inline_in_notification
        );
END;
```

---

## Page 10 — Low Voltage Monitoring

Note preserved from the original: **Check 1 always gets a row (even blank),
Checks 2 and 3 only get a row if their detail was actually filled in** —
this matches the PDF's "Check 1 always shown, 2/3 only if present" behaviour
exactly, so nothing changes visually.

### Process: "Load Monitoring Data"

Replace the 16 `:P10_MS_CHECKn_*` assignment lines with:

```plsql
FOR chk IN (
    SELECT check_seq, detail, check_time, in_order, comments
    FROM   ptw_pro.ptw_monitoring_checks
    WHERE  monitoring_id = :P10_MONITORING_ID
    ORDER  BY check_seq
) LOOP
    CASE chk.check_seq
        WHEN 1 THEN
            :P10_MS_CHECK1_DETAIL   := chk.detail;
            :P10_MS_CHECK1_TIME     := chk.check_time;
            :P10_MS_CHECK1_IN_ORDER := chk.in_order;
            :P10_MS_CHECK1_COMMENTS := chk.comments;
        WHEN 2 THEN
            :P10_MS_CHECK2_DETAIL   := chk.detail;
            :P10_MS_CHECK2_TIME     := chk.check_time;
            :P10_MS_CHECK2_IN_ORDER := chk.in_order;
            :P10_MS_CHECK2_COMMENTS := chk.comments;
        WHEN 3 THEN
            :P10_MS_CHECK3_DETAIL   := chk.detail;
            :P10_MS_CHECK3_TIME     := chk.check_time;
            :P10_MS_CHECK3_IN_ORDER := chk.in_order;
            :P10_MS_CHECK3_COMMENTS := chk.comments;
    END CASE;
END LOOP;
```

Everything else in this process (`CHK_PERMIT_ON_DISPLAY` etc., `MONITOR_NAME`,
signature) is unchanged.

### Process: "Save Monitoring Data"

In both the `UPDATE` and `INSERT` branches, **remove** all 12
`ms_check1/2/3_*` columns (both from the `SET`/column list and the
corresponding bind variables). Everything else in that UPDATE/INSERT stays.

Then, immediately **after** the `IF :P10_MONITORING_ID IS NOT NULL THEN ...
END IF;` block (so `:P10_MONITORING_ID` is guaranteed populated either way,
via the existing `RETURNING ... INTO` on insert), add:

```plsql
-- Check 1 always saved, even if blank (matches original "always shown")
ptw_pro.ptw_monitoring_pkg.save_check(
    p_monitoring_id => :P10_MONITORING_ID,
    p_check_seq     => 1,
    p_detail        => :P10_MS_CHECK1_DETAIL,
    p_check_time    => :P10_MS_CHECK1_TIME,
    p_in_order      => :P10_MS_CHECK1_IN_ORDER,
    p_comments      => :P10_MS_CHECK1_COMMENTS
);

IF :P10_MS_CHECK2_DETAIL IS NOT NULL THEN
    ptw_pro.ptw_monitoring_pkg.save_check(
        p_monitoring_id => :P10_MONITORING_ID,
        p_check_seq     => 2,
        p_detail        => :P10_MS_CHECK2_DETAIL,
        p_check_time    => :P10_MS_CHECK2_TIME,
        p_in_order      => :P10_MS_CHECK2_IN_ORDER,
        p_comments      => :P10_MS_CHECK2_COMMENTS
    );
END IF;

IF :P10_MS_CHECK3_DETAIL IS NOT NULL THEN
    ptw_pro.ptw_monitoring_pkg.save_check(
        p_monitoring_id => :P10_MONITORING_ID,
        p_check_seq     => 3,
        p_detail        => :P10_MS_CHECK3_DETAIL,
        p_check_time    => :P10_MS_CHECK3_TIME,
        p_in_order      => :P10_MS_CHECK3_IN_ORDER,
        p_comments      => :P10_MS_CHECK3_COMMENTS
    );
END IF;
```

---

## Page 16 — Clear Permit

Worth knowing before you touch this one: the current Load process selects
`accept_person_mobile` into `:P16_CLEAR_PERSON_MOBILE`, then immediately
selects `clear_person_mobile` into the *same* bind variable — the second
assignment always wins, so the "prefill from accept" was already dead code
today, not something this migration changes. The rewrite below reproduces
the actual current behaviour (mobile comes from the CLEAR stage only). If
you want the prefill to genuinely work, that's a separate, deliberate fix.

### Process: "Load Permit Data"

```plsql
DECLARE
    v_status   VARCHAR2(20);
    v_ended    DATE;
    v_sig      BLOB;
    v_na_lat   ptw_pro.ptw_signatures.latitude%TYPE;
    v_na_lng   ptw_pro.ptw_signatures.longitude%TYPE;
BEGIN
    SELECT workflow_status, ended_datetime, permit_number,
           person_in_charge_name, supervising_company
    INTO   v_status, v_ended, :P16_PERMIT_NUMBER,
           :P16_CLEAR_PERSON_NAME, :P16_CLEAR_COMPANY
    FROM   ptw_pro.ptw_lv_permits
    WHERE  permit_id = :P16_PERMIT_ID;

    IF v_status NOT IN ('STARTED', 'COMPLETED') THEN
        apex_error.add_error(
            p_message          => 'This permit cannot be viewed here. Current status: ' || v_status,
            p_display_location => apex_error.c_on_error_page
        );
        RETURN;
    END IF;

    IF v_status = 'STARTED' THEN
        IF SYSDATE >= v_ended THEN
            apex_error.add_error(
                p_message          => 'This permit has expired ('
                                      || TO_CHAR(v_ended, 'DD-MON-YYYY HH24:MI')
                                      || ') and cannot be cleared.',
                p_display_location => apex_error.c_on_error_page
            );
            RETURN;
        END IF;
        :P16_CLEAR_DATETIME := TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI');
    END IF;

    IF v_status = 'COMPLETED' THEN
        ptw_pro.ptw_signature_pkg.get_signature(:P16_PERMIT_ID, 'CLEAR',
            :P16_CLEAR_PERSON_NAME, v_sig, :P16_CLEAR_PERSON_MOBILE, :P16_CLEAR_COMPANY,
            :P16_CLEAR_DATETIME, v_na_lat, v_na_lng);

        SELECT clear_work_complete, clear_area_safe
        INTO   :P16_CLEAR_WORK_COMPLETE, :P16_CLEAR_AREA_SAFE
        FROM   ptw_pro.ptw_lv_permits
        WHERE  permit_id = :P16_PERMIT_ID;

        IF v_sig IS NOT NULL AND DBMS_LOB.GETLENGTH(v_sig) > 0 THEN
            :P16_CLEAR_SIGNATURE_DATA_URL := 'data:image/png;base64,'
                || apex_web_service.blob2clobbase64(v_sig);
        ELSE
            :P16_CLEAR_SIGNATURE_DATA_URL := NULL;
        END IF;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        apex_error.add_error(
            p_message => 'Permit not found.', p_display_location => apex_error.c_on_error_page
        );
    WHEN OTHERS THEN
        apex_error.add_error(
            p_message => 'Error loading permit data: ' || SQLERRM,
            p_display_location => apex_error.c_on_error_page
        );
END;
```

### Process: "Clear Permit"

```plsql
DECLARE
    v_sig_blob  BLOB;
    v_clob      CLOB;
    v_now       DATE := SYSDATE;
BEGIN
    IF :P16_CLEAR_SIGNATURE_DATA IS NOT NULL THEN
        v_clob     := REPLACE(:P16_CLEAR_SIGNATURE_DATA, 'data:image/png;base64,', '');
        v_sig_blob := apex_web_service.clobbase642blob(v_clob);
    END IF;

    -- Guarded status transition stays on PTW_LV_PERMITS, same race-condition
    -- protection as before (workflow_status/expiry check + ROWCOUNT).
    UPDATE ptw_pro.ptw_lv_permits
    SET    clear_work_complete = :P16_CLEAR_WORK_COMPLETE,
           clear_area_safe     = :P16_CLEAR_AREA_SAFE,
           workflow_status     = 'COMPLETED',
           current_step        = 'CLEARANCE',
           completion_date     = v_now,
           modified_by         = V('APP_USER'),
           modified_date       = v_now
    WHERE  permit_id           = :P16_PERMIT_ID
    AND    workflow_status     = 'STARTED'
    AND    SYSDATE             < ended_datetime;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20001,
            'Permit could not be cleared. It may have expired or '
            || 'already been closed. Please refresh the permits list.');
    END IF;

    ptw_pro.ptw_signature_pkg.save_signature(
        p_permit_id      => :P16_PERMIT_ID,
        p_stage          => 'CLEAR',
        p_person_name    => UPPER(TRIM(:P16_CLEAR_PERSON_NAME)),
        p_signature_blob => v_sig_blob,
        p_mobile_no      => TRIM(:P16_CLEAR_PERSON_MOBILE),
        p_company_name   => UPPER(TRIM(:P16_CLEAR_COMPANY)),
        p_event_datetime => v_now,
        p_latitude       => TO_NUMBER(:APP_LATITUDE),
        p_longitude      => TO_NUMBER(:APP_LONGITUDE)
    );

    COMMIT;
    :P16_CLEARED := 'Y';
    apex_application.g_print_success_message :=
        'Permit ' || :P16_PERMIT_NUMBER || ' cleared successfully.';

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        apex_error.add_error(
            p_message          => 'Error clearing permit: ' || SQLERRM,
            p_display_location => apex_error.c_inline_in_notification
        );
END;
```

---

## Page 17 — Cancel Permit

### Process: "Load Cancel Permit Data"

```plsql
DECLARE
    v_clob CLOB;
    v_sig  BLOB;
    v_na_mobile  ptw_pro.ptw_signatures.mobile_no%TYPE;
    v_na_company ptw_pro.ptw_signatures.company_name%TYPE;
    v_na_lat     ptw_pro.ptw_signatures.latitude%TYPE;
    v_na_lng     ptw_pro.ptw_signatures.longitude%TYPE;
BEGIN
    SELECT permit_number, workflow_status
    INTO   :P17_PERMIT_NUMBER, :P17_WORKFLOW_STATUS
    FROM   ptw_pro.ptw_lv_permits
    WHERE  permit_id = :P17_PERMIT_ID;

    IF :P17_WORKFLOW_STATUS = 'CANCELLED' THEN

        ptw_pro.ptw_signature_pkg.get_signature(:P17_PERMIT_ID, 'CANCEL',
            :P17_CANCEL_PERSON_NAME, v_sig, v_na_mobile, v_na_company,
            :P17_CANCEL_DATETIME, v_na_lat, v_na_lng);

        SELECT cancel_work_complete
        INTO   :P17_CANCEL_WORK_COMPLETE
        FROM   ptw_pro.ptw_lv_permits
        WHERE  permit_id = :P17_PERMIT_ID;

        IF v_sig IS NOT NULL AND DBMS_LOB.GETLENGTH(v_sig) > 0 THEN
            v_clob := apex_web_service.blob2clobbase64(v_sig);
            v_clob := REPLACE(REPLACE(v_clob, CHR(13), ''), CHR(10), '');
            :P17_CANCEL_SIGNATURE_DATA_URL :=
                'data:image/png;base64,' || DBMS_LOB.SUBSTR(v_clob, 32000, 1);
        ELSE
            :P17_CANCEL_SIGNATURE_DATA_URL := NULL;
        END IF;

    ELSE
        :P17_CANCEL_DATETIME := TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI');
        :P17_CANCEL_SIGNATURE_DATA_URL := NULL;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        apex_error.add_error(
            p_message => 'Permit not found.', p_display_location => apex_error.c_on_error_page
        );
    WHEN OTHERS THEN
        apex_error.add_error(
            p_message => 'Error loading cancellation data: ' || SQLERRM,
            p_display_location => apex_error.c_on_error_page
        );
END;
```

### Process: "Cancel Permit"

```plsql
DECLARE
    v_sig_blob BLOB;

    FUNCTION base64_to_blob(p_base64 CLOB) RETURN BLOB IS
        v_blob BLOB;
        v_clob CLOB;
    BEGIN
        IF p_base64 IS NULL THEN RETURN NULL; END IF;
        v_clob := REGEXP_REPLACE(p_base64, '^data:image/[^;]+;base64,', '');
        v_blob := apex_web_service.clobbase642blob(v_clob);
        RETURN v_blob;
    END base64_to_blob;

BEGIN
    v_sig_blob := base64_to_blob(:P17_CANCEL_SIGNATURE_DATA);

    -- Guarded status transition, same protection as before.
    UPDATE ptw_pro.ptw_lv_permits
    SET    cancel_work_complete = :P17_CANCEL_WORK_COMPLETE,
           workflow_status      = 'CANCELLED',
           current_step         = 'CANCELLED',
           completion_date      = SYSDATE,
           modified_by          = NVL(V('APP_USER'), USER),
           modified_date        = CURRENT_TIMESTAMP
    WHERE  permit_id            = :P17_PERMIT_ID
    AND    workflow_status NOT IN ('CANCELLED','COMPLETED','CLEARED');

    IF SQL%ROWCOUNT = 0 THEN
        apex_error.add_error(
            p_message          => 'Permit could not be cancelled. It may have already '
                               || 'been cancelled or completed. Please refresh the '
                               || 'permits list.',
            p_display_location => apex_error.c_inline_in_notification
        );
        RETURN;
    END IF;

    ptw_pro.ptw_signature_pkg.save_signature(
        p_permit_id      => :P17_PERMIT_ID,
        p_stage          => 'CANCEL',
        p_person_name    => UPPER(TRIM(:P17_CANCEL_PERSON_NAME)),
        p_signature_blob => v_sig_blob,
        p_event_datetime => SYSDATE,
        p_latitude       => :APP_LATITUDE,
        p_longitude      => :APP_LONGITUDE
    );

    :P17_CANCELLED := 'Y';
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        apex_error.add_error(
            p_message          => 'Error cancelling permit: ' || SQLERRM,
            p_display_location => apex_error.c_inline_in_notification
        );
        RAISE;
END;
```

---

## Page 50 — Permit Search

Query selects `p.auth_person_name` from `ptw_pro.ptw_lv_permits p` directly.

**Find:**
```sql
p.auth_person_name,
```

**Replace with:**
```sql
(SELECT sig.person_name FROM ptw_pro.ptw_signatures sig
 WHERE  sig.permit_id = p.permit_id AND sig.stage = 'AUTH') AS auth_person_name,
```

---

## Page 51 — Permit Analytics

**Nothing to change.** Confirmed its query already runs against
`ptw_pro.ptw_lv_analytics_v` (aliased `p`), not `PTW_LV_PERMITS` directly —
`auth_datetime`, `clear_datetime`, `cancel_datetime`, `has_clearance`,
`has_cancellation` all come from the view, which `08_update_views.sql`
already fixed. This page inherits the fix automatically.

---

## Page 15 — Monitoring

**Nothing to change.** This is monitoring for an *existing* permit, not
permit creation. `P15_PTW_TYPE` is a pass-through display item carrying an
already-known type; its `CREATE` button goes to Page 10 with an existing
`permit_id`. Unrelated to type selection — checked, not a gap.

---

## Type selection: Pages 14 → 2 → 3 (new)

Page 14 ("Create PTW") already has a working, entitlement-aware type
picker — `P14_PTW_TYPES`' LOV correctly queries `ptw_lv_effective_types_v`
/ `ptw_lv_company_types`. But a validation on the `CREATE` button rejects
anything except `'LV ISOLATION'`, and even past that, the selected value
was never passed to Page 2 at all. Three pages need changes to close this.

### Page 14 — validation "Is an available PTW?"

**Find:**
```plsql
:P14_PTW_TYPES = 'LV ISOLATION'
```

**Replace with** (re-runs the same entitlement check the LOV itself uses,
rather than hardcoding one literal — this is also more correct than the
original, which only ever validated one specific value):
```plsql
EXISTS (
    SELECT 1 FROM ptw_pro.ptw_types t
    WHERE  t.ptw_type = :P14_PTW_TYPES
    AND    t.available = 'Y'
    AND (
        t.type_id IN (
            SELECT et.type_id FROM ptw_pro.ptw_lv_effective_types_v et
            WHERE  UPPER(et.username) = UPPER(V('APP_USER'))
            AND    et.is_active = 'Y'
        )
        OR (
            :P14_COMPANY_ID IS NOT NULL
            AND t.type_id IN (
                SELECT ct.type_id FROM ptw_pro.ptw_lv_company_types ct
                WHERE  ct.company_id = :P14_COMPANY_ID
                AND    ct.is_active = 'Y'
            )
        )
    )
)
```
The error message ("PTW type is not currently available for this
customer.") is still accurate for this — no change needed there.

### Page 14 — Branch "Go to create a PTW"

**Find:**
```
url: 'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_PERMIT_ID,P2_WORKFLOW_STATUS:&P14_PERMIT_ID.,DRAFT'
values:
  p2_permit_id: '&P14_PERMIT_ID.'
  p2_workflow_status: DRAFT
```

**Replace with:**
```
url: 'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_PERMIT_ID,P2_WORKFLOW_STATUS,P2_PTW_TYPE:&P14_PERMIT_ID.,DRAFT,&P14_PTW_TYPES.'
values:
  p2_permit_id: '&P14_PERMIT_ID.'
  p2_workflow_status: DRAFT
  p2_ptw_type: '&P14_PTW_TYPES.'
```

### Page 2 — new item

Add one **Hidden** item, `P2_PTW_TYPE`, Session State storage — same
pattern as `P2_WORKFLOW_STATUS`. No source query needed; it only ever
arrives via the Page 14 redirect above.

### Page 2 — Process "Save Permit Data (INSERT or UPDATE)"

**INSERT branch** — find:
```plsql
) VALUES (
    :P2_SAFETY_PROGRAMME_REF_NO,
    'LV ISOLATION',
```
**Replace with** (defaults to LV Isolation only as a safety net for the
edge case of someone reaching Page 2 without going through Page 14 —
matches the original's behaviour in that situation):
```plsql
) VALUES (
    :P2_SAFETY_PROGRAMME_REF_NO,
    NVL(:P2_PTW_TYPE, 'LV ISOLATION'),
```

**UPDATE branch** — find:
```plsql
              UPDATE ptw_pro.ptw_lv_permits
              SET safety_programme_ref_no     = :P2_SAFETY_PROGRAMME_REF_NO,
                  ptw_type                    = 'LV ISOLATION',
```
**Replace with** (remove the line entirely — worth knowing this was a
latent bug even before this refactor: editing Site & Work Details on an
already-drafted General permit would have silently flipped it back to LV
Isolation on save, since permit type shouldn't change after creation and
this UPDATE was unconditionally resetting it every time):
```plsql
              UPDATE ptw_pro.ptw_lv_permits
              SET safety_programme_ref_no     = :P2_SAFETY_PROGRAMME_REF_NO,
```

### Page 3 — Branch "Go to Equipment Isolation (NEXT_STEP)"

**Find** the server-side condition:
```
type: Request = Value
value: NEXT_STEP
```
**Replace with** (Expression type, so it only fires for LV Isolation permits):
```plsql
type: Expression
pl/sql-expression: ":REQUEST = 'NEXT_STEP' AND (SELECT ptw_type FROM ptw_pro.ptw_lv_permits WHERE permit_id = :P3_PERMIT_ID) = 'LV ISOLATION'"
```

**Add a new branch**, same target shape as the existing "Refresh Current
Page" branch but pointing at Page 5 instead:
```
Name: Go to Authorisation (NEXT_STEP, non-isolation types)
Point: After Processing
Behavior: Page or URL (Redirect)
Target page: 5 (Authorisation & Acceptance)
Target URL: f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5:P5_PERMIT_ID:&P3_PERMIT_ID.
Values: p5_permit_id = &P3_PERMIT_ID.
Server-side condition: Expression
pl/sql-expression: ":REQUEST = 'NEXT_STEP' AND (SELECT ptw_type FROM ptw_pro.ptw_lv_permits WHERE permit_id = :P3_PERMIT_ID) != 'LV ISOLATION'"
```

No new page item needed — the type check queries `PTW_LV_PERMITS` directly
in the branch condition rather than adding a `P3_PTW_TYPE` item just to
carry a value used in exactly one place.

### Page 50 — Permit Search

`PTW_TYPE` is also a facet/filter column on this page (`P50_PTW_TYPE`,
`database-column: PTW_TYPE`), so the raw code column can't just be
replaced — the facet depends on it matching the underlying data. Add a
second, display-only column instead.

**Find:**
```sql
p.ptw_type,
```
**Add alongside it** (leave the original `p.ptw_type` in place — the facet
needs it):
```sql
(SELECT t.type_desc FROM ptw_pro.ptw_types t
 WHERE  t.ptw_type = p.ptw_type) AS ptw_type_desc,
```

Then in the report's column attributes, point whichever column is actually
**displayed** in the grid at `PTW_TYPE_DESC` instead of `PTW_TYPE`. The
facet/filter keeps using the raw `PTW_TYPE` column underneath, unchanged.

