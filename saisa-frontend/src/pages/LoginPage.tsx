import React, { useState } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { Link, useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '@/hooks/useAuth';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Dialog } from '@/components/ui/dialog';
import {
  Check,
  ShieldCheck,
  KeyRound,
  Mail,
  ArrowRight,
  CheckCircle2,
  AlertCircle,
  Layers,
  BarChart3,
  BookOpen,
} from 'lucide-react';
import { setupService } from '../services/setupService';
import { authService } from '../services/authService';

const loginSchema = z.object({
  tenantCode: z
    .string()
    .min(2, 'Company code must be at least 2 characters')
    .max(50, 'Company code is too long')
    .trim(),
  username: z
    .string()
    .min(3, 'Username must be at least 3 characters')
    .trim(),
  password: z
    .string()
    .min(6, 'Password must be at least 6 characters'),
});

type LoginFormData = z.infer<typeof loginSchema>;

export const LoginPage: React.FC = () => {
  const { login, isLoggingIn } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();

  const from = (location.state as { from?: { pathname: string } })?.from?.pathname || '/dashboard';

  const {
    register,
    handleSubmit,
    setValue,
    formState: { errors },
  } = useForm<LoginFormData>({
    resolver: zodResolver(loginSchema),
    defaultValues: {
      tenantCode: '_platform',
      username: 'superadmin',
      password: 'ChangeMe#2026',
    },
  });

  // Forgot Password / OTP Modal State
  const [forgotModalOpen, setForgotModalOpen] = useState(false);
  const [forgotStep, setForgotStep] = useState<1 | 2>(1);
  const [forgotEmail, setForgotEmail] = useState('nextgeninnovationsprivatelimit@gmail.com');
  const [forgotTenantCode, setForgotTenantCode] = useState('_platform');
  const [forgotOtp, setForgotOtp] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [forgotLoading, setForgotLoading] = useState(false);
  const [forgotError, setForgotError] = useState('');
  const [forgotSuccessMessage, setForgotSuccessMessage] = useState('');

  const handleSendOtp = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!forgotEmail.trim()) {
      setForgotError('कृपया इमेल ठेगाना प्रविष्ट गर्नुहोस्।');
      return;
    }
    setForgotLoading(true);
    setForgotError('');
    try {
      const res = await authService.forgotPassword({
        email: forgotEmail.trim(),
        tenantCode: forgotTenantCode.trim() || undefined,
      });
      setForgotSuccessMessage(res.message);
      setForgotStep(2);
    } catch (err: any) {
      setForgotError(err?.response?.data?.message || err?.message || 'OTP पठाउन सकिएन। कृपया इमेल जाँच गर्नुहोस्।');
    } finally {
      setForgotLoading(false);
    }
  };

  const handleResetPassword = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!forgotOtp.trim() || forgotOtp.trim().length !== 6) {
      setForgotError('कृपया ६-अङ्कको OTP कोड प्रविष्ट गर्नुहोस्।');
      return;
    }
    if (!newPassword || newPassword.length < 6) {
      setForgotError('नयाँ पासवर्ड कम्तिमा ६ वर्णको हुनुपर्दछ।');
      return;
    }
    if (newPassword !== confirmPassword) {
      setForgotError('पासवर्डहरू मिलेनन्। कृपया दुवै फिल्डमा एउटै पासवर्ड राख्नुहोस्।');
      return;
    }
    setForgotLoading(true);
    setForgotError('');
    try {
      const res = await authService.resetPasswordWithOtp({
        email: forgotEmail.trim(),
        otp: forgotOtp.trim(),
        newPassword: newPassword.trim(),
      });
      setForgotSuccessMessage(res.message);
      setValue('password', newPassword.trim());
      setTimeout(() => {
        setForgotModalOpen(false);
        setForgotStep(1);
        setForgotOtp('');
        setNewPassword('');
        setConfirmPassword('');
        setForgotSuccessMessage('');
      }, 2500);
    } catch (err: any) {
      setForgotError(err?.response?.data?.message || err?.message || 'पासवर्ड रिसेट गर्न सकिएन।');
    } finally {
      setForgotLoading(false);
    }
  };

  const onSubmit = (data: LoginFormData) => {
    login(data, {
      onSuccess: async () => {
        try {
          const status = await setupService.getStatus();
          if (status && !status.setupCompleted) {
            navigate('/setup', { replace: true });
            return;
          }
        } catch (err) {
          console.warn('Could not verify setup status on login:', err);
        }
        navigate(from, { replace: true });
      },
    });
  };

  return (
    <div className="min-h-screen grid grid-cols-1 md:grid-cols-2 bg-paper">
      {/* LEFT: Classical Finance Brand Panel */}
      <div className="hidden md:flex flex-col justify-center px-10 lg:px-16 py-12 bg-gradient-to-br from-[#1e3a5f] via-[#2a4d75] to-[#14263d] text-white relative overflow-hidden">
        {/* Subtle ledger paper line pattern overlay */}
        <div
          className="absolute inset-0 pointer-events-none opacity-5"
          style={{
            backgroundImage:
              'repeating-linear-gradient(0deg, #ffffff 0px, #ffffff 1px, transparent 1px, transparent 36px)',
          }}
        />

        <div className="relative z-10 max-w-lg">
          <div className="flex items-center gap-3 mb-3">
            <span className="w-12 h-12 bg-white text-brand-navy rounded flex items-center justify-center font-bold text-2xl font-serif shadow-lg">
              S
            </span>
            <span className="font-serif text-3xl font-bold tracking-wider">
              SAISA
            </span>
          </div>
          <p className="font-serif italic text-lg text-blue-100/90 mb-10">
            Enterprise Accounting & Financial Management
          </p>

          <ul className="space-y-4">
            <li className="flex items-start gap-3 text-sm text-blue-50/90">
              <span className="w-5 h-5 rounded-full bg-white/15 border border-white/30 flex items-center justify-center flex-shrink-0 mt-0.5">
                <Check className="w-3 h-3 text-white" />
              </span>
              <span>
                <strong>Double-Entry Ledger:</strong> Pure immutable financial journals, debit/credit balanced at write time.
              </span>
            </li>

            <li className="flex items-start gap-3 text-sm text-blue-50/90">
              <span className="w-5 h-5 rounded-full bg-white/15 border border-white/30 flex items-center justify-center flex-shrink-0 mt-0.5">
                <Layers className="w-3 h-3 text-white" />
              </span>
              <span>
                <strong>Billing & Real-Time COGS:</strong> Automatic inventory valuation & cost of goods sold posting.
              </span>
            </li>

            <li className="flex items-start gap-3 text-sm text-blue-50/90">
              <span className="w-5 h-5 rounded-full bg-white/15 border border-white/30 flex items-center justify-center flex-shrink-0 mt-0.5">
                <BarChart3 className="w-3 h-3 text-white" />
              </span>
              <span>
                <strong>Statutory Financial Statements:</strong> Real-time Trial Balance, Profit & Loss, and Balance Sheet.
              </span>
            </li>

            <li className="flex items-start gap-3 text-sm text-blue-50/90">
              <span className="w-5 h-5 rounded-full bg-white/15 border border-white/30 flex items-center justify-center flex-shrink-0 mt-0.5">
                <ShieldCheck className="w-3 h-3 text-white" />
              </span>
              <span>
                <strong>Audit Compliance:</strong> Row-level tenancy isolation with cryptographically verified audit trails.
              </span>
            </li>
          </ul>

          <div className="mt-12 pt-6 border-t border-white/15 text-xs text-blue-200/70 flex items-center gap-2">
            <BookOpen className="w-4 h-4" />
            <span>Designed for professional chartered accountants & CFOs</span>
          </div>
        </div>
      </div>

      {/* RIGHT: Login Form */}
      <div className="flex items-center justify-center p-6 md:p-12">
        <div className="w-full max-w-md bg-paper-surface p-8 rounded-lg border border-paper-border shadow-ledger">
          <div className="mb-6">
            <div className="md:hidden flex items-center gap-2 mb-4">
              <span className="w-8 h-8 bg-brand-navy text-white rounded flex items-center justify-center font-bold text-lg font-serif">
                S
              </span>
              <span className="font-serif text-2xl font-bold text-brand-navy">
                SAISA
              </span>
            </div>
            <h1 className="font-serif text-2xl font-bold text-paper-text mb-1">
              Sign In to Your Ledger
            </h1>
            <p className="text-sm text-paper-muted">
              Enter your assigned company code and credentials.
            </p>
          </div>

          <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
            <div>
              <Label htmlFor="tenantCode" required>
                Company Code
              </Label>
              <Input
                id="tenantCode"
                placeholder="e.g. ACME"
                error={errors.tenantCode?.message}
                {...register('tenantCode')}
                autoFocus
              />
              <p className="text-[11px] text-paper-muted mt-1">
                The unique code assigned to your accounting tenant.
              </p>
            </div>

            <div>
              <Label htmlFor="username" required>
                Username
              </Label>
              <Input
                id="username"
                type="text"
                placeholder="Enter username"
                error={errors.username?.message}
                {...register('username')}
                autoComplete="username"
              />
            </div>

            <div>
              <div className="flex justify-between items-center mb-1">
                <Label htmlFor="password" required className="mb-0">
                  Password
                </Label>
                <button
                  type="button"
                  onClick={() => {
                    setForgotModalOpen(true);
                    setForgotStep(1);
                    setForgotError('');
                    setForgotSuccessMessage('');
                  }}
                  className="text-xs text-primary-600 hover:text-primary-800 hover:underline font-semibold"
                >
                  पासवर्ड बिर्सनुभयो? (Forgot?)
                </button>
              </div>
              <Input
                id="password"
                type="password"
                placeholder="Enter password"
                error={errors.password?.message}
                {...register('password')}
                autoComplete="current-password"
              />
            </div>

            <Button
              type="submit"
              variant="primary"
              size="lg"
              className="w-full mt-2"
              isLoading={isLoggingIn}
            >
              Sign In to Accounting System
            </Button>

            {/* Platform Superadmin Credentials Hint */}
            <div className="mt-4 p-3 rounded bg-blue-50/70 border border-blue-200 text-xs text-blue-900 space-y-1">
              <div className="font-semibold flex items-center justify-between">
                <span>Platform Superadmin Credentials:</span>
                <span className="text-[10px] text-blue-700 font-mono bg-blue-100 px-1.5 py-0.5 rounded">Pre-filled</span>
              </div>
              <div className="flex items-center justify-between text-[11px] font-mono">
                <span>Company: <strong>_platform</strong></span>
                <span>User: <strong>superadmin</strong></span>
                <span>Pass: <strong>ChangeMe#2026</strong></span>
              </div>
              <div className="text-[10px] text-blue-800 font-mono pt-0.5 flex items-center justify-between">
                <span>Email: <strong>nextgeninnovationsprivatelimit@gmail.com</strong></span>
                <span className="text-emerald-700 font-sans font-bold">● Live OTP</span>
              </div>
            </div>
          </form>

          {/* Forgot Password & Reset via OTP Dialog */}
          <Dialog
            open={forgotModalOpen}
            onOpenChange={setForgotModalOpen}
            title={forgotStep === 1 ? "पासवर्ड रिसेट OTP अनुरोध (Request Password Reset OTP)" : "नयाँ पासवर्ड सेट गर्नुहोस् (Reset Password with OTP)"}
            description={forgotStep === 1 ? "आफ्नो दर्ता गरिएको इमेल प्रविष्ट गर्नुहोस्। हामी तपाईंलाई ६-अङ्कको OTP कोड पठाउनेछौं।" : "तपाईंको इमेलमा प्राप्त भएको ६-अङ्कको OTP कोड र नयाँ पासवर्ड प्रविष्ट गर्नुहोस्।"}
            className="max-w-md w-full"
          >
            {forgotError && (
              <div className="mb-4 p-3 rounded bg-rose-50 border border-rose-200 text-rose-800 text-xs flex items-start gap-2">
                <AlertCircle className="w-4 h-4 text-rose-600 flex-shrink-0 mt-0.5" />
                <span>{forgotError}</span>
              </div>
            )}

            {forgotSuccessMessage && (
              <div className="mb-4 p-3 rounded bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs flex items-start gap-2">
                <CheckCircle2 className="w-4 h-4 text-emerald-600 flex-shrink-0 mt-0.5" />
                <span>{forgotSuccessMessage}</span>
              </div>
            )}

            {forgotStep === 1 ? (
              <form onSubmit={handleSendOtp} className="space-y-4">
                <div>
                  <Label htmlFor="forgotTenantCode">कम्पनी कोड (Company Code - Optional)</Label>
                  <Input
                    id="forgotTenantCode"
                    value={forgotTenantCode}
                    onChange={(e) => setForgotTenantCode(e.target.value)}
                    placeholder="_platform वा कम्पनी कोड"
                  />
                  <p className="text-[11px] text-neutral-500 mt-1">Superadmin को लागि <code>_platform</code> राख्नुहोस्।</p>
                </div>

                <div>
                  <Label htmlFor="forgotEmail" required>दर्ता गरिएको इमेल (Registered Email Address)</Label>
                  <div className="relative">
                    <Input
                      id="forgotEmail"
                      type="email"
                      value={forgotEmail}
                      onChange={(e) => setForgotEmail(e.target.value)}
                      placeholder="e.g. nextgeninnovationsprivatelimit@gmail.com"
                      required
                      autoFocus
                    />
                    <Mail className="w-4 h-4 text-neutral-400 absolute right-3 top-3 pointer-events-none" />
                  </div>
                  <p className="text-[11px] text-neutral-500 mt-1">यस इमेलमा ६-अङ्कको गोप्य OTP कोड डेलिभर हुनेछ।</p>
                </div>

                <div className="pt-2 flex justify-end gap-2">
                  <Button
                    type="button"
                    variant="outline"
                    onClick={() => setForgotModalOpen(false)}
                  >
                    रद्द गर्नुहोस् (Cancel)
                  </Button>
                  <Button
                    type="submit"
                    variant="primary"
                    isLoading={forgotLoading}
                    className="inline-flex items-center gap-1.5"
                  >
                    <span>इमेलमा OTP पठाउनुहोस्</span>
                    <ArrowRight className="w-4 h-4" />
                  </Button>
                </div>
              </form>
            ) : (
              <form onSubmit={handleResetPassword} className="space-y-4">
                <div className="bg-neutral-50 p-3 rounded border border-neutral-200 text-xs text-neutral-700">
                  इमेल: <strong className="font-mono text-neutral-900">{forgotEmail}</strong>
                </div>

                <div>
                  <Label htmlFor="forgotOtp" required>६-अङ्कको OTP कोड (Enter 6-Digit OTP)</Label>
                  <Input
                    id="forgotOtp"
                    value={forgotOtp}
                    onChange={(e) => setForgotOtp(e.target.value.replace(/[^0-9]/g, '').slice(0, 6))}
                    placeholder="123456"
                    className="text-center font-mono text-xl tracking-[0.5em] font-bold"
                    maxLength={6}
                    required
                    autoFocus
                  />
                  <p className="text-[11px] text-neutral-500 mt-1">तपाईंको Gmail इनबक्समा पठाइएको कोड यहाँ राख्नुहोस्।</p>
                </div>

                <div>
                  <Label htmlFor="newPassword" required>नयाँ पासवर्ड (New Password)</Label>
                  <Input
                    id="newPassword"
                    type="password"
                    value={newPassword}
                    onChange={(e) => setNewPassword(e.target.value)}
                    placeholder="कम्तिमा ६ वर्ण"
                    required
                  />
                </div>

                <div>
                  <Label htmlFor="confirmPassword" required>नयाँ पासवर्ड पुनः पुष्टि गर्नुहोस् (Confirm Password)</Label>
                  <Input
                    id="confirmPassword"
                    type="password"
                    value={confirmPassword}
                    onChange={(e) => setConfirmPassword(e.target.value)}
                    placeholder="नयाँ पासवर्ड दोहोर्याउनुहोस्"
                    required
                  />
                </div>

                <div className="pt-2 flex justify-between items-center gap-2">
                  <button
                    type="button"
                    onClick={() => {
                      setForgotStep(1);
                      setForgotError('');
                      setForgotSuccessMessage('');
                    }}
                    className="text-xs text-neutral-600 hover:text-neutral-900 underline"
                  >
                    ← इमेल परिवर्तन गर्नुहोस्
                  </button>
                  <div className="flex gap-2">
                    <Button
                      type="button"
                      variant="outline"
                      onClick={() => setForgotModalOpen(false)}
                    >
                      बन्द गर्नुहोस्
                    </Button>
                    <Button
                      type="submit"
                      variant="primary"
                      isLoading={forgotLoading}
                      className="inline-flex items-center gap-1.5"
                    >
                      <KeyRound className="w-4 h-4" />
                      <span>पासवर्ड परिवर्तन गर्नुहोस्</span>
                    </Button>
                  </div>
                </div>
              </form>
            )}
          </Dialog>

          <div className="mt-6 pt-5 border-t border-paper-border text-center text-sm text-paper-muted">
            Need a new company workspace?{' '}
            <Link
              to="/register"
              className="text-brand-navy font-semibold hover:underline"
            >
              Register Company
            </Link>
          </div>

          <div className="mt-6 text-center text-[11px] text-paper-subtle">
            SAISA Enterprise Accounting Core v1.0 · Secured by JWT & HMAC
          </div>
        </div>
      </div>
    </div>
  );
};

