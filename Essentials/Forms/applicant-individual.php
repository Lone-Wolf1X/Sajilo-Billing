<div id="applicantFormSection" style="display:block;">

                <div id="applicantFormInner">

                    <!-- ================= BASIC DETAILS ================= -->
                    <div class="form-section">

                        <div class="form-section-title d-flex justify-content-between align-items-center">
                            <span><?= isset($formTitle) ? $formTitle : 'Applicant Information' ?></span>
                            <div>
                                <a href="search-existing.php?type=Individual" class="btn btn-sm btn-outline-primary fw-bold shadow-sm">
                                    🔍 Select from existing entries
                                </a>
                            </div>
                        </div>

                        <div class="row g-3">

                            <!-- Salutation -->
                            <div class="col-md-2">
                                <label class="form-label">
                                    Salutation <span class="required">*</span>
                                </label>
                                <select class="form-select" name="salutation" id="salutation" required>
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
                                       name="fullNameEnglish" id="fullNameEnglish"
                                       required>
                            </div>

                            <!-- Full Name Nepali -->
                            <div class="col-md-5">
                                <label class="form-label">
                                    Full Name (Nepali)
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="fullNameNepali" id="fullNameNepali">
                            </div>

                            <!-- DOB (AD) -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Date of Birth (AD) <span class="required">*</span>
                                </label>
                                <div class="input-group position-relative">
                                    <input type="text" class="form-control" name="dob" id="dob" required onclick="toggleNepaliDatePicker('dob')" style="cursor: pointer;" placeholder="YYYY-MM-DD">
                                    <button class="btn btn-outline-secondary" type="button" onclick="toggleNepaliDatePicker('dob')">📅</button>
                                    <div id="picker_dob" class="collapse position-absolute z-3 mt-1" style="z-index: 1000; top: 100%;">
                                        <iframe src="../widgets/nepali_calendar_widget.php?target=dob" style="width: 320px; height: 380px; border: none; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.12);" scrolling="no"></iframe>
                                    </div>
                                </div>
                            </div>

                            <!-- DOB (BS) -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Date of Birth (BS) <span class="required">*</span>
                                </label>
                                <div class="input-group position-relative">
                                    <input type="text" class="form-control" name="dobBs" id="dobBs" required onclick="toggleNepaliDatePicker('dobBs')" style="cursor: pointer;" placeholder="YYYY-MM-DD">
                                    <button class="btn btn-outline-secondary" type="button" onclick="toggleNepaliDatePicker('dobBs')">📅</button>
                                    <div id="picker_dobBs" class="collapse position-absolute z-3 mt-1" style="z-index: 1000; top: 100%;">
                                        <iframe src="../widgets/nepali_calendar_widget.php?target=dobBs" style="width: 320px; height: 380px; border: none; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.12);" scrolling="no"></iframe>
                                    </div>
                                </div>
                            </div>

                            <!-- Gender -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Gender <span class="required">*</span>
                                </label>
                                <select class="form-select" name="gender" id="gender" required>
                                    <option value="">Select Gender</option>
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>

                            <!-- Marital Status -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Marital Status <span class="required">*</span>
                                </label>
                                <select class="form-select" name="maritalStatus" id="maritalStatus" required>
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
                                       name="nidNumber" id="nidNumber">
                            </div>

                            <!-- Citizenship Number -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Citizenship Number <span class="required">*</span>
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="citizenshipNumber" id="citizenshipNumber"
                                       required>
                            </div>

                            <!-- Citizenship Issue Date -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Citizenship Issue Date
                                </label>
                                <div class="input-group position-relative">
                                    <input type="text" class="form-control" name="citizenshipIssueDate" id="citizenshipIssueDate" onclick="toggleNepaliDatePicker('citizenshipIssueDate')" style="cursor: pointer;" placeholder="YYYY-MM-DD">
                                    <button class="btn btn-outline-secondary" type="button" onclick="toggleNepaliDatePicker('citizenshipIssueDate')">📅</button>
                                    <div id="picker_citizenshipIssueDate" class="collapse position-absolute z-3 mt-1" style="z-index: 1000; top: 100%;">
                                        <iframe src="../widgets/nepali_calendar_widget.php?target=citizenshipIssueDate" style="width: 320px; height: 380px; border: none; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.12);" scrolling="no"></iframe>
                                    </div>
                                </div>
                            </div>

                            <!-- Issue District -->
                            <div class="col-md-3">
                                <label class="form-label">
                                    Citizenship Issue District
                                </label>
                                <select class="form-select" name="citizenshipIssueDistrict" id="citizenshipIssueDistrict">
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
                                <select class="form-select" name="citizenshipAuthority" id="citizenshipAuthority" onchange="toggleIssuePlace(this, 'citizenshipIssuePlaceContainer')">
                                    <option value="">Select Authority</option>
                                    <option value="District Administration Office">District Administration Office</option>
                                    <option value="Area Administration Office">Area Administration Office</option>
                                </select>
                            </div>

                            <!-- Issue Place (Hidden by Default) -->
                            <div class="col-md-3" id="citizenshipIssuePlaceContainer" style="display: none;">
                                <label class="form-label">
                                    Citizenship Issue Place
                                </label>
                                <select class="form-select" name="citizenshipIssuePlace" id="citizenshipIssuePlace">
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
                                       name="mobile" id="mobile"
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
                                       name="email" id="email"
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
                                           name="reissue"
                                           id="reissueYes"
                                           value="Yes">
                                    <label class="form-check-label" for="reissueYes">
                                        Yes
                                    </label>
                                </div>

                                <div class="form-check form-check-inline">
                                    <input class="form-check-input"
                                           type="radio"
                                           name="reissue"
                                           id="reissueNo"
                                           value="No"
                                           checked>
                                    <label class="form-check-label" for="reissueNo">
                                        No
                                    </label>
                                </div>
                            </div>

                        </div>

                        <!-- REISSUE DETAILS -->
                        <div class="reissue-box" id="reissueDetails" style="display:none;">

                            <div class="row g-3">

                                <!-- Reissue Date -->
                                <div class="col-md-3">
                                    <label class="form-label">
                                        Reissue Date
                                    </label>
                                    <div class="input-group position-relative">
                                        <input type="text" class="form-control" name="reissueDate" id="reissueDate" onclick="toggleNepaliDatePicker('reissueDate')" style="cursor: pointer;" placeholder="YYYY-MM-DD">
                                        <button class="btn btn-outline-secondary" type="button" onclick="toggleNepaliDatePicker('reissueDate')">📅</button>
                                        <div id="picker_reissueDate" class="collapse position-absolute z-3 mt-1" style="z-index: 1000; top: 100%;">
                                            <iframe src="../widgets/nepali_calendar_widget.php?target=reissueDate" style="width: 320px; height: 380px; border: none; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.12);" scrolling="no"></iframe>
                                        </div>
                                    </div>
                                </div>

                                <!-- Pratilipi -->
                                <div class="col-md-3">
                                    <label class="form-label">
                                        Pratilipi Type
                                    </label>

                                    <input type="text" class="form-control" name="pratilipiType" id="pratilipiType" list="pratilipiList" placeholder="Select or type copy details">
                                    <datalist id="pratilipiList">
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
                                    <select class="form-select" name="reissueDistrict" id="reissueDistrict">
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
                                    <select class="form-select" name="reissueAuthority" id="reissueAuthority" onchange="toggleIssuePlace(this, 'reissuePlaceContainer')">
                                        <option value="">Select Authority</option>
                                        <option value="District Administration Office">District Administration Office</option>
                                        <option value="Area Administration Office">Area Administration Office</option>
                                    </select>
                                </div>

                                <!-- Reissue Place (Hidden by Default) -->
                                <div class="col-md-3" id="reissuePlaceContainer" style="display: none;">
                                    <label class="form-label">
                                        Reissue Place
                                    </label>
                                    <select class="form-select" name="reissuePlace" id="reissuePlace">
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
                                <select class="form-select" name="perProvince" id="perProvince">
                                    <option value="">Select Province</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">District</label>
                                <select class="form-select" name="perDistrict" id="perDistrict" disabled>
                                    <option value="">Select District</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Municipality / VDC
                                </label>
                                <select class="form-select" name="perMunicipality" id="perMunicipality" disabled>
                                    <option value="">Select Municipality</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Ward No.
                                </label>
                                <select class="form-select" name="perWard" id="perWard" disabled>
                                    <option value="">Select Ward</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Town / Village
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="perTown" id="perTown">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Street Name
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="perStreet" id="perStreet">
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
                                       name="sameAddress" id="sameAddress">

                                <label class="form-check-label" for="sameAddress">
                                    Same as Permanent Address
                                </label>
                            </div>
                        </div>

                        <div class="row g-3">

                            <div class="col-md-3">
                                <label class="form-label">Province</label>
                                <select class="form-select" name="tempProvince" id="tempProvince">
                                    <option value="">Select Province</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">District</label>
                                <select class="form-select" name="tempDistrict" id="tempDistrict" disabled>
                                    <option value="">Select District</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Municipality / VDC
                                </label>
                                <select class="form-select" name="tempMunicipality" id="tempMunicipality" disabled>
                                    <option value="">Select Municipality</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Ward No.
                                </label>
                                <select class="form-select" name="tempWard" id="tempWard" disabled>
                                    <option value="">Select Ward</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Town / Village
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="tempTown" id="tempTown">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Street Name
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="tempStreet" id="tempStreet">
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
                                       name="grandfather" id="grandfather">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Grandmother
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="grandmother" id="grandmother">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Father
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="father" id="father">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Mother
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="mother" id="mother">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Spouse <span class="required" id="spouseReqSpan" style="display:none;">*</span>
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="spouse" id="spouse">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Daughter
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="daughter" id="daughter">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Son
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="son" id="son">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Father-in-Law <span class="required" id="fatherInLawReqSpan" style="display:none;">*</span>
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="fatherInLaw" id="fatherInLaw">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">
                                    Mother-in-Law
                                </label>
                                <input type="text"
                                       class="form-control"
                                       name="motherInLaw" id="motherInLaw">
                            </div>

                        </div>

                    </div>


                    <!-- ================= FORM BUTTONS ================= -->
                    <div class="d-flex justify-content-end gap-2">

                </div>

            </div>


            <!-- ================= SUMMARY TABLE ================= -->