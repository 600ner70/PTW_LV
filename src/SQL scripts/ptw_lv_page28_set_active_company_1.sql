-- =====================================================
-- PTW LV-ELECTRICAL - PAGE 28: SET ACTIVE COMPANY
-- + LOGIN-TIME COMPANY_ID CLEANUP
-- + PAGE 23 GUARD (no override set)
-- Oracle APEX 24.2 | App ID: 105
-- =====================================================
-- New, app-wide mechanism for a super user to set/clear
-- G_OVERRIDE_COMPANY_ID, replacing the ad-hoc "only settable
-- via Page 14's permit-creation flow" approach. Page 14's
-- picker keeps working unchanged (same underlying item).
-- =====================================================
-- DOES NOT replace or change:
--   - Page 1's "Viewing As (Super User)" banner / "Return to
--     Super User View" link (Stage 7 Part 2) - unchanged.
--   - Page 14's company picker (Stage 7 Part 1) - unchanged,
--     still pre-fills from G_OVERRIDE_COMPANY_ID if already
--     set via Page 28.
--   - trg_ptw_lv_permits_company - unchanged, still reads
--     G_OVERRIDE_COMPANY_ID the same way.
-- =====================================================


-- =====================================================
-- PART A - PAGE 28: SET ACTIVE COMPANY
-- =====================================================

-- =====================================================
-- PAGE SETUP
-- =====================================================
-- App Builder > Application 105 > Create Page
-- Type:         Blank Page
-- Page Number:  28
-- Page Name:    Set Active Company
-- Page Alias:   SET-ACTIVE-COMPANY
-- Page Mode:    Normal
-- Title:        Set Active Company
-- Warn on unsaved changes: Yes
-- Autocomplete: Off

-- =====================================================
-- PAGE PROPERTIES > Security
-- =====================================================
-- Authentication:         Page Requires Authentication
-- Authorization Scheme:   Super User Rights (existing - same
--                         scheme as Pages 21/22/24/25)
-- Page Access Protection: Arguments Must Have Checksum

-- =====================================================
-- REGION 1: Page Header
-- Sequence: 10
-- Type: Dynamic Content (PL/SQL function body returning CLOB)
-- =====================================================

DECLARE
    l_html CLOB;
BEGIN
    l_html := '<div class="admin-page-header">'
           || '  <h1><span class="fa fa-eye" style="margin-right:10px;"></span>Set Active Company</h1>'
           || '  <p>Choose a company to view and manage as. This applies across '
           || '     the whole application (dashboard, permit types, user '
           || '     maintenance, and creating permits) until you clear it or '
           || '     log out and back in.</p>'
           || '</div>';
    RETURN l_html;
END;

-- =====================================================
-- REGION 2: Active Company
-- Sequence: 20
-- Type: Static Content (Form region)
-- Title: Active Company
-- Icon: fa-building
-- Template Options: t-Region--accent15 t-Region--scrollBody
--                   t-Region--showIcon
-- =====================================================

-- Item: P28_COMPANY_ID
-- Type: Select List
-- Label: Active Company
-- Sequence: 10
-- Width: 6 columns
-- Template: Optional - Floating
-- List of Values: SQL Query

SELECT company_name d,
       company_id   r
FROM   ptw_pro.ptw_lv_companies
WHERE  is_active = 'Y'
ORDER  BY company_name

-- Display Null Value: Yes, Null Display Value:
--   "- View All Companies (no restriction) -"
-- Source > Type: PL/SQL Expression
--   V('G_OVERRIDE_COMPANY_ID')
-- Source > Used: Always, replacing any existing value in
--   session state
-- (Unlike P14_COMPANY_ID, "Always" is CORRECT and desired
-- here - this page's whole purpose is to faithfully reflect
-- the current override every time it's visited, with no
-- competing in-page interaction to protect against. Compare/
-- contrast with P14_COMPANY_ID's "Only when null" setting,
-- which was needed there because that item has its own
-- independent live user interaction within the same page.)
--
-- Item: P28_CURRENT_STATUS
-- Type: Display Only
-- Label: Currently
-- Sequence: 5 (before P28_COMPANY_ID)
-- Width: 12 columns
-- Source (PL/SQL Expression, On Load):

CASE
    WHEN V('G_OVERRIDE_COMPANY_ID') IS NULL OR V('G_OVERRIDE_COMPANY_ID') = ''
    THEN 'Viewing ALL companies (no restriction).'
    ELSE 'Viewing as: ' || (
        SELECT company_name FROM ptw_pro.ptw_lv_companies
        WHERE  company_id = TO_NUMBER(V('G_OVERRIDE_COMPANY_ID'))
    )
END

