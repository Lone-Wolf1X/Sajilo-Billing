package com.saisa.app.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import java.security.Key;
import java.util.Date;
import java.util.List;
import java.util.function.Function;
import javax.crypto.SecretKey;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

/**
 * Handles JWT generation and parsing.
 *
 * Access token contains:
 *   sub     = userId (as string)
 *   tid     = tenantId
 *   roles   = ["ADMIN", "ACCOUNTANT"]
 *   iat     = issued at
 *   exp     = expires at
 *
 * The tenant ID is embedded in the token and is the ONLY source of truth
 * for tenant identity during a request. Never trust tenantId from the client.
 */
@Service
public class JwtService {

    private final SecretKey signingKey;
    private final long accessTokenValidityMs;

    public JwtService(
            @Value("${saisa.jwt.secret}") String base64Secret,
            @Value("${saisa.jwt.access-token-validity-minutes:15}") long accessTokenValidityMinutes) {
        this.signingKey = Keys.hmacShaKeyFor(Decoders.BASE64.decode(base64Secret));
        this.accessTokenValidityMs = accessTokenValidityMinutes * 60 * 1000;
    }

    public String generateAccessToken(Long userId, Long tenantId, List<String> roles) {
        Date now = new Date();
        Date expiry = new Date(now.getTime() + accessTokenValidityMs);
        return Jwts.builder()
            .subject(String.valueOf(userId))
            .claim("tid", tenantId)
            .claim("roles", roles)
            .issuedAt(now)
            .expiration(expiry)
            .signWith(signingKey)
            .compact();
    }

    public Long extractUserId(String token) {
        return Long.valueOf(extractClaim(token, Claims::getSubject));
    }

    public Long extractTenantId(String token) {
        return extractClaim(token, claims -> claims.get("tid", Long.class));
    }

    @SuppressWarnings("unchecked")
    public List<String> extractRoles(String token) {
        return extractClaim(token, claims -> claims.get("roles", List.class));
    }

    public boolean isTokenValid(String token) {
        try {
            return !extractClaim(token, Claims::getExpiration).before(new Date());
        } catch (Exception e) {
            return false;
        }
    }

    private <T> T extractClaim(String token, Function<Claims, T> resolver) {
        Claims claims = Jwts.parser()
            .verifyWith(signingKey)
            .build()
            .parseSignedClaims(token)
            .getPayload();
        return resolver.apply(claims);
    }
}

