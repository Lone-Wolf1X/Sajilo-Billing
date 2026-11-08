package com.saisa.financial.application.reversal;

import com.saisa.financial.application.posting.JournalPostingService;
import com.saisa.financial.domain.exception.InvalidJournalEntryException;
import com.saisa.financial.domain.journal.EntryStatus;
import com.saisa.financial.domain.journal.EntryType;
import com.saisa.financial.domain.journal.JournalEntry;
import com.saisa.financial.domain.journal.JournalLine;
import com.saisa.financial.domain.journal.builder.JournalEntryBuilder;
import com.saisa.financial.domain.money.Currency;
import com.saisa.financial.domain.money.Money;
import com.saisa.financial.infrastructure.persistence.JournalEntryRepository;
import java.time.LocalDate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

/**
 * Implements the REVERSAL-BASED CORRECTION mechanism.
 *
 * Accounting rule: a posted journal entry is IMMUTABLE. To "undo" it,
 * you post a NEW entry that has the exact opposite effect:
 *   - For each debit line in the original, create a credit line in the reversal.
 *   - For each credit line in the original, create a debit line in the reversal.
 *   - Set reversal_of_id to the original entry's ID.
 *   - Mark the original entry as REVERSED (informational only).
 *
 * The original entry still appears in the general ledger (with status REVERSED).
 * The reversal entry also appears. Net effect is zero. Audit trail is complete.
 */
@Service
public class ReversalService {

    private static final Logger log = LoggerFactory.getLogger(ReversalService.class);

    private final JournalEntryRepository journalEntryRepository;
    private final JournalPostingService postingService;

    public ReversalService(
            JournalEntryRepository journalEntryRepository,
            JournalPostingService postingService) {
        this.journalEntryRepository = journalEntryRepository;
        this.postingService = postingService;
    }

    /**
     * Reverse a POSTED journal entry.
     *
     * @param originalEntryId ID of the entry to reverse
     * @param reversalDate date to use for the reversal entry (typically today)
     * @param reason human-readable reason for the reversal
     * @param postedBy user performing the reversal
     * @return the newly-created reversal entry (POSTED)
     */
    @Transactional(isolation = Isolation.SERIALIZABLE)
    public JournalEntry reverse(
            Long originalEntryId,
            LocalDate reversalDate,
            String reason,
            Long postedBy) {

        // Load the original WITH lines (we need them to build the reversal).
        JournalEntry original = journalEntryRepository.findByIdWithLines(originalEntryId)
            .orElseThrow(() -> new InvalidJournalEntryException(
                "Original entry not found: " + originalEntryId));

        if (original.getStatus() != EntryStatus.POSTED) {
            throw new InvalidJournalEntryException(
                "Only POSTED entries can be reversed. Entry " + originalEntryId
                    + " is " + original.getStatus());
        }

        if (original.getReversalOfId() != null) {
            throw new InvalidJournalEntryException(
                "Cannot reverse a reversal entry. Reverse the original instead.");
        }

        // Build the mirror-image entry.
        JournalEntryBuilder builder = JournalEntryBuilder.create()
            .tenant(original.getTenantId())
            .entryDate(reversalDate)
            .period(original.getPeriodId())
            .type(EntryType.REVERSAL)
            .description("Reversal of " + original.getEntryNumber() + ": " + reason)
            .reference(original.getReferenceType(), original.getReferenceId())
            .createdBy(postedBy);

        for (JournalLine line : original.getLines()) {
            Currency currency = Currency.valueOf(line.getCurrencyCode());
            if (line.getDebitAmount().signum() > 0) {
                // Original had debit -> reversal gets credit.
                builder.credit(line.getAccountId(),
                    Money.fromDatabase(line.getDebitAmount(), currency),
                    "Reversal: " + line.getDescription());
            } else {
                // Original had credit -> reversal gets debit.
                builder.debit(line.getAccountId(),
                    Money.fromDatabase(line.getCreditAmount(), currency),
                    "Reversal: " + line.getDescription());
            }
        }

        JournalEntry reversal = builder.build();

        // Link reversal to original (must be set BEFORE posting).
        reversal.setReversalOfId(original.getId());

        // Post the reversal using the standard posting path.
        JournalEntry postedReversal = postingService.post(reversal, postedBy);

        // Mark the original as REVERSED (informational flag only - does NOT
        // unset postedAt or change the posted entry's effect on the ledger).
        original.setStatus(EntryStatus.REVERSED);
        journalEntryRepository.save(original);

        log.info("Reversed entry {} with new entry {}",
            original.getEntryNumber(), postedReversal.getEntryNumber());

        return postedReversal;
    }
}

