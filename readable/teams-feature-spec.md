# PTW_LV — Teams & Tiered Permit-Type Assignment
## Implementation Spec

**Status:** Design confirmed through discussion. Two items remain open (marked ⚠️ below) — resolve before building the pieces they affect.

---

## 1. Design summary (confirmed)

- **Hierarchy:** Company (1) → Teams (N) → Engineers (N), engineer belongs to **exactly one team** (nullable — not mandatory).
- **Resolution rule:** most-specific-wins, tri-state at team and engineer level.
  - No row at a level = inherit from the level above.
  - `is_active = 'Y'` = explicitly granted at this level.
  - `is_active = 'N'` = explicitly denied at this level, overrides anything above it.
- **Company remains the master gate** — a type must be company-licensed (`ptw_lv_company_types`) before any team/engineer override on it has meaning. Team/engineer rows for a type the company doesn't hold are inert (ignored by the resolution view) until/unless the company re-adds that type.
- **No teams defined = no behavior change.** `team_id` is nullable on `ptw_lv_users`; the resolution view's `LEFT JOIN`s degrade to company-only via standard NULL-never-matches semantics. No backfill, no default team required to avoid breakage.
- **Page 14 filters by the logged-in creator**, not a separately chosen engineer (confirmed from your existing query) — normal users resolve through the effective-types view; a super user viewing a company (no specific engineer selected) falls back to company-level types only, by design, since there's no engineer to resolve overrides against.

---

## 2. Schema changes

Run in this order (FK dependencies).

