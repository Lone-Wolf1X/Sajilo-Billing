# 📄 Sajilo Billing - Paper Sizes & Printer Preferences Guide
> सजिलो बिलिङ: बिल साइज, प्रिन्टर सेटअप तथा पेपर छनोट निर्देशिका

---

## 1. 📏 Paper Sizes Comparison & Quick Decision Matrix

| Paper Size | Dimensions (mm) | Dimensions (Inches) | Best For / कस्तो बिलको लागि उपयुक्त? | Verdict / सुझाव |
|---|---|---|---|---|
| **A5** ⭐ | **148 × 210 mm** | **5.8 × 8.3 in** | **Classic Retail Cash Memo, Pink Bill Pad, Stationery, Kirana Stores** | ⭐ **SABSE BEST (Standard)** |
| **A4** | **210 × 297 mm** | **8.3 × 11.7 in** | **Full 13% VAT Tax Invoices, B2B Sales, Wholesale, Audit Reports** | ✅ **Standard for Tax Invoices** |
| **80mm Roll** | **80mm × Continuous** | **3.15 in wide** | **POS Supermarket, Restaurant KOT, Fast Thermal Checkout** | ✅ **Best for Thermal Printers** |
| **58mm Roll** | **58mm × Continuous** | **2.28 in wide** | **Mobile Billing, Bluetooth Handheld, Delivery Van Receipts** | 📱 **Best for Handheld POS** |
| **A6** | **105 × 148 mm** | **4.1 × 5.8 in** | **Mini Cash Slips, Petrol pump receipts, Token receipts** | 🟡 **Optional Compact** |
| **A3** | **297 × 420 mm** | **11.7 × 16.5 in** | **Architectural blueprints, Large Posters, Newspapers only** | ❌ **NOT RECOMMENDED (Too Big)** |

---

## 2. 📐 Exact Dimensions & Pixel Specifications (At 300 DPI)

For high-resolution graphic design, PDF rendering, or raster printing:

| Size | Millimeters (W × H) | Centimeters | Pixels at 300 DPI (Print Quality) | Pixels at 72 DPI (Screen) |
|---|---|---|---|---|
| **A5 (Portrait)** | `148 × 210 mm` | `14.8 × 21.0 cm` | **1748 × 2480 px** | 420 × 595 px |
| **A4 (Portrait)** | `210 × 297 mm` | `21.0 × 29.7 cm` | **2480 × 3508 px** | 595 × 842 px |
| **A4 (Landscape - 2 A5s)** | `297 × 210 mm` | `29.7 × 21.0 cm` | **3508 × 2480 px** | 842 × 595 px |
| **80mm Thermal** | `80 mm wide` | `8.0 cm wide` | **576 px wide** (printable ~72mm) | 48 characters/line |
| **58mm Thermal** | `58 mm wide` | `5.8 cm wide` | **384 px wide** (printable ~48mm) | 32 characters/line |

---

## 3. 💡 The Retailer's Secret: "2 Bills Per A4 Sheet" (50% Cost Saving)

Retail shopkeepers across Nepal rarely buy expensive pre-cut A5 pads for laser/inkjet printers. Instead, they use this smart technique:

```
┌───────────────────────── A4 Sheet (Landscape) ─────────────────────────┐
│                                   │                                    │
│        BILL #1 (A5)               │          BILL #2 (A5)              │
│  जानकारी केन्द्र (प्रा.) ली.      │    जानकारी केन्द्र (प्रा.) ली.     │
│  पुतलीसडक, काठमाडौँ               │    पुतलीसडक, काठमाडौँ              │
│  [Customer Copy / ग्राहक प्रति]   │    [Store Copy / पसल प्रति]        │
│                                   │                                    │
│  - Items & Rate Table             │    - Items & Rate Table            │
│  - Total & Signature              │    - Total & Signature             │
│                                   │                                    │
└───────────────────────────────────┴────────────────────────────────────┘
                               ▲ Cut here in middle
```

