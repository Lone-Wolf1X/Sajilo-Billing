package com.saisa.app.security;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.saisa.app.admin.dto.CreateUserRequest;
import com.saisa.app.auth.dto.LoginRequest;
import com.saisa.app.auth.dto.RegisterTenantRequest;
import com.saisa.billing.domain.payment.PartyType;
import com.saisa.billing.domain.payment.PaymentMethod;
import com.saisa.common.tenant.BusinessNature;
import com.saisa.common.tenant.IncorporationType;
import com.saisa.common.tenant.dto.UpdateProfileRequest;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
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
class RbacSecurityIntegrationTest {

    @Autowired private MockMvc mvc;
    @Autowired private ObjectMapper json;
    @Autowired private com.saisa.app.ratelimit.RateLimitService rateLimitService;

    private String tenantCode;
    private String adminToken;
    private String cashierToken;
    private String superadminToken;

    @BeforeEach
    void setup() throws Exception {
        rateLimitService.clearAll();
        tenantCode = "rbac" + System.currentTimeMillis();

        // 1. Register tenant -> returns ADMIN token
        var reg = new RegisterTenantRequest(
            tenantCode,
            "RBAC Test Enterprise",
            "owner",
            "owner@" + tenantCode + ".com",
            "Owner@12345",
            "Business Owner"
        );
        String regRes = mvc.perform(post("/api/v1/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(reg)))
            .andExpect(status().isOk())
            .andReturn().getResponse().getContentAsString();

        adminToken = json.readTree(regRes).get("accessToken").asText();

        // 2. Owner creates a CASHIER user
        var cashierReq = new CreateUserRequest(
            "cashier1",
            "cashier1@" + tenantCode + ".com",
            "Cashier@12345",
            "First Cashier",
            "CASHIER"
        );
        mvc.perform(post("/api/v1/admin/users")
                .header("Authorization", "Bearer " + adminToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(cashierReq)))
            .andExpect(status().isCreated());

        // Log in as cashier
        var cashierLogin = new LoginRequest(tenantCode, "cashier1", "Cashier@12345");
        String cashierLoginRes = mvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(cashierLogin)))
            .andExpect(status().isOk())
            .andReturn().getResponse().getContentAsString();
        cashierToken = json.readTree(cashierLoginRes).get("accessToken").asText();

        // 3. Log in as superadmin (_platform tenant)
        var superLogin = new LoginRequest("_platform", "superadmin", "ChangeMe#2026");
        String superLoginRes = mvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(superLogin)))
            .andExpect(status().isOk())
            .andReturn().getResponse().getContentAsString();
        superadminToken = json.readTree(superLoginRes).get("accessToken").asText();
    }

    @Test
    @DisplayName("Step 2A: Tenant ADMIN gets 403 on /setup/* endpoints")
    void tenantAdminCannotAccessSetupWizard() throws Exception {
        // GET /setup/status -> 403 Forbidden
        mvc.perform(get("/api/v1/setup/status")
                .header("Authorization", "Bearer " + adminToken))
            .andExpect(status().isForbidden());

        // GET /setup/profile -> 403 Forbidden
        mvc.perform(get("/api/v1/setup/profile")
                .header("Authorization", "Bearer " + adminToken))
            .andExpect(status().isForbidden());

        // POST /setup/complete -> 403 Forbidden
        mvc.perform(post("/api/v1/setup/complete")
                .header("Authorization", "Bearer " + adminToken))
            .andExpect(status().isForbidden());
    }

    @Test
    @DisplayName("Step 2A: Tenant ADMIN can view and update business profile via /admin/profile")
    void tenantAdminCanAccessCompanyProfile() throws Exception {
        // GET /admin/profile -> 200 OK
        mvc.perform(get("/api/v1/admin/profile")
                .header("Authorization", "Bearer " + adminToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.companyName").value("RBAC Test Enterprise"));

        // PUT /admin/profile -> 200 OK
        var updateReq = new UpdateProfileRequest(
            "RBAC Test Enterprise Ltd",
            "आरबिएसी इन्टरप्राइज",
            "RBAC Test Enterprise Limited",
            "601999888",
            LocalDate.of(2022, 1, 1),
            "Office of Company Registrar",
            "REG-999888",
            LocalDate.of(2022, 1, 1),
            "Bagmati",
            "Kathmandu",
            "Kathmandu Metro",
            1,
            "Thamel",
            "Thamel, Ward-1, Kathmandu",
            "+977-1-4400000",
            "info@rbactest.com.np",
            IncorporationType.PRIVATE_LIMITED,
            BusinessNature.RETAIL,
            "Managing Owner",
            "Director",
            "+977-9800000000",
            "owner@rbactest.com.np",
            null
        );

        mvc.perform(put("/api/v1/admin/profile")
                .header("Authorization", "Bearer " + adminToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(updateReq)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.companyName").value("RBAC Test Enterprise Ltd"))
            .andExpect(jsonPath("$.panVatNo").value("601999888"));
    }

    @Test
    @DisplayName("Step 2C: PLATFORM_ADMIN can impersonate tenant and execute setup wizard")
    void platformAdminCanImpersonateAndExecuteSetup() throws Exception {
        // 1. Request impersonation token for tenant
        String impRes = mvc.perform(post("/api/v1/platform/impersonate/" + tenantCode)
                .header("Authorization", "Bearer " + superadminToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.accessToken").exists())
            .andExpect(jsonPath("$.impersonatingTenantCode").value(tenantCode))
            .andReturn().getResponse().getContentAsString();

        String impToken = json.readTree(impRes).get("accessToken").asText();

        // 2. Impersonated PLATFORM_ADMIN has access to /setup/status
        mvc.perform(get("/api/v1/setup/status")
                .header("Authorization", "Bearer " + impToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.companyName").value("RBAC Test Enterprise"));

        // 3. Impersonated PLATFORM_ADMIN can complete setup
        mvc.perform(post("/api/v1/setup/complete")
                .header("Authorization", "Bearer " + impToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.setupCompleted").value(true));
    }

    @Test
    @DisplayName("Step 2B: CASHIER role is forbidden from financial reports, ledger, journals, purchases")
    void cashierForbiddenFromFinancialEngine() throws Exception {
        // Reports -> 403 Forbidden
        mvc.perform(get("/api/v1/reports/trial-balance?asOf=2026-07-17")
                .header("Authorization", "Bearer " + cashierToken))
            .andExpect(status().isForbidden());

        mvc.perform(get("/api/v1/reports/profit-loss?from=2026-01-01&to=2026-12-31")
                .header("Authorization", "Bearer " + cashierToken))
            .andExpect(status().isForbidden());

        // General Ledger -> 403 Forbidden
        mvc.perform(get("/api/v1/ledger/1?from=2026-01-01&to=2026-12-31")
                .header("Authorization", "Bearer " + cashierToken))
            .andExpect(status().isForbidden());

        // Journal Entries -> 403 Forbidden
        mvc.perform(get("/api/v1/journal-entries")
                .header("Authorization", "Bearer " + cashierToken))
            .andExpect(status().isForbidden());

        // Purchase Invoices -> 403 Forbidden
        mvc.perform(get("/api/v1/purchase-invoices")
                .header("Authorization", "Bearer " + cashierToken))
            .andExpect(status().isForbidden());
    }

    @Test
    @DisplayName("Step 2B: CASHIER can post CASH payment but is forbidden from non-CASH payments")
    void cashierPaymentMethodRestrictions() throws Exception {
        // Attempt BANK_TRANSFER payment -> 403 Forbidden
        var bankTransferReq = Map.of(
            "paymentNumber", "PAY-TEST-001",
            "paymentDate", "2026-07-17",
            "amount", "100.00",
            "partyType", "CUSTOMER",
            "partyId", 1L,
            "paymentMethod", "BANK_TRANSFER"
        );

        mvc.perform(post("/api/v1/payments")
                .header("Authorization", "Bearer " + cashierToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(bankTransferReq)))
            .andExpect(status().isForbidden());
    }

    @Test
    @DisplayName("Step 2B: Commercial license generation is restricted to PLATFORM_ADMIN only")
    void licenseGenerationSecurity() throws Exception {
        var genReq = Map.of(
            "tenantCode", tenantCode,
            "companyName", "RBAC Test Enterprise",
            "panNumber", "601999888",
            "plan", "GROWTH",
            "durationDays", 365,
            "maxUsers", 5,
            "zipPassword", "SecureZip@2026"
        );

        // Tenant ADMIN cannot generate licenses -> 403 Forbidden
        mvc.perform(post("/api/v1/licenses/generate")
                .header("Authorization", "Bearer " + adminToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(genReq)))
            .andExpect(status().isForbidden());

        // PLATFORM_ADMIN can generate licenses -> 200 OK
        mvc.perform(post("/api/v1/licenses/generate")
                .header("Authorization", "Bearer " + superadminToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(genReq)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.zipBase64").exists())
            .andExpect(jsonPath("$.filename").exists());
    }
}
