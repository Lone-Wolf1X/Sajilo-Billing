package com.saisa.inventory.api;

import com.saisa.common.tenant.TenantContext;
import com.saisa.inventory.application.StockAdjustmentService;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/stock/adjustments")
public class StockAdjustmentController {

    public record CreateAdjustmentRequest(
        @NotNull Long itemId,
        @NotNull Long warehouseId,
        @NotNull LocalDate adjustmentDate,
        @NotBlank String type,          // ADJUSTMENT_IN or ADJUSTMENT_OUT
        @NotNull @Positive BigDecimal quantity,
        BigDecimal unitCost,            // required for ADJUSTMENT_IN
        String notes
    ) {}

    private final StockAdjustmentService service;

    public StockAdjustmentController(StockAdjustmentService service) {
        this.service = service;
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'ACCOUNTANT')")
    public ResponseEntity<?> create(@Valid @RequestBody CreateAdjustmentRequest req) {
        Long tenantId = TenantContext.getCurrentTenantId();
        Long userId = TenantContext.getCurrentUserId();

        var result = service.adjust(new StockAdjustmentService.AdjustmentRequest(
            tenantId, req.itemId(), req.warehouseId(), req.adjustmentDate(),
            req.type(), req.quantity(),
            req.unitCost(),
            req.notes(), userId));

        return ResponseEntity.status(HttpStatus.CREATED).body(Map.of(
            "movementId", result.movement().getId(),
            "quantityIn", result.movement().getQuantityIn(),
            "quantityOut", result.movement().getQuantityOut(),
            "unitCost", result.movement().getUnitCost(),
            "totalValue", result.totalValue(),
            "wacAfter", result.wacAfter(),
            "journalEntryId", result.journalEntry().getId()
        ));
    }
}

