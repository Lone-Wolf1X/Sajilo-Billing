package com.saisa.financial.infrastructure.persistence;

import com.saisa.financial.domain.journal.EntryStatus;
import com.saisa.financial.domain.journal.JournalEntry;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface JournalEntryRepository extends JpaRepository<JournalEntry, Long> {

    Optional<JournalEntry> findByTenantIdAndEntryNumber(Long tenantId, String entryNumber);

    boolean existsByTenantIdAndEntryNumber(Long tenantId, String entryNumber);

    Optional<JournalEntry> findByTenantIdAndIdempotencyKey(Long tenantId, String idempotencyKey);

    boolean existsByTenantIdAndIdempotencyKey(Long tenantId, String idempotencyKey);

    List<JournalEntry> findByTenantIdAndPeriodIdOrderByEntryDateAsc(Long tenantId, Long periodId);

    List<JournalEntry> findByTenantIdAndStatus(Long tenantId, EntryStatus status);

    @Query("SELECT j FROM JournalEntry j LEFT JOIN FETCH j.lines WHERE j.id = :id AND j.tenantId = :tenantId")
    Optional<JournalEntry> findByIdWithLines(@Param("tenantId") Long tenantId, @Param("id") Long id);

    @Query("SELECT j FROM JournalEntry j LEFT JOIN FETCH j.lines WHERE j.entryNumber = :entryNumber AND j.tenantId = :tenantId")
    Optional<JournalEntry> findByEntryNumberWithLines(@Param("tenantId") Long tenantId, @Param("entryNumber") String entryNumber);
}
