package com.saisa.app.api;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.options;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import ch.qos.logback.classic.spi.LoggingEvent;
import com.saisa.app.logging.MaskingPatternLayout;
import java.util.Map;
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
class ProductionHardeningTest {

    @Autowired private MockMvc mvc;

    @Test
    void testValidationFailureReturnsFieldErrorsAndCorrelationId() throws Exception {
        // Empty payload fails validation (@NotBlank fields)
        mvc.perform(post("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{}")
                .header("X-Correlation-ID", "test-cid-12345"))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.code").value("VALIDATION_FAILED"))
            .andExpect(jsonPath("$.correlationId").value("test-cid-12345"))
            .andExpect(jsonPath("$.errors.username").exists())
            .andExpect(jsonPath("$.errors.tenantCode").exists())
            .andExpect(jsonPath("$.errors.password").exists());
    }

    @Test
    void testCorsHeadersIncludeCorrelationAndRetryAfter() throws Exception {
        mvc.perform(options("/api/v1/auth/login")
                .header("Origin", "http://localhost:3000")
                .header("Access-Control-Request-Method", "POST"))
            .andExpect(status().isOk())
            .andExpect(header().string("Access-Control-Allow-Origin", "http://localhost:3000"))
            .andExpect(header().exists("Access-Control-Expose-Headers"));
    }

    @Test
    void testMaskingPatternLayoutScrubsSensitiveData() {
        ch.qos.logback.classic.LoggerContext lc = (ch.qos.logback.classic.LoggerContext) org.slf4j.LoggerFactory.getILoggerFactory();
        MaskingPatternLayout layout = new MaskingPatternLayout();
        layout.setContext(lc);
        layout.setPattern("%msg");
        layout.start();

        ch.qos.logback.classic.Logger logger = lc.getLogger("test");
        LoggingEvent event = new LoggingEvent(
            "com.saisa.test", logger, ch.qos.logback.classic.Level.INFO,
            "User login attempt with {\"password\":\"SuperSecret123\", \"refreshToken\":\"token_xyz\"}",
            null, null);

        String formatted = layout.doLayout(event);
        assertFalse(formatted.contains("SuperSecret123"));
        assertFalse(formatted.contains("token_xyz"));
        assertTrue(formatted.contains("\"password\":\"***\""));
        assertTrue(formatted.contains("\"refreshToken\":\"***\""));
    }
}

