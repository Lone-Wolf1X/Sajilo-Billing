package com.saisa.financial.infrastructure.persistence;

import com.saisa.financial.domain.period.AccountingPeriod;
import com.saisa.financial.domain.period.PeriodStatus;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface AccountingPeriodRepository extends JpaRepository<AccountingPeriod, Long> {

    List<AccountingPeriod> findByTenantIdOrderByStartDateDesc(Long tenantId);

    Optional<AccountingPeriod> findByTenantIdAndPeriodName(Long tenantId, String periodName);

    boolean existsByTenantIdAndPeriodName(Long tenantId, String periodName);

    @Query("SELECT p FROM AccountingPeriod p WHERE p.tenantId = :tenantId AND :date BETWEEN p.startDate AND p.endDate")
    Optional<AccountingPeriod> findActivePeriodForDate(@Param("tenantId") Long tenantId, @Param("date") LocalDate date);

    List<AccountingPeriod> findByTenantIdAndStatus(Long tenantId, PeriodStatus status);
}
