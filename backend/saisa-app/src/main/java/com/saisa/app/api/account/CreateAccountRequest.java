package com.saisa.app.api.account;

import com.saisa.financial.domain.account.AccountType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record CreateAccountRequest(
    @NotBlank @Size(max = 32) String accountCode,
    @NotBlank @Size(max = 255) String accountName,
    @NotNull AccountType accountType,
    Long parentAccountId
) {}
