<script>
    let currentJointHolders = [];
    let editJointHolderIndex = -1;

    document.addEventListener("DOMContentLoaded", function () {
        if (typeof window.drawerData !== 'undefined' && window.drawerData.jointHolders) {
            let j = window.drawerData.jointHolders;
            if (typeof j === 'string') {
                try { j = JSON.parse(j); } catch(e) {}
            }
            if (Array.isArray(j)) {
                currentJointHolders = j;
            }
        }
        renderJointHoldersTable();

        const addBtn = document.getElementById("addJointHolderBtn");
        if (addBtn) {
            addBtn.addEventListener("click", function () {
                editJointHolderIndex = -1;
                resetJointHolderForm();
                document.getElementById("authorizedForm").style.display = "block";
                document.getElementById("naturalPersonForm").style.display = "block";
            });
        }

        const cancelBtn = document.getElementById("cancelAuthorizedBtn");
        if (cancelBtn) {
            cancelBtn.addEventListener("click", function () {
                resetJointHolderForm();
                document.getElementById("authorizedForm").style.display = "none";
            });
        }

        const saveBtn = document.getElementById("saveAuthorizedBtn");
        if (saveBtn) {
            saveBtn.addEventListener("click", saveJointHolder);
        }
        
        // Handle reissue toggle
        const reissueRadios = document.querySelectorAll('input[name="personReissue"]');
        reissueRadios.forEach(r => {
            r.addEventListener('change', function() {
                const box = document.getElementById('personReissueDetails');
                if (document.getElementById('personReissueYes').checked) {
                    box.style.display = 'block';
                } else {
                    box.style.display = 'none';
                    // clear inputs
                    box.querySelectorAll('input, select').forEach(i => i.value = '');
                }
            });
        });
    });

    function resetJointHolderForm() {
        document.getElementById("authorizedRole").value = "";
        
        const npForm = document.getElementById("naturalPersonForm");
        npForm.querySelectorAll("input[type=text], input[type=email], select").forEach(i => i.value = "");
        document.getElementById("personReissueNo").checked = true;
        document.getElementById("personReissueDetails").style.display = "none";
    }

    function saveJointHolder() {
        // Collect data
        let pNameEn = document.getElementById("personNameEnglish").value.trim();
        let pNameNp = document.getElementById("personNameNepali").value.trim();
        let pRole = document.getElementById("authorizedRole").value.trim();
        let pCit = document.getElementById("personCitizenship").value.trim();
        
        if (!pNameEn || !pCit) {
            alert("Name and Citizenship Number are required.");
            return;
        }

        let obj = {
            authorizedType: "Natural Person",
            authorizedRole: pRole,
            personNameEnglish: pNameEn,
            personNameNepali: pNameNp,
            personDob: document.getElementById("personDob").value,
            personDobBs: document.getElementById("personDobBs").value,
            personGender: document.getElementById("personGender").value,
            personNid: document.getElementById("personNid").value,
            personCitizenship: pCit,
            personCitizenshipDate: document.getElementById("personCitizenshipDate").value,
            personCitizenshipDistrict: document.getElementById("personCitizenshipDistrict").value,
            personCitizenshipAuthority: document.getElementById("personCitizenshipAuthority").value,
            personCitizenshipIssuePlace: document.getElementById("personCitizenshipIssuePlace").value,
            personMobile: document.getElementById("personMobile").value,
            personEmail: document.getElementById("personEmail").value,
            personReissue: document.getElementById("personReissueYes").checked ? "Yes" : "No",
            personPratilipiType: document.getElementById("personPratilipiType") ? document.getElementById("personPratilipiType").value : "",
            personReissueDate: document.getElementById("personReissueDate") ? document.getElementById("personReissueDate").value : "",
            personReissueDistrict: document.getElementById("personReissueDistrict") ? document.getElementById("personReissueDistrict").value : "",
            personReissueAuthority: document.getElementById("personReissueAuthority") ? document.getElementById("personReissueAuthority").value : "",
            personReissuePlace: document.getElementById("personReissuePlace") ? document.getElementById("personReissuePlace").value : "",
            personGrandfather: document.getElementById("personGrandfather") ? document.getElementById("personGrandfather").value : "",
            personFather: document.getElementById("personFather") ? document.getElementById("personFather").value : "",
            personSpouse: document.getElementById("personSpouse") ? document.getElementById("personSpouse").value : ""
        };

        if (editJointHolderIndex >= 0) {
            currentJointHolders[editJointHolderIndex] = obj;
        } else {
            currentJointHolders.push(obj);
        }

        resetJointHolderForm();
        document.getElementById("authorizedForm").style.display = "none";
        renderJointHoldersTable();
    }

    function editJointHolder(index) {
        editJointHolderIndex = index;
        const obj = currentJointHolders[index];

        document.getElementById("authorizedRole").value = obj.authorizedRole || obj.role || "";
        document.getElementById("personNameEnglish").value = obj.personNameEnglish || obj.nameEnglish || "";
        document.getElementById("personNameNepali").value = obj.personNameNepali || obj.nameNepali || "";
        document.getElementById("personDob").value = obj.personDob || obj.dob || "";
        document.getElementById("personDobBs").value = obj.personDobBs || obj.dobBs || "";
        document.getElementById("personGender").value = obj.personGender || obj.gender || "";
        document.getElementById("personNid").value = obj.personNid || obj.nid || "";
        document.getElementById("personCitizenship").value = obj.personCitizenship || obj.citizenship || "";
        document.getElementById("personCitizenshipDate").value = obj.personCitizenshipDate || obj.citizenshipDate || "";
        document.getElementById("personCitizenshipDistrict").value = obj.personCitizenshipDistrict || obj.citizenshipDistrict || "";
        document.getElementById("personCitizenshipAuthority").value = obj.personCitizenshipAuthority || obj.citizenshipAuthority || "";
        document.getElementById("personCitizenshipIssuePlace").value = obj.personCitizenshipIssuePlace || obj.citizenshipIssuePlace || "";
        document.getElementById("personMobile").value = obj.personMobile || obj.mobile || "";
        document.getElementById("personEmail").value = obj.personEmail || obj.email || "";
        
        let isReissue = (obj.personReissue === "Yes" || obj.reissue === "Yes");
        if (isReissue) {
            document.getElementById("personReissueYes").checked = true;
            document.getElementById("personReissueDetails").style.display = "block";
        } else {
            document.getElementById("personReissueNo").checked = true;
            document.getElementById("personReissueDetails").style.display = "none";
        }
        
        if(document.getElementById("personPratilipiType")) document.getElementById("personPratilipiType").value = obj.personPratilipiType || obj.pratilipiType || "";
        if(document.getElementById("personReissueDate")) document.getElementById("personReissueDate").value = obj.personReissueDate || obj.reissueDate || "";
        if(document.getElementById("personReissueDistrict")) document.getElementById("personReissueDistrict").value = obj.personReissueDistrict || obj.reissueDistrict || "";
        if(document.getElementById("personReissueAuthority")) document.getElementById("personReissueAuthority").value = obj.personReissueAuthority || obj.reissueAuthority || "";
        if(document.getElementById("personReissuePlace")) document.getElementById("personReissuePlace").value = obj.personReissuePlace || obj.reissuePlace || "";
        
        const fam = obj.family || {};
        if(document.getElementById("personGrandfather")) document.getElementById("personGrandfather").value = obj.personGrandfather || fam.grandfather || "";
        if(document.getElementById("personFather")) document.getElementById("personFather").value = obj.personFather || fam.father || "";
        if(document.getElementById("personSpouse")) document.getElementById("personSpouse").value = obj.personSpouse || fam.spouse || "";

        document.getElementById("authorizedForm").style.display = "block";
        document.getElementById("naturalPersonForm").style.display = "block";
        window.scrollTo({top: document.getElementById("authorizedForm").offsetTop - 50, behavior: "smooth"});
    }

    function removeJointHolder(index) {
        if (confirm("Are you sure you want to remove this joint holder?")) {
            currentJointHolders.splice(index, 1);
            renderJointHoldersTable();
        }
    }

    function renderJointHoldersTable() {
        const tbody = document.getElementById("authorizedTableBody");
        if (!tbody) return;

        tbody.innerHTML = "";
        
        if (currentJointHolders.length === 0) {
            tbody.innerHTML = `<tr id="emptyAuthRow"><td colspan="5" class="text-center text-muted py-4">No joint holders added yet.</td></tr>`;
            return;
        }

        currentJointHolders.forEach((j, i) => {
            const nameEn = j.personNameEnglish || j.nameEnglish || '';
            const nameNp = j.personNameNepali || j.nameNepali || '';
            const role = j.authorizedRole || j.role || '-';
            const cit = j.personCitizenship || j.citizenship || '-';
            const mob = j.personMobile || j.mobile || '-';

            const tr = document.createElement("tr");
            tr.innerHTML = `
                <td>
                    <div class="fw-bold">${nameEn}</div>
                    <div class="small text-muted">${nameNp}</div>
                </td>
                <td>${role}</td>
                <td>${cit}</td>
                <td>${mob}</td>
                <td>
                    <button type="button" class="btn btn-sm btn-outline-primary" onclick="editJointHolder(${i})" style="${window.location.search.includes('action=view') ? 'display:none;' : ''}">Edit</button>
                    <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeJointHolder(${i})" style="${window.location.search.includes('action=view') ? 'display:none;' : ''}">Remove</button>
                </td>
            `;
            tbody.appendChild(tr);
        });
    }
</script>
