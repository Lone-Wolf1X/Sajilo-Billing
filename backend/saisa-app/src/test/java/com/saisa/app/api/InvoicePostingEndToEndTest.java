package com.saisa.app.api;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.saisa.app.auth.dto.LoginRequest;
import com.saisa.app.auth.dto.RegisterTenantRequest;
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
class InvoicePostingEndToEndTest {

    @Autowired private MockMvc mvc;
    @Autowired private ObjectMapper json;

    @Test
    void salesInvoicePostingCreatesBalancedJournalEntry() throws Exception {
        // Setup tenant + login
        String token = registerAndLogin("acme", "admin", "admin@acme.com");

        // Create a period
        var p = mvc.perform(post("/api/v1/periods")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of(
                    "periodName", "Apr-2026",
                    "startDate", "2026-04-01",
                    "endDate", "2026-04-30"
                ))))
            .andExpect(status().isCreated())
            .andReturn();
        Long periodId = json.readTree(p.getResponse().getContentAsString()).get("id").asLong();

        // Create a customer
        var c = mvc.perform(post("/api/v1/customers")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of(
                    "customerCode", "CUST-001",
                    "customerName", "Ramesh Trader"
                ))))
            .andExpect(status().isCreated())
            .andReturn();
        Long customerId = json.readTree(c.getResponse().getContentAsString()).get("id").asLong();

        // Post sales invoice: 10 items @ 1000, 18% GST
        var inv = mvc.perform(post("/api/v1/sales-invoices")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of(
                    "invoiceNumber", "INV-001",
                    "invoiceDate", "2026-04-15",
                    "customerId", customerId,
                    "lines", java.util.List.of(Map.of(
                        "description", "Widget",
                        "quantity", "10",
                        "unitPrice", "1000.00",
                        "taxRate", "0.18"
                    ))
                ))))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.subtotal").value(10000.0000))
            .andExpect(jsonPath("$.taxAmount").value(1800.0000))
            .andExpect(jsonPath("$.totalAmount").value(11800.0000))
            .andReturn();

        JsonNode invoiceBody = json.readTree(inv.getResponse().getContentAsString());
        Long journalEntryId = invoiceBody.get("journalEntryId").asLong();

        // Verify journal entry exists and is balanced
        mvc.perform(get("/api/v1/journal-entries/" + journalEntryId)
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.status").value("POSTED"))
            .andExpect(jsonPath("$.entryType").value("SALES"))
            .andExpect(jsonPath("$.lines.length()").value(3));

        // Verify Trial Balance is balanced
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
