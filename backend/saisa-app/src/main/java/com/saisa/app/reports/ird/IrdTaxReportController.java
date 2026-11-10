package com.saisa.app.reports.ird;

import java.time.LocalDate;
import java.util.List;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/reports/ird")
@PreAuthorize("hasAnyRole('PLATFORM_ADMIN', 'ADMIN', 'ACCOUNTANT', 'VIEWER')")
public class IrdTaxReportController {

    private final IrdTaxReportService irdService;

    public IrdTaxReportController(IrdTaxReportService irdService) {
        this.irdService = irdService;
    }

    @GetMapping("/d01-sales")
    public ResponseEntity<List<D01SalesEntryDto>> getD01SalesBook(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fromDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate toDate) {
        return ResponseEntity.ok(irdService.getD01SalesBook(fromDate, toDate));
    }

    @GetMapping("/d02-purchases")
    public ResponseEntity<List<D02PurchaseEntryDto>> getD02PurchaseBook(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fromDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate toDate) {
        return ResponseEntity.ok(irdService.getD02PurchaseBook(fromDate, toDate));
    }

    @GetMapping("/summary")
    public ResponseEntity<IrdTaxSummaryResponse> getSummary(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fromDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate toDate) {
        return ResponseEntity.ok(irdService.getSummary(fromDate, toDate));
    }
}

