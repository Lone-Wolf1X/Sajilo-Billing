package com.saisa.app.api;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

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
class CreditDebitNoteEndToEndTest {

    @Autowired private MockMvc mvc;
    @Autowired private ObjectMapper json;

    @Test
    void creditNoteReducesARAndGSTOutput() throws Exception {
        String token = registerAndLogin("cn-test", "admin", "a@cn.com");
        createPeriod(token);
        Long customerId = createCustomer(token);
        Long invoiceId = createInvoice(token, customerId, "INV-001");

        // Credit note: 2 items @ 1000, 18% GST = subtotal 2000, tax 360, total 2360
        mvc.perform(post("/api/v1/credit-notes")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of(
                    "creditNoteNumber", "CN-001",
                    "creditNoteDate", "2026-04-20",
                    "customerId", customerId,
                    "originalInvoiceId", invoiceId,
                    "reason", "Damaged goods returned",
                    "lines", List.of(Map.of(
                        "description", "Return",
                        "quantity", "2",
                        "unitPrice", "1000.00",
                        "taxRate", "0.18"
                    ))
                ))))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.subtotal").value(2000.0000))
            .andExpect(jsonPath("$.taxAmount").value(360.0000))
            .andExpect(jsonPath("$.totalAmount").value(2360.0000))
            .andExpect(jsonPath("$.journalEntryId").exists());

        // Verify trial balance still balanced
        mvc.perform(get("/api/v1/reports/trial-balance")
                .param("asOf", "2026-04-30")
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.balanced").value(true));
    }

    @Test
    void overCreditRejected() throws Exception {
        String token = registerAndLogin("cn-test2", "admin", "a@cn2.com");
        createPeriod(token);
        Long customerId = createCustomer(token);
        Long invoiceId = createInvoice(token, customerId, "INV-001");

        // Try to credit 50,000 against invoice - should fail with 422
        mvc.perform(post("/api/v1/credit-notes")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of(
                    "creditNoteNumber", "CN-001",
                    "creditNoteDate", "2026-04-20",
                    "customerId", customerId,
                    "originalInvoiceId", invoiceId,
                    "reason", "Test",
                    "lines", List.of(Map.of(
                        "description", "Excess Return",
                        "quantity", "50",
                        "unitPrice", "1000.00",
                        "taxRate", "0"
                    ))
                ))))
            .andExpect(status().isUnprocessableEntity());
    }

    private String registerAndLogin(String t, String u, String email) throws Exception {
        var reg = new RegisterTenantRequest(t, t + " Ltd", u, email, "password123", u);
        mvc.perform(post("/api/v1/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(reg)))
            .andExpect(status().isOk());
        var login = new LoginRequest(t, u, "password123");
        var r = mvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(login)))
            .andExpect(status().isOk()).andReturn();
        return json.readTree(r.getResponse().getContentAsString()).get("accessToken").asText();
    }

    private void createPeriod(String token) throws Exception {
        mvc.perform(post("/api/v1/periods")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of(
                    "periodName", "Apr-2026",
                    "startDate", "2026-04-01",
                    "endDate", "2026-04-30"))))
            .andExpect(status().isCreated());
    }

    private Long createCustomer(String token) throws Exception {
        var r = mvc.perform(post("/api/v1/customers")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of(
                    "customerCode", "C001", "customerName", "Ramesh"))))
            .andExpect(status().isCreated()).andReturn();
        return json.readTree(r.getResponse().getContentAsString()).get("id").asLong();
    }

    private Long createInvoice(String token, Long customerId, String number) throws Exception {
        var r = mvc.perform(post("/api/v1/sales-invoices")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of(
                    "invoiceNumber", number,
                    "invoiceDate", "2026-04-15",
                    "customerId", customerId,
                    "lines", List.of(Map.of(
                        "description", "Widget",
                        "quantity", "10",
                        "unitPrice", "1000.00",
                        "taxRate", "0.18"
                    ))
                ))))
            .andExpect(status().isCreated()).andReturn();
        return json.readTree(r.getResponse().getContentAsString()).get("id").asLong();
    }
}

