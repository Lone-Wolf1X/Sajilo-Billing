package com.saisa.app.platform;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * Configuration for platform superadmin seeding.
 * Set via application.yml (dev) or environment variables (prod).
 */
@Component
@ConfigurationProperties(prefix = "saisa.platform")
public class PlatformProperties {

    private boolean seedEnabled = true;
    private String superadminUsername = "superadmin";
    private String superadminEmail = "nextgeninnovationsprivatelimit@gmail.com";
    private String superadminPassword = "ChangeMe#2026";   // MUST override in prod
    private String superadminFullName = "NextGen Administrator";

    public boolean isSeedEnabled() { return seedEnabled; }
    public void setSeedEnabled(boolean v) { this.seedEnabled = v; }

    public String getSuperadminUsername() { return superadminUsername; }
    public void setSuperadminUsername(String v) { this.superadminUsername = v; }

    public String getSuperadminEmail() { return superadminEmail; }
    public void setSuperadminEmail(String v) { this.superadminEmail = v; }

    public String getSuperadminPassword() { return superadminPassword; }
    public void setSuperadminPassword(String v) { this.superadminPassword = v; }

    public String getSuperadminFullName() { return superadminFullName; }
    public void setSuperadminFullName(String v) { this.superadminFullName = v; }
}

