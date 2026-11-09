package com.saisa.app.ratelimit;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.Instant;
import java.util.Map;
import org.springframework.core.annotation.Order;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

/**
 * Rate limit UNAUTHENTICATED auth endpoints by IP + username.
 * All other endpoints are handled by RateLimitInterceptor (post-auth).
 */
@Component
@Order(10)
public class RateLimitFilter extends OncePerRequestFilter {

    private final RateLimitService rateLimitService;
    private final ObjectMapper objectMapper;

    public RateLimitFilter(RateLimitService rateLimitService, ObjectMapper objectMapper) {
        this.rateLimitService = rateLimitService;
        this.objectMapper = objectMapper;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest req, HttpServletResponse resp,
                                    FilterChain chain) throws ServletException, IOException {
        String path = req.getRequestURI();
        String method = req.getMethod();

        HttpServletRequest requestToPass = req;
        RateLimitService.Decision decision = null;

        if ("POST".equalsIgnoreCase(method) && "/api/v1/auth/login".equals(path)) {
            CachedBodyHttpServletRequest wrapped = new CachedBodyHttpServletRequest(req);
            requestToPass = wrapped;
            String username = "";
            try {
                JsonNode node = objectMapper.readTree(wrapped.getCachedBody());
                if (node != null) {
                    String tenant = node.has("tenantCode") ? node.get("tenantCode").asText("") : "";
                    String uName = node.has("username") ? node.get("username").asText("") : "";
                    if (!tenant.isBlank() || !uName.isBlank()) {
                        username = tenant + ":" + uName;
                    }
                }
            } catch (Exception ignored) {
            }
            decision = rateLimitService.checkLogin(clientIp(req), username);
        } else if ("POST".equalsIgnoreCase(method) && "/api/v1/auth/register".equals(path)) {
            decision = rateLimitService.checkRegister(clientIp(req));
        } else if ("POST".equalsIgnoreCase(method) && "/api/v1/auth/refresh".equals(path)) {
            decision = rateLimitService.checkRefresh(clientIp(req));
        }

        if (decision != null && !decision.allowed()) {
            writeRateLimited(resp, decision);
            return;
        }

        chain.doFilter(requestToPass, resp);
    }

    private String clientIp(HttpServletRequest req) {
        String xff = req.getHeader("X-Forwarded-For");
        if (xff != null && !xff.isBlank()) return xff.split(",")[0].trim();
        return req.getRemoteAddr();
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
