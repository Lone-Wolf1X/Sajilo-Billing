package com.saisa.billing.domain.exception;

public class InvalidCreditNoteException extends RuntimeException {
    public InvalidCreditNoteException(String message) {
        super(message);
    }
}

