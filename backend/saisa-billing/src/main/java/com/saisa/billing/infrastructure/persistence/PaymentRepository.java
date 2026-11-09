package com.saisa.billing.infrastructure.persistence;

import com.saisa.billing.domain.payment.Payment;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {

    @Query("SELECT p FROM Payment p LEFT JOIN FETCH p.allocations WHERE p.id = :id")
    Optional<Payment> findByIdWithAllocations(@Param("id") Long id);

    Optional<Payment> findByTenantIdAndIdempotencyKey(Long tenantId, String key);

    Optional<Payment> findByTenantIdAndPaymentNumber(Long tenantId, String number);
}

