import React, { useState } from 'react';
import {
  Building2,
  Plus,
  Search,
  CheckCircle2,
  AlertCircle,
  ShieldCheck,
  UserCheck,
} from 'lucide-react';
import { useTenants, useOnboardTenant, useToggleTenantStatus } from '../../hooks/useAdmin';
import { Dialog } from '../../components/ui/dialog';

export const TenantsPage: React.FC = () => {
  const { data: tenants = [], isLoading } = useTenants();
  const onboardMutation = useOnboardTenant();
  const toggleMutation = useToggleTenantStatus();

  const [search, setSearch] = useState('');
  const [modalOpen, setModalOpen] = useState(false);

  // Form State
  const [companyName, setCompanyName] = useState('');
  const [companyNameNepali, setCompanyNameNepali] = useState('');
  const [tenantCode, setTenantCode] = useState('');
  const [panVatNo, setPanVatNo] = useState('');
  const [phone, setPhone] = useState('');
  const [email, setEmail] = useState('');
  const [address, setAddress] = useState('');
  const [district, setDistrict] = useState('Kathmandu');
  const [province, setProvince] = useState('Bagmati Province');
  const [adminFullName, setAdminFullName] = useState('');
  const [adminUsername, setAdminUsername] = useState('');
  const [adminEmail, setAdminEmail] = useState('');
  const [adminPassword, setAdminPassword] = useState('');

  // Auto-fill tenantCode from companyName if blank
  const handleCompanyNameChange = (val: string) => {
    setCompanyName(val);
    if (!tenantCode || tenantCode === companyName.replace(/[^a-zA-Z0-9]/g, '').toUpperCase().slice(0, 10)) {
      setTenantCode(val.replace(/[^a-zA-Z0-9]/g, '').toUpperCase().slice(0, 10));
    }
  };

  const handleOnboardSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!companyName.trim() || !tenantCode.trim() || !adminUsername.trim() || !adminPassword.trim()) {
      return;
    }

    await onboardMutation.mutateAsync({
      companyName: companyName.trim(),
      companyNameNepali: companyNameNepali.trim() || undefined,
      tenantCode: tenantCode.trim().toUpperCase(),
      panVatNo: panVatNo.trim() || undefined,
      phone: phone.trim() || undefined,
      email: email.trim() || undefined,
      address: address.trim() || undefined,
      district: district.trim() || undefined,
      province: province.trim() || undefined,
      adminFullName: adminFullName.trim() || adminUsername.trim(),
      adminUsername: adminUsername.trim().toLowerCase(),
      adminEmail: adminEmail.trim() || email.trim() || `${adminUsername.trim()}@company.com`,
      adminPassword: adminPassword.trim(),
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

  const filteredTenants = tenants.filter(
    (t) =>
      t.companyName.toLowerCase().includes(search.toLowerCase()) ||
      t.tenantCode.toLowerCase().includes(search.toLowerCase()) ||
      (t.panVatNo && t.panVatNo.includes(search))
  );

  const activeCount = tenants.filter((t) => t.status === 'ACTIVE').length;
  const completedCount = tenants.filter((t) => t.setupCompleted).length;

  return (
    <div className="space-y-6 max-w-7xl mx-auto p-4 md:p-6">
      {/* Header Bar */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white border border-neutral-300 rounded-lg p-6 shadow-sm">
        <div className="flex items-start gap-3">
          <div className="w-12 h-12 rounded-lg bg-primary-50 border border-primary-200 flex items-center justify-center text-primary-700 flex-shrink-0">
            <Building2 className="w-6 h-6" />
          </div>
          <div>
            <div className="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full bg-primary-50 text-primary-800 border border-primary-200 text-xs font-semibold mb-1">
              <span>सुपर एडमिन कन्ट्रोल (Super Admin Control)</span>
            </div>
            <h1 className="text-2xl font-serif font-bold text-neutral-900">
              ग्राहक तथा संस्था अनबोर्डिङ (Tenant Management)
            </h1>
            <p className="text-xs text-neutral-600 mt-1">
              प्रणालीमा नयाँ व्यवसाय वा ग्राहक संस्था दर्ता गर्नुहोस्, सुरुवाती एडमिन खाता बनाउनुहोस् र स्थिति व्यवस्थापन गर्नुहोस्।
            </p>
          </div>
        </div>

        <button
          type="button"
          onClick={() => setModalOpen(true)}
          className="inline-flex items-center justify-center gap-2 px-5 py-2.5 text-sm font-semibold text-white bg-primary-700 hover:bg-primary-800 active:bg-primary-900 rounded-lg shadow-sm transition-colors whitespace-nowrap"
        >
          <Plus className="w-4 h-4" />
          <span>नयाँ ग्राहक / संस्था अनबोर्ड गर्नुहोस् (+ Onboard Tenant)</span>
        </button>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div className="bg-white border border-neutral-200 rounded-lg p-4 shadow-sm flex items-center justify-between">
          <div>
            <p className="text-xs font-semibold text-neutral-500 uppercase tracking-wider">कुल दर्ता संस्था</p>
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
            <p className="text-xs font-semibold text-neutral-500 uppercase tracking-wider">सेटअप पूरा भएका</p>
            <p className="text-2xl font-serif font-bold text-primary-700 mt-1">{completedCount}</p>
          </div>
          <div className="w-10 h-10 rounded-full bg-primary-50 text-primary-700 flex items-center justify-center">
            <ShieldCheck className="w-5 h-5" />
          </div>
        </div>
      </div>

      {/* Filter & Table Card */}
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
                <th className="py-3 px-2 text-center">बीजक</th>
                <th className="py-3 px-3">स्थिति (Status)</th>
                <th className="py-3 px-3 text-right">कार्य</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-neutral-200">
              {isLoading ? (
                <tr>
                  <td colSpan={8} className="py-8 text-center text-neutral-500 font-serif">
                    डेटा लोड हुँदैछ... (Loading Tenants...)
                  </td>
                </tr>
              ) : filteredTenants.length === 0 ? (
                <tr>
                  <td colSpan={8} className="py-8 text-center text-neutral-500 font-serif">
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
                      <div className="text-neutral-700 text-xs">{t.email || '—'}</div>
                      {t.phone && <div className="text-[11px] text-neutral-500 font-mono">{t.phone}</div>}
                    </td>
                    <td className="py-2.5 px-2 text-center font-mono font-semibold">
                      {t.userCount}
                    </td>
                    <td className="py-2.5 px-2 text-center font-mono font-semibold text-primary-700">
                      {t.invoiceCount}
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
                    <td className="py-2.5 px-3 text-right">
                      <button
                        type="button"
                        onClick={() =>
                          toggleMutation.mutate({
                            id: t.id,
                            status: t.status === 'ACTIVE' ? 'SUSPENDED' : 'ACTIVE',
                          })
                        }
                        disabled={toggleMutation.isPending}
                        className={`px-2.5 py-1 text-xs font-semibold rounded border transition-colors ${
                          t.status === 'ACTIVE'
                            ? 'bg-rose-50 hover:bg-rose-100 text-rose-700 border-rose-300'
                            : 'bg-emerald-50 hover:bg-emerald-100 text-emerald-700 border-emerald-300'
                        }`}
                      >
                        {t.status === 'ACTIVE' ? 'निलम्बन (Suspend)' : 'सक्रिय गर्नुहोस् (Activate)'}
                      </button>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Onboard Tenant Modal */}
      <Dialog
        open={modalOpen}
        onClose={() => setModalOpen(false)}
        title="नयाँ ग्राहक / संस्था अनबोर्ड गर्नुहोस् (Onboard New Tenant)"
        description="संस्थाको व्यावसायिक विवरण र पहिलो व्यवस्थापक (Admin) खाता तयार गर्नुहोस्।"
      >
        <form onSubmit={handleOnboardSubmit} className="space-y-4">
          <div className="bg-neutral-50 border border-neutral-200 p-3.5 rounded-lg space-y-3">
            <h3 className="text-xs font-bold uppercase text-neutral-700 tracking-wider flex items-center gap-1.5">
              <Building2 className="w-4 h-4 text-primary-600" />
              <span>१. संस्थागत विवरण (Company Details)</span>
            </h3>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  Company Name (English) <span className="text-rose-600">*</span>
                </label>
                <input
                  type="text"
                  required
                  value={companyName}
                  onChange={(e) => handleCompanyNameChange(e.target.value)}
                  placeholder="e.g. NextGen Innovations Pvt. Ltd."
                  className="w-full px-2.5 py-1.5 text-xs border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  Company Name (नेपाली)
                </label>
                <input
                  type="text"
                  value={companyNameNepali}
                  onChange={(e) => setCompanyNameNepali(e.target.value)}
                  placeholder="उदा: नेक्ट्सजेन इनोभेसन्स प्रा. लि."
                  className="w-full px-2.5 py-1.5 text-xs border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 font-serif shadow-sm"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  Tenant Code (संक्षिप्त संकेत) <span className="text-rose-600">*</span>
                </label>
                <input
                  type="text"
                  required
                  value={tenantCode}
                  onChange={(e) => setTenantCode(e.target.value.toUpperCase())}
                  placeholder="NEXTGEN"
                  className="w-full px-2.5 py-1.5 text-xs font-mono uppercase font-bold border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  PAN / VAT No. (स्थायी लेखा नं.)
                </label>
                <input
                  type="text"
                  maxLength={9}
                  value={panVatNo}
                  onChange={(e) => setPanVatNo(e.target.value.replace(/\D/g, ''))}
                  placeholder="९ अंकको प्यान (e.g. 609823412)"
                  className="w-full px-2.5 py-1.5 text-xs font-mono font-bold border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">फोन नं.</label>
                <input
                  type="text"
                  value={phone}
                  onChange={(e) => setPhone(e.target.value)}
                  placeholder="01-XXXXXXX or 98XXXXXXXX"
                  className="w-full px-2.5 py-1.5 text-xs border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">कार्यालय इमेल</label>
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="contact@company.com"
                  className="w-full px-2.5 py-1.5 text-xs border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">जिल्ला (District)</label>
                <input
                  type="text"
                  value={district}
                  onChange={(e) => setDistrict(e.target.value)}
                  placeholder="Kathmandu"
                  className="w-full px-2.5 py-1.5 text-xs border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">प्रदेश (Province)</label>
                <input
                  type="text"
                  value={province}
                  onChange={(e) => setProvince(e.target.value)}
                  placeholder="Bagmati Province"
                  className="w-full px-2.5 py-1.5 text-xs border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                />
              </div>

              <div className="sm:col-span-2">
                <label className="block text-xs font-semibold text-neutral-800 mb-1">ठेगाना (Office Address)</label>
                <input
                  type="text"
                  value={address}
                  onChange={(e) => setAddress(e.target.value)}
                  placeholder="Putalisadak, Kathmandu"
                  className="w-full px-2.5 py-1.5 text-xs border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                />
              </div>
            </div>
          </div>

          <div className="bg-neutral-50 border border-neutral-200 p-3.5 rounded-lg space-y-3">
            <h3 className="text-xs font-bold uppercase text-neutral-700 tracking-wider flex items-center gap-1.5">
              <UserCheck className="w-4 h-4 text-emerald-600" />
              <span>२. व्यवस्थापक खाता (Admin Credentials)</span>
            </h3>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  व्यवस्थापकको पूरा नाम (Full Name) <span className="text-rose-600">*</span>
                </label>
                <input
                  type="text"
                  required
                  value={adminFullName}
                  onChange={(e) => setAdminFullName(e.target.value)}
                  placeholder="Ramesh Kumar Shrestha"
                  className="w-full px-2.5 py-1.5 text-xs border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
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
                  className="w-full px-2.5 py-1.5 text-xs font-mono border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  Admin Email <span className="text-rose-600">*</span>
                </label>
                <input
                  type="email"
                  required
                  value={adminEmail}
                  onChange={(e) => setAdminEmail(e.target.value)}
                  placeholder="ramesh@company.com"
                  className="w-full px-2.5 py-1.5 text-xs border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  पासवर्ड (Password) <span className="text-rose-600">*</span>
                </label>
                <input
                  type="password"
                  required
                  minLength={6}
                  value={adminPassword}
                  onChange={(e) => setAdminPassword(e.target.value)}
                  placeholder="न्यूनतम ६ अक्षर"
                  className="w-full px-2.5 py-1.5 text-xs border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                />
              </div>
            </div>
          </div>

          <div className="flex items-center justify-end gap-3 pt-3 border-t border-neutral-200">
            <button
              type="button"
              onClick={() => setModalOpen(false)}
              className="px-4 py-2 text-xs font-semibold text-neutral-600 hover:bg-neutral-100 rounded border border-neutral-300 shadow-sm"
            >
              रद्द गर्नुहोस् (Cancel)
            </button>
            <button
              type="submit"
              disabled={onboardMutation.isPending}
              className="px-6 py-2 text-xs font-bold text-white bg-primary-700 hover:bg-primary-800 active:bg-primary-900 rounded shadow-sm disabled:opacity-50"
            >
              {onboardMutation.isPending ? 'दर्ता गर्दैछ...' : 'संस्था दर्ता सम्पन्न गर्नुहोस् (Onboard)'}
            </button>
          </div>
        </form>
      </Dialog>
    </div>
  );
};
