package com.saisa.app.api;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.saisa.app.auth.dto.LoginRequest;
import com.saisa.app.auth.dto.RegisterTenantRequest;
import java.time.LocalDate;
import java.util.Map;
import org.junit.jupiter.api.BeforeEach;
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
class CrossTenantIsolationTest {

    @Autowired private MockMvc mvc;
    @Autowired private ObjectMapper json;

    private String tokenA;
    private String tokenB;
    private Long accountAId;

    @BeforeEach
    void setUp() throws Exception {
        tokenA = registerAndLogin("tenant-a", "admin-a", "admina@a.com");
        tokenB = registerAndLogin("tenant-b", "admin-b", "adminb@b.com");

        // A creates an account
        var createResp = mvc.perform(post("/api/v1/accounts")
                .header("Authorization", "Bearer " + tokenA)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of(
                    "accountCode", "1001",
                    "accountName", "Cash A",
                    "accountType", "ASSET"
                ))))
            .andExpect(status().isCreated())
            .andReturn();
        accountAId = json.readTree(createResp.getResponse().getContentAsString())
            .get("id").asLong();
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
        JsonNode body = json.readTree(resp.getResponse().getContentAsString());
        return body.get("accessToken").asText();
    }

    @Test
    void tenantBCannotReadTenantAAccount() throws Exception {
        mvc.perform(get("/api/v1/accounts/" + accountAId)
                .header("Authorization", "Bearer " + tokenB))
            .andExpect(status().isNotFound());  // 404, NOT 403 (info leak prevention)
    }

    @Test
    void tenantBSeeOnlyOwnAccounts() throws Exception {
        mvc.perform(get("/api/v1/accounts")
                .header("Authorization", "Bearer " + tokenB))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.length()").value(10));  // B has 10 seeded system accounts
    }

    @Test
    void tenantACannotUseTenantBPeriodInJournalEntry() throws Exception {
        // A creates a period for themselves
        var pA = mvc.perform(post("/api/v1/periods")
                .header("Authorization", "Bearer " + tokenA)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of(
                    "periodName", "Apr-2026",
                    "startDate", "2026-04-01",
                    "endDate", "2026-04-30"
                ))))
            .andExpect(status().isCreated())
            .andReturn();
        Long periodAId = json.readTree(pA.getResponse().getContentAsString())
            .get("id").asLong();

        // B tries to use A's period
        var entry = Map.of(
            "entryDate", "2026-04-15",
            "periodId", periodAId,
            "entryType", "MANUAL",
            "lines", java.util.List.of(
                Map.of("accountId", accountAId, "side", "DEBIT", "amount", "100.00"),
                Map.of("accountId", accountAId, "side", "CREDIT", "amount", "100.00")
            )
        );
        mvc.perform(post("/api/v1/journal-entries")
                .header("Authorization", "Bearer " + tokenB)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(entry)))
            .andExpect(status().isNotFound());  // Period not in B's tenant → 404
    }

    @Test
    void unauthenticatedRequestRejected() throws Exception {
        mvc.perform(get("/api/v1/accounts"))
            .andExpect(status().isUnauthorized());
    }
}
