import React, { useState, useEffect } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
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
  Check,
} from 'lucide-react';
import {
  useCompanyProfile,
  useUpdateProfile,
  useCompleteSetup,
  useOpeningBalance,
} from '../../hooks/useSetup';
import {
  CascadingAddressSelector,
  AddressValue,
} from '../../components/setup/CascadingAddressSelector';
import { OpeningBalancesStep } from '../../components/setup/OpeningBalancesStep';
import { Phase3InventoryStep } from '../../components/setup/Phase3InventoryStep';
import type { IncorporationType, BusinessNature } from '../../types/setup';
import rawAuthorities from '../../data/registration_authorities.json';

const authorities = rawAuthorities as Record<string, { en: string; np: string }>;

export const SetupWizardPage: React.FC = () => {
  const navigate = useNavigate();
  const [searchParams, setSearchParams] = useSearchParams();
  const paramStep = parseInt(searchParams.get('step') || '1', 10);
  const [currentStep, setCurrentStep] = useState<number>(
    paramStep >= 1 && paramStep <= 3 ? paramStep : 1
  );

  const { data: profile, isLoading } = useCompanyProfile();
  const { data: openingBalance } = useOpeningBalance();
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

  // Inline Validation Errors
  const [formErrors, setFormErrors] = useState<Record<string, string>>({});

  const clearError = (field: string) => {
    if (formErrors[field]) {
      setFormErrors((prev) => {
        const copy = { ...prev };
        delete copy[field];
        return copy;
      });
    }
  };

  const validatePhase1 = (): boolean => {
    const errs: Record<string, string> = {};

    if (!companyName.trim()) {
      errs.companyName = 'Company Name (English) अनिवार्य छ (Required).';
    } else if (companyName.trim().length < 3) {
      errs.companyName = 'कम्पनीको नाम कम्तीमा ३ अक्षरको हुनुपर्छ (Min. 3 characters).';
    }

    if (panVatNo.trim()) {
      const cleanPan = panVatNo.trim().replace(/\D/g, '');
      if (cleanPan.length !== 9) {
        errs.panVatNo = 'नेपालको प्यान/भ्याट नम्बर ठ्याक्कै ९ अंकको हुनुपर्छ (PAN must be exactly 9 digits).';
      }
    }

    if (email.trim()) {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(email.trim())) {
        errs.email = 'मान्य इमेल ठेगाना प्रविष्ट गर्नुहोस् (Invalid email format).';
      }
    }

    if (phone.trim()) {
      const cleanPhone = phone.trim().replace(/[\s-]/g, '');
      if (!/^\+?[0-9]{7,15}$/.test(cleanPhone)) {
        errs.phone = 'फोन नम्बर मान्य हुनुपर्छ (Valid 7-10 digit phone number).';
      }
    }

    if (authorizedPersonEmail.trim()) {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(authorizedPersonEmail.trim())) {
        errs.authorizedPersonEmail = 'हस्ताक्षरकर्ताको इमेल मान्य छैन (Invalid email format).';
      }
    }

    if (authorizedPersonPhone.trim()) {
      const cleanPhone = authorizedPersonPhone.trim().replace(/[\s-]/g, '');
      if (!/^\+?[0-9]{9,15}$/.test(cleanPhone)) {
        errs.authorizedPersonPhone = 'मोबाइल नम्बर मान्य हुनुपर्छ (Valid 10 digit mobile number).';
      }
    }

    if (addressValue.province && !addressValue.district) {
      errs.district = 'कृपया जिल्ला छान्नुहोस् (Please select district).';
    }

    setFormErrors(errs);
    if (Object.keys(errs).length > 0) {
      const firstError = Object.values(errs)[0];
      toast.error(firstError);
      return false;
    }
    return true;
  };

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

  const goToStep = (step: number) => {
    setCurrentStep(step);
    setSearchParams({ step: step.toString() });
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handleSubmit = async (e: React.FormEvent, complete: boolean = false) => {
    e.preventDefault();

    if (!validatePhase1()) {
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
        toast.success('कम्पनी प्रोफाइल सुरक्षित गरियो। अब प्रारम्भिक मौज्दात प्रविष्टि गर्नुहोस्।');
        goToStep(2);
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
    <div className="min-h-screen bg-[#f1f5f9] -m-4 md:-m-6 p-4 md:p-8">
      <div className="max-w-5xl mx-auto">
        {/* Classical Header */}
        <div className="bg-white border border-neutral-300 rounded-lg p-6 shadow-sm mb-6">
          <div className="flex flex-col md:flex-row items-start md:items-center justify-between gap-4 border-b border-neutral-200 pb-5">
            <div>
              <div className="inline-flex items-center gap-2 px-2.5 py-1 rounded bg-amber-50 border border-amber-300 text-amber-900 text-xs font-semibold mb-2">
                <Sparkles className="w-3.5 h-3.5 text-amber-600" />
                <span>प्रारम्भिक सेटअप विजार्ड • Onboarding Guided Setup</span>
              </div>
              <h1 className="text-2xl font-serif font-bold text-neutral-900">
                {currentStep === 1 && 'व्यापार प्रोफाइल तथा संस्थागत विवरण (Phase 1: Business Profile)'}
                {currentStep === 2 && 'प्रारम्भिक मौज्दात तथा खाता सन्तुलन (Phase 2: Opening Balances)'}
                {currentStep === 3 && 'मौज्दात तथा गोदाम व्यवस्थापन (Phase 3: Inventory Quickstart)'}
              </h1>
              <p className="text-sm text-neutral-600 mt-1">
                नेपाल सरकारको नियमानुसार कर विजक (Tax Invoice), भ्याट विवरण, प्रारम्भिक खाता तथा आधिकारिक लेजरका लागि आवश्यक सेटअप।
              </p>
            </div>

            <div className="flex items-center gap-3">
              {profile?.setupCompleted ? (
                <span className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-emerald-50 text-emerald-800 border border-emerald-300 text-xs font-semibold">
                  <CheckCircle2 className="w-4 h-4 text-emerald-600" />
                  सेटअप पूरा भएको (Completed)
                </span>
              ) : (
                <span className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-blue-50 text-blue-800 border border-blue-300 text-xs font-semibold">
                  <Clock className="w-4 h-4 text-blue-600" />
                  सेटअप बाँकी (In Progress)
                </span>
              )}
            </div>
          </div>

          {/* 3-Step Guided Stepper */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-3 pt-5">
            {/* Step 1 Pill */}
            <button
              type="button"
              onClick={() => goToStep(1)}
              className={`flex items-center gap-3 p-3 rounded border text-left transition-colors cursor-pointer ${
                currentStep === 1
                  ? 'border-primary-600 bg-primary-50 shadow-sm'
                  : 'border-neutral-200 bg-white hover:border-neutral-300 hover:bg-neutral-50'
              }`}
            >
              <div
                className={`w-7 h-7 rounded-full text-xs font-bold flex items-center justify-center flex-shrink-0 ${
                  profile?.companyName
                    ? 'bg-emerald-600 text-white'
                    : currentStep === 1
                    ? 'bg-primary-700 text-white'
                    : 'bg-neutral-200 text-neutral-700'
                }`}
              >
                {profile?.companyName ? <Check className="w-4 h-4" /> : '1'}
              </div>
              <div>
                <div className="text-xs font-bold text-neutral-900 flex items-center gap-1">
                  Phase 1: Business Profile
                  {profile?.companyName && (
                    <span className="text-[10px] bg-emerald-100 text-emerald-800 px-1.5 py-0.2 rounded font-normal">
                      सम्पन्न
                    </span>
                  )}
                </div>
                <div className="text-[11px] text-neutral-500">
                  कम्पनी, प्यान/भ्याट, आधिकारिक ठेगाना
                </div>
              </div>
            </button>

            {/* Step 2 Pill */}
            <button
              type="button"
              onClick={() => goToStep(2)}
              className={`flex items-center gap-3 p-3 rounded border text-left transition-colors cursor-pointer ${
                currentStep === 2
                  ? 'border-primary-600 bg-primary-50 shadow-sm'
                  : 'border-neutral-200 bg-white hover:border-neutral-300 hover:bg-neutral-50'
              }`}
            >
              <div
                className={`w-7 h-7 rounded-full text-xs font-bold flex items-center justify-center flex-shrink-0 ${
                  openingBalance?.posted
                    ? 'bg-emerald-600 text-white'
                    : currentStep === 2
                    ? 'bg-primary-700 text-white'
                    : 'bg-neutral-200 text-neutral-700'
                }`}
              >
                {openingBalance?.posted ? <Check className="w-4 h-4" /> : '2'}
              </div>
              <div>
                <div className="text-xs font-bold text-neutral-900 flex items-center gap-1">
                  Phase 2: Opening Balances
                  {openingBalance?.posted && (
                    <span className="text-[10px] bg-emerald-100 text-emerald-800 px-1.5 py-0.2 rounded font-normal">
                      दर्ता भयो
                    </span>
                  )}
                </div>
                <div className="text-[11px] text-neutral-500">
                  प्रारम्भिक मौज्दात र लेजर सन्तुलन
                </div>
              </div>
            </button>

            {/* Step 3 Pill */}
            <button
              type="button"
              onClick={() => goToStep(3)}
              className={`flex items-center gap-3 p-3 rounded border text-left transition-colors cursor-pointer ${
                currentStep === 3
                  ? 'border-primary-600 bg-primary-50 shadow-sm'
                  : 'border-neutral-200 bg-white hover:border-neutral-300 hover:bg-neutral-50'
              }`}
            >
              <div
                className={`w-7 h-7 rounded-full text-xs font-bold flex items-center justify-center flex-shrink-0 ${
                  currentStep === 3
                    ? 'bg-primary-700 text-white'
                    : 'bg-neutral-200 text-neutral-700'
                }`}
              >
                3
              </div>
              <div>
                <div className="text-xs font-bold text-neutral-900 flex items-center gap-1">
                  Phase 3: Inventory Quickstart
                </div>
                <div className="text-[11px] text-neutral-500">
                  गोदाम (Warehouse) र सुरुआती सामान
                </div>
              </div>
            </button>
          </div>
        </div>

      {/* PHASE 1: Business Profile Form */}
      {currentStep === 1 && (
        <form onSubmit={(e) => handleSubmit(e, false)} className="space-y-6 pb-20">
          {/* Top Quick-Action Bar for Phase 1 */}
          <div className="bg-white border-2 border-primary-200 rounded-lg p-4 shadow-sm flex flex-col sm:flex-row items-center justify-between gap-3">
            <div className="flex items-center gap-2 text-xs text-neutral-800">
              <span className="w-2.5 h-2.5 rounded-full bg-primary-600 animate-pulse flex-shrink-0" />
              <span>
                <strong>चरण १: व्यापार प्रोफाइल</strong> — विवरण भरेपछि अगाडि बढ्न <strong>"अर्को चरण"</strong> बटन थिच्नुहोस्।
              </span>
            </div>
            <div className="flex flex-wrap items-center gap-2.5 w-full sm:w-auto">
              <button
                type="button"
                onClick={() => goToStep(2)}
                className="inline-flex items-center gap-1.5 px-3.5 py-2 text-xs font-semibold text-neutral-700 bg-neutral-100 hover:bg-neutral-200 rounded border border-neutral-300 transition-colors shadow-sm whitespace-nowrap"
              >
                <span>छोड्नुहोस् ➔ चरण २ (Skip to Step 2)</span>
                <ArrowRight className="w-3.5 h-3.5" />
              </button>
              <button
                type="submit"
                disabled={updateMutation.isPending}
                className="flex-1 sm:flex-none inline-flex items-center justify-center gap-2 px-5 py-2 text-xs font-bold text-white bg-primary-700 hover:bg-primary-800 active:bg-primary-900 rounded shadow transition-colors disabled:opacity-50 whitespace-nowrap"
              >
                <span>अर्को चरण: मौज्दात (Next: Step 2)</span>
                <ArrowRight className="w-4 h-4" />
              </button>
            </div>
          </div>

          {/* SECTION 1: Unit / Company Master Information */}
          <div className="bg-white border border-neutral-300 rounded-lg p-6 shadow-sm">
            <div className="flex items-center gap-2 pb-3 mb-5 border-b border-neutral-200">
              <Building2 className="w-5 h-5 text-primary-600" />
              <h2 className="text-base font-bold font-serif text-neutral-900">
                १. कम्पनी / संस्थाको विवरण (Unit / Business Information)
              </h2>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  Company Name (English) <span className="text-rose-600">*</span>
                </label>
                <input
                  type="text"
                  required
                  value={companyName}
                  onChange={(e) => {
                    setCompanyName(e.target.value);
                    clearError('companyName');
                  }}
                  placeholder="e.g. Acme Nepal Technologies Pvt. Ltd."
                  className={`w-full px-3 py-2 text-sm border rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 font-serif shadow-sm ${
                    formErrors.companyName
                      ? 'border-rose-400 focus:ring-rose-500'
                      : 'border-neutral-300 focus:ring-primary-500'
                  }`}
                />
                {formErrors.companyName && (
                  <p className="text-xs text-rose-600 mt-1 font-medium">{formErrors.companyName}</p>
                )}
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  कम्पनीको नाम (नेपालीमा) / Business Name in Devanagari
                </label>
                <input
                  type="text"
                  value={companyNameNepali}
                  onChange={(e) => setCompanyNameNepali(e.target.value)}
                  placeholder="जस्तै: एक्मी नेपाल टेक्नोलोजिज प्रा. लि."
                  className="w-full px-3 py-2 text-sm border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  Legal / Trade Name (व्यापारिक नाम)
                </label>
                <input
                  type="text"
                  value={legalName}
                  onChange={(e) => setLegalName(e.target.value)}
                  placeholder="Official registered legal entity name"
                  className="w-full px-3 py-2 text-sm border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                />
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="block text-xs font-semibold text-neutral-800 mb-1">
                    Incorporation Type (दर्ता प्रकार)
                  </label>
                  <select
                    value={incorporationType}
                    onChange={(e) => setIncorporationType(e.target.value as IncorporationType)}
                    className="w-full px-3 py-2 text-sm border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                  >
                    <option value="PROPRIETORSHIP">एकलौटी फर्म (Proprietorship)</option>
                    <option value="PARTNERSHIP">साझेदारी फर्म (Partnership)</option>
                    <option value="PRIVATE_LIMITED">प्राइभेट लिमिटेड (Private Ltd.)</option>
                    <option value="PUBLIC_LIMITED">पब्लिक लिमिटेड (Public Ltd.)</option>
                    <option value="COOPERATIVE">सहकारी संस्था (Cooperative)</option>
                    <option value="NGO">गैरसरकारी संस्था (NGO/Non-profit)</option>
                    <option value="GOVERNMENT">सरकारी निकाय (Government Entity)</option>
                    <option value="OTHER">अन्य (Other)</option>
                  </select>
                </div>

                <div>
                  <label className="block text-xs font-semibold text-neutral-800 mb-1">
                    Nature of Business (कारोबारको प्रकृति)
                  </label>
                  <select
                    value={businessNature}
                    onChange={(e) => setBusinessNature(e.target.value as BusinessNature)}
                    className="w-full px-3 py-2 text-sm border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                  >
                    <option value="TRADING">व्यापार (Trading)</option>
                    <option value="MANUFACTURING">उत्पादन (Manufacturing)</option>
                    <option value="SERVICE">सेवामूलक (Service)</option>
                    <option value="RETAIL">खुद्रा बिक्री (Retail)</option>
                    <option value="WHOLESALE">थोक व्यापार (Wholesale)</option>
                    <option value="MIXED">मिश्रित (Mixed)</option>
                    <option value="OTHER">अन्य (Other)</option>
                  </select>
                </div>
              </div>
            </div>
          </div>

          {/* SECTION 2: Tax, Registration & Statutory */}
          <div className="bg-white border border-neutral-300 rounded-lg p-6 shadow-sm">
            <div className="flex items-center gap-2 pb-3 mb-5 border-b border-neutral-200">
              <FileText className="w-5 h-5 text-primary-600" />
              <h2 className="text-base font-bold font-serif text-neutral-900">
                २. कर, प्यान/भ्याट तथा दर्ता विवरण (Tax & Registration Details)
              </h2>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  Registration Authority (दर्ता गर्ने निकाय)
                </label>
                <select
                  value={registrationAuthority}
                  onChange={(e) => setRegistrationAuthority(e.target.value)}
                  className="w-full px-3 py-2 text-sm border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                >
                  <option value="">-- दर्ता गर्ने निकाय छान्नुहोस् (Select Authority) --</option>
                  {Object.entries(authorities).map(([key, val]) => (
                    <option key={key} value={key}>
                      {val.en} ({val.np})
                    </option>
                  ))}
                </select>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="block text-xs font-semibold text-neutral-800 mb-1">
                    Registration No. (दर्ता नं.)
                  </label>
                  <input
                    type="text"
                    value={registrationNo}
                    onChange={(e) => setRegistrationNo(e.target.value)}
                    placeholder="e.g. 123456/080/081"
                    className="w-full px-3 py-2 text-sm font-mono border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                  />
                </div>

                <div>
                  <label className="block text-xs font-semibold text-neutral-800 mb-1">
                    Registration Date (दर्ता मिति)
                  </label>
                  <input
                    type="date"
                    value={registrationDate}
                    onChange={(e) => setRegistrationDate(e.target.value)}
                    className="w-full px-3 py-2 text-sm border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 font-mono shadow-sm"
                  />
                </div>
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  PAN / VAT No. (स्थायी लेखा नं. / भ्याट नं.)
                </label>
                <input
                  type="text"
                  maxLength={9}
                  value={panVatNo}
                  onChange={(e) => {
                    setPanVatNo(e.target.value.replace(/\D/g, ''));
                    clearError('panVatNo');
                  }}
                  placeholder="9-digit PAN (e.g. 601234567)"
                  className={`w-full px-3 py-2 text-sm font-mono font-bold tracking-wider border rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 shadow-sm ${
                    formErrors.panVatNo
                      ? 'border-rose-400 focus:ring-rose-500'
                      : 'border-neutral-300 focus:ring-primary-500'
                  }`}
                />
                {formErrors.panVatNo ? (
                  <p className="text-xs text-rose-600 mt-1 font-medium">{formErrors.panVatNo}</p>
                ) : (
                  <p className="text-[11px] text-neutral-500 mt-1">
                    नेपालको कर कानुन अनुसार ९ अंकको प्यान नम्बर बिल र विजकमा अनिवार्य हुन्छ।
                  </p>
                )}
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  PAN / VAT Registration Date (प्यान दर्ता मिति)
                </label>
                <input
                  type="date"
                  value={panVatDate}
                  onChange={(e) => setPanVatDate(e.target.value)}
                  className="w-full px-3 py-2 text-sm border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 font-mono shadow-sm"
                />
              </div>
            </div>
          </div>

          {/* SECTION 3: Registered Official Address */}
          <div className="bg-white border border-neutral-300 rounded-lg p-6 shadow-sm">
            <div className="flex items-center gap-2 pb-3 mb-5 border-b border-neutral-200">
              <MapPin className="w-5 h-5 text-primary-600" />
              <h2 className="text-base font-bold font-serif text-neutral-900">
                ३. कम्पनीको दर्ता भएको आधिकारिक ठेगाना (Registered Address)
              </h2>
            </div>

            <CascadingAddressSelector
              value={addressValue}
              onChange={(val) => {
                setAddressValue(val);
                clearError('district');
              }}
            />
            {formErrors.district && (
              <p className="text-xs text-rose-600 mt-1 font-medium">{formErrors.district}</p>
            )}

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4 pt-4 border-t border-neutral-200">
              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  Official Phone (कार्यालय फोन नं.)
                </label>
                <input
                  type="text"
                  value={phone}
                  onChange={(e) => {
                    setPhone(e.target.value);
                    clearError('phone');
                  }}
                  placeholder="01-XXXXXXX or 98XXXXXXXX"
                  className={`w-full px-3 py-2 text-sm border rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 font-mono shadow-sm ${
                    formErrors.phone
                      ? 'border-rose-400 focus:ring-rose-500'
                      : 'border-neutral-300 focus:ring-primary-500'
                  }`}
                />
                {formErrors.phone && (
                  <p className="text-xs text-rose-600 mt-1 font-medium">{formErrors.phone}</p>
                )}
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  Official Email (कार्यालय इमेल)
                </label>
                <input
                  type="email"
                  value={email}
                  onChange={(e) => {
                    setEmail(e.target.value);
                    clearError('email');
                  }}
                  placeholder="billing@company.com.np"
                  className={`w-full px-3 py-2 text-sm border rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 shadow-sm ${
                    formErrors.email
                      ? 'border-rose-400 focus:ring-rose-500'
                      : 'border-neutral-300 focus:ring-primary-500'
                  }`}
                />
                {formErrors.email && (
                  <p className="text-xs text-rose-600 mt-1 font-medium">{formErrors.email}</p>
                )}
              </div>
            </div>
          </div>

          {/* SECTION 4: Authorized Signatory */}
          <div className="bg-white border border-neutral-300 rounded-lg p-6 shadow-sm">
            <div className="flex items-center gap-2 pb-3 mb-5 border-b border-neutral-200">
              <UserCheck className="w-5 h-5 text-primary-600" />
              <h2 className="text-base font-bold font-serif text-neutral-900">
                ४. आधिकारिक हस्ताक्षरकर्ता / सम्पर्क व्यक्ति (Authorized Signatory)
              </h2>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  Full Name (पूरा नाम)
                </label>
                <input
                  type="text"
                  value={authorizedPersonName}
                  onChange={(e) => setAuthorizedPersonName(e.target.value)}
                  placeholder="e.g. Ramesh Kumar Shrestha"
                  className="w-full px-3 py-2 text-sm border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  Designation (पद / जिम्मेवारी)
                </label>
                <input
                  type="text"
                  value={authorizedPersonDesignation}
                  onChange={(e) => setAuthorizedPersonDesignation(e.target.value)}
                  placeholder="Managing Director / Proprietor / CEO"
                  className="w-full px-3 py-2 text-sm border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  Mobile Number / मोबाइल नं.
                </label>
                <input
                  type="text"
                  value={authorizedPersonPhone}
                  onChange={(e) => {
                    setAuthorizedPersonPhone(e.target.value);
                    clearError('authorizedPersonPhone');
                  }}
                  placeholder="+977-98XXXXXXXX"
                  className={`w-full px-3 py-2 text-sm border rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 font-mono shadow-sm ${
                    formErrors.authorizedPersonPhone
                      ? 'border-rose-400 focus:ring-rose-500'
                      : 'border-neutral-300 focus:ring-primary-500'
                  }`}
                />
                {formErrors.authorizedPersonPhone && (
                  <p className="text-xs text-rose-600 mt-1 font-medium">{formErrors.authorizedPersonPhone}</p>
                )}
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  Personal / Direct Email (इमेल)
                </label>
                <input
                  type="email"
                  value={authorizedPersonEmail}
                  onChange={(e) => {
                    setAuthorizedPersonEmail(e.target.value);
                    clearError('authorizedPersonEmail');
                  }}
                  placeholder="signatory@company.com.np"
                  className={`w-full px-3 py-2 text-sm border rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 shadow-sm ${
                    formErrors.authorizedPersonEmail
                      ? 'border-rose-400 focus:ring-rose-500'
                      : 'border-neutral-300 focus:ring-primary-500'
                  }`}
                />
                {formErrors.authorizedPersonEmail && (
                  <p className="text-xs text-rose-600 mt-1 font-medium">{formErrors.authorizedPersonEmail}</p>
                )}
              </div>
            </div>
          </div>

          {/* Floating Sticky Action Buttons Bar */}
          <div className="sticky bottom-4 z-30 bg-white/95 backdrop-blur-md border-2 border-primary-600/40 rounded-xl p-4 sm:p-5 shadow-2xl flex flex-col sm:flex-row items-center justify-between gap-4">
            <div className="flex flex-wrap items-center gap-3 w-full sm:w-auto">
              <button
                type="button"
                onClick={() => navigate('/dashboard')}
                className="px-4 py-2.5 text-xs sm:text-sm font-semibold text-neutral-700 hover:text-neutral-900 bg-neutral-100 hover:bg-neutral-200 rounded-lg border border-neutral-300 transition-colors shadow-sm"
              >
                अहिलेलाई छोड्नुहोस् (Exit to Dashboard)
              </button>

              <button
                type="button"
                onClick={() => goToStep(2)}
                className="inline-flex items-center gap-1.5 px-4 py-2.5 text-xs sm:text-sm font-semibold text-neutral-700 bg-neutral-100 hover:bg-neutral-200 rounded-lg border border-neutral-300 transition-colors shadow-sm"
              >
                <span>प्रोफाइल पछि भर्छु ➔ चरण २ (Skip to Step 2)</span>
                <ArrowRight className="w-4 h-4" />
              </button>
            </div>

            <button
              type="submit"
              disabled={updateMutation.isPending}
              className="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-6 sm:px-8 py-3 text-sm sm:text-base font-bold text-white bg-primary-700 hover:bg-primary-800 active:bg-primary-900 rounded-lg shadow-lg transition-transform active:scale-[0.99] disabled:opacity-50"
            >
              {updateMutation.isPending ? (
                <span>सुरक्षित गर्दैछ... (Saving...)</span>
              ) : (
                <>
                  <span>सुरक्षित गरी अर्को चरणमा जानुहोस् (Save & Next: Opening Balances)</span>
                  <ArrowRight className="w-5 h-5" />
                </>
              )}
            </button>
          </div>
        </form>
      )}

      {/* PHASE 2: Opening Balances Step */}
      {currentStep === 2 && (
        <OpeningBalancesStep
          onBack={() => goToStep(1)}
          onContinue={() => goToStep(3)}
        />
      )}

      {/* PHASE 3: Inventory Quickstart Step */}
      {currentStep === 3 && (
        <Phase3InventoryStep
          businessNature={profile?.businessNature || businessNature}
          onBack={() => goToStep(2)}
          onComplete={() => {
            toast.success('🎉 बधाई छ! सम्पूर्ण सेटअप सफलतापूर्वक सम्पन्न भयो।');
            navigate('/dashboard');
          }}
        />
      )}
      </div>
    </div>
  );
};
