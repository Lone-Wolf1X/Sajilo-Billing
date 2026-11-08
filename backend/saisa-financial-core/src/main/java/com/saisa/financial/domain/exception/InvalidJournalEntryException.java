package com.saisa.financial.domain.exception;

/**
 * Thrown when a journal entry violates an accounting invariant.
 *
 * This is a DOMAIN exception - it signals a business rule violation,
 * not an infrastructure problem. Callers should catch it, surface
 * the message to the user, and NOT retry.
 */
public class InvalidJournalEntryException extends RuntimeException {

    public InvalidJournalEntryException(String message) {
        super(message);
    }
}

