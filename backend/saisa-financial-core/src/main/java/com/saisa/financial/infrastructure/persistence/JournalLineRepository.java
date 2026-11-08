package com.saisa.financial.infrastructure.persistence;

import com.saisa.financial.domain.journal.JournalLine;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface JournalLineRepository extends JpaRepository<JournalLine, Long> {

    List<JournalLine> findByJournalEntryIdOrderByLineNumberAsc(Long journalEntryId);

    List<JournalLine> findByTenantIdAndAccountId(Long tenantId, Long accountId);
}

