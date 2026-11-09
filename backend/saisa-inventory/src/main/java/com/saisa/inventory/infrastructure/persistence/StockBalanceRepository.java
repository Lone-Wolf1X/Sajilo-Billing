package com.saisa.inventory.infrastructure.persistence;

import com.saisa.inventory.domain.movement.StockBalance;
import jakarta.persistence.LockModeType;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface StockBalanceRepository extends JpaRepository<StockBalance, Long> {

    Optional<StockBalance> findByTenantIdAndItemIdAndWarehouseId(Long tenantId, Long itemId, Long warehouseId);

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("SELECT b FROM StockBalance b WHERE b.tenantId = :tenantId AND b.itemId = :itemId AND b.warehouseId = :warehouseId")
    Optional<StockBalance> findForUpdate(@Param("tenantId") Long tenantId,
                                         @Param("itemId") Long itemId,
                                         @Param("warehouseId") Long warehouseId);

    List<StockBalance> findByTenantIdAndItemId(Long tenantId, Long itemId);

    List<StockBalance> findByTenantId(Long tenantId);
}

