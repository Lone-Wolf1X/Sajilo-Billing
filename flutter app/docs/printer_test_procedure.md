# Sajilo Billing - Thermal Printer Manual Testing Procedure

Use this checklist to manually verify thermal receipt printing on physical 58mm and 80mm printers, or software emulators (e.g. Netcat raw port 9100 listener).

---

## 1. Test Setup Checklist

### Equipment Needed:
1. One 58mm or 80mm thermal receipt printer (e.g., Xprinter, Epson, Rongta, Everycom).
2. Direct USB cable or Ethernet cable connected to your local router.
3. Windows, macOS, or Linux computer running Sajilo Billing.

---

## 2. Step-by-Step Test Execution

### Test Case 1: Subnet Discovery & Connection Test
1. Connect thermal printer to your Wi-Fi router via Ethernet cable.
2. Print self-test slip (hold FEED button while powering on). Note printer IP (e.g., `192.168.1.100`).
3. Open Sajilo Billing > **Settings > Printer Settings**.
4. Select **Network (LAN / Wi-Fi)**.
5. Tap **Scan Subnet for Printers**.
6. **Expected Result**: Progress bar increments from 0% to 100%. The printer IP appears as an actionable chip.
7. Tap the discovered IP chip, then tap **Test Connection**.
8. **Expected Result**: Green checkmark with message "Printer connection successful!".

---

### Test Case 2: ASCII Receipt Print (80mm & 58mm)
1. In Printer Settings, ensure **High-Fidelity Devanagari Mode (Raster)** is **OFF**.
2. Set Paper Width to **80mm** (or 58mm if using 2-inch roll).
3. Navigate to **Billing Counter (POS)**.
4. Add 2 products, specify cash amount, and click **Complete & Generate Bill (Enter)**.
5. In the success modal, tap **Print (80mm)**.
6. **Expected Result**:
   - Header prints business name in bold double-height ASCII text.
   - S.N., Item Name, Qty, Rate, and Line Total align in neat tabular columns.
   - Subtotal, VAT, Grand Total, Tendered, and Change amounts match POS calculations.
   - Footer prints NextGen Innovations branding and website.
   - Printer feeds 3 lines and triggers paper cut.

---

### Test Case 3: High-Fidelity Devanagari Raster Print (`GS v 0`)
1. Go to **Settings > Printer Settings**.
2. Turn **High-Fidelity Devanagari Mode (Raster)** to **ON**.
3. Tap **Save Printer Settings**.
4. Navigate to POS, generate a bill with customer name and Nepali item descriptions.
5. Confirm invoice.
6. **Expected Result**:
   - Receipt prints in pure Nepali Devanagari script using the bundled `NotoSansDevanagari` font.
   - Nepali business name, Bikram Sambat date (`वि.सं.`), and "धन्यवाद! फेरि पाल्नुहोला ।" appear with crisp typography.
   - QR code is rendered cleanly.

---

### Test Case 4: Auto-Print After Sale
1. In Printer Settings, turn **Auto-Print After Sale** to **ON**.
2. Save settings.
3. On POS screen, add items and complete checkout.
4. **Expected Result**:
   - Receipt starts printing immediately upon confirmation without clicking any extra buttons.
   - Invoice success modal displays normally.

---

### Test Case 5: Offline / Printer Out of Paper Resilience
1. Turn off printer power or disconnect network cable.
2. Complete a sale on POS counter.
3. **Expected Result**:
   - The sale completes and updates SQLite stock ledger successfully (financial ledger is never rolled back).
   - A non-blocking red snackbar informs the cashier: "Sale saved, but auto-printing failed: Network printer unreachable".

---

### Test Case 6: Sales History Reprint
1. Navigate to **Sales History** tab on the navigation rail.
2. Click any past invoice to open **Sale Detail Dialog**.
3. Tap **Reprint Bill** (or click the dropdown arrow to select Thermal 58mm, 80mm, or A4 PDF).
4. **Expected Result**: Past invoice prints accurately with original invoice date, quantities, and fiscal totals.

