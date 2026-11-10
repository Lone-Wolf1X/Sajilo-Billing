# Banking Essentials - Forms & Master Datasets

This module contains production-ready, localized form templates and administrative master datasets designed for Core Banking, KYC, Cheque Blacklisting, and Loan origination software across Nepali financial institutions.

---

## 📁 Directory Contents

| File / Folder | Purpose & Details |
| :--- | :--- |
| `form-individual.html` / `applicant-individual.php` | Full individual customer profile form (Preeti typing, AD/BS conversion, Citizenship reissue, cascading addresses, family relations). |
| `form-institutional.html` / `applicant-institutional.php` | Full institutional entity profile form (Company registration, PAN, registered/mailing addresses, dynamic authorized persons & signatories table). |
| `chequeform.html` / `case-form.php` | Bank Cheque details sub-form (Account details, amount in words, multiple presentment dates, NRB dishonour reasons). |
| `applicant-joint-holders.php` / `case-drawer-form.php` | Sub-forms for joint holders and drawer specifications. |
| `js-individual.php` & `js-institutional.php` | Dynamic client-side logic for real-time validation, Preeti conversion, and modal search. |
| `address-cascading.js` | Zero-dependency standalone JavaScript cascading engine for Nepal's 7 Provinces, 77 Districts, 753 Municipalities, and Wards. |
| `locations_en.json` | Complete English administrative hierarchy of Nepal. |
| `locations_np.json` | Complete Devanagari (नेपाली) administrative hierarchy of Nepal. |
| `locations_unified.json` | Unified dual-language (EN + NP) administrative structure. |
| `address_mapping.json` | Dictionary translating English location names to Nepali Devanagari. |
| `dropdown_master_data.json` | Master JSON containing all banking dropdown options (Salutations, Marital Statuses, Identification Types, Authorities, Pratilipi Types, Reissue Reasons, Institutional Types, Designations, NRB Dishonour Reasons). |
| `registration_authorities.json` | Standard Nepali corporate registration authorities (Company Registrar, Dept of Industry, Ward, Municipality, DAO, etc.). |
| `aao_options.php` | Complete list of all Area Administration Offices (इलाका प्रशासन कार्यालय) across Nepal. |
| `fonts/` | Contains `preeti.ttf` and `Preeti Normal.otf` fonts for native Nepali input rendering. |
| `forms_analysis_report.md` | In-depth architectural analysis and field breakdown of each form. |

---

## 🛠 Quick Integration Guides

### 1. Cascading Address Dropdowns (Standalone JS)
```html
<script src="address-cascading.js"></script>
<script>
document.addEventListener("DOMContentLoaded", function() {
    const cascade = new NepalAddressCascade({ dataPath: 'locations_en.json' });
    
    // Bind Permanent Address
    cascade.bindCascade({
        province: '#perProvince',
        district: '#perDistrict',
        municipality: '#perMunicipality',
        ward: '#perWard'
    });
    
    // Bind Temporary Address & "Same as Permanent" Checkbox
    cascade.bindCascade({
        province: '#tempProvince',
        district: '#tempDistrict',
        municipality: '#tempMunicipality',
        ward: '#tempWard'
    });
    
    NepalAddressCascade.setupSameAddressSync('#sameAddress', 'per', 'temp');
});
</script>
```

### 2. Using Dropdown Master Data in Any Backend/Frontend
```javascript
fetch('dropdown_master_data.json')
    .then(res => res.json())
    .then(data => {
        // Populate Salutations
        const salutationSelect = document.getElementById('salutation');
        data.salutations.forEach(s => {
            salutationSelect.innerHTML += `<option value="${s.value}">${s.label_en} (${s.label_np})</option>`;
        });
        
        // Populate NRB Dishonour Reasons
        const reasonSelect = document.getElementById('dishonourReason');
        data.dishonour_reasons_nrb.forEach(r => {
            reasonSelect.innerHTML += `<option value="${r.value}">${r.label_en} - ${r.notice_type}</option>`;
        });
    });
```
