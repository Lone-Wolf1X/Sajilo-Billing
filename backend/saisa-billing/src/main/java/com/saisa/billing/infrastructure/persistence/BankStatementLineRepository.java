package com.saisa.billing.infrastructure.persistence;

import com.saisa.billing.domain.reconciliation.BankStatementLine;
import com.saisa.billing.domain.reconciliation.StatementLineStatus;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BankStatementLineRepository extends JpaRepository<BankStatementLine, Long> {

    List<BankStatementLine> findByTenantIdAndBankAccountIdOrderByStatementDate(Long tenantId, Long bankAccountId);

    Optional<BankStatementLine> findByIdAndTenantId(Long id, Long tenantId);

    boolean existsByTenantIdAndMatchedPaymentIdAndStatus(
        Long tenantId, Long matchedPaymentId, StatementLineStatus status);
}