-- =====================================================
-- REGION 3: Buttons
-- Sequence: 30
-- Type: Buttons Container
-- =====================================================

-- Button 1: SET
-- Label:         Set Active Company
-- Position:      Next (right), Hot: Yes
-- Action:        Submit Page
-- Static ID:     BTN_SET_P28

-- Button 2: CLEAR
-- Label:         View All Companies
-- Position:      Previous (left)
-- Action:        Submit Page
-- Static ID:     BTN_CLEAR_P28

-- =====================================================
-- PROCESSES
-- =====================================================

-- Process 1: Apply Active Company
-- Sequence: 10
-- Point: Processing
-- Type: Execute Code (PL/SQL)
-- When Button Pressed: SET
-- Success Message: Active company updated.

BEGIN
    APEX_UTIL.SET_SESSION_STATE('G_OVERRIDE_COMPANY_ID', :P28_COMPANY_ID);
END;

-- NOTE: If the super user left the Select List on
-- "- View All Companies (no restriction) -" (NULL) and
-- clicked SET, this correctly clears the override too - SET
-- and CLEAR end up doing the same thing in that specific
-- case, which is fine and not worth special-casing.

-- Process 2: Clear Active Company
-- Sequence: 10
-- Point: Processing
-- Type: Execute Code (PL/SQL)
-- When Button Pressed: CLEAR
-- Success Message: Now viewing all companies.

BEGIN
    APEX_UTIL.SET_SESSION_STATE('G_OVERRIDE_COMPANY_ID', NULL);
END;

-- =====================================================
-- BRANCH (After Processing)
-- =====================================================

-- Branch: Reload Page 28
-- Sequence: 10
-- Point: After Processing
-- Behavior: Page or URL (Redirect)
-- Target: Page 28, Clear Cache 28
-- NOTE: Reloads so P28_CURRENT_STATUS and the Select List
-- both reflect the new state immediately.


-- =====================================================
-- NAVIGATION MENU ENTRY
-- Shared Components > Navigation Menu
-- =====================================================
-- Label:           Set Active Company
-- Icon:            fa-eye
-- Parent Entry:    Admin
-- Sequence:        74 (between User Maintenance (70)/Permit
--                  Types (72) and Companies (75)/Master
--                  Permit Types (76) - adjust if you'd prefer
--                  it elsewhere in the list)
-- Target:          Page 28, Clear Cache 28
-- Authorization Scheme: Super User Rights


-- =====================================================
-- PART B - LOGIN-TIME COMPANY_ID CLEANUP
-- =====================================================
-- Shared Components > Authentication Schemes >
-- "Oracle APEX Accounts" > Edit
-- =====================================================
-- Section: Login Processing > Post-Authentication Procedure
-- (currently EMPTY - this is a new addition, not a change to
-- an existing value. Stage 5's original PTW_SEC_CTX-based
-- Post-Authentication process was already removed earlier -
-- see 99_rollback.sql Stage 5 - this is unrelated and safe to
-- add fresh.)
-- =====================================================

BEGIN
    UPDATE ptw_pro.ptw_lv_users
    SET    company_id = NULL
    WHERE  UPPER(username) = UPPER(:APP_USER)
    AND    is_super_user = 'Y'
    AND    company_id IS NOT NULL;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Never block login over this cleanup - log and
        -- continue. (No dedicated log table exists yet; if
        -- one is added later for app-wide error logging,
        -- write to it here instead of silently swallowing.)
        NULL;
END;