```sql
--------------------------------------------------------------------------------
-- 2.1 Teams
--------------------------------------------------------------------------------
CREATE TABLE ptw_pro.ptw_lv_teams (
    team_id        NUMBER GENERATED ALWAYS AS IDENTITY
                   MINVALUE 1 START WITH 1 CACHE 20 NOT NULL ENABLE,
    company_id     NUMBER NOT NULL ENABLE,
    team_name      VARCHAR2(200) NOT NULL ENABLE,
    is_active      VARCHAR2(1) DEFAULT 'Y' NOT NULL ENABLE,
    created_date   TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    created_by     VARCHAR2(100),
    modified_date  TIMESTAMP(6),
    modified_by    VARCHAR2(100),
    CONSTRAINT pk_ptw_lv_teams PRIMARY KEY (team_id) USING INDEX ENABLE,
    CONSTRAINT uq_ptw_lv_teams UNIQUE (company_id, team_name) USING INDEX ENABLE,
    CONSTRAINT chk_ptw_lv_teams_active CHECK (is_active IN ('Y','N')) ENABLE,
    CONSTRAINT fk_ptw_lv_teams_company FOREIGN KEY (company_id)
        REFERENCES ptw_pro.ptw_lv_companies (company_id)
);
CREATE INDEX ptw_pro.idx_ptw_lv_teams_company ON ptw_pro.ptw_lv_teams (company_id);

--------------------------------------------------------------------------------
-- 2.2 Engineer -> Team (nullable, one team only)
--------------------------------------------------------------------------------
ALTER TABLE ptw_pro.ptw_lv_users ADD (
    team_id NUMBER,
    CONSTRAINT fk_ptw_lv_users_team FOREIGN KEY (team_id)
        REFERENCES ptw_pro.ptw_lv_teams (team_id)
);
CREATE INDEX ptw_pro.idx_ptw_lv_users_team ON ptw_pro.ptw_lv_users (team_id);

--------------------------------------------------------------------------------
-- 2.3 Team-level override (tri-state)
--------------------------------------------------------------------------------
CREATE TABLE ptw_pro.ptw_lv_team_types (
    team_type_id   NUMBER GENERATED ALWAYS AS IDENTITY
                   MINVALUE 1 START WITH 1 CACHE 20 NOT NULL ENABLE,
    company_id     NUMBER NOT NULL ENABLE,   -- denormalized for direct VPD predicate
    team_id        NUMBER NOT NULL ENABLE,
    type_id        NUMBER NOT NULL ENABLE,
    is_active      VARCHAR2(1) NOT NULL ENABLE,  -- 'Y' granted / 'N' denied here; no row = inherit
    created_date   TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    created_by     VARCHAR2(100),
    modified_date  TIMESTAMP(6),
    modified_by    VARCHAR2(100),
    CONSTRAINT pk_ptw_lv_team_types PRIMARY KEY (team_type_id) USING INDEX ENABLE,
    CONSTRAINT uq_ptw_lv_team_types UNIQUE (team_id, type_id) USING INDEX ENABLE,
    CONSTRAINT chk_ptw_lv_team_types_active CHECK (is_active IN ('Y','N')) ENABLE,
    CONSTRAINT fk_ptw_lv_team_types_company FOREIGN KEY (company_id)
        REFERENCES ptw_pro.ptw_lv_companies (company_id),
    CONSTRAINT fk_ptw_lv_team_types_team FOREIGN KEY (team_id)
        REFERENCES ptw_pro.ptw_lv_teams (team_id),
    CONSTRAINT fk_ptw_lv_team_types_type FOREIGN KEY (type_id)
        REFERENCES ptw_pro.ptw_types (type_id)
);
CREATE INDEX ptw_pro.idx_ptw_lv_team_types_team ON ptw_pro.ptw_lv_team_types (team_id);
CREATE INDEX ptw_pro.idx_ptw_lv_team_types_company ON ptw_pro.ptw_lv_team_types (company_id);

--------------------------------------------------------------------------------
-- 2.4 Engineer-level override (tri-state), same shape
--------------------------------------------------------------------------------
CREATE TABLE ptw_pro.ptw_lv_user_types (
    user_type_id   NUMBER GENERATED ALWAYS AS IDENTITY
                   MINVALUE 1 START WITH 1 CACHE 20 NOT NULL ENABLE,
    company_id     NUMBER NOT NULL ENABLE,
    user_id        NUMBER NOT NULL ENABLE,
    type_id        NUMBER NOT NULL ENABLE,
    is_active      VARCHAR2(1) NOT NULL ENABLE,  -- 'Y' granted / 'N' denied; no row = inherit
    created_date   TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    created_by     VARCHAR2(100),
    modified_date  TIMESTAMP(6),
    modified_by    VARCHAR2(100),
    CONSTRAINT pk_ptw_lv_user_types PRIMARY KEY (user_type_id) USING INDEX ENABLE,
    CONSTRAINT uq_ptw_lv_user_types UNIQUE (user_id, type_id) USING INDEX ENABLE,
    CONSTRAINT chk_ptw_lv_user_types_active CHECK (is_active IN ('Y','N')) ENABLE,
    CONSTRAINT fk_ptw_lv_user_types_company FOREIGN KEY (company_id)
        REFERENCES ptw_pro.ptw_lv_companies (company_id),
    CONSTRAINT fk_ptw_lv_user_types_user FOREIGN KEY (user_id)
        REFERENCES ptw_pro.ptw_lv_users (user_id),
    CONSTRAINT fk_ptw_lv_user_types_type FOREIGN KEY (type_id)
        REFERENCES ptw_pro.ptw_types (type_id)
);
CREATE INDEX ptw_pro.idx_ptw_lv_user_types_user ON ptw_pro.ptw_lv_user_types (user_id);
CREATE INDEX ptw_pro.idx_ptw_lv_user_types_company ON ptw_pro.ptw_lv_user_types (company_id);
```

---

## 3. VPD

No new policy function — apply the existing `PTW_SEC_PKG.COMPANY_POLICY` to the three new tables, identical to how it's already applied to `ptw_lv_company_types` (see `02_vpd_policy_3.sql`, section 3).

```sql
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema   => 'PTW_PRO',
        object_name     => 'PTW_LV_TEAMS',
        policy_name     => 'PTW_COMPANY_POLICY',
        function_schema => 'PTW_PRO',
        policy_function => 'PTW_SEC_PKG.COMPANY_POLICY',
        statement_types => 'SELECT,INSERT,UPDATE,DELETE',
        update_check    => TRUE
    );
    DBMS_RLS.ADD_POLICY(
        object_schema   => 'PTW_PRO',
        object_name     => 'PTW_LV_TEAM_TYPES',
        policy_name     => 'PTW_COMPANY_POLICY',
        function_schema => 'PTW_PRO',
        policy_function => 'PTW_SEC_PKG.COMPANY_POLICY',
        statement_types => 'SELECT,INSERT,UPDATE,DELETE',
        update_check    => TRUE
    );
    DBMS_RLS.ADD_POLICY(
        object_schema   => 'PTW_PRO',
        object_name     => 'PTW_LV_USER_TYPES',
        policy_name     => 'PTW_COMPANY_POLICY',
        function_schema => 'PTW_PRO',
        policy_function => 'PTW_SEC_PKG.COMPANY_POLICY',
        statement_types => 'SELECT,INSERT,UPDATE,DELETE',
        update_check    => TRUE
    );
END;
/
```

