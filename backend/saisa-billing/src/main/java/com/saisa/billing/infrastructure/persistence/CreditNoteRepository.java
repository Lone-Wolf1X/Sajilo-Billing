package com.saisa.billing.infrastructure.persistence;

import com.saisa.billing.domain.creditnote.CreditNote;
import java.util.Optional;
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
}

