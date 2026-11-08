-- =====================================================================
-- V5: Immutability & Balance Triggers
-- Enforces rules that cannot be expressed as simple CHECK constraints.
-- =====================================================================

-- ---------------------------------------------------------------------
-- Rule 1: A POSTED journal entry cannot be UPDATEd.
-- Only certain "safe" fields (like reversal_of_id linking) may change,
-- but for simplicity and audit safety, we block everything.
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION prevent_update_of_posted_entry()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.status = 'POSTED' THEN
        RAISE EXCEPTION 'Cannot modify a POSTED journal entry (id=%). Post a reversal instead.', OLD.id
            USING ERRCODE = 'restrict_violation';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_je_prevent_update_posted
BEFORE UPDATE ON journal_entries
FOR EACH ROW
EXECUTE FUNCTION prevent_update_of_posted_entry();

-- ---------------------------------------------------------------------
-- Rule 2: A POSTED journal entry cannot be DELETEd.
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION prevent_delete_of_posted_entry()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.status = 'POSTED' THEN
        RAISE EXCEPTION 'Cannot delete a POSTED journal entry (id=%). Post a reversal instead.', OLD.id
            USING ERRCODE = 'restrict_violation';
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_je_prevent_delete_posted
BEFORE DELETE ON journal_entries
FOR EACH ROW
EXECUTE FUNCTION prevent_delete_of_posted_entry();

-- ---------------------------------------------------------------------
-- Rule 3: Journal lines cannot be inserted/updated/deleted after
-- the parent entry has been POSTED. All line changes must happen in DRAFT.
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION prevent_line_changes_when_posted()
RETURNS TRIGGER AS $$
DECLARE
    entry_status VARCHAR(16);
    entry_id     BIGINT;
BEGIN
    IF TG_OP = 'DELETE' THEN
        entry_id := OLD.journal_entry_id;
    ELSE
        entry_id := NEW.journal_entry_id;
    END IF;

    SELECT status INTO entry_status FROM journal_entries WHERE id = entry_id;
    IF entry_status = 'POSTED' THEN
        RAISE EXCEPTION 'Cannot modify journal lines of a POSTED entry (id=%).', entry_id
            USING ERRCODE = 'restrict_violation';
    END IF;

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_jl_prevent_changes_when_posted
BEFORE INSERT OR UPDATE OR DELETE ON journal_lines
FOR EACH ROW
EXECUTE FUNCTION prevent_line_changes_when_posted();

-- ---------------------------------------------------------------------
-- Rule 4: On POSTING (status DRAFT -> POSTED), enforce sum(debit) = sum(credit).
-- This is the fundamental double-entry invariant.
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION check_entry_balanced_on_posting()
RETURNS TRIGGER AS $$
DECLARE
    total_debit  NUMERIC(20, 4);
    total_credit NUMERIC(20, 4);
    line_count   INT;
BEGIN
    -- Only check when transitioning to POSTED.
    IF NEW.status = 'POSTED' AND OLD.status = 'DRAFT' THEN
        SELECT
            COALESCE(SUM(debit_amount), 0),
            COALESCE(SUM(credit_amount), 0),
            COUNT(*)
        INTO total_debit, total_credit, line_count
        FROM journal_lines
        WHERE journal_entry_id = NEW.id;

        IF line_count < 2 THEN
            RAISE EXCEPTION 'A journal entry must have at least 2 lines (entry id=%).', NEW.id
                USING ERRCODE = 'check_violation';
        END IF;

        IF total_debit <> total_credit THEN
            RAISE EXCEPTION 'Journal entry is not balanced (id=%): debits=% credits=%',
                NEW.id, total_debit, total_credit
                USING ERRCODE = 'check_violation';
        END IF;

        IF total_debit = 0 THEN
            RAISE EXCEPTION 'Journal entry has zero amount (id=%).', NEW.id
                USING ERRCODE = 'check_violation';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_je_check_balanced_on_posting
BEFORE UPDATE ON journal_entries
FOR EACH ROW
EXECUTE FUNCTION check_entry_balanced_on_posting();
