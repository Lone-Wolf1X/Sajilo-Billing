import React, { useMemo } from 'react';
import rawLocations from '../../data/locations_unified.json';

export interface AddressValue {
  province?: string;
  district?: string;
  municipalityVdc?: string;
  wardNo?: number;
  toleStreet?: string;
}

interface Props {
  value: AddressValue;
  onChange: (val: AddressValue) => void;
  disabled?: boolean;
}

interface MunicipalityItem {
  en: string;
  np: string;
  wards: number[];
}

interface DistrictItem {
  en: string;
  np: string;
  municipalities: MunicipalityItem[];
}

interface ProvinceItem {
  en: string;
  np: string;
  districts: DistrictItem[];
}

interface LocationsData {
  provinces: ProvinceItem[];
}

const locations = rawLocations as LocationsData;

export const CascadingAddressSelector: React.FC<Props> = ({
  value,
  onChange,
  disabled = false,
}) => {
  // 1. Current selected Province item
  const selectedProvince = useMemo(() => {
    if (!value.province) return undefined;
    return locations.provinces.find(
      (p) => p.en === value.province || p.np === value.province
    );
  }, [value.province]);

  // 2. Districts list for selected province
  const availableDistricts = useMemo(() => {
    return selectedProvince?.districts || [];
  }, [selectedProvince]);

  // 3. Current selected District item
  const selectedDistrict = useMemo(() => {
    if (!value.district || !availableDistricts.length) return undefined;
    return availableDistricts.find(
      (d) => d.en === value.district || d.np === value.district
    );
  }, [value.district, availableDistricts]);

  // 4. Municipalities list for selected district
  const availableMunicipalities = useMemo(() => {
    return selectedDistrict?.municipalities || [];
  }, [selectedDistrict]);

  // 5. Current selected Municipality item
  const selectedMunicipality = useMemo(() => {
    if (!value.municipalityVdc || !availableMunicipalities.length) return undefined;
    return availableMunicipalities.find(
      (m) => m.en === value.municipalityVdc || m.np === value.municipalityVdc
    );
  }, [value.municipalityVdc, availableMunicipalities]);

  // 6. Available Wards list
  const availableWards = useMemo(() => {
    if (selectedMunicipality?.wards && selectedMunicipality.wards.length > 0) {
      return selectedMunicipality.wards;
    }
    // Fallback standard 1-35 wards if municipality not specifically loaded
    return Array.from({ length: 32 }, (_, i) => i + 1);
  }, [selectedMunicipality]);

  const handleProvinceChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const prov = e.target.value;
    onChange({
      ...value,
      province: prov,
      district: '',
      municipalityVdc: '',
      wardNo: undefined,
    });
  };

  const handleDistrictChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const dist = e.target.value;
    onChange({
      ...value,
      district: dist,
      municipalityVdc: '',
      wardNo: undefined,
    });
  };

  const handleMunicipalityChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const muni = e.target.value;
    onChange({
      ...value,
      municipalityVdc: muni,
      wardNo: undefined,
    });
  };

  const handleWardChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const ward = e.target.value ? parseInt(e.target.value, 10) : undefined;
    onChange({
      ...value,
      wardNo: ward,
    });
  };

  const handleToleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    onChange({
      ...value,
      toleStreet: e.target.value,
    });
  };

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
      {/* Province */}
      <div>
        <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
          Province / प्रदेश <span className="text-red-500">*</span>
        </label>
        <select
          value={value.province || ''}
          onChange={handleProvinceChange}
          disabled={disabled}
          className="w-full px-3 py-2 text-sm border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-800 dark:text-neutral-200 focus:outline-none focus:ring-1 focus:ring-primary-500"
        >
          <option value="">-- Select Province / प्रदेश छान्नुहोस् --</option>
          {locations.provinces.map((p) => (
            <option key={p.en} value={p.en}>
              {p.en} ({p.np})
            </option>
          ))}
        </select>
      </div>

      {/* District */}
      <div>
        <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
          District / जिल्ला <span className="text-red-500">*</span>
        </label>
        <select
          value={value.district || ''}
          onChange={handleDistrictChange}
          disabled={disabled || !value.province}
          className="w-full px-3 py-2 text-sm border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-800 dark:text-neutral-200 focus:outline-none focus:ring-1 focus:ring-primary-500 disabled:opacity-50"
        >
          <option value="">
            {value.province
              ? '-- Select District / जिल्ला छान्नुहोस् --'
              : '-- Select Province first --'}
          </option>
          {availableDistricts.map((d) => (
            <option key={d.en} value={d.en}>
              {d.en} ({d.np})
            </option>
          ))}
        </select>
      </div>

      {/* Municipality / Local Level */}
      <div>
        <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
          Local Level / स्थानीय तह <span className="text-red-500">*</span>
        </label>
        <select
          value={value.municipalityVdc || ''}
          onChange={handleMunicipalityChange}
          disabled={disabled || !value.district}
          className="w-full px-3 py-2 text-sm border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-800 dark:text-neutral-200 focus:outline-none focus:ring-1 focus:ring-primary-500 disabled:opacity-50"
        >
          <option value="">
            {value.district
              ? '-- Select Municipality / गापा/नपा --'
              : '-- Select District first --'}
          </option>
          {availableMunicipalities.map((m) => (
            <option key={m.en} value={m.en}>
              {m.en} ({m.np})
            </option>
          ))}
        </select>
      </div>

      {/* Ward No */}
      <div>
        <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
          Ward No. / वडा नं. <span className="text-red-500">*</span>
        </label>
        <select
          value={value.wardNo ?? ''}
          onChange={handleWardChange}
          disabled={disabled || !value.municipalityVdc}
          className="w-full px-3 py-2 text-sm border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-800 dark:text-neutral-200 focus:outline-none focus:ring-1 focus:ring-primary-500 disabled:opacity-50"
        >
          <option value="">-- वडा नं. --</option>
          {availableWards.map((w) => (
            <option key={w} value={w}>
              Ward {w} (वडा नं. {w})
            </option>
          ))}
        </select>
      </div>

      {/* Tole / Street */}
      <div className="md:col-span-2 lg:col-span-4">
        <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
          Tole / Street / Road / टोल वा सडक
        </label>
        <input
          type="text"
          value={value.toleStreet || ''}
          onChange={handleToleChange}
          disabled={disabled}
          placeholder="e.g. Lazimpat, Uttardhoka / लाजिम्पाट, उत्तरढोका"
          className="w-full px-3 py-2 text-sm border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-800 dark:text-neutral-200 focus:outline-none focus:ring-1 focus:ring-primary-500"
        />
      </div>
    </div>
  );
};

