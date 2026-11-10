package com.saisa.app.admin.email;

import jakarta.mail.internet.MimeMessage;
import java.time.Instant;
import java.util.Properties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class EmailService {

    private static final Logger log = LoggerFactory.getLogger(EmailService.class);

    private final EmailSettingsRepository settingsRepo;
    private final JavaMailSender defaultMailSender;

    public EmailService(EmailSettingsRepository settingsRepo, JavaMailSender defaultMailSender) {
        this.settingsRepo = settingsRepo;
        this.defaultMailSender = defaultMailSender;
    }

    public EmailSettings getSettings() {
        return settingsRepo.findAll().stream().findFirst().orElseGet(() -> {
            EmailSettings defaultSettings = new EmailSettings();
            defaultSettings.setSmtpHost("smtp.gmail.com");
            defaultSettings.setSmtpPort(587);
            defaultSettings.setSmtpUsername("nextgeninnovationsprivatelimit@gmail.com");
            defaultSettings.setSmtpPassword("mdvx fwry lrmd pwsc");
            defaultSettings.setFromEmail("nextgeninnovationsprivatelimit@gmail.com");
            defaultSettings.setFromName("SAISA Billing & Accounting");
            defaultSettings.setStarttlsEnabled(true);
            defaultSettings.setAuthEnabled(true);
            return settingsRepo.save(defaultSettings);
        });
    }

    @Transactional
    public EmailSettings updateSettings(EmailSettings updated) {
        EmailSettings current = getSettings();
        current.setSmtpHost(updated.getSmtpHost());
        current.setSmtpPort(updated.getSmtpPort());
        current.setSmtpUsername(updated.getSmtpUsername());
        if (updated.getSmtpPassword() != null && !updated.getSmtpPassword().isBlank()) {
            current.setSmtpPassword(updated.getSmtpPassword().trim());
        }
        current.setFromEmail(updated.getFromEmail());
        current.setFromName(updated.getFromName());
        current.setStarttlsEnabled(updated.isStarttlsEnabled());
        current.setAuthEnabled(updated.isAuthEnabled());
        current.setUpdatedAt(Instant.now());
        return settingsRepo.save(current);
    }

    public JavaMailSender buildSender(EmailSettings settings) {
        JavaMailSenderImpl sender = new JavaMailSenderImpl();
        sender.setHost(settings.getSmtpHost());
        sender.setPort(settings.getSmtpPort());
        sender.setUsername(settings.getSmtpUsername());
        sender.setPassword(settings.getSmtpPassword());

        Properties props = sender.getJavaMailProperties();
        props.put("mail.transport.protocol", "smtp");
        props.put("mail.smtp.auth", String.valueOf(settings.isAuthEnabled()));
        props.put("mail.smtp.starttls.enable", String.valueOf(settings.isStarttlsEnabled()));
        props.put("mail.smtp.starttls.required", String.valueOf(settings.isStarttlsEnabled()));
        props.put("mail.smtp.connectiontimeout", "7000");
        props.put("mail.smtp.timeout", "7000");
        props.put("mail.smtp.writetimeout", "7000");

        return sender;
    }

    public void sendEmail(String to, String subject, String htmlContent) {
        EmailSettings settings = getSettings();
        try {
            JavaMailSender sender = buildSender(settings);
            MimeMessage message = sender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(settings.getFromEmail(), settings.getFromName());
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(htmlContent, true);

            sender.send(message);
            log.info("Email sent successfully to {}", to);
        } catch (Exception ex) {
            log.error("Failed to send email to {}: {}", to, ex.getMessage(), ex);
            throw new RuntimeException("इमेल पठाउन सकिएन: " + ex.getMessage(), ex);
        }
    }

    public String sendTestEmail(String targetEmail) {
        String recipient = (targetEmail != null && !targetEmail.isBlank())
                ? targetEmail.trim()
                : getSettings().getFromEmail();

        EmailSettings settings = getSettings();

        String html = "<div style=\"font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 24px; border: 1px solid #cbd5e1; border-radius: 8px; background-color: #ffffff;\">"
                + "<div style=\"border-bottom: 2px solid #0f2d59; padding-bottom: 12px; margin-bottom: 16px;\">"
                + "<h2 style=\"color: #0f2d59; margin: 0; font-size: 20px;\">SAISA Billing & Accounting • SMTP Test Verification</h2>"
                + "<p style=\"color: #64748b; font-size: 13px; margin: 4px 0 0 0;\">प्रणाली इमेल कन्फिगरेसन परीक्षण</p>"
                + "</div>"
                + "<div style=\"background-color: #f8fafc; border-left: 4px solid #10b981; padding: 12px 16px; margin-bottom: 16px;\">"
                + "<p style=\"color: #065f46; font-weight: bold; margin: 0 0 4px 0;\">✓ सफलता! SMTP कन्फिगरेसन सफल भयो</p>"
                + "<p style=\"color: #334155; font-size: 13px; margin: 0;\">SAISA Admin Panel बाट पठाइएको परीक्षण इमेल सफलतापूर्वक डेलिभर भएको छ।</p>"
                + "</div>"
                + "<table style=\"width: 100%; border-collapse: collapse; font-size: 13px; margin-bottom: 20px;\">"
                + "<tr style=\"border-bottom: 1px solid #e2e8f0;\"><td style=\"padding: 8px 0; color: #64748b; width: 140px;\">SMTP Host:</td><td style=\"padding: 8px 0; font-weight: bold; color: #0f172a;\">" + settings.getSmtpHost() + "</td></tr>"
                + "<tr style=\"border-bottom: 1px solid #e2e8f0;\"><td style=\"padding: 8px 0; color: #64748b;\">SMTP Port:</td><td style=\"padding: 8px 0; font-weight: bold; color: #0f172a;\">" + settings.getSmtpPort() + "</td></tr>"
                + "<tr style=\"border-bottom: 1px solid #e2e8f0;\"><td style=\"padding: 8px 0; color: #64748b;\">Sender Email:</td><td style=\"padding: 8px 0; font-weight: bold; color: #0f172a;\">" + settings.getFromEmail() + "</td></tr>"
                + "<tr style=\"border-bottom: 1px solid #e2e8f0;\"><td style=\"padding: 8px 0; color: #64748b;\">Sender Name:</td><td style=\"padding: 8px 0; font-weight: bold; color: #0f172a;\">" + settings.getFromName() + "</td></tr>"
                + "<tr><td style=\"padding: 8px 0; color: #64748b;\">Sent Time:</td><td style=\"padding: 8px 0; font-family: monospace; color: #0f172a;\">" + Instant.now().toString() + "</td></tr>"
                + "</table>"
                + "<div style=\"border-top: 1px solid #e2e8f0; padding-top: 12px; font-size: 11px; color: #94a3b8; text-align: center;\">SAISA Cloud Accounting • NextGen Innovations Pvt. Ltd. • Nepal</div>"
                + "</div>";

        sendEmail(recipient, "✓ SAISA Billing - SMTP Test Email Successful", html);
        return recipient;
    }
}
