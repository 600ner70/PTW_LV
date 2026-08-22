# General Permit + Multi-Type UI Changes — Full Implementation List

Everything from this session, in run order. Assumes the earlier
`multiPermitVersionChanges` batch (tables, checklist/signature/monitoring
packages, Page 14/2/3/50 type-selection wiring) is already applied — this
document picks up from there.

---

## Run order

1. `13_add_close_stage_and_auth_to_datetime.sql`
2. `ptw_signature_pkg.pks.sql` (updated)
3. `ptw_signature_pkg.pkb.sql` (updated)
4. Corrected GENERAL section of `06_seed_checklist_items.sql` (re-run)
5. `ptw_ui_pkg` (new — spec then body)
6. Page 23 (Permit Types admin) fixes
7. Page Designer changes — Pages 2, 3, 4, 5

---

## 1. Database — signature stage + validity window

**File: `13_add_close_stage_and_auth_to_datetime.sql`**

```sql
ALTER TABLE ptw_pro.ptw_signatures DROP CONSTRAINT chk_ptw_sig_stage;

ALTER TABLE ptw_pro.ptw_signatures
  ADD CONSTRAINT chk_ptw_sig_stage
  CHECK (stage IN ('AUTH','ACCEPT','CLEAR','CANCEL','CLOSE')) ENABLE;

ALTER TABLE ptw_pro.ptw_signatures
  ADD auth_to_datetime DATE;

COMMENT ON COLUMN ptw_pro.ptw_signatures.auth_to_datetime IS
  'Validity window end (AUTH stage only). NULL for all other stages.';
```

**File: `ptw_signature_pkg.pks.sql`** — replace in full:

```sql
CREATE OR REPLACE PACKAGE ptw_pro.ptw_signature_pkg AS
    --------------------------------------------------------------------------
    -- p_stage must be one of 'AUTH','ACCEPT','CLEAR','CANCEL','CLOSE'.
    -- p_auth_to_datetime is only ever populated for stage = 'AUTH'; pass
    -- NULL (the default) for every other stage.
    --------------------------------------------------------------------------
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
    );

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
    );

END ptw_signature_pkg;
/
```

**File: `ptw_signature_pkg.pkb.sql`** — replace in full:

```sql
CREATE OR REPLACE PACKAGE BODY ptw_pro.ptw_signature_pkg AS

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
```

**Not yet done — separate follow-up:** no page in the app calls `save_signature`
with `p_stage => 'CLOSE'` or passes `p_auth_to_datetime` yet. Page 5's
Authorisation process needs a `P5_AUTH_TO_DATETIME` item and a Permit Closure
page/section needs building before this is usable end to end. Flagging so it
isn't mistaken for "done" once this batch is applied.

---

## 2. Corrected GENERAL checklist items

Re-run this against `06_seed_checklist_items.sql`'s GENERAL section — replaces
the placeholder list built from an incomplete PDF read with the real 14-item
form. `upsert_item` is idempotent (MERGE), safe to re-run.

```sql
    ------------------------------------------------------------------------
    -- GENERAL — Control Measures (corrected against the full "Permit to
    -- Work — General Work" form). Shared item_codes reused only where the
    -- question is genuinely the same as LV's; items 4, 6, 8-13 are new.
    ------------------------------------------------------------------------
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'CM_01_SITE_INDUCTION',        10, 'All persons working under this permit have undertaken a site specific safety induction.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'CM_02_RISK_ASSESSMENT',       20, 'A suitable and sufficient written risk assessment and method statement for these works, which has been read and understood by all persons working under this permit, is in place and has been reviewed at the point of works by the person controlling the works.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'CM_03_COMPETENCE_CHECKED',    30, 'The competence of the people working under the permit has been checked and is deemed to be adequate for these works.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'GEN_02_PIC_HAZARDS_AWARE',    40, 'The person in charge of the works must be made aware of all hazards within the vicinity of the place of works.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'CM_05_PPE_IDENTIFIED',        50, 'Where the use of PPE is identified as a control measure within the risk assessment, this equipment is in good order.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'GEN_03_ISOLATED_LOCKED',      60, 'All equipment/systems to be worked on have been isolated and locked off from all sources of energy, with suitable signage fitted.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'CM_08_STORED_ENERGY',         70, 'All systems to be worked on have been checked to ensure that any stored energy has been dissipated.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'GEN_04_ACCEPTOR_ISOLATION',   80, 'The person accepting this permit must be shown the points of isolation and be given the option of fitting additional safety locks.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'GEN_05_REFERRAL_LV_HV_TEST',  90, 'Where works and/or testing is to be conducted on potentially ''live equipment'', a separate ''Low Voltage'' and/or ''High Voltage'' Electrical Permit and/or ''Sanction to Test'' must be issued.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'GEN_06_REFERRAL_HV_ACCESS',  100, 'Where works are in the vicinity of High Voltage systems and/or equipment a ''High Voltage Limitation of Access'' must be issued.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'GEN_07_REFERRAL_HEIGHT',     110, 'Where ''Working at Height'' is to be conducted, a separate ''Working at Height Permit'' must be issued.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'GEN_08_REFERRAL_CONFINED',   120, 'Where works are to be conducted in an area defined as a ''Confined Space'', a separate ''Confined Spaces Permit'' must be issued.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'GEN_09_REFERRAL_HOT_WORKS',  130, 'Where ''Hot Works'' are to be conducted, a separate ''Hot Works Permit'' must be issued.');
    upsert_item(l_general_type_id, 'CONTROL_MEASURES', 'GEN_01_PRESSURE_NEUTRAL',    140, 'Where works are to be conducted on pressurised systems, the pressure system must be returned to a neutral state before work commences.');

    ------------------------------------------------------------------------
    -- GENERAL — PPE: no separate PPE checklist exists on the real form
    -- (PPE only referenced inline in item 5). Retire the 6 invented items
    -- rather than delete, so any recorded response keeps its history.
    ------------------------------------------------------------------------
    UPDATE ptw_pro.ptw_checklist_items
    SET    is_active = 'N'
    WHERE  type_id      = l_general_type_id
    AND    section_code = 'PPE';
```

