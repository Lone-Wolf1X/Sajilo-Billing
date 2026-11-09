package com.saisa.inventory.infrastructure.persistence;

import com.saisa.inventory.domain.movement.StockMovement;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface StockMovementRepository extends JpaRepository<StockMovement, Long> {

    Optional<StockMovement> findFirstByTenantIdAndReferenceTypeAndReferenceIdAndItemId(
        Long tenantId, String referenceType, Long referenceId, Long itemId);

    List<StockMovement> findByTenantIdAndItemIdOrderByMovementDateAscIdAsc(Long tenantId, Long itemId);
}

