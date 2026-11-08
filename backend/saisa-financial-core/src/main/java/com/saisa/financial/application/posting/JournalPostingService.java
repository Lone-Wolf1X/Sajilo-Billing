package com.saisa.financial.application.posting;

import com.saisa.financial.domain.exception.InvalidJournalEntryException;
import com.saisa.financial.domain.journal.EntryStatus;
import com.saisa.financial.domain.journal.JournalEntry;
import com.saisa.financial.domain.period.AccountingPeriod;
import com.saisa.financial.infrastructure.persistence.AccountingPeriodRepository;
import com.saisa.financial.infrastructure.persistence.JournalEntryRepository;
import java.time.Instant;
import java.util.Optional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

/**
 * Orchestrates the lifecycle of a journal entry: DRAFT -> POSTED.
 *
 * RESPONSIBILITIES:
 *   1. Enforce idempotency (same idempotency_key returns same result)
 *   2. Validate period state (period must be OPEN)
 *   3. Persist entry with lines atomically
 *   4. Transition to POSTED via a single atomic UPDATE that triggers DB validation
 *   5. Assign human-readable entry number atomically
 *
 * TRANSACTION ISOLATION:
 *   We use SERIALIZABLE for the posting transaction. This is deliberate:
 *   - It prevents phantom reads (e.g., two entries seeing "period open" simultaneously)
 *   - It prevents write skew (two postings racing to consume the same sequence)
 *   - The cost is retry-on-conflict, which is acceptable for financial postings
 *
 * IDEMPOTENCY:
 *   The caller provides an idempotencyKey (typically a UUID or client request ID).
 *   If we find an existing POSTED entry with the same (tenant, key), we return it.
 *   The DB has a unique constraint on (tenant_id, idempotency_key), so even
 *   concurrent requests cannot produce duplicates.
 */
@Service
public class JournalPostingService {

    private static final Logger log = LoggerFactory.getLogger(JournalPostingService.class);

    private final JournalEntryRepository journalEntryRepository;
    private final AccountingPeriodRepository periodRepository;

    public JournalPostingService(
            JournalEntryRepository journalEntryRepository,
            AccountingPeriodRepository periodRepository) {
        this.journalEntryRepository = journalEntryRepository;
        this.periodRepository = periodRepository;
    }

    /**
     * Post a journal entry atomically.
     *
     * @param draft a fully-built JournalEntry in DRAFT state with lines attached
     * @param postedBy user ID posting the entry
     * @return the persisted entry in POSTED state
     * @throws InvalidJournalEntryException if the period is not open or the entry is invalid
     */
    @Transactional(isolation = Isolation.SERIALIZABLE)
    public JournalEntry post(JournalEntry draft, Long postedBy) {
        // 1. Idempotency: if we already have this entry, return it.
        if (draft.getIdempotencyKey() != null) {
            Optional<JournalEntry> existing = journalEntryRepository
                .findByTenantIdAndIdempotencyKey(draft.getTenantId(), draft.getIdempotencyKey());
            if (existing.isPresent()) {
                log.info("Idempotent replay: returning existing entry {}", existing.get().getId());
                return existing.get();
            }
        }

        // 2. Period must be OPEN.
        AccountingPeriod period = periodRepository.findById(draft.getPeriodId())
            .orElseThrow(() -> new InvalidJournalEntryException(
                "Period not found: " + draft.getPeriodId()));
        if (!period.isOpen()) {
            throw new InvalidJournalEntryException(
                "Period " + period.getPeriodName() + " is " + period.getStatus()
                    + " and does not accept postings");
        }

        // 3. Validate date falls in period.
        if (draft.getEntryDate().isBefore(period.getStartDate())
                || draft.getEntryDate().isAfter(period.getEndDate())) {
            throw new InvalidJournalEntryException(
                "Entry date " + draft.getEntryDate() + " is outside period ["
                    + period.getStartDate() + ", " + period.getEndDate() + "]");
        }

        // 4. Persist as DRAFT first (this is required so lines get IDs and
        //    the DB trigger can validate balance on the subsequent UPDATE).
        draft.setStatus(EntryStatus.DRAFT);
        JournalEntry persisted = journalEntryRepository.saveAndFlush(draft);

        // 5. Transition to POSTED. This single UPDATE fires the DB trigger
        //    that re-validates the balance. If it fails, the transaction rolls back
        //    and no partial data remains.
        persisted.setStatus(EntryStatus.POSTED);
        persisted.setPostedAt(Instant.now());
        persisted.setPostedBy(postedBy);
        JournalEntry posted = journalEntryRepository.saveAndFlush(persisted);

        log.info("Posted journal entry {} for tenant {} (total lines: {})",
            posted.getEntryNumber(), posted.getTenantId(), posted.getLines().size());

        return posted;
    }
}

