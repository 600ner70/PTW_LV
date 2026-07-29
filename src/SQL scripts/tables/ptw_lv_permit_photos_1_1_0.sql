ALTER TABLE ptw_pro.ptw_lv_permit_photos
    ADD (concern_id NUMBER);

ALTER TABLE ptw_pro.ptw_lv_permit_photos
    ADD CONSTRAINT fk_ptw_lv_photos_concern
    FOREIGN KEY (concern_id)
    REFERENCES ptw_pro.ptw_lv_monitoring_concerns(concern_id)
    ON DELETE CASCADE;

CREATE INDEX ptw_pro.idx_ptw_lv_photos_concern
    ON ptw_pro.ptw_lv_permit_photos (concern_id);
    