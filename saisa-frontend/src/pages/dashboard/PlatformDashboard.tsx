import React from 'react';
import { Link } from 'react-router-dom';
import {
  Building2,
  Users,
  Key,
  Clock,
  ShieldCheck,
  Plus,
  ArrowRight,
  Server,
  Mail,
  CheckCircle2,
  Sparkles,
  Activity,
  FileText,
} from 'lucide-react';
import { useTenants, useDemoLeads } from '../../hooks/useAdmin';
import { useAuth } from '../../hooks/useAuth';

export const PlatformDashboard: React.FC = () => {
  const { user } = useAuth();
  const { data: tenants = [], isLoading: tenantsLoading } = useTenants();
  const { data: demoLeads = [], isLoading: leadsLoading } = useDemoLeads();

  const activeTenants = tenants.filter((t) => t.status === 'ACTIVE');
  const suspendedTenants = tenants.filter((t) => t.status !== 'ACTIVE');
  const waitingLeads = demoLeads.filter((l) => l.status === 'WAITING');

  return (
    <div className="space-y-6 max-w-7xl mx-auto p-4 md:p-6">
      {/* Header Banner */}
      <div className="bg-gradient-to-r from-[#14263d] via-[#1e3a5f] to-[#2a4d75] text-white rounded-xl p-6 md:p-8 shadow-md relative overflow-hidden">
        <div
          className="absolute inset-0 pointer-events-none opacity-10"
          style={{
            backgroundImage:
              'repeating-linear-gradient(45deg, #ffffff 0px, #ffffff 1px, transparent 1px, transparent 20px)',
          }}
        />

        <div className="relative z-10 flex flex-col md:flex-row md:items-center justify-between gap-6">
          <div className="space-y-2">
            <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-white/10 backdrop-blur-xs border border-white/20 text-xs font-semibold text-blue-100">
              <ShieldCheck className="w-3.5 h-3.5 text-emerald-400" />
              <span>SAISA Pro • सुपर एडमिन कन्ट्रोल सेन्टर (SaaS Operations)</span>
            </div>
            <h1 className="text-2xl md:text-3xl font-serif font-bold text-white tracking-wide">
              नमस्ते, {user?.fullName || 'Super Administrator'}
            </h1>
            <p className="text-sm text-blue-100/80 max-w-2xl leading-relaxed">
              तपाईं SAISA Pro को केन्द्रीय प्रणाली व्यवस्थापक हुनुहुन्छ। यहाँबाट सम्पूर्ण ग्राहक संस्थाहरू, बहु-लाइसेन्स वितरण, डेमो लिडहरू तथा प्रणाली स्वास्थ्य निगरानी गर्नुहोस्।
            </p>
          </div>

          <div className="flex flex-wrap items-center gap-3">
            <Link
              to="/admin/tenants"
              className="inline-flex items-center gap-2 px-4 py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white font-semibold text-sm rounded-lg shadow transition-colors"
            >
              <Plus className="w-4 h-4" />
              <span>नयाँ ग्राहक अनबोर्ड गर्नुहोस्</span>
            </Link>

            <Link
              to="/admin/email-settings"
              className="inline-flex items-center gap-2 px-3.5 py-2.5 bg-white/10 hover:bg-white/20 text-white font-medium text-sm rounded-lg border border-white/20 backdrop-blur-xs transition-colors"
            >
              <Mail className="w-4 h-4 text-blue-200" />
              <span>इमेल / SMTP कन्फिग</span>
            </Link>
          </div>
        </div>
      </div>

      {/* Top 4 Stat Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {/* Card 1: Total Tenants */}
        <div className="bg-white border border-neutral-300 rounded-lg p-5 shadow-xs hover:border-neutral-400 transition-colors">
          <div className="flex items-center justify-between text-neutral-500 mb-2">
            <span className="text-xs font-semibold uppercase tracking-wider">कुल ग्राहक संस्थाहरू (Tenants)</span>
            <div className="w-8 h-8 rounded-lg bg-blue-50 text-blue-700 flex items-center justify-center">
              <Building2 className="w-4 h-4" />
            </div>
          </div>
          <div className="text-2xl font-bold font-serif text-neutral-900">
            {tenantsLoading ? '...' : tenants.length}
          </div>
          <div className="mt-2 text-xs flex items-center gap-2">
            <span className="text-emerald-700 font-semibold flex items-center gap-1">
              <CheckCircle2 className="w-3.5 h-3.5" />
              {activeTenants.length} सक्रिय (Active)
            </span>
            {suspendedTenants.length > 0 && (
              <span className="text-rose-600 font-semibold">
                • {suspendedTenants.length} निलम्बित
              </span>
            )}
          </div>
        </div>

        {/* Card 2: Active Cryptographic Licenses */}
        <div className="bg-white border border-neutral-300 rounded-lg p-5 shadow-xs hover:border-neutral-400 transition-colors">
          <div className="flex items-center justify-between text-neutral-500 mb-2">
            <span className="text-xs font-semibold uppercase tracking-wider">लाइसेन्स बाँडफाँड (Licenses)</span>
            <div className="w-8 h-8 rounded-lg bg-purple-50 text-purple-700 flex items-center justify-center">
              <Key className="w-4 h-4" />
            </div>
          </div>
          <div className="text-2xl font-bold font-serif text-neutral-900">
            {tenantsLoading ? '...' : activeTenants.length}
          </div>
          <div className="mt-2 text-xs text-neutral-600 flex items-center gap-1">
            <Sparkles className="w-3.5 h-3.5 text-purple-600" />
            <span>RSA-Signed डिजिटल कुञ्जीहरू</span>
          </div>
        </div>

        {/* Card 3: Demo Waiting Leads */}
        <div className="bg-white border border-neutral-300 rounded-lg p-5 shadow-xs hover:border-neutral-400 transition-colors">
          <div className="flex items-center justify-between text-neutral-500 mb-2">
            <span className="text-xs font-semibold uppercase tracking-wider">डेमो प्रतिक्षा सूची (Waiting Leads)</span>
            <div className="w-8 h-8 rounded-lg bg-amber-50 text-amber-700 flex items-center justify-center">
              <Clock className="w-4 h-4" />
            </div>
          </div>
          <div className="text-2xl font-bold font-serif text-amber-900">
            {leadsLoading ? '...' : waitingLeads.length}
          </div>
          <div className="mt-2 text-xs text-amber-700 font-medium">
            {waitingLeads.length > 0 ? (
              <Link to="/admin/tenants" className="hover:underline flex items-center gap-1">
                <span>स्वीकृत गर्न बाँकी लिडहरू</span>
                <ArrowRight className="w-3 h-3" />
              </Link>
            ) : (
              <span>कुनै पेन्डिङ अनुरोध छैन</span>
            )}
          </div>
        </div>

        {/* Card 4: Platform Engine Health */}
        <div className="bg-white border border-neutral-300 rounded-lg p-5 shadow-xs hover:border-neutral-400 transition-colors">
          <div className="flex items-center justify-between text-neutral-500 mb-2">
            <span className="text-xs font-semibold uppercase tracking-wider">प्रणाली स्थिति (Engine Health)</span>
            <div className="w-8 h-8 rounded-lg bg-emerald-50 text-emerald-700 flex items-center justify-center">
              <Activity className="w-4 h-4" />
            </div>
          </div>
          <div className="text-base font-bold font-serif text-emerald-800 flex items-center gap-2">
            <span className="w-2.5 h-2.5 rounded-full bg-emerald-500 animate-pulse" />
            <span>सबै सेवाहरू सक्रिय (Healthy)</span>
          </div>
          <div className="mt-2 text-xs text-neutral-600 font-mono">
            API • PostgreSQL • Mail OK
          </div>
        </div>
      </div>

      {/* Two Column Section: Recent Onboarded Tenants + Demo Leads Preview */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Left Column (2 Cols): Registered Tenants Table */}
        <div className="lg:col-span-2 bg-white border border-neutral-300 rounded-lg p-6 shadow-xs space-y-4">
          <div className="flex items-center justify-between pb-3 border-b border-neutral-200">
            <div>
              <h2 className="text-lg font-serif font-bold text-neutral-900 flex items-center gap-2">
                <Building2 className="w-5 h-5 text-primary-700" />
                <span>दर्ता भएका ग्राहक संस्थाहरू (Onboarded Tenants)</span>
              </h2>
              <p className="text-xs text-neutral-600 mt-0.5">
                हाल सक्रिय रहेका व्यवसायिक ग्राहकहरू र उनीहरूको लाइसेन्स अवस्था
              </p>
            </div>
            <Link
              to="/admin/tenants"
              className="text-xs font-semibold text-primary-700 hover:text-primary-800 hover:underline flex items-center gap-1"
            >
              <span>सबै हेर्नुहोस् ({tenants.length})</span>
              <ArrowRight className="w-3.5 h-3.5" />
            </Link>
          </div>

          <div className="overflow-x-auto border border-neutral-200 rounded-lg">
            <table className="w-full text-left text-xs">
              <thead className="bg-neutral-50 text-neutral-700 font-semibold border-b border-neutral-200 uppercase tracking-wider text-[11px]">
                <tr>
                  <th className="py-2.5 px-3">संस्थाको नाम (Company)</th>
                  <th className="py-2.5 px-3">कोड (Code)</th>
                  <th className="py-2.5 px-3">भ्याट / प्यान</th>
                  <th className="py-2.5 px-3">स्थिति</th>
                  <th className="py-2.5 px-3 text-right">कार्य</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-neutral-200">
                {tenantsLoading ? (
                  <tr>
                    <td colSpan={5} className="py-6 text-center text-neutral-500 font-serif">
                      लोड हुँदैछ...
                    </td>
                  </tr>
                ) : tenants.length === 0 ? (
                  <tr>
                    <td colSpan={5} className="py-8 text-center text-neutral-500 font-serif">
                      अहिले कुनै पनि नयाँ ग्राहक दर्ता गरिएको छैन। माथिको <strong>"+ नयाँ ग्राहक अनबोर्ड गर्नुहोस्"</strong> बटन प्रयोग गरी पहिलो ग्राहक थप्नुहोस्।
                    </td>
                  </tr>
                ) : (
                  tenants.slice(0, 5).map((t) => (
                    <tr key={t.id} className="hover:bg-neutral-50/50">
                      <td className="py-2.5 px-3 font-semibold text-neutral-900 font-serif">
                        {t.companyName}
                        {t.companyNameNepali && (
                          <span className="block text-[11px] text-neutral-500 font-normal">
                            {t.companyNameNepali}
                          </span>
                        )}
                      </td>
                      <td className="py-2.5 px-3 font-mono font-bold text-primary-800">
                        {t.tenantCode}
                      </td>
                      <td className="py-2.5 px-3 font-mono text-neutral-700">
                        {t.panVatNo || '—'}
                      </td>
                      <td className="py-2.5 px-3">
                        <span
                          className={`inline-flex items-center px-2 py-0.5 rounded-full text-[10px] font-bold ${
                            t.status === 'ACTIVE'
                              ? 'bg-emerald-50 text-emerald-800 border border-emerald-200'
                              : 'bg-rose-50 text-rose-800 border border-rose-200'
                          }`}
                        >
                          {t.status === 'ACTIVE' ? 'सक्रिय' : 'निलम्बित'}
                        </span>
                      </td>
                      <td className="py-2.5 px-3 text-right">
                        <Link
                          to="/admin/tenants"
                          className="text-xs font-semibold text-purple-700 hover:text-purple-900 bg-purple-50 px-2 py-1 rounded border border-purple-200"
                        >
                          व्यवस्थापन
                        </Link>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>

        {/* Right Column (1 Col): Quick Admin Tools & System Info */}
        <div className="space-y-6">
          {/* Quick Operations Box */}
          <div className="bg-white border border-neutral-300 rounded-lg p-5 shadow-xs space-y-3">
            <h3 className="text-sm font-serif font-bold text-neutral-900 border-b border-neutral-200 pb-2 flex items-center gap-2">
              <Server className="w-4 h-4 text-primary-700" />
              <span>प्लेटफर्म प्रशासनिक कमाण्डहरू (Admin Hub)</span>
            </h3>

            <div className="space-y-2">
              <Link
                to="/admin/tenants"
                className="flex items-center justify-between p-3 rounded-lg border border-neutral-200 hover:border-primary-400 hover:bg-neutral-50 transition-colors"
              >
                <div className="flex items-center gap-2.5">
                  <div className="w-8 h-8 rounded bg-primary-50 text-primary-700 flex items-center justify-center font-bold">
                    <Users className="w-4 h-4" />
                  </div>
                  <div>
                    <div className="text-xs font-bold text-neutral-900">ग्राहक व्यवस्थापन तथा लाइसेन्स</div>
                    <div className="text-[11px] text-neutral-500">नयाँ ग्राहक थप्ने, लाइसेन्स इन्जेक्ट गर्ने</div>
                  </div>
                </div>
                <ArrowRight className="w-4 h-4 text-neutral-400" />
              </Link>

              <Link
                to="/admin/email-settings"
                className="flex items-center justify-between p-3 rounded-lg border border-neutral-200 hover:border-primary-400 hover:bg-neutral-50 transition-colors"
              >
                <div className="flex items-center gap-2.5">
                  <div className="w-8 h-8 rounded bg-blue-50 text-blue-700 flex items-center justify-center font-bold">
                    <Mail className="w-4 h-4" />
                  </div>
                  <div>
                    <div className="text-xs font-bold text-neutral-900">प्रणाली इमेल (SMTP) सेटिङ्स</div>
                    <div className="text-[11px] text-neutral-500">Gmail SMTP, स्वागत इमेल तथा OTP</div>
                  </div>
                </div>
                <ArrowRight className="w-4 h-4 text-neutral-400" />
              </Link>

              <Link
                to="/audit-trail"
                className="flex items-center justify-between p-3 rounded-lg border border-neutral-200 hover:border-primary-400 hover:bg-neutral-50 transition-colors"
              >
                <div className="flex items-center gap-2.5">
                  <div className="w-8 h-8 rounded bg-amber-50 text-amber-700 flex items-center justify-center font-bold">
                    <FileText className="w-4 h-4" />
                  </div>
                  <div>
                    <div className="text-xs font-bold text-neutral-900">सुरक्षा अडिट लग (Security Audit)</div>
                    <div className="text-[11px] text-neutral-500">सिस्टम लगइन तथा परिवर्तनको विवरण</div>
                  </div>
                </div>
                <ArrowRight className="w-4 h-4 text-neutral-400" />
              </Link>
            </div>
          </div>

          {/* Platform Security Badge */}
          <div className="bg-neutral-50 border border-neutral-200 rounded-lg p-4 text-xs text-neutral-600 space-y-1.5 font-sans">
            <div className="font-bold text-neutral-900 flex items-center gap-1.5">
              <ShieldCheck className="w-4 h-4 text-emerald-600" />
              <span>Multi-Tenant Enterprise Isolation</span>
            </div>
            <p className="text-[11px] text-neutral-500 leading-relaxed">
              प्रत्येक ग्राहकको वित्तीय डाटा, भ्याट रिपोर्ट तथा बहीखाता पूर्ण रूपमा डेटाबेस स्तरमै पृथकीकृत (isolated) गरिएको छ। ग्राहक प्रयोगकर्ताहरूले यो प्लेटफर्म ड्यासबोर्ड खोल्न सक्दैनन्।
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

