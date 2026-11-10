package com.saisa.app.platform.dto;

public record PublicDemoResponse(
    Long leadId,
    String status,
    String message,
    String downloadUrlMac,
    String downloadUrlWindows
) {}

