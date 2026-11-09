package com.saisa.billing.infrastructure.persistence;

import com.saisa.billing.domain.invoice.InvoiceStatus;
import com.saisa.billing.domain.invoice.SalesInvoice;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface SalesInvoiceRepository extends JpaRepository<SalesInvoice, Long> {

    @Query("SELECT i FROM SalesInvoice i LEFT JOIN FETCH i.lines WHERE i.id = :id")
    Optional<SalesInvoice> findByIdWithLines(@Param("id") Long id);

    Optional<SalesInvoice> findByTenantIdAndIdempotencyKey(Long tenantId, String key);

    Optional<SalesInvoice> findByTenantIdAndInvoiceNumber(Long tenantId, String invoiceNumber);

    @Query("""
        SELECT i FROM SalesInvoice i
        WHERE i.tenantId = :tenantId
          AND (:fromDate IS NULL OR i.invoiceDate >= :fromDate)
          AND (:toDate IS NULL OR i.invoiceDate <= :toDate)
          AND (:customerId IS NULL OR i.customerId = :customerId)
          AND (:status IS NULL OR i.status = :status)
        ORDER BY i.invoiceDate DESC, i.id DESC
        """)
    List<SalesInvoice> findWithFilters(
        @Param("tenantId") Long tenantId,
        @Param("fromDate") LocalDate fromDate,
        @Param("toDate") LocalDate toDate,
        @Param("customerId") Long customerId,
        @Param("status") InvoiceStatus status,
        Pageable pageable);
}

