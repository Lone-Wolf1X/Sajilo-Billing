# Devanagari Font Bundling & OFL Licensing

Sajilo Billing (`सजिलो बिलिङ`) embeds Google Noto Sans Devanagari fonts directly within the application binary to guarantee 100% offline Devanagari typography rendering across Windows, macOS, Linux, and Web WASM.

## Included Font Files
- `assets/fonts/NotoSansDevanagari-Regular.ttf`
- `assets/fonts/NotoSansDevanagari-Bold.ttf`

## Licensing
The bundled fonts are licensed under the **SIL Open Font License (OFL), Version 1.1**.
The full text of the license is included in `assets/fonts/OFL.txt`.

### Copyright Notice
Copyright 2022 The Noto Project Authors (https://github.com/notofonts/devanagari)

### Usage in Sajilo Billing
1. **Application UI Theme**:
   Defined in `lib/core/theme/app_theme.dart` using `fontFamily: 'NotoSansDevanagari'`.
2. **Offline Bilingual Invoices**:
   Loaded in `lib/features/billing/data/pdf_bill_generator.dart` via `rootBundle.load(...)` and passed into `pw.ThemeData.withFont(base: ttfRegular, bold: ttfBold)`.
3. **No External Network Dependencies**:
   The PDF generator does not make external HTTP requests or depend on Google Fonts CDN at runtime, maintaining full compliance with offline retail requirements.

