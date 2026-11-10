package com.saisa.app.license;

import org.springframework.stereotype.Component;

import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;

@Component
public class LicenseKeyProvider {

    public static final String PUBLIC_KEY_BASE64 =
            "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzTW9ynu/y4vCxN787CzG" +
            "NYzTPEMZwfl+pgPcSbjOMKo+5NjqacKPE+3xejbpYWYGXtU5yjBXn85etbf939vT" +
            "kvbmCJfKRnjnUyReUav06fbAQKU8eGwbKYd1Aq5S/svzMvStF0ANxXZ+mq8j/CcA" +
            "sSUVx3NRv1jZL2WgET9iwYDXDOFYKWQcf+5/K36+2/xMISPgRzW89/eYrDKlHYkZ" +
            "jEfrxYBCf2o4045kAazXWWiWwyazYgGzfQL0Gbjcli/+EXbNMWpzJ8+zw8Y4FLVU" +
            "sU86Fuj1T6g3K2kKUj94GWEW2l2gmpZAj12KiuKfpyadomLwzX92xyuKlAsypmQG" +
            "tQIDAQAB";

    public static final String PRIVATE_KEY_BASE64 =
            "MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDNNb3Ke7/Li8LE" +
            "3vzsLMY1jNM8QxnB+X6mA9xJuM4wqj7k2Oppwo8T7fF6NulhZgZe1TnKMFefzl61" +
            "t/3f29OS9uYIl8pGeOdTJF5Rq/Tp9sBApTx4bBsph3UCrlL+y/My9K0XQA3Fdn6a" +
            "ryP8JwCxJRXHc1G/WNkvZaARP2LBgNcM4VgpZBx/7n8rfr7b/EwhI+BHNbz395is" +
            "MqUdiRmMR+vFgEJ/ajjTjmQBrNdZaJbDJrNiAbN9AvQZuNyWL/4Rds0xanMnz7PD" +
            "xjgUtVSxTzoW6PVPqDcraQpSP3gZYRbaXaCalkCPXYqK4p+nJp2iYvDNf3bHK4qU" +
            "CzKmZAa1AgMBAAECggEAShczNR5E+0q0wbv4+ZSY49C6m7FmZWCdV3dhW8S7vVpa" +
            "ZuniiNjUK8/nNccJsD7T4f1+Zf/aQzqRe2643NBTrWYzW7riL1uLubsRys8ZGDgc" +
            "5bpDAP+XNwFPP+6MzK36WtV4gUKBNmA4CcVearXyTAMlv+NlCn8buz8n8dI+57nl" +
            "XKIAY+wgEy7qrZz+oeMwE6+5VvZRokkW0lyRjb/FY5YmAcu6oyetJU1os220UR8j" +
            "4kTU6deBGq1x+kr6Z4OHHRKg0i2T1ib+G8xzkgT2PWd7Dwqb1o1yCyc2EJXGug3S" +
            "NzTQ0wVLnM3xmgCNESV8BqRRLbA64G9C3Q24Wh1fwQKBgQDqykjTYQsdq9gvX31l" +
            "tDugWrdUQp5A3f+e3Qgu6ym8xEYltgiSH3Cu6dvyV62ElQfboJt6Ll+DJg9Tkskd" +
            "plovhxFFhdm+0HiMUXpT46o1clTOoGdfmfV7oCoBn6TfXszRbTPuV3BbI0fkHhSw" +
            "VkQJpQyiki4ogMByZyrOkpxO+QKBgQDfv2OwZ+Ep8GEHiqluHO9/BKK3sqFjeITq" +
            "CoEJWpVWS/uGULWMKjNlSmnIiCaqALt4XcJuVmbCrQsphUKRnxUoAe2XXuWy2d+7" +
            "Ew+t8Jl54kii6mc949EQDkXWN9/eFKcM1O2Ky9WcshEfk8BVpUoJ5OHlDIrg6LlY" +
            "ZMhxqvJYnQKBgDtyBehG7LqRdMXhxm0GqgYakcoqp8jCrGK7kcPXVJTvmNcZdKgS" +
            "f8Q5f6+nFU65MOkhi9vue85Hx5+gTX1NTg40g2H31r6iJ7NXOcKdpM2tad167VFe" +
            "OLIZRiltEyBe7zqjDH/u8YqRrzUJjLFs1gMfH8jVfAxTNOaCSmtM4Xh5AoGBAIKl" +
            "Y1Uu4se1R0K7EYFtPd7B2y0+DYRia+Gorn3Cua5BAaYE3Gzyez4qvCfOcB0V/mEj" +
            "BhOdObV0iy78U8lpxVWuAog/bgoHs96tG5uqAEOuAFG4Yv49VuZ0Hw0dZQdssboJ" +
            "XoaLzLgJNXxlromT0O6ECe7Paww2d3sIpg3RDl71AoGAeg3gvLtPfQ3OuX221siC" +
            "xyRVlGACiYAeRBm8TzTDj7f4Eul3hLx3Vq5KQRp5R2MQbgBBeZ2Ox+qz+dzCnhVu" +
            "XGEb5dk5Bbf9hTKEx6faZy9dLJarwENR29D907ViK43I0PGaJWUEDP/LGcCE/svd" +
            "HHs3X8aVKUAYVwbJUuCJ724=";

    private final PublicKey publicKey;
    private final PrivateKey privateKey;

    public LicenseKeyProvider() {
        try {
            KeyFactory kf = KeyFactory.getInstance("RSA");
            byte[] pubBytes = Base64.getDecoder().decode(PUBLIC_KEY_BASE64);
            this.publicKey = kf.generatePublic(new X509EncodedKeySpec(pubBytes));

            byte[] privBytes = Base64.getDecoder().decode(PRIVATE_KEY_BASE64);
            this.privateKey = kf.generatePrivate(new PKCS8EncodedKeySpec(privBytes));
        } catch (Exception e) {
            throw new IllegalStateException("Failed to initialize RSA License Keys", e);
        }
    }

    public PublicKey getPublicKey() {
        return publicKey;
    }

    public PrivateKey getPrivateKey() {
        return privateKey;
    }
}

