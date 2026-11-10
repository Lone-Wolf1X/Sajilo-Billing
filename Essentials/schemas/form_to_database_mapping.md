# Form Fields to Database Mapping & Data Dictionary

This document provides a comprehensive mapping between every input field in the banking forms (`form-individual.html`, `form-institutional.html`, `chequeform.html`, and `case-drawer-form.php`) and the underlying SQL database tables.

---

## 1. Individual Applicant & Drawer Profile Form

| HTML Input Name (`id`/`name`) | Field Label | Element Type | Source Dropdown / Dataset | DB Table | DB Column | SQL Data Type | Processing Notes |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `salutation` | Salutation | `<select>` | `dropdown_master_data.json` (`salutations`) | `profiles` / `drawer_details` | `salutation` | `VARCHAR(20)` | e.g. Mr., Mrs., Ms., Dr. |
| `fullNameEnglish` | Full Name (English) | `<input type="text">` | Direct Input | `profiles` / `drawer_details` | `fullNameEnglish` | `VARCHAR(255)` | Required |
| `fullNameNepali` | Full Name (Nepali) | `<input type="text">` | Preeti font or Unicode | `profiles` / `drawer_details` | `fullNameNepali` | `VARCHAR(255)` | Converted via `preetiToUnicode()` |
| `dob` | Date of Birth (AD) | `<input type="text">` | Calendar Widget | `profiles` / `drawer_details` | `dob` | `VARCHAR(50)` | YYYY-MM-DD format |
| `dobBs` | Date of Birth (BS) | `<input type="text">` | Calendar Widget | `profiles` / `drawer_details` | `dobBs` | `VARCHAR(50)` | YYYY-MM-DD format (B.S.) |
| `gender` | Gender | `<select>` | `dropdown_master_data.json` (`genders`) | `profiles` / `drawer_details` | `gender` | `VARCHAR(50)` | Male, Female, Other |
| `maritalStatus` | Marital Status | `<select>` | `dropdown_master_data.json` (`marital_statuses`) | `profiles` / `drawer_details` | `maritalStatus` | `VARCHAR(30)` | Married, Unmarried, Divorced, Widowed |
| `nidNumber` | National ID (NID) | `<input type="text">` | Direct Input | `profiles` / `drawer_details` | `nidNumber` | `VARCHAR(100)` | Optional |
| `citizenshipNumber` | Citizenship Number | `<input type="text">` | Direct Input | `profiles` / `drawer_details` | `citizenshipNumber` | `VARCHAR(100)` | Required |
| `citizenshipIssueDate` | Citizenship Issue Date | `<input type="text">` | Calendar Widget | `profiles` / `drawer_details` | `citizenshipIssueDate` | `VARCHAR(50)` | Usually BS or AD |
| `citizenshipIssueDistrict` | Issue District | `<select>` | `locations_en.json` (Districts list) | `profiles` / `drawer_details` | `citizenshipIssueDistrict` | `VARCHAR(100)` | 77 Districts |
| `citizenshipAuthority` | Issue Authority | `<select>` | `dropdown_master_data.json` (`citizenship_authorities`) | `profiles` / `drawer_details` | `citizenshipAuthority` | `VARCHAR(100)` | DAO or AAO |
| `citizenshipIssuePlace` | Issue Place (AAO) | `<select>` | `aao_options.php` / `aao_options.json` | `profiles` / `drawer_details` | `citizenshipIssuePlace` | `VARCHAR(255)` | Visible if AAO selected |
| `mobile` | Mobile / Phone | `<input type="text">` | Direct Input | `profiles` / `drawer_details` | `mobile` | `VARCHAR(50)` | Primary contact |
| `email` | Email Address | `<input type="email">` | Direct Input | `profiles` / `drawer_details` | `email` | `VARCHAR(100)` | Optional |
| `reissue` (`reissueYes`/`reissueNo`) | Is Reissue? | `<input type="radio">` | Radio (Yes / No) | `profiles` / `drawer_details` | `reissueYes` / `reissueNo` | `VARCHAR(10)` | Toggles reissue box |
| `reissueDate` | Reissue Date | `<input type="text">` | Calendar Widget | `profiles` / `drawer_details` | `reissueDate` | `VARCHAR(50)` | Conditional |
| `pratilipiType` | Pratilipi Type | `<input list>` | `dropdown_master_data.json` (`pratilipi_types`) | `profiles` / `drawer_details` | `pratilipiType` | `VARCHAR(50)` | 1st Copy to 10th Copy |
| `reissueDistrict` | Reissue District | `<select>` | `locations_en.json` (Districts) | `profiles` / `drawer_details` | `reissueDistrict` | `VARCHAR(255)` | District |
| `reissueAuthority` | Reissue Authority | `<select>` | `dropdown_master_data.json` (`citizenship_authorities`) | `profiles` / `drawer_details` | `reissueAuthority` | `VARCHAR(255)` | DAO or AAO |
| `reissuePlace` | Reissue Place | `<select>` | `aao_options.php` | `profiles` / `drawer_details` | `reissuePlace` | `VARCHAR(255)` | Area Admin Office |
| `perProvince` | Permanent Province | `<select>` | `locations_en.json` (`provinces`) | `profiles` / `drawer_details` | `perProvince` | `VARCHAR(100)` | 7 Provinces |
| `perDistrict` | Permanent District | `<select>` | Cascaded from Province | `profiles` / `drawer_details` | `perDistrict` | `VARCHAR(100)` | 77 Districts |
| `perMunicipality` | Permanent Local Body | `<select>` | Cascaded from District | `profiles` / `drawer_details` | `perMunicipality` | `VARCHAR(100)` | 753 Local Bodies |
| `perWard` | Permanent Ward | `<select>` | Cascaded from Local Body | `profiles` / `drawer_details` | `perWard` | `VARCHAR(50)` | 1 to 35 |
| `perTown` | Town / Village | `<input type="text">` | Direct Input | `profiles` / `drawer_details` | `perTown` | `VARCHAR(100)` | Settlement/Tol |
| `perStreet` | Street / Road | `<input type="text">` | Direct Input | `profiles` / `drawer_details` | `perStreet` | `VARCHAR(100)` | Street name |
| `sameAddress` | Same as Permanent? | `<input type="checkbox">` | Checkbox | `profiles` / `drawer_details` | `sameAddress` | `VARCHAR(10)` | Copies `per*` into `temp*` |
| `tempProvince` | Temp Province | `<select>` | `locations_en.json` | `profiles` / `drawer_details` | `tempProvince` | `VARCHAR(100)` | Temporary Province |
| `tempDistrict` | Temp District | `<select>` | Cascaded | `profiles` / `drawer_details` | `tempDistrict` | `VARCHAR(100)` | Temporary District |
| `tempMunicipality` | Temp Local Body | `<select>` | Cascaded | `profiles` / `drawer_details` | `tempMunicipality` | `VARCHAR(100)` | Temporary Municipality |
| `tempWard` | Temp Ward | `<select>` | Cascaded | `profiles` / `drawer_details` | `tempWard` | `VARCHAR(50)` | Temporary Ward |
| `tempTown` | Temp Town | `<input type="text">` | Direct Input | `profiles` / `drawer_details` | `tempTown` | `VARCHAR(100)` | Temporary Town |
| `tempStreet` | Temp Street | `<input type="text">` | Direct Input | `profiles` / `drawer_details` | `tempStreet` | `VARCHAR(100)` | Temporary Street |
| `grandfather` | Grandfather's Name | `<input type="text">` | Direct Input | `profiles` / `drawer_details` | `grandfather` | `VARCHAR(255)` | 3-Generations KYC |
| `grandmother` | Grandmother's Name | `<input type="text">` | Direct Input | `profiles` / `drawer_details` | `grandmother` | `VARCHAR(255)` | Family Details |
| `father` | Father's Name | `<input type="text">` | Direct Input | `profiles` / `drawer_details` | `father` | `VARCHAR(255)` | KYC Mandatory |
| `mother` | Mother's Name | `<input type="text">` | Direct Input | `profiles` / `drawer_details` | `mother` | `VARCHAR(255)` | KYC Mandatory |
| `spouse` | Spouse's Name | `<input type="text">` | Direct Input | `profiles` / `drawer_details` | `spouse` | `VARCHAR(255)` | Required if Married |
| `daughter` | Daughter's Name | `<input type="text">` | Direct Input | `profiles` / `drawer_details` | `daughter` | `VARCHAR(255)` | Family KYC |
| `son` | Son's Name | `<input type="text">` | Direct Input | `profiles` / `drawer_details` | `son` | `VARCHAR(255)` | Family KYC |
| `fatherInLaw` | Father-in-Law | `<input type="text">` | Direct Input | `profiles` / `drawer_details` | `fatherInLaw` | `VARCHAR(255)` | Required if Married Female |
| `motherInLaw` | Mother-in-Law | `<input type="text">` | Direct Input | `profiles` / `drawer_details` | `motherInLaw` | `VARCHAR(255)` | Family KYC |

