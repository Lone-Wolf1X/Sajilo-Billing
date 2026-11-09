package com.saisa.billing.infrastructure.persistence;

import com.saisa.billing.domain.invoice.SalesInvoice;
import java.util.Optional;
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
}

