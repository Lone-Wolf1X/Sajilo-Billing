package com.saisa.app.license;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface TenantLicenseRepository extends JpaRepository<TenantLicense, Long> {

    Optional<TenantLicense> findFirstByTenantIdAndActiveTrueOrderByExpiresAtDesc(Long tenantId);

    Optional<TenantLicense> findByLicenseId(String licenseId);
}
