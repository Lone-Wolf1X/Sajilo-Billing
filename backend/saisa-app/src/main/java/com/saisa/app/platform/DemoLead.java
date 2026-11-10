package com.saisa.app.platform;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.Instant;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "demo_leads")
@Getter
@Setter
public class DemoLead {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "full_name", nullable = false)
    private String fullName;

    @Column(name = "email", nullable = false)
    private String email;

    @Column(name = "phone", nullable = false)
    private String phone;

    @Column(name = "company_name", nullable = false)
    private String companyName;

    @Column(name = "city")
    private String city;

    @Column(name = "status", nullable = false)
    private String status = "WAITING";

    @Column(name = "requested_plan", nullable = false)
    private String requestedPlan = "DEMO_TRIAL";

    @Column(name = "notes")
    private String notes;

    @Column(name = "converted_tenant_id")
    private Long convertedTenantId;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt = Instant.now();

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt = Instant.now();
}

