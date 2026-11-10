package com.saisa.app.platform;

import com.saisa.app.platform.dto.PublicDemoRequest;
import com.saisa.app.platform.dto.PublicDemoResponse;
import jakarta.validation.Valid;
import java.time.Instant;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/public")
public class PublicDemoController {

    private final DemoLeadRepository demoLeadRepo;

    public PublicDemoController(DemoLeadRepository demoLeadRepo) {
        this.demoLeadRepo = demoLeadRepo;
    }

    @PostMapping("/demo-request")
    public ResponseEntity<PublicDemoResponse> submitDemoRequest(@Valid @RequestBody PublicDemoRequest req) {
        DemoLead lead = new DemoLead();
        lead.setFullName(req.fullName().trim());
        lead.setEmail(req.email().trim().toLowerCase());
        lead.setPhone(req.phone().trim());
        lead.setCompanyName(req.companyName().trim());
        lead.setCity(req.city() != null ? req.city().trim() : null);
        lead.setNotes(req.notes() != null ? req.notes().trim() : null);
        lead.setStatus("WAITING");
        lead.setRequestedPlan("DEMO_TRIAL");
        lead.setCreatedAt(Instant.now());
        lead.setUpdatedAt(Instant.now());

        lead = demoLeadRepo.save(lead);

        return ResponseEntity.status(HttpStatus.CREATED).body(new PublicDemoResponse(
            lead.getId(),
            "WAITING",
            "तपाईंको डेमो अनुरोध दर्ता भयो। टोलीले छिट्टै समीक्षा गरी पूर्ण सेवा सक्रिय गर्नेछ। (Demo request registered successfully.)",
            "/downloads/sajilo_billing_mac.dmg",
            "/downloads/sajilo_billing_windows.exe"
        ));
    }
}

