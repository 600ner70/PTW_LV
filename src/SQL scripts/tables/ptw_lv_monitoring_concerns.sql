CREATE TABLE ptw_pro.ptw_lv_monitoring_concerns (
    concern_id              NUMBER
        DEFAULT ptw_pro.ptw_lv_monitoring_concern_seq.NEXTVAL
        PRIMARY KEY,
    monitoring_id           NUMBER NOT NULL,
    check_number            NUMBER(1) NOT NULL,

    concern_description     VARCHAR2(1000),
    actions_taken           VARCHAR2(1000),
    happy_to_continue       VARCHAR2(1),        -- Y/N, NULL while still a draft

    -- Sign-off block, same convention as every other stage
    concern_person_name     VARCHAR2(200),
    concern_signature       BLOB,
    concern_datetime        DATE,
    concern_latitude        NUMBER,
    concern_longitude       NUMBER,

    company_id              NUMBER NOT NULL,   -- auto-copied by trigger below

    created_date             TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by                VARCHAR2(100),
    modified_date             TIMESTAMP,
    modified_by                VARCHAR2(100),

    CONSTRAINT ck_ptw_lv_mc_check_number
        CHECK (check_number IN (1,2,3)),
    CONSTRAINT ck_ptw_lv_mc_happy
        CHECK (happy_to_continue IN ('Y','N')),
    CONSTRAINT uq_ptw_lv_mc_monitoring_check
        UNIQUE (monitoring_id, check_number),
    CONSTRAINT fk_ptw_lv_mc_monitoring
        FOREIGN KEY (monitoring_id)
        REFERENCES ptw_pro.ptw_lv_monitoring(monitoring_id)
        ON DELETE CASCADE
);

CREATE INDEX ptw_pro.idx_ptw_lv_mc_monitoring
    ON ptw_pro.ptw_lv_monitoring_concerns (monitoring_id);

