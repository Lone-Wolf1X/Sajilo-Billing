package com.saisa.app.api.period;

import com.saisa.app.api.common.AuthenticatedUser;
import com.saisa.app.api.common.TenantGuard;
import com.saisa.financial.domain.exception.InvalidJournalEntryException;
import com.saisa.financial.domain.period.AccountingPeriod;
import com.saisa.financial.infrastructure.persistence.AccountingPeriodRepository;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/periods")
public class PeriodsController {

    private final AccountingPeriodRepository periodRepo;

    public PeriodsController(AccountingPeriodRepository periodRepo) {
        this.periodRepo = periodRepo;
    }

    @GetMapping
    public List<PeriodResponse> list() {
        // Note: we don't have a find-by-tenant method; use findAll + filter
        // (small data set - periods are ~12/year)
        Long tenantId = AuthenticatedUser.tenantId();
        return periodRepo.findAll(Sort.by("startDate")).stream()
            .filter(p -> p.getTenantId().equals(tenantId))
            .map(PeriodResponse::from).toList();
    }

    @GetMapping("/{id}")
    public PeriodResponse get(@PathVariable Long id) {
        AccountingPeriod p = periodRepo.findById(id)
            .orElseThrow(() -> new InvalidJournalEntryException("Period not found: " + id));
        TenantGuard.ensureOwned(p.getTenantId());
        return PeriodResponse.from(p);
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<PeriodResponse> create(@Valid @RequestBody CreatePeriodRequest req) {
        if (req.endDate().isBefore(req.startDate())) {
            throw new InvalidJournalEntryException("endDate must be >= startDate");
        }

        AccountingPeriod p = new AccountingPeriod();
        p.setTenantId(AuthenticatedUser.tenantId());
        p.setPeriodName(req.periodName());
        p.setStartDate(req.startDate());
        p.setEndDate(req.endDate());
        p.setCreatedBy(AuthenticatedUser.userId());

        AccountingPeriod saved = periodRepo.save(p);
        return ResponseEntity.status(HttpStatus.CREATED).body(PeriodResponse.from(saved));
    }
}
