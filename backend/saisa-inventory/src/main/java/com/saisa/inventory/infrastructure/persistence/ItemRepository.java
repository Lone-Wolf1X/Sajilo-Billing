package com.saisa.inventory.infrastructure.persistence;

import com.saisa.inventory.domain.item.Item;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ItemRepository extends JpaRepository<Item, Long> {

    Optional<Item> findByTenantIdAndSku(Long tenantId, String sku);

    boolean existsByTenantIdAndSku(Long tenantId, String sku);

    List<Item> findByTenantIdAndActiveTrueOrderBySku(Long tenantId);

    Optional<Item> findByTenantIdAndId(Long tenantId, Long id);
}

