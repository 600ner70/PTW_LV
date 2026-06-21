# PTW LV — Multi-Tenant (VPD) Implementation Runbook

**STATUS: Fully implemented and live.**

This runbook documents what was built, in the order it was built.
It reflects the final implemented design — not any earlier drafts or
approaches that were explored and abandoned during development.

---

## Architecture Summary

Company-based data isolation using Oracle VPD (Virtual Private Database /
Row-Level Security). Each user belongs to one company and sees only that
company's data. Super users can view and act on any company's data, with an
optional company-scoping override.

**Key design principle**: the VPD policy function (`ptw_sec_pkg.company_policy`)
does a direct lookup of the current user via `V('APP_USER')` on every call.
No DB session context (`SYS_CONTEXT`) is used — this was deliberately avoided
because ORDS connection pooling means DB session state cannot be reliably
passed between page requests. `V('APP_USER')` reads APEX session state
(stored in tables, not in the DB session) and is always reliable.

---

## Quick Reference — Files

| File | Purpose |
|---|---|
| `get_ptw_pro_ddl.sql` | Full DDL snapshot before starting |
| `01_ddl_multitenancy.sql` | Stage 1 — schema additions |
| `04_backfill.sql` | Stage 2 — assign existing data to default company |
| `06_stage_locations.sql` | Stage 3 — permit history table |
| `02_vpd_policy.sql` | Stage 4 — security package + VPD policies (FINAL version) |
| `03_views_and_functions.sql` | Stage 4 — updated views |
| `99_rollback.sql` | Emergency rollback |

APEX page build specs (annotated SQL format):

| File | Pages |
|---|---|
| `ptw_lv_page21_companies.sql` | Pages 21 (Companies list) + 24 (Edit Company modal) |
| `ptw_lv_page22_master_permit_types.sql` | Pages 22 (Master Permit Types list) + 25 (Edit Permit Type modal) |
| `ptw_lv_page23_company_permit_types.sql` | Page 23 (Company Permit Types) |
| `ptw_lv_page14_stage7_company_picker.sql` | Page 14 addendum — super user company picker |
| `ptw_lv_page01_stage7_return_to_super_user.sql` | Page 1 addendum — "Viewing As" banner |
| `ptw_lv_page08_stage7_company_guard.sql` | Page 8 addendum — company guard |
| `ptw_lv_page28_set_active_company.sql` | Page 28 — Set Active Company |
| `ptw_permit_numbering.sql` | Per-company permit numbering (steps A–L) |

---

## Quick Reference — Stages

| Stage | What | Status |
|---|---|---|
| 0 | Preparation | ✅ Complete |
| 1 | Schema additions (DDL) | ✅ Complete |
| 2 | Backfill existing data | ✅ Complete |
| 3 | Permit history table | ✅ Complete |
| 4 | Security package + VPD policies | ✅ Complete — VPD live and verified |
| 5 | Application Process removed (not needed) | ✅ Complete — see note below |
| 6 | New admin pages | ✅ Complete — Pages 21/24, 22/25, 23, 28 |
| 7 | Permit creation + super user picker + Page 8 | ✅ Complete |
| 8 | Per-company permit numbering | ✅ Complete |
| 9 | End-to-end testing | ✅ Complete |

---

## STAGE 0 — Preparation

### Step 0.1 — DDL snapshot
Run `get_ptw_pro_ddl.sql` against PTW_PRO to capture the full schema
before any changes. Save the output as a "before" reference.

### Step 0.2 — Design decisions

| # | Decision |
|---|---|
| A | `ptw_types` stays global (super-user managed); `ptw_lv_company_types` junction table is the per-company, VPD-protected assignment |
| B | Super users can create permits via a company picker on Page 14, setting the session-wide `G_OVERRIDE_COMPANY_ID` application item |
| C | `ptw_stage_locations` FK uses `ON DELETE CASCADE` — consistent with sibling child tables |
| D | `ptw_lv_users` is NOT under VPD — three-layer protection instead (see Stage 7) |

---

## STAGE 1 — Schema additions

**File: `01_ddl_multitenancy.sql`**

Creates:
- `ptw_lv_companies` table (one row per tenant company)
- `company_id` + `is_super_user` columns on `ptw_lv_users`
- `company_id` column on `ptw_lv_permits` and its four child tables
- BEFORE INSERT triggers on child tables — copy `company_id` from parent permit
- `ptw_lv_company_types` junction table (per-company permit type licensing)

