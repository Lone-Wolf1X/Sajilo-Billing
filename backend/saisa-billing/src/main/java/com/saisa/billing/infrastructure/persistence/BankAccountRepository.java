package com.saisa.billing.infrastructure.persistence;

import com.saisa.billing.domain.payment.BankAccount;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BankAccountRepository extends JpaRepository<BankAccount, Long> {

    List<BankAccount> findByTenantIdAndActiveTrueOrderByAccountCode(Long tenantId);

    Optional<BankAccount> findByTenantIdAndAccountCode(Long tenantId, String code);
}

