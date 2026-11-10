package com.saisa.common.user;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByTenantIdAndUsername(Long tenantId, String username);

    Optional<User> findFirstByEmailIgnoreCase(String email);

    Optional<User> findByTenantIdAndEmailIgnoreCase(Long tenantId, String email);

    boolean existsByTenantIdAndUsername(Long tenantId, String username);

    boolean existsByTenantIdAndEmail(Long tenantId, String email);

    java.util.List<User> findByTenantId(Long tenantId);

    java.util.List<User> findByTenantIdOrderByUsername(Long tenantId);

    long countByTenantId(Long tenantId);
}