After running the script, insert the first company record:
```sql
INSERT INTO ptw_pro.ptw_lv_companies (company_name, company_code, is_active)
VALUES ('Your Company Name', 'SHORT_CODE', 'Y');

SELECT company_id FROM ptw_pro.ptw_lv_companies WHERE company_code = 'SHORT_CODE';
```
Note the generated `company_id` — needed for Stage 2.

---

## STAGE 2 — Backfill existing data

**File: `04_backfill.sql`**

- Assigns all existing users to the default company
- Assigns all existing permits and child records to the default company
- Seeds `ptw_lv_company_types` for the default company with all existing
  master permit types
- Designates the super user(s) (`is_super_user = 'Y'`, `company_id = NULL`)

After running, verify no NULLs remain:
```sql
SELECT COUNT(*) FROM ptw_pro.ptw_lv_permits WHERE company_id IS NULL;
SELECT COUNT(*) FROM ptw_pro.ptw_lv_users
WHERE  company_id IS NULL AND is_super_user = 'N';
```
Both must return 0 before continuing.

Then lock in the NOT NULL constraints:
```sql
ALTER TABLE ptw_pro.ptw_lv_permits MODIFY (company_id NOT NULL);
ALTER TABLE ptw_pro.ptw_lv_control_measures MODIFY (company_id NOT NULL);
ALTER TABLE ptw_pro.ptw_lv_equipment_isolation MODIFY (company_id NOT NULL);
ALTER TABLE ptw_pro.ptw_lv_monitoring MODIFY (company_id NOT NULL);
ALTER TABLE ptw_pro.ptw_lv_permit_photos MODIFY (company_id NOT NULL);
-- ptw_lv_users.company_id stays nullable (super users have none)
```

---

## STAGE 3 — Permit history table

**File: `06_stage_locations.sql`**

- Adds `company_id` to `ptw_stage_locations`
- Adds FK to `ptw_lv_permits` (ON DELETE CASCADE)
- Updates the three triggers that write to this table to also stamp `company_id`

---

## STAGE 4 — Security package + VPD policies

**File: `02_vpd_policy.sql`**

### What the package does

`ptw_pro.ptw_sec_pkg` contains three members:

**`set_session_context(p_username)`** — stub only, does nothing.
Retained for compatibility with rollback scripts. Was originally intended
to set DB session context (`DBMS_SESSION.SET_CONTEXT`) but this was
abandoned because ORDS connection pooling means DB session state is not
reliably shared between page requests.

**`company_policy(p_schema, p_object)`** — the VPD policy function, called
by Oracle on every query against a VPD-protected table. Logic:
- `V('APP_USER')` is NULL → return `'1=2'` (fail closed — no APEX session)
- User is a workspace Administrator → return `NULL` (no restriction)
- User is super user with no override → return `NULL` (see all companies)
- User is super user with `G_OVERRIDE_COMPANY_ID` set → return
  `'company_id = N'` (scoped to the override company)
- Normal user → return `'company_id = N'` (scoped to their company)
- User not found or any error → return `'1=2'` (fail closed)

**`check_user_in_company(p_username)`** — called by Page 8's DML processes
before any write operation to confirm the target user belongs to the caller's
company (or the caller is a super user / workspace admin). Raises
`ORA-20002: Access denied` if not. Respects `G_OVERRIDE_COMPANY_ID` for
super users.

### VPD policies applied

Policy name `PTW_COMPANY_POLICY`, function `ptw_sec_pkg.company_policy`,
`SELECT/INSERT/UPDATE/DELETE`, `update_check=TRUE` applied to:
- `ptw_lv_permits`
- `ptw_lv_control_measures`
- `ptw_lv_equipment_isolation`
- `ptw_lv_monitoring`
- `ptw_lv_permit_photos`
- `ptw_lv_company_types`
- `ptw_stage_locations`

NOT applied to: `ptw_lv_users` (page-level filter + DML guard instead),
`ptw_lv_companies` (super-user-only page, no isolation needed),
`ptw_types` (global master list, no isolation needed).

### Application item

`G_OVERRIDE_COMPANY_ID` — Application Item (Scope: Application) in
Shared Components. Used by super users to scope themselves to a specific
company. Set via Page 28 (Set Active Company) or Page 14 (Create PTW
company picker). Cleared by Page 1's "Return to Super User View" link or
Page 28's "View All Companies" button. Session-scoped — cleared automatically
when the user logs out.

---

## STAGE 5 — Application Process (not needed)

