                         AUTHORIZED PERSON
                    ========================================== -->

                    <div class="form-section">

                        <div class="d-flex justify-content-between align-items-center mb-3">

                            <div>

                                <div class="form-section-title mb-1 border-0 pb-0">
                                    Joint Account Holders Details
                                </div>

                                <small class="text-muted">
                                    Add joint holder (Natural Person) for this joint account.
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
                                    id="addJointHolderBtn"
                                >
                                    + Add Joint Holder
                                </button>
                            </div>

                        </div>

                        <!-- Info -->

                        <div
                            class="alert alert-info py-2"
                            id="authorizationInfo"
                        >
                            You can add multiple joint holders for this account.
                        </div>


                        <!-- AUTHORIZED FORM (Hidden by default) -->

                        <div id="authorizedForm" style="display: none;">

                            <input type="hidden" id="authorizedType" value="Natural Person">

                            <div class="sub-box mb-3 bg-light p-3 border rounded">

                                <div class="row g-3 align-items-end">

                                    <!-- Role -->

                                    <div class="col-md-4">

                                        <label class="form-label fw-bold text-primary">
                                            Role / Designation <span class="required">*</span>
                                        </label>

                                        <input
                                            type="text"
                                            class="form-control"
                                            id="authorizedRole"
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
                                <select class="form-select" id="personSalutation">
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
                                    Full Name (English) <span class="required">*</span>
                                </label>
                                <input type="text"
                                       class="form-control"
                                       id="personNameEnglish"
                                       required>
                            </div>

                            <!-- Full Name Nepali -->
                            <div class="col-md-5">
                                <label class="form-label">
                                    Full Name (Nepali)
                                </label>
                                <input type="text"
                                       class="form-control"
                                       id="personNameNepali">
                            </div>

                            <!-- DOB (AD) -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Date of Birth (AD) <span class="required">*</span>
                                </label>
                                <div class="input-group position-relative">
                                    <input type="text" class="form-control" id="personDob" required onclick="toggleNepaliDatePicker('personDob')" style="cursor: pointer;" placeholder="YYYY-MM-DD">
                                    <button class="btn btn-outline-secondary" type="button" onclick="toggleNepaliDatePicker('personDob')">📅</button>
                                    <div id="picker_personDob" class="collapse position-absolute z-3 mt-1" style="z-index: 1000; top: 100%;">
                                        <iframe src="../widgets/nepali_calendar_widget.php?target=personDob" style="width: 320px; height: 380px; border: none; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.12);" scrolling="no"></iframe>
                                    </div>
                                </div>
                            </div>

                            <!-- DOB (BS) -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Date of Birth (BS) <span class="required">*</span>
                                </label>
                                <div class="input-group position-relative">
                                    <input type="text" class="form-control" id="personDobBs" required onclick="toggleNepaliDatePicker('personDobBs')" style="cursor: pointer;" placeholder="YYYY-MM-DD">
                                    <button class="btn btn-outline-secondary" type="button" onclick="toggleNepaliDatePicker('personDobBs')">📅</button>
                                    <div id="picker_personDobBs" class="collapse position-absolute z-3 mt-1" style="z-index: 1000; top: 100%;">
                                        <iframe src="../widgets/nepali_calendar_widget.php?target=personDobBs" style="width: 320px; height: 380px; border: none; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.12);" scrolling="no"></iframe>
                                    </div>
                                </div>
                            </div>

                            <!-- Gender -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Gender <span class="required">*</span>
                                </label>
                                <select class="form-select" id="personGender" required>
                                    <option value="">Select Gender</option>
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>

                            <!-- NID -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    NID Number
                                </label>
                                <input type="text"
                                       class="form-control"
                                       id="personNid">
                            </div>

                            <!-- Citizenship Number -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Citizenship Number <span class="required">*</span>
                                </label>
                                <input type="text"
                                       class="form-control"
                                       id="personCitizenship"
                                       required>
                            </div>

                            <!-- Citizenship Issue Date -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Citizenship Issue Date
                                </label>
                                <div class="input-group position-relative">
                                    <input type="text" class="form-control" id="personCitizenshipDate" onclick="toggleNepaliDatePicker('personCitizenshipDate')" style="cursor: pointer;" placeholder="YYYY-MM-DD">
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
                                <select class="form-select" id="personCitizenshipDistrict">
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
                                <select class="form-select" id="personCitizenshipAuthority" onchange="toggleIssuePlace(this, 'personCitizenshipIssuePlaceContainer')">
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
                                <select class="form-select" id="personCitizenshipIssuePlace">
                                    <option value="">Select Place</option>
                                    <?php include 'aao_options.php'; ?>
                                </select>
                            </div>

                            <!-- Contact Number -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Mobile / Phone Number <span class="required">*</span>
                                </label>
                                <input type="text"
                                       class="form-control"
                                       id="personMobile"
                                       placeholder="Enter mobile or phone"
                                       required>
                            </div>

                            <!-- Email Address -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Email Address
                                </label>
                                <input type="email"
                                       class="form-control"
                                       id="personEmail"
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

                            <!-- ACTION BUTTONS -->
                            <div class="d-flex justify-content-end gap-2 mt-4">
                                <button type="button" class="btn btn-secondary" id="cancelAuthorizedBtn">Cancel</button>
                                <button type="button" class="btn btn-primary fw-bold" id="saveAuthorizedBtn">Save Joint Holder</button>
                            </div>
                        </div> <!-- end authorizedForm -->

                        <!-- AUTHORIZED TABLE -->
                        <div class="table-responsive mt-4">
                            <table class="table table-bordered table-hover" id="authorizedTable">
                                <thead class="table-light">
                                    <tr>
                                        <th>Name</th>
                                        <th>Role</th>
                                        <th>Citizenship No.</th>
                                        <th>Mobile</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="authorizedTableBody">
                                    <tr id="emptyAuthRow">
                                        <td colspan="5" class="text-center text-muted py-4">
                                            No joint holders added yet.
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
