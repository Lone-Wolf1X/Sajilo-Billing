package com.saisa.app.logging;

import ch.qos.logback.classic.PatternLayout;
import ch.qos.logback.classic.spi.ILoggingEvent;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Logback PatternLayout that scrubs sensitive credentials, tokens, and passwords
 * before log lines are written to console or file.
 */
public class MaskingPatternLayout extends PatternLayout {

    private static final Pattern SENSITIVE_PATTERN = Pattern.compile(
        "(?i)\"(password|refreshToken|secret|jwtSecret|access_token|refresh_token)\"\\s*:\\s*\"([^\"]+)\"|" +
        "(?i)(password|token|secret|refreshToken)=([^\\s&,]+)|" +
        "(Bearer\\s+)[A-Za-z0-9-_=]+\\.[A-Za-z0-9-_=]+\\.?[A-Za-z0-9-_.+/=]*"
    );

    @Override
    public String doLayout(ILoggingEvent event) {
        String message = super.doLayout(event);
        if (message == null) return null;

        Matcher matcher = SENSITIVE_PATTERN.matcher(message);
        StringBuilder sb = new StringBuilder();
        while (matcher.find()) {
            if (matcher.group(1) != null) {
                // JSON key-value
                matcher.appendReplacement(sb, "\"" + matcher.group(1) + "\":\"***\"");
            } else if (matcher.group(3) != null) {
                // Query / form param
                matcher.appendReplacement(sb, matcher.group(3) + "=***");
            } else if (matcher.group(5) != null) {
                // Bearer token
                matcher.appendReplacement(sb, matcher.group(5) + "***");
            }
        }
        matcher.appendTail(sb);
        return sb.toString();
    }
}

