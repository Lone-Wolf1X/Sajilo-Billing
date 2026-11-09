package com.saisa.app.api.reporting;

import com.saisa.app.api.common.AuthenticatedUser;
import com.saisa.financial.application.reporting.BalanceSheetService;
import com.saisa.financial.application.reporting.CashFlowService;
import com.saisa.financial.application.reporting.ProfitAndLossService;
import com.saisa.financial.application.reporting.TrialBalanceService;
import com.saisa.financial.application.reporting.dto.BalanceSheetReport;
import com.saisa.financial.application.reporting.dto.CashFlowReport;
import com.saisa.financial.application.reporting.dto.ProfitAndLossReport;
import java.time.LocalDate;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/reports")
public class ReportsController {

    private final TrialBalanceService tbService;
    private final ProfitAndLossService plService;
    private final BalanceSheetService bsService;
    private final CashFlowService cfService;

    public ReportsController(TrialBalanceService tbService,
                             ProfitAndLossService plService,
                             BalanceSheetService bsService,
                             CashFlowService cfService) {
        this.tbService = tbService;
        this.plService = plService;
        this.bsService = bsService;
        this.cfService = cfService;
    }

    @GetMapping("/trial-balance")
    public TrialBalanceResponse trialBalance(@RequestParam LocalDate asOf) {
        Long tenantId = AuthenticatedUser.tenantId();
        var rows = tbService.computeTrialBalance(tenantId, asOf);
        return new TrialBalanceResponse(tenantId, asOf, rows, tbService.isBalanced(rows));
    }

    @GetMapping("/profit-loss")
    public ProfitAndLossReport profitLoss(
            @RequestParam LocalDate from, @RequestParam LocalDate to) {
        return plService.generate(AuthenticatedUser.tenantId(), from, to);
    }

    @GetMapping("/balance-sheet")
    public BalanceSheetReport balanceSheet(@RequestParam LocalDate asOf) {
        return bsService.generate(AuthenticatedUser.tenantId(), asOf);
    }

    @GetMapping("/cash-flow")
    public CashFlowReport cashFlow(
            @RequestParam LocalDate from, @RequestParam LocalDate to) {
        return cfService.generate(AuthenticatedUser.tenantId(), from, to);
    }

    public record TrialBalanceResponse(
        Long tenantId, LocalDate asOfDate,
        List<TrialBalanceService.TrialBalanceRow> rows,
        boolean balanced
    ) {}
}
