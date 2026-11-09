package com.saisa.app.ratelimit;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.Instant;
import java.util.Map;
import org.springframework.http.MediaType;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class RateLimitInterceptor implements HandlerInterceptor {

    private final RateLimitService rateLimitService;
    private final ObjectMapper objectMapper;

    public RateLimitInterceptor(RateLimitService rateLimitService, ObjectMapper objectMapper) {
        this.rateLimitService = rateLimitService;
        this.objectMapper = objectMapper;
    }

    @Override
    public boolean preHandle(HttpServletRequest req, HttpServletResponse resp, Object handler)
            throws IOException {
        String path = req.getRequestURI();
        String method = req.getMethod();

        if (!path.startsWith("/api/v1/")) return true;    // skip actuator, etc.
        if (path.startsWith("/api/v1/auth/")) return true; // already rate limited in filter

        String principal = principal();

        RateLimitService.Decision decision;
        if (isFinancialWrite(path, method)) {
            decision = rateLimitService.checkFinancialWrite(principal);
        } else {
            decision = rateLimitService.checkGeneral(principal);
        }

        if (!decision.allowed()) {
            writeRateLimited(resp, decision);
            return false;
        }

        resp.setHeader("X-RateLimit-Remaining", String.valueOf(decision.remainingTokens()));
        return true;
    }

    private boolean isFinancialWrite(String path, String method) {
        if (!("POST".equals(method) || "PUT".equals(method) || "PATCH".equals(method))) return false;
        return path.startsWith("/api/v1/journal-entries")
            || path.startsWith("/api/v1/sales-invoices")
            || path.startsWith("/api/v1/purchase-invoices")
            || path.startsWith("/api/v1/payments")
            || path.startsWith("/api/v1/credit-notes")
            || path.startsWith("/api/v1/debit-notes");
    }

    private String principal() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.getPrincipal() != null) {
            return "u:" + auth.getPrincipal().toString();
        }
        return "anon";
    }

    private void writeRateLimited(HttpServletResponse resp,
                                   RateLimitService.Decision d) throws IOException {
        resp.setStatus(429);
        resp.setHeader("Retry-After", String.valueOf(d.retryAfterSeconds()));
        resp.setContentType(MediaType.APPLICATION_JSON_VALUE);
        objectMapper.writeValue(resp.getOutputStream(), Map.of(
            "code", "RATE_LIMITED",
            "message", "Too many requests. Retry after " + d.retryAfterSeconds() + " seconds.",
            "retryAfterSeconds", d.retryAfterSeconds(),
            "timestamp", Instant.now().toString()
        ));
    }
}

