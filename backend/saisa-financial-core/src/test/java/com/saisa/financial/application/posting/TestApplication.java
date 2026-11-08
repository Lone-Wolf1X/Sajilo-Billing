package com.saisa.financial.application.posting;

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

/**
 * Minimal Spring Boot app for tests in this module.
 * Scans entities and repositories under com.saisa.
 */
@SpringBootApplication(scanBasePackages = "com.saisa")
@EntityScan(basePackages = "com.saisa")
@EnableJpaRepositories(basePackages = "com.saisa")
public class TestApplication {
}

