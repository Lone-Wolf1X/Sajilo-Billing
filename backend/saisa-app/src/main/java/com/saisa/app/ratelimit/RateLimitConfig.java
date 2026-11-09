package com.saisa.app.ratelimit;

import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;
import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import io.github.bucket4j.Refill;
import java.time.Duration;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class RateLimitConfig {

    private static int regCapacity = 3;

    @Value("${saisa.ratelimit.register-capacity:3}")
    public void setRegisterCapacity(int capacity) {
        regCapacity = capacity;
    }

    /**
     * Cache of rate-limit buckets keyed by client identifier + tier.
     * Auto-evicts after 1 hour of inactivity to prevent memory growth.
     */
    @Bean
    public Cache<String, Bucket> rateLimitBuckets() {
        return Caffeine.newBuilder()
            .expireAfterAccess(Duration.ofHours(1))
            .maximumSize(50_000)
            .build();
    }

    /** Login: 5 attempts per 15 minutes. */
    public static Bucket newLoginBucket() {
        return Bucket.builder()
            .addLimit(Bandwidth.classic(5, Refill.greedy(5, Duration.ofMinutes(15))))
            .build();
    }

    /** Register: 3 attempts per hour in prod, configurable for tests. */
    public static Bucket newRegisterBucket() {
        return Bucket.builder()
            .addLimit(Bandwidth.classic(regCapacity, Refill.greedy(regCapacity, Duration.ofHours(1))))
            .build();
    }

    /** General API: 100 requests per minute. */
    public static Bucket newGeneralBucket() {
        return Bucket.builder()
            .addLimit(Bandwidth.classic(100, Refill.greedy(100, Duration.ofMinutes(1))))
            .build();
    }

    /** Financial writes: 30 requests per minute (posting is expensive). */
    public static Bucket newFinancialWriteBucket() {
        return Bucket.builder()
            .addLimit(Bandwidth.classic(30, Refill.greedy(30, Duration.ofMinutes(1))))
            .build();
    }

    /** Refresh token: 30 per hour. */
    public static Bucket newRefreshBucket() {
        return Bucket.builder()
            .addLimit(Bandwidth.classic(30, Refill.greedy(30, Duration.ofHours(1))))
            .build();
    }
}
