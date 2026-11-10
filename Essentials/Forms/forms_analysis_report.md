# Forms Analysis Report

This document provides a detailed breakdown of the three HTML form files located in the `forms` directory. It explains the purpose of the input fields and the design strategy used for each form.

---

## 1. `chequeform.html` (Cheque Details Form)

> [!NOTE]
> **Purpose**: To capture, manage, and list details of bank cheques in a tabular summary.

### Design Strategy
- **Styling**: Uses custom CSS (Vanilla CSS) without an external framework like Bootstrap. 
- **Layout**: Employs a flexbox-based grid system (`.row`, `.col-md-3`) to arrange input fields side-by-side responsively.
- **UI Components**: Features a clean "card" layout with clearly separated form sections.
- **Interactivity**: Uses Vanilla JavaScript to allow users to dynamically add multiple "Presentment Dates" and appends the submitted cheque data into a summary table (`<table class="data-table">`) at the bottom of the page.

### Input Fields
- **Cheque Information**:
  - `Account Holder Name` (Text): Name of the bank account owner.
  - `Account Number` (Text): The associated bank account number.
  - `Cheque Number` (Text): Unique identifier for the cheque.
  - `Cheque Date` (Date): The date written on the cheque.
  - `Cheque Amount` (Number): The monetary value.
  - `Cheque Amount in Words` (Text): Spelled-out version of the amount.
  - `Payee Name` (Text): The recipient to whom the cheque is issued.
- **Presentment Dates**:
  - `Presentment Date` (Date): A dynamic field where users can add one or multiple dates representing when the cheque was presented to the bank.

---

## 2. `form-individual.html` (Applicant Details Form)

> [!NOTE]
> **Purpose**: To collect comprehensive personal, demographic, and familial information for individual applicants.

### Design Strategy
- **Styling**: Utilizes **Bootstrap 5** for a robust, responsive, and mobile-friendly layout.
- **Typography**: Includes custom CSS (`@font-face`) to load the **Preeti font** for typing the applicant's name in Nepali.
- **Interactivity**: Includes advanced Vanilla JavaScript for:
  - Automatically converting dates between **AD (Gregorian) and BS (Bikram Sambat)** using a custom `DateConverter` script.
  - A toggle for "Is Reissue?" which dynamically reveals or hides the reissue details section.
  - A "Same as Permanent Address" checkbox that copies the permanent address over to the temporary address.
- **Modularity**: Groups data logically into Basic Details, Addresses, and Family Details.

### Input Fields
- **Applicant Information**:
  - `Full Name (English)` & `Full Name (Nepali)`: Applicant's name.
  - `Date of Birth (AD)` & `Date of Birth (BS)`: Birth dates (auto-converting).
  - `Gender` (Dropdown), `NID Number` (Text).
  - `Citizenship Number`, `Issue Date`, `Issue District` (Dropdown), and `Issue Authority`.
  - `Is Reissue?` (Radio Buttons): Toggles the Reissue section.
- **Reissue Details** (Conditional):
  - `Reissue Date` (Date), `Pratilipi Type` (Dropdown: First Copy, Second Copy, etc.), and `Reissue Reason` (Dropdown: Lost, Damaged, etc.).
- **Permanent Address**:
  - `Province`, `District`, `Municipality / VDC`, `Ward No.`, `Town / Village`, and `Street Name`.
- **Temporary Address**:
  - Replicates the Permanent Address fields, featuring a one-click copy checkbox.
- **Family Details**:
  - `Grandfather`, `Grandmother`, `Father`, `Mother`, `Spouse`, `Daughter`, `Son`, `Father-in-Law`, and `Mother-in-Law` (All Text inputs).

---

## 3. `form-institutional.html` (Unit Details Form)

> [!NOTE]
> **Purpose**: To collect organizational, registration, and contact data for corporate or institutional entities.

### Design Strategy
- **Styling**: Built with **Bootstrap 5** for consistent UI components (Cards, form controls, responsive grids).
- **Typography**: Like the individual form, it uses the **Preeti font** for Nepali text entry.
- **Interactivity**: 
  - Features an address duplication toggle ("Same as Registered Address" for Mailing Address).
  - Contains a dynamic and conditional **"Authorized Person / Entity"** section. This section's behavior depends on the "Registration Type" selected (e.g., Proprietorship vs. Private Limited), allowing the user to append authorized individuals or linked units to the institution.

### Input Fields
- **Unit Information**:
  - `Unit Name (English)` & `Unit Name (Nepali)`: Name of the institution.
  - `Registration Type` (Dropdown): Proprietorship, Partnership, Private Limited, Limited, etc.
  - `Registration Number`, `Registration Date`, and `Registration Authority`.
  - `PAN Number`, `PAN Issue Date`, `PAN Authority`, and `PAN District` (Dropdown).
  - `Email`, `Contact` (Text), and `Website` (URL).
- **Registered Address**:
  - `Province`, `District`, `Municipality / VDC`, `Ward No.`, `Town / Village`, and `Street Name`.
- **Mailing Address**:
  - Matches the Registered Address fields, with a checkbox to easily duplicate the data.
- **Authorized Person / Entity**:
  - Dynamic sub-forms that collect details of individuals or entities authorized to act on behalf of the institution. Includes fields like `Authorized Type`.
