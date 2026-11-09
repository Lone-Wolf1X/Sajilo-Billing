package com.saisa.billing.infrastructure.persistence;

import com.saisa.billing.domain.creditnote.DebitNote;
import java.util.Optional;
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
}

