package com.saisa.app.auth;

import com.saisa.financial.domain.exception.InvalidJournalEntryException;
import java.time.Instant;
import java.util.HashMap;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.server.ResponseStatusException;

@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

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

    @ExceptionHandler(org.springframework.security.authentication.DisabledException.class)
    public ResponseEntity<Map<String, Object>> handleDisabled(org.springframework.security.authentication.DisabledException e) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
            .body(error("ACCOUNT_DISABLED", "User account is disabled. Contact your administrator."));
    }

    @ExceptionHandler(org.springframework.security.authentication.LockedException.class)
    public ResponseEntity<Map<String, Object>> handleLocked(org.springframework.security.authentication.LockedException e) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
            .body(error("ACCOUNT_LOCKED", "User account is temporarily locked due to failed login attempts."));
    }

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<Map<String, Object>> handleAccessDenied(AccessDeniedException e) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN)
            .body(error("ACCESS_DENIED", "Access denied: insufficient permissions"));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, Object>> handleValidationErrors(MethodArgumentNotValidException e) {
        Map<String, String> fieldErrors = new HashMap<>();
        for (FieldError fe : e.getBindingResult().getFieldErrors()) {
            fieldErrors.put(fe.getField(), fe.getDefaultMessage());
        }
        Map<String, Object> err = error("VALIDATION_FAILED", "Request validation failed");
        err.put("errors", fieldErrors);
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(err);
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<Map<String, Object>> handleIllegalArgument(IllegalArgumentException e) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body(error("BAD_REQUEST", e.getMessage()));
    }

    @ExceptionHandler({
        InvalidJournalEntryException.class,
        com.saisa.billing.domain.exception.InvalidPaymentException.class,
        com.saisa.billing.domain.exception.InvalidCreditNoteException.class,
        com.saisa.billing.domain.exception.InvalidBankReconciliationException.class
    })
    public ResponseEntity<Map<String, Object>> handleInvalidBusinessRules(RuntimeException e) {
        return ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY)
            .body(error("INVALID_JOURNAL_ENTRY", e.getMessage()));
    }

    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<Map<String, Object>> handleDataIntegrity(DataIntegrityViolationException e) {
        String cid = currentCorrelationId();
        log.warn("Database constraint violation [cid={}]: {}", cid, e.getMessage());
        return ResponseEntity.status(HttpStatus.CONFLICT)
            .body(error("DATA_INTEGRITY_VIOLATION",
                "A database constraint was violated (e.g., duplicate record or invalid reference)."));
    }

    @ExceptionHandler(IllegalStateException.class)
    public ResponseEntity<Map<String, Object>> handleIllegalState(IllegalStateException e) {
        String cid = currentCorrelationId();
        log.error("Internal state error [cid={}]: {}", cid, e.getMessage(), e);
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
            .body(error("INTERNAL_ERROR",
                "An unexpected internal state error occurred. Reference CID: " + cid));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, Object>> handleUnhandledException(Exception e) {
        String cid = currentCorrelationId();
        log.error("Unhandled server exception [cid={}]: {}", cid, e.getMessage(), e);
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
            .body(error("INTERNAL_SERVER_ERROR",
                "An unexpected server error occurred. Reference CID: " + cid));
    }

    private Map<String, Object> error(String code, String message) {
        Map<String, Object> res = new HashMap<>();
        res.put("code", code);
        res.put("message", message);
        res.put("correlationId", currentCorrelationId());
        res.put("timestamp", Instant.now().toString());
        return res;
    }

    private String currentCorrelationId() {
        String cid = MDC.get("correlationId");
        return cid != null ? cid : "no-cid";
    }
}