---

## 2. Institutional Entity Profile Form

| HTML Input Name | Field Label | Element Type | Source Dropdown / Dataset | DB Table | DB Column | SQL Data Type | Processing Notes |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `unitNameEnglish` | Institution Name (EN) | `<input type="text">` | Direct Input | `profiles` / `drawer_details` | `unitNameEnglish` | `VARCHAR(255)` | Entity legal name |
| `unitNameNepali` | Institution Name (NP) | `<input type="text">` | Preeti font or Unicode | `profiles` / `drawer_details` | `unitNameNepali` | `VARCHAR(255)` | Converted via `preetiToUnicode()` |
| `registrationType` | Registration Type | `<select>` | `dropdown_master_data.json` (`institutional_registration_types`) | `profiles` / `drawer_details` | `registrationType` | `VARCHAR(100)` | Dictates Authorized Person rules |
| `registrationNumber` | Registration Number | `<input type="text">` | Direct Input | `profiles` / `drawer_details` | `registrationNumber` | `VARCHAR(100)` | Company/Firm Reg No. |
| `registrationDate` | Reg Date (AD) | `<input type="text">` | Calendar Widget | `profiles` / `drawer_details` | `registrationDate` | `VARCHAR(50)` | YYYY-MM-DD |
| `registrationDateBs` | Reg Date (BS) | `<input type="text">` | Calendar Widget | `profiles` / `drawer_details` | `registrationDateBs` | `VARCHAR(50)` | YYYY-MM-DD |
| `registrationAuthority` | Reg Authority (EN) | `<select>` / `<input>` | `registration_authorities.json` or `gov_offices` | `profiles` / `drawer_details` | `registrationAuthority` | `VARCHAR(500)` | Issuing authority |
| `registrationAuthorityNp` | Reg Authority (NP) | `<input>` | Auto-mapped | `profiles` / `drawer_details` | `registrationAuthorityNp` | `VARCHAR(500)` | Devanagari translation |
| `registration_org_id` | Master Org ID | `<input type="hidden">` | `gov_offices.id` / `gov_departments.id` | `profiles` / `drawer_details` | `registration_org_id` | `INT` | Relational FK link |
| `registration_org_type` | Master Org Type | `<input type="hidden">` | ENUM | `profiles` / `drawer_details` | `registration_org_type` | `ENUM(...)` | Office, Department, Ministry, Other |
| `panNumber` | PAN Number | `<input type="text">` | Direct Input | `profiles` / `drawer_details` | `panNumber` | `VARCHAR(100)` | 9-Digit Tax ID |
| `panIssueDate` | PAN Issue Date | `<input type="text">` | Calendar Widget | `profiles` / `drawer_details` | `panIssueDate` | `VARCHAR(50)` | Issue Date |
| `panAuthority` | PAN Authority | `<select>` | `registration_authorities.json` | `profiles` / `drawer_details` | `panAuthority` | `VARCHAR(100)` | Inland Revenue Office |
| `panDistrict` | PAN District | `<select>` | `locations_en.json` (Districts) | `profiles` / `drawer_details` | `panDistrict` | `VARCHAR(100)` | Tax District |
| `contact` | Phone / Landline | `<input type="text">` | Direct Input | `profiles` / `drawer_details` | `contact` | `VARCHAR(50)` | Primary Telephone |
| `website` | Corporate Website | `<input type="url">` | Direct Input | `profiles` / `drawer_details` | `website` | `VARCHAR(255)` | Web URL |
| `registered*` | Registered Address | Cascaded selects | `locations_en.json` | `profiles` / `drawer_details` | `registeredProvince` to `registeredStreet` | `VARCHAR(100)` | Registered Office Location |
| `mailing*` | Mailing Address | Cascaded selects | `locations_en.json` | `profiles` / `drawer_details` | `mailingProvince` to `mailingStreet` | `VARCHAR(100)` | Correspondence Address |

