package com.saisa.billing.domain.exception;

public class InvalidBankReconciliationException extends RuntimeException {
    public InvalidBankReconciliationException(String message) {
        super(message);
    }
}

