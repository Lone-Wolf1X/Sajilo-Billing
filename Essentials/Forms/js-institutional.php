<script>

    // =========================================================
    // GLOBAL DATA
    // =========================================================

    window.units = window.units || [];

    window.editIndex = -1;

    let currentUnitAuthorized = [];

    let editUnitIndex = -1;

    let editAuthorizedIndex = -1;


    // =========================================================
    // ADD UNIT
    // =========================================================

    document
        .getElementById("addUnitBtn")
        ?.addEventListener("click", function () {

            editUnitIndex = -1;

            currentUnitAuthorized = [];

            document
                .getElementById("unitForm")
                .reset();

            document
                .getElementById("unitFormSection")
                .style.display = "block";

            document
                .getElementById("authorizedForm")
                .style.display = "none";

            document
                .getElementById("addAuthorizedBtn")
                .disabled = true;

            updateAuthorizationInfo();

            renderAuthorizedTable();

            window.scrollTo({
                top: 0,
                behavior: "smooth"
            });

        });


    // =========================================================
    // REGISTRATION TYPE CHANGE
    // =========================================================

    document
        .getElementById("registrationType")
        ?.addEventListener("change", function () {
            updateAuthorizationInfo();
            renderAuthorizedTable();
        });

    document
        .getElementById("registrationType")
        ?.addEventListener("input", function () {
            updateAuthorizationInfo();
            renderAuthorizedTable();
        });


    // =========================================================
    // AUTHORIZATION RULE
    // =========================================================

    function getAuthorizationRule() {

        const type =
            document.getElementById("registrationType")?.value;

        switch (type) {

            case "Proprietorship":

                return {
                    maxAuth: 1,
                    text: "Proprietorship allows 1 Authorized Person (Owner) and multiple Signatories."
                };

            case "Partnership":

                return {
                    maxAuth: Infinity,
                    text: "Partnership allows multiple authorized persons and signatories."
                };

            case "Private Limited":

                return {
                    maxAuth: Infinity,
                    text: "Private Limited allows multiple authorized persons and signatories."
                };

            case "Limited":

                return {
                    maxAuth: Infinity,
                    text: "Limited allows multiple authorized persons and signatories."
                };

            case "Other":

                return {
                    maxAuth: Infinity,
                    text: "Multiple authorized persons and signatories can be added."
                };

            default:

                return {
                    maxAuth: 0,
                    text: "Please select registration type first."
                };
        }

    }


    // =========================================================
    // UPDATE AUTHORIZATION INFO
    // =========================================================

    function updateAuthorizationInfo() {

        const rule = getAuthorizationRule();

        const info =
            document.getElementById("authorizationInfo");

        const addBtn =
            document.getElementById("addAuthorizedBtn");

        const addSigBtn =
            document.getElementById("addSignatoryBtn");

        if (info) info.innerHTML = rule.text;

        const isDisabled = (rule.maxAuth === 0);
        if (addBtn) addBtn.disabled = isDisabled;
        if (addSigBtn) addSigBtn.disabled = isDisabled;

    }


    // =========================================================
    // ADD AUTHORIZED PERSON
    // =========================================================

    document
        .getElementById("addAuthorizedBtn")
        ?.addEventListener("click", function () {

            const rule = getAuthorizationRule();

            if (rule.maxAuth === 0) {
                alert("Please select registration type first.");
                return;
            }

            editAuthorizedIndex = -1;

            resetAuthorizedForm();

            const roleTypeEl = document.getElementById("authorizedRoleType");
            if (roleTypeEl) roleTypeEl.value = "Authorized Person";

            document
                .getElementById("authorizedForm")
                .style.display = "block";

            document
                .getElementById("naturalPersonForm")
                .style.display = "block";

            window.scrollTo({
                top:
                    document.getElementById("authorizedForm")
                    .offsetTop - 50,
                behavior: "smooth"
            });

        });


    // =========================================================
    // ADD SIGNATORY
    // =========================================================

    document
        .getElementById("addSignatoryBtn")
        ?.addEventListener("click", function () {

            const rule = getAuthorizationRule();

            if (rule.maxAuth === 0) {
                alert("Please select registration type first.");
                return;
            }

            editAuthorizedIndex = -1;

            resetAuthorizedForm();

            const roleTypeEl = document.getElementById("authorizedRoleType");
            if (roleTypeEl) roleTypeEl.value = "Signatory";

            const roleEl = document.getElementById("authorizedRole");
            if (roleEl) roleEl.value = "Account Operator";

            document
                .getElementById("authorizedForm")
                .style.display = "block";

            document
                .getElementById("naturalPersonForm")
                .style.display = "block";

            window.scrollTo({
                top:
                    document.getElementById("authorizedForm")
                    .offsetTop - 50,
                behavior: "smooth"
            });

        });


    // =========================================================
    // SEARCH & SELECT EXISTING AUTHORIZED PERSON
    // =========================================================

    let authSearchResults = [];

    window.openAuthPersonSearchModal = function () {
        const rule = getAuthorizationRule();
        const currentAuthCount = currentUnitAuthorized.filter(a => (a.roleType || "Authorized Person") === "Authorized Person").length;
        if (rule.maxAuth !== Infinity && currentAuthCount >= rule.maxAuth) {
            alert("Maximum Authorized Person limit reached for this registration type.");
            return;
        }

        const modalEl = document.getElementById("authPersonSearchModal");
        if (modalEl) {
            const bsModal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
            bsModal.show();
            searchExistingAuthPersons();
        }
    };

    window.searchExistingAuthPersons = async function () {
        const q = (document.getElementById("authSearchInput")?.value || "").trim();
        const tbody = document.getElementById("authSearchResultsBody");
        if (!tbody) return;

        tbody.innerHTML = '<tr><td colspan="5" class="text-center py-3"><div class="spinner-border spinner-border-sm text-primary" role="status"></div> Loading...</td></tr>';

        try {
            const res = await fetch(`api-search.php?type=All&q=${encodeURIComponent(q)}`);
            const data = await res.json();
            authSearchResults = Array.isArray(data) ? data : [];

            if (authSearchResults.length === 0) {
                tbody.innerHTML = '<tr><td colspan="5" class="text-center text-muted py-3">No matching individual profiles found.</td></tr>';
                return;
            }

            let html = "";
            authSearchResults.forEach((item, index) => {
                const rec = item.data || {};
                const isInst = rec.applicant_type === 'Institutional' || rec.drawer_type === 'Institutional';
                const nameEn = isInst ? (rec.unitNameEnglish || rec.applicant_name) : (rec.fullNameEnglish || rec.applicant_name || "Unknown");
                const nameNp = isInst ? (rec.unitNameNepali || rec.applicant_name_np) : (rec.fullNameNepali || rec.applicant_name_np || "");
                const idDoc = isInst ? (rec.registrationNumber || rec.panNumber || "N/A") : (rec.citizenshipNumber || rec.citizenship_no || rec.nid || "N/A");
                const contact = rec.mobile || rec.contact || rec.contact_no || "N/A";
                const email = rec.email ? `<br><small class="text-muted">${rec.email}</small>` : "";

                html += `
                    <tr>
                        <td><span class="badge ${isInst ? 'bg-primary' : 'bg-secondary'}">${isInst ? 'Institutional' : 'Individual'}</span></td>
                        <td><strong>${nameEn}</strong>${nameNp ? `<br><small class="text-muted">${nameNp}</small>` : ''}</td>
                        <td>${idDoc}</td>
                        <td>📞 ${contact}${email}</td>
                        <td>
                            <button type="button" class="btn btn-sm btn-outline-success fw-bold" onclick="selectExistingAuthPerson(${index})">
                                Select
                            </button>
                        </td>
                    </tr>
                `;
            });
            tbody.innerHTML = html;
        } catch (e) {
            tbody.innerHTML = '<tr><td colspan="5" class="text-center text-danger py-3">Error fetching records.</td></tr>';
        }
    };

    // Attach Enter key for search input
    document.addEventListener("DOMContentLoaded", function() {
        document.getElementById("authSearchInput")?.addEventListener("keypress", function(e) {
            if (e.key === "Enter") {
                e.preventDefault();
                searchExistingAuthPersons();
            }
        });
    });

    window.selectExistingAuthPerson = function (index) {
        const item = authSearchResults[index];
        if (!item || !item.data) return;
        const rec = item.data;

        const currentRoleType = document.getElementById("authorizedRoleType")?.value || "Authorized Person";

        resetAuthorizedForm();

        const roleTypeEl = document.getElementById("authorizedRoleType");
        if (roleTypeEl) roleTypeEl.value = currentRoleType;
        if (currentRoleType === 'Signatory') {
            const roleEl = document.getElementById("authorizedRole");
            if (roleEl && (!roleEl.value || roleEl.value === '')) roleEl.value = "Account Operator";
        }
        
        const isInst = rec.applicant_type === 'Institutional' || rec.drawer_type === 'Institutional';
        document.getElementById("authorizedType").value = isInst ? "Institutional" : "Natural Person";

        if (isInst) {
            // Populate Institutional fields into the available Natural Person UI fields for storage
            document.getElementById("personNameEnglish").value = rec.unitNameEnglish || rec.applicant_name || "";
            document.getElementById("personNameNepali").value = rec.unitNameNepali || rec.applicant_name_np || "";
            document.getElementById("personCitizenship").value = rec.registrationNumber || "";
            document.getElementById("personCitizenshipDate").value = rec.registrationDate || "";
            document.getElementById("personCitizenshipAuthority").value = rec.registrationAuthority || "";
            
            // Address fields - Dispatch change to trigger cascading dropdowns
            const setVal = (id, val) => {
                const el = document.getElementById(id);
                if (el && val) {
                    el.value = val;
                    el.dispatchEvent(new Event('change'));
                }
            };
            setVal("personProvince", rec.registeredProvince);
            setVal("personDistrict", rec.registeredDistrict);
            setVal("personMunicipality", rec.registeredMunicipality);
            setVal("personWard", rec.registeredWard);
            document.getElementById("personTown").value = rec.registeredTown || "";
            document.getElementById("personStreet").value = rec.registeredStreet || "";
            
            document.getElementById("personMobile").value = rec.contact || rec.mobile || rec.contact_no || "";
            document.getElementById("personEmail").value = rec.email || "";
        } else {
            // Populate Individual fields
            if (document.getElementById("personSalutation")) document.getElementById("personSalutation").value = rec.salutation || "";
            if (document.getElementById("personMaritalStatus")) document.getElementById("personMaritalStatus").value = rec.maritalStatus || "";
            document.getElementById("personNameEnglish").value = rec.fullNameEnglish || rec.applicant_name || "";
            document.getElementById("personNameNepali").value = rec.fullNameNepali || rec.applicant_name_np || "";
            document.getElementById("personDob").value = rec.dob || "";
            document.getElementById("personDobBs").value = rec.dobBs || "";
            if (rec.gender) document.getElementById("personGender").value = rec.gender;
            document.getElementById("personNid").value = rec.nidNumber || rec.nid || "";
            document.getElementById("personCitizenship").value = rec.citizenshipNumber || rec.citizenship_no || "";
            document.getElementById("personCitizenshipDate").value = rec.citizenshipIssueDate || "";
            document.getElementById("personCitizenshipDistrict").value = rec.citizenshipIssueDistrict || "";
            document.getElementById("personCitizenshipAuthority").value = rec.citizenshipAuthority || "";

            // Address fields - Match exactly with database_setup.php and trigger cascading dropdowns
            const setVal = (id, val) => {
                const el = document.getElementById(id);
                if (el && val) {
                    el.value = val;
                    el.dispatchEvent(new Event('change'));
                }
            };
            setVal("personProvince", rec.perProvince);
            setVal("personDistrict", rec.perDistrict);
            setVal("personMunicipality", rec.perMunicipality);
            setVal("personWard", rec.perWard);
            document.getElementById("personTown").value = rec.perTown || "";
            document.getElementById("personStreet").value = rec.perStreet || "";
            
            document.getElementById("personMobile").value = rec.mobile || rec.contact || rec.contact_no || "";
            document.getElementById("personEmail").value = rec.email || "";

            // Family fields - Match exactly with database_setup.php
            if (rec.grandfather) document.getElementById("personGrandfather").value = rec.grandfather;
            if (rec.grandmother) document.getElementById("personGrandmother").value = rec.grandmother;
            if (rec.father) document.getElementById("personFather").value = rec.father;
            if (rec.mother) document.getElementById("personMother").value = rec.mother;
            if (rec.spouse) document.getElementById("personSpouse").value = rec.spouse;
            if (rec.daughter) document.getElementById("personDaughter").value = rec.daughter;
            if (rec.son) document.getElementById("personSon").value = rec.son;
            if (rec.fatherInLaw) document.getElementById("personFatherInLaw").value = rec.fatherInLaw;
            if (rec.motherInLaw) document.getElementById("personMotherInLaw").value = rec.motherInLaw;
        }

        // Show authorized form
        document.getElementById("authorizedForm").style.display = "block";
        document.getElementById("naturalPersonForm").style.display = "block";

        // Close modal
        const modalEl = document.getElementById("authPersonSearchModal");
        if (modalEl) {
            bootstrap.Modal.getInstance(modalEl)?.hide();
        }

        // Focus on role
        document.getElementById("authorizedRole").focus();

        window.scrollTo({
            top: document.getElementById("authorizedForm").offsetTop - 50,
            behavior: "smooth"
        });

        if (typeof Swal !== "undefined") {
            Swal.fire({
                icon: "success",
                title: "Profile Loaded!",
                text: "Individual loaded. Please specify Role/Designation and click Save Authorized.",
                timer: 2000,
                showConfirmButton: false
            });
        }
    };


    // =========================================================
    // SAVE AUTHORIZED
    // =========================================================

    document
        .getElementById("saveAuthorizedBtn")
        ?.addEventListener("click", function () {

            const roleType = document.getElementById("authorizedRoleType")?.value || "Authorized Person";

            const role =
                document.getElementById("authorizedRole")?.value.trim();

            const rule = getAuthorizationRule();
            const currentAuthCount = currentUnitAuthorized.filter(a => (a.roleType || "Authorized Person") === "Authorized Person").length;
            let isEditingAuth = false;
            if (editAuthorizedIndex !== -1 && (currentUnitAuthorized[editAuthorizedIndex].roleType || "Authorized Person") === "Authorized Person") {
                isEditingAuth = true;
            }
            const effectiveAuthCount = isEditingAuth ? (currentAuthCount - 1) : currentAuthCount;

            if (roleType === "Authorized Person" && rule.maxAuth !== Infinity && effectiveAuthCount >= rule.maxAuth) {
                alert("Maximum Authorized Person (Owner) limit reached for this registration type.");
                return;
            }

            if (!role) {
                alert("Please enter Role / Designation.");
                document.getElementById("authorizedRole")?.focus();
                return;
            }

            const name =
                document.getElementById("personNameEnglish")?.value.trim();

            if (!name) {
                alert("Please enter Full Name (English).");
                document.getElementById("personNameEnglish")?.focus();
                return;
            }

            const authType = document.getElementById("authorizedType")?.value || "Natural Person";

            if (authType !== 'Institutional') {
                if (!document.getElementById("personDob")?.value) { alert("Please provide Date of Birth (AD)"); return; }
                if (!document.getElementById("personDobBs")?.value) { alert("Please provide Date of Birth (BS)"); return; }
                if (!document.getElementById("personGender")?.value) { alert("Please select Gender"); return; }
                if (!document.getElementById("personCitizenship")?.value) { alert("Please provide Citizenship Number"); return; }
                if (!document.getElementById("personMobile")?.value) { alert("Please provide Mobile Number"); return; }
            }

            let isReissue = document.querySelector('input[name="personReissue"]:checked') ? document.querySelector('input[name="personReissue"]:checked').value : 'No';

            let data = {
                id: editAuthorizedIndex !== -1 ? currentUnitAuthorized[editAuthorizedIndex].id : "A" + Date.now(),
                type: authType,
                roleType: roleType,
                source_profile_id: window.selectedSourceProfileId || null,
                role: role,
                salutation: document.getElementById("personSalutation")?.value || "",
                maritalStatus: document.getElementById("personMaritalStatus")?.value || "",
                nameEnglish: name,
                nameNepali: preetiToUnicode(document.getElementById("personNameNepali")?.value || ""),
                dob: document.getElementById("personDob")?.value || "",
                dobBs: document.getElementById("personDobBs")?.value || "",
                gender: document.getElementById("personGender")?.value || "",
                nid: document.getElementById("personNid")?.value || "",
                citizenship: document.getElementById("personCitizenship")?.value || "",
                citizenshipDate: document.getElementById("personCitizenshipDate")?.value || "",
                citizenshipDistrict: document.getElementById("personCitizenshipDistrict")?.value || "",
                citizenshipAuthority: document.getElementById("personCitizenshipAuthority")?.value || "",
                citizenshipIssuePlace: document.getElementById("personCitizenshipIssuePlace")?.value || "",
                mobile: document.getElementById("personMobile")?.value || "",
                email: document.getElementById("personEmail")?.value || "",
                reissue: isReissue,
                reissueDate: document.getElementById("personReissueDate")?.value || "",
                pratilipiType: document.getElementById("personPratilipiType")?.value || "",
                reissueDistrict: document.getElementById("personReissueDistrict")?.value || "",
                reissueAuthority: document.getElementById("personReissueAuthority")?.value || "",
                reissuePlace: document.getElementById("personReissuePlace")?.value || "",
                address: {
                    province: document.getElementById("personProvince")?.value || "",
                    district: document.getElementById("personDistrict")?.value || "",
                    municipality: document.getElementById("personMunicipality")?.value || "",
                    ward: document.getElementById("personWard")?.value || "",
                    town: document.getElementById("personTown")?.value || "",
                    street: document.getElementById("personStreet")?.value || ""
                },
                tempAddress: {
                    province: document.getElementById("personTempProvince")?.value || "",
                    district: document.getElementById("personTempDistrict")?.value || "",
                    municipality: document.getElementById("personTempMunicipality")?.value || "",
                    ward: document.getElementById("personTempWard")?.value || "",
                    town: document.getElementById("personTempTown")?.value || "",
                    street: document.getElementById("personTempStreet")?.value || ""
                }
            };
            
            if (authType === "Institutional") {
                data.registrationNumber = document.getElementById("personCitizenship")?.value || "";
                data.registrationDate = document.getElementById("personCitizenshipDate")?.value || "";
                data.registrationAuthority = document.getElementById("personCitizenshipAuthority")?.value || "";
            } else {
                data.family = {
                    grandfather: document.getElementById("personGrandfather")?.value || "",
                    grandmother: document.getElementById("personGrandmother")?.value || "",
                    father: document.getElementById("personFather")?.value || "",
                    mother: document.getElementById("personMother")?.value || "",
                    spouse: document.getElementById("personSpouse")?.value || "",
                    daughter: document.getElementById("personDaughter")?.value || "",
                    son: document.getElementById("personSon")?.value || "",
                    fatherInLaw: document.getElementById("personFatherInLaw")?.value || "",
                    motherInLaw: document.getElementById("personMotherInLaw")?.value || ""
                };
            }

            // =============================================
            // ADD / EDIT
            // =============================================

            if (editAuthorizedIndex !== -1) {
                currentUnitAuthorized[editAuthorizedIndex] = data;
            } else {
                currentUnitAuthorized.push(data);
            }

            editAuthorizedIndex = -1;

            renderAuthorizedTable();
            resetAuthorizedForm();

            document
                .getElementById("authorizedForm")
                .style.display = "none";

            updateAuthorizationInfo();

        });    // =========================================================
    // PREETI TO UNICODE (JS ENGINE)
    // =========================================================

    function preetiToUnicode(text) {
        try {
            if (!text || typeof text !== 'string') return '';
            text = text.trim();
            if (!text) return '';

            // If text already contains Devanagari characters and no English letters, return as is
            if (/[\u0900-\u097F]/.test(text) && !/[a-zA-Z]/.test(text)) {
                return text;
            }

            const charMap = {
                "÷": "/", "v": "ख", "r": "च", "\"": "ू", "~": "ञ्", "z": "श", "ç": "ॐ", "f": "ा", "b": "द", "n": "ल", "j": "व", "×": "×", "V": "ख्", "R": "च्", "ß": "द्म", "^": "६", "Û": "!", "Z": "श्", "F": "ँ", "B": "द्य", "N": "ल्", "Ë": "ङ्ग", "J": "व्", "6": "ट", "2": "द्द", "¿": "रू", ">": "श्र", ":": "स्", "§": "ट्ट", "&": "७", "£": "घ्", "•": "ड्ड", ".": "।", "«": "्र", "*": "८", "„": "ध्र", "w": "ध", "s": "क", "g": "न", "æ": "“", "c": "अ", "o": "य", "k": "प", "W": "ध्", "Ö": "=", "S": "क्", "Ò": "¨", "_": ")", "[": "ृ", "Ú": "’", "G": "न्", "ˆ": "फ्", "C": "ऋ", "O": "इ", "Î": "ङ्ख", "K": "प्", "7": "ठ", "¶": "ठ्ठ", "3": "घ", "9": "ढ", "?": "रु", ";": "स", "'": "ु", "#": "३", "¢": "द्घ", "/": "र", "+": "ं", "ª": "ङ", "t": "त", "p": "उ", "|": "्र", "x": "ह", "å": "द्व", "d": "म", "`": "ञ", "l": "ि", "h": "ज", "T": "त्", "P": "ए", "Ý": "ट्ठ", "\\": "्", "Ù": ";", "X": "ह्", "Å": "हृ", "D": "म्", "@": "२", "Í": "ङ्क", "L": "ी", "H": "ज्", "4": "द्ध", "±": "+", "0": "ण्", "<": "?", "8": "ड", "¥": "र्‍", "$": "४", "¡": "ज्ञ्", ",": ",", "©": "र", "(": "९", "‘": "ॅ", "u": "ग", "q": "त्र", "}": "ै", "y": "थ", "e": "भ", "a": "ब", "i": "ष्", "‰": "झ्", "U": "ग्", "Q": "त्त", "]": "े", "˜": "ऽ", "Y": "थ्", "Ø": "्य", "E": "भ्", "A": "ब्", "M": "ः", "Ì": "न्न", "I": "क्ष्", "5": "छ", "´": "झ", "1": "ज्ञ", "°": "ङ्ढ", "=": ".", "Æ": "”", "‹": "ङ्घ", "%": "५", "¤": "झ्", "!": "१", "-": "(", "›": "द्र", ")": "०", "…": "‘", "Ü": "%"
            };

            let unicode = "";
            for (let i = 0; i < text.length; i++) {
                const ch = text[i];
                unicode += charMap[ch] !== undefined ? charMap[ch] : ch;
            }

            unicode = unicode.replace(/्ा/g, '');
            unicode = unicode.replace(/(त्र|त्त)([^उभप]+?)m/g, '$1m$2');
            unicode = unicode.replace(/त्रm/g, 'क्र');
            unicode = unicode.replace(/त्तm/g, 'क्त');
            unicode = unicode.replace(/([^उभप]+?)m/g, 'm$1');
            unicode = unicode.replace(/उm/g, 'ऊ');
            unicode = unicode.replace(/भm/g, 'झ');
            unicode = unicode.replace(/पm/g, 'फ');
            unicode = unicode.replace(/इ{/g, 'ई');
            unicode = unicode.replace(/ि((.्)*[^्])/g, '$1ि');
            unicode = unicode.replace(/(.[ािीुूृेैोौंःँ]*?){/g, '{$1');
            unicode = unicode.replace(/((.्)*){/g, '{$1');
            unicode = unicode.replace(/{/g, 'र्');
            unicode = unicode.replace(/([ाीुूृेैोौंःँ]+?)(्(.्)*[^्])/g, '$2$1');
            unicode = unicode.replace(/्([ािीुूृेैोौंःँ]+?)((.्)*[^्])/g, '्$2$1');
            unicode = unicode.replace(/([ंँ])([ािीुूृेैोौः]*)/g, '$2$1');
            unicode = unicode.replace(/ँँ/g, 'ँ');

            return unicode.trim();
        } catch (err) {
            console.error("preetiToUnicode error:", err);
            return text || '';
        }
    }

    // =========================================================
    // RENDER AUTHORIZED TABLE
    // =========================================================

    function renderAuthorizedTable() {

        const tbody =
            document.getElementById(
                "authorizedTableBody"
            );

        if (!tbody) return;

        tbody.innerHTML = "";


        if (currentUnitAuthorized.length === 0) {

            tbody.innerHTML = `

                <tr>

                    <td
                        colspan="6"
                        class="text-center text-muted py-3"
                    >
                        No authorized person/entity added.
                    </td>

                </tr>

            `;

            return;

        }


        currentUnitAuthorized.forEach(
            function (item, index) {

                let number = "-";

                if (item.type === "Natural Person") {

                    number =
                        item.citizenship || "-";

                }

                else {

                    number =
                        item.registrationNumber || "-";

                }

                const unicodeNameNp = preetiToUnicode(item.nameNepali || "");
                const roleTypeLabel = item.roleType || "Authorized Person";
                const roleBadgeClass = roleTypeLabel === 'Signatory' ? 'bg-info text-dark' : 'bg-primary';

                tbody.innerHTML += `

                    <tr>

                        <td>
                            ${index + 1}
                        </td>

                        <td>
                            <strong>
                                ${item.salutation ? item.salutation + ' ' : ''}${item.nameEnglish || "-"}
                            </strong>

                            ${
                                unicodeNameNp
                                ? `<br>
                                   <small class="text-muted fw-bold" style="font-size: 0.95rem;">
                                       ${unicodeNameNp}
                                   </small>`
                                : ""
                            }

                        </td>

                        <td>

                            <span
                                class="badge ${
                                    item.type === "Natural Person"
                                    ? "bg-secondary"
                                    : "bg-dark"
                                } badge-type"
                            >
                                ${item.type || "Natural Person"}
                            </span>
                            <br>
                            <span class="badge ${roleBadgeClass} mt-1">
                                ${roleTypeLabel}
                            </span>

                        </td>

                        <td>
                            ${number}
                        </td>

                        <td>
                            ${item.role || "-"}
                        </td>

                        <td>

                            <button
                                type="button"
                                class="btn btn-info text-white action-btn btn-sm"
                                onclick="viewAuthorized(${index})"
                            >
                                View
                            </button>

                            <button
                                type="button"
                                class="btn btn-warning action-btn edit-auth-btn btn-sm"
                                onclick="editAuthorized(${index})"
                                style="${window.location.search.includes('action=view') ? 'display:none;' : ''}"
                            >
                                Edit
                            </button>

                            <button
                                type="button"
                                class="btn btn-danger action-btn btn-sm"
                                onclick="deleteAuthorized(${index})"
                                style="${window.location.search.includes('action=view') ? 'display:none;' : ''}"
                            >
                                Delete
                            </button>

                        </td>

                    </tr>

                `;

            }
        );

    }


    function resetAuthorizedFormState() {
        const formContainer = document.getElementById("authorizedForm");
        if (!formContainer) return;

        const inputs = formContainer.querySelectorAll("input, select, textarea, button");
        inputs.forEach(el => el.disabled = false);

        const banner = document.getElementById("viewAuthBanner");
        if (banner) banner.remove();

        const saveBtn = document.getElementById("saveAuthorizedBtn");
        const cancelBtn = document.getElementById("cancelAuthorizedBtn");
        const closeBtn = document.getElementById("closeViewAuthorizedBtn");

        if (saveBtn) {
            saveBtn.style.display = "inline-block";
            saveBtn.innerText = "Save Authorized";
        }
        if (cancelBtn) cancelBtn.style.display = "inline-block";
        if (closeBtn) closeBtn.style.display = "none";
    }

    // =========================================================
    // EDIT AUTHORIZED
    // =========================================================

    function editAuthorized(index) {
        resetAuthorizedFormState();

        const item = currentUnitAuthorized[index];
        if (!item) return;

        editAuthorizedIndex = index;

        document.getElementById("authorizedForm").style.display = "block";
        document.getElementById("naturalPersonForm").style.display = "block";

        document.getElementById("authorizedRoleType").value = item.roleType || "Authorized Person";
        window.selectedSourceProfileId = item.source_profile_id || null;
        document.getElementById("authorizedRole").value = item.role || "";
        if (document.getElementById("personSalutation")) document.getElementById("personSalutation").value = item.salutation || "";
        if (document.getElementById("personMaritalStatus")) document.getElementById("personMaritalStatus").value = item.maritalStatus || "";
        document.getElementById("personNameEnglish").value = item.nameEnglish || "";
        document.getElementById("personNameNepali").value = item.nameNepali || "";
        document.getElementById("personDob").value = item.dob || "";
        document.getElementById("personDobBs").value = item.dobBs || "";
        document.getElementById("personGender").value = item.gender || "";
        document.getElementById("personNid").value = item.nid || "";
        document.getElementById("personCitizenship").value = item.citizenship || "";
        document.getElementById("personCitizenshipDate").value = item.citizenshipDate || "";
        document.getElementById("personCitizenshipDistrict").value = item.citizenshipDistrict || "";
        
        const saveBtn = document.getElementById("saveAuthorizedBtn");
        if (saveBtn) saveBtn.innerText = "Update Auth / Signatory";

        let citAuthEl = document.getElementById("personCitizenshipAuthority");
        if(citAuthEl) {
            citAuthEl.value = item.citizenshipAuthority || "";
            window.toggleIssuePlace && window.toggleIssuePlace(citAuthEl, 'personCitizenshipIssuePlaceContainer');
        }
        document.getElementById("personCitizenshipIssuePlace").value = item.citizenshipIssuePlace || "";

        if (item.address) {
            const setVal = (id, val) => {
                const el = document.getElementById(id);
                if (el && val) {
                    el.value = val;
                    el.dispatchEvent(new Event('change'));
                }
            };
            setVal("personProvince", item.address.province);
            setVal("personDistrict", item.address.district);
            setVal("personMunicipality", item.address.municipality);
            setVal("personWard", item.address.ward);
            document.getElementById("personTown").value = item.address.town || "";
            document.getElementById("personStreet").value = item.address.street || "";
        }

        if (item.tempAddress) {
            const setVal = (id, val) => {
                const el = document.getElementById(id);
                if (el && val) {
                    el.value = val;
                    el.dispatchEvent(new Event('change'));
                }
            };
            setVal("personTempProvince", item.tempAddress.province);
            setVal("personTempDistrict", item.tempAddress.district);
            setVal("personTempMunicipality", item.tempAddress.municipality);
            setVal("personTempWard", item.tempAddress.ward);
            document.getElementById("personTempTown").value = item.tempAddress.town || "";
            document.getElementById("personTempStreet").value = item.tempAddress.street || "";
        }

        document.getElementById("personMobile").value = item.mobile || "";
        document.getElementById("personEmail").value = item.email || "";

        if (item.reissue === 'Yes') {
            document.getElementById("personReissueYes").checked = true;
            document.getElementById("personReissueDetails").style.display = 'block';
            document.getElementById("personReissueDate").value = item.reissueDate || "";
            document.getElementById("personPratilipiType").value = item.pratilipiType || "";
            document.getElementById("personReissueDistrict").value = item.reissueDistrict || "";

            let reAuthEl = document.getElementById("personReissueAuthority");
            if(reAuthEl) {
                reAuthEl.value = item.reissueAuthority || "";
                window.toggleIssuePlace && window.toggleIssuePlace(reAuthEl, 'personReissuePlaceContainer');
            }
            document.getElementById("personReissuePlace").value = item.reissuePlace || "";
        } else {
            document.getElementById("personReissueNo").checked = true;
            document.getElementById("personReissueDetails").style.display = 'none';
        }

        if (item.family) {
            document.getElementById("personGrandfather").value = item.family.grandfather || "";
            document.getElementById("personGrandmother").value = item.family.grandmother || "";
            document.getElementById("personFather").value = item.family.father || "";
            document.getElementById("personMother").value = item.family.mother || "";
            document.getElementById("personSpouse").value = item.family.spouse || "";
            document.getElementById("personDaughter").value = item.family.daughter || "";
            document.getElementById("personSon").value = item.family.son || "";
            document.getElementById("personFatherInLaw").value = item.family.fatherInLaw || "";
            document.getElementById("personMotherInLaw").value = item.family.motherInLaw || "";
        }

        document.getElementById("authorizedForm").scrollIntoView({
            behavior: "smooth",
            block: "start"
        });

    }


    // =========================================================
    // DELETE AUTHORIZED
    // =========================================================

    function deleteAuthorized(index) {

        if (confirm("Are you sure you want to delete this authorized person?")) {
            currentUnitAuthorized.splice(index, 1);
            renderAuthorizedTable();
            updateAuthorizationInfo();
        }

    }


    // =========================================================
    // VIEW AUTHORIZED
    // =========================================================

    window.viewAuthorized = function(index) {
        const item = currentUnitAuthorized[index];
        if (!item) return;

        editAuthorized(index);

        const formContainer = document.getElementById("authorizedForm");
        if (!formContainer) return;

        const inputs = formContainer.querySelectorAll("input, select, textarea, button:not(#closeViewAuthorizedBtn)");
        inputs.forEach(el => el.disabled = true);

        const saveBtn = document.getElementById("saveAuthorizedBtn");
        const cancelBtn = document.getElementById("cancelAuthorizedBtn");
        const closeBtn = document.getElementById("closeViewAuthorizedBtn");

        if (saveBtn) saveBtn.style.display = "none";
        if (cancelBtn) cancelBtn.style.display = "none";
        if (closeBtn) {
            closeBtn.style.display = "inline-block";
            closeBtn.disabled = false;
        }

        let banner = document.getElementById("viewAuthBanner");
        if (!banner) {
            banner = document.createElement("div");
            banner.id = "viewAuthBanner";
            banner.className = "alert alert-warning py-2 mb-3 fw-bold border-warning d-flex align-items-center justify-content-between";
            banner.innerHTML = `<span>👁️ Viewing ${item.roleType || 'Authorized Person'} Details (Read-Only Mode)</span> <button type="button" class="btn btn-sm btn-outline-dark fw-bold" onclick="closeViewAuthorized()">✖ Close View</button>`;
            formContainer.insertBefore(banner, formContainer.firstChild);
        }

        formContainer.scrollIntoView({ behavior: "smooth", block: "start" });
    };

    window.closeViewAuthorized = function() {
        resetAuthorizedFormState();
        resetAuthorizedForm();
        const formContainer = document.getElementById("authorizedForm");
        if (formContainer) formContainer.style.display = "none";
    };


    // =========================================================
    // RESET AUTHORIZED
    // =========================================================

    function resetAuthorizedForm() {

        const authTypeEl = document.getElementById("authorizedType");
        if (authTypeEl) authTypeEl.value = "Natural Person";
        
        window.selectedSourceProfileId = null;
        const roleTypeEl = document.getElementById("authorizedRoleType");
        if (roleTypeEl) roleTypeEl.value = "Authorized Person";

        const authRoleEl = document.getElementById("authorizedRole");
        if (authRoleEl) authRoleEl.value = "";

        document.querySelectorAll("#authorizedForm input").forEach(function (input) {
            if (input.id !== "authorizedType") input.value = "";
        });

        document.querySelectorAll("#authorizedForm select").forEach(function (select) {
            select.selectedIndex = 0;
        });

        const npForm = document.getElementById("naturalPersonForm");
        if (npForm) npForm.style.display = "block";

    }


    // =========================================================
    // CANCEL AUTHORIZED
    // =========================================================

    document
        .getElementById("cancelAuthorizedBtn")
        ?.addEventListener("click", function () {

            resetAuthorizedFormState();
            resetAuthorizedForm();

            editAuthorizedIndex = -1;

            document
                .getElementById("authorizedForm")
                .style.display = "none";

        });


    // =========================================================
    // SAME REGISTERED ADDRESS
    // =========================================================

    document
        .getElementById("sameRegisteredAddress")
        ?.addEventListener("change", function () {

            if (this.checked) {
                
                const fields = ["Province", "District", "Municipality", "Ward", "Town", "Street"];
                
                fields.forEach(field => {
                    const regEl = document.getElementById(`registered${field}`);
                    const mailEl = document.getElementById(`mailing${field}`);
                    
                    if (regEl && mailEl) {
                        if (regEl.tagName === "SELECT") {
                            mailEl.innerHTML = regEl.innerHTML;
                            mailEl.disabled = regEl.disabled;
                        }
                        
                        mailEl.value = regEl.value;
                    }
                });

    function updatePersonMaritalStatusValidation() {
        const maritalStatus = document.getElementById('personMaritalStatus')?.value;
        const gender = document.getElementById('personGender')?.value;
        const spouseInput = document.getElementById('personSpouse');
        const spouseReqSpan = document.getElementById('personSpouseReqSpan');
        const filInput = document.getElementById('personFatherInLaw');
        const filReqSpan = document.getElementById('personFatherInLawReqSpan');

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

    document.addEventListener("DOMContentLoaded", async function() {
        const reuseData = localStorage.getItem('reuseApplicantData');
        if (reuseData) {
            try {
                window.drawerData = Object.assign(window.drawerData || {}, JSON.parse(reuseData));
            } catch (e) {
                console.error("Error parsing reuseApplicantData:", e);
            }
            localStorage.removeItem('reuseApplicantData');
            
            // if we are in profile.php, toggle the edit form open automatically
            if (typeof toggleEditForm === 'function') {
                const form = document.getElementById('editFormContainer');
                if (form && form.style.display === 'none') {
                    toggleEditForm();
                }
            }
        }
        
        updateAuthorizationInfo();
        renderAuthorizedTable();
        await loadLocationsData();
        
        const pMsEl = document.getElementById('personMaritalStatus');
        const pGenEl = document.getElementById('personGender');
        if (pMsEl) pMsEl.addEventListener('change', updatePersonMaritalStatusValidation);
        if (pGenEl) pGenEl.addEventListener('change', updatePersonMaritalStatusValidation);
        updatePersonMaritalStatusValidation();
        
        
        if (document.getElementById("personDob") && document.getElementById("personDobBs")) {
            document.getElementById("personDob")?.addEventListener("change", function () {
                const adDate = this.value.trim();
                if (/^\d{4}-\d{2}-\d{2}$/.test(adDate)) {
                    fetch('api/convert-date.php?ad=' + adDate)
                        .then(res => res.json())
                        .then(data => {
                            if (data.bs) {
                                document.getElementById("personDobBs").value = data.bs;
                            }
                        })
                        .catch(e => console.error("AD to BS Conversion Error:", e));
                }
            });
            
            document.getElementById("personDobBs")?.addEventListener("change", function () {
                const bsDate = this.value.trim().replace(/[\/.]/g, '-');
                if (/^\d{4}-\d{1,2}-\d{1,2}$/.test(bsDate)) {
                    fetch('api/convert-date.php?bs=' + bsDate)
                        .then(res => res.json())
                        .then(data => {
                            if (data.ad && !data.ad.includes('undefined')) {
                                document.getElementById("personDob").value = data.ad;
                            }
                        })
                        .catch(e => console.error("BS to AD Conversion Error:", e));
                }
            });
        }
        
        if (document.getElementById("registrationDate") && document.getElementById("registrationDateBs")) {
            document.getElementById("registrationDate")?.addEventListener("change", function () {
                const adDate = this.value.trim();
                if (/^\d{4}-\d{2}-\d{2}$/.test(adDate)) {
                    fetch('api/convert-date.php?ad=' + adDate)
                        .then(res => res.json())
                        .then(data => {
                            if (data.bs) {
                                document.getElementById("registrationDateBs").value = data.bs;
                            }
                        })
                        .catch(e => console.error("AD to BS Conversion Error:", e));
                }
            });
            
            document.getElementById("registrationDateBs")?.addEventListener("change", function () {
                const bsDate = this.value.trim().replace(/[\/.]/g, '-');
                if (/^\d{4}-\d{1,2}-\d{1,2}$/.test(bsDate)) {
                    fetch('api/convert-date.php?bs=' + bsDate)
                        .then(res => res.json())
                        .then(data => {
                            if (data.ad && !data.ad.includes('undefined')) {
                                document.getElementById("registrationDate").value = data.ad;
                            }
                        })
                        .catch(e => console.error("BS to AD Conversion Error:", e));
                }
            });
        }
        
        // =========================================================
        // GOV HIERARCHY FLEXIBLE & LINK-FREE LOGIC
        // =========================================================
        async function fetchGovData(action, params = {}) {
            let url = `api-gov-hierarchy.php?action=${action}`;
            for (let k in params) {
                if (params[k]) url += `&${k}=${params[k]}`;
            }
            try {
                const res = await fetch(url);
                return await res.json();
            } catch (e) {
                console.error("Error fetching gov data:", e);
                return [];
            }
        }

        function populateSelect(id, data, valField, textField, defaultOption = "Select...") {
            const el = document.getElementById(id);
            if (!el) return;
            const currentVal = el.value;
            el.innerHTML = `<option value="">${defaultOption}</option>`;
            if (Array.isArray(data)) {
                data.forEach(item => {
                    const opt = document.createElement('option');
                    opt.value = item[valField];
                    opt.textContent = `${item[textField]} ${item.name_np ? '('+item.name_np+')' : ''}`;
                    opt.dataset.nameEn = item[textField] || '';
                    opt.dataset.nameNp = item.name_np || '';
                    el.appendChild(opt);
                });
            }
            el.disabled = false;
            if (currentVal) {
                el.value = currentVal;
            }
        }

        async function initGovHierarchy() {
            const [authorities, provinces, districts, ministries, departments, offices] = await Promise.all([
                fetchGovData('get_authorities'),
                fetchGovData('get_provinces'),
                fetchGovData('get_districts'),
                fetchGovData('get_ministries', { all: 1 }),
                fetchGovData('get_departments', { all: 1 }),
                fetchGovData('get_offices', { all: 1 })
            ]);

            populateSelect('regGovAuthority', authorities, 'id', 'name_en', 'Select Authority');
            populateSelect('regGovProvince', provinces, 'id', 'name_en', 'Select Province');
            populateSelect('regGovDistrict', districts, 'id', 'name_en', 'Select District (77 Districts)');
            populateSelect('regGovMinistry', ministries, 'id', 'name_en', 'Select Ministry (Optional)');
            populateSelect('regGovDepartment', departments, 'id', 'name_en', 'Select Department (Optional)');
            
            // Separate Business/Firm Registering Offices vs Inland Revenue (PAN) Offices
            const isIrd = (o) => o.department_id == 2 || (o.name_en && (o.name_en.toLowerCase().includes('revenue') || o.name_en.toLowerCase().includes('taxpayer')));
            const businessRegOffices = Array.isArray(offices) ? offices.filter(o => !isIrd(o)) : [];
            const irdOffices = Array.isArray(offices) ? offices.filter(o => isIrd(o)) : [];

            populateSelect('regGovOffice', businessRegOffices, 'id', 'name_en', 'Select Registering Office');
            populateSelect('panAuthority', irdOffices, 'name_en', 'name_en', 'Select PAN Issue Authority (IRD Office)...');
            
            // Check if there is existing hierarchy data to restore
            const drawer = window.drawerData || {};
            const existingAuthId = document.getElementById('reg_authority_id')?.value || drawer.reg_authority_id;
            const existingMinistryId = document.getElementById('reg_ministry_id')?.value || drawer.reg_ministry_id;
            const existingDeptId = document.getElementById('reg_department_id')?.value || drawer.reg_department_id;
            const existingOfficeId = document.getElementById('reg_office_id')?.value || drawer.reg_office_id || drawer.registration_org_id;
            const existingProvId = drawer.reg_province_id || drawer.registration_province_id;
            const existingDistId = drawer.reg_district_id || drawer.registration_district_id;
            const existingOfficeAddr = drawer.registrationOfficeAddress || drawer.registration_office_address || '';

            if (existingOfficeAddr && document.getElementById('registrationOfficeAddress')) {
                document.getElementById('registrationOfficeAddress').value = existingOfficeAddr;
            }

            const existingPanAuth = drawer.panAuthority || drawer.pan_authority;
            if (existingPanAuth && document.getElementById('panAuthority')) {
                document.getElementById('panAuthority').value = existingPanAuth;
            }

            if (existingAuthId || existingOfficeId || existingMinistryId || existingDeptId || existingProvId || existingDistId) {
                restoreGovHierarchy(existingAuthId, existingMinistryId, existingDeptId, existingOfficeId, existingProvId, existingDistId, existingOfficeAddr);
            }
        }

        function onAuthorityChange() {
            const authSel = document.getElementById('regGovAuthority');
            const authId = authSel?.value;
            const provCol = document.getElementById('colRegProvince');

            document.getElementById('reg_authority_id').value = authId || '';

            // Check if Provincial (ID 2) or Local Government (ID 3)
            const selectedText = authSel.options[authSel.selectedIndex]?.textContent || '';
            if (authId == 2 || authId == 3 || selectedText.toLowerCase().includes('provincial') || selectedText.toLowerCase().includes('local')) {
                if (provCol) provCol.style.display = 'block';
            } else {
                if (provCol) provCol.style.display = 'none';
            }

            updateRegistrationAuthoritySummary();
        }

        function onDistrictChange() {
            const distSel = document.getElementById('regGovDistrict');
            if (document.getElementById('reg_district_id')) {
                document.getElementById('reg_district_id').value = distSel?.value || '';
            }
            updateRegistrationAuthoritySummary();
        }

        function onMinistryChange() {
            const minSel = document.getElementById('regGovMinistry');
            document.getElementById('reg_ministry_id').value = minSel?.value || '';
            updateRegistrationAuthoritySummary();
        }

        function onDepartmentChange() {
            const deptSel = document.getElementById('regGovDepartment');
            document.getElementById('reg_department_id').value = deptSel?.value || '';
            updateRegistrationAuthoritySummary();
        }

        function onOfficeChange() {
            const offSel = document.getElementById('regGovOffice');
            const offId = offSel?.value;
            document.getElementById('reg_office_id').value = offId || '';

            if (offId) {
                document.getElementById('registration_org_id').value = offId;
                document.getElementById('registration_org_type').value = 'Office';
            } else {
                const deptId = document.getElementById('reg_department_id')?.value;
                const minId = document.getElementById('reg_ministry_id')?.value;
                if (deptId) {
                    document.getElementById('registration_org_id').value = deptId;
                    document.getElementById('registration_org_type').value = 'Department';
                } else if (minId) {
                    document.getElementById('registration_org_id').value = minId;
                    document.getElementById('registration_org_type').value = 'Ministry';
                }
            }
            updateRegistrationAuthoritySummary();
        }

        function updateRegistrationAuthoritySummary() {
            const authSel = document.getElementById('regGovAuthority');
            const provSel = document.getElementById('regGovProvince');
            const distSel = document.getElementById('regGovDistrict');
            const minSel = document.getElementById('regGovMinistry');
            const deptSel = document.getElementById('regGovDepartment');
            const offSel = document.getElementById('regGovOffice');
            const addrInput = document.getElementById('registrationOfficeAddress');

            const partsEn = [];
            const partsNp = [];

            // Authority
            if (authSel && authSel.selectedIndex > 0) {
                const opt = authSel.options[authSel.selectedIndex];
                const en = opt.dataset?.nameEn || opt.textContent.split(' (')[0].trim();
                const np = opt.dataset?.nameNp || '';
                if (en) partsEn.push(en);
                if (np) partsNp.push(np);
            }

            // Province (if visible and selected)
            const provCol = document.getElementById('colRegProvince');
            if (provCol && provCol.style.display !== 'none' && provSel && provSel.selectedIndex > 0) {
                const opt = provSel.options[provSel.selectedIndex];
                const en = opt.dataset?.nameEn || opt.textContent.split(' (')[0].trim();
                const np = opt.dataset?.nameNp || '';
                if (en) partsEn.push(en);
                if (np) partsNp.push(np);
            }

            // Ministry
            if (minSel && minSel.selectedIndex > 0) {
                const opt = minSel.options[minSel.selectedIndex];
                const en = opt.dataset?.nameEn || opt.textContent.split(' (')[0].trim();
                const np = opt.dataset?.nameNp || '';
                if (en) partsEn.push(en);
                if (np) partsNp.push(np);
            }

            // Department
            if (deptSel && deptSel.selectedIndex > 0) {
                const opt = deptSel.options[deptSel.selectedIndex];
                const en = opt.dataset?.nameEn || opt.textContent.split(' (')[0].trim();
                const np = opt.dataset?.nameNp || '';
                if (en) partsEn.push(en);
                if (np) partsNp.push(np);
            }

            // Office
            if (offSel && offSel.selectedIndex > 0) {
                const opt = offSel.options[offSel.selectedIndex];
                const en = opt.dataset?.nameEn || opt.textContent.split(' (')[0].trim();
                const np = opt.dataset?.nameNp || '';
                if (en) partsEn.push(en);
                if (np) partsNp.push(np);
            }

            // District
            if (distSel && distSel.selectedIndex > 0) {
                const opt = distSel.options[distSel.selectedIndex];
                const en = opt.dataset?.nameEn || opt.textContent.split(' (')[0].trim();
                const np = opt.dataset?.nameNp || '';
                if (en) partsEn.push(en);
                if (np) partsNp.push(np);
            }

            // Address
            const addrVal = addrInput ? addrInput.value.trim() : '';
            if (addrVal) {
                partsEn.push(addrVal);
                partsNp.push(addrVal);
            }

            const fullEn = partsEn.join(', ');
            const fullNp = partsNp.join(', ');

            if (document.getElementById('registrationAuthority')) {
                document.getElementById('registrationAuthority').value = fullEn;
            }
            if (document.getElementById('registrationAuthorityNp')) {
                document.getElementById('registrationAuthorityNp').value = fullNp;
            }
        }

        function restoreGovHierarchy(authId, minId, deptId, offId, provId, distId, officeAddr) {
            const authSel = document.getElementById('regGovAuthority');
            const provSel = document.getElementById('regGovProvince');
            const distSel = document.getElementById('regGovDistrict');
            const minSel = document.getElementById('regGovMinistry');
            const deptSel = document.getElementById('regGovDepartment');
            const offSel = document.getElementById('regGovOffice');
            const addrInput = document.getElementById('registrationOfficeAddress');

            if (authId && authSel) {
                authSel.value = authId;
                const provCol = document.getElementById('colRegProvince');
                if (authId == 2 || authId == 3) {
                    if (provCol) provCol.style.display = 'block';
                    if (provId && provSel) provSel.value = provId;
                }
            }
            if (distId && distSel) distSel.value = distId;
            if (minId && minSel) minSel.value = minId;
            if (deptId && deptSel) deptSel.value = deptId;
            if (offId && offSel) offSel.value = offId;
            if (officeAddr && addrInput) addrInput.value = officeAddr;

            updateRegistrationAuthoritySummary();
        }

        // Attach event listeners
        document.getElementById('regGovAuthority')?.addEventListener('change', onAuthorityChange);
        document.getElementById('regGovProvince')?.addEventListener('change', updateRegistrationAuthoritySummary);
        document.getElementById('regGovDistrict')?.addEventListener('change', onDistrictChange);
        document.getElementById('regGovMinistry')?.addEventListener('change', onMinistryChange);
        document.getElementById('regGovDepartment')?.addEventListener('change', onDepartmentChange);
        document.getElementById('regGovOffice')?.addEventListener('change', onOfficeChange);
        document.getElementById('registrationOfficeAddress')?.addEventListener('input', updateRegistrationAuthoritySummary);

        // Initialize Government Hierarchy
        if (document.getElementById('regGovAuthority')) {
            initGovHierarchy();
        }

        // Initialize Person Reissue logic
        document.querySelectorAll('input[name="personReissue"]').forEach(radio => {
            radio.addEventListener('change', function() {
                const details = document.getElementById('personReissueDetails');
                if (details) details.style.display = this.value === 'Yes' ? 'block' : 'none';
            });
        });

        // Initialize Person Same Address logic
        const sameAddr = document.getElementById('personSameAddress');
        if (sameAddr) {
            sameAddr.addEventListener('change', function() {
                const tempProv = document.getElementById('personTempProvince');
                const tempDist = document.getElementById('personTempDistrict');
                const tempMuni = document.getElementById('personTempMunicipality');
                const tempWard = document.getElementById('personTempWard');
                const tempTown = document.getElementById('personTempTown');
                const tempStreet = document.getElementById('personTempStreet');

                if (this.checked) {
                    tempProv.value = document.getElementById('personProvince').value;
                    tempProv.dispatchEvent(new Event('change'));
                    
                    setTimeout(() => {
                        tempDist.value = document.getElementById('personDistrict').value;
                        tempDist.dispatchEvent(new Event('change'));
                        setTimeout(() => {
                            tempMuni.value = document.getElementById('personMunicipality').value;
                            tempMuni.dispatchEvent(new Event('change'));
                            setTimeout(() => {
                                tempWard.value = document.getElementById('personWard').value;
                                tempTown.value = document.getElementById('personTown').value;
                                tempStreet.value = document.getElementById('personStreet').value;
                            }, 50);
                        }, 50);
                    }, 50);
                } else {
                    tempProv.value = "";
                    tempProv.dispatchEvent(new Event('change'));
                    tempTown.value = "";
                    tempStreet.value = "";
                }
            });
        }

    });

    // =========================
    // LOCATION JSON INTEGRATION
    // =========================

    let locationsData = [];

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

    // Helper function to fetch data from JSON
    async function loadLocationsData() {
        try {
            const response = await fetch('forms/locations_en.json');
            if (!response.ok) throw new Error("Network response error");
            const data = await response.json();
            locationsData = data.provinces || [];
            initCascadingDropdowns("registered");
            initCascadingDropdowns("mailing");
            initCascadingDropdowns("person");
            initCascadingDropdowns("personTemp");
            
            let allDistricts = [];
            locationsData.forEach(p => {
                if (p.districts) {
                    p.districts.forEach(d => allDistricts.push(d));
                }
            });
            allDistricts.sort((a, b) => a.name.localeCompare(b.name));
            
            const citiSelect = document.getElementById("personCitizenshipDistrict");
            if (citiSelect) populateDropdown(citiSelect, allDistricts, "Select District");

            const reiSelect = document.getElementById("personReissueDistrict");
            if (reiSelect) populateDropdown(reiSelect, allDistricts, "Select District");
        // Auto-populate if drawerData exists (Edit Mode)
        if (window.drawerData) {
            window.isPopulatingDrawerData = true;

            // Extract Authorized Persons & Signatories
            let ap = window.drawerData.authorizedPersons;
            if (!ap && window.drawerData.applicant_details && window.drawerData.applicant_details.authorizedPersons) {
                ap = window.drawerData.applicant_details.authorizedPersons;
            }
            if (typeof ap === 'string') {
                try { ap = JSON.parse(ap); } catch(e) {}
            }
            if (Array.isArray(ap) && ap.length > 0) {
                currentUnitAuthorized = ap;
            }
            renderAuthorizedTable();
            updateAuthorizationInfo();

            // Explicit fallback mapping for applicant details
            if (window.drawerData.applicant_name) {
                const unEl = document.getElementById('unitNameEnglish');
                if (unEl && !unEl.value) unEl.value = window.drawerData.applicant_name;
            }
            if (window.drawerData.contact_no || window.drawerData.mobile) {
                const conEl = document.getElementById('contact');
                if (conEl && !conEl.value) conEl.value = window.drawerData.contact || window.drawerData.contact_no || window.drawerData.mobile;
            }
            if (window.drawerData.email) {
                const emEl = document.getElementById('email');
                if (emEl && !emEl.value) emEl.value = window.drawerData.email;
            }
            if (window.drawerData.applicant_name_np) {
                const unNpEl = document.getElementById('unitNameNepali');
                if (unNpEl && !unNpEl.value) unNpEl.value = window.drawerData.applicant_name_np;
            }

            // 1. Standard Fields (non-location cascades)
            for (const [key, value] of Object.entries(window.drawerData)) {
                if (key === 'authorizedPersons' || key === 'jointHolders') continue;
                if (['registeredProvince', 'registeredDistrict', 'registeredMunicipality', 'registeredWard', 'mailingProvince', 'mailingDistrict', 'mailingMunicipality', 'mailingWard'].includes(key)) {
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
                        if (key === 'unitNameEnglish' && !finalVal) {
                            finalVal = window.drawerData.applicant_name || '';
                        }
                        if (key === 'contact' && !finalVal) {
                            finalVal = window.drawerData.contact_no || window.drawerData.mobile || '';
                        }
                        if (key === 'email' && !finalVal) {
                            finalVal = window.drawerData.email || '';
                        }
                        el.value = finalVal;
                        el.dispatchEvent(new Event('change'));
                    }
                }
            }

            // Trigger registrationType change listener to refresh authorization rules
            const regTypeEl = document.getElementById('registrationType');
            if (regTypeEl && regTypeEl.value) {
                regTypeEl.dispatchEvent(new Event('change'));
            }

            // Restore Government Hierarchy fields if available
            if (window.drawerData.reg_authority_id || window.drawerData.reg_office_id || window.drawerData.registrationAuthority) {
                if (typeof restoreGovHierarchy === 'function') {
                    restoreGovHierarchy(
                        window.drawerData.reg_authority_id,
                        window.drawerData.reg_ministry_id,
                        window.drawerData.reg_department_id,
                        window.drawerData.reg_office_id,
                        window.drawerData.reg_province_id || window.drawerData.registeredProvince,
                        window.drawerData.reg_district_id,
                        window.drawerData.registrationOfficeAddress
                    );
                }
                if (window.drawerData.registrationAuthority) {
                    const raEl = document.getElementById('registrationAuthority');
                    if (raEl) raEl.value = window.drawerData.registrationAuthority;
                }
                if (window.drawerData.registrationAuthorityNp) {
                    const raNpEl = document.getElementById('registrationAuthorityNp');
                    if (raNpEl) raNpEl.value = window.drawerData.registrationAuthorityNp;
                }
            }

            // 2. Sequential Ordered Location Auto-Population for Registered Address
            const regProv = window.drawerData.registeredProvince;
            const regDist = window.drawerData.registeredDistrict;
            const regMuni = window.drawerData.registeredMunicipality;
            const regWard = window.drawerData.registeredWard;

            if (regProv) {
                const rProvEl = document.getElementById('registeredProvince');
                if (rProvEl) {
                    rProvEl.value = regProv;
                    rProvEl.dispatchEvent(new Event('change'));
                    
                    if (regDist) {
                        const rDistEl = document.getElementById('registeredDistrict');
                        if (rDistEl) {
                            rDistEl.value = regDist;
                            rDistEl.dispatchEvent(new Event('change'));
                            
                            if (regMuni) {
                                const rMuniEl = document.getElementById('registeredMunicipality');
                                if (rMuniEl) {
                                    rMuniEl.value = regMuni;
                                    rMuniEl.dispatchEvent(new Event('change'));
                                    
                                    if (regWard) {
                                        const rWardEl = document.getElementById('registeredWard');
                                        if (rWardEl) {
                                            rWardEl.value = regWard;
                                            rWardEl.dispatchEvent(new Event('change'));
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // 3. Sequential Ordered Location Auto-Population for Mailing Address
            const mailProv = window.drawerData.mailingProvince;
            const mailDist = window.drawerData.mailingDistrict;
            const mailMuni = window.drawerData.mailingMunicipality;
            const mailWard = window.drawerData.mailingWard;

            if (mailProv) {
                const mProvEl = document.getElementById('mailingProvince');
                if (mProvEl) {
                    mProvEl.value = mailProv;
                    mProvEl.dispatchEvent(new Event('change'));
                    
                    if (mailDist) {
                        const mDistEl = document.getElementById('mailingDistrict');
                        if (mDistEl) {
                            mDistEl.value = mailDist;
                            mDistEl.dispatchEvent(new Event('change'));
                            
                            if (mailMuni) {
                                const mMuniEl = document.getElementById('mailingMunicipality');
                                if (mMuniEl) {
                                    mMuniEl.value = mailMuni;
                                    mMuniEl.dispatchEvent(new Event('change'));
                                    
                                    if (mailWard) {
                                        const mWardEl = document.getElementById('mailingWard');
                                        if (mWardEl) {
                                            mWardEl.value = mailWard;
                                            mWardEl.dispatchEvent(new Event('change'));
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            window.isPopulatingDrawerData = false;
            renderAuthorizedTable();
            updateAuthorizationInfo();
        }

        } catch (error) {
            console.error("Error loading locations_en.json:", error);
        }
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

</script>

<script src="../Date Converter/core.js"></script>