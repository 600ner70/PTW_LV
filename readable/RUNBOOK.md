# PTW LV — Multi-Tenant (VPD) Implementation Runbook

**STATUS: All design decisions resolved. Ready to execute.**

This is the full, in-order sequence to roll out company-based data isolation.
Each step says WHAT to do, WHERE to do it, and references the exact script
file. Do not skip the verification steps — they're cheap and catch problems
before they become hard to undo.

**Recommend running this entire runbook on a TEST/DEV copy of the database
first.** Several steps add constraints and enable RLS — both are easy to add,
much harder to safely back out once real data and live users are involved.

## Quick Reference — Files

| File | Used in |
|---|---|
| `get_ptw_pro_ddl.sql` | Step 0.1 — full DDL snapshot before starting |
| `01_ddl_multitenancy.sql` | Stage 1 — companies table, company_id columns, child triggers, company_types junction table |
| `04_backfill.sql` | Stage 2 — assign existing data to default company |
| `06_stage_locations.sql` | Stage 3 — permit history table changes |
| `02_vpd_policy.sql` | Stage 4 — security package, VPD policies, ownership guard |
| `03_views_and_functions.sql` | Stage 4 — updated view and permit-visibility function |
| `05_apex_changes.md` | Stages 5–8 — all APEX-side page changes |
| `99_rollback.sql` | Emergency rollback — see end of this document |

## Quick Reference — Stages

| Stage | What | App impact |
|---|---|---|
| 0 | Preparation | None |
| 1 | Schema additions (DDL) | None — new/nullable columns only |
| 2 | Backfill existing data | None — data only |
| 3 | Permit history table | None yet — VPD not active |
| 4 | Security package + VPD policies | ⚠️ **App goes blank until Stage 5** |
| 5 | Wire APEX to security package | Restores app, now company-scoped |
| 6 | New admin pages (companies, permit types) | New pages only |
| 7 | Permit creation auto-stamp + super user picker | Page 14 gains picker (super users only) |
| 8 | Page 8 User Management rework | Page 8 filtered + hardened |
| 9 | End-to-end testing | — |

**Run Stages 4 and 5 in the same maintenance window** — between them the
app is non-functional for all users.

---

## STAGE 0 — Preparation (no changes to the live app yet)

### Step 0.1 — Get a fresh full DDL export
Run `get_ptw_pro_ddl.sql` (already fixed for ISEQ$$ and constraint errors)
against PTW_PRO. Save the output — this is your "before" snapshot, useful if
anything needs rolling back.

### Step 0.2 — Design decisions (all resolved)

| # | Question | Decision |
|---|---|---|
| A | How are permit types scoped per company? | `ptw_types` stays global (super-user managed master list); new `ptw_lv_company_types` junction table is the company-scoped, VPD-protected, billable assignment |
| B | Can super users create permits? | Yes — via a company picker on Page 14 (Step 7.0), with a "Return to Super User View" link (Step 7.0b) to reset afterwards |
| C | `ptw_stage_locations` FK on delete | `ON DELETE CASCADE` — consistent with sibling child tables |
| D | Is `ptw_lv_users` under VPD? | No — three-layer protection instead: filtered region (8.1), protected page item (8.2), DML ownership guard via `check_user_in_company` (8.3) |

### Step 0.3 — Create your first company record
You'll need at least one `company_id` to backfill existing data into. Do this
now so Stage 2's backfill script has a real ID to use.



```sql
INSERT INTO ptw_pro.ptw_lv_companies (company_name, company_code, is_active)
VALUES ('<<Your Company Name>>', '<<SHORT_CODE>>', 'Y');

-- Note the generated company_id:
SELECT company_id FROM ptw_pro.ptw_lv_companies WHERE company_code = '<<SHORT_CODE>>';
```

⚠️ This INSERT will fail until Stage 1 creates the `ptw_lv_companies` table —
just note you'll come back to this as part of Stage 1.

---

## STAGE 1 — Schema changes (DDL only, no behaviour change yet)

**File: `01_ddl_multitenancy.sql`**

