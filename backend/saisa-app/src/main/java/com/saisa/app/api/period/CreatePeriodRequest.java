package com.saisa.app.api.period;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;

public record CreatePeriodRequest(
    @NotBlank String periodName,
    @NotNull LocalDate startDate,
    @NotNull LocalDate endDate
) {}
