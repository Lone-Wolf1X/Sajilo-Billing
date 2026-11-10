import React, { useState } from 'react';
import {
  Building2,
  Plus,
  Search,
  CheckCircle2,
  AlertCircle,
  ShieldCheck,
  UserCheck,
  Key,
  Clock,
  Mail,
  Phone,
  Sparkles,
  ArrowRight,
  XCircle,
} from 'lucide-react';
import {
  useTenants,
  useOnboardTenant,
  useToggleTenantStatus,
  useDemoLeads,
  useInjectLicense,
  useUpdateDemoLeadStatus,
} from '../../hooks/useAdmin';
import { Dialog } from '../../components/ui/dialog';

export const TenantsPage: React.FC = () => {
  const { data: tenants = [], isLoading } = useTenants();
  const { data: demoLeads = [], isLoading: leadsLoading } = useDemoLeads();
  const onboardMutation = useOnboardTenant();
  const toggleMutation = useToggleTenantStatus();
  const injectLicenseMutation = useInjectLicense();
  const updateLeadStatusMutation = useUpdateDemoLeadStatus();

  const [activeTab, setActiveTab] = useState<'tenants' | 'waiting_list'>('tenants');
  const [search, setSearch] = useState('');
  const [modalOpen, setModalOpen] = useState(false);

  // License Injection Modal State
  const [licenseModalOpen, setLicenseModalOpen] = useState(false);
  const [selectedTenantForLicense, setSelectedTenantForLicense] = useState<{ id: number; name: string; code: string } | null>(null);
  const [injectPlan, setInjectPlan] = useState('GROWTH');
  const [injectDurationDays, setInjectDurationDays] = useState(365);
  const [injectMaxUsers, setInjectMaxUsers] = useState(5);

  // Form State for Onboarding Wizard
  const [companyName, setCompanyName] = useState('');
  const [companyNameNepali, setCompanyNameNepali] = useState('');
  const [tenantCode, setTenantCode] = useState('');
  const [panVatNo, setPanVatNo] = useState('');
  const [phone, setPhone] = useState('');
  const [email, setEmail] = useState('');
  const [address, setAddress] = useState('');
  const [district, setDistrict] = useState('Kathmandu');
  const [province, setProvince] = useState('Bagmati Province');
  const [incorporationType, setIncorporationType] = useState('PRIVATE_LIMITED');
  const [adminFullName, setAdminFullName] = useState('');
  const [adminUsername, setAdminUsername] = useState('');
  const [adminEmail, setAdminEmail] = useState('');
  const [adminPassword, setAdminPassword] = useState('');
  const [licensePlan, setLicensePlan] = useState('GROWTH');
  const [licenseDurationDays, setLicenseDurationDays] = useState(365);

  // Auto-fill tenantCode from companyName if blank
  const handleCompanyNameChange = (val: string) => {
    setCompanyName(val);
    if (!tenantCode || tenantCode === companyName.replace(/[^a-zA-Z0-9]/g, '').toUpperCase().slice(0, 10)) {
      setTenantCode(val.replace(/[^a-zA-Z0-9]/g, '').toUpperCase().slice(0, 10));
    }
  };

  const handleOnboardSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!companyName.trim() || !tenantCode.trim() || !adminUsername.trim() || !adminPassword.trim() || !adminEmail.trim()) {
      return;
    }

    await onboardMutation.mutateAsync({
      companyName: companyName.trim(),
      companyNameNepali: companyNameNepali.trim() || undefined,
      tenantCode: tenantCode.trim().toUpperCase(),
      panVatNo: panVatNo.trim() || undefined,
      phone: phone.trim() || undefined,
      email: email.trim() || adminEmail.trim(),
      address: address.trim() || undefined,
      district: district.trim() || undefined,
      province: province.trim() || undefined,
      adminFullName: adminFullName.trim() || adminUsername.trim(),
      adminUsername: adminUsername.trim().toLowerCase(),
      adminEmail: adminEmail.trim().toLowerCase(),
      adminPassword: adminPassword.trim(),
      licensePlan,
      licenseDurationDays,
    });

    setModalOpen(false);
    // Reset form
    setCompanyName('');
    setCompanyNameNepali('');
    setTenantCode('');
    setPanVatNo('');
    setPhone('');
    setEmail('');
    setAddress('');
    setAdminFullName('');
    setAdminUsername('');
    setAdminEmail('');
    setAdminPassword('');
  };

  const handleOpenInjectLicense = (t: { id: number; companyName: string; tenantCode: string }) => {
    setSelectedTenantForLicense({ id: t.id, name: t.companyName, code: t.tenantCode });
    setLicenseModalOpen(true);
  };

  const handleConfirmInjectLicense = async () => {
    if (!selectedTenantForLicense) return;
    await injectLicenseMutation.mutateAsync({
      id: selectedTenantForLicense.id,
      plan: injectPlan,
      durationDays: injectDurationDays,
      maxUsers: injectMaxUsers,
    });
    setLicenseModalOpen(false);
  };

  const handleApproveLead = (lead: any) => {
    setCompanyName(lead.companyName);
    setTenantCode(lead.companyName.replace(/[^a-zA-Z0-9]/g, '').toUpperCase().slice(0, 8));
    setAdminFullName(lead.fullName);
    setAdminUsername(lead.email.split('@')[0].toLowerCase().replace(/[^a-z0-9]/g, ''));
    setAdminEmail(lead.email);
    setEmail(lead.email);
    setPhone(lead.phone);
    if (lead.city) setDistrict(lead.city);
    setAdminPassword('Admin@12345');
    setLicensePlan('GROWTH');
    setLicenseDurationDays(365);
    setModalOpen(true);
  };

  const filteredTenants = tenants.filter(
    (t) =>
      t.companyName.toLowerCase().includes(search.toLowerCase()) ||
      t.tenantCode.toLowerCase().includes(search.toLowerCase()) ||
      (t.panVatNo && t.panVatNo.includes(search))
  );

  const waitingLeads = demoLeads.filter((l) => l.status === 'WAITING');
  const activeCount = tenants.filter((t) => t.status === 'ACTIVE').length;

  return (
    <div className="space-y-6 max-w-7xl mx-auto p-4 md:p-6">
      {/* Header Bar */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white border border-neutral-300 rounded-lg p-6 shadow-sm">
        <div className="flex items-start gap-3">
          <div className="w-12 h-12 rounded-lg bg-primary-50 border border-primary-200 flex items-center justify-center text-primary-700 flex-shrink-0">
            <Building2 className="w-6 h-6" />
          </div>
          <div>
            <div className="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full bg-purple-50 text-purple-800 border border-purple-200 text-xs font-semibold mb-1">
              <ShieldCheck className="w-3.5 h-3.5 text-purple-700" />
              <span>सुपर एडमिन कन्ट्रोल (Super Admin Platform Operations)</span>
            </div>
            <h1 className="text-2xl font-serif font-bold text-neutral-900">
              ग्राहक संस्था तथा लाइसेन्स व्यवस्थापन (Tenant & License Hub)
            </h1>
            <p className="text-xs text-neutral-600 mt-1">
              नयाँ व्यवसाय अनबोर्ड गर्नुहोस्, डेमो प्रतिक्षा सूची व्यवस्थापन गर्नुहोस्, र लाइसेन्स इन्जेक्ट गर्नुहोस्।
            </p>
          </div>
        </div>

        <button
          type="button"
          onClick={() => setModalOpen(true)}
          className="inline-flex items-center justify-center gap-2 px-5 py-2.5 text-sm font-semibold text-white bg-primary-700 hover:bg-primary-800 active:bg-primary-900 rounded-lg shadow-sm transition-colors whitespace-nowrap"
        >
          <Plus className="w-4 h-4" />
          <span>नयाँ ग्राहक अनबोर्ड गर्नुहोस् (+ Onboard Customer)</span>
        </button>
      </div>

      {/* Navigation Tabs */}
      <div className="flex items-center gap-2 border-b border-neutral-200 pb-2">
        <button
          type="button"
          onClick={() => setActiveTab('tenants')}
          className={`flex items-center gap-2 px-4 py-2 text-xs font-bold rounded-lg transition-colors ${
            activeTab === 'tenants'
              ? 'bg-primary-700 text-white shadow-sm'
              : 'bg-white text-neutral-700 border border-neutral-300 hover:bg-neutral-50'
          }`}
        >
          <Building2 className="w-4 h-4" />
          <span>सक्रिय ग्राहक संस्थाहरू (Active Tenants)</span>
          <span className="ml-1.5 px-2 py-0.2 rounded-full text-[10px] bg-white/20 text-white">
            {tenants.length}
          </span>
        </button>

        <button
          type="button"
          onClick={() => setActiveTab('waiting_list')}
          className={`flex items-center gap-2 px-4 py-2 text-xs font-bold rounded-lg transition-colors ${
            activeTab === 'waiting_list'
              ? 'bg-amber-600 text-white shadow-sm'
              : 'bg-white text-neutral-700 border border-neutral-300 hover:bg-neutral-50'
          }`}
        >
          <Clock className="w-4 h-4" />
          <span>डेमो प्रतिक्षा सूची (Waiting List / Leads)</span>
          {waitingLeads.length > 0 && (
            <span className="ml-1.5 px-2 py-0.5 rounded-full text-[10px] bg-rose-500 text-white font-bold animate-pulse">
              {waitingLeads.length} नयाँ
            </span>
          )}
        </button>
      </div>

      {/* Tab 1: Tenants List View */}
      {activeTab === 'tenants' && (
        <>
          {/* Stats Cards */}
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
            <div className="bg-white border border-neutral-200 rounded-lg p-4 shadow-sm flex items-center justify-between">
              <div>
                <p className="text-xs font-semibold text-neutral-500 uppercase tracking-wider">कुल ग्राहक संस्था</p>
                <p className="text-2xl font-serif font-bold text-neutral-900 mt-1">{tenants.length}</p>
              </div>
              <div className="w-10 h-10 rounded-full bg-blue-50 text-blue-700 flex items-center justify-center">
                <Building2 className="w-5 h-5" />
              </div>
            </div>

            <div className="bg-white border border-neutral-200 rounded-lg p-4 shadow-sm flex items-center justify-between">
              <div>
                <p className="text-xs font-semibold text-neutral-500 uppercase tracking-wider">सञ्चालनमा रहेका (Active)</p>
                <p className="text-2xl font-serif font-bold text-emerald-700 mt-1">{activeCount}</p>
              </div>
              <div className="w-10 h-10 rounded-full bg-emerald-50 text-emerald-700 flex items-center justify-center">
                <CheckCircle2 className="w-5 h-5" />
              </div>
            </div>

            <div className="bg-white border border-neutral-200 rounded-lg p-4 shadow-sm flex items-center justify-between">
              <div>
                <p className="text-xs font-semibold text-neutral-500 uppercase tracking-wider">प्रतिक्षा सूची (Demo Leads)</p>
                <p className="text-2xl font-serif font-bold text-amber-700 mt-1">{waitingLeads.length}</p>
              </div>
              <div className="w-10 h-10 rounded-full bg-amber-50 text-amber-700 flex items-center justify-center">
                <Clock className="w-5 h-5" />
              </div>
            </div>
          </div>

          {/* Tenants Table Card */}
          <div className="bg-white border border-neutral-300 rounded-lg p-6 shadow-sm space-y-4">
            <div className="flex flex-col sm:flex-row items-center justify-between gap-3 pb-3 border-b border-neutral-200">
              <div className="relative w-full sm:w-80">
                <Search className="w-4 h-4 text-neutral-400 absolute left-3 top-1/2 -translate-y-1/2" />
                <input
                  type="text"
                  value={search}
                  onChange={(e) => setSearch(e.target.value)}
                  placeholder="नाम, Tenant Code वा PAN खोज्नुहोस्..."
                  className="w-full pl-9 pr-3 py-1.5 text-xs border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                />
              </div>
              <div className="text-xs text-neutral-500 font-mono">
                जम्मा: {filteredTenants.length} वटा संस्था भेटियो
              </div>
            </div>

            {/* Table */}
            <div className="overflow-x-auto border border-neutral-200 rounded-lg">
              <table className="w-full text-left text-xs">
                <thead className="bg-neutral-50 text-neutral-700 font-semibold border-b border-neutral-200 uppercase tracking-wider text-[11px]">
                  <tr>
                    <th className="py-3 px-3">संकेत (Code)</th>
                    <th className="py-3 px-3 min-w-[200px]">कम्पनी / संस्थाको नाम</th>
                    <th className="py-3 px-3">PAN / VAT नं.</th>
                    <th className="py-3 px-3">सम्पर्क (Email / Phone)</th>
                    <th className="py-3 px-2 text-center">प्रयोगकर्ता</th>
                    <th className="py-3 px-3">स्थिति (Status)</th>
                    <th className="py-3 px-3 text-right">कार्य (Actions)</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-neutral-200">
                  {isLoading ? (
                    <tr>
                      <td colSpan={7} className="py-8 text-center text-neutral-500 font-serif">
                        डेटा लोड हुँदैछ... (Loading Tenants...)
                      </td>
                    </tr>
                  ) : filteredTenants.length === 0 ? (
                    <tr>
                      <td colSpan={7} className="py-8 text-center text-neutral-500 font-serif">
                        कुनै संस्था फेला परेन।
                      </td>
                    </tr>
                  ) : (
                    filteredTenants.map((t) => (
                      <tr key={t.id} className="hover:bg-neutral-50/50">
                        <td className="py-2.5 px-3">
                          <span className="font-mono font-bold text-xs bg-neutral-100 px-2 py-0.5 rounded text-neutral-800 border border-neutral-300">
                            {t.tenantCode}
                          </span>
                        </td>
                        <td className="py-2.5 px-3">
                          <div className="font-bold text-neutral-900 font-serif text-sm">{t.companyName}</div>
                          {t.companyNameNepali && (
                            <div className="text-[11px] text-neutral-500 font-serif">{t.companyNameNepali}</div>
                          )}
                        </td>
                        <td className="py-2.5 px-3 font-mono font-bold text-neutral-800">
                          {t.panVatNo ? t.panVatNo : <span className="text-neutral-400">—</span>}
                        </td>
                        <td className="py-2.5 px-3">
                          <div className="text-neutral-700 text-xs flex items-center gap-1">
                            <Mail className="w-3 h-3 text-neutral-400" />
                            <span>{t.email || '—'}</span>
                          </div>
                          {t.phone && (
                            <div className="text-[11px] text-neutral-500 font-mono flex items-center gap-1 mt-0.5">
                              <Phone className="w-3 h-3 text-neutral-400" />
                              <span>{t.phone}</span>
                            </div>
                          )}
                        </td>
                        <td className="py-2.5 px-2 text-center font-mono font-semibold">
                          {t.userCount}
                        </td>
                        <td className="py-2.5 px-3">
                          {t.status === 'ACTIVE' ? (
                            <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[11px] font-semibold bg-emerald-50 text-emerald-800 border border-emerald-200">
                              <CheckCircle2 className="w-3 h-3 text-emerald-600" />
                              सञ्चालनमा (Active)
                            </span>
                          ) : (
                            <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[11px] font-semibold bg-rose-50 text-rose-800 border border-rose-200">
                              <AlertCircle className="w-3 h-3 text-rose-600" />
                              निलम्बित (Suspended)
                            </span>
                          )}
                        </td>
                        <td className="py-2.5 px-3 text-right space-x-1.5 whitespace-nowrap">
                          {/* Inject / Upgrade License Button */}
                          <button
                            type="button"
                            onClick={() => handleOpenInjectLicense(t)}
                            className="inline-flex items-center gap-1 px-2.5 py-1 text-xs font-semibold text-purple-700 bg-purple-50 hover:bg-purple-100 rounded border border-purple-300 transition-colors"
                            title="लाइसेन्स इन्जेक्ट गर्नुहोस् / म्याद थप्नुहोस्"
                          >
                            <Key className="w-3 h-3 text-purple-700" />
                            <span>लाइसेन्स थप्नुहोस् (Inject)</span>
                          </button>

                          {/* Toggle Active / Suspended Button */}
                          <button
                            type="button"
                            onClick={() =>
                              toggleMutation.mutate({
                                id: t.id,
                                status: t.status === 'ACTIVE' ? 'SUSPENDED' : 'ACTIVE',
                              })
                            }
                            className={`px-2.5 py-1 text-xs font-semibold rounded border transition-colors ${
                              t.status === 'ACTIVE'
                                ? 'text-rose-700 bg-rose-50 hover:bg-rose-100 border-rose-200'
                                : 'text-emerald-700 bg-emerald-50 hover:bg-emerald-100 border-emerald-200'
                            }`}
                          >
                            {t.status === 'ACTIVE' ? 'निलम्बन गर्नुहोस्' : 'सक्रिय बनाउनुहोस्'}
                          </button>
                        </td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
            </div>
          </div>
        </>
      )}

      {/* Tab 2: Waiting List / Demo Leads View */}
      {activeTab === 'waiting_list' && (
        <div className="bg-white border border-neutral-300 rounded-lg p-6 shadow-sm space-y-4">
          <div className="flex items-center justify-between pb-3 border-b border-neutral-200">
            <div>
              <h2 className="text-lg font-serif font-bold text-neutral-900 flex items-center gap-2">
                <Clock className="w-5 h-5 text-amber-600" />
                <span>वेबसाइटबाट डेमो डाउनलोड गरेका ग्राहकहरूको सूची (Demo Leads Waiting List)</span>
              </h2>
              <p className="text-xs text-neutral-600 mt-1">
                वेबसाइटमा दर्ता भई डेमो एप डाउनलोड गरेका ग्राहकहरू यहाँ देखिन्छन्। प्रत्यक्ष कुराकानी गरी यहाँबाट एक-क्लिकमै पूर्ण लाइसेन्ससहित अनबोर्ड गर्नुहोस्।
              </p>
            </div>
            <div className="text-xs font-mono font-bold text-neutral-600">
              कुल अनुरोध: {demoLeads.length}
            </div>
          </div>

          <div className="overflow-x-auto border border-neutral-200 rounded-lg">
            <table className="w-full text-left text-xs">
              <thead className="bg-neutral-50 text-neutral-700 font-semibold border-b border-neutral-200 uppercase tracking-wider text-[11px]">
                <tr>
                  <th className="py-3 px-3">ग्राहकको नाम (Lead)</th>
                  <th className="py-3 px-3">पसल / कम्पनीको नाम</th>
                  <th className="py-3 px-3">सम्पर्क (Email / Phone)</th>
                  <th className="py-3 px-3">ठेगाना / शहर</th>
                  <th className="py-3 px-3">अनुरोध स्थिति</th>
                  <th className="py-3 px-3 text-right">कार्य (Onboard Action)</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-neutral-200">
                {leadsLoading ? (
                  <tr>
                    <td colSpan={6} className="py-8 text-center text-neutral-500 font-serif">
                      डेमो अनुरोधहरू लोड हुँदैछन्...
                    </td>
                  </tr>
                ) : demoLeads.length === 0 ? (
                  <tr>
                    <td colSpan={6} className="py-8 text-center text-neutral-500 font-serif">
                      अहिले कुनै पनि नयाँ डेमो अनुरोध प्रतिक्षामा छैन।
                    </td>
                  </tr>
                ) : (
                  demoLeads.map((lead) => (
                    <tr key={lead.id} className="hover:bg-neutral-50/50">
                      <td className="py-2.5 px-3">
                        <div className="font-bold text-neutral-900 font-serif">{lead.fullName}</div>
                        <div className="text-[10px] text-neutral-400 font-mono">
                          {new Date(lead.createdAt).toLocaleDateString()}
                        </div>
                      </td>
                      <td className="py-2.5 px-3 font-semibold text-neutral-800">
                        {lead.companyName}
                      </td>
                      <td className="py-2.5 px-3">
                        <div className="text-neutral-700 font-mono text-xs">{lead.email}</div>
                        <div className="text-neutral-500 font-mono text-[11px]">{lead.phone}</div>
                      </td>
                      <td className="py-2.5 px-3 text-neutral-600">
                        {lead.city || '—'}
                      </td>
                      <td className="py-2.5 px-3">
                        {lead.status === 'WAITING' ? (
                          <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] font-bold bg-amber-50 text-amber-800 border border-amber-300">
                            <Clock className="w-3 h-3 text-amber-600" />
                            प्रतिक्षामा (Waiting)
                          </span>
                        ) : lead.status === 'APPROVED_ONBOARDED' ? (
                          <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] font-bold bg-emerald-50 text-emerald-800 border border-emerald-300">
                            <CheckCircle2 className="w-3 h-3 text-emerald-600" />
                            अनबोर्ड भइसकेको (Onboarded)
                          </span>
                        ) : (
                          <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] font-bold bg-neutral-100 text-neutral-700 border border-neutral-300">
                            {lead.status}
                          </span>
                        )}
                      </td>
                      <td className="py-2.5 px-3 text-right space-x-2">
                        {lead.status === 'WAITING' && (
                          <>
                            <button
                              type="button"
                              onClick={() => handleApproveLead(lead)}
                              className="inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-bold text-white bg-primary-700 hover:bg-primary-800 rounded shadow-xs transition-colors"
                            >
                              <Sparkles className="w-3.5 h-3.5 text-amber-300" />
                              <span>लाइसेन्स दिनुहोस् र अनबोर्ड गर्नुहोस्</span>
                              <ArrowRight className="w-3 h-3" />
                            </button>
                            <button
                              type="button"
                              onClick={() => updateLeadStatusMutation.mutate({ id: lead.id, status: 'REJECTED' })}
                              className="inline-flex items-center gap-1 px-2.5 py-1.5 text-xs font-semibold text-rose-700 bg-rose-50 hover:bg-rose-100 rounded border border-rose-200 transition-colors"
                              title="अस्वीकार गर्नुहोस्"
                            >
                              <XCircle className="w-3.5 h-3.5" />
                              <span>हटाउनुहोस्</span>
                            </button>
                          </>
                        )}
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* ========================================================================= */}
      {/* 1. FULL CONTENT 3-COLUMN ONBOARDING WIZARD DIALOG                         */}
      {/* ========================================================================= */}
      <Dialog
        open={modalOpen}
        onClose={() => setModalOpen(false)}
        title="कम्पनी अनबोर्डिङ तथा लाइसेन्स विन्डोज (Company Onboarding Wizard)"
        description="३-स्तम्भ लेआउट: कम्पनी प्रोफाइल, ठेगाना, र अनिवार्य इमेलसहित सुरुवाती लाइसेन्स बाँध्न फारम भर्नुहोस्।"
        className="max-w-6xl w-full max-h-[92vh] overflow-y-auto"
      >
        <form onSubmit={handleOnboardSubmit} className="space-y-6">
          {/* 3-Column Grid Layout */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {/* COLUMN 1: संस्थागत विवरण (Company Details) */}
            <div className="bg-neutral-50/80 border border-neutral-200 p-4 rounded-xl space-y-3.5">
              <h3 className="text-xs font-bold uppercase text-primary-800 tracking-wider flex items-center gap-1.5 pb-2 border-b border-neutral-200">
                <Building2 className="w-4 h-4 text-primary-600" />
                <span>१. संस्थागत विवरण (Company Identity)</span>
              </h3>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  कम्पनीको नाम (English) <span className="text-rose-600">*</span>
                </label>
                <input
                  type="text"
                  required
                  value={companyName}
                  onChange={(e) => handleCompanyNameChange(e.target.value)}
                  placeholder="e.g. NextGen Innovations Pvt. Ltd."
                  className="w-full px-3 py-2 text-xs border border-neutral-300 rounded-md bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-xs"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  कम्पनीको नाम (नेपाली)
                </label>
                <input
                  type="text"
                  value={companyNameNepali}
                  onChange={(e) => setCompanyNameNepali(e.target.value)}
                  placeholder="उदा: नेक्ट्सजेन इनोभेसन्स प्रा. लि."
                  className="w-full px-3 py-2 text-xs border border-neutral-300 rounded-md bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 font-serif shadow-xs"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  संक्षिप्त संकेत (Tenant Code) <span className="text-rose-600">*</span>
                </label>
                <input
                  type="text"
                  required
                  value={tenantCode}
                  onChange={(e) => setTenantCode(e.target.value.toUpperCase())}
                  placeholder="NEXTGEN"
                  className="w-full px-3 py-2 text-xs font-mono uppercase font-bold border border-neutral-300 rounded-md bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-xs"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  कम्पनी प्रकार (Incorporation Type)
                </label>
                <select
                  value={incorporationType}
                  onChange={(e) => setIncorporationType(e.target.value)}
                  className="w-full px-3 py-2 text-xs border border-neutral-300 rounded-md bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-xs"
                >
                  <option value="PRIVATE_LIMITED">प्राइभेट लिमिटेड (Private Limited)</option>
                  <option value="PROPRIETORSHIP">एकल स्वामित्व (Proprietorship)</option>
                  <option value="PARTNERSHIP">साझेदारी (Partnership)</option>
                  <option value="PUBLIC_LIMITED">पब्लिक लिमिटेड (Public Limited)</option>
                </select>
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  PAN / VAT नं. (स्थायी लेखा नं.)
                </label>
                <input
                  type="text"
                  maxLength={9}
                  value={panVatNo}
                  onChange={(e) => setPanVatNo(e.target.value.replace(/\D/g, ''))}
                  placeholder="९ अंकको प्यान (e.g. 609823412)"
                  className="w-full px-3 py-2 text-xs font-mono font-bold border border-neutral-300 rounded-md bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-xs"
                />
              </div>
            </div>

            {/* COLUMN 2: स्थान तथा सम्पर्क (Location & Address) */}
            <div className="bg-neutral-50/80 border border-neutral-200 p-4 rounded-xl space-y-3.5">
              <h3 className="text-xs font-bold uppercase text-primary-800 tracking-wider flex items-center gap-1.5 pb-2 border-b border-neutral-200">
                <Building2 className="w-4 h-4 text-primary-600" />
                <span>२. स्थान तथा सम्पर्क (Location & Contact)</span>
              </h3>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  सम्पर्क फोन / मोबाइल नं.
                </label>
                <input
                  type="text"
                  value={phone}
                  onChange={(e) => setPhone(e.target.value)}
                  placeholder="98XXXXXXXX / 01-XXXXXXX"
                  className="w-full px-3 py-2 text-xs border border-neutral-300 rounded-md bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-xs"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  प्रदेश (Province)
                </label>
                <select
                  value={province}
                  onChange={(e) => setProvince(e.target.value)}
                  className="w-full px-3 py-2 text-xs border border-neutral-300 rounded-md bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-xs"
                >
                  <option value="Bagmati Province">बागमती प्रदेश (Bagmati Province)</option>
                  <option value="Koshi Province">कोशी प्रदेश (Koshi Province)</option>
                  <option value="Madhesh Province">मधेश प्रदेश (Madhesh Province)</option>
                  <option value="Gandaki Province">गण्डकी प्रदेश (Gandaki Province)</option>
                  <option value="Lumbini Province">लुम्बिनी प्रदेश (Lumbini Province)</option>
                  <option value="Karnali Province">कर्णाली प्रदेश (Karnali Province)</option>
                  <option value="Sudurpashchim Province">सुदूरपश्चिम प्रदेश (Sudurpashchim Province)</option>
                </select>
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  जिल्ला (District)
                </label>
                <input
                  type="text"
                  value={district}
                  onChange={(e) => setDistrict(e.target.value)}
                  placeholder="Kathmandu"
                  className="w-full px-3 py-2 text-xs border border-neutral-300 rounded-md bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-xs"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  कार्यालय ठेगाना (Office Street / Tole)
                </label>
                <input
                  type="text"
                  value={address}
                  onChange={(e) => setAddress(e.target.value)}
                  placeholder="Putalisadak, Ward-28"
                  className="w-full px-3 py-2 text-xs border border-neutral-300 rounded-md bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-xs"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  कार्यालयको आधिकारिक इमेल
                </label>
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="info@company.com.np"
                  className="w-full px-3 py-2 text-xs border border-neutral-300 rounded-md bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-xs"
                />
              </div>
            </div>

            {/* COLUMN 3: व्यवस्थापक तथा लाइसेन्स (Admin User & License) */}
            <div className="bg-neutral-50/80 border border-neutral-200 p-4 rounded-xl space-y-3.5">
              <h3 className="text-xs font-bold uppercase text-emerald-800 tracking-wider flex items-center gap-1.5 pb-2 border-b border-neutral-200">
                <UserCheck className="w-4 h-4 text-emerald-600" />
                <span>३. व्यवस्थापक र लाइसेन्स (Admin & License)</span>
              </h3>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  व्यवस्थापकको नाम (Full Name) <span className="text-rose-600">*</span>
                </label>
                <input
                  type="text"
                  required
                  value={adminFullName}
                  onChange={(e) => setAdminFullName(e.target.value)}
                  placeholder="Ramesh Kumar Shrestha"
                  className="w-full px-3 py-2 text-xs border border-neutral-300 rounded-md bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-xs"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  Username (लगइन युजरनेम) <span className="text-rose-600">*</span>
                </label>
                <input
                  type="text"
                  required
                  value={adminUsername}
                  onChange={(e) => setAdminUsername(e.target.value.toLowerCase())}
                  placeholder="admin.ramesh"
                  className="w-full px-3 py-2 text-xs font-mono border border-neutral-300 rounded-md bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-xs"
                />
              </div>

              {/* STRICTLY MANDATORY ADMIN EMAIL */}
              <div>
                <label className="block text-xs font-bold text-neutral-900 mb-1">
                  Admin Email (अनिवार्य) <span className="text-rose-600">*</span>
                </label>
                <input
                  type="email"
                  required
                  value={adminEmail}
                  onChange={(e) => setAdminEmail(e.target.value)}
                  placeholder="ramesh@company.com"
                  className="w-full px-3 py-2 text-xs font-semibold border-2 border-primary-500 rounded-md bg-white text-neutral-900 focus:outline-none focus:ring-2 focus:ring-primary-500 shadow-xs"
                />
                <p className="text-[10px] text-primary-700 font-semibold mt-1">
                  अनबोर्डिङ लिंक र लगइन विवरण यसै इमेलमा पठाइनेछ।
                </p>
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  सुरुवाती पासवर्ड (Password) <span className="text-rose-600">*</span>
                </label>
                <input
                  type="password"
                  required
                  minLength={6}
                  value={adminPassword}
                  onChange={(e) => setAdminPassword(e.target.value)}
                  placeholder="न्यूनतम ६ अक्षर"
                  className="w-full px-3 py-2 text-xs border border-neutral-300 rounded-md bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-xs"
                />
              </div>

              {/* LICENSE PLAN BINDING */}
              <div className="pt-2 border-t border-neutral-200">
                <label className="block text-xs font-bold text-purple-900 mb-1 flex items-center gap-1">
                  <Key className="w-3.5 h-3.5 text-purple-700" />
                  <span>प्रारम्भिक लाइसेन्स योजना (Initial License Plan)</span>
                </label>
                <select
                  value={licensePlan}
                  onChange={(e) => {
                    const p = e.target.value;
                    setLicensePlan(p);
                    setLicenseDurationDays(p === 'TRIAL' ? 30 : 365);
                  }}
                  className="w-full px-3 py-2 text-xs font-bold border-2 border-purple-400 rounded-md bg-purple-50 text-purple-950 focus:outline-none focus:ring-2 focus:ring-purple-500 shadow-xs"
                >
                  <option value="TRIAL">TRIAL — ३० दिनको निःशुल्क ट्रायल (30 Days)</option>
                  <option value="STARTER">STARTER — १ वर्ष (Single User / १ प्रयोगकर्ता)</option>
                  <option value="GROWTH">GROWTH — १ वर्ष (५ प्रयोगकर्ता / Full Multi-User)</option>
                  <option value="ENTERPRISE">ENTERPRISE — १ वर्ष (Unlimited / सम्पुर्ण सुविधाहरू)</option>
                </select>
                <div className="text-[10px] text-purple-700 font-mono mt-1">
                  म्याद: {licenseDurationDays} दिन (अटो-एक्टिभेटेड)
                </div>
              </div>
            </div>
          </div>

          {/* Action Buttons */}
          <div className="flex items-center justify-end gap-3 pt-4 border-t border-neutral-200">
            <button
              type="button"
              onClick={() => setModalOpen(false)}
              className="px-5 py-2 text-xs font-semibold text-neutral-600 hover:bg-neutral-100 rounded border border-neutral-300 shadow-xs"
            >
              रद्द गर्नुहोस् (Cancel)
            </button>
            <button
              type="submit"
              disabled={onboardMutation.isPending}
              className="px-7 py-2.5 text-xs font-bold text-white bg-primary-700 hover:bg-primary-800 active:bg-primary-900 rounded-lg shadow-sm disabled:opacity-50 flex items-center gap-2"
            >
              <CheckCircle2 className="w-4 h-4 text-emerald-300" />
              <span>{onboardMutation.isPending ? 'दर्ता गर्दैछ...' : 'संस्था दर्ता तथा लाइसेन्स सक्रिय गर्नुहोस् (Complete Onboarding)'}</span>
            </button>
          </div>
        </form>
      </Dialog>

      {/* ========================================================================= */}
      {/* 2. INJECT / UPGRADE LICENSE DIALOG                                         */}
      {/* ========================================================================= */}
      <Dialog
        open={licenseModalOpen}
        onClose={() => setLicenseModalOpen(false)}
        title="ग्राहक प्रोफाइलमा नयाँ लाइसेन्स इन्जेक्ट गर्नुहोस् (Inject Cryptographic License)"
        description="यो लाइसेन्स डिजिटल रूपमा साईन भई ग्राहकको खातामा इन्जेक्ट हुन्छ। ग्राहकले डेस्कटप एप पुन: खोल्दा (Restart) यो तुरुन्तै प्रभावकारी हुनेछ।"
      >
        <div className="space-y-4">
          <div className="bg-purple-50 border border-purple-200 p-3.5 rounded-lg">
            <div className="text-xs text-purple-800 font-semibold">लक्ष्य संस्था (Target Tenant):</div>
            <div className="text-sm font-bold text-purple-950 font-serif mt-0.5">
              {selectedTenantForLicense?.name} ({selectedTenantForLicense?.code})
            </div>
          </div>

          <div>
            <label className="block text-xs font-bold text-neutral-800 mb-1">
              लाइसेन्स योजना (Plan Tier)
            </label>
            <select
              value={injectPlan}
              onChange={(e) => setInjectPlan(e.target.value)}
              className="w-full px-3 py-2 text-xs font-bold border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-purple-500 shadow-xs"
            >
              <option value="GROWTH">GROWTH — व्यवसायिक योजना (५ युजर, पूर्ण मोड्युल)</option>
              <option value="ENTERPRISE">ENTERPRISE — कर्पोरेट योजना (असीमित युजर, अडिट ट्रेल)</option>
              <option value="STARTER">STARTER — प्रारम्भिक योजना (१ युजर, बिलिङ)</option>
              <option value="TRIAL">TRIAL — परीक्षण योजना (३० दिन)</option>
            </select>
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className="block text-xs font-bold text-neutral-800 mb-1">
                लाइसेन्सको म्याद (Days)
              </label>
              <select
                value={injectDurationDays}
                onChange={(e) => setInjectDurationDays(Number(e.target.value))}
                className="w-full px-3 py-2 text-xs border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-purple-500 shadow-xs"
              >
                <option value={30}>३० दिन (1 Month)</option>
                <option value={90}>९० दिन (3 Months)</option>
                <option value={180}>१८० दिन (6 Months)</option>
                <option value={365}>३६५ दिन (1 Year)</option>
                <option value={730}>७३० दिन (2 Years)</option>
              </select>
            </div>

            <div>
              <label className="block text-xs font-bold text-neutral-800 mb-1">
                अधिकतम प्रयोगकर्ता (Max Users)
              </label>
              <input
                type="number"
                min={1}
                max={100}
                value={injectMaxUsers}
                onChange={(e) => setInjectMaxUsers(Number(e.target.value))}
                className="w-full px-3 py-2 text-xs font-mono font-bold border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-purple-500 shadow-xs"
              />
            </div>
          </div>

          <div className="p-3 bg-neutral-100 rounded text-[11px] text-neutral-600 border border-neutral-200">
            ℹ️ <span className="font-semibold">नोट:</span> यो प्रक्रियाले तत्काल RSA-2048 डिजिटल हस्ताक्षर सिर्जना गरी डाटाबेसमा सुरक्षित गर्छ। ग्राहकले आफ्नो विन्डोज/म्याक एप बन्द गरी पुनः खोल्दा नयाँ लाइसेन्स स्वतः लागू हुनेछ।
          </div>

          <div className="flex items-center justify-end gap-3 pt-3 border-t border-neutral-200">
            <button
              type="button"
              onClick={() => setLicenseModalOpen(false)}
              className="px-4 py-2 text-xs font-semibold text-neutral-600 hover:bg-neutral-100 rounded border border-neutral-300"
            >
              रद्द गर्नुहोस्
            </button>
            <button
              type="button"
              disabled={injectLicenseMutation.isPending}
              onClick={handleConfirmInjectLicense}
              className="px-5 py-2 text-xs font-bold text-white bg-purple-700 hover:bg-purple-800 rounded shadow-xs flex items-center gap-1.5 disabled:opacity-50"
            >
              <Key className="w-3.5 h-3.5 text-purple-200" />
              <span>{injectLicenseMutation.isPending ? 'इन्जेक्ट गर्दैछ...' : 'लाइसेन्स सक्रिय गर्नुहोस् (Inject License)'}</span>
            </button>
          </div>
        </div>
      </Dialog>
    </div>
  );
};
