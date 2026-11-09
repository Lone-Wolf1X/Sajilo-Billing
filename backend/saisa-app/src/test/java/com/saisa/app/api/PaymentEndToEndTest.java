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
class PaymentEndToEndTest {

    @Autowired private MockMvc mvc;
    @Autowired private ObjectMapper json;

    @Test
    void partialAndFullPaymentsClearAR() throws Exception {
        String token = registerAndLogin("acme", "admin", "admin@acme.com");
        Long periodId = createPeriod(token);
        Long customerId = createCustomer(token);

        // Post sales invoice: 10 items @ 1000, 18% GST = 11,800
        Long invoiceId = createSalesInvoice(token, customerId, "INV-001", "11800.0000");

        // Partial payment: 5,000 cash
        Long paymentId = createPayment(token, "PAY-001", "5000.00",
            "CUSTOMER", customerId, "CASH", null,
            List.of(Map.of("invoiceType", "SALES", "invoiceId", invoiceId, "amount", "5000.00")));

        // AR aging: outstanding = 11,800 - 5,000 = 6,800
        mvc.perform(get("/api/v1/reports/ar-aging")
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.totalOutstanding").value(6800.0000))
            .andExpect(jsonPath("$.rows.length()").value(1));

        // Second payment: 6,800 cash (full)
        createPayment(token, "PAY-002", "6800.00",
            "CUSTOMER", customerId, "CASH", null,
            List.of(Map.of("invoiceType", "SALES", "invoiceId", invoiceId, "amount", "6800.00")));

        // AR aging: outstanding = 0
        mvc.perform(get("/api/v1/reports/ar-aging")
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.totalOutstanding").value(0))
            .andExpect(jsonPath("$.rows.length()").value(0));

        // Trial balance should still be balanced
        mvc.perform(get("/api/v1/reports/trial-balance")
                .param("asOf", "2026-04-30")
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.balanced").value(true));
    }

    @Test
    void overpaymentRejected() throws Exception {
        String token = registerAndLogin("acme2", "admin", "admin@acme2.com");
        Long periodId = createPeriod(token);
        Long customerId = createCustomer(token);
        Long invoiceId = createSalesInvoice(token, customerId, "INV-001", "11800.0000");

        mvc.perform(post("/api/v1/payments")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of(
                    "paymentNumber", "PAY-001",
                    "paymentDate", "2026-04-20",
                    "amount", "12000.00",
                    "partyType", "CUSTOMER",
                    "partyId", customerId,
                    "paymentMethod", "CASH",
                    "allocations", List.of(Map.of(
                        "invoiceType", "SALES",
                        "invoiceId", invoiceId,
                        "amount", "12000.00"
                    ))
                ))))
            .andExpect(status().isUnprocessableEntity());
    }

    private Long createPeriod(String token) throws Exception {
        var r = mvc.perform(post("/api/v1/periods")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of(
                    "periodName", "Apr-2026",
                    "startDate", "2026-04-01",
                    "endDate", "2026-04-30"
                ))))
            .andExpect(status().isCreated())
            .andReturn();
        return json.readTree(r.getResponse().getContentAsString()).get("id").asLong();
    }

    private Long createCustomer(String token) throws Exception {
        var r = mvc.perform(post("/api/v1/customers")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of(
                    "customerCode", "C001", "customerName", "Ramesh"
                ))))
            .andExpect(status().isCreated())
            .andReturn();
        return json.readTree(r.getResponse().getContentAsString()).get("id").asLong();
    }

    private Long createSalesInvoice(String token, Long customerId,
                                    String number, String total) throws Exception {
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
            .andExpect(status().isCreated())
            .andReturn();
        var body = json.readTree(r.getResponse().getContentAsString());
        return body.get("id").asLong();
    }

    private Long createPayment(String token, String number, String amount,
                               String partyType, Long partyId, String method,
                               Long bankAccountId, List<Map<String, Object>> allocations)
            throws Exception {
        var payload = new java.util.HashMap<String, Object>();
        payload.put("paymentNumber", number);
        payload.put("paymentDate", "2026-04-20");
        payload.put("amount", amount);
        payload.put("partyType", partyType);
        payload.put("partyId", partyId);
        payload.put("paymentMethod", method);
        if (bankAccountId != null) payload.put("bankAccountId", bankAccountId);
        payload.put("allocations", allocations);

        var r = mvc.perform(post("/api/v1/payments")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(payload)))
            .andExpect(status().isCreated())
            .andReturn();
        return json.readTree(r.getResponse().getContentAsString()).get("id").asLong();
    }

    private String registerAndLogin(String tenant, String user, String email) throws Exception {
        var reg = new RegisterTenantRequest(tenant, tenant + " Ltd", user, email,
            "password123", user);
        mvc.perform(post("/api/v1/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(reg)))
            .andExpect(status().isOk());

        var login = new LoginRequest(tenant, user, "password123");
        var r = mvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(login)))
            .andExpect(status().isOk())
            .andReturn();
        return json.readTree(r.getResponse().getContentAsString())
            .get("accessToken").asText();
    }
}

