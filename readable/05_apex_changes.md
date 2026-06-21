# PTW LV — Multi-Tenant APEX Changes

**STATUS: All changes implemented and live.**

This document records what was built in APEX as part of the multi-tenant
rollout. It reflects the final implemented state only — earlier approaches
that were explored and not used are not documented here.

---

## 1. Application Process — NOT BUILT

The original plan included an Application Process calling
`ptw_sec_pkg.set_session_context` on every page to set DB session context.
**This was not implemented.** The VPD policy function (`company_policy`)
was rewritten to use `V('APP_USER')` for a direct lookup on every call —
no DB session context, no Application Process needed.

If you see any Application Process named "Set Security Context" in Shared
Components, it is a leftover from earlier testing and should be removed.

---

## 2. Application Item

`G_OVERRIDE_COMPANY_ID` — created in Shared Components → Application Items.
- Scope: Application
- No default value
- Used by super users to scope themselves to a specific company app-wide
- Set via Page 28 (Set Active Company) or Page 14 (Create PTW company picker)
- Cleared via Page 1's "Return to Super User View" or Page 28's "View All"
- Session-scoped naturally — empty on every fresh login

---

## 3. Authorization Scheme — Super User Rights

Created in Shared Components → Authorization Schemes.
- Name: Super User Rights
- Type: PL/SQL Function Body Returning Boolean
- Used by: Pages 21, 22, 24, 25, 28 and their navigation menu entries

```sql
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO   v_count
    FROM   ptw_pro.ptw_lv_users
    WHERE  UPPER(username) = UPPER(:APP_USER)
    AND    is_super_user   = 'Y'
    AND    is_active       = 'Y';
    RETURN v_count > 0;
EXCEPTION
    WHEN OTHERS THEN RETURN FALSE;
END;
```

Note: `APEX_UTIL.IS_ADMIN` and `APEX_UTIL.CURRENT_USER_IS_ADMIN` do not
exist in APEX 24. The correct function is
`APEX_UTIL.CURRENT_USER_IN_GROUP('Administrators')` — used in
`ptw_sec_pkg.check_user_in_company` for workspace admin bypass.

---

## 4. New Pages

All new pages follow the standard app pattern:
- Theme 42 Universal Theme, Redwood Light style
- Region template: Standard with `t-Region--accent15 t-Region--scrollBody
  t-Region--showIcon`
- Form labels: Optional - Floating
- Y/N fields: Radio Group, `STATIC:Yes;Y,No;N`, CSS class `cm-binary-item`,
  inline JS badge pattern (per-page `binarybadge{NN}` namespace)
- Modals: Chained Yes, Resizable Yes, after Save/Cancel redirect to parent
  page (clear cache) — APEX closes the dialog automatically

### Pages 21 + 24 — Companies + Edit Company

- Page 21: Normal page, Interactive Report on `ptw_lv_companies`
- Page 24: Modal Dialog — Add/Edit Company
- Auth: Super User Rights (both pages)
- Fields: Company Name (locked after create), Company Code (locked after
  create), Permit Prefix (locked after create), Active (always editable)
- Save logic: UPDATE only ever changes `is_active` (all other fields locked);
  INSERT sets all fields
- No Delete — `is_active = 'N'` is the only deactivation mechanism
- Audit trigger: `trg_ptw_lv_companies_audit` (BEFORE INSERT OR UPDATE,
  stamps `SYSTIMESTAMP` + `SYS_CONTEXT('APEX$SESSION','APP_USER')`)
- **Spec file**: `ptw_lv_page21_companies.sql`

### Pages 22 + 25 — Master Permit Types + Edit Permit Type

- Page 22: Normal page, Interactive Report on `ptw_types`
- Page 25: Modal Dialog — Add/Edit Permit Type
- Auth: Super User Rights (both pages)
- Fields: Type Code (locked after create), Description (locked after create),
  Available (always editable)
- Save logic: UPDATE only ever changes `available`; INSERT sets all fields
- No Delete
- Audit trigger: `trg_ptw_types_audit` (BEFORE INSERT only — `ptw_types`
  has no `modified_date`/`modified_by` columns)
- **Spec file**: `ptw_lv_page22_master_permit_types.sql`

### Page 23 — Company Permit Types

- Single page, no modals
- Auth: Administration Rights (company ADMINs, not super users)
- Classic Report (not IR — needed for `apex_item` form elements)
- Shows all master permit types. Per row:
  - `permit_count > 0`: static text "Yes (in use — cannot remove)"
  - `permit_count = 0`: `apex_item.select_list(1, ...)` Yes/No + hidden
    `apex_item.hidden(2, type_id)`
- One Save button, one process looping `g_f01`/`g_f02` arrays
- INSERT into `ptw_lv_company_types` for Yes; DELETE for No
- VPD scopes all queries to the current user's company automatically
- Guard: server-side condition (PL/SQL Function Body Returning Boolean) on
  the report region — shows "Select a Company First" message using
  `t-Alert--warning` classes if super user has no override set
- Audit trigger: `trg_ptw_lv_company_types_audit` (BEFORE INSERT)
- **Spec file**: `ptw_lv_page23_company_permit_types.sql`

### Page 28 — Set Active Company

- Normal page, Auth: Super User Rights
- Select List of active companies, sources/displays current
  `G_OVERRIDE_COMPANY_ID`
- Display Only item shows current override status (PL/SQL Function Body)
- Buttons: "Set Active Company" (sets override), "View All Companies"
  (clears override)
