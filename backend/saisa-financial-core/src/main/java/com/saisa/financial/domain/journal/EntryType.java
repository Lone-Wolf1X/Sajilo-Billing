package com.saisa.financial.domain.journal;

/**
 * Type of journal entry. Determines default narration and may affect
 * which accounts are posted to (though explicit lines still control that).
 */
public enum EntryType {
    MANUAL,        // user-entered
    SALES,         // from a sales invoice
    PURCHASE,      // from a purchase invoice
    RECEIPT,       // money in
    PAYMENT,       // money out
    CONTRA,        // cash <-> bank transfer
    JOURNAL,       // general journal adjustment
    OPENING,       // opening balances
    REVERSAL,      // explicitly reverses an earlier entry
    ADJUSTMENT     // year-end / correction adjustments
}
