import React, { useState, useEffect } from 'react';
import {
  Mail,
  Send,
  Save,
  CheckCircle2,
  Eye,
  EyeOff,
  Server,
  HelpCircle,
} from 'lucide-react';
import { useEmailSettings, useUpdateEmailSettings, useSendTestEmail } from '../../hooks/useAdmin';

export const EmailSettingsPage: React.FC = () => {
  const { data: settings, isLoading } = useEmailSettings();
  const updateMutation = useUpdateEmailSettings();
  const sendTestMutation = useSendTestEmail();

  // Form State
  const [smtpHost, setSmtpHost] = useState('smtp.gmail.com');
  const [smtpPort, setSmtpPort] = useState(587);
  const [smtpUsername, setSmtpUsername] = useState('nextgeninnovationsprivatelimit@gmail.com');
  const [smtpPassword, setSmtpPassword] = useState('mdvx fwry lrmd pwsc');
  const [fromEmail, setFromEmail] = useState('nextgeninnovationsprivatelimit@gmail.com');
  const [fromName, setFromName] = useState('SAISA Billing & Accounting');
  const [starttlsEnabled, setStarttlsEnabled] = useState(true);
  const [authEnabled, setAuthEnabled] = useState(true);

  const [showPassword, setShowPassword] = useState(false);
  const [testRecipient, setTestRecipient] = useState('nextgeninnovationsprivatelimit@gmail.com');
  const [testSuccessMessage, setTestSuccessMessage] = useState<string | null>(null);

  useEffect(() => {
    if (settings) {
      setSmtpHost(settings.smtpHost || 'smtp.gmail.com');
      setSmtpPort(settings.smtpPort || 587);
      setSmtpUsername(settings.smtpUsername || 'nextgeninnovationsprivatelimit@gmail.com');
      setSmtpPassword(settings.smtpPassword || 'mdvx fwry lrmd pwsc');
      setFromEmail(settings.fromEmail || 'nextgeninnovationsprivatelimit@gmail.com');
      setFromName(settings.fromName || 'SAISA Billing & Accounting');
      setStarttlsEnabled(settings.starttlsEnabled ?? true);
      setAuthEnabled(settings.authEnabled ?? true);
      setTestRecipient(settings.fromEmail || 'nextgeninnovationsprivatelimit@gmail.com');
    }
  }, [settings]);

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    await updateMutation.mutateAsync({
      smtpHost: smtpHost.trim(),
      smtpPort: Number(smtpPort),
      smtpUsername: smtpUsername.trim(),
      smtpPassword: smtpPassword.trim(),
      fromEmail: fromEmail.trim(),
      fromName: fromName.trim(),
      starttlsEnabled,
      authEnabled,
    });
  };

  const handleSendTest = async () => {
    setTestSuccessMessage(null);
    try {
      const res = await sendTestMutation.mutateAsync(testRecipient.trim() || undefined);
      setTestSuccessMessage(
        `✓ सफलता! परीक्षण इमेल "${res.recipient}" मा सफलतापूर्वक पुग्यो (${new Date(res.timestamp).toLocaleTimeString()})`
      );
    } catch {
      // Handled by toast
    }
  };

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[40vh]">
        <div className="text-center font-serif text-sm text-neutral-500">
          इमेल कन्फिगरेसन लोड हुँदैछ... (Loading Email Settings...)
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6 max-w-5xl mx-auto p-4 md:p-6">
      {/* Header Bar */}
      <div className="bg-white border border-neutral-300 rounded-lg p-6 shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div className="flex items-start gap-3">
          <div className="w-12 h-12 rounded-lg bg-emerald-50 border border-emerald-200 flex items-center justify-center text-emerald-700 flex-shrink-0">
            <Mail className="w-6 h-6" />
          </div>
          <div>
            <div className="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full bg-emerald-50 text-emerald-800 border border-emerald-200 text-xs font-semibold mb-1">
              <span>प्रणाली इमेल गेटवे (System SMTP Gateway)</span>
            </div>
            <h1 className="text-2xl font-serif font-bold text-neutral-900">
              इमेल कन्फिगरेसन तथा प्रमाणीकरण (Email / SMTP Settings)
            </h1>
            <p className="text-xs text-neutral-600 mt-1">
              बीजक (Invoices), भुक्तानी रसिद र प्रणाली सूचनाहरू ग्राहकलाई इमेल गर्न SMTP सर्भर सेटिङ।
            </p>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Main Settings Form (2 cols) */}
        <div className="lg:col-span-2 space-y-6">
          <form onSubmit={handleSave} className="bg-white border border-neutral-300 rounded-lg p-6 shadow-sm space-y-5">
            <div className="flex items-center justify-between pb-3 border-b border-neutral-200">
              <h2 className="text-sm font-bold uppercase text-neutral-800 tracking-wider flex items-center gap-2">
                <Server className="w-4 h-4 text-primary-600" />
                <span>SMTP सर्भर विवरण (Server Configuration)</span>
              </h2>
              <span className="text-xs text-neutral-500">Google SMTP / Custom</span>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
              <div className="sm:col-span-2">
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  SMTP Host (सर्भर ठेगाना) <span className="text-rose-600">*</span>
                </label>
                <input
                  type="text"
                  required
                  value={smtpHost}
                  onChange={(e) => setSmtpHost(e.target.value)}
                  placeholder="smtp.gmail.com"
                  className="w-full px-3 py-2 text-xs font-mono border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  Port <span className="text-rose-600">*</span>
                </label>
                <input
                  type="number"
                  required
                  value={smtpPort}
                  onChange={(e) => setSmtpPort(Number(e.target.value))}
                  placeholder="587"
                  className="w-full px-3 py-2 text-xs font-mono font-bold border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                />
              </div>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  SMTP Username / Email <span className="text-rose-600">*</span>
                </label>
                <input
                  type="email"
                  required
                  value={smtpUsername}
                  onChange={(e) => setSmtpUsername(e.target.value)}
                  placeholder="your-email@gmail.com"
                  className="w-full px-3 py-2 text-xs border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  App Password / पासवर्ड <span className="text-rose-600">*</span>
                </label>
                <div className="relative">
                  <input
                    type={showPassword ? 'text' : 'password'}
                    required
                    value={smtpPassword}
                    onChange={(e) => setSmtpPassword(e.target.value)}
                    placeholder="mdvx fwry lrmd pwsc"
                    className="w-full pl-3 pr-9 py-2 text-xs font-mono border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="absolute right-2.5 top-1/2 -translate-y-1/2 text-neutral-400 hover:text-neutral-700"
                    title={showPassword ? 'Hide password' : 'Show password'}
                  >
                    {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                  </button>
                </div>
              </div>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-2">
              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  प्रेषक इमेल (From Email) <span className="text-rose-600">*</span>
                </label>
                <input
                  type="email"
                  required
                  value={fromEmail}
                  onChange={(e) => setFromEmail(e.target.value)}
                  placeholder="billing@company.com"
                  className="w-full px-3 py-2 text-xs border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  प्रेषक नाम (Sender Display Name) <span className="text-rose-600">*</span>
                </label>
                <input
                  type="text"
                  required
                  value={fromName}
                  onChange={(e) => setFromName(e.target.value)}
                  placeholder="SAISA Billing & Accounting"
                  className="w-full px-3 py-2 text-xs border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                />
              </div>
            </div>

            <div className="flex flex-wrap items-center gap-6 pt-3 border-t border-neutral-200">
              <label className="inline-flex items-center gap-2 cursor-pointer">
                <input
                  type="checkbox"
                  checked={starttlsEnabled}
                  onChange={(e) => setStarttlsEnabled(e.target.checked)}
                  className="w-4 h-4 rounded text-primary-600 border-neutral-300 focus:ring-primary-500"
                />
                <span className="text-xs font-semibold text-neutral-800">Use STARTTLS Encryption (Recommended)</span>
              </label>

              <label className="inline-flex items-center gap-2 cursor-pointer">
                <input
                  type="checkbox"
                  checked={authEnabled}
                  onChange={(e) => setAuthEnabled(e.target.checked)}
                  className="w-4 h-4 rounded text-primary-600 border-neutral-300 focus:ring-primary-500"
                />
                <span className="text-xs font-semibold text-neutral-800">SMTP Authentication (Auth Login)</span>
              </label>
            </div>

            <div className="pt-4 border-t border-neutral-200 flex justify-end">
              <button
                type="submit"
                disabled={updateMutation.isPending}
                className="inline-flex items-center gap-2 px-6 py-2.5 text-xs font-bold text-white bg-primary-700 hover:bg-primary-800 active:bg-primary-900 rounded-lg shadow-sm transition-colors disabled:opacity-50"
              >
                <Save className="w-4 h-4" />
                <span>{updateMutation.isPending ? 'सुरक्षित गर्दैछ...' : 'इमेल सेटिङ सुरक्षित गर्नुहोस् (Save Settings)'}</span>
              </button>
            </div>
          </form>
        </div>

        {/* Live Test Panel & Help (1 col) */}
        <div className="space-y-6">
          {/* Test Email Box */}
          <div className="bg-white border-2 border-emerald-300 rounded-lg p-5 shadow-sm space-y-4">
            <div className="flex items-center gap-2 pb-2 border-b border-neutral-200">
              <Send className="w-4 h-4 text-emerald-600" />
              <h2 className="text-sm font-bold text-neutral-900">
                परीक्षण इमेल पठाउनुहोस् (Send Test Email)
              </h2>
            </div>

            <p className="text-xs text-neutral-600">
              SMTP सर्भर र पासवर्ड सही भएको जाँच गर्न तत्काल परीक्षण इमेल पठाउनुहोस्।
            </p>

            <div>
              <label className="block text-xs font-semibold text-neutral-800 mb-1">
                प्रापक इमेल ठेगाना (Recipient Email)
              </label>
              <input
                type="email"
                value={testRecipient}
                onChange={(e) => setTestRecipient(e.target.value)}
                placeholder="test@example.com"
                className="w-full px-3 py-2 text-xs border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-emerald-500 shadow-sm"
              />
            </div>

            <button
              type="button"
              onClick={handleSendTest}
              disabled={sendTestMutation.isPending || !testRecipient.trim()}
              className="w-full inline-flex items-center justify-center gap-2 px-4 py-2.5 text-xs font-bold text-white bg-emerald-600 hover:bg-emerald-700 active:bg-emerald-800 rounded shadow transition-colors disabled:opacity-50"
            >
              {sendTestMutation.isPending ? (
                <span>इमेल पठाउँदैछ... (Sending...)</span>
              ) : (
                <>
                  <Send className="w-3.5 h-3.5" />
                  <span>अहिले नै परीक्षण इमेल पठाउनुहोस् (Send Test Now)</span>
                </>
              )}
            </button>

            {testSuccessMessage && (
              <div className="p-3 bg-emerald-50 border border-emerald-300 rounded text-xs text-emerald-900 flex items-start gap-2">
                <CheckCircle2 className="w-4 h-4 text-emerald-600 flex-shrink-0 mt-0.5" />
                <span>{testSuccessMessage}</span>
              </div>
            )}
          </div>

          {/* Google App Password Guide */}
          <div className="bg-blue-50 border border-blue-200 rounded-lg p-5 text-xs text-blue-900 space-y-2.5">
            <div className="flex items-center gap-1.5 font-bold text-sm text-blue-950">
              <HelpCircle className="w-4 h-4 text-blue-600" />
              <span>Gmail App Password सहायता</span>
            </div>
            <p className="leading-relaxed opacity-95">
              Gmail बाट इमेल पठाउन तपाईंको Google Account मा <strong>2-Step Verification (2FA)</strong> सक्रिय हुनुपर्छ र <strong>16-character App Password</strong> (जस्तै <code>mdvx fwry lrmd pwsc</code>) प्रयोग गर्नुपर्छ।
            </p>
            <div className="font-mono text-[11px] bg-white/70 p-2 rounded border border-blue-200">
              Account ➔ Security ➔ 2-Step Verification ➔ App passwords
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
