package com.saisa.financial.application.ledger;

import com.saisa.financial.domain.money.Money;
import java.time.LocalDate;

/**
 * One row in a General Ledger statement for a specific account.
 *
 * This is a READ MODEL, not an entity. It's derived from joining
 * journal_lines + journal_entries and computing a running balance.
 */
public record LedgerEntry(
    LocalDate entryDate,
    String entryNumber,
    Long journalEntryId,
    String narration,
    Money debit,
    Money credit,
    Money runningBalance
) {}
