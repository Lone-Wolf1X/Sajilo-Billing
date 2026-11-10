# Banking Essentials - Nepali Calendar & Datepicker Widget

A 100% offline, locally hosted dual Bikram Sambat (वि.सं.) and Gregorian (AD) calendar widget and date picker tailored for Core Banking Systems, Loan Management, KYC and Cheque Blacklisting modules.

---

## 📁 Files Included

| File | Role |
| :--- | :--- |
| `nepali_calendar_widget.php` | The core calendar view component with month/year navigation, Saturday highlighting, Panchang Tithi, and interactive selection. |
| `bs_date.php` | The mathematical conversion engine mapping 1975 BS to 2090 BS with month names, day counts, and Nepal fiscal year calculation. |
| `NepaliDateConverter.php` | Extended conversion table covering BS 1970 to 2100 with precise 1st Baisakh anchors. |
| `convert-date.php` | Lightweight JSON API endpoint for bidirectional date conversion (`?ad=YYYY-MM-DD` or `?bs=YYYY-MM-DD`). |
| `calendar-integration.js` | Modular JavaScript providing iframe toggling, auto input population, and outside click dismiss. |
| `calendar-demo.html` | Working standalone demo page demonstrating dual AD/BS inputs with calendar popups. |

---

## 🚀 How to Use in Any HTML/PHP Page

### Step 1: Include the JavaScript helper
```html
<script src="calendar-integration.js"></script>
```

### Step 2: Add paired AD and BS inputs
```html
<!-- AD Input with Calendar Trigger -->
<div class="input-group position-relative">
    <input type="text" class="form-control" id="chequeDate" name="chequeDate" 
           placeholder="YYYY-MM-DD" onclick="toggleNepaliDatePicker('chequeDate')">
    <button class="btn btn-outline-secondary" type="button" 
            onclick="toggleNepaliDatePicker('chequeDate')">📅</button>
    
    <div id="picker_chequeDate" class="collapse position-absolute z-3 mt-1" style="display:none;">
        <iframe src="nepali_calendar_widget.php?target=chequeDate" 
                style="width: 320px; height: 380px; border: none; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.12);" 
                scrolling="no"></iframe>
    </div>
</div>

<!-- Paired BS Input (Name must end with 'Bs' or target will auto-pair) -->
<input type="text" class="form-control" id="chequeDateBs" name="chequeDateBs" placeholder="YYYY-MM-DD">
```

### Step 3: Customize Widget Appearance
The widget supports query string customizations:
- `header_color`: Hex code without `#` (e.g. `header_color=2563eb` for Blue, `header_color=16a34a` for Green)
- `tithi`: `1` (show tithi) or `0` (hide tithi)
- `date`: Initial preselected AD date (e.g. `date=2026-10-11`)
- `target`: ID of the HTML input receiving the selected date
