package com.saisa.financial.application.journal;

import com.saisa.financial.domain.journal.EntryStatus;
import com.saisa.financial.domain.journal.JournalEntry;
import com.saisa.financial.infrastructure.persistence.JournalEntryRepository;
import java.time.LocalDate;
import java.util.List;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
public class JournalEntryQueryService {

    private final JournalEntryRepository repo;

    public JournalEntryQueryService(JournalEntryRepository repo) {
        this.repo = repo;
    }

    public List<JournalEntry> list(Long tenantId, LocalDate fromDate, LocalDate toDate,
                                    EntryStatus status, int limit) {
        return repo.findWithFilters(tenantId, fromDate, toDate, status,
            PageRequest.of(0, Math.min(limit, 200)));
    }
}

