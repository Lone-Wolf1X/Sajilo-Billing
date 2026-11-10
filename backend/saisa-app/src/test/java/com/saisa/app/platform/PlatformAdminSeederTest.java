package com.saisa.app.platform;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.saisa.app.auth.dto.LoginRequest;
import com.saisa.app.security.JwtService;
import com.saisa.common.tenant.Tenant;
import com.saisa.common.tenant.TenantRepository;
import com.saisa.common.user.User;
import com.saisa.common.user.UserRepository;
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
class PlatformAdminSeederTest {

    @Autowired private MockMvc mockMvc;
    @Autowired private ObjectMapper json;
    @Autowired private TenantRepository tenantRepo;
    @Autowired private UserRepository userRepo;
    @Autowired private JwtService jwtService;

    @Test
    void superadminShouldBeSeededAndLoginSuccessfully() throws Exception {
        // 1. Verify _platform tenant exists
        Tenant platformTenant = tenantRepo.findByTenantCode("_platform").orElse(null);
        assertThat(platformTenant).isNotNull();
        assertThat(platformTenant.isSetupCompleted()).isTrue();

        // 2. Verify superadmin user exists
        User superadmin = userRepo.findByTenantIdAndUsername(platformTenant.getId(), "superadmin").orElse(null);
        assertThat(superadmin).isNotNull();
        assertThat(superadmin.getRoles()).anyMatch(r -> "PLATFORM_ADMIN".equals(r.getRoleCode()));

        // 3. Login with superadmin credentials
        var login = new LoginRequest("_platform", "superadmin", "ChangeMe#2026");
        var res = mockMvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(login)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.accessToken").exists())
            .andExpect(jsonPath("$.tenantCode").value("_platform"))
            .andReturn();

        JsonNode body = json.readTree(res.getResponse().getContentAsString());
        String token = body.get("accessToken").asText();
        assertThat(token).isNotBlank();
        assertThat(jwtService.extractRoles(token)).contains("PLATFORM_ADMIN");

        // 4. Bad password fails
        var badLogin = new LoginRequest("_platform", "superadmin", "WrongPass123");
        mockMvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(badLogin)))
            .andExpect(status().isUnauthorized());
    }
}
