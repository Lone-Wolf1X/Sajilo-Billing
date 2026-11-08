-- =====================================================================
-- V7: Allow Status Transition from POSTED to REVERSED
-- Enables ReversalService to flag an original posted entry as REVERSED
-- while still strictly preventing any other modifications to POSTED entries.
-- =====================================================================

CREATE OR REPLACE FUNCTION prevent_update_of_posted_entry()
RETURNS TRIGGER AS $$
BEGIN
    -- Allow updating status to REVERSED (informational reversal marking)
    IF OLD.status = 'POSTED' THEN
        IF NEW.status = 'REVERSED' THEN
            -- Only allow status to change to REVERSED, no other columns may change
            IF NEW.id = OLD.id
               AND NEW.tenant_id = OLD.tenant_id
               AND NEW.entry_number = OLD.entry_number
               AND NEW.entry_date = OLD.entry_date
               AND NEW.period_id = OLD.period_id
               AND NEW.entry_type = OLD.entry_type
               AND NEW.posted_at = OLD.posted_at
               AND NEW.posted_by = OLD.posted_by THEN
                RETURN NEW;
            ELSE
                RAISE EXCEPTION 'Cannot modify financial data of a POSTED journal entry (id=%). Only status -> REVERSED is permitted.', OLD.id
                    USING ERRCODE = 'restrict_violation';
            END IF;
        ELSE
            RAISE EXCEPTION 'Cannot modify a POSTED journal entry (id=%). Post a reversal instead.', OLD.id
                USING ERRCODE = 'restrict_violation';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

