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
import com.saisa.common.tenant.dto.OpeningStockRequest;
import com.saisa.common.tenant.dto.UpdateProfileRequest;
import com.saisa.inventory.api.dto.BulkItemRequest;
import com.saisa.inventory.api.dto.CreateItemRequest;
import com.saisa.inventory.api.dto.CreateWarehouseRequest;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
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

    @Test
    void completePhase3InventorySetupFlow() throws Exception {
        String tenantCode = "nepalinventory" + System.currentTimeMillis();

        // 1. Register tenant
        var reg = new RegisterTenantRequest(
            tenantCode,
            "Nepal Hardware & Tools",
            "admin",
            "admin@nepalhardware.com.np",
            "Pass@12345",
            "Hardware Admin"
        );
        String regRes = mvc.perform(post("/api/v1/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(reg)))
            .andExpect(status().isOk())
            .andReturn().getResponse().getContentAsString();

        String token = json.readTree(regRes).get("accessToken").asText();

        // 2. Open an Accounting Period
        var periodReq = Map.of(
            "periodName", "FY-2083/84-Q1",
            "startDate", "2026-07-16",
            "endDate", "2026-10-17"
        );
        mvc.perform(post("/api/v1/periods")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(periodReq)))
            .andExpect(status().isCreated());

        // 3. Test Bulk Item Creation: Duplicate SKU rejection
        var dupItemsReq = new BulkItemRequest(List.of(
            new CreateItemRequest("TOOL-001", "Hammer", "16oz Claw Hammer", "PCS", "8205", true, new BigDecimal("450.00"), new BigDecimal("300.00"), new BigDecimal("10")),
            new CreateItemRequest("TOOL-001", "Duplicate Hammer", "Different name", "PCS", "8205", true, new BigDecimal("450.00"), new BigDecimal("300.00"), new BigDecimal("10"))
        ));
        mvc.perform(post("/api/v1/items/bulk")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(dupItemsReq)))
            .andExpect(status().isBadRequest());

        // 4. Test Bulk Item Creation: Success
        var bulkItemsReq = new BulkItemRequest(List.of(
            new CreateItemRequest("TOOL-001", "Claw Hammer", "16oz Steel Claw Hammer", "PCS", "8205", true, new BigDecimal("550.00"), new BigDecimal("350.00"), new BigDecimal("10")),
            new CreateItemRequest("TOOL-002", "Hand Saw", "20-inch Hand Saw", "PCS", "8202", true, new BigDecimal("850.00"), new BigDecimal("600.00"), new BigDecimal("5")),
            new CreateItemRequest("TOOL-003", "Measuring Tape", "5m Steel Tape", "PCS", "9017", true, new BigDecimal("250.00"), new BigDecimal("150.00"), new BigDecimal("20"))
        ));
        String bulkRes = mvc.perform(post("/api/v1/items/bulk")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(bulkItemsReq)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.createdCount").value(3))
            .andExpect(jsonPath("$.items[0].sku").value("TOOL-001"))
            .andExpect(jsonPath("$.items[1].sku").value("TOOL-002"))
            .andExpect(jsonPath("$.items[2].sku").value("TOOL-003"))
            .andReturn().getResponse().getContentAsString();

        JsonNode itemsNode = json.readTree(bulkRes).get("items");
        long item1Id = itemsNode.get(0).get("id").asLong();
        long item2Id = itemsNode.get(1).get("id").asLong();

        // 5. Create Warehouse
        var whReq = new CreateWarehouseRequest("MAIN", "Main Godown / मुख्य गोदाम", "Lazimpat, Kathmandu", true);
        String whRes = mvc.perform(post("/api/v1/warehouses")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(whReq)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.code").value("MAIN"))
            .andReturn().getResponse().getContentAsString();

        long warehouseId = json.readTree(whRes).get("id").asLong();

        // 6. Post Opening Stock:
        // Item 1: 100 pcs @ Rs 350 = 35,000
        // Item 2: 50 pcs @ Rs 600 = 30,000
        // Total stock value = 65,000
        var stockReq = new OpeningStockRequest(
            LocalDate.of(2026, 7, 17),
            warehouseId,
            List.of(
                new OpeningStockRequest.OpeningStockLine(item1Id, new BigDecimal("100"), new BigDecimal("350.00")),
                new OpeningStockRequest.OpeningStockLine(item2Id, new BigDecimal("50"), new BigDecimal("600.00"))
            )
        );

        mvc.perform(post("/api/v1/setup/opening-stock")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(stockReq)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.posted").value(true))
            .andExpect(jsonPath("$.itemCount").value(2))
            .andExpect(jsonPath("$.totalQuantity").value(150.0))
            .andExpect(jsonPath("$.totalValue").value(65000.0));

        // 7. Verify Idempotency: Second call rejected
        mvc.perform(post("/api/v1/setup/opening-stock")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(stockReq)))
            .andExpect(status().is4xxClientError());

        // 8. Query Opening Stock Status
        mvc.perform(get("/api/v1/setup/opening-stock")
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.posted").value(true))
            .andExpect(jsonPath("$.totalValue").value(65000.0));

        // 9. Verify Trial Balance: INVENTORY_ASSET is debited and CAPITAL is credited
        mvc.perform(get("/api/v1/reports/trial-balance?asOf=2026-07-17")
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.balanced").value(true))
            .andExpect(jsonPath("$.rows[?(@.accountCode=='INVENTORY_ASSET')].debitBalance").value(65000.0))
            .andExpect(jsonPath("$.rows[?(@.accountCode=='CAPITAL')].creditBalance").value(65000.0));

        // 10. Complete Setup
        mvc.perform(post("/api/v1/setup/complete")
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.setupCompleted").value(true))
            .andExpect(jsonPath("$.setupStep").value(4));
    }
}
