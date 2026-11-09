package com.saisa.billing.infrastructure.persistence;

import com.saisa.billing.domain.payment.PartyType;
import com.saisa.billing.domain.payment.Payment;
import com.saisa.billing.domain.payment.PaymentStatus;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.Pageable;
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

    @Query("""
        SELECT p FROM Payment p
        WHERE p.tenantId = :tenantId
          AND (:fromDate IS NULL OR p.paymentDate >= :fromDate)
          AND (:toDate IS NULL OR p.paymentDate <= :toDate)
          AND (:partyType IS NULL OR p.partyType = :partyType)
          AND (:partyId IS NULL OR p.partyId = :partyId)
          AND (:status IS NULL OR p.status = :status)
        ORDER BY p.paymentDate DESC, p.id DESC
        """)
    List<Payment> findWithFilters(
        @Param("tenantId") Long tenantId,
        @Param("fromDate") LocalDate fromDate,
        @Param("toDate") LocalDate toDate,
        @Param("partyType") PartyType partyType,
        @Param("partyId") Long partyId,
        @Param("status") PaymentStatus status,
        Pageable pageable);
}

