package com.saisa.app.api;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.saisa.app.auth.dto.RegisterTenantRequest;
import com.saisa.common.tenant.BusinessNature;
import com.saisa.common.tenant.IncorporationType;
import com.saisa.common.tenant.dto.UpdateProfileRequest;
import java.time.LocalDate;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class SetupWizardEndToEndTest {

    @Autowired private MockMvc mvc;
    @Autowired private ObjectMapper json;

    @Test
    void completeBusinessProfileSetupFlow() throws Exception {
        String tenantCode = "nepalbiz" + System.currentTimeMillis();

        // 1. Register a new tenant
        var reg = new RegisterTenantRequest(
            tenantCode,
            "Himalayan Traders Pvt Ltd",
            "admin",
            "admin@himalayantraders.com.np",
            "Pass@12345",
            "Himalayan Admin"
        );
        String regRes = mvc.perform(post("/api/v1/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(reg)))
            .andExpect(status().isOk())
            .andReturn().getResponse().getContentAsString();

        JsonNode regNode = json.readTree(regRes);
        String token = regNode.get("accessToken").asText();

        // 2. Check initial setup status
        mvc.perform(get("/api/v1/setup/status")
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.setupCompleted").value(false))
            .andExpect(jsonPath("$.setupStep").value(1))
            .andExpect(jsonPath("$.companyName").value("Himalayan Traders Pvt Ltd"));

        // 3. Check locations & registration authorities catalog
        mvc.perform(get("/api/v1/setup/registration-authorities")
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$['Office of the Company Registrar'].np").value("कम्पनी रजिष्ट्रारको कार्यालय"));

        mvc.perform(get("/api/v1/setup/locations")
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.provinces[0].en").exists());

        // 4. Update Profile (Phase 1)
        var updateReq = new UpdateProfileRequest(
            "Himalayan Traders Pvt. Ltd.",
            "हिमालयन ट्रेडर्स प्रा. लि.",
            "Himalayan Traders Private Limited",
            "601234567",
            LocalDate.of(2021, 4, 14),
            "Office of the Company Registrar",
            "OCR-2078-1092",
            LocalDate.of(2021, 4, 1),
            "Bagmati Province",
            "Kathmandu",
            "Kathmandu Metropolitan City",
            3,
            "Lazimpat",
            "Lazimpat, Ward-3, Kathmandu",
            "+977-1-4412345",
            "contact@himalayantraders.com.np",
            IncorporationType.PRIVATE_LIMITED,
            BusinessNature.TRADING,
            "Pasang Sherpa",
            "Managing Director",
            "+977-9841234567",
            "pasang@himalayantraders.com.np",
            2
        );

        mvc.perform(put("/api/v1/setup/profile")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(updateReq)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.companyName").value("Himalayan Traders Pvt. Ltd."))
            .andExpect(jsonPath("$.companyNameNepali").value("हिमालयन ट्रेडर्स प्रा. लि."))
            .andExpect(jsonPath("$.panVatNo").value("601234567"))
            .andExpect(jsonPath("$.pan").value("601234567"))
            .andExpect(jsonPath("$.province").value("Bagmati Province"))
            .andExpect(jsonPath("$.district").value("Kathmandu"))
            .andExpect(jsonPath("$.wardNo").value(3))
            .andExpect(jsonPath("$.incorporationType").value("PRIVATE_LIMITED"))
            .andExpect(jsonPath("$.businessNature").value("TRADING"))
            .andExpect(jsonPath("$.authorizedPersonName").value("Pasang Sherpa"))
            .andExpect(jsonPath("$.setupStep").value(2));

        // 5. Get Profile and verify persistence
        mvc.perform(get("/api/v1/setup/profile")
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.companyNameNepali").value("हिमालयन ट्रेडर्स प्रा. लि."))
            .andExpect(jsonPath("$.authorizedPersonDesignation").value("Managing Director"))
            .andExpect(jsonPath("$.registrationAuthority").value("Office of the Company Registrar"));

        // 6. Complete Setup
        mvc.perform(post("/api/v1/setup/complete")
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.setupCompleted").value(true))
            .andExpect(jsonPath("$.setupStep").value(4));

        // 7. Status reflects completion
        mvc.perform(get("/api/v1/setup/status")
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.setupCompleted").value(true))
            .andExpect(jsonPath("$.setupStep").value(4));
    }
}
