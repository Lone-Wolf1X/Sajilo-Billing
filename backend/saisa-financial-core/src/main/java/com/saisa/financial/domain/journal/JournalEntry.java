package com.saisa.financial.domain.journal;

import com.saisa.common.domain.BaseEntity;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import lombok.Getter;
import lombok.Setter;

/**
 * A journal entry header. Immutable once POSTED.
 *
 * Lines are managed as a collection. Persisting an entry cascades to its lines.
 */
@Entity
@Table(name = "journal_entries")
@Getter
@Setter
public class JournalEntry extends BaseEntity {

    @Column(name = "tenant_id", nullable = false)
    private Long tenantId;

    @Column(name = "entry_number", nullable = false, length = 64)
    private String entryNumber;

    @Column(name = "entry_date", nullable = false)
    private LocalDate entryDate;

    @Column(name = "period_id", nullable = false)
    private Long periodId;

    @Enumerated(EnumType.STRING)
    @Column(name = "entry_type", nullable = false, length = 32)
    private EntryType entryType;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 16)
    private EntryStatus status = EntryStatus.DRAFT;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "reference_type", length = 32)
    private String referenceType;

    @Column(name = "reference_id")
    private Long referenceId;

    @Column(name = "reversal_of_id")
    private Long reversalOfId;

    @Column(name = "posted_at")
    private Instant postedAt;

    @Column(name = "posted_by")
    private Long postedBy;

    @Column(name = "idempotency_key", length = 128)
    private String idempotencyKey;

    /**
     * Lines are part of the entry aggregate. CascadeType.ALL means:
     * - Persist/remove operations cascade
     * - Orphan removal: removing from this list deletes the line
     *
     * FetchType.LAZY: we don't want to load all lines on every query.
     * Access them via a repository method or within a transaction.
     */
    @OneToMany(
        mappedBy = "journalEntry",
        cascade = CascadeType.ALL,
        orphanRemoval = true,
        fetch = FetchType.LAZY
    )
    private List<JournalLine> lines = new ArrayList<>();

    // ---- Domain helpers ----

    public void addLine(JournalLine line) {
        line.setJournalEntry(this);
        line.setTenantId(this.tenantId);
        line.setLineNumber(this.lines.size() + 1);
        this.lines.add(line);
    }

    public boolean isDraft() {
        return status == EntryStatus.DRAFT;
    }

    public boolean isPosted() {
        return status == EntryStatus.POSTED;
    }
}