**Known gap, deliberately deferred:** item 14's "Initial to Confirm" needs
initials text captured, not just Tick/N/A. `ptw_checklist_responses.response`
is `CHECK (response IN ('Y','N','NA'))` — no field for it. Decision made to
skip this for now; revisit when ready.

---

## 3. New package — `ptw_ui_pkg`

Shared step-bar + permit-type badge HTML, called identically from every page.
Uses the `Dynamic Content` region type (current, non-legacy pattern — `PL/SQL
Dynamic Content`/`htp.p` has been Legacy since APEX 22.2).

```sql
CREATE OR REPLACE PACKAGE ptw_pro.ptw_ui_pkg AS

    -- Workflow step bar. Steps shown depend on ptw_type; current position
    -- comes from current_step. LV Isolation gets 5 steps (includes
    -- Equipment Isolation); every other type gets 4.
    FUNCTION get_workflow_steps_html(
        p_permit_id IN ptw_pro.ptw_lv_permits.permit_id%TYPE
    ) RETURN CLOB;

    -- Small badge showing the permit type's description (e.g. "General
    -- Permit to Work"). Sits directly below the step bar on every page.
    FUNCTION get_permit_type_badge_html(
        p_permit_id IN ptw_pro.ptw_lv_permits.permit_id%TYPE
    ) RETURN CLOB;

END ptw_ui_pkg;
/
```

