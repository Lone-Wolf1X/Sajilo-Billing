package com.saisa.billing.infrastructure.persistence;

import com.saisa.billing.domain.invoice.Customer;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, Long> {

    Optional<Customer> findByTenantIdAndCustomerCode(Long tenantId, String customerCode);

    boolean existsByTenantIdAndCustomerCode(Long tenantId, String customerCode);
}
