package com.saisa.app.license;

public record LicenseContainer(
    LicensePayload payload,
    String signature,
    String algorithm
) {}

