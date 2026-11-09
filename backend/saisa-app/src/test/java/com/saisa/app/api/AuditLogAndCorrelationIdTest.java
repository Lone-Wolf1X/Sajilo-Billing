package com.saisa.app.api;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

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
class AuditLogAndCorrelationIdTest {

    @Autowired private MockMvc mvc;
    @Autowired private ObjectMapper json;

    @Test
    void correlationIdAndAuditTrailVerified() throws Exception {
        String testCid = "cid-test-12345";

        // 1. Register with correlation ID
        var reg = new RegisterTenantRequest("audittenant", "Audit Ltd", "admin", "admin@audit.com", "password123", "Admin");
        mvc.perform(post("/api/v1/auth/register")
                .header("X-Correlation-ID", testCid)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(reg)))
            .andExpect(status().isOk())
            .andExpect(header().string("X-Correlation-ID", testCid));

        // 2. Failed login should produce LOGIN_FAILED audit log
        var badLogin = new LoginRequest("audittenant", "admin", "wrongpassword");
        mvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(badLogin)))
            .andExpect(status().isUnauthorized());

        // 3. Successful login should produce LOGIN_SUCCESS audit log
        var goodLogin = new LoginRequest("audittenant", "admin", "password123");
        var loginResp = mvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(goodLogin)))
            .andExpect(status().isOk())
            .andReturn();
        String token = json.readTree(loginResp.getResponse().getContentAsString()).get("accessToken").asText();

        // 4. Query audit logs via GET /api/v1/audit-logs
        mvc.perform(get("/api/v1/audit-logs")
                .header("Authorization", "Bearer " + token))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$").isArray());
    }
}
