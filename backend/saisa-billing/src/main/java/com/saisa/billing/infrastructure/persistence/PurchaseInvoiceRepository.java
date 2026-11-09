package com.saisa.billing.infrastructure.persistence;

import com.saisa.billing.domain.invoice.PurchaseInvoice;
import java.util.Optional;
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
}