-- NOTE: This fixes ptw_lv_users.company_id (a PERMANENT
-- record on the user's row) - completely separate from
-- G_OVERRIDE_COMPANY_ID (a SESSION-scoped item, set via Page
-- 28/14, cleared via Page 28/Page 1's "Return to Super User
-- View" link). company_policy's super-user branch never
-- reads ptw_lv_users.company_id at all, so this isn't fixing
-- a live bug in company_policy itself - it's defensive data
-- hygiene, guarding against any OTHER code that might
-- (incorrectly) assume a super user's company_id is always
-- NULL, and against confusing data if anyone inspects
-- ptw_lv_users directly.
--
-- Runs ONCE per fresh login (Post-Authentication fires after
-- successful authentication, before the first page loads) -
-- not on every page request.


-- =====================================================
-- PART C - PAGE 23 GUARD
-- =====================================================
-- Page 23 (Permit Types) > Region 2 ("Permit Types") >
-- Server-side Condition
-- =====================================================
-- Add this Server-side Condition to the EXISTING Region 2 -
-- Type: PL/SQL Expression:

NOT EXISTS (
    SELECT 1 FROM ptw_pro.ptw_lv_users
    WHERE  UPPER(username) = UPPER(:APP_USER)
    AND    is_super_user = 'Y'
    AND    is_active = 'Y'
)
OR (V('G_OVERRIDE_COMPANY_ID') IS NOT NULL AND V('G_OVERRIDE_COMPANY_ID') != '')

-- This means: show the report for everyone EXCEPT a super
-- user with no override set. Normal users always pass the
-- first clause (NOT EXISTS is true for them) - unaffected.


-- NEW REGION: Select a Company First
-- Sequence: 15 (same position as Region 2 - only one of the
--           two will ever be visible, since their conditions
--           are exact opposites)
-- Type: Static Content
-- =====================================================
-- Server-side Condition: PL/SQL Expression (the EXACT inverse
-- of Region 2's condition above):

EXISTS (
    SELECT 1 FROM ptw_pro.ptw_lv_users
    WHERE  UPPER(username) = UPPER(:APP_USER)
    AND    is_super_user = 'Y'
    AND    is_active = 'Y'
)
AND (V('G_OVERRIDE_COMPANY_ID') IS NULL OR V('G_OVERRIDE_COMPANY_ID') = '')

-- HTML region content:

<div class="admin-page-header" style="background:#fff8e1;border:1px solid #ffe082;">
    <p>You're not currently viewing as a specific company.
       Permit Types are managed per-company, so please
       <a href="#SET_ACTIVE_COMPANY_LINK#">set an active
       company</a> first.</p>
</div>

-- Where #SET_ACTIVE_COMPANY_LINK# is a substitution string
-- item, or simply hardcode the link using APEX_PAGE.GET_URL
-- in a PL/SQL Dynamic Content region instead of plain Static
-- Content if you'd rather build the URL with a proper
-- checksum:

DECLARE
    l_url VARCHAR2(500);
BEGIN
    l_url := APEX_PAGE.GET_URL(p_page => 28, p_clear_cache => '28');
    RETURN '<div class="admin-page-header" '
        || '     style="background:#fff8e1;border:1px solid #ffe082;">'
        || '  <p>You''re not currently viewing as a specific '
        || '     company. Permit Types are managed per-company, '
        || '     so please <a href="' || l_url || '">set an active '
        || '     company</a> first.</p>'
        || '</div>';
END;

-- (Use this PL/SQL version as the region's Dynamic Content
-- source instead of plain Static Content + substitution
-- string - simpler and avoids needing a separate link item.)


-- =====================================================
-- VERIFICATION TESTS
-- =====================================================
-- 1. Log in as super user, no prior override - "Set Active
--    Company" appears under Admin menu. Page 28 shows
--    "Viewing ALL companies (no restriction)." and the Select
--    List defaulted to "- View All Companies -".
-- 2. Select "Test Company 2", click "Set Active Company" -
--    page reloads, status now shows "Viewing as: Test Company
--    2", success message shown.
-- 3. Navigate to Page 23 (Permit Types) - now shows the
--    report (Region 2 visible, since override is set),
--    correctly scoped to Test Company 2.
-- 4. Navigate to Page 1 - "Viewing As (Super User)" banner
--    shows "Test Company 2" with "Return to Super User View"
--    link (Stage 7 Part 2, unchanged) - confirms Page 28 and
--    the existing banner read/write the same item correctly.
-- 5. Navigate to Page 14 - company picker pre-fills "Test
--    Company 2" (Source: Used "Only when null" - correctly
--    picks up what Page 28 set).
-- 6. Back on Page 28, click "View All Companies" (CLEAR) -
--    status reverts to "Viewing ALL companies", success
--    message "Now viewing all companies."
-- 7. Navigate to Page 23 - now shows "You're not currently
--    viewing as a specific company..." message with a working
--    link back to Page 28 (Region 2 hidden, new region
--    visible - confirms the two server-side conditions are
--    correctly mutually exclusive).
-- 8. Log out, log back in as the SAME super user - confirm
--    G_OVERRIDE_COMPANY_ID is empty on first page load
--    (expected - it's session-scoped, a new session always
--    starts clear regardless of the login cleanup).
-- 9. Login-time cleanup test: as PTW_PRO (or directly via SQL
--    Developer), manually set a super user's
--    ptw_lv_users.company_id to some non-null value (e.g. 1).
--    Log out and back in as that super user - confirm
--    company_id is back to NULL immediately after login
--    (query ptw_lv_users directly to verify, since this
--    doesn't surface anywhere in the UI).
-- 10. Confirm a NORMAL (non-super) user is completely
--     unaffected throughout: no "Set Active Company" menu
--     entry, Page 23 always shows their own company's report
--     (Region 2's first OR-clause always true for them), and
--     the Post-Authentication cleanup's WHERE clause never
--     matches them (is_super_user = 'Y' filter).
