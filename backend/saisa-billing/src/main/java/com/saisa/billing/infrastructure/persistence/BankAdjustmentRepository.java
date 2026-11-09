package com.saisa.billing.infrastructure.persistence;

import com.saisa.billing.domain.reconciliation.BankAdjustment;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BankAdjustmentRepository extends JpaRepository<BankAdjustment, Long> {

    Optional<BankAdjustment> findByTenantIdAndIdempotencyKey(Long tenantId, String idempotencyKey);
}

