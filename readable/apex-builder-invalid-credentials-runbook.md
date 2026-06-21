# Runbook: APEX Builder "Invalid Credentials" / Account Locked

**Applies to:** Always Free / Autonomous Database-hosted APEX, local workspace admin accounts (not IAM/SSO).

## The core gotcha

APEX workspace login credentials live in **two independent stores**, and the Builder Sign In page can fail even when both *look* fine individually:

| Store | What it tracks | Where to check | Who controls it |
|---|---|---|---|
| Workspace repository (`WWV_FLOW_FND_USER`) | APEX's own user/password copy | INTERNAL workspace → Manage Users → user record. `Account Availability` field, `Developer/Administrator Password: Valid/Invalid` | APEX Builder UI |
| Database schema user (`dba_users`) | The real Oracle DB account, same username | SQL query (below) | `ALTER USER` in SQL |

**These do not always stay in sync.** A reset done only through the APEX UI (Sign-In page reset, or INTERNAL's password field) does not necessarily update the database password, and vice versa. If they drift apart, you'll see "Invalid Credentials" or "The account is locked" in Builder while INTERNAL's own screen insists everything is `Unlocked` and `Valid` — because INTERNAL is only checking its own copy.

## Diagnostic steps, in order

**1. Check the database-level lock and status** (this is the layer that actually gates Sign In for DB-backed accounts):
```sql
SELECT username, account_status, lock_date, profile, expiry_date
FROM dba_users
WHERE username = '<your_username>';
```
`LOCKED` or `LOCKED(TIMED)` here means a real DB lock, regardless of what INTERNAL's UI says.

**2. Check the workspace-level flag**, for comparison only — don't treat this as authoritative on its own:
```sql
SELECT workspace_id, workspace_name, user_name, account_locked
FROM apex_workspace_apex_users
WHERE user_name = '<your_username>';
```

**3. Rule out a workspace/schema mix-up** (only if 1 and 2 don't explain it):
```sql
SELECT workspace_id, workspace, schema, created
FROM apex_workspace_schemas
WHERE schema = '<your_schema>';
```
More than one workspace mapped to the same schema, or a workspace name reused under a different ID, is a separate failure mode worth ruling out before re-touching passwords.

## Fix

1. **Unlock the DB account if locked:**
   ```sql
   ALTER USER <username> ACCOUNT UNLOCK;
   ```
2. **Reset the password in both places, same sitting, every time:**
   - Database side: `ALTER USER <username> IDENTIFIED BY "NewPassword123";`
   - Workspace side: INTERNAL → Manage Users → user record → Password fields → Apply Changes
   - Don't assume one propagates to the other. Confirm by testing a raw DB connection (SQL Developer, new connection, not your existing session) with the new credentials before going back to Builder.
3. **Retry Sign In in a fresh incognito/private window** — rules out stale `ORA_WWV_REMEMBER_UN` / session cookies as a contributing factor.

## Things that will NOT tell you what you need

- `dba_audit_trail` — legacy view, doesn't capture unified audit policy events. Don't bother checking it.
- `unified_audit_trail` filtered on the workspace username — Builder authentication is largely an APEX application-layer check (`WWV_FLOW_FND_USER` validation), not a direct OS-level DB connection as that username. Failed Builder logins often leave no trace here even when `ORA_LOGON_FAILURES` is enabled and capturing failures generally.
- Repeated login retries while diagnosing — each attempt counts against `FAILED_LOGIN_ATTEMPTS` on the DB profile (default 10) and can trigger a fresh timed lock mid-investigation, destroying whatever state you were trying to observe. **Check status via SQL before retrying logins, not after.**

## To prevent recurrence

- Whenever resetting this account's password, change **both** stores together (see Fix step 2). Make this a habit, not a one-off fix.
- Check the profile's lockout tolerance if typos during testing are a recurring risk:
  ```sql
  SELECT profile, resource_name, limit
  FROM dba_profiles
  WHERE profile = (SELECT profile FROM dba_users WHERE username = '<username>')
  AND resource_name IN ('FAILED_LOGIN_ATTEMPTS','PASSWORD_LOCK_TIME','PASSWORD_LIFE_TIME');
  ```
  Loosening `FAILED_LOGIN_ATTEMPTS` or setting `PASSWORD_LOCK_TIME UNLIMITED` trades off brute-force protection against this kind of lockout — only worth it if Builder access is already IP-restricted at the network layer (load balancer / NSG), not exposed on the open internet.
- If Builder (`/ords/apex`) isn't already IP-restricted, that's a separate, larger gap than this incident — worth fixing independently.
