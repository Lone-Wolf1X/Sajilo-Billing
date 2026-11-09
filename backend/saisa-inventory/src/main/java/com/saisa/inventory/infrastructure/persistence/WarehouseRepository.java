package com.saisa.inventory.infrastructure.persistence;

import com.saisa.inventory.domain.warehouse.Warehouse;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface WarehouseRepository extends JpaRepository<Warehouse, Long> {

    Optional<Warehouse> findByTenantIdAndCode(Long tenantId, String code);

    boolean existsByTenantIdAndCode(Long tenantId, String code);

    Optional<Warehouse> findFirstByTenantIdAndDefaultWarehouseTrue(Long tenantId);

    List<Warehouse> findByTenantIdAndActiveTrue(Long tenantId);

    Optional<Warehouse> findByTenantIdAndId(Long tenantId, Long id);
}

