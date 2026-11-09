package com.saisa.billing.infrastructure.persistence;

import com.saisa.billing.domain.creditnote.DebitNote;
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
public interface DebitNoteRepository extends JpaRepository<DebitNote, Long> {

    @Query("SELECT d FROM DebitNote d LEFT JOIN FETCH d.lines WHERE d.id = :id")
    Optional<DebitNote> findByIdWithLines(@Param("id") Long id);

    Optional<DebitNote> findByTenantIdAndIdempotencyKey(Long tenantId, String key);

    Optional<DebitNote> findByTenantIdAndDebitNoteNumber(Long tenantId, String debitNoteNumber);

    @Query("""
        SELECT d FROM DebitNote d
        WHERE d.tenantId = :tenantId
          AND (:fromDate IS NULL OR d.debitNoteDate >= :fromDate)
          AND (:toDate IS NULL OR d.debitNoteDate <= :toDate)
          AND (:vendorId IS NULL OR d.vendorId = :vendorId)
          AND (:status IS NULL OR d.status = :status)
        ORDER BY d.debitNoteDate DESC, d.id DESC
        """)
    List<DebitNote> findWithFilters(
        @Param("tenantId") Long tenantId,
        @Param("fromDate") LocalDate fromDate,
        @Param("toDate") LocalDate toDate,
        @Param("vendorId") Long vendorId,
        @Param("status") InvoiceStatus status,
        Pageable pageable);
}

