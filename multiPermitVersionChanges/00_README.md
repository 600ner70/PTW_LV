# PTW_LV Checklist Refactor — Full Suite

Everything produced across this session: the permit-type-driven checklist,
signature/monitoring normalization, the PDF library + per-type PDF
functions, and the Page 14/2/3/50 type-selection wiring. This file is the
index — start here.

## Contents

| File | What it is |
|---|---|
| `sql/05_new_tables_ddl.sql` | New tables: checklist metadata/responses, signatures, monitoring checks — sequences, FKs, indexes, VPD policies |
| `sql/06_seed_checklist_items.sql` | Seeds `PTW_TYPES` (`GENERAL`) + checklist questions for `LV ISOLATION` and `GENERAL` |
| `sql/07_migrate_existing_data.sql` | One-time backfill of existing permit data into the new tables (idempotent) |
| `sql/08_update_views.sql` | Updated `PTW_LV_ANALYTICS_V` and `PTW_LV_CANCELLATION_REASON_V` |
| `packages/ptw_pdf_lib_pkg.pks/pkb.sql` | Shared PDF library — formatting helpers + every section that's identical across permit types (site/work details, checklist, PPE, signature stages, monitoring, stage history) |
| `sql/09_update_generate_ptw_lv_pdf.sql` | `GENERATE_PTW_LV_PDF`, rebuilt on the library — now only ~130 lines, holds just what's LV-specific (Equipment Isolation, header ref, 5-year retention text) |
| `sql/11_generate_ptw_general_pdf.sql` | New `GENERATE_PTW_GENERAL_PDF` — same library, no isolation section, its own header/retention wording |
| `sql/12_generate_ptw_permit_pdf.sql` | Dispatcher — single entry point that looks up a permit's type and calls the right per-type function. Point Page 300 at this instead of `GENERATE_PTW_LV_PDF` directly |
| `packages/ptw_checklist_pkg.pks/pkb.sql` | JSON load/save for the permit-type-driven checklist (the one piece that's genuinely dynamic) |
| `packages/ptw_signature_pkg.pks/pkb.sql` | Save/load for AUTH/ACCEPT/CLEAR/CANCEL signatures — plain `MERGE`, no JSON |
| `packages/ptw_monitoring_pkg.pks/pkb.sql` | Save for monitoring checks — plain `MERGE`, no JSON |
| `js/ptw-checklist.js` | Reusable checklist renderer — same badge markup/CSS as today, driven by loaded metadata instead of a hardcoded item array |
| `PAGE_PROCESS_UPDATES.md` | Every Page Designer process that needs updating: Pages 1, 2, 4, 5, 10, 16, 17, 50 (column fixes/DML rewrites), Pages 14, 2, 3 (type-selection wiring). Pages 15 and 51 checked and confirmed clean. |

## Run order

1. `05_new_tables_ddl.sql`
2. `06_seed_checklist_items.sql` (check the Step 0 lookup query first — already
   confirmed as `'LV ISOLATION'` from your `PTW_TYPES` data)
3. `07_migrate_existing_data.sql`
4. `08_update_views.sql`
5. Compile the checklist/signature/monitoring packages (spec before body) —
   `09` needs `ptw_signature_pkg`
6. `packages/ptw_pdf_lib_pkg.pks.sql` (**spec only** for now)
7. `09_update_generate_ptw_lv_pdf.sql`
8. `11_generate_ptw_general_pdf.sql`
9. `packages/ptw_pdf_lib_pkg.pkb.sql` (**body**, now that 7 and 8 exist)
10. `12_generate_ptw_permit_pdf.sql`
11. Apply the Page Designer changes in `PAGE_PROCESS_UPDATES.md`, and point
    Page 300's PDF viewer at `generate_ptw_permit_pdf` instead of calling
    `generate_ptw_lv_pdf` directly

**Why the odd spec/body split at steps 6 and 9:** `09` and `11` call the
library's functions, so they need its *spec* to exist — but the library's
*body* calls `09`/`11` by name (so it knows which per-type function to run
for the dispatcher's sibling logic), so the body has to come after them.
This is a one-time ordering quirk of this file set, not something to
think about again once it's deployed.

## Builder steps for the new General/LV checklist UI (Page 3)

These can't be scripted — they're Page Designer changes:

1. **Upload `ptw-checklist.js`** to Shared Components → Static Application
   Files, and add `#APP_FILES#ptw-checklist#MIN#.js` to Page 0's File URLs,
   same as `ptw-utils.js` already is.

2. **On Page 3**, replace the 16 `P3_CM_*` items and 10 `P3_PPE_*` items with
   two empty **Static Content** regions with Static IDs, e.g.
   `cm-checklist-region` and `ppe-checklist-region`.

3. **One new Hidden item**: `P3_CHECKLIST_JSON` — carries the collected
   answers to the save process.

4. **Execute When Page Loads** (Page 3, Page Attributes):
   ```javascript
   PTW.checklist.load(
       $v('P3_PERMIT_ID'),
       { controlMeasures: 'cm-checklist-region', ppe: 'ppe-checklist-region' },
       apex.item('P3_WORKFLOW_STATUS').getValue() !== 'DRAFT'
   );
   ```

5. **AJAX Callback process** named `GET_CHECKLIST`:
   ```plsql
   BEGIN
       htp.prn('{"items":' || ptw_pro.ptw_checklist_pkg.get_checklist_json(apex_application.g_x01) || '}');
   END;
   ```

6. **Before the existing Save/Next Step DAs submit** (same pattern as the
   `captureLocationThenSubmit` geolocation DA already does), add:
   ```javascript
   apex.item('P3_CHECKLIST_JSON').setValue(JSON.stringify(PTW.checklist.collect()));
   ```

7. **Replace the old 16-column DML** in the Save process with:
   ```plsql
   ptw_pro.ptw_checklist_pkg.save_checklist_responses(:P3_PERMIT_ID, :P3_CHECKLIST_JSON);
   ```

Nothing here requires IG, Tabular Forms, or `APEX_ITEM` arrays — the
placeholder regions just host plain HTML the JS builds, same as the badge
rows already do today.

## Known open items

- **General permit's question set is a starting point, not confirmed** —
  the source PDF text was mostly the closure page. Check `06`'s `GENERAL`
  items against the real form. Same caveat applies to
  `generate_ptw_general_pdf`'s header refs and retention wording — the
  retention text is taken directly from the source PDF, but the rest is a
  reasonable-effort draft.
- Pages 16's "prefill clear-mobile from accept-mobile" was already dead code
  before this refactor (documented in `PAGE_PROCESS_UPDATES.md`) — preserved
  as-is, not fixed, since that's a separate decision.
- `CHK_PERMIT_ON_DISPLAY` / `CHK_ACCESS_EGRESS` / `CHK_WARNING_SIGNS` on
  `PTW_LV_MONITORING` were deliberately left as fixed columns — generic,
  not permit-type-variable, not part of this refactor's scope.

**Resolved this round** (see `PAGE_PROCESS_UPDATES.md`'s "Type selection"
section for the exact changes):

- Page 4 branching — Page 3's Next Step branch now checks the permit's
  actual type and routes LV Isolation permits through Page 4, everything
  else straight to Page 5.
- Permit type name display — Page 50 gets a `PTW_TYPE_DESC` column
  alongside the existing raw code (which the facet/filter still needs).
- Type selection end-to-end — Page 14's validation was silently hardcoded
  to reject every type except LV Isolation even though its dropdown was
  already properly entitlement-aware; and even past that, the selected
  value was never passed to Page 2 at all. Both fixed, plus a related
  latent bug: Page 2's UPDATE branch was unconditionally resetting
  `ptw_type` back to `'LV ISOLATION'` on every edit, which would have
  silently corrupted any non-LV permit's type on save.
- Page 15 checked — confirmed unrelated (monitoring for an existing
  permit, not permit creation).

