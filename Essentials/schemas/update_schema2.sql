USE cheque_blacklist_db;
ALTER TABLE linked_individuals ADD COLUMN source_profile_id VARCHAR(50) NULL AFTER is_signatory;
