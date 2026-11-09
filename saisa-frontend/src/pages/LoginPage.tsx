import React from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { Link, useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '@/hooks/useAuth';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Check, ShieldCheck, BookOpen, Layers, BarChart3 } from 'lucide-react';

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
    formState: { errors },
  } = useForm<LoginFormData>({
    resolver: zodResolver(loginSchema),
    defaultValues: {
      tenantCode: 'ACME',
      username: '',
      password: '',
    },
  });

  const onSubmit = (data: LoginFormData) => {
    login(data, {
      onSuccess: () => {
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
          </form>

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

