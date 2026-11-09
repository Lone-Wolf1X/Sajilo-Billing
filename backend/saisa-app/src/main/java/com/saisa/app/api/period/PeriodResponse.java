package com.saisa.app.api.period;

import com.saisa.financial.domain.period.AccountingPeriod;
import com.saisa.financial.domain.period.PeriodStatus;
import java.time.LocalDate;

public record PeriodResponse(
    Long id,
    String periodName,
    LocalDate startDate,
    LocalDate endDate,
    PeriodStatus status
) {
    public static PeriodResponse from(AccountingPeriod p) {
        return new PeriodResponse(
            p.getId(), p.getPeriodName(), p.getStartDate(), p.getEndDate(), p.getStatus());
    }
}