```sql
CREATE OR REPLACE PACKAGE BODY ptw_pro.ptw_ui_pkg AS

    FUNCTION get_workflow_steps_html(
        p_permit_id IN ptw_pro.ptw_lv_permits.permit_id%TYPE
    ) RETURN CLOB IS

        TYPE t_step_rec IS RECORD (
            step_code  VARCHAR2(30),
            step_label VARCHAR2(50)
        );
        TYPE t_step_tab IS TABLE OF t_step_rec INDEX BY PLS_INTEGER;

        l_steps        t_step_tab;
        l_ptw_type     ptw_pro.ptw_lv_permits.ptw_type%TYPE;
        l_current_step ptw_pro.ptw_lv_permits.current_step%TYPE;
        l_current_idx  PLS_INTEGER := 0;
        l_html         CLOB := '<div class="ptw-workflow-progress">';
        l_class        VARCHAR2(30);
        l_icon         VARCHAR2(20);

    BEGIN
        SELECT ptw_type, current_step
        INTO   l_ptw_type, l_current_step
        FROM   ptw_pro.ptw_lv_permits
        WHERE  permit_id = p_permit_id;

        IF l_ptw_type = 'LV ISOLATION' THEN
            l_steps(1).step_code := 'SITE_WORK_DETAILS'; l_steps(1).step_label := 'Site & Work Details';
            l_steps(2).step_code := 'CONTROL_MEASURES';  l_steps(2).step_label := 'Control Measures';
            l_steps(3).step_code := 'EQUIP_ISOLATION';   l_steps(3).step_label := 'Equipment Isolation';
            l_steps(4).step_code := 'AUTHORISATION';     l_steps(4).step_label := 'Authorisation';
            l_steps(5).step_code := 'CLEARANCE';         l_steps(5).step_label := 'Clearance';
        ELSE
            l_steps(1).step_code := 'SITE_WORK_DETAILS'; l_steps(1).step_label := 'Site & Work Details';
            l_steps(2).step_code := 'CONTROL_MEASURES';  l_steps(2).step_label := 'Control Measures';
            l_steps(3).step_code := 'AUTHORISATION';     l_steps(3).step_label := 'Authorisation';
            l_steps(4).step_code := 'CLEARANCE';         l_steps(4).step_label := 'Clearance';
        END IF;

        FOR i IN 1 .. l_steps.COUNT LOOP
            IF l_steps(i).step_code = l_current_step THEN
                l_current_idx := i;
            END IF;
        END LOOP;

        FOR i IN 1 .. l_steps.COUNT LOOP
            IF l_current_idx = 0 THEN
                l_class := NULL;                 -- unrecognised step (e.g. CANCELLED)
                l_icon  := TO_CHAR(i);
            ELSIF i < l_current_idx THEN
                l_class := 'completed';
                l_icon  := '&#10003;';
            ELSIF i = l_current_idx THEN
                l_class := 'active';
                l_icon  := TO_CHAR(i);
            ELSE
                l_class := NULL;
                l_icon  := TO_CHAR(i);
            END IF;

            l_html := l_html
                || '<div class="workflow-step' || CASE WHEN l_class IS NOT NULL THEN ' ' || l_class END
                || '" data-step="' || i || '">'
                || '<span class="step-icon">' || l_icon || '</span>'
                || '<span class="step-text">' || APEX_ESCAPE.HTML(l_steps(i).step_label) || '</span>'
                || '</div>';
        END LOOP;

        RETURN l_html || '</div>';

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;   -- new/unsaved permit — nothing to render yet
    END get_workflow_steps_html;


    FUNCTION get_permit_type_badge_html(
        p_permit_id IN ptw_pro.ptw_lv_permits.permit_id%TYPE
    ) RETURN CLOB IS
        l_type_desc ptw_pro.ptw_types.type_desc%TYPE;
    BEGIN
        SELECT t.type_desc
        INTO   l_type_desc
        FROM   ptw_pro.ptw_lv_permits p
        JOIN   ptw_pro.ptw_types t ON t.ptw_type = p.ptw_type
        WHERE  p.permit_id = p_permit_id;

        RETURN '<div class="ptw-permit-type-badge" style="margin-bottom:12px;">'
            || '<span class="apex-badge" style="background-color:#5a6b7a;color:white;'
            || 'padding:4px 14px;border-radius:14px;font-weight:600;font-size:0.85rem;">'
            || APEX_ESCAPE.HTML(l_type_desc)
            || '</span></div>';

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END get_permit_type_badge_html;

END ptw_ui_pkg;
/
```

Badge colour (`#5a6b7a`) is a placeholder, distinct from the existing green
permit-number badge on Page 2 — adjust to match your palette if needed.

`CANCELLED` isn't in either step list — a cancelled permit renders with no
step highlighted. Deliberate simplification; revisit if you want a specific
"cancelled" treatment.

---

## 4. Page 23 — Permit Types admin