### Benefits:
1. **Cost Halved**: 1 standard A4 ream (Rs. 600 - 700) gives **1,000 bills** instead of 500!
2. **Dual Copies**: Left side = Customer Copy, Right side = Store Account Copy (auditing).

---

## 4. 🖨️ Printer Preferences & Hardware Setup Guide

### Category A: Standard Laser & Inkjet Printers (HP LaserJet, Canon, Epson L-Series, Brother)

Best for: **A4 Tax Invoices & A5 Retail Bills**

- **Paper Tray Setting**:
  - For A4: Load standard A4 paper in Tray 1.
  - For A5: Adjust the plastic slider guides in the paper tray inward to the `A5` mark.
- **Orientation**: Portrait (ठाडो)
- **Print Quality**: `Standard` or `Draft / Fast Economy` (saves 40% toner/ink on daily bills).
- **Duplex / 2-Sided**: Turn **OFF** for bills.

---

### Category B: Thermal POS Receipt Printers (80mm & 58mm)

Best for: **Supermarket, Grocery counter, Fast food, Pharmacy counters**
Examples: *Epson TM-T82, Xprinter XP-N160II, Sunmi, TVS, Rongta, Bixolon*

- **Baud Rate (Serial/USB)**: `9600` or `115200`
- **Paper Roll Width**:
  - `80mm`: 48 characters per line (`charsPerLine = 48`, raster width = 576 dots).
  - `58mm`: 32 characters per line (`charsPerLine = 32`, raster width = 384 dots).
- **Auto-Cutter**:
  - ESC/POS Command: `GS V 66 0` (Partial cut) or `GS V 65 0` (Full cut).
  - Enabled automatically in Sajilo Billing's Printer Settings.
- **Cash Drawer Kickout**:
  - Standard RJ11 kick pulse: `ESC p 0 25 250` (Pops cash drawer open when bill is printed).

---

### Category C: Dot Matrix Printers (Epson LX-310 / LQ-310)

Best for: **Traditional multi-copy carbon continuous stationery (बिल प्याड)**

- **Paper Type**: Continuous tractor-feed paper with side sprocket holes (6-inch or 8.5-inch width).
- **Tear-off mode**: Set `Auto Tear-Off = ON` in printer DIP switches.
- **Font**: Draft / Roman (10 CPI or 12 CPI).

---

## 5. 🌐 Web Browser & Computer Print Dialog Preferences

When printing HTML bills directly from Google Chrome, Edge, Safari, or Brave:

| Setting | Recommended Value | Reason |
|---|---|---|
| **Destination** | Select your physical printer or `Save as PDF` | Ensures direct output |
| **Pages** | `All` or `1` | Prevents blank 2nd page |
| **Layout** | `Portrait` | Standard bill orientation |
| **Paper size** | **`A5`** (for Bill Pad) or **`A4`** (for Tax Invoice) | Matches design ratio |
| **Margins** | **`None`** or **`Minimum`** | Maximizes printable area, avoids cutoffs |
| **Scale** | **`Fit to printable area`** or **`100%`** | Keeps crisp table lines |
| **Background graphics** | ✅ **MUST BE CHECKED (On)** | **Critical!** Without this, the pink or red background styling will not print. |
| **Headers and footers** | ❌ **UNCHECKED (Off)** | Removes browser URL and date stamp from corners |

---

## 6. 📱 Sajilo Billing In-App Configuration Summary

In the Sajilo Billing app under **Settings > Printer Settings (प्रिन्टर सेटिङ)**:

1. **Default Format**:
   - Select `A4 PDF / Bill Pad` for A5/A4 office paper.
   - Select `Thermal 80mm` for standard roll.
   - Select `Thermal 58mm` for compact handheld.
2. **Auto-Print after Sale**:
   - Turn **ON** for high-volume grocery / retail counters.
   - Turn **OFF** if you prefer reviewing the bill before printing.
3. **Multi-Copy Receipt**:
   - Set to `1` for normal retail.
   - Set to `2` if store copy is required.

