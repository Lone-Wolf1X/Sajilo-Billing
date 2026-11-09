package com.saisa.app.api;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.saisa.app.ratelimit.RateLimitService;
import java.util.Map;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class RateLimitAndHealthTest {

    @Autowired private MockMvc mvc;
    @Autowired private ObjectMapper json;
    @Autowired private RateLimitService rateLimitService;

    @AfterEach
    void cleanup() {
        rateLimitService.clearAll();
    }

    @Test
    void healthEndpointsArePublic() throws Exception {
        mvc.perform(get("/actuator/health"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.status").value("UP"));

        mvc.perform(get("/actuator/health/liveness"))
            .andExpect(status().isOk());

        mvc.perform(get("/actuator/health/readiness"))
            .andExpect(status().isOk());
    }

    @Test
    void loginRateLimitExceeded() throws Exception {
        var payload = Map.of(
            "tenantCode", "ratelimit-test",
            "username", "x",
            "password", "y"
        );

        // First 5 attempts: whatever status (400/401/404), not 429
        for (int i = 0; i < 5; i++) {
            mvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(payload)));
        }

        // 6th: should be 429
        mvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(payload)))
            .andExpect(status().isTooManyRequests())
            .andExpect(header().exists("Retry-After"))
            .andExpect(jsonPath("$.code").value("RATE_LIMITED"));
    }
}

