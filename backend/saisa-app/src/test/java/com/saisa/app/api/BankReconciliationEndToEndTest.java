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
class BankReconciliationEndToEndTest {

    @Autowired private MockMvc mvc;
    @Autowired private ObjectMapper json;

    @Test
    void autoMatchThenReconcileToZero() throws Exception {
        String token = registerAndLogin("brecon", "admin", "a@brecon.com");
        createPeriod(token);

        // Create bank account linked to BANK system account
        Long bankGlId = getSystemAccountId(token, "BANK");
        Long bankId = createBankAccount(token, bankGlId, "HDFC");

        // Create a customer + payment of 5000 via bank transfer
        Long customerId = createCustomer(token);
        Long paymentId = createPayment(token, customerId, bankId, "5000", "PAY-001");

        // Add matching statement line (bank credit, i.e., money in)
        Long lineId = addStatementLine(token, bankId, "5000", "0", "PAY-001");

        // Auto-match
        mvc.perform(post("/api/v1/bank-reconciliation/auto-match")
                .param("bankAccountId", bankId.toString())
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.matched").value(1));

        // After match, reconciliation should show balanced
        mvc.perform(get("/api/v1/bank-reconciliation/summary")
                .param("bankAccountId", bankId.toString())
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.reconciled").value(true));
    }

    @Test
    void manualMatchAndUnmatchFlow() throws Exception {
        String token = registerAndLogin("bmanual", "admin", "a@bmanual.com");
        createPeriod(token);

        Long bankGlId = getSystemAccountId(token, "BANK");
        Long bankId = createBankAccount(token, bankGlId, "ICICI");

        Long customerId = createCustomer(token);
        Long paymentId = createPayment(token, customerId, bankId, "3000", "PAY-300");

        // Statement line without reference matching
        Long lineId = addStatementLine(token, bankId, "3000", "0", "DIFF-REF");

        // Manual match
        mvc.perform(post("/api/v1/bank-reconciliation/match")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of(
                    "statementLineId", lineId,
                    "paymentId", paymentId
                ))))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.status").value("MATCHED"))
            .andExpect(jsonPath("$.matchedPaymentId").value(paymentId));

        // Unmatch
        mvc.perform(post("/api/v1/bank-reconciliation/lines/" + lineId + "/unmatch")
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.status").value("UNMATCHED"))
            .andExpect(jsonPath("$.matchedPaymentId").doesNotExist());
    }

    @Test
    void bankAdjustmentPostsJournalEntry() throws Exception {
        String token = registerAndLogin("badjust", "admin", "a@badjust.com");
        createPeriod(token);

        Long bankGlId = getSystemAccountId(token, "BANK");
        Long bankId = createBankAccount(token, bankGlId, "SBI");

        // Post bank charge adjustment of 250
        mvc.perform(post("/api/v1/bank-adjustments")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of(
                    "bankAccountId", bankId,
                    "adjustmentDate", "2026-04-20",
                    "type", "BANK_CHARGE",
                    "amount", "250.00",
                    "description", "Monthly maintenance charge",
                    "idempotencyKey", "ADJ-CHG-001"
                ))))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.journalEntryId").isNumber());
    }

    // --- helpers ---

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
                    "startDate", "2026-04-01", "endDate", "2026-04-30"))))
            .andExpect(status().isCreated());
    }

    private Long getSystemAccountId(String token, String code) throws Exception {
        var r = mvc.perform(get("/api/v1/accounts")
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk()).andReturn();
        for (JsonNode n : json.readTree(r.getResponse().getContentAsString())) {
            if (code.equals(n.get("accountCode").asText())) {
                return n.get("id").asLong();
            }
        }
        throw new RuntimeException("System account missing: " + code);
    }

    private Long createBankAccount(String token, Long glId, String name) throws Exception {
        var r = mvc.perform(post("/api/v1/bank-accounts")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of(
                    "accountCode", "HDFC-001",
                    "accountName", name,
                    "bankName", name,
                    "glAccountId", glId,
                    "defaultAccount", true
                ))))
            .andExpect(status().isCreated()).andReturn();
        return json.readTree(r.getResponse().getContentAsString()).get("id").asLong();
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

    private Long createPayment(String token, Long customerId, Long bankId,
                                String amount, String number) throws Exception {
        var r = mvc.perform(post("/api/v1/payments")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of(
                    "paymentNumber", number,
                    "paymentDate", "2026-04-15",
                    "amount", amount,
                    "partyType", "CUSTOMER",
                    "partyId", customerId,
                    "paymentMethod", "BANK_TRANSFER",
                    "bankAccountId", bankId,
                    "referenceNo", number
                ))))
            .andExpect(status().isCreated()).andReturn();
        return json.readTree(r.getResponse().getContentAsString()).get("id").asLong();
    }

    private Long addStatementLine(String token, Long bankId,
                                   String credit, String debit, String ref)
            throws Exception {
        var r = mvc.perform(post("/api/v1/bank-reconciliation/lines")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of(
                    "bankAccountId", bankId,
                    "statementDate", "2026-04-16",
                    "description", "Incoming NEFT",
                    "referenceNo", ref,
                    "creditAmount", credit,
                    "debitAmount", debit
                ))))
            .andExpect(status().isCreated()).andReturn();
        return json.readTree(r.getResponse().getContentAsString()).get("id").asLong();
    }
}