Note: `ptw_lv_users` itself is **not** VPD-protected on `team_id` specifically — the FK just needs `ptw_lv_teams` to already be VPD-scoped so a company admin can't assign a user to another company's team by ID-guessing. Confirm `ptw_lv_users` has row-level protection already (it should, being the root of company scoping) — no new work here, just a sanity check when you test.

---

## 4. Effective-types resolution view

Single source of truth. Every place in the app that needs to answer "can this engineer issue this type" should query this view — not re-implement the tri-state logic inline (this is exactly the drift problem the logo header/PDF/report-template had; don't repeat it here with three copies of the same CASE logic).

```sql
CREATE OR REPLACE VIEW ptw_pro.ptw_lv_effective_types_v AS
SELECT
    u.user_id,
    u.username,
    u.company_id,
    u.team_id,
    ct.type_id,
    CASE
        WHEN ut.is_active IS NOT NULL THEN ut.is_active   -- engineer override wins
        WHEN tt.is_active IS NOT NULL THEN tt.is_active   -- else team override
        ELSE 'Y'                                          -- else company grant (ct pre-filtered active)
    END AS is_active
FROM ptw_pro.ptw_lv_users         u
JOIN ptw_pro.ptw_lv_company_types ct
     ON ct.company_id = u.company_id AND ct.is_active = 'Y'
LEFT JOIN ptw_pro.ptw_lv_team_types tt
     ON tt.team_id = u.team_id AND tt.type_id = ct.type_id
LEFT JOIN ptw_pro.ptw_lv_user_types ut
     ON ut.user_id = u.user_id AND ut.type_id = ct.type_id;
```

Standard usage: `EXISTS (SELECT 1 FROM ptw_lv_effective_types_v WHERE username = :x AND type_id = :y AND is_active = 'Y')`.

---

## 5. Page 23 changes (Company Permit Types)

**Bug fix already agreed (from earlier in this thread)** — replace the existing save process with the G_OVERRIDE_COMPANY_ID-aware version + explicit `company_id` filter on the exists-check (VPD doesn't scope super users). See that corrected block already delivered.

**New requirement from teams:** when a type is **revoked** at company level, cascade-delete any team/engineer override rows for that `(company_id, type_id)` — otherwise they sit orphaned and silently reactivate if the company re-adds the type later without anyone reviewing whether that's still wanted.

Add to the `ELSIF v_new_val = 'N' AND v_exists > 0 THEN` branch, after the existing `v_used = 0` check passes and before/alongside the `DELETE FROM ptw_lv_company_types`:

```sql
DELETE FROM ptw_pro.ptw_lv_team_types
WHERE  company_id = v_company_id
AND    type_id    = v_type_id;

DELETE FROM ptw_pro.ptw_lv_user_types
WHERE  company_id = v_company_id
AND    type_id    = v_type_id;
```

Order matters only in that these should run in the same transaction as the company-level delete (they already will, since it's all one PL/SQL block with no intermediate commit).

---

## 6. Page 14 changes (Create Permit — type picker)

Replace the current `LOV` query with:

```sql
SELECT t.type_desc d,
       t.ptw_type  r
FROM   ptw_pro.ptw_types t
WHERE  t.available = 'Y'
AND (
        t.type_id IN (
            SELECT et.type_id
            FROM   ptw_pro.ptw_lv_effective_types_v et
            WHERE  UPPER(et.username) = UPPER(v('APP_USER'))
            AND    et.is_active = 'Y'
        )
     OR
        (
            :P14_COMPANY_ID IS NOT NULL
        AND t.type_id IN (
                SELECT ct.type_id
                FROM   ptw_pro.ptw_lv_company_types ct
                WHERE  ct.company_id = :P14_COMPANY_ID
                AND    ct.is_active = 'Y'
            )
        )
    )
ORDER BY t.type_desc
```

⚠️ **Open item — confirm before building:** this keeps the super-user path at company-level-only (no engineer selected on this page today, so no team/individual override to resolve). If you actually want the super user to pick *which* engineer they're creating on behalf of (and get that engineer's real effective types), Page 14 needs a new select list first — that's a bigger change than "swap the query" and should be scoped separately. Confirm scope before implementing.

---

## 7. New page — Team Administration

One new page, not two. Engineer↔team assignment does **not** need its own page (see §8).

**Suggested placement:** under existing **Super User Admin** or **Admin** menu group (wherever Page 21 "Companies" lives), as a peer to it — "Companies → Teams" is a natural drill-down.

**Structure:**

- **Region: Teams** (Interactive Report or Grid) — scoped to the active company (same `G_OVERRIDE_COMPANY_ID` pattern as Page 23/28). Columns: team_name, is_active, engineer count, created_date. Row actions: Edit, Deactivate.
- **Region: Team Detail** (shown on row select or "Create Team") — team_name, is_active. Standard create/edit form, same pattern as Page 24 (Edit Company).
- **Region: Team Permit Types** (shown once a team is selected) — tri-state grid, one row per `ptw_types` row that's currently company-licensed (join to `ptw_lv_company_types` filtered active — don't show types the company doesn't hold, since team overrides on them would be inert). Three-state control per row: **Inherit / Granted / Denied** — do **not** use a plain checkbox (that can only represent two states; you need three). Options for the control itself:
  - Radio group (3 options) per row — most explicit, most vertical space.
  - Select list per row — compact, standard APEX pattern for tri-state in a report (Page 23's existing checkbox-grid save process is a good template to adapt: same `apex_application.g_f01`/`g_f02` array-processing pattern, just reading a select value instead of a checkbox state).
- **Process:** same array-loop pattern as Page 23's (corrected) save process, upserting into `ptw_lv_team_types` — `Inherit` selected = delete the row if it exists; `Granted`/`Denied` selected = insert or update `is_active`.

---

## 8. Page 8 changes (User Management)

Two additions to the existing edit form — no new page.

1. **`team_id` field** — Select List, LOV = teams for the user's (or override) company (`ptw_lv_teams` where `company_id = :effective company` and `is_active = 'Y'`), null-permitted (`-- No Team --`).
2. **Engineer Permit Types region** — same tri-state grid as §7's team version, scoped to `ptw_lv_user_types` for the selected user instead of team. Same array-loop upsert pattern.

⚠️ **Open item, not yet decided — flag if it matters to you:** if a future "Team Lead" role needs to manage their own team's roster/type-grid without full Page 8 access, that's a reason to split engineer-team-assignment into its own restricted page later. Not needed for the current scope (Company Admin manages everything) — noted so it doesn't get forgotten if a Team Lead role comes up.

---

## 9. Build order (respects dependencies, lets you test incrementally)

1. Schema (§2) + VPD (§3) + view (§4) — no UI impact yet, safe to deploy standalone and verify via SQL Workshop (`SELECT * FROM ptw_lv_effective_types_v` against existing data — should show every engineer with `is_active = 'Y'` for every company-licensed type, since no team/user override rows exist yet — confirms §1's "no teams = no behavior change" claim before touching any page).
2. Page 23 save-process fix + cascade-delete (§5) — independent of teams UI, ships the already-agreed bug fix regardless of team rollout timing.
3. Page 14 query swap (§6) — depends on §4's view existing; safe once step 1 is deployed, since the view degrades to company-only with no teams/users overrides present.
4. New Team Admin page (§7) — first point where teams can actually be created.
5. Page 8 additions (§8) — last, since it's the only place engineers get assigned to teams or given individual overrides; nothing upstream needs it to exist first.

## 10. Testing checklist

- [ ] Engineer with no team, no individual override → gets exactly company-level types (regression check against current behavior).
- [ ] Engineer with a team, team has no override on type X → inherits company's grant/absence of X.
- [ ] Engineer with a team, team explicitly denies type X (company allows it) → engineer cannot issue X.
- [ ] Engineer individually denied type X (team/company allow it) → engineer cannot issue X — this is your original test case.
- [ ] Engineer individually granted type X that their team denies → engineer **can** issue X (engineer beats team).
- [ ] Company revokes type X entirely → Page 23 cascade-delete removes orphaned team/user rows for X; re-adding X later does **not** silently reactivate old overrides.
- [ ] Super user, no company selected → Page 14 shows nothing (matches current behavior).
- [ ] Super user, company selected, no specific engineer → Page 14 shows company-level types only (confirmed §6 scope).
