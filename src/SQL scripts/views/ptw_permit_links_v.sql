
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PTW_PRO"."PTW_PERMIT_LINKS_V" ("LINK_ID", "PERMIT_ID", "OTHER_PERMIT_ID", "LINK_NOTE", "COMPANY_ID", "CREATED_BY", "CREATED_DATE") AS
  SELECT link_id, permit_id, linked_permit_id AS other_permit_id, link_note, company_id, created_by, created_date
FROM   ptw_pro.ptw_permit_links
UNION ALL
SELECT link_id, linked_permit_id AS permit_id, permit_id AS other_permit_id, link_note, company_id, created_by, created_date
FROM   ptw_pro.ptw_permit_links;
