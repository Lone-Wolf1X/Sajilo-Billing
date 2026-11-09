package com.saisa.billing.api.payment;

import com.saisa.billing.application.payment.AgingService;
import com.saisa.common.tenant.TenantContext;
import java.time.LocalDate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/reports")
public class AgingController {

    private final AgingService agingService;

    public AgingController(AgingService agingService) {
        this.agingService = agingService;
    }

    @GetMapping("/ar-aging")
    public AgingService.AgingReport arAging(
            @RequestParam(required = false) LocalDate asOf) {
        return agingService.arAging(
            TenantContext.getCurrentTenantId(),
            asOf != null ? asOf : LocalDate.now());
    }

    @GetMapping("/ap-aging")
    public AgingService.AgingReport apAging(
            @RequestParam(required = false) LocalDate asOf) {
        return agingService.apAging(
            TenantContext.getCurrentTenantId(),
            asOf != null ? asOf : LocalDate.now());
    }
}

