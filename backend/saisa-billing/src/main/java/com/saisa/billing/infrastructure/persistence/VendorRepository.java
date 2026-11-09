package com.saisa.billing.infrastructure.persistence;

import com.saisa.billing.domain.invoice.Vendor;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface VendorRepository extends JpaRepository<Vendor, Long> {

    Optional<Vendor> findByTenantIdAndVendorCode(Long tenantId, String vendorCode);

    boolean existsByTenantIdAndVendorCode(Long tenantId, String vendorCode);
}