What this does, in plain English:
- Creates a new `ptw_lv_companies` table (one row per tenant company)
- Adds a `company_id` column to `ptw_lv_users` (which company each user
  belongs to) plus an `is_super_user` flag
- Adds a `company_id` column to `ptw_lv_permits` and its four child tables
  (control measures, equipment isolation, monitoring, photos)
- Adds triggers so child tables automatically copy `company_id` from their
  parent permit when a new row is inserted
- Creates a new `ptw_lv_company_types` junction table (which master permit
  types each company is licensed to use) — `ptw_types` itself is unchanged
  and stays global

**Run this entire script now.** Nothing changes for existing users yet —
these are just new, currently-unused/nullable columns and a new empty table.

### Step 1.1 — Run `01_ddl_multitenancy.sql`

### Step 1.2 — Now go back and do Step 0.3
Insert your first company row (table now exists), note its `company_id`
(call it `<<DEFAULT_COMPANY_ID>>` for the rest of this runbook).

### Step 1.3 — Verify
```sql
SELECT * FROM ptw_pro.ptw_lv_companies;
DESC ptw_pro.ptw_lv_permits;     -- confirm company_id column exists
DESC ptw_pro.ptw_lv_users;       -- confirm company_id, is_super_user exist
```

---

## STAGE 2 — Backfill existing data

**File: `04_backfill.sql`**

What this does, in plain English:
- Assigns every existing user to `<<DEFAULT_COMPANY_ID>>`
- Assigns every existing permit (and its children: control measures,
  isolation, monitoring, photos) to the same company, based on who created it
- Assigns all existing (~12) `ptw_types` master rows to
  `<<DEFAULT_COMPANY_ID>>` via `ptw_lv_company_types`, so existing users see
  no change in available permit types

### Step 2.1 — Edit the script
Open `04_backfill.sql` and replace every `1   -- <<< replace with actual...`
placeholder with your real `<<DEFAULT_COMPANY_ID>>` from Step 1.2.

### Step 2.2 — Designate your super user(s)
Still in `04_backfill.sql`, find the commented-out block:
```sql
-- UPDATE ptw_pro.ptw_lv_users SET is_super_user = 'Y', company_id = NULL
-- WHERE username = '<<your username>>';
```
Uncomment it, put in your own username (the APEX workspace admin / "you"),
and run it. This is the person who can see across all companies.

### Step 2.3 — Run the rest of the script
Run sections 3–5 (permits, child tables, ptw_lv_company_types seed).

### Step 2.4 — Verify — check for remaining NULLs
Run the verification queries at the bottom of `04_backfill.sql` (section 6).
**All must return 0** before continuing:
```sql
SELECT COUNT(*) FROM ptw_pro.ptw_lv_permits WHERE company_id IS NULL;
SELECT COUNT(*) FROM ptw_pro.ptw_lv_control_measures WHERE company_id IS NULL;
SELECT COUNT(*) FROM ptw_pro.ptw_lv_equipment_isolation WHERE company_id IS NULL;
SELECT COUNT(*) FROM ptw_pro.ptw_lv_monitoring WHERE company_id IS NULL;
SELECT COUNT(*) FROM ptw_pro.ptw_lv_permit_photos WHERE company_id IS NULL;
SELECT COUNT(*) FROM ptw_pro.ptw_lv_users WHERE company_id IS NULL AND is_super_user = 'N';
```
If any return > 0, stop and investigate — do not proceed to Stage 3 with
unassigned rows, they will become invisible to everyone once VPD is live.

### Step 2.5 — Make company_id mandatory going forward
Now that every row has a value, lock it in:
```sql
ALTER TABLE ptw_pro.ptw_lv_permits MODIFY (company_id NOT NULL);
ALTER TABLE ptw_pro.ptw_lv_control_measures MODIFY (company_id NOT NULL);
ALTER TABLE ptw_pro.ptw_lv_equipment_isolation MODIFY (company_id NOT NULL);
ALTER TABLE ptw_pro.ptw_lv_monitoring MODIFY (company_id NOT NULL);
ALTER TABLE ptw_pro.ptw_lv_permit_photos MODIFY (company_id NOT NULL);
-- ptw_lv_users.company_id stays nullable (super users have none)
```