**Report query** — change the inner join on `ptw_lv_company_types` to a LEFT
JOIN (was silently hiding every type the company hadn't already toggled):

```sql
FROM   ptw_pro.ptw_types pt
LEFT JOIN ptw_pro.ptw_lv_company_types ct
       ON ct.type_id = pt.type_id AND ct.company_id = :P23_EFFECTIVE_COMPANY_ID
LEFT JOIN ptw_pro.ptw_lv_team_types tt
       ON tt.type_id = pt.type_id AND tt.team_id = :P23_TEAM_ID
LEFT JOIN ptw_pro.ptw_lv_user_types ut
       ON ut.type_id = pt.type_id AND ut.user_id = :P23_ENGINEER_ID
WHERE  pt.available = 'Y'
```
Delete the old `-- AND ct.is_active = 'Y'` commented-out line entirely.

**Process "Save Permit Type Assignments"** — in the `COMPANY` branch, scope
the "is this type in use" check to the logged-in company and surface a real
error instead of silently reverting the flag:

```plsql
ELSIF v_new_val = 'N' AND v_exists > 0 THEN

    SELECT COUNT(*) INTO v_used
    FROM   ptw_pro.ptw_lv_permits p
    WHERE  p.ptw_type   = (SELECT ptw_type FROM ptw_pro.ptw_types
                             WHERE type_id = v_type_id)
    AND    p.company_id = v_company_id;

    IF v_used = 0 THEN
        DELETE FROM ptw_pro.ptw_lv_company_types
        WHERE  type_id    = v_type_id
        AND    company_id = v_company_id;

        DELETE FROM ptw_pro.ptw_lv_team_types
        WHERE  company_id = v_company_id
        AND    type_id    = v_type_id;

        DELETE FROM ptw_pro.ptw_lv_user_types
        WHERE  company_id = v_company_id
        AND    type_id    = v_type_id;
    ELSE
        apex_error.add_error(
            p_message          => 'This permit type has been used by your company and cannot be deactivated.',
            p_display_location => apex_error.c_inline_in_notification);
        RETURN;
    END IF;

END IF;
```

**Note on behaviour:** this `RETURN` aborts the whole Save on the first
blocked row — if the admin changed several types in one click and one is
blocked, none of the changes save, not just that one. Flagged, not resolved;
tell me if you want best-effort-per-row instead.

---

## 5. Page Designer changes

### Page 2 — Site & Work Details

1. **Regions → "Workflow Status"** → Attributes:
   - **Type**: change to **Dynamic Content**
   - **PL/SQL Code**:
     ```plsql
     RETURN ptw_pro.ptw_ui_pkg.get_workflow_steps_html(:P2_PERMIT_ID);
     ```
2. **Page Items → `P2_SAFETY_PROGRAMME_REF_NO`** → Server-side Condition:
   - **Type**: PL/SQL Expression
   - **Expression**: `:P2_PTW_TYPE = 'LV ISOLATION'`
3. **Page Items → `P2_ISOLATION_DIAGRAM_SERIAL_NO`** → same condition as step 2.
4. **Regions** → right-click the step-bar region → **Create Region**:
   - **Name**: `Permit Type Badge`
   - **Type**: **Dynamic Content**
   - **PL/SQL Code**:
     ```plsql
     RETURN ptw_pro.ptw_ui_pkg.get_permit_type_badge_html(:P2_PERMIT_ID);
     ```
   - Drag it directly below the step-bar region, above "Permit Information Badge".
5. Save and run. Confirm: LV-only fields hidden for General permits, shown
   for LV Isolation; type badge renders correctly under the steps.

### Page 3 — Control Measures

6. Apply the dynamic checklist refactor from `multiPermitVersionChanges/00_README.md`
   ("Builder steps for the new General/LV checklist UI (Page 3)", steps 1–7) —
   already written, never applied. Retires the fixed `P3_CM_01..16` / `P3_PPE_*`
   items in favour of the JSON-driven checklist.
7. **Regions → step-bar region** → same Dynamic Content swap as Page 2 step 1:
   ```plsql
   RETURN ptw_pro.ptw_ui_pkg.get_workflow_steps_html(:P3_PERMIT_ID);
   ```
8. Add **Permit Type Badge** region, same pattern as Page 2 step 4, using
   `:P3_PERMIT_ID`.

### Page 4 — Equipment Isolation

9. **Regions → step-bar region** → same Dynamic Content swap:
   ```plsql
   RETURN ptw_pro.ptw_ui_pkg.get_workflow_steps_html(:P4_PERMIT_ID);
   ```
10. Add **Permit Type Badge** region, same pattern, using `:P4_PERMIT_ID`.
11. No item-level changes — every field on this page is LV-specific by
    design, and non-LV permits don't reach it via normal navigation (Page 3
    branch). **Not fixed in this pass:** direct URL access
    (`f?p=...:4:...:P4_PERMIT_ID`) isn't blocked for non-LV permits — flagged,
    open item.

### Page 5 — Authorisation & Acceptance

12. **Regions → "Workflow Progress"** → same Dynamic Content swap:
    ```plsql
    RETURN ptw_pro.ptw_ui_pkg.get_workflow_steps_html(:P5_PERMIT_ID);
    ```
13. Add **Permit Type Badge** region, same pattern, using `:P5_PERMIT_ID`.
14. No other Page 5 changes in this pass — `CLOSE` stage / `auth_to_datetime`
    process wiring is separate follow-up work (see Section 1's note).

---

## Open items carried forward, not actioned this round

- Page 5 process changes to actually use `p_stage => 'CLOSE'` and
  `p_auth_to_datetime` (new page items + a Permit Closure section needed).
- Item 14's "Initial to Confirm" — no initials-capture field on
  `ptw_checklist_responses` yet.
- Page 4 reachable via direct URL for non-LV permit types.
- Whether Pages 16 (Clearance) and 17 (Cancel) need the same step-bar +
  type-badge treatment — not yet audited.
- Save-batch behaviour on Page 23: hard-stop vs. best-effort-per-row when a
  type is blocked from deactivation.
