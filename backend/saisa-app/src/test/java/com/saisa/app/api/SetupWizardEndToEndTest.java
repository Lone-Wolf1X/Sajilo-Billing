package com.saisa.app.api;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
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
import com.saisa.common.tenant.dto.OpeningBalanceRequest;
import com.saisa.common.tenant.dto.UpdateProfileRequest;
import java.time.LocalDate;
import java.util.Map;
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

    @Test
    void completeOpeningBalancesFlow() throws Exception {
        String tenantCode = "obtest" + System.currentTimeMillis();

        // 1. Register a new tenant
        var reg = new RegisterTenantRequest(
            tenantCode,
            "Everest Enterprise Pvt Ltd",
            "admin",
            "admin@everest.com.np",
            "Admin@12345",
            "Everest Admin"
        );
        String regRes = mvc.perform(post("/api/v1/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(reg)))
            .andExpect(status().isOk())
            .andReturn().getResponse().getContentAsString();

        JsonNode regNode = json.readTree(regRes);
        String token = regNode.get("accessToken").asText();

        // 2. Create accounting period for FY 2026-27 (2026-07-17 to 2027-07-16)
        var periodReq = Map.of(
            "periodName", "FY 2026-27",
            "startDate", "2026-07-17",
            "endDate", "2027-07-16"
        );
        mvc.perform(post("/api/v1/periods")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(periodReq)))
            .andExpect(status().isCreated());

        // 3. Verify initially no opening balances posted
        mvc.perform(get("/api/v1/setup/opening-balances")
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.posted").value(false));

        // 4. Try posting unbalanced manual capital (should fail)
        var unbalancedReq = new OpeningBalanceRequest(
            LocalDate.of(2026, 7, 17),
            "50000.00", null, null, null, null, null,
            null, null, null,
            "1000.00", null // Assets: 50,000 != Liabilities+Equity: 1,000
        );
        mvc.perform(post("/api/v1/setup/opening-balances")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(unbalancedReq)))
            .andExpect(status().is4xxClientError());

        // 5. Post balanced opening balances with auto-capital
        var validReq = new OpeningBalanceRequest(
            LocalDate.of(2026, 7, 17),
            "50000.00",    // Cash
            "500000.00",   // Bank
            "200000.00",   // AR
            "1000000.00",  // Fixed Assets
            null,          // Investments
            "50000.00",    // Other Assets
            "150000.00",   // AP
            "400000.00",   // Bank Loans
            "30000.00",    // Other Liabilities
            null,          // Capital (auto-computed = 1,800,000 - 580,000 = 1,220,000)
            null           // Retained Earnings
        );
        mvc.perform(post("/api/v1/setup/opening-balances")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(validReq)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.posted").value(true))
            .andExpect(jsonPath("$.balanced").value(true))
            .andExpect(jsonPath("$.totalDebits").value(1800000.0))
            .andExpect(jsonPath("$.totalCredits").value(1800000.0))
            .andExpect(jsonPath("$.totalAssets").value(1800000.0))
            .andExpect(jsonPath("$.totalLiabilities").value(580000.0))
            .andExpect(jsonPath("$.totalEquity").value(1220000.0));

        // 6. Verify trial balance is balanced
        mvc.perform(get("/api/v1/reports/trial-balance?asOf=2026-07-17")
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.balanced").value(true));

        // 7. Verify setup status has advanced to at least step 2
        mvc.perform(get("/api/v1/setup/status")
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.setupStep").value(2));

        // 8. Reset via reversal
        mvc.perform(delete("/api/v1/setup/opening-balances?reason=Wrong amounts")
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isNoContent());

        // 9. Verify opening balance is cleared
        mvc.perform(get("/api/v1/setup/opening-balances")
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.posted").value(false));

        // 10. Re-post with corrected values
        var rePostReq = new OpeningBalanceRequest(
            LocalDate.of(2026, 7, 17),
            "60000.00",
            "500000.00",
            "200000.00",
            "1000000.00",
            null,
            null,
            "150000.00",
            "400000.00",
            null,
            null,
            null
        );
        mvc.perform(post("/api/v1/setup/opening-balances")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(rePostReq)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.posted").value(true))
            .andExpect(jsonPath("$.balanced").value(true))
            .andExpect(jsonPath("$.totalDebits").value(1760000.0))
            .andExpect(jsonPath("$.totalCredits").value(1760000.0));
    }
}
