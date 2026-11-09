package com.saisa.billing.api;

import com.saisa.billing.api.dto.CreateVendorRequest;
import com.saisa.billing.api.dto.VendorResponse;
import com.saisa.billing.domain.invoice.Vendor;
import com.saisa.billing.infrastructure.persistence.VendorRepository;
import com.saisa.common.tenant.TenantContext;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/v1/vendors")
public class VendorController {

    private final VendorRepository vendorRepo;

    public VendorController(VendorRepository vendorRepo) {
        this.vendorRepo = vendorRepo;
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'ACCOUNTANT')")
    public ResponseEntity<VendorResponse> create(@Valid @RequestBody CreateVendorRequest req) {
        Long tenantId = TenantContext.getCurrentTenantId();
        Long userId = TenantContext.getCurrentUserId();

        if (vendorRepo.existsByTenantIdAndVendorCode(tenantId, req.vendorCode())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Vendor code already exists");
        }

        Vendor vendor = new Vendor();
        vendor.setTenantId(tenantId);
        vendor.setVendorCode(req.vendorCode());
        vendor.setVendorName(req.vendorName());
        vendor.setGstin(req.gstin());
        vendor.setPan(req.pan());
        vendor.setEmail(req.email());
        vendor.setPhone(req.phone());
        vendor.setBillingAddress(req.billingAddress());
        vendor.setState(req.state());
        vendor.setActive(true);
        vendor.setCreatedBy(userId);

        Vendor saved = vendorRepo.save(vendor);
        return ResponseEntity.status(HttpStatus.CREATED).body(VendorResponse.from(saved));
    }

    @GetMapping("/{id}")
    @Transactional(readOnly = true)
    public VendorResponse get(@PathVariable Long id) {
        Vendor vendor = vendorRepo.findById(id)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Vendor not found"));
        if (!vendor.getTenantId().equals(TenantContext.getCurrentTenantId())) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Vendor not found");
        }
        return VendorResponse.from(vendor);
    }
}

