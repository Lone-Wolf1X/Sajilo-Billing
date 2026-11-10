package com.saisa.app.platform;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DemoLeadRepository extends JpaRepository<DemoLead, Long> {
    List<DemoLead> findAllByOrderByCreatedAtDesc();
    List<DemoLead> findByStatusOrderByCreatedAtDesc(String status);
}

