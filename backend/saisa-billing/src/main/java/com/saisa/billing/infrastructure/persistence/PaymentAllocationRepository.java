package com.saisa.billing.infrastructure.persistence;

import com.saisa.billing.domain.payment.PaymentAllocation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PaymentAllocationRepository extends JpaRepository<PaymentAllocation, Long> {
}

