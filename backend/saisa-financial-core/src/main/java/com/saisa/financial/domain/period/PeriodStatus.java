package com.saisa.financial.domain.period;

/**
 * Lifecycle of an accounting period.
 *
 * OPEN   -> accepts new postings
 * CLOSED -> no new postings; reversals of entries within the period ARE allowed
 * LOCKED -> fully sealed after statutory audit; no changes at all
 */
public enum PeriodStatus {
    OPEN,
    CLOSED,
    LOCKED
}
