package com.saisa.financial.infrastructure.persistence;

import com.saisa.financial.domain.account.ChartOfAccount;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ChartOfAccountRepository extends JpaRepository<ChartOfAccount, Long> {

    List<ChartOfAccount> findByTenantIdOrderByAccountCode(Long tenantId);

    Optional<ChartOfAccount> findByTenantIdAndAccountCode(Long tenantId, String accountCode);

    boolean existsByTenantIdAndAccountCode(Long tenantId, String accountCode);
}
