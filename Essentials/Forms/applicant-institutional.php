<div id="unitFormSection" style="display:block;">

    <div id="unitFormInner">

        <!-- =========================================
             UNIT BASIC DETAILS
        ========================================== -->

        <div class="form-section">

            <div class="form-section-title d-flex justify-content-between align-items-center">
                <span><?= isset($formTitle) ? $formTitle : 'Unit Information' ?></span>
                <div>
                    <a href="search-existing.php?type=Institutional" class="btn btn-sm btn-outline-primary fw-bold shadow-sm">
                        🔍 Select from existing entries
                    </a>
                </div>
            </div>

                        <div class="row g-3">

                            <!-- Unit Name English -->

                            <div class="col-md-3">

                                <label class="form-label">
                                    Unit Name (English)
                                    <span class="required">*</span>
                                </label>

                                <input
                                    type="text"
                                    class="form-control"
                                    name="unitNameEnglish" id="unitNameEnglish"
                                    required
                                >

                            </div>


                            <!-- Unit Name Nepali -->

                            <div class="col-md-3">

                                <label class="form-label">
                                    Unit Name (Nepali)
                                </label>

                                <input
                                    type="text"
                                    class="form-control"
                                    name="unitNameNepali" id="unitNameNepali"
                                >

                            </div>


                            <!-- Registration Type -->

                            <div class="col-md-3">

                                <label class="form-label">
                                    Registration Type
                                    <span class="required">*</span>
                                </label>

                                <select
                                    class="form-select"
                                    name="registrationType" id="registrationType"
                                    required
                                >

                                    <option value="">
                                        Select Registration Type
                                    </option>

                                    <option value="Proprietorship">
                                        Proprietorship
                                    </option>

                                    <option value="Partnership">
                                        Partnership
                                    </option>

                                    <option value="Private Limited">
                                        Private Limited
                                    </option>

                                    <option value="Limited">
                                        Limited
                                    </option>

                                    <option value="Other">
                                        Other
                                    </option>

                                </select>

                            </div>


                            <!-- Registration Number -->

                            <div class="col-md-3">

                                <label class="form-label">
                                    Registration Number
                                    <span class="required">*</span>
                                </label>

                                <input
                                    type="text"
                                    class="form-control"
                                    name="registrationNumber" id="registrationNumber"
                                    required
                                >

                            </div>


                            <!-- Registration Date (AD) -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Registration Date (AD)
                                </label>
                                <div class="input-group position-relative">
                                    <input type="text" class="form-control" name="registrationDate" id="registrationDate" onclick="toggleNepaliDatePicker('registrationDate')" style="cursor: pointer;" placeholder="YYYY-MM-DD">
                                    <button class="btn btn-outline-secondary" type="button" onclick="toggleNepaliDatePicker('registrationDate')">📅</button>
                                    <div id="picker_registrationDate" class="collapse position-absolute z-3 mt-1" style="z-index: 1000; top: 100%;">
                                        <iframe src="../widgets/nepali_calendar_widget.php?target=registrationDate" style="width: 320px; height: 380px; border: none; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.12);" scrolling="no"></iframe>
                                    </div>
                                </div>
                            </div>

                            <!-- Registration Date (BS) -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Registration Date (BS)
                                </label>
                                <div class="input-group position-relative">
                                    <input type="text" class="form-control" name="registrationDateBs" id="registrationDateBs" onclick="toggleNepaliDatePicker('registrationDateBs')" style="cursor: pointer;" placeholder="YYYY-MM-DD">
                                    <button class="btn btn-outline-secondary" type="button" onclick="toggleNepaliDatePicker('registrationDateBs')">📅</button>
                                    <div id="picker_registrationDateBs" class="collapse position-absolute z-3 mt-1" style="z-index: 1000; top: 100%;">
                                        <iframe src="../widgets/nepali_calendar_widget.php?target=registrationDateBs" style="width: 320px; height: 380px; border: none; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.12);" scrolling="no"></iframe>
                                    </div>
                                </div>
                            </div>


                            <!-- Registration Authority (Hidden Fallback & Mappings) -->
                            <input type="hidden" name="registrationAuthority" id="registrationAuthority">
                            <input type="hidden" name="registrationAuthorityNp" id="registrationAuthorityNp">
                            <input type="hidden" id="registration_org_id" name="registration_org_id">
                            <input type="hidden" id="registration_org_type" name="registration_org_type">
                            <input type="hidden" id="reg_authority_id" name="reg_authority_id">
                            <input type="hidden" id="reg_ministry_id" name="reg_ministry_id">
                            <input type="hidden" id="reg_department_id" name="reg_department_id">
                            <input type="hidden" id="reg_office_id" name="reg_office_id">
                            <input type="hidden" id="reg_district_id" name="reg_district_id">

                            <!-- Registration Hierarchy Mapping (Col-MD-3 Clean Grid - Fully Free Selection) -->
                            <div class="col-md-3">
                                <label class="form-label">Authority <span class="required">*</span></label>
                                <select class="form-select" name="regGovAuthority" id="regGovAuthority" required></select>
                            </div>
                            <div class="col-md-3" id="colRegProvince" style="display:none;">
                                <label class="form-label">Province</label>
                                <select class="form-select" name="regGovProvince" id="regGovProvince"></select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Ministry</label>
                                <select class="form-select" name="regGovMinistry" id="regGovMinistry">
                                    <option value="">Select Ministry (Optional)</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Department / Directorate</label>
                                <select class="form-select" name="regGovDepartment" id="regGovDepartment">
                                    <option value="">Select Department (Optional)</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Registering Office <span class="required">*</span></label>
                                <select class="form-select border-primary" name="regGovOffice" id="regGovOffice" required>
                                    <option value="">Select Office</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Office District</label>
                                <select class="form-select" name="regGovDistrict" id="regGovDistrict">
                                    <option value="">Select District (77 Districts)</option>
                                </select>
                            </div>


                            <!-- PAN Number -->

                            <div class="col-md-3">

                                <label class="form-label">
                                    PAN Number
                                </label>

                                <input
                                    type="text"
                                    class="form-control"
                                    name="panNumber" id="panNumber"
                                >

                            </div>


                            <!-- PAN Issue Date -->

                            <div class="col-md-3">

                                <label class="form-label">
                                    PAN Issue Date
                                </label>

                                <div class="input-group position-relative">
                                    <input type="text" class="form-control" name="panIssueDate" id="panIssueDate" onclick="toggleNepaliDatePicker('panIssueDate')" style="cursor: pointer;" placeholder="YYYY-MM-DD">
                                    <button class="btn btn-outline-secondary" type="button" onclick="toggleNepaliDatePicker('panIssueDate')">📅</button>
                                    <div id="picker_panIssueDate" class="collapse position-absolute z-3 mt-1" style="z-index: 1000; top: 100%;">
                                        <iframe src="../widgets/nepali_calendar_widget.php?target=panIssueDate" style="width: 320px; height: 380px; border: none; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.12);" scrolling="no"></iframe>
                                    </div>
                                </div>

                            </div>


                            <!-- PAN Authority (Synced with IRD Offices) -->

                            <div class="col-md-3">

                                <label class="form-label">
                                    PAN Issue Authority (IRD Office)
                                </label>

                                <select
                                    class="form-select"
                                    name="panAuthority" id="panAuthority"
                                >
                                    <option value="">Select PAN Issue Authority (IRD Office)...</option>
                                </select>

                            </div>


                            <!-- Email -->

                            <div class="col-md-3">

                                <label class="form-label">
                                    Email
                                </label>

                                <input
                                    type="email"
                                    class="form-control"
                                    name="email" id="email"
                                >

                            </div>


                            <!-- Contact -->

                            <div class="col-md-3">

                                <label class="form-label">
                                    Contact
                                </label>

                                <input
                                    type="text"
                                    class="form-control"
                                    name="contact" id="contact"
                                >

                            </div>


                            <!-- Website -->

                            <div class="col-md-3">

                                <label class="form-label">
                                    Website
                                </label>

                                <input
                                    type="url"
                                    class="form-control"
                                    name="website" id="website"
                                    placeholder="https://example.com"
                                >

                            </div>

                        </div>

                    </div>


                    <!-- =========================================
                         REGISTERED ADDRESS
                    ========================================== -->

                    <div class="form-section">

                        <div class="form-section-title">
                            Registered Address
                        </div>

                        <div class="row g-3">

                            <div class="col-md-3">

                                <label class="form-label">
                                    Province
                                </label>

                                <select
                                    class="form-select"
                                    name="registeredProvince" id="registeredProvince"
                                >

                                    <option value="">
                                        Select Province
                                    </option>

                                    <option>Koshi</option>
                                    <option>Madhesh</option>
                                    <option>Bagmati</option>
                                    <option>Gandaki</option>
                                    <option>Lumbini</option>
                                    <option>Karnali</option>
                                    <option>Sudurpashchim</option>

                                </select>

                            </div>


                            <div class="col-md-3">

                                <label class="form-label">
                                    District
                                </label>

                                <select
                                    class="form-select"
                                    name="registeredDistrict" id="registeredDistrict"
                                >

                                    <option value="">
                                        Select District
                                    </option>

                                    <option>Dhanusha</option>
                                    <option>Mahottari</option>
                                    <option>Sarlahi</option>
                                    <option>Siraha</option>
                                    <option>Kathmandu</option>
                                    <option>Lalitpur</option>

                                </select>

                            </div>


                            <div class="col-md-3">

                                <label class="form-label">
                                    Municipality / VDC
                                </label>

                                <select
                                    class="form-select"
                                    name="registeredMunicipality" id="registeredMunicipality"
                                >
                                    <option value="">Select Municipality</option>
                                </select>

                            </div>


                            <div class="col-md-3">

                                <label class="form-label">
                                    Ward No.
                                </label>

                                <select
                                    class="form-select"
                                    name="registeredWard" id="registeredWard"
                                >
                                    <option value="">Select Ward</option>
                                </select>

                            </div>


                            <div class="col-md-3">

                                <label class="form-label">
                                    Town / Village
                                </label>

                                <input
                                    type="text"
                                    class="form-control"
                                    name="registeredTown" id="registeredTown"
                                >

                            </div>


                            <div class="col-md-3">

                                <label class="form-label">
                                    Street Name
                                </label>

                                <input
                                    type="text"
                                    class="form-control"
                                    name="registeredStreet" id="registeredStreet"
                                >

                            </div>

                        </div>

                    </div>


                    <!-- =========================================
                         MAILING ADDRESS
                    ========================================== -->

                    <div class="form-section">

                        <div class="d-flex justify-content-between align-items-center mb-3">

                            <div class="form-section-title mb-0 border-0">
                                Mailing Address
                            </div>

                            <div class="form-check">

                                <input
                                    class="form-check-input"
                                    type="checkbox"
                                    name="sameRegisteredAddress" id="sameRegisteredAddress"
                                >

                                <label
                                    class="form-check-label"
                                    for="sameRegisteredAddress"
                                >
                                    Same as Registered Address
                                </label>

                            </div>

                        </div>


                        <div class="row g-3">

                            <div class="col-md-3">

                                <label class="form-label">
                                    Province
                                </label>

                                <select
                                    class="form-select"
                                    name="mailingProvince" id="mailingProvince"
                                >

                                    <option value="">
                                        Select Province
                                    </option>

                                    <option>Koshi</option>
                                    <option>Madhesh</option>
                                    <option>Bagmati</option>
                                    <option>Gandaki</option>
                                    <option>Lumbini</option>
                                    <option>Karnali</option>
                                    <option>Sudurpashchim</option>

                                </select>

                            </div>


                            <div class="col-md-3">

                                <label class="form-label">
                                    District
                                </label>

                                <select
                                    class="form-select"
                                    name="mailingDistrict" id="mailingDistrict"
                                >

                                    <option value="">
                                        Select District
                                    </option>

                                    <option>Dhanusha</option>
                                    <option>Mahottari</option>
                                    <option>Sarlahi</option>
                                    <option>Siraha</option>
                                    <option>Kathmandu</option>
                                    <option>Lalitpur</option>

                                </select>

                            </div>


                            <div class="col-md-3">

                                <label class="form-label">
                                    Municipality / VDC
                                </label>

                                <select
                                    class="form-select"
                                    name="mailingMunicipality" id="mailingMunicipality"
                                >
                                    <option value="">Select Municipality</option>
                                </select>

                            </div>


                            <div class="col-md-3">

                                <label class="form-label">
                                    Ward No.
                                </label>

                                <select
                                    class="form-select"
                                    name="mailingWard" id="mailingWard"
                                >
                                    <option value="">Select Ward</option>
                                </select>

                            </div>


                            <div class="col-md-3">

                                <label class="form-label">
                                    Town / Village
                                </label>

                                <input
                                    type="text"
                                    class="form-control"
                                    name="mailingTown" id="mailingTown"
                                >

                            </div>


                            <div class="col-md-3">

                                <label class="form-label">
                                    Street Name
                                </label>

                                <input
                                    type="text"
                                    class="form-control"
                                    name="mailingStreet" id="mailingStreet"
                                >

                            </div>

                        </div>

                    </div>


                    <!-- =========================================
                    <!-- =========================================
                         AUTHORIZED PERSON
                    ========================================== -->

                    <div class="form-section">

                        <div class="d-flex justify-content-between align-items-center mb-3">

                            <div>

                                <div class="form-section-title mb-1 border-0 pb-0">
                                    Authorized Person Details
                                </div>

                                <small class="text-muted">
                                    Add authorized individual (Natural Person) for this institutional applicant.
                                </small>

                            </div>

                            <div class="d-flex gap-2">
                                <button
                                    type="button"
                                    class="btn btn-outline-primary btn-sm fw-bold shadow-sm"
                                    id="btnSearchExistingAuth"
                                    onclick="openAuthPersonSearchModal()"
                                >
                                    🔍 Select from existing
                                </button>
                                <button
                                    type="button"
                                    class="btn btn-primary btn-sm fw-bold"
                                    id="addAuthorizedBtn"
                                    disabled
                                >
                                    + Add Auth Person
                                </button>
                                <button
                                    type="button"
                                    class="btn btn-info text-dark btn-sm fw-bold shadow-sm"
                                    id="addSignatoryBtn"
                                    disabled
                                >
                                    + Add Signatory
                                </button>
                            </div>

                        </div>


                        <!-- Registration type info -->

                        <div
                            class="alert alert-info py-2"
                            id="authorizationInfo"
                        >
                            Please select registration type first.
                        </div>


                        <!-- AUTHORIZED TABLE (Always visible) -->

                        <div class="table-responsive my-3">

                            <table
                                class="table table-bordered table-hover shadow-sm bg-white"
                            >

                                <thead class="table-light">

                                    <tr>

                                        <th>#</th>

                                        <th>
                                            Name
                                        </th>

                                        <th>
                                            Type
                                        </th>

                                        <th>
                                            Citizenship / NID
                                        </th>

                                        <th>
                                            Role
                                        </th>

                                        <th>
                                            Action
                                        </th>

                                    </tr>

                                </thead>

                                <tbody id="authorizedTableBody">

                                    <tr id="noAuthorizedRow">

                                        <td
                                            colspan="6"
                                            class="text-center text-muted py-3"
                                        >
                                            No authorized person added.
                                        </td>

                                    </tr>

                                </tbody>

                            </table>

                        </div>


                        <!-- AUTHORIZED FORM (Hidden by default) -->

                        <div id="authorizedForm" style="display: none;">

                            <input type="hidden" name="authorizedType" id="authorizedType" value="Natural Person">

                            <div class="d-flex justify-content-between align-items-center mb-3 bg-white p-2 px-3 border rounded shadow-sm">
                                <span class="fw-bold text-dark" style="font-size: 0.95rem;">
                                    📝 Individual Details Form
                                </span>
                                <button
                                    type="button"
                                    class="btn btn-outline-primary btn-sm fw-bold shadow-sm"
                                    onclick="openAuthPersonSearchModal()"
                                >
                                    🔍 Select from Existing Entry
                                </button>
                            </div>

                            <div class="sub-box mb-3 bg-light p-3 border rounded">

                                <div class="row g-3 align-items-end">

                                    <!-- Role Type -->
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold text-primary">
                                            Role Type <span class="">*</span>
                                        </label>
                                        <select class="form-select" name="authorizedRoleType" id="authorizedRoleType">
                                            <option value="Authorized Person">Authorized Person (Owner/Director)</option>
                                            <option value="Signatory">Signatory (Account Operator)</option>
                                        </select>
                                    </div>

                                    <!-- Role -->
                                    <div class="col-md-4">

                                        <label class="form-label fw-bold text-primary">
                                            Role / Designation <span class="">*</span>
                                        </label>

                                        <input
                                            type="text"
                                            class="form-control"
                                            name="authorizedRole" id="authorizedRole"
                                            placeholder="e.g. Director / Partner / Proprietor"
                                        >

                                    </div>

                                </div>

                            </div>


                            <!-- =================================
                                 NATURAL PERSON FORM
                            ================================== -->

                            <div id="naturalPersonForm">


                    <div class="form-section">

                        <div class="form-section-title">Personal Details</div><div class="row g-3">

                            <!-- Salutation -->
                            <div class="col-md-2">
                                <label class="form-label">
                                    Salutation
                                </label>
                                <select class="form-select" name="personSalutation" id="personSalutation">
                                    <option value="">-- Select --</option>
                                    <option value="Mr.">Mr. (श्री)</option>
                                    <option value="Mrs.">Mrs. (श्रीमती)</option>
                                    <option value="Ms.">Ms. (सुश्री)</option>
                                    <option value="Miss">Miss (सुश्री)</option>
                                    <option value="Dr.">Dr. (डा.)</option>
                                    <option value="Prof.">Prof. (प्रा.)</option>
                                    <option value="M/S">M/S (मेसर्स)</option>
                                </select>
                            </div>

                            <!-- Full Name English -->
                            <div class="col-md-5">
                                <label class="form-label">
                                    Full Name (English) <span class="">*</span>
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="personNameEnglish" id="personNameEnglish"
                                       >
                            </div>

                            <!-- Full Name Nepali -->
                            <div class="col-md-5">
                                <label class="form-label">
                                    Full Name (Nepali)
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="personNameNepali" id="personNameNepali">
                            </div>

                            <!-- DOB (AD) -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Date of Birth (AD) <span class="">*</span>
                                </label>
                                <div class="input-group position-relative">
                                    <input type="text" class="form-control" name="personDob" id="personDob"  onclick="toggleNepaliDatePicker('personDob')" style="cursor: pointer;" placeholder="YYYY-MM-DD">
                                    <button class="btn btn-outline-secondary" type="button" onclick="toggleNepaliDatePicker('personDob')">📅</button>
                                    <div id="picker_personDob" class="collapse position-absolute z-3 mt-1" style="z-index: 1000; top: 100%;">
                                        <iframe src="../widgets/nepali_calendar_widget.php?target=personDob" style="width: 320px; height: 380px; border: none; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.12);" scrolling="no"></iframe>
                                    </div>
                                </div>
                            </div>

                            <!-- DOB (BS) -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Date of Birth (BS) <span class="">*</span>
                                </label>
                                <div class="input-group position-relative">
                                    <input type="text" class="form-control" name="personDobBs" id="personDobBs"  onclick="toggleNepaliDatePicker('personDobBs')" style="cursor: pointer;" placeholder="YYYY-MM-DD">
                                    <button class="btn btn-outline-secondary" type="button" onclick="toggleNepaliDatePicker('personDobBs')">📅</button>
                                    <div id="picker_personDobBs" class="collapse position-absolute z-3 mt-1" style="z-index: 1000; top: 100%;">
                                        <iframe src="../widgets/nepali_calendar_widget.php?target=personDobBs" style="width: 320px; height: 380px; border: none; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.12);" scrolling="no"></iframe>
                                    </div>
                                </div>
                            </div>

                            <!-- Gender -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Gender <span class="">*</span>
                                </label>
                                <select class="form-select" name="personGender" id="personGender" >
                                    <option value="">Select Gender</option>
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>

                            <!-- Marital Status -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Marital Status
                                </label>
                                <select class="form-select" name="personMaritalStatus" id="personMaritalStatus">
                                    <option value="">-- Select --</option>
                                    <option value="Unmarried">Unmarried (अविवाहित)</option>
                                    <option value="Married">Married (विवाहित)</option>
                                    <option value="Divorced">Divorced (पारपाचुके)</option>
                                    <option value="Widowed">Widowed (एकल / विधवा / विधुर)</option>
                                </select>
                            </div>

                            <!-- NID -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    NID Number
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="personNid" id="personNid">
                            </div>

                            <!-- Citizenship Number -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Citizenship Number <span class="">*</span>
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="personCitizenship" id="personCitizenship"
                                       >
                            </div>

                            <!-- Citizenship Issue Date -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Citizenship Issue Date
                                </label>
                                <div class="input-group position-relative">
                                    <input type="text" class="form-control" name="personCitizenshipDate" id="personCitizenshipDate" onclick="toggleNepaliDatePicker('personCitizenshipDate')" style="cursor: pointer;" placeholder="YYYY-MM-DD">
                                    <button class="btn btn-outline-secondary" type="button" onclick="toggleNepaliDatePicker('personCitizenshipDate')">📅</button>
                                    <div id="picker_personCitizenshipDate" class="collapse position-absolute z-3 mt-1" style="z-index: 1000; top: 100%;">
                                        <iframe src="../widgets/nepali_calendar_widget.php?target=personCitizenshipDate" style="width: 320px; height: 380px; border: none; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.12);" scrolling="no"></iframe>
                                    </div>
                                </div>
                            </div>

                            <!-- Issue District -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Citizenship Issue District
                                </label>
                                <select class="form-select" name="personCitizenshipDistrict" id="personCitizenshipDistrict">
                                    <option value="">Select District</option>
                                    <option value="Kathmandu">Kathmandu</option>
                                    <option value="Lalitpur">Lalitpur</option>
                                    <option value="Bhaktapur">Bhaktapur</option>
                                    <option value="Dhanusha">Dhanusha</option>
                                    <option value="Mahottari">Mahottari</option>
                                    <option value="Sarlahi">Sarlahi</option>
                                    <option value="Morang">Morang</option>
                                    <option value="Sunsari">Sunsari</option>
                                </select>
                            </div>

                            <!-- Issue Authority -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Citizenship Issue Authority
                                </label>
                                <select class="form-select" name="personCitizenshipAuthority" id="personCitizenshipAuthority" onchange="toggleIssuePlace(this, 'personCitizenshipIssuePlaceContainer')">
                                    <option value="">Select Authority</option>
                                    <option value="District Administration Office">District Administration Office</option>
                                    <option value="Area Administration Office">Area Administration Office</option>
                                </select>
                            </div>

                            <!-- Issue Place (Hidden by Default) -->
                            <div class="col-md-3" id="personCitizenshipIssuePlaceContainer" style="display: none;">
                                <label class="form-label">
                                    Citizenship Issue Place
                                </label>
                                <select class="form-select" name="personCitizenshipIssuePlace" id="personCitizenshipIssuePlace">
                                    <option value="">Select Place</option>
                                    <?php include 'aao_options.php'; ?>
                                </select>
                            </div>

                            <!-- Contact Number -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Mobile / Phone Number <span class="">*</span>
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="personMobile" id="personMobile"
                                       placeholder="Enter mobile or phone"
                                       >
                            </div>

                            <!-- Email Address -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Email Address
                                </label>
                                <input type="email"
                                       class="form-control"
                                       name="personEmail" id="personEmail"
                                       placeholder="Enter email address">
                            </div>

                            <!-- Reissue -->
                            <div class="col-md-3">
                                <label class="form-label d-block">
                                    Is Reissue?
                                </label>

                                <div class="form-check form-check-inline">
                                    <input class="form-check-input"
                                           type="radio"
                                           name="personReissue"
                                           id="personReissueYes"
                                           value="Yes">
                                    <label class="form-check-label" for="personReissueYes">
                                        Yes
                                    </label>
                                </div>

                                <div class="form-check form-check-inline">
                                    <input class="form-check-input"
                                           type="radio"
                                           name="personReissue"
                                           id="personReissueNo"
                                           value="No"
                                           checked>
                                    <label class="form-check-label" for="personReissueNo">
                                        No
                                    </label>
                                </div>
                            </div>

                        </div>

                        <!-- REISSUE DETAILS -->
                        <div class="reissue-box" id="personReissueDetails" style="display:none;">

                            <div class="row g-3">

                                <!-- Reissue Date -->
                                <div class="col-md-3">
                                    <label class="form-label">
                                        Reissue Date
                                    </label>
                                    <div class="input-group position-relative">
                                        <input type="text" class="form-control" name="personReissueDate" id="personReissueDate" onclick="toggleNepaliDatePicker('personReissueDate')" style="cursor: pointer;" placeholder="YYYY-MM-DD">
                                        <button class="btn btn-outline-secondary" type="button" onclick="toggleNepaliDatePicker('personReissueDate')">📅</button>
                                        <div id="picker_personReissueDate" class="collapse position-absolute z-3 mt-1" style="z-index: 1000; top: 100%;">
                                            <iframe src="../widgets/nepali_calendar_widget.php?target=personReissueDate" style="width: 320px; height: 380px; border: none; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.12);" scrolling="no"></iframe>
                                        </div>
                                    </div>
                                </div>

                                <!-- Pratilipi -->
                                <div class="col-md-3">
                                    <label class="form-label">
                                        Pratilipi Type
                                    </label>

                                    <input type="text" class="form-control" name="personPratilipiType" id="personPratilipiType" list="personPratilipiList" placeholder="Select or type copy details">
                                    <datalist id="personPratilipiList">
                                        <option value="Pratham Pratilipi (1st Copy)"></option>
                                        <option value="Dosro Pratilipi (2nd Copy)"></option>
                                        <option value="Tesro Pratilipi (3rd Copy)"></option>
                                        <option value="Chautho Pratilipi (4th Copy)"></option>
                                        <option value="Pachau Pratilipi (5th Copy)"></option>
                                        <option value="Chhaithau Pratilipi (6th Copy)"></option>
                                        <option value="Sataun Pratilipi (7th Copy)"></option>
                                        <option value="Athaun Pratilipi (8th Copy)"></option>
                                        <option value="Nawaun Pratilipi (9th Copy)"></option>
                                        <option value="Dasau Pratilipi (10th Copy)"></option>
                                    </datalist>
                                </div>

                                <!-- Reissue District -->
                                <div class="col-md-3">
                                    <label class="form-label">
                                        Reissue District
                                    </label>
                                    <select class="form-select" name="personReissueDistrict" id="personReissueDistrict">
                                        <option value="">Select District</option>
                                        <option value="Kathmandu">Kathmandu</option>
                                        <option value="Lalitpur">Lalitpur</option>
                                        <option value="Bhaktapur">Bhaktapur</option>
                                        <option value="Dhanusha">Dhanusha</option>
                                        <option value="Mahottari">Mahottari</option>
                                        <option value="Sarlahi">Sarlahi</option>
                                        <option value="Morang">Morang</option>
                                        <option value="Sunsari">Sunsari</option>
                                    </select>
                                </div>

                                <!-- Reissue Authority -->
                                <div class="col-md-3">
                                    <label class="form-label">
                                        Reissue Authority
                                    </label>
                                    <select class="form-select" name="personReissueAuthority" id="personReissueAuthority" onchange="toggleIssuePlace(this, 'personReissuePlaceContainer')">
                                        <option value="">Select Authority</option>
                                        <option value="District Administration Office">District Administration Office</option>
                                        <option value="Area Administration Office">Area Administration Office</option>
                                    </select>
                                </div>

                                <!-- Reissue Place (Hidden by Default) -->
                                <div class="col-md-3" id="personReissuePlaceContainer" style="display: none;">
                                    <label class="form-label">
                                        Reissue Place
                                    </label>
                                    <select class="form-select" name="personReissuePlace" id="personReissuePlace">
                                        <option value="">Select Place</option>
                                        <?php include 'aao_options.php'; ?>
                                    </select>
                                </div>

                            </div>

                        </div>

                    </div>


                    <!-- ================= PERMANENT ADDRESS ================= -->
                    <div class="form-section">

                        <div class="form-section-title">
                            Permanent Address
                        </div>

                        <div class="row g-3">

                            <div class="col-md-3">
                                <label class="form-label">Province</label>
                                <select class="form-select" name="personProvince" id="personProvince">
                                    <option value="">Select Province</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">District</label>
                                <select class="form-select" name="personDistrict" id="personDistrict" disabled>
                                    <option value="">Select District</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Municipality / VDC
                                </label>
                                <select class="form-select" name="personMunicipality" id="personMunicipality" disabled>
                                    <option value="">Select Municipality</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Ward No.
                                </label>
                                <select class="form-select" name="personWard" id="personWard" disabled>
                                    <option value="">Select Ward</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Town / Village
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="personTown" id="personTown">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Street Name
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="personStreet" id="personStreet">
                            </div>

                        </div>

                    </div>


                    <!-- ================= TEMPORARY ADDRESS ================= -->
                    <div class="form-section">

                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div class="form-section-title mb-0 border-0 pb-0">
                                Temporary Address
                            </div>

                            <div class="form-check same-address">
                                <input class="form-check-input"
                                       type="checkbox"
                                       name="personSameAddress" id="personSameAddress">

                                <label class="form-check-label" for="personSameAddress">
                                    Same as Permanent Address
                                </label>
                            </div>
                        </div>

                        <div class="row g-3">

                            <div class="col-md-3">
                                <label class="form-label">Province</label>
                                <select class="form-select" name="personTempProvince" id="personTempProvince">
                                    <option value="">Select Province</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">District</label>
                                <select class="form-select" name="personTempDistrict" id="personTempDistrict" disabled>
                                    <option value="">Select District</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Municipality / VDC
                                </label>
                                <select class="form-select" name="personTempMunicipality" id="personTempMunicipality" disabled>
                                    <option value="">Select Municipality</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Ward No.
                                </label>
                                <select class="form-select" name="personTempWard" id="personTempWard" disabled>
                                    <option value="">Select Ward</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Town / Village
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="personTempTown" id="personTempTown">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Street Name
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="personTempStreet" id="personTempStreet">
                            </div>

                        </div>

                    </div>


                    <!-- ================= FAMILY DETAILS ================= -->

                    <div class="form-section">

                        <div class="form-section-title">
                            Family Details
                        </div>

                        <div class="row g-3">

                            <div class="col-md-3">
                                <label class="form-label">
                                    Grandfather
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="personGrandfather" id="personGrandfather">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Grandmother
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="personGrandmother" id="personGrandmother">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Father
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="personFather" id="personFather">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Mother
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="personMother" id="personMother">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Spouse <span class="required" id="personSpouseReqSpan" style="display:none;">*</span>
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="personSpouse" id="personSpouse">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Daughter
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="personDaughter" id="personDaughter">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Son
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="personSon" id="personSon">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Father-in-Law <span class="required" id="personFatherInLawReqSpan" style="display:none;">*</span>
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="personFatherInLaw" id="personFatherInLaw">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Mother-in-Law
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="personMotherInLaw" id="personMotherInLaw">
                            </div>

                            <!-- AUTHORIZED BUTTONS -->

                            <div class="d-flex justify-content-end gap-2 mb-3">

                                <button
                                    type="button"
                                    class="btn btn-secondary btn-sm"
                                    id="cancelAuthorizedBtn"
                                >
                                    Cancel
                                </button>

                                <button
                                    type="button"
                                    class="btn btn-primary btn-sm fw-bold px-3"
                                    id="closeViewAuthorizedBtn"
                                    style="display:none;"
                                    onclick="closeViewAuthorized()"
                                >
                                    ✖ Close View
                                </button>

                                <button
                                    type="button"
                                    class="btn btn-success btn-sm"
                                    id="saveAuthorizedBtn"
                                >
                                    Save Authorized
                                </button>

                            </div>

                        </div>

                    </div>


    </div>
</div>

<!-- =========================================================
     SEARCH EXISTING AUTHORIZED PERSON MODAL
========================================================== -->
<div class="modal fade" id="authPersonSearchModal" tabindex="-1" aria-hidden="true" style="z-index: 1060;">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content shadow-lg border-0">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title text-white">🔍 Select Existing Individual as Authorized Person</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <div class="input-group mb-3">
                    <input type="text" class="form-control" name="authSearchInput" id="authSearchInput" placeholder="Type name, citizenship, mobile, or email to search...">
                    <button class="btn btn-primary fw-bold" type="button" id="btnDoAuthSearch" onclick="searchExistingAuthPersons()">Search</button>
                </div>
                <div class="table-responsive" style="max-height: 360px;">
                    <table class="table table-hover align-middle border">
                        <thead class="table-light">
                            <tr>
                                <th>Source</th>
                                <th>Name</th>
                                <th>Citizenship / NID</th>
                                <th>Contact</th>
                                <th width="15%">Action</th>
                            </tr>
                        </thead>
                        <tbody id="authSearchResultsBody">
                            <tr><td colspan="5" class="text-center text-muted py-3">Click Search or type to find individual records.</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="modal-footer bg-light py-2">
                <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>