package com.saisa.app.auth;

import com.saisa.financial.domain.exception.InvalidJournalEntryException;
import java.time.Instant;
import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.server.ResponseStatusException;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ResponseStatusException.class)
    public ResponseEntity<Map<String, Object>> handleResponseStatus(ResponseStatusException e) {
        return ResponseEntity.status(e.getStatusCode())
            .body(error(e.getStatusCode().toString(), e.getReason()));
    }

    @ExceptionHandler(BadCredentialsException.class)
    public ResponseEntity<Map<String, Object>> handleBadCredentials(BadCredentialsException e) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
            .body(error("INVALID_CREDENTIALS", "Invalid username or password"));
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<Map<String, Object>> handleIllegalArgument(IllegalArgumentException e) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body(error("BAD_REQUEST", e.getMessage()));
    }

    @ExceptionHandler({
        InvalidJournalEntryException.class,
        com.saisa.billing.domain.exception.InvalidPaymentException.class,
        com.saisa.billing.domain.exception.InvalidCreditNoteException.class
    })
    public ResponseEntity<Map<String, Object>> handleInvalidJournalEntry(RuntimeException e) {
        return ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY)
            .body(error("INVALID_JOURNAL_ENTRY", e.getMessage()));
    }

    @ExceptionHandler(IllegalStateException.class)
    public ResponseEntity<Map<String, Object>> handleIllegalState(IllegalStateException e) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
            .body(error("INTERNAL_ERROR", e.getMessage()));
    }

    private Map<String, Object> error(String code, String message) {
        return Map.of(
            "code", code,
            "message", message,
            "timestamp", Instant.now().toString()
        );
    }
}

