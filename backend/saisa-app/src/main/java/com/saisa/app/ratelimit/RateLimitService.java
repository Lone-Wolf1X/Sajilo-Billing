package com.saisa.app.ratelimit;

import com.github.benmanes.caffeine.cache.Cache;
import io.github.bucket4j.Bucket;
import io.github.bucket4j.ConsumptionProbe;
import org.springframework.stereotype.Service;

@Service
public class RateLimitService {

    private final Cache<String, Bucket> buckets;

    public RateLimitService(Cache<String, Bucket> buckets) {
        this.buckets = buckets;
    }

    public record Decision(boolean allowed, long remainingTokens, long retryAfterSeconds) {}

    public Decision checkLogin(String ip, String username) {
        String key = "login:" + ip + ":" + username;
        return tryConsume(key, RateLimitConfig::newLoginBucket);
    }

    public Decision checkRegister(String ip) {
        return tryConsume("register:" + ip, RateLimitConfig::newRegisterBucket);
    }

    public Decision checkRefresh(String ip) {
        return tryConsume("refresh:" + ip, RateLimitConfig::newRefreshBucket);
    }

    public Decision checkGeneral(String principal) {
        return tryConsume("general:" + principal, RateLimitConfig::newGeneralBucket);
    }

    public Decision checkFinancialWrite(String principal) {
        return tryConsume("fin:" + principal, RateLimitConfig::newFinancialWriteBucket);
    }

    public void clearAll() {
        buckets.invalidateAll();
    }

    private Decision tryConsume(String key,
                                java.util.function.Supplier<Bucket> bucketFactory) {
        Bucket bucket = buckets.get(key, k -> bucketFactory.get());
        ConsumptionProbe probe = bucket.tryConsumeAndReturnRemaining(1);

        if (probe.isConsumed()) {
            return new Decision(true, probe.getRemainingTokens(), 0);
        }

        long retryAfterNanos = probe.getNanosToWaitForRefill();
        long seconds = Math.max(1, retryAfterNanos / 1_000_000_000L);
        return new Decision(false, 0, seconds);
    }
}

