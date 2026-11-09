package com.saisa.app.api.account;

import com.saisa.financial.domain.account.AccountType;
import com.saisa.financial.domain.account.ChartOfAccount;

public record AccountResponse(
    Long id,
    String accountCode,
    String accountName,
    AccountType accountType,
    Long parentAccountId,
    boolean systemAccount,
    boolean active
) {
    public static AccountResponse from(ChartOfAccount a) {
        return new AccountResponse(
            a.getId(), a.getAccountCode(), a.getAccountName(),
            a.getAccountType(), a.getParentAccountId(),
            a.isSystemAccount(), a.isActive());
    }
}
