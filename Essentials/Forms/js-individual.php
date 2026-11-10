<script src="../Date Converter/core.js"></script>


<script>

    window.applicants = window.applicants || [];
    window.editIndex = -1;

    // =========================
    // AD/BS DATE CONVERSION
    // =========================
    document.addEventListener("DOMContentLoaded", function() {
        document.getElementById("dob")?.addEventListener("change", function () {
            if (!window.DateConverter) return;
            const adDate = this.value;
            if (adDate) {
                try {
                    const dateObj = new Date(adDate);
                    const y = dateObj.getFullYear();
                    const m = dateObj.getMonth() + 1;
                    const d = dateObj.getDate();
                    
                    const converter = new window.DateConverter(y, m, d);
                    document.getElementById("dobBs").value = converter.convertToBS().toBSString().replace(/-/g, '/');
                } catch (e) {
                    console.error("AD to BS Conversion Error:", e);
                }
            }
        });

        document.getElementById("dobBs")?.addEventListener("change", function () {
            if (!window.DateConverter) return;
            const bsDate = this.value.trim();
            const parts = bsDate.split(/[-/.]/);
            
            if (parts.length === 3) {
                const y = parseInt(parts[0]);
                const m = parseInt(parts[1]);
                const d = parseInt(parts[2]);
                
                if (!isNaN(y) && !isNaN(m) && !isNaN(d)) {
                    try {
                        const converter = new window.DateConverter(y, m, d);
                        const adString = converter.convertToAD().toADString();
                        
                        const [adY, adM, adD] = adString.split('-');
                        const formattedAd = `${adY}-${adM.toString().padStart(2, '0')}-${adD.toString().padStart(2, '0')}`;
                        document.getElementById("dob").value = formattedAd;
                    } catch (e) {
                        console.error("BS to AD Conversion Error:", e);
                    }
                }
            }
        });
    });


    // =========================
    // ADD DETAILS BUTTON
    // =========================

    document.getElementById("addApplicantBtn")?.addEventListener("click", function () {

        editIndex = -1;

        document.getElementById("applicantForm").reset();

        document.getElementById("reissueNo").checked = true;

        document.getElementById("reissueDetails").style.display = "none";

        document.getElementById("applicantFormSection").style.display = "block";

        window.scrollTo({
            top: document.getElementById("applicantFormSection").offsetTop - 20,
            behavior: "smooth"
        });

    });


    // =========================
    // REISSUE TOGGLE
    // =========================

    document.querySelectorAll('input[name="reissue"]').forEach(function (radio) {

        radio.addEventListener("change", function () {

            if (document.getElementById("reissueYes").checked) {

                document.getElementById("reissueDetails").style.display = "block";

            } else {

                document.getElementById("reissueDetails").style.display = "none";

            }

        });

    });


    // =========================
    // SAME ADDRESS
    // =========================

    document.getElementById("sameAddress")?.addEventListener("change", function () {

        if (this.checked) {
            
            const fields = ["Province", "District", "Municipality", "Ward", "Town", "Street"];
            
            fields.forEach(field => {
                const perEl = document.getElementById(`per${field}`);
                const tempEl = document.getElementById(`temp${field}`);
                
                if (perEl.tagName === "SELECT") {
                    tempEl.innerHTML = perEl.innerHTML;
                    tempEl.disabled = perEl.disabled;
                }
                
                tempEl.value = perEl.value;
            });

        }

    });


    // DATE FORMAT
    // =========================

    function formatDate(date) {

        if (!date) {
            return "-";
        }

        const d = new Date(date);

        if (isNaN(d.getTime())) {
            return date;
        }

        return d.toLocaleDateString("en-GB");

    }

    // =========================
    // LOCATION JSON INTEGRATION
    // =========================

    let locationsData = [];

    // Helper function to fetch data from JSON
    async function loadLocationsData() {
        try {
            const response = await fetch('forms/locations_en.json');
            if (!response.ok) throw new Error("Network response error");
            const data = await response.json();
            locationsData = data.provinces || [];
            initCascadingDropdowns("per");
            initCascadingDropdowns("temp");
            
            let allDistricts = [];
            locationsData.forEach(p => {
                if (p.districts) {
                    p.districts.forEach(d => allDistricts.push(d));
                }
            });
            allDistricts.sort((a, b) => a.name.localeCompare(b.name));
            
            const issueSelect = document.getElementById("citizenshipIssueDistrict");
            if (issueSelect) populateDropdown(issueSelect, allDistricts, "Select District");
            
            // Auto-populate if drawerData exists (Edit Mode)
            if (window.drawerData) {
                // Explicit fallback mapping for applicant details
                if (window.drawerData.salutation) {
                    const salEl = document.getElementById('salutation');
                    if (salEl && !salEl.value) salEl.value = window.drawerData.salutation;
                }
                if (window.drawerData.maritalStatus) {
                    const msEl = document.getElementById('maritalStatus');
                    if (msEl && !msEl.value) msEl.value = window.drawerData.maritalStatus;
                }
                if (window.drawerData.applicant_name) {
                    const fnEl = document.getElementById('fullNameEnglish');
                    if (fnEl && !fnEl.value) fnEl.value = window.drawerData.applicant_name;
                }
                if (window.drawerData.contact_no || window.drawerData.contact || window.drawerData.mobile) {
                    const mobEl = document.getElementById('mobile');
                    if (mobEl && !mobEl.value) mobEl.value = window.drawerData.mobile || window.drawerData.contact_no || window.drawerData.contact;
                }
                if (window.drawerData.email) {
                    const emEl = document.getElementById('email');
                    if (emEl && !emEl.value) emEl.value = window.drawerData.email;
                }
                if (window.drawerData.applicant_name_np) {
                    const fnNpEl = document.getElementById('fullNameNepali');
                    if (fnNpEl && !fnNpEl.value) fnNpEl.value = window.drawerData.applicant_name_np;
                }

                // 1. Standard Fields (non-location cascades)
                for (const [key, value] of Object.entries(window.drawerData)) {
                    if (['perProvince', 'perDistrict', 'perMunicipality', 'perWard', 'tempProvince', 'tempDistrict', 'tempMunicipality', 'tempWard'].includes(key)) {
                        continue; // Handle location cascades sequentially below
                    }
                    const el = document.getElementById(key);
                    if (el) {
                        if (el.type === 'radio' || el.type === 'checkbox') {
                            if (el.value === value || (el.type === 'checkbox' && (value === 'on' || value === true || value === 'Yes'))) {
                                el.checked = true;
                                el.dispatchEvent(new Event('change'));
                            }
                        } else {
                            let finalVal = value || '';
                            if (key === 'fullNameEnglish' && !finalVal) {
                                finalVal = window.drawerData.applicant_name || '';
                            }
                            if (key === 'mobile' && !finalVal) {
                                finalVal = window.drawerData.contact_no || window.drawerData.contact || '';
                            }
                            if (key === 'email' && !finalVal) {
                                finalVal = window.drawerData.email || '';
                            }
                            el.value = finalVal;
                            el.dispatchEvent(new Event('change'));
                        }
                    }
                }

                // Reissue radio toggle handling
                if (window.drawerData.reissueYes === 'Yes' || window.drawerData.reissue === 'Yes') {
                    const rYes = document.getElementById('reissueYes');
                    if (rYes) { rYes.checked = true; rYes.dispatchEvent(new Event('change')); }
                } else if (window.drawerData.reissueNo === 'No' || window.drawerData.reissue === 'No') {
                    const rNo = document.getElementById('reissueNo');
                    if (rNo) { rNo.checked = true; rNo.dispatchEvent(new Event('change')); }
                }

                // Citizenship Authority toggle handling
                if (window.drawerData.citizenshipAuthority) {
                    const authEl = document.getElementById('citizenshipAuthority');
                    if (authEl) {
                        authEl.value = window.drawerData.citizenshipAuthority;
                        authEl.dispatchEvent(new Event('change'));
                    }
                }

                // 2. Sequential Ordered Location Auto-Population for Permanent Address
                const perProv = window.drawerData.perProvince;
                const perDist = window.drawerData.perDistrict;
                const perMuni = window.drawerData.perMunicipality;
                const perWard = window.drawerData.perWard;

                if (perProv) {
                    const provEl = document.getElementById('perProvince');
                    if (provEl) {
                        provEl.value = perProv;
                        provEl.dispatchEvent(new Event('change'));
                        
                        if (perDist) {
                            const distEl = document.getElementById('perDistrict');
                            if (distEl) {
                                distEl.value = perDist;
                                distEl.dispatchEvent(new Event('change'));
                                
                                if (perMuni) {
                                    const muniEl = document.getElementById('perMunicipality');
                                    if (muniEl) {
                                        muniEl.value = perMuni;
                                        muniEl.dispatchEvent(new Event('change'));
                                        
                                        if (perWard) {
                                            const wardEl = document.getElementById('perWard');
                                            if (wardEl) {
                                                wardEl.value = perWard;
                                                wardEl.dispatchEvent(new Event('change'));
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // 3. Sequential Ordered Location Auto-Population for Temporary Address
                const tempProv = window.drawerData.tempProvince;
                const tempDist = window.drawerData.tempDistrict;
                const tempMuni = window.drawerData.tempMunicipality;
                const tempWard = window.drawerData.tempWard;

                if (tempProv) {
                    const tProvEl = document.getElementById('tempProvince');
                    if (tProvEl) {
                        tProvEl.value = tempProv;
                        tProvEl.dispatchEvent(new Event('change'));
                        
                        if (tempDist) {
                            const tDistEl = document.getElementById('tempDistrict');
                            if (tDistEl) {
                                tDistEl.value = tempDist;
                                tDistEl.dispatchEvent(new Event('change'));
                                
                                if (tempMuni) {
                                    const tMuniEl = document.getElementById('tempMunicipality');
                                    if (tMuniEl) {
                                        tMuniEl.value = tempMuni;
                                        tMuniEl.dispatchEvent(new Event('change'));
                                        
                                        if (tempWard) {
                                            const tWardEl = document.getElementById('tempWard');
                                            if (tWardEl) {
                                                tWardEl.value = tempWard;
                                                tWardEl.dispatchEvent(new Event('change'));
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            
        } catch (error) {
            console.error("Error loading locations_en.json:", error);
        }
    }

    // Helper function to populate <select> options
    function populateDropdown(selectElement, data, placeholderText) {
        selectElement.innerHTML = `<option value="">${placeholderText}</option>`;
        data.forEach(item => {
            const option = document.createElement('option');
            option.value = item.name; // Using name as value for the form submission
            option.textContent = item.name;
            selectElement.appendChild(option);
        });
        selectElement.disabled = false;
    }

    // Helper to clear and disable dependent dropdowns
    function resetDropdowns(...selectElements) {
        selectElements.forEach(el => {
            el.innerHTML = `<option value="">Select Option</option>`;
            el.disabled = true;
        });
    }

    // Function to attach cascading logic
    function initCascadingDropdowns(prefix) {
        const provinceSelect = document.getElementById(`${prefix}Province`);
        const districtSelect = document.getElementById(`${prefix}District`);
        const municipalitySelect = document.getElementById(`${prefix}Municipality`);
        const wardSelect = document.getElementById(`${prefix}Ward`);

        if (!provinceSelect || !districtSelect) return;

        // Load Provinces initially
        populateDropdown(provinceSelect, locationsData, "Select Province"); 

        // When Province changes -> load Districts
        provinceSelect.addEventListener("change", function() {
            resetDropdowns(districtSelect, municipalitySelect, wardSelect);
            if (this.value) {
                const province = locationsData.find(p => p.name === this.value);
                if (province && province.districts) {
                    populateDropdown(districtSelect, province.districts, "Select District");
                }
            }
        });

        // When District changes -> load Municipalities
        districtSelect.addEventListener("change", function() {
            resetDropdowns(municipalitySelect, wardSelect);
            if (this.value) {
                const provinceName = provinceSelect.value;
                const province = locationsData.find(p => p.name === provinceName);
                if (province) {
                    const district = province.districts.find(d => d.name === this.value);
                    if (district && district.municipalities) {
                        populateDropdown(municipalitySelect, district.municipalities, "Select Municipality");
                    }
                }
            }
        });

        // When Municipality changes -> load Wards
        municipalitySelect.addEventListener("change", function() {
            resetDropdowns(wardSelect);
            if (this.value) {
                const provinceName = provinceSelect.value;
                const districtName = districtSelect.value;
                const province = locationsData.find(p => p.name === provinceName);
                if (province) {
                    const district = province.districts.find(d => d.name === districtName);
                    if (district) {
                        const municipality = district.municipalities.find(m => m.name === this.value);
                        if (municipality && municipality.wards) {
                            populateDropdown(wardSelect, municipality.wards, "Select Ward");
                        }
                    }
                }
            }
        });
    }

    // Load locations data on page load
    document.addEventListener("DOMContentLoaded", function() {
        const reuseData = localStorage.getItem('reuseApplicantData');
        if (reuseData) {
            window.drawerData = Object.assign(window.drawerData || {}, JSON.parse(reuseData));
            localStorage.removeItem('reuseApplicantData');
            
            // if we are in profile.php, toggle the edit form open automatically
            if (typeof toggleEditForm === 'function') {
                const form = document.getElementById('editFormContainer');
                if (form && form.style.display === 'none') {
                    toggleEditForm();
                }
            }
        }
        
        loadLocationsData();

        const msEl = document.getElementById('maritalStatus');
        const genEl = document.getElementById('gender');
        if (msEl) msEl.addEventListener('change', updateMaritalStatusValidation);
        if (genEl) genEl.addEventListener('change', updateMaritalStatusValidation);
        updateMaritalStatusValidation();
    });

    function updateMaritalStatusValidation() {
        const maritalStatus = document.getElementById('maritalStatus')?.value;
        const gender = document.getElementById('gender')?.value;
        const spouseInput = document.getElementById('spouse');
        const spouseReqSpan = document.getElementById('spouseReqSpan');
        const filInput = document.getElementById('fatherInLaw');
        const filReqSpan = document.getElementById('fatherInLawReqSpan');

        if (maritalStatus === 'Married') {
            if (gender === 'Female') {
                if (spouseInput) spouseInput.required = true;
                if (spouseReqSpan) spouseReqSpan.style.display = 'inline';
                if (filInput) filInput.required = true;
                if (filReqSpan) filReqSpan.style.display = 'inline';
            } else {
                if (spouseInput) spouseInput.required = true;
                if (spouseReqSpan) spouseReqSpan.style.display = 'inline';
                if (filInput) filInput.required = false;
                if (filReqSpan) filReqSpan.style.display = 'none';
            }
        } else {
            if (spouseInput) spouseInput.required = false;
            if (spouseReqSpan) spouseReqSpan.style.display = 'none';
            if (filInput) filInput.required = false;
            if (filReqSpan) filReqSpan.style.display = 'none';
        }
    }

</script>


