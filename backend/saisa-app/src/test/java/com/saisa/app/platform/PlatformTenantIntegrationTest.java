package com.saisa.app.platform;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.saisa.app.auth.dto.LoginRequest;
import com.saisa.app.platform.dto.CreateTenantRequest;
import com.saisa.app.ratelimit.RateLimitService;
import com.saisa.common.tenant.Tenant;
import com.saisa.common.tenant.TenantRepository;
import com.saisa.financial.infrastructure.persistence.ChartOfAccountRepository;
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
class PlatformTenantIntegrationTest {

    @Autowired private MockMvc mockMvc;
    @Autowired private ObjectMapper json;
    @Autowired private TenantRepository tenantRepo;
    @Autowired private ChartOfAccountRepository accountRepo;
    @Autowired private RateLimitService rateLimitService;

    @BeforeEach
    void setUp() {
        rateLimitService.clearAll();
    }

    private String loginSuperadmin() throws Exception {
        var login = new LoginRequest("_platform", "superadmin", "ChangeMe#2026");
        var res = mockMvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(login)))
            .andExpect(status().isOk())
            .andReturn();
        JsonNode body = json.readTree(res.getResponse().getContentAsString());
        return body.get("accessToken").asText();
    }

    @Test
    void platformAdminCanListAndCreateTenants() throws Exception {
        String superadminToken = loginSuperadmin();

        // 1. List tenants - must not contain _platform
        var listRes = mockMvc.perform(get("/api/v1/platform/tenants")
                .header("Authorization", "Bearer " + superadminToken))
            .andExpect(status().isOk())
            .andReturn();
        JsonNode listNode = json.readTree(listRes.getResponse().getContentAsString());
        assertThat(listNode.isArray()).isTrue();
        for (JsonNode t : listNode) {
            assertThat(t.get("tenantCode").asText()).isNotEqualTo("_platform");
        }

        // 2. Create tenant with auto-generated password
        String tenantCode = "pilot-001";
        CreateTenantRequest req = new CreateTenantRequest(
            tenantCode,
            "Pilot Shop Pvt Ltd",
            "पायलट पसल प्रा.लि.",
            "Pilot Shop Private Limited",
            "pilotowner",
            "owner@pilot.com.np",
            "Ram Bahadur",
            null, // auto-generate password
            "REG-101",
            "123456789",
            "Bagmati",
            "Kathmandu",
            "Kathmandu Metro",
            "3",
            "PRIVATE_LTD",
            "RETAIL"
        );

        var createRes = mockMvc.perform(post("/api/v1/platform/tenants")
                .header("Authorization", "Bearer " + superadminToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(req)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.tenantCode").value("pilot-001"))
            .andExpect(jsonPath("$.companyName").value("Pilot Shop Pvt Ltd"))
            .andExpect(jsonPath("$.adminUsername").value("pilotowner"))
            .andExpect(jsonPath("$.adminEmail").value("owner@pilot.com.np"))
            .andExpect(jsonPath("$.generatedPassword").isNotEmpty())
            .andExpect(jsonPath("$.passwordWasGenerated").value(true))
            .andReturn();

        JsonNode createNode = json.readTree(createRes.getResponse().getContentAsString());
        String generatedPassword = createNode.get("generatedPassword").asText();
        Long tenantId = createNode.get("tenantId").asLong();

        // 3. Verify accounts were seeded
        long accountCount = accountRepo.findByTenantIdOrderByAccountCode(tenantId).size();
        assertThat(accountCount).isGreaterThanOrEqualTo(15);

        // 4. Verify tenant setup status
        Tenant savedTenant = tenantRepo.findByTenantCode(tenantCode).orElseThrow();
        assertThat(savedTenant.isSetupCompleted()).isTrue();

        // 5. Login as the newly created admin user
        var adminLogin = new LoginRequest("pilot-001", "pilotowner", generatedPassword);
        var loginRes = mockMvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(adminLogin)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.accessToken").isNotEmpty())
            .andExpect(jsonPath("$.tenantCode").value("pilot-001"))
            .andExpect(jsonPath("$.roles[0]").value("ADMIN"))
            .andReturn();

        String newAdminToken = json.readTree(loginRes.getResponse().getContentAsString())
            .get("accessToken").asText();

        // 6. Verify new admin cannot access /api/v1/platform/tenants (403 Forbidden)
        mockMvc.perform(get("/api/v1/platform/tenants")
                .header("Authorization", "Bearer " + newAdminToken))
            .andExpect(status().isForbidden());

        // 7. Verify new admin cannot access /api/v1/setup/profile (403 Forbidden)
        mockMvc.perform(get("/api/v1/setup/profile")
                .header("Authorization", "Bearer " + newAdminToken))
            .andExpect(status().isForbidden());
    }
}