---

## STAGE 3 — Permit history table (ptw_stage_locations)

**File: `06_stage_locations.sql`**

What this does, in plain English:
- Adds `company_id` to `ptw_stage_locations` (the table that records GPS
  location at each stage of a permit's lifecycle — feeds Page 6 Permit
  History)
- Adds a foreign key linking each location record back to its permit
- Updates the three triggers that write to this table so they also record
  which company the row belongs to

### Step 3.1 — Check for orphaned rows first
Run the SELECT in Step 1 of the script:
```sql
SELECT DISTINCT sl.permit_id
FROM   ptw_pro.ptw_stage_locations sl
WHERE  NOT EXISTS (
           SELECT 1 FROM ptw_pro.ptw_lv_permits p
           WHERE  p.permit_id = sl.permit_id
       );
```
If this returns rows, decide: delete them (if clearly test/junk data) or
investigate why permits referenced here no longer exist. **Resolve before
continuing** — the FK addition in Step 3.2 will fail otherwise.

### Step 3.2 — Run the rest of `06_stage_locations.sql`
This adds the company_id column, the FK + index, and replaces all three
triggers (control measures, monitoring, permits) with versions that stamp
`company_id` on every history row.

Decision C (settled): `ON DELETE CASCADE` — if a permit is hard-deleted
(Page 1 → Delete Permit), its location history is deleted too, consistent
with the other child tables.

### Step 3.3 — Verify
```sql
-- Make a small test edit on an existing IN_PROGRESS permit (e.g. Page 3,
-- tick a control measure checkbox and save), then:
SELECT * FROM ptw_pro.ptw_stage_locations
WHERE permit_id = <<test permit id>>
ORDER BY created_date DESC;
-- Confirm the new row has company_id populated correctly.
```

---

## STAGE 4 — Security package and VPD policies

**Files: `02_vpd_policy.sql`, `03_views_and_functions.sql`**

⚠️ **This is the stage that actually turns on data isolation.** Before
running this, make sure Stages 1–3 are fully complete and verified —
once VPD is live, any row without a correctly-set `company_id` or session
context becomes invisible.

### Step 4.1 — Create the security package
Run the first two sections of `02_vpd_policy.sql`:
- Creates a database "context" called `PTW_SEC_CTX` — a secure, session-only
  scratch space that holds the current user's company_id
- Creates a package `PTW_SEC_PKG` with two parts:
  - `set_session_context` — works out which company the logged-in user
    belongs to, and stores it in the context
  - `company_policy` — the actual security rule: "only show rows where
    company_id matches the session's company, unless the user is a super
    user or APEX workspace admin, in which case show everything"

### Step 4.2 — Apply the VPD policies
Run section 3 of `02_vpd_policy.sql` — this attaches the `company_policy`
rule to these tables:
- `ptw_lv_permits`
- `ptw_lv_control_measures`
- `ptw_lv_equipment_isolation`
- `ptw_lv_monitoring`
- `ptw_lv_permit_photos`
- `ptw_lv_company_types`

Then also run the policy block from `06_stage_locations.sql` Step 2 to add
`ptw_stage_locations` to the same protection (if not already done in Stage 3).