---

## 3. Dynamic Authorized Persons & Signatories Sub-Table

Stored in the `linked_individuals` relational table:

| Sub-Form Field | Meaning | Linked DB Column | Type | Constraints & Values |
| :--- | :--- | :--- | :--- | :--- |
| `roleType` | Distinction | `link_type` | `ENUM` | `'Authorized Person'` or `'Signatory'` |
| `is_signatory` | Cheque Signatory Flag | `is_signatory` | `TINYINT(1)` | `1` if Account Operator/Signatory, `0` if purely Director/Owner |
| `authorizedRole` | Role Title / Designation | `role_title` | `VARCHAR(100)` | From `dropdown_master_data.json` (`authorized_roles`) |
| `source_profile_id` | Linked Master Profile | `source_profile_id` | `VARCHAR(50)` | Links to existing customer `profile_id` if reused |
| Personal & Address Fields | Demographic & KYC | Replicates all individual demographics | Multi-column | `fullNameEnglish`, `fullNameNepali`, `dob`, `citizenshipNumber`, `mobile`, `perProvince`, etc. |

---

## 4. Cheque Details Form

| HTML Input Name | Field Label | Element Type | Source Reference | DB Table | DB Column | SQL Data Type |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `accountHolderName` | Account Holder Name | `<input type="text">` | Direct Input | `cheque_details` | `accountHolderName` | `VARCHAR(255)` |
| `accountNumber` | Bank Account Number | `<input type="text">` | Direct Input | `cheque_details` | `accountNumber` | `VARCHAR(100)` |
| `branchNameEn` | Drawee Branch (EN) | `<select>` / `<input>` | `branches.branch_name_en` | `cheque_details` | `branchNameEn` | `VARCHAR(255)` |
| `branchNameNp` | Drawee Branch (NP) | `<input type="text">` | `branches.branch_name_np` | `cheque_details` | `branchNameNp` | `VARCHAR(255)` |
| `chequeNumber` | Cheque Number | `<input type="text">` | Direct Input | `cheque_details` | `chequeNumber` | `VARCHAR(100)` |
| `chequeDate` | Cheque Date | `<input type="text">` | Calendar Widget | `cheque_details` | `chequeDate` | `VARCHAR(50)` |
| `chequeAmount` | Cheque Amount (NPR) | `<input type="number">` | Direct Input | `cheque_details` | `chequeAmount` | `DECIMAL(15,2)` |
| `chequeAmountWords` | Amount in Words | `<input type="text">` | `NumberToNepaliWords` | `cheque_details` | `chequeAmountWords` | `VARCHAR(255)` |
| `dishonour_reason_select` | Reason for Return | `<select>` | `dropdown_master_data.json` (`dishonour_reasons_nrb`) | `cheque_details` | `dishonour_reason_select` | `VARCHAR(255)` |
| `presentmentDates[]` | Presentment Dates | Dynamic list of dates | Multiple inputs | `cheque_details` | `presentmentDates` | `TEXT` (JSON encoded) |
