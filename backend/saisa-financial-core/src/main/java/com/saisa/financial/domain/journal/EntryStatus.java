package com.saisa.financial.domain.journal;

/**
 * Lifecycle of a journal entry.
 *
 * DRAFT    -> editable, lines can be added/changed/deleted, not yet in GL
 * POSTED   -> IMMUTABLE. Affects GL, reports, and balances. Cannot be modified.
 * REVERSED -> the original POSTED entry has been reversed by another entry.
 *             This status is informational; the entry itself is still visible
 *             in reports but flagged.
 */
public enum EntryStatus {
    DRAFT,
    POSTED,
    REVERSED
}