**At this point, if you ran a query as PTW_PRO in SQL Developer right now,
you'd see ZERO rows in all these tables** — because no session context has
been set yet (SQL Developer isn't going through APEX). This is correct and
expected — see Stage 5 to make the app work again.

### Step 4.3 — Update the view and function
Run `03_views_and_functions.sql`:
- Updates `ptw_lv_user_roles_v` to also show each user's company_id,
  company_name, and is_super_user flag
- Replaces `ptw_lv_permit_visible` — same logic as before, but now relies on
  VPD having already filtered to the right company, so it only needs to
  apply role-based rules (admin sees all, engineer sees own, etc.) *within*
  that company

---

## STAGE 5 — Connect APEX to the security package (THE APP WILL BREAK UNTIL THIS STEP)

**File: `05_apex_changes.md`**

### Step 5.1 — Add the Post-Authentication process
In APEX App Builder:
1. Go to **Shared Components → Authentication Schemes**
2. Open your app's authentication scheme
3. Find the **Post-Authentication Procedure** field
4. Enter:
   ```sql
   ptw_pro.ptw_sec_pkg.set_session_context(:APP_USER);
   ```
5. Save

This runs once per login and tells the database which company the logged-in
user belongs to. **Without this step, every page will appear empty for every
user** (because VPD is now active but no context has been set).

### Step 5.2 — Test immediately
Log out and log back in as an existing user. You should see your permits
again (now filtered to your company — but since everyone is currently in the
same default company, you shouldn't notice a difference yet).

If pages are still blank:
- Confirm the Post-Authentication procedure saved correctly (check for typos)
- Confirm your test user has `company_id` set (not NULL) and `is_active='Y'`
  in `ptw_lv_users`
- Check for errors in **APEX Debug** (Developer Toolbar → enable Debug, reload
  page, look for ORA- errors)

---

## STAGE 6 — New admin pages

### Step 6.1 — Company Maintenance page (Super User only)
Follow section 2 of `05_apex_changes.md`:
- New page (e.g. Page 17 — pick the next free number)
- Simple Report+Form on `ptw_lv_companies`
- New authorization scheme "Super User Rights" — checks
  `ptw_lv_users.is_super_user = 'Y'` OR APEX workspace admin
- This page is NOT under VPD (super users need to see/create all companies)

### Step 6.2 — Company Permit Types page (Company Admin)
Follow section 3 of `05_apex_changes.md`:
- New page (e.g. Page 18) — Interactive Grid on `ptw_lv_company_types`,
  picking `type_id` from a LOV of `ptw_types` (the global master list)
- Restricted to users with the `ADMIN` role (existing authorization pattern,
  scoped per company automatically by VPD on `ptw_lv_company_types`)
- Add the trigger from section 3 of `05_apex_changes.md` so new rows
  automatically get the right `company_id`

This is the billable list — `SELECT COUNT(*) FROM ptw_lv_company_types
WHERE company_id = X AND is_active = 'Y'` gives the number of permit types
that company is licensed for.

### Step 6.3 — Master Permit Types page (Super User only)
Follow section 3b of `05_apex_changes.md`:
- New page (e.g. Page 19, or a tab on Page 17) — Report+Form on `ptw_types`
  (global, no VPD)
- Same "Super User Rights" authorization as Page 17
- Until this page is built, add new master types via direct SQL INSERT into
  `ptw_types`

### Step 6.4 — Update permit-type LOV on Page 14
Confirmed: there is exactly **one** location referencing `ptw_types` in the
app — Page 14 (Create PTW), item `P14_PTW_TYPES`, List of Values:

Current SQL:
```sql
SELECT type_desc d,
       ptw_type  r
FROM   ptw_pro.ptw_types
WHERE  available = 'Y';
```

Replace with:
```sql
SELECT t.type_desc d,
       t.ptw_type  r
FROM   ptw_pro.ptw_types t
JOIN   ptw_pro.ptw_lv_company_types ct ON ct.type_id = t.type_id
WHERE  ct.is_active = 'Y'
AND    t.available  = 'Y';
-- company_id filter automatic via VPD on ptw_lv_company_types
```

Note: Page 14 also has a validation `:P14_PTW_TYPES = 'LV ISOLATION'` — this
hardcoded comparison is unaffected by this change (still compares the
selected value, which still comes from `ptw_type`, unchanged).

This is the only page-level LOV change required for the types model.

---

## STAGE 7 — Permit creation auto-stamping (+ super user company picker)

### Step 7.0 — Add a company picker for super users (Page 14)

Page 14 ("Create PTW") is the entry point before Page 2. Add:

- New page item `P14_COMPANY_ID` — Select List
  - **Source**: LOV on `ptw_lv_companies` (active only)
  - **Condition — Server-side Condition**: only render/show when current
    user `is_super_user = 'Y'`:
    ```sql
    SELECT is_super_user FROM ptw_pro.ptw_lv_users
    WHERE UPPER(username) = UPPER(:APP_USER)
    ```
    (Type: "Expression" returning 'Y', or use an existing
    "Is Super User" authorization scheme as the item's server-side condition)
  - For normal company users, this item doesn't render — no UI change for
    them at all.

- New process on Page 14, **Before Header**, runs only if `P14_COMPANY_ID`
  is not null (i.e. only fires for super users who picked a company):
  ```sql
  BEGIN
      IF :P14_COMPANY_ID IS NOT NULL THEN
          DBMS_SESSION.SET_CONTEXT('PTW_SEC_CTX', 'COMPANY_ID',
              TO_CHAR(:P14_COMPANY_ID));
      END IF;
  END;
  ```

This temporarily sets the session's company context for the rest of this
permit's creation flow (Pages 2–5), so the auto-stamp trigger in Step 7.1
picks up the chosen company instead of NULL.

⚠️ **Session context persists for the whole session**, not just this
permit. If the super user navigates back to the Dashboard (Page 1) after
this, they'll now see Page 1 filtered to the *picked* company, not "all
companies", until they log out/in again (which re-runs
`set_session_context` and resets to `IS_SUPER_USER='Y'` / no filter).

This is **acceptable** as a temporary side effect for a deliberate action —
to make it clean, add a "Return to Super User View" link to Page 1.

### Step 7.0b — "Return to Super User View" link (Page 1)

- New button/link on Page 1 (Dashboard), e.g. top-right near the user menu
- **Condition — Server-side Condition**: only render when current user
  `is_super_user = 'Y'` AND `SYS_CONTEXT('PTW_SEC_CTX','IS_SUPER_USER') = 'Y'`
  (i.e. always available to super users — clicking it is a no-op if they're
  already in "all companies" view, harmless)
- Action: **Execute Code** (or a small "Reset View" page process triggered
  by the button), then redirect to Page 1:
  ```sql
  BEGIN
      ptw_pro.ptw_sec_pkg.set_session_context(:APP_USER);
  END;
  ```
- This re-runs the same logic as login's Post-Authentication process — since
  `is_super_user='Y'` for this user, it resets `COMPANY_ID` to NULL and
  `IS_SUPER_USER` to 'Y', restoring the "all companies" view immediately,
  no logout required.

With this link in place, the Step 7.0 side effect becomes a deliberate,
reversible, one-click action rather than something that lingers until next
login.

### Step 7.1 — Add the permits insert trigger
```sql
CREATE OR REPLACE TRIGGER ptw_pro.trg_ptw_lv_permits_company
BEFORE INSERT ON ptw_pro.ptw_lv_permits
FOR EACH ROW
WHEN (NEW.company_id IS NULL)
BEGIN
    :NEW.company_id := TO_NUMBER(SYS_CONTEXT('PTW_SEC_CTX','COMPANY_ID'));

    -- Safety net: if company_id is still NULL here (e.g. a super user
    -- reached this insert without going through Page 14's company picker —
    -- stale session, direct API call, etc.), block rather than create a
    -- permit with no company.
    IF :NEW.company_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001,
            'Cannot create a permit: no company selected for this session. ' ||
            'Super users must pick a company on the Create PTW screen first.');
    END IF;
END;
/
```

This means **no changes needed to Pages 2–5** for permit creation —
`company_id` is set automatically (either from the normal user's own
company, or from the super user's Page 14 picker in Step 7.0) and can't be
tampered with via page items.

### Step 7.2 — Test
Log in as a normal (non-super) user, create a new permit (Page 14 → Page 2),
save it, then:
```sql
SELECT permit_id, permit_number, company_id, created_by
FROM ptw_pro.ptw_lv_permits
ORDER BY permit_id DESC FETCH FIRST 1 ROWS ONLY;
```
Confirm `company_id` matches the user's company.

Log in as your super user, go to Page 14, confirm the company picker
appears, select a company, create a permit, and confirm `company_id`
matches the picked company. Then navigate to Page 1 (Dashboard) — confirm
it now shows that company's permits (expected side effect from Step 7.0).
Click "Return to Super User View" — confirm Page 1 returns to showing all
companies, without needing to log out.

---

## STAGE 8 — Page 8 (User Management) rework

This is the most manual page-level change. Follow section 4 of
`05_apex_changes.md`:

### Step 8.1 — Filter the user list
Edit the region source SQL for "Current Users Report" (and "User Role
Assignments") — add this WHERE condition:
```sql
WHERE (
    company_id = (SELECT company_id FROM ptw_pro.ptw_lv_users
                   WHERE UPPER(username) = UPPER(:APP_USER))
    OR
    (SELECT is_super_user FROM ptw_pro.ptw_lv_users
     WHERE UPPER(username) = UPPER(:APP_USER)) = 'Y'
)
```
(adjust to `AND (...)` if the query already has a WHERE clause). Company
admins see only their company's users; super users see everyone.

### Step 8.2 — Protect P8_USER_ID from tampering
Find the page item holding the selected user's `user_id` (likely
`P8_USER_ID` or similar — set when a row is clicked/selected in the report).

- Open the item → **Security**
- Set **Session State Protection** to `Restricted - May not be set from
  browser`

This means the value can only be set via APEX's own page processing (e.g.
selecting an IR row and submitting), not by editing the URL or browser dev
tools.

### Step 8.3 — Add the DML guard to every Page 8 process
At the very start of each of these processes' PL/SQL, add a single line:
```sql
ptw_pro.ptw_sec_pkg.check_user_in_company(:P8_USER_ID);
```
(substitute the actual item name holding the target user_id if different)

Apply to:
- Update Existing APEX User
- Reset User Password
- Deactivate User Role
- Reactivate User Role
- Unlock User Account

If the check fails, it raises `ORA-20002: Access denied...` which APEX will
show as an inline error — the process stops before any DML runs. This is
the actual guarantee; Step 8.1/8.2 reduce how often this would ever trigger,
but this is what makes it impossible to bypass.

### Step 8.4 — Add Company field to the user edit form
- New LOV item, sourced from `ptw_lv_companies`
- For Company Admins: read-only, defaulted to their own company
- For Super Users: editable, full list

### Step 8.5 — Add "Super User" checkbox
- Only visible/editable if the CURRENT logged-in user is themselves a super
  user (prevents company admins promoting themselves or others)

---

## STAGE 9 — End-to-end testing

Set up two test companies with one ADMIN and one ENGINEER user each, then
work through the checklist in section 7 of `05_apex_changes.md`:

- [ ] Company A engineer cannot see Company B's permits (including by typing
      a Company B permit_id directly into the URL)
- [ ] Company A admin cannot see Company B's users, permit types, or permits
- [ ] Super user sees all companies' data on Dashboard, Search, Analytics
- [ ] New permit auto-gets correct company_id (Stage 7)
- [ ] PTW Types page: Company A admin's additions invisible to Company B
- [ ] Photos, control measures, isolation, monitoring all inherit
      company_id correctly (check via SQL, not just UI)
- [ ] Page 6 Permit History — viewing own company's permit shows location
      history; navigating directly to another company's permit_id via
      P6_PERMIT_ID returns zero rows (not an error)
- [ ] Direct SQL as PTW_PRO (no APEX session) returns ZERO rows from all
      protected tables — proves VPD works outside the app too
- [ ] Super user: Page 14 shows company picker; creating a permit for
      Company A stamps company_id correctly; Page 1 then shows Company A's
      data; clicking "Return to Super User View" restores "all companies"
      view without logout
- [ ] Normal (non-super) user: Page 14 shows NO company picker
- [ ] Page 8: Company A admin sees only Company A users in the list
- [ ] Page 8: attempting to act on a Company B user_id (e.g. via tampered
      page item / direct process call) raises ORA-20002 and performs no DML
- [ ] Page 1 "Delete Permit" — confirm cascades correctly through all child
      tables including `ptw_stage_locations`

---

## Rollback

If major issues are hit at any stage, see `99_rollback.sql`. It is written
in the same staged structure as this runbook — you can roll back from
wherever you stopped, in reverse order. Read its header comments before
running; some steps are only safe/needed depending on how far you got.
