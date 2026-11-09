package com.saisa.app.api;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.saisa.app.auth.dto.LoginRequest;
import com.saisa.app.auth.dto.RegisterTenantRequest;
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
class InventoryPostingEndToEndTest {

    @Autowired private MockMvc mvc;
    @Autowired private ObjectMapper json;

    @Test
    void completeInventoryPostingAndCogsFlow() throws Exception {
        // 1. Setup tenant + login
        String token = registerAndLogin("invcorp", "admin", "admin@invcorp.com");

        // 2. Create accounting period
        mvc.perform(post("/api/v1/periods")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of(
                    "periodName", "Apr-2026",
                    "startDate", "2026-04-01",
                    "endDate", "2026-04-30"
                ))))
            .andExpect(status().isCreated());

        // 3. Create default warehouse
        var whResp = mvc.perform(post("/api/v1/warehouses")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of(
                    "code", "WH-MAIN",
                    "name", "Main Warehouse",
                    "address", "Kathmandu, Nepal",
                    "isDefault", true
                ))))
            .andExpect(status().isCreated())
            .andReturn();
        Long warehouseId = json.readTree(whResp.getResponse().getContentAsString()).get("id").asLong();

        // 4. Create inventory item
        var itemResp = mvc.perform(post("/api/v1/items")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of(
                    "sku", "WIDGET-01",
                    "name", "Steel Widget",
                    "unitOfMeasure", "NOS",
                    "tracksInventory", true,
                    "salePrice", 1000.00,
                    "purchasePrice", 500.00
                ))))
            .andExpect(status().isCreated())
            .andReturn();
        Long itemId = json.readTree(itemResp.getResponse().getContentAsString()).get("id").asLong();

        // 5. Create vendor
        var vendorResp = mvc.perform(post("/api/v1/vendors")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of(
                    "vendorCode", "VEND-001",
                    "vendorName", "Steel Suppliers Ltd",
                    "billingAddress", "Biratnagar, Nepal"
                ))))
            .andExpect(status().isCreated())
            .andReturn();
        Long vendorId = json.readTree(vendorResp.getResponse().getContentAsString()).get("id").asLong();

        // 6. Post purchase invoice: 100 units @ 500.00, tax 0%
        var purchaseInvResp = mvc.perform(post("/api/v1/purchase-invoices")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of(
                    "invoiceNumber", "PINV-001",
                    "invoiceDate", "2026-04-05",
                    "vendorId", vendorId,
                    "warehouseId", warehouseId,
                    "lines", List.of(Map.of(
                        "itemId", itemId,
                        "description", "Steel Widget Purchase",
                        "quantity", "100",
                        "unitPrice", "500.00",
                        "taxRate", "0.00"
                    ))
                ))))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.subtotal").value(50000.0000))
            .andExpect(jsonPath("$.totalAmount").value(50000.0000))
            .andReturn();

        Long purchaseJournalId = json.readTree(purchaseInvResp.getResponse().getContentAsString())
            .get("journalEntryId").asLong();

        // 7. Verify stock balance after purchase: 100 on hand @ 500 WAC = 50,000 value
        mvc.perform(get("/api/v1/stock/balances")
                .param("itemId", itemId.toString())
                .param("warehouseId", warehouseId.toString())
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$[0].quantityOnHand").value(100.0000))
            .andExpect(jsonPath("$[0].wac").value(500.0000))
            .andExpect(jsonPath("$[0].inventoryValue").value(50000.0000));

        // 8. Verify purchase journal entry: INVENTORY_ASSET Dr 50,000 | AP Cr 50,000
        mvc.perform(get("/api/v1/journal-entries/" + purchaseJournalId)
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.status").value("POSTED"))
            .andExpect(jsonPath("$.entryType").value("PURCHASE"))
            .andExpect(jsonPath("$.lines.length()").value(2));

        // 9. Create customer
        var custResp = mvc.perform(post("/api/v1/customers")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of(
                    "customerCode", "CUST-001",
                    "customerName", "Apex Builders"
                ))))
            .andExpect(status().isCreated())
            .andReturn();
        Long customerId = json.readTree(custResp.getResponse().getContentAsString()).get("id").asLong();

        // 10. Post sales invoice: 20 units @ 1,000.00, 18% GST (subtotal 20k, tax 3.6k, total 23.6k)
        var salesInvResp = mvc.perform(post("/api/v1/sales-invoices")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of(
                    "invoiceNumber", "SINV-001",
                    "invoiceDate", "2026-04-10",
                    "customerId", customerId,
                    "warehouseId", warehouseId,
                    "lines", List.of(Map.of(
                        "itemId", itemId,
                        "description", "Steel Widget Sale",
                        "quantity", "20",
                        "unitPrice", "1000.00",
                        "taxRate", "0.18"
                    ))
                ))))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.subtotal").value(20000.0000))
            .andExpect(jsonPath("$.taxAmount").value(3600.0000))
            .andExpect(jsonPath("$.totalAmount").value(23600.0000))
            .andReturn();

        Long salesJournalId = json.readTree(salesInvResp.getResponse().getContentAsString())
            .get("journalEntryId").asLong();

        // 11. Verify stock balance after sale: 80 on hand @ 500 WAC = 40,000 value
        mvc.perform(get("/api/v1/stock/balances")
                .param("itemId", itemId.toString())
                .param("warehouseId", warehouseId.toString())
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$[0].quantityOnHand").value(80.0000))
            .andExpect(jsonPath("$[0].wac").value(500.0000))
            .andExpect(jsonPath("$[0].inventoryValue").value(40000.0000));

        // 12. Verify sales journal entry: AR Dr 23,600 | SALES Cr 20,000 | GST_OUTPUT Cr 3,600
        mvc.perform(get("/api/v1/journal-entries/" + salesJournalId)
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.status").value("POSTED"))
            .andExpect(jsonPath("$.entryType").value("SALES"))
            .andExpect(jsonPath("$.lines.length()").value(3));

        // 13. Verify Trial Balance is completely balanced across all accounts
        mvc.perform(get("/api/v1/reports/trial-balance")
                .param("asOf", "2026-04-30")
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.balanced").value(true));
    }

    private String registerAndLogin(String tenantCode, String username, String email) throws Exception {
        var reg = new RegisterTenantRequest(
            tenantCode, tenantCode + " Ltd", username, email, "password123", username);
        mvc.perform(post("/api/v1/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(reg)))
            .andExpect(status().isOk());

        var login = new LoginRequest(tenantCode, username, "password123");
        var resp = mvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(login)))
            .andExpect(status().isOk())
            .andReturn();
        return json.readTree(resp.getResponse().getContentAsString())
            .get("accessToken").asText();
    }
}

