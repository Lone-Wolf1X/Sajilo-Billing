package com.saisa.inventory.api;

import com.saisa.common.tenant.TenantContext;
import com.saisa.inventory.api.dto.StockBalanceResponse;
import com.saisa.inventory.infrastructure.persistence.StockBalanceRepository;
import java.util.List;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/stock")
public class StockController {

    private final StockBalanceRepository balanceRepo;

    public StockController(StockBalanceRepository balanceRepo) {
        this.balanceRepo = balanceRepo;
    }

    @GetMapping("/balances")
    @Transactional(readOnly = true)
    public List<StockBalanceResponse> getBalances(
            @RequestParam(required = false) Long itemId,
            @RequestParam(required = false) Long warehouseId) {

        Long tenantId = TenantContext.getCurrentTenantId();

        if (itemId != null && warehouseId != null) {
            return balanceRepo.findByTenantIdAndItemIdAndWarehouseId(tenantId, itemId, warehouseId)
                .map(b -> List.of(StockBalanceResponse.from(b)))
                .orElseGet(List::of);
        } else if (itemId != null) {
            return balanceRepo.findByTenantIdAndItemId(tenantId, itemId).stream()
                .map(StockBalanceResponse::from)
                .toList();
        } else {
            return balanceRepo.findByTenantId(tenantId).stream()
                .map(StockBalanceResponse::from)
                .toList();
        }
    }
}