- Processes: both use `APEX_UTIL.SET_SESSION_STATE('G_OVERRIDE_COMPANY_ID')`
- Navigation: Admin menu, sequence 74, Super User Rights
- **Spec file**: `ptw_lv_page28_set_active_company.sql`

---

## 5. Page 14 — Create PTW (addendum)

**Spec file**: `ptw_lv_page14_stage7_company_picker.sql`

### New item: P14_COMPANY_ID

- Type: Select List, LOV: active companies from `ptw_lv_companies`
- Server-side Condition: Super User Rights (hidden for normal users)
- Source: `V('G_OVERRIDE_COMPANY_ID')`, Used: "Only when current value
  in session state is null"

### P14_PTW_TYPES LOV (updated)

Rewritten to join `ptw_types` to `ptw_lv_company_types`, showing only
types assigned to the effective company. Uses `IN (SELECT ...)` pattern
(not `CASE`/`TO_NUMBER` — that approach failed with ORDS cascading LOV
AJAX requests).

Cascading LOV settings on `P14_PTW_TYPES`:
- Parent Item: `P14_COMPANY_ID`
- Items to Submit: `P14_COMPANY_ID`

### New process: Set Company Override

- Point: Processing, When Button = CREATE
- `APEX_UTIL.SET_SESSION_STATE('G_OVERRIDE_COMPANY_ID', :P14_COMPANY_ID)`
- Only runs for super users (EXISTS check in PL/SQL)

### New validation: Company required for Super User

- PL/SQL Function Body Returning Boolean
- Blocks CREATE if super user has not selected a company

---

## 6. Page 1 — Dashboard (addendum)

**Spec file**: `ptw_lv_page01_stage7_return_to_super_user.sql`

### New region: Viewing As (Super User)

- Sequence 11, Type: Dynamic Content, Template: Blank
- No server-side condition — PL/SQL returns NULL (renders nothing) when
  not applicable
- When `G_OVERRIDE_COMPANY_ID` is set for a super user, renders a
  `t-Alert--warning` style banner: "Viewing as [Company Name]" with a
  "Return to Super User View" button
- Button uses `apex.submit('CLEAR_OVERRIDE')` — no APEX Button component
  needed

### New process: Clear Company Override

- Point: Processing
- Server-side Condition: Request = Value → `CLEAR_OVERRIDE`
- `APEX_UTIL.SET_SESSION_STATE('G_OVERRIDE_COMPANY_ID', NULL)`

### New branch: Reload Dashboard

- Point: After Processing
- Server-side Condition: Request = Value → `CLEAR_OVERRIDE`
- Redirects to Page 1, clear cache 1

---

## 7. Page 8 — User Management (addendum)

**Spec file**: `ptw_lv_page08_stage7_company_guard.sql`

### Layer 1 (8.1) — IR company filter

Complex AND condition added to Current Users Report SQL. Uses PL/SQL
Function Body Returning Boolean server-side condition. Logic:
- Super user + no override → see all users
- Everyone else (normal user or super user with override) → see only the
  effective company's users

### Layer 2 (8.2) — Page Load DA guard

`check_user_in_company` added at the top of the "When page loads and
reloads" DA's server-side code, before any user data is fetched. Prevents
cross-company data display even via a crafted URL.

Note: `P8_SELECTED_USERNAME` is NOT session-state-protected (Restricted
setting would break the IR's edit links — confirmed by testing). The DA
guard is the correct protection layer for read-access.

### Layer 3 (8.3) — DML guard

`ptw_pro.ptw_sec_pkg.check_user_in_company(p_username)` called at the
start of every DML process:
- Update Existing APEX User
- Reset User Password (uses the free-typed `P8_RESET_USERNAME`)
- Unlock User Account
- Deactivate User Role
- Reactivate User Role

Raises `ORA-20002: Access denied` if the target user doesn't belong to
the caller's effective company. This is the hard guarantee that cannot
be bypassed regardless of UI state.

---

## 8. Authentication Scheme — Post-Authentication Procedure

Added to Shared Components → Oracle APEX Accounts.

Runs once per fresh login. Clears `company_id` on the super user's own
`ptw_lv_users` row if accidentally set. Guards against the scenario where
a super user changes active company (via Page 28), does some work, and
closes the browser without resetting — ensuring a clean state on next login.

```sql
BEGIN
    UPDATE ptw_pro.ptw_lv_users
    SET    company_id = NULL
    WHERE  UPPER(username) = UPPER(:APP_USER)
    AND    is_super_user = 'Y'
    AND    company_id IS NOT NULL;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
```

---

## 9. Page 24 — Edit Company (addendum for permit numbering)

**Spec file**: `ptw_permit_numbering.sql` (Steps J–L)

New items added for `permit_prefix`:
- `P24_PERMIT_PREFIX` — Text Field, max 4 chars, shown in CREATE mode only
  (server-side condition: `P24_COMPANY_ID IS NULL`)
- `P24_PERMIT_PREFIX_DISPLAY` — Display Only, shown in EDIT mode only
  (`P24_COMPANY_ID IS NOT NULL`), matches `P24_CREATED_DATE` styling

Dynamic Action: auto-uppercases `P24_PERMIT_PREFIX` on Key Release.

Two new validations: prefix required + prefix unique across companies.

Fetch process updated to populate `P24_PERMIT_PREFIX_DISPLAY`.
Save process INSERT branch updated to include `permit_prefix`.
UPDATE branch unchanged — prefix never editable after creation.
