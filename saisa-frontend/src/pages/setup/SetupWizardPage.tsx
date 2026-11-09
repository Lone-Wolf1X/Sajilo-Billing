import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { toast } from 'sonner';
import {
  Building2,
  FileText,
  MapPin,
  UserCheck,
  CheckCircle2,
  ArrowRight,
  Clock,
  Sparkles,
} from 'lucide-react';
import { useCompanyProfile, useUpdateProfile, useCompleteSetup } from '../../hooks/useSetup';
import { CascadingAddressSelector, AddressValue } from '../../components/setup/CascadingAddressSelector';
import type { IncorporationType, BusinessNature } from '../../types/setup';
import rawAuthorities from '../../data/registration_authorities.json';

const authorities = rawAuthorities as Record<string, { en: string; np: string }>;

export const SetupWizardPage: React.FC = () => {
  const navigate = useNavigate();
  const { data: profile, isLoading } = useCompanyProfile();
  const updateMutation = useUpdateProfile();
  const completeMutation = useCompleteSetup();

  // Form State
  const [companyName, setCompanyName] = useState('');
  const [companyNameNepali, setCompanyNameNepali] = useState('');
  const [legalName, setLegalName] = useState('');
  const [incorporationType, setIncorporationType] = useState<IncorporationType>('PRIVATE_LIMITED');
  const [businessNature, setBusinessNature] = useState<BusinessNature>('TRADING');

  // Tax & Registration State
  const [registrationAuthority, setRegistrationAuthority] = useState('');
  const [registrationNo, setRegistrationNo] = useState('');
  const [registrationDate, setRegistrationDate] = useState('');
  const [panVatNo, setPanVatNo] = useState('');
  const [panVatDate, setPanVatDate] = useState('');

  // Address State
  const [addressValue, setAddressValue] = useState<AddressValue>({
    province: '',
    district: '',
    municipalityVdc: '',
    wardNo: undefined,
    toleStreet: '',
  });
  const [phone, setPhone] = useState('');
  const [email, setEmail] = useState('');

  // Authorized Person State
  const [authorizedPersonName, setAuthorizedPersonName] = useState('');
  const [authorizedPersonDesignation, setAuthorizedPersonDesignation] = useState('Managing Director');
  const [authorizedPersonPhone, setAuthorizedPersonPhone] = useState('');
  const [authorizedPersonEmail, setAuthorizedPersonEmail] = useState('');

  // Sync profile data into state
  useEffect(() => {
    if (profile) {
      if (profile.companyName) setCompanyName(profile.companyName);
      if (profile.companyNameNepali) setCompanyNameNepali(profile.companyNameNepali);
      if (profile.legalName) setLegalName(profile.legalName);
      if (profile.incorporationType) setIncorporationType(profile.incorporationType);
      if (profile.businessNature) setBusinessNature(profile.businessNature);
      if (profile.registrationAuthority) setRegistrationAuthority(profile.registrationAuthority);
      if (profile.registrationNo) setRegistrationNo(profile.registrationNo);
      if (profile.registrationDate) setRegistrationDate(profile.registrationDate);
      if (profile.panVatNo || profile.pan) setPanVatNo(profile.panVatNo || profile.pan || '');
      if (profile.panVatDate) setPanVatDate(profile.panVatDate);
      setAddressValue({
        province: profile.province || '',
        district: profile.district || '',
        municipalityVdc: profile.municipalityVdc || '',
        wardNo: profile.wardNo,
        toleStreet: profile.toleStreet || '',
      });
      if (profile.phone) setPhone(profile.phone);
      if (profile.email) setEmail(profile.email);
      if (profile.authorizedPersonName) setAuthorizedPersonName(profile.authorizedPersonName);
      if (profile.authorizedPersonDesignation) setAuthorizedPersonDesignation(profile.authorizedPersonDesignation);
      if (profile.authorizedPersonPhone) setAuthorizedPersonPhone(profile.authorizedPersonPhone);
      if (profile.authorizedPersonEmail) setAuthorizedPersonEmail(profile.authorizedPersonEmail);
    }
  }, [profile]);

  const handleSubmit = async (e: React.FormEvent, complete: boolean = false) => {
    e.preventDefault();

    if (!companyName.trim()) {
      toast.error('Company Name (English) is required.');
      return;
    }

    try {
      await updateMutation.mutateAsync({
        companyName: companyName.trim(),
        companyNameNepali: companyNameNepali.trim() || undefined,
        legalName: legalName.trim() || undefined,
        incorporationType,
        businessNature,
        registrationAuthority: registrationAuthority || undefined,
        registrationNo: registrationNo.trim() || undefined,
        registrationDate: registrationDate || undefined,
        panVatNo: panVatNo.trim() || undefined,
        panVatDate: panVatDate || undefined,
        province: addressValue.province || undefined,
        district: addressValue.district || undefined,
        municipalityVdc: addressValue.municipalityVdc || undefined,
        wardNo: addressValue.wardNo,
        toleStreet: addressValue.toleStreet?.trim() || undefined,
        phone: phone.trim() || undefined,
        email: email.trim() || undefined,
        authorizedPersonName: authorizedPersonName.trim() || undefined,
        authorizedPersonDesignation: authorizedPersonDesignation.trim() || undefined,
        authorizedPersonPhone: authorizedPersonPhone.trim() || undefined,
        authorizedPersonEmail: authorizedPersonEmail.trim() || undefined,
        setupStep: 2,
      });

      if (complete) {
        await completeMutation.mutateAsync();
        toast.success('🎉 Business profile setup completed successfully!');
        navigate('/dashboard');
      } else {
        toast.success('Company profile saved! Proceeding to next step.');
        navigate('/dashboard');
      }
    } catch (err: any) {
      toast.error(err?.response?.data?.message || 'Failed to save company profile.');
    }
  };

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <div className="text-center">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600 mx-auto mb-3" />
          <p className="text-sm text-neutral-500 font-serif">
            Loading Nepal Business Master Setup...
          </p>
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-5xl mx-auto px-4 py-8">
      {/* Classical Header */}
      <div className="bg-white dark:bg-neutral-900 border border-neutral-300 dark:border-neutral-800 rounded-lg p-6 shadow-sm mb-6">
        <div className="flex flex-col md:flex-row items-start md:items-center justify-between gap-4 border-b border-neutral-200 dark:border-neutral-800 pb-5">
          <div>
            <div className="inline-flex items-center gap-2 px-2.5 py-1 rounded bg-amber-50 dark:bg-amber-950/40 border border-amber-200 dark:border-amber-900/60 text-amber-800 dark:text-amber-300 text-xs font-semibold mb-2">
              <Sparkles className="w-3.5 h-3.5" />
              <span>प्रारम्भिक सेटअप विजार्ड • Onboarding Guided Setup</span>
            </div>
            <h1 className="text-2xl font-serif font-bold text-neutral-900 dark:text-neutral-100">
              व्यापार प्रोफाइल तथा संस्थागत विवरण (Phase 1)
            </h1>
            <p className="text-sm text-neutral-600 dark:text-neutral-400 mt-1">
              नेपाल सरकारको नियमानुसार कर विजक (Tax Invoice), भ्याट विवरण र आधिकारिक लेजरका लागि आवश्यक कम्पनी प्रोफाइल पूरा गर्नुहोस्।
            </p>
          </div>

          <div className="flex items-center gap-3">
            {profile?.setupCompleted ? (
              <span className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-emerald-50 dark:bg-emerald-950/40 text-emerald-700 dark:text-emerald-300 border border-emerald-200 dark:border-emerald-800 text-xs font-semibold">
                <CheckCircle2 className="w-4 h-4" />
                सेटअप पूरा भएको (Completed)
              </span>
            ) : (
              <span className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-blue-50 dark:bg-blue-950/40 text-blue-700 dark:text-blue-300 border border-blue-200 dark:border-blue-800 text-xs font-semibold">
                <Clock className="w-4 h-4" />
                सेटअप बाँकी (In Progress)
              </span>
            )}
          </div>
        </div>

        {/* 3-Step Guided Stepper */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-3 pt-5">
          <div className="flex items-center gap-3 p-3 rounded border border-primary-500/40 bg-primary-50/50 dark:bg-primary-950/20">
            <div className="w-7 h-7 rounded-full bg-primary-700 text-white font-bold text-xs flex items-center justify-center">
              1
            </div>
            <div>
              <div className="text-xs font-bold text-primary-900 dark:text-primary-200">
                Phase 1: Business Profile
              </div>
              <div className="text-[11px] text-neutral-500">
                कम्पनी, प्यान/भ्याट, आधिकारिक ठेगाना
              </div>
            </div>
          </div>

          <div className="flex items-center gap-3 p-3 rounded border border-neutral-200 dark:border-neutral-800 bg-neutral-50/50 dark:bg-neutral-800/20 opacity-75">
            <div className="w-7 h-7 rounded-full bg-neutral-300 dark:bg-neutral-700 text-neutral-700 dark:text-neutral-300 font-bold text-xs flex items-center justify-center">
              2
            </div>
            <div>
              <div className="text-xs font-bold text-neutral-700 dark:text-neutral-300 flex items-center gap-1">
                Phase 2: Opening Balances
                <span className="text-[10px] bg-neutral-200 dark:bg-neutral-700 px-1.5 py-0.2 rounded font-normal">
                  अर्को चरण
                </span>
              </div>
              <div className="text-[11px] text-neutral-500">
                प्रारम्भिक मौज्दात र लेजर सन्तुलन
              </div>
            </div>
          </div>

          <div className="flex items-center gap-3 p-3 rounded border border-neutral-200 dark:border-neutral-800 bg-neutral-50/50 dark:bg-neutral-800/20 opacity-75">
            <div className="w-7 h-7 rounded-full bg-neutral-300 dark:bg-neutral-700 text-neutral-700 dark:text-neutral-300 font-bold text-xs flex items-center justify-center">
              3
            </div>
            <div>
              <div className="text-xs font-bold text-neutral-700 dark:text-neutral-300 flex items-center gap-1">
                Phase 3: Inventory Quickstart
                <span className="text-[10px] bg-neutral-200 dark:bg-neutral-700 px-1.5 py-0.2 rounded font-normal">
                  अर्को चरण
                </span>
              </div>
              <div className="text-[11px] text-neutral-500">
                गोदाम (Warehouse) र सुरुआती सामान
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Main Form */}
      <form onSubmit={(e) => handleSubmit(e, false)} className="space-y-6">
        {/* SECTION 1: Unit / Company Master Information */}
        <div className="bg-white dark:bg-neutral-900 border border-neutral-300 dark:border-neutral-800 rounded-lg p-6 shadow-sm">
          <div className="flex items-center gap-2 pb-3 mb-5 border-b border-neutral-200 dark:border-neutral-800">
            <Building2 className="w-5 h-5 text-primary-600" />
            <h2 className="text-base font-bold font-serif text-neutral-900 dark:text-neutral-100">
              १. कम्पनी / संस्थाको विवरण (Unit / Business Information)
            </h2>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {/* Company Name English */}
            <div>
              <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
                Unit / Company Name (English) <span className="text-red-500">*</span>
              </label>
              <input
                type="text"
                required
                value={companyName}
                onChange={(e) => setCompanyName(e.target.value)}
                placeholder="e.g. Himalayan Traders Pvt. Ltd."
                className="w-full px-3 py-2 text-sm border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500"
              />
            </div>

            {/* Company Name Nepali */}
            <div>
              <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
                कम्पनी / संस्थाको नाम (नेपालीमा) <span className="text-red-500">*</span>
              </label>
              <input
                type="text"
                value={companyNameNepali}
                onChange={(e) => setCompanyNameNepali(e.target.value)}
                placeholder="उदा. हिमालयन ट्रेडर्स प्रा. लि."
                className="w-full px-3 py-2 text-sm border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500 font-serif"
              />
            </div>

            {/* Legal / Trade Name */}
            <div>
              <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
                Legal / Trade Name (कानूनी वा व्यापारिक नाम)
              </label>
              <input
                type="text"
                value={legalName}
                onChange={(e) => setLegalName(e.target.value)}
                placeholder="e.g. Himalayan Enterprises"
                className="w-full px-3 py-2 text-sm border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500"
              />
            </div>

            {/* Incorporation Type */}
            <div>
              <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
                Registration Type / संस्थागत दर्ता प्रकार <span className="text-red-500">*</span>
              </label>
              <select
                value={incorporationType}
                onChange={(e) => setIncorporationType(e.target.value as IncorporationType)}
                className="w-full px-3 py-2 text-sm border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500"
              >
                <option value="PRIVATE_LIMITED">Private Limited (प्राइभेट लिमिटेड कम्पनी)</option>
                <option value="PROPRIETORSHIP">Sole Proprietorship (एकलौटी फर्म)</option>
                <option value="PARTNERSHIP">Partnership Firm (साझेदारी फर्म)</option>
                <option value="PUBLIC_LIMITED">Public Limited (पब्लिक लिमिटेड कम्पनी)</option>
                <option value="COOPERATIVE">Cooperative Society (सहकारी संस्था)</option>
                <option value="NGO">Non-Governmental Organization / Trust (गैरसरकारी संस्था / गुठी)</option>
                <option value="GOVERNMENT">Government Department / Corporation (सरकारी निकाय / संस्थान)</option>
                <option value="OTHER">Other Entity (अन्य निकाय)</option>
              </select>
            </div>

            {/* Business Nature */}
            <div className="md:col-span-2">
              <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
                Business Nature / कारोबारको प्रकृति <span className="text-red-500">*</span>
              </label>
              <div className="grid grid-cols-2 md:grid-cols-4 gap-2 pt-1">
                {[
                  { value: 'TRADING', label_en: 'Trading / थोक व्यापार', label_np: 'व्यापार' },
                  { value: 'RETAIL', label_en: 'Retail / खुद्रा', label_np: 'खुद्रा' },
                  { value: 'MANUFACTURING', label_en: 'Manufacturing / उत्पादन', label_np: 'उत्पादन' },
                  { value: 'SERVICE', label_en: 'Service Provider / सेवा', label_np: 'सेवा' },
                  { value: 'WHOLESALE', label_en: 'Wholesale / होलसेल', label_np: 'थोक' },
                  { value: 'MIXED', label_en: 'Mixed / मिश्रित', label_np: 'मिश्रित' },
                ].map((item) => (
                  <label
                    key={item.value}
                    className={`flex items-center gap-2 p-2.5 rounded border text-xs cursor-pointer transition-all ${
                      businessNature === item.value
                        ? 'border-primary-600 bg-primary-50/60 dark:bg-primary-950/40 text-primary-900 dark:text-primary-200 font-semibold shadow-sm'
                        : 'border-neutral-300 dark:border-neutral-700 hover:border-neutral-400 text-neutral-700 dark:text-neutral-300'
                    }`}
                  >
                    <input
                      type="radio"
                      name="businessNature"
                      value={item.value}
                      checked={businessNature === item.value}
                      onChange={() => setBusinessNature(item.value as BusinessNature)}
                      className="text-primary-600 focus:ring-primary-500"
                    />
                    <span>{item.label_en}</span>
                  </label>
                ))}
              </div>
            </div>
          </div>
        </div>

        {/* SECTION 2: Tax & Legal Registration Details */}
        <div className="bg-white dark:bg-neutral-900 border border-neutral-300 dark:border-neutral-800 rounded-lg p-6 shadow-sm">
          <div className="flex items-center gap-2 pb-3 mb-5 border-b border-neutral-200 dark:border-neutral-800">
            <FileText className="w-5 h-5 text-primary-600" />
            <h2 className="text-base font-bold font-serif text-neutral-900 dark:text-neutral-100">
              २. दर्ता तथा कर विवरण (Registration & Tax Details)
            </h2>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            {/* Registration Authority */}
            <div className="md:col-span-2">
              <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
                Registration Authority / दर्ता गर्ने निकाय
              </label>
              <select
                value={registrationAuthority}
                onChange={(e) => setRegistrationAuthority(e.target.value)}
                className="w-full px-3 py-2 text-sm border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500"
              >
                <option value="">-- Select Authority / निकाय छान्नुहोस् --</option>
                {Object.entries(authorities).map(([key, val]) => (
                  <option key={key} value={val.en}>
                    {val.en} ({val.np})
                  </option>
                ))}
              </select>
            </div>

            {/* Registration Number */}
            <div>
              <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
                Registration No. / दर्ता नम्बर
              </label>
              <input
                type="text"
                value={registrationNo}
                onChange={(e) => setRegistrationNo(e.target.value)}
                placeholder="उदा. 123456/080/081"
                className="w-full px-3 py-2 text-sm border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500 font-mono"
              />
            </div>

            {/* Registration Date */}
            <div>
              <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
                Registration Date / दर्ता मिति
              </label>
              <input
                type="date"
                value={registrationDate}
                onChange={(e) => setRegistrationDate(e.target.value)}
                className="w-full px-3 py-2 text-sm border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500"
              />
            </div>

            {/* PAN / VAT Number */}
            <div>
              <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
                PAN / VAT No. (स्थायी लेखा नं. ९ अंक) <span className="text-red-500">*</span>
              </label>
              <input
                type="text"
                maxLength={20}
                value={panVatNo}
                onChange={(e) => setPanVatNo(e.target.value)}
                placeholder="उदा. 601234567"
                className="w-full px-3 py-2 text-sm border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500 font-mono font-bold tracking-wider"
              />
            </div>

            {/* PAN/VAT Date */}
            <div>
              <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
                PAN/VAT Date / प्यान दर्ता मिति
              </label>
              <input
                type="date"
                value={panVatDate}
                onChange={(e) => setPanVatDate(e.target.value)}
                className="w-full px-3 py-2 text-sm border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500"
              />
            </div>
          </div>
        </div>

        {/* SECTION 3: Registered Office Address (Cascading Nepal Geographies) */}
        <div className="bg-white dark:bg-neutral-900 border border-neutral-300 dark:border-neutral-800 rounded-lg p-6 shadow-sm">
          <div className="flex items-center gap-2 pb-3 mb-5 border-b border-neutral-200 dark:border-neutral-800">
            <MapPin className="w-5 h-5 text-primary-600" />
            <h2 className="text-base font-bold font-serif text-neutral-900 dark:text-neutral-100">
              ३. दर्ता भएको ठेगाना (Registered Office Address)
            </h2>
          </div>

          <div className="space-y-4">
            <CascadingAddressSelector
              value={addressValue}
              onChange={setAddressValue}
            />

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 pt-2 border-t border-neutral-100 dark:border-neutral-800">
              <div>
                <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
                  Official Phone / टेलिफोन / फोन नं.
                </label>
                <input
                  type="text"
                  value={phone}
                  onChange={(e) => setPhone(e.target.value)}
                  placeholder="उदा. 01-4412345 वा 98XXXXXXXX"
                  className="w-full px-3 py-2 text-sm border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500 font-mono"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
                  Official Email / आधिकारिक इमेल
                </label>
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="उदा. info@company.com.np"
                  className="w-full px-3 py-2 text-sm border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500"
                />
              </div>
            </div>
          </div>
        </div>

        {/* SECTION 4: Key Contact / Authorized Person */}
        <div className="bg-white dark:bg-neutral-900 border border-neutral-300 dark:border-neutral-800 rounded-lg p-6 shadow-sm">
          <div className="flex items-center gap-2 pb-3 mb-5 border-b border-neutral-200 dark:border-neutral-800">
            <UserCheck className="w-5 h-5 text-primary-600" />
            <h2 className="text-base font-bold font-serif text-neutral-900 dark:text-neutral-100">
              ४. मुख्य अख्तियारप्राप्त व्यक्ति (Key Authorized Signatory / Person)
            </h2>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
                Authorized Person Full Name (पूरा नाम)
              </label>
              <input
                type="text"
                value={authorizedPersonName}
                onChange={(e) => setAuthorizedPersonName(e.target.value)}
                placeholder="e.g. Ramesh Kumar Sharma"
                className="w-full px-3 py-2 text-sm border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500"
              />
            </div>

            <div>
              <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
                Designation / पद
              </label>
              <select
                value={authorizedPersonDesignation}
                onChange={(e) => setAuthorizedPersonDesignation(e.target.value)}
                className="w-full px-3 py-2 text-sm border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500"
              >
                <option value="Managing Director">Managing Director (प्रबन्ध निर्देशक)</option>
                <option value="Proprietor">Proprietor / Owner (प्रोप्राइटर / धनी)</option>
                <option value="Partner">Managing Partner (साझेदार)</option>
                <option value="Chairman">Chairman / President (अध्यक्ष)</option>
                <option value="Director">Director (सञ्चालक)</option>
                <option value="CEO">Chief Executive Officer (CEO / प्रमुख कार्यकारी अधिकृत)</option>
                <option value="Company Secretary">Company Secretary (कम्पनी सचिव)</option>
                <option value="Account Operator">Account Operator / Signatory (खाता सञ्चालक)</option>
                <option value="Authorized Representative">Authorized Representative (अख्तियारप्राप्त प्रतिनिधि)</option>
              </select>
            </div>

            <div>
              <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
                Mobile Number / मोबाइल नं.
              </label>
              <input
                type="text"
                value={authorizedPersonPhone}
                onChange={(e) => setAuthorizedPersonPhone(e.target.value)}
                placeholder="+977-98XXXXXXXX"
                className="w-full px-3 py-2 text-sm border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500 font-mono"
              />
            </div>

            <div>
              <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
                Personal / Direct Email (इमेल)
              </label>
              <input
                type="email"
                value={authorizedPersonEmail}
                onChange={(e) => setAuthorizedPersonEmail(e.target.value)}
                placeholder="signatory@company.com.np"
                className="w-full px-3 py-2 text-sm border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500"
              />
            </div>
          </div>
        </div>

        {/* Action Buttons Bar */}
        <div className="flex flex-col sm:flex-row items-center justify-between gap-4 bg-white dark:bg-neutral-900 border border-neutral-300 dark:border-neutral-800 rounded-lg p-5 shadow-sm">
          <button
            type="button"
            onClick={() => navigate('/dashboard')}
            className="w-full sm:w-auto px-4 py-2 text-sm font-semibold text-neutral-600 dark:text-neutral-400 hover:text-neutral-900 dark:hover:text-neutral-100 hover:bg-neutral-100 dark:hover:bg-neutral-800 rounded border border-neutral-300 dark:border-neutral-700 transition-colors"
          >
            अहिलेलाई छोड्नुहोस् (Skip to Dashboard)
          </button>

          <div className="flex items-center gap-3 w-full sm:w-auto">
            <button
              type="submit"
              disabled={updateMutation.isPending}
              className="flex-1 sm:flex-none inline-flex items-center justify-center gap-2 px-5 py-2 text-sm font-semibold text-neutral-800 dark:text-neutral-200 bg-neutral-100 hover:bg-neutral-200 dark:bg-neutral-800 dark:hover:bg-neutral-700 rounded border border-neutral-300 dark:border-neutral-700 transition-colors disabled:opacity-50"
            >
              <span>विवरण सुरक्षित गर्नुहोस् (Save Draft)</span>
            </button>

            <button
              type="button"
              onClick={(e) => handleSubmit(e, true)}
              disabled={updateMutation.isPending || completeMutation.isPending}
              className="flex-1 sm:flex-none inline-flex items-center justify-center gap-2 px-6 py-2 text-sm font-semibold text-white bg-primary-700 hover:bg-primary-800 active:bg-primary-900 rounded shadow-sm transition-colors disabled:opacity-50"
            >
              <span>पूरा गरी अगाडि बढ्नुहोस् (Complete Setup)</span>
              <ArrowRight className="w-4 h-4" />
            </button>
          </div>
        </div>
      </form>
    </div>
  );
};
