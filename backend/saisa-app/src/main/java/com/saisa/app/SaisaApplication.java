package com.saisa.app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

/**
 * SAISA Accounting - Main entry point.
 *
 * This class starts the entire modular monolith.
 * It scans all com.saisa.* packages so all modules are wired automatically.
 */
@SpringBootApplication(scanBasePackages = "com.saisa")
@EntityScan(basePackages = "com.saisa")
@EnableJpaRepositories(basePackages = "com.saisa")
public class SaisaApplication {

    public static void main(String[] args) {
        SpringApplication.run(SaisaApplication.class, args);
    }
}

