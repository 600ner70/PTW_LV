CREATE TABLE ptw_pro.ptw_lv_sites (
    site_id        NUMBER GENERATED ALWAYS AS IDENTITY
                   MINVALUE 1 START WITH 1 CACHE 20 NOT NULL ENABLE,
    company_id     NUMBER NOT NULL ENABLE,
    site_name      VARCHAR2(200) NOT NULL ENABLE,
    is_active      VARCHAR2(1) DEFAULT 'Y' NOT NULL ENABLE,
    created_date   TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    created_by     VARCHAR2(100),
    modified_date  TIMESTAMP(6),
    modified_by    VARCHAR2(100),
    CONSTRAINT pk_ptw_lv_sites PRIMARY KEY (site_id) USING INDEX ENABLE,
    CONSTRAINT uq_ptw_lv_sites UNIQUE (company_id, site_name) USING INDEX ENABLE,
    CONSTRAINT chk_ptw_lv_sites_active CHECK (is_active IN ('Y','N')) ENABLE,
    CONSTRAINT fk_ptw_lv_sites_company FOREIGN KEY (company_id)
        REFERENCES ptw_pro.ptw_lv_companies (company_id)
);

CREATE INDEX ptw_pro.idx_ptw_lv_sites_company ON ptw_pro.ptw_lv_sites (company_id);

ALTER TABLE ptw_pro.ptw_lv_permits ADD (
    site_id NUMBER,
    CONSTRAINT fk_ptw_lv_permits_site FOREIGN KEY (site_id)
        REFERENCES ptw_pro.ptw_lv_sites (site_id)
);
CREATE INDEX ptw_pro.idx_ptw_lv_permits_site ON ptw_pro.ptw_lv_permits (site_id);