package com.saisa.billing.infrastructure.persistence;

import com.saisa.billing.domain.invoice.InvoiceStatus;
import com.saisa.billing.domain.invoice.PurchaseInvoice;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface PurchaseInvoiceRepository extends JpaRepository<PurchaseInvoice, Long> {

    @Query("SELECT i FROM PurchaseInvoice i LEFT JOIN FETCH i.lines WHERE i.id = :id")
    Optional<PurchaseInvoice> findByIdWithLines(@Param("id") Long id);

    Optional<PurchaseInvoice> findByTenantIdAndIdempotencyKey(Long tenantId, String key);

    Optional<PurchaseInvoice> findByTenantIdAndInvoiceNumber(Long tenantId, String invoiceNumber);

    @Query("""
        SELECT i FROM PurchaseInvoice i
        WHERE i.tenantId = :tenantId
          AND (:fromDate IS NULL OR i.invoiceDate >= :fromDate)
          AND (:toDate IS NULL OR i.invoiceDate <= :toDate)
          AND (:vendorId IS NULL OR i.vendorId = :vendorId)
          AND (:status IS NULL OR i.status = :status)
        ORDER BY i.invoiceDate DESC, i.id DESC
        """)
    List<PurchaseInvoice> findWithFilters(
        @Param("tenantId") Long tenantId,
        @Param("fromDate") LocalDate fromDate,
        @Param("toDate") LocalDate toDate,
        @Param("vendorId") Long vendorId,
        @Param("status") InvoiceStatus status,
        Pageable pageable);
}

