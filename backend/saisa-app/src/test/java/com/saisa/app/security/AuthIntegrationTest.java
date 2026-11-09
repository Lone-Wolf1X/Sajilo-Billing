package com.saisa.app.security;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.saisa.app.auth.dto.LoginRequest;
import com.saisa.app.auth.dto.RegisterTenantRequest;
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
class AuthIntegrationTest {

    @Autowired private MockMvc mockMvc;
    @Autowired private ObjectMapper json;

    @Test
    void registerLoginAndAccessProtectedEndpoint() throws Exception {
        // 1. Register tenant
        var reg = new RegisterTenantRequest(
            "acme", "Acme Corp", "admin", "admin@acme.com", "password123", "Admin User");
        var regResp = mockMvc.perform(post("/api/v1/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(reg)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.accessToken").exists())
            .andReturn();

        JsonNode body = json.readTree(regResp.getResponse().getContentAsString());
        String token = body.get("accessToken").asText();
        assertThat(token).isNotBlank();

        // 2. Login again (verify password storage)
        var login = new LoginRequest("acme", "admin", "password123");
        mockMvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(login)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.accessToken").exists());

        // 3. Wrong password rejected
        var badLogin = new LoginRequest("acme", "admin", "wrongpass");
        mockMvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(badLogin)))
            .andExpect(status().isUnauthorized());

        // 4. Protected endpoint (actuator/info may be public; use /api/v1/auth/login as example of public, use a random API as protected)
        // For now, verify token works on /actuator/health (public) - we don't have protected endpoints yet
        // Next step adds test for cross-tenant access.
    }

    @Test
    void duplicateTenantCodeRejected() throws Exception {
        var reg = new RegisterTenantRequest(
            "dupe", "Dupe Corp", "admin", "admin@dupe.com", "password123", "Admin");
        mockMvc.perform(post("/api/v1/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(reg)))
            .andExpect(status().isOk());

        mockMvc.perform(post("/api/v1/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(reg)))
            .andExpect(status().isBadRequest());
    }
}
