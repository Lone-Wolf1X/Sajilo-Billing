# Sajilo Billing - Thermal Receipt Printer Integration (ESC/POS)

Sajilo Billing supports direct retail thermal roll printing (58mm and 80mm) without cutting A4 paper. This document details hardware compatibility, setup procedures, network configuration, and architectural design.

---

## 1. Supported Connection Types & Platform Matrix

| Platform | Network (LAN / Wi-Fi) on Port 9100 | USB Thermal Printer | Bluetooth Thermal | Notes |
|---|---|---|---|---|
| **Windows Desktop** | ✅ Full Raw ESC/POS Socket | ✅ OS Spooled & Raw Driver | ⏳ Planned Step 7 | Most common in Nepali retail stores. |
| **macOS Desktop** | ✅ Full Raw ESC/POS Socket | ✅ Supported via CUPS | ⏳ Planned Step 7 | Plug & play for network and CUPS USB. |
| **Linux Desktop** | ✅ Full Raw ESC/POS Socket | ✅ Supported via CUPS/lp | ⏳ Planned Step 7 | Full raw socket & spooling support. |
| **Flutter Web** | ❌ Browser sandbox block | ❌ Direct USB blocked | ❌ Not available | Web users print roll/A4 PDFs via browser dialog. |
| **Mobile (Android/iOS)**| ✅ Socket available | ❌ USB OTG | ⏳ Planned Step 7 | Bluetooth BLE interface stubbed in Step 6. |

---

## 2. Recommended Printer Models for Nepali Retail

The following mainstream ESC/POS printers are widely available in Putalisadak/New Road IT markets across Nepal:

### 80mm (3-inch) Roll Printers (Recommended for Supermarkets & Busy Stores)
- **Xprinter XP-N160II / XP-C260M**: Industry workhorse in Nepal. Supports Ethernet (LAN) + USB. Fast 160mm/s auto-cutter.
- **Epson TM-T82III / TM-T88VI**: Standard commercial grade.
- **Rongta RP326 / RP80**: Affordable 80mm printer with LAN port.
- **Everycom BS-80**: Budget friendly thermal printer with USB+LAN.

### 58mm (2-inch) Roll Printers (Recommended for Small Grocery / Kirana)
- **Xprinter XP-58IIH**: Ultra-affordable 58mm USB/LAN printer.
- **POS-58 Series (Generic)**: Common 58mm POS printer. (Note: most 58mm models have manual tear bars, not auto-cutters).

---

## 3. Windows USB Driver Setup

When connecting a thermal printer via USB to Windows:
1. Connect the USB cable and power on the printer.
2. Install the manufacturer's Windows driver (e.g., Xprinter driver v7.77 or Epson OPOS driver).
3. Open **Windows Settings > Bluetooth & Devices > Printers & Scanners**.
4. Confirm your printer appears (e.g., `POS-80` or `XP-80C`).
5. In Sajilo Billing, navigate to **Settings > Printer Settings**:
   - Select **USB Thermal Printer**.
   - Pick your printer from the **Detected USB / Local Printer** dropdown.
   - Tap **Test Connection** or **Print Test Slip**.

---

## 4. Network Printer Setup (Ethernet / Wi-Fi)

Network printing is the most reliable setup for multi-counter shops and shared billing stations:
1. Connect the printer's RJ45 Ethernet port to your local Wi-Fi router or network switch.
2. Hold down the printer's **FEED** button while switching on power to print a **Self-Test Slip**.
3. Note the printer's current IP address (default is often `192.168.1.100` or `192.168.123.100`).
4. If your router uses a different subnet (e.g. `192.168.0.x` or `192.168.18.x`), change the printer's static IP to match your router's subnet using the manufacturer's IP tool.
5. In Sajilo Billing:
   - Go to **Settings > Printer Settings**.
   - Select **Network (LAN / Wi-Fi)**.
   - Tap **Scan Subnet for Printers** or enter the printer's IP manually.
   - Default port is **9100** (standard JetDirect/RAW port).
   - Tap **Test Connection** to verify ping.

---

## 5. Devanagari (Nepali) Text: ASCII vs. Raster Mode

Standard thermal printer hardware ROMs only support Latin/ASCII code pages (e.g., CP437, CP850). **Devanagari characters are NOT supported in ESC/POS text mode.**

Sajilo Billing provides two intelligent solutions:

### Mode 1: Clean ASCII Mode (Default, Fast & Crisp)
- Invoices are printed in crisp, clean English formatting.
- Item names, totals, PAN, and NextGen footer are formatted into tabular columns.
- Uses standard ESC/POS hardware font at maximum print speed (0.2 seconds per receipt).

### Mode 2: High-Fidelity Devanagari Mode (Raster Bitmap `GS v 0`)
- Toggle **High-Fidelity Devanagari Mode (Raster)** in Printer Settings.
- Sajilo Billing renders the entire bilingual receipt (with the bundled `NotoSansDevanagari` TTF) onto a high-resolution 203 DPI canvas (384px for 58mm, 576px for 80mm).
- The canvas is converted into a 1-bit monochrome bitmap buffer and dispatched using ESC/POS `GS v 0` graphic commands.
- **Benefits**: Perfect Devanagari typography, Bikram Sambat date (`वि.सं.`), Nepali numbers, and bilingual receipts.
- **Trade-off**: Takes ~1.5 to 2 seconds to transmit depending on USB/LAN throughput.

---

## 6. Web Platform Limitation

Web browsers execute inside a strict sandbox and cannot open raw TCP sockets (`dart:io` Socket) or access raw USB endpoints.
- In Flutter Web, thermal printing falls back to the browser's native print dialog formatted for 58mm or 80mm paper rolls.
- For full automatic offline background printing, storekeepers should use the **Sajilo Billing Desktop App** (Windows / macOS / Linux).

---

## 7. Troubleshooting Guide

| Issue | Root Cause | Solution |
|---|---|---|
| **Nothing prints (Network)** | IP address mismatch or port 9100 blocked | Print self-test slip (hold FEED on boot) to check IP. Ensure PC and printer are on same Wi-Fi/LAN subnet. |
| **Garbage / strange characters printed** | Wrong code page selected | Sajilo Billing enforces CP437 (`ESC t 0`). Switch to Devanagari Raster Mode if attempting to print Nepali characters. |
| **Paper not cutting** | Printer does not have an auto-cutter, or cut disabled | Most 58mm printers do not have motorized cutters (tear manually). For 80mm printers, enable **Auto Cut Paper** in settings. |
| **Extra paper feeds after bill** | `feedLines` configured too high | Set **Feed Lines** to 2 or 3 in Printer Settings. |
| **Raster mode too slow** | High network latency or complex rendering | Switch to ASCII mode for instant checkout, or verify router Wi-Fi signal strength. |