The original plan was an Application Process calling
`ptw_sec_pkg.set_session_context` on every page to set DB session context
for VPD. **This was not built** — the entire approach was superseded when
`company_policy` was rewritten to use `V('APP_USER')` directly (no DB
session context at all). No Application Process exists for this purpose.

Post-Authentication Procedure: a separate, unrelated Post-Authentication
Procedure was added to the Oracle APEX Accounts authentication scheme
(Stage 7) for super user data hygiene. See Stage 7.

---

## STAGE 6 — New admin pages

All pages follow the same modal dialog pattern:
- List page (Normal mode) with Interactive Report
- Add/Edit in a Modal Dialog (Chained: Yes, Resizable: Yes)
- After Save/Cancel, modal redirects to the list page (clear cache) —
  APEX dialog framework interprets this as "close and reload"

Authorization scheme **"Super User Rights"** (new, created in Stage 6):
PL/SQL Function Body returning Boolean — checks `ptw_lv_users.is_super_user='Y'`
and `is_active='Y'` for `:APP_USER`.

### Pages built

| Pages | Purpose | Auth | File |
|---|---|---|---|
| 21 + 24 | Companies list + Edit Company modal | Super User Rights | `ptw_lv_page21_companies.sql` |
| 22 + 25 | Master Permit Types list + Edit modal | Super User Rights | `ptw_lv_page22_master_permit_types.sql` |
| 23 | Company Permit Types (per-company assignment) | Administration Rights | `ptw_lv_page23_company_permit_types.sql` |
| 28 | Set Active Company (super user override) | Super User Rights | `ptw_lv_page28_set_active_company.sql` |

### Page 23 — Company Permit Types

Single-page design (no modals). Classic Report (not IR — needed for
`apex_item` form elements) showing all master permit types. Per row:
- `permit_count > 0` → static "Yes (in use — cannot remove)" — no form
  element rendered, structurally impossible to change
- `permit_count = 0` → `apex_item.select_list` Yes/No dropdown + hidden
  `type_id`

One Save process loops `g_f01`/`g_f02` arrays: INSERTs into
`ptw_lv_company_types` for new assignments, DELETEs for removals.
VPD scopes all queries to the current user's company automatically.
`company_id` for INSERT is derived via
`SYS_CONTEXT('APEX$SESSION','APP_USER') → ptw_lv_users` — not from DB
session context.

### Audit triggers

All new tables have BEFORE INSERT OR UPDATE audit triggers setting
`created_date`/`created_by`/`modified_date`/`modified_by` via
`SYSTIMESTAMP` and `SYS_CONTEXT('APEX$SESSION','APP_USER')`.

---

## STAGE 7 — Permit creation, super user picker, Page 8

### Page 14 — Super user company picker

