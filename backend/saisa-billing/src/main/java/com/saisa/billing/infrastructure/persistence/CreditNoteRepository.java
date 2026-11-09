package com.saisa.billing.infrastructure.persistence;

import com.saisa.billing.domain.creditnote.CreditNote;
import com.saisa.billing.domain.invoice.InvoiceStatus;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface CreditNoteRepository extends JpaRepository<CreditNote, Long> {

    @Query("SELECT c FROM CreditNote c LEFT JOIN FETCH c.lines WHERE c.id = :id")
    Optional<CreditNote> findByIdWithLines(@Param("id") Long id);

    Optional<CreditNote> findByTenantIdAndIdempotencyKey(Long tenantId, String key);

    Optional<CreditNote> findByTenantIdAndCreditNoteNumber(Long tenantId, String creditNoteNumber);

    @Query("""
        SELECT c FROM CreditNote c
        WHERE c.tenantId = :tenantId
          AND (:fromDate IS NULL OR c.creditNoteDate >= :fromDate)
          AND (:toDate IS NULL OR c.creditNoteDate <= :toDate)
          AND (:customerId IS NULL OR c.customerId = :customerId)
          AND (:status IS NULL OR c.status = :status)
        ORDER BY c.creditNoteDate DESC, c.id DESC
        """)
    List<CreditNote> findWithFilters(
        @Param("tenantId") Long tenantId,
        @Param("fromDate") LocalDate fromDate,
        @Param("toDate") LocalDate toDate,
        @Param("customerId") Long customerId,
        @Param("status") InvoiceStatus status,
        Pageable pageable);
}

