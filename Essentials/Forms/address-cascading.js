/**
 * Reusable Nepal Administrative Address Cascading Dropdown Engine
 * Supports 7 Provinces, 77 Districts, 753 Local Bodies (Municipalities/VDCs), and Wards
 * 
 * Works with locations_en.json, locations_np.json, or locations_unified.json
 */

(function (global) {
    'use strict';

    class NepalAddressCascade {
        /**
         * @param {Object} config
         * @param {string} [config.dataPath='locations_en.json'] - Path to locations JSON
         * @param {string} [config.lang='en'] - 'en' or 'np'
         */
        constructor(config = {}) {
            this.dataPath = config.dataPath || 'locations_en.json';
            this.lang = config.lang || 'en';
            this.data = null;
            this.isLoaded = false;
            this._loadPromise = null;
        }

        async loadData() {
            if (this.isLoaded) return this.data;
            if (this._loadPromise) return this._loadPromise;

            this._loadPromise = fetch(this.dataPath)
                .then(res => {
                    if (!res.ok) throw new Error(`HTTP error! status: ${res.status}`);
                    return res.json();
                })
                .then(json => {
                    this.data = json.provinces || json;
                    this.isLoaded = true;
                    return this.data;
                })
                .catch(err => {
                    console.error("Failed to load Nepal address dataset:", err);
                    throw err;
                });

            return this._loadPromise;
        }

        /**
         * Attach cascading behavior to a set of Province, District, Municipality, Ward selects
         * @param {Object} options
         * @param {string|HTMLElement} options.province - Select element or selector
         * @param {string|HTMLElement} options.district - Select element or selector
         * @param {string|HTMLElement} options.municipality - Select element or selector
         * @param {string|HTMLElement} [options.ward] - Select element or selector
         * @param {Object} [options.initialValues] - { province, district, municipality, ward }
         */
        async bindCascade(options) {
            await this.loadData();

            const provEl = typeof options.province === 'string' ? document.querySelector(options.province) : options.province;
            const distEl = typeof options.district === 'string' ? document.querySelector(options.district) : options.district;
            const muniEl = typeof options.municipality === 'string' ? document.querySelector(options.municipality) : options.municipality;
            const wardEl = options.ward ? (typeof options.ward === 'string' ? document.querySelector(options.ward) : options.ward) : null;

            if (!provEl || !distEl) return;

            // 1. Populate Provinces
            this.populateSelect(provEl, this.data, "Select Province");

            // Province Change Listener
            provEl.addEventListener("change", () => {
                this.resetSelect(distEl, "Select District");
                if (muniEl) this.resetSelect(muniEl, "Select Municipality");
                if (wardEl) this.resetSelect(wardEl, "Select Ward");

                const provName = provEl.value;
                if (!provName) return;

                const provinceObj = this.data.find(p => p.name === provName || p.name_en === provName || p.name_np === provName);
                if (provinceObj && provinceObj.districts) {
                    this.populateSelect(distEl, provinceObj.districts, "Select District");
                }
            });

            // District Change Listener
            distEl.addEventListener("change", () => {
                if (muniEl) this.resetSelect(muniEl, "Select Municipality");
                if (wardEl) this.resetSelect(wardEl, "Select Ward");

                const provName = provEl.value;
                const distName = distEl.value;
                if (!provName || !distName) return;

                const provinceObj = this.data.find(p => p.name === provName || p.name_en === provName || p.name_np === provName);
                if (provinceObj && provinceObj.districts) {
                    const districtObj = provinceObj.districts.find(d => d.name === distName || d.name_en === distName || d.name_np === distName);
                    if (districtObj && districtObj.municipalities && muniEl) {
                        this.populateSelect(muniEl, districtObj.municipalities, "Select Municipality");
                    }
                }
            });

            // Municipality Change Listener
            if (muniEl && wardEl) {
                muniEl.addEventListener("change", () => {
                    this.resetSelect(wardEl, "Select Ward");

                    const provName = provEl.value;
                    const distName = distEl.value;
                    const muniName = muniEl.value;
                    if (!provName || !distName || !muniName) return;

                    const provinceObj = this.data.find(p => p.name === provName || p.name_en === provName || p.name_np === provName);
                    if (provinceObj && provinceObj.districts) {
                        const districtObj = provinceObj.districts.find(d => d.name === distName || d.name_en === distName || d.name_np === distName);
                        if (districtObj && districtObj.municipalities) {
                            const muniObj = districtObj.municipalities.find(m => m.name === muniName || m.name_en === muniName || m.name_np === muniName);
                            if (muniObj && muniObj.wards) {
                                this.populateWardSelect(wardEl, muniObj.wards, "Select Ward");
                            }
                        }
                    }
                });
            }

            // Set initial values if provided
            if (options.initialValues) {
                const init = options.initialValues;
                if (init.province) {
                    provEl.value = init.province;
                    provEl.dispatchEvent(new Event('change'));

                    if (init.district) {
                        distEl.value = init.district;
                        distEl.dispatchEvent(new Event('change'));

                        if (init.municipality && muniEl) {
                            muniEl.value = init.municipality;
                            muniEl.dispatchEvent(new Event('change'));

                            if (init.ward && wardEl) {
                                wardEl.value = init.ward;
                                wardEl.dispatchEvent(new Event('change'));
                            }
                        }
                    }
                }
            }
        }

        populateSelect(select, list, placeholder) {
            select.innerHTML = `<option value="">-- ${placeholder} --</option>`;
            list.forEach(item => {
                const opt = document.createElement("option");
                const val = item.name || item.name_en || item;
                const text = (this.lang === 'np' && item.name_np) ? item.name_np : val;
                opt.value = val;
                opt.textContent = text;
                select.appendChild(opt);
            });
            select.disabled = false;
        }

        populateWardSelect(select, wards, placeholder) {
            select.innerHTML = `<option value="">-- ${placeholder} --</option>`;
            const count = typeof wards === 'number' ? wards : (Array.isArray(wards) ? wards.length : parseInt(wards, 10));
            for (let w = 1; w <= count; w++) {
                const opt = document.createElement("option");
                opt.value = w.toString();
                opt.textContent = `Ward ${w}`;
                select.appendChild(opt);
            }
            select.disabled = false;
        }

        resetSelect(select, placeholder) {
            select.innerHTML = `<option value="">-- ${placeholder} --</option>`;
            select.disabled = true;
        }

        /**
         * Synchronizes permanent address into temporary/mailing address when checkbox is toggled
         * @param {HTMLElement|string} checkbox
         * @param {string} sourcePrefix - e.g., 'per'
         * @param {string} targetPrefix - e.g., 'temp' or 'mailing'
         */
        static setupSameAddressSync(checkbox, sourcePrefix, targetPrefix) {
            const cb = typeof checkbox === 'string' ? document.querySelector(checkbox) : checkbox;
            if (!cb) return;

            const fields = ["Province", "District", "Municipality", "Ward", "Town", "Street"];

            cb.addEventListener("change", function () {
                if (this.checked) {
                    fields.forEach(field => {
                        const src = document.getElementById(`${sourcePrefix}${field}`);
                        const tgt = document.getElementById(`${targetPrefix}${field}`);
                        if (src && tgt) {
                            if (src.tagName === "SELECT") {
                                tgt.innerHTML = src.innerHTML;
                                tgt.disabled = src.disabled;
                            }
                            tgt.value = src.value;
                        }
                    });
                }
            });
        }
    }

    global.NepalAddressCascade = NepalAddressCascade;

})(typeof window !== 'undefined' ? window : this);