New `P14_COMPANY_ID` Select List (Super User Rights server-side condition
— hidden for normal users). LOV: active companies from `ptw_lv_companies`.
Source: `V('G_OVERRIDE_COMPANY_ID')`, Used: "Only when current value is null"
(pre-fills from existing override, doesn't override a live selection).

Cascading LOV wiring on `P14_PTW_TYPES`:
- Parent Item: `P14_COMPANY_ID`
- Items to Submit: `P14_COMPANY_ID`
- LOV SQL filters `ptw_lv_company_types` for the selected company via
  `IN (SELECT ...)` — NOT via a CASE/TO_NUMBER expression (that approach
  failed with ORDS cascading LOV AJAX requests).

New process "Set Company Override" (When Button = CREATE): calls
`APEX_UTIL.SET_SESSION_STATE('G_OVERRIDE_COMPANY_ID', :P14_COMPANY_ID)`.

New validation "Company required for Super User": PL/SQL Expression,
blocks CREATE if super user hasn't selected a company.

**Spec file**: `ptw_lv_page14_stage7_company_picker.sql`

### Page 1 — "Viewing As" banner

New Dynamic Content region (sequence 11, Template: Blank). PL/SQL Function
Body returns NULL (renders nothing) for normal users and super users with no
override — so no server-side condition needed on the region itself. When
`G_OVERRIDE_COMPANY_ID` is set, renders a yellow `t-Alert--warning` style
banner showing "Viewing as [Company Name]" with a "Return to Super User View"
button (`apex.submit('CLEAR_OVERRIDE')`).

New process (Request = Value: `CLEAR_OVERRIDE`): clears
`G_OVERRIDE_COMPANY_ID` via `APEX_UTIL.SET_SESSION_STATE`.
New branch (Request = Value: `CLEAR_OVERRIDE`): redirects to Page 1,
clear cache 1.

**Spec file**: `ptw_lv_page01_stage7_return_to_super_user.sql`

### Permit insert trigger

`trg_ptw_lv_permits_company` — BEFORE INSERT on `ptw_lv_permits`. Uses
`V('APP_USER') → ptw_lv_users` to derive `company_id` for normal users, or
reads `G_OVERRIDE_COMPANY_ID` for super users. Raises errors if company
cannot be determined. **No DB session context used.**

### Page 8 — Three-layer company guard

**Layer 1 (8.1)** — IR filter: complex AND condition on the Current Users
Report SQL, using a PL/SQL Function Body Returning Boolean server-side
condition. Super user with no override sees all users; everyone else sees
only their effective company's users.

**Layer 2 (8.2)** — Page Load DA guard: `check_user_in_company` called at
the top of the "When page loads and reloads" dynamic action's server-side
code, before any user data is fetched. Blocks cross-company reads at the
UI level even if `P8_SELECTED_USERNAME` is set via a crafted URL.
Note: `P8_SELECTED_USERNAME` is NOT session-state-protected (that would
break the IR's edit links) — the DA guard is the correct protection.

**Layer 3 (8.3)** — DML guard: `check_user_in_company` called at the start
of every DML process (Update, Reset Password, Unlock, Deactivate Role,
Reactivate Role). Raises `ORA-20002` if the target user doesn't belong to
the caller's company. This is the hard guarantee — Layers 1/2 reduce
exposure, Layer 3 makes bypass impossible.

**Spec file**: `ptw_lv_page08_stage7_company_guard.sql`

### Page 28 — Set Active Company

New page (Super User Rights). Select List of active companies, sets
`G_OVERRIDE_COMPANY_ID` via `APEX_UTIL.SET_SESSION_STATE` on Save, clears
it on "View All Companies". Shows current override status via a Display Only
item (PL/SQL Function Body source). Navigation menu entry under Admin
(sequence 74).

**Spec file**: `ptw_lv_page28_set_active_company.sql`

### Post-Authentication Procedure

Added to Shared Components → Oracle APEX Accounts authentication scheme.
On every fresh login, clears `company_id` on the super user's own
`ptw_lv_users` row if it was accidentally set (data hygiene — a super user's
`company_id` should always be NULL; this catches any drift without user
intervention). Does not touch `G_OVERRIDE_COMPANY_ID` (session-scoped,
always starts empty on a new login naturally).

```sql
BEGIN
    UPDATE ptw_pro.ptw_lv_users
    SET    company_id = NULL
    WHERE  UPPER(username) = UPPER(:APP_USER)
    AND    is_super_user = 'Y'
    AND    company_id IS NOT NULL;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN NULL; -- never block login
END;
```

---

## STAGE 8 — Per-company permit numbering

**File: `ptw_permit_numbering.sql`** — 12 sequential steps (A through L).

Format: `{PREFIX}/{YYYY}/{NNNNN}` e.g. `MWM/2026/00001`
- Prefix: 1–4 uppercase characters, unique per company
- Sequence resets to 00001 on 1 January each year
- Uniqueness: `(permit_number, company_id)` — not global

Implementation:
- New columns on `ptw_lv_companies`: `permit_prefix VARCHAR2(4)`,
  `last_permit_seq NUMBER`, `last_permit_year VARCHAR2(4)`
- `trg_ptw_lv_permit_number` rewritten: uses `SELECT ... FOR UPDATE` on the
  company row for atomic sequence generation (no race condition)
- Existing permit numbers reformatted via MERGE (preserving creation order
  within each company+year group)
- Page 24 additions: `P24_PERMIT_PREFIX` (editable on create, Display Only
  on edit — consistent with `company_name`/`company_code` pattern)

---

## STAGE 9 — End-to-end testing (completed)

Two-company test verified:
- Normal user sees only their company's permits, types, and users
- Super user sees all data with no override set
- Super user scoped to one company via Page 28 sees only that company's data
  across the whole app (dashboard, permit types, user management, permit creation)
- "Return to Super User View" / "View All Companies" restores unrestricted view
- New permits get correct `company_id` stamped automatically by trigger
- Per-company permit numbering generates correct sequential numbers with
  yearly reset
- Page 8 three-layer guard blocks cross-company user data access

---

## Rollback

If rollback is ever needed, see `99_rollback.sql`. It is structured in
reverse stage order. Read the header comments before running — some steps
are only applicable depending on how far the implementation had progressed.
