package com.saisa.billing.api;

import com.saisa.billing.api.dto.CreateCustomerRequest;
import com.saisa.billing.api.dto.CustomerResponse;
import com.saisa.billing.domain.invoice.Customer;
import com.saisa.billing.infrastructure.persistence.CustomerRepository;
import com.saisa.common.tenant.TenantContext;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/v1/customers")
public class CustomerController {

    private final CustomerRepository customerRepo;

    public CustomerController(CustomerRepository customerRepo) {
        this.customerRepo = customerRepo;
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'ACCOUNTANT')")
    public ResponseEntity<CustomerResponse> create(@Valid @RequestBody CreateCustomerRequest req) {
        Long tenantId = TenantContext.getCurrentTenantId();
        Long userId = TenantContext.getCurrentUserId();

        if (customerRepo.existsByTenantIdAndCustomerCode(tenantId, req.customerCode())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Customer code already exists");
        }

        Customer customer = new Customer();
        customer.setTenantId(tenantId);
        customer.setCustomerCode(req.customerCode());
        customer.setCustomerName(req.customerName());
        customer.setGstin(req.gstin());
        customer.setPan(req.pan());
        customer.setEmail(req.email());
        customer.setPhone(req.phone());
        customer.setBillingAddress(req.billingAddress());
        customer.setState(req.state());
        customer.setActive(true);
        customer.setCreatedBy(userId);

        Customer saved = customerRepo.save(customer);
        return ResponseEntity.status(HttpStatus.CREATED).body(CustomerResponse.from(saved));
    }

    @GetMapping("/{id}")
    @Transactional(readOnly = true)
    public CustomerResponse get(@PathVariable Long id) {
        Customer customer = customerRepo.findById(id)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Customer not found"));
        if (!customer.getTenantId().equals(TenantContext.getCurrentTenantId())) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Customer not found");
        }
        return CustomerResponse.from(customer);
    }
}

