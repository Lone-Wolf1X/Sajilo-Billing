package com.saisa.app.health;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.stereotype.Component;

@Component("dbSchema")
public class DatabaseSchemaHealthIndicator implements HealthIndicator {

    @PersistenceContext
    private EntityManager em;

    @Override
    public Health health() {
        try {
            var result = (Number) em.createNativeQuery(
                "SELECT COUNT(*) FROM flyway_schema_history WHERE success = true")
                .getSingleResult();
            long migrations = result.longValue();

            var lastVersion = (String) em.createNativeQuery(
                "SELECT version FROM flyway_schema_history WHERE success = true " +
                "ORDER BY installed_rank DESC LIMIT 1")
                .getSingleResult();

            if (lastVersion == null || migrations == 0) {
                return Health.down().withDetail("reason", "No migrations applied").build();
            }
            return Health.up()
                .withDetail("migrationsApplied", migrations)
                .withDetail("schemaVersion", lastVersion)
                .build();
        } catch (Exception e) {
            return Health.down().withDetail("error", e.getMessage()).build();
        }
    }
}

