import React from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '@/hooks/useAuth';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Building2, ArrowLeft } from 'lucide-react';

const registerSchema = z.object({
  companyName: z
    .string()
    .min(3, 'Company name must be at least 3 characters')
    .trim(),
  tenantCode: z
    .string()
    .min(2, 'Company code must be at least 2 characters')
    .max(20, 'Company code cannot exceed 20 characters')
    .regex(/^[A-Za-z0-9_-]+$/, 'Letters, numbers, underscores and hyphens only')
    .transform((v) => v.toUpperCase().trim()),
  adminFullName: z
    .string()
    .min(3, 'Full name must be at least 3 characters')
    .trim(),
  adminEmail: z
    .string()
    .email('Invalid email address')
    .trim(),
  adminUsername: z
    .string()
    .min(3, 'Admin username must be at least 3 characters')
    .trim(),
  adminPassword: z
    .string()
    .min(6, 'Password must be at least 6 characters'),
});

type RegisterFormData = z.infer<typeof registerSchema>;

export const RegisterPage: React.FC = () => {
  const { register: registerCompany, isRegistering } = useAuth();
  const navigate = useNavigate();

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<RegisterFormData>({
    resolver: zodResolver(registerSchema),
    defaultValues: {
      companyName: '',
      tenantCode: '',
      adminFullName: '',
      adminEmail: '',
      adminUsername: '',
      adminPassword: '',
    },
  });

  const onSubmit = (data: RegisterFormData) => {
    registerCompany(data, {
      onSuccess: () => {
        navigate('/dashboard', { replace: true });
      },
    });
  };

  return (
    <div className="min-h-screen bg-paper py-10 px-4 flex flex-col justify-center items-center">
      <div className="w-full max-w-xl bg-paper-surface p-8 rounded-lg border border-paper-border shadow-ledger">
        <div className="flex items-center justify-between mb-6 pb-4 border-b border-paper-border">
          <div className="flex items-center gap-2.5">
            <span className="w-9 h-9 bg-brand-navy text-white rounded flex items-center justify-center font-bold text-lg font-serif">
              S
            </span>
            <div>
              <h1 className="font-serif text-xl font-bold text-brand-navy">
                Register New Tenant
              </h1>
              <p className="text-xs text-paper-muted">
                Create an isolated accounting workspace with Chart of Accounts
              </p>
            </div>
          </div>
          <Link
            to="/login"
            className="text-xs text-paper-muted hover:text-brand-navy flex items-center gap-1 font-medium"
          >
            <ArrowLeft className="w-3.5 h-3.5" />
            <span>Back to Login</span>
          </Link>
        </div>

        <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <Label htmlFor="companyName" required>
                Company Legal Name
              </Label>
              <Input
                id="companyName"
                placeholder="e.g. Acme Traders Pvt Ltd"
                error={errors.companyName?.message}
                {...register('companyName')}
                autoFocus
              />
            </div>

            <div>
              <Label htmlFor="tenantCode" required>
                Tenant Code (Unique)
              </Label>
              <Input
                id="tenantCode"
                placeholder="e.g. ACME"
                error={errors.tenantCode?.message}
                {...register('tenantCode')}
              />
              <p className="text-[11px] text-paper-muted mt-1">
                Used in prefix URLs & user logins.
              </p>
            </div>
          </div>

          <div className="pt-2 border-t border-dashed border-paper-border">
            <div className="flex items-center gap-1.5 text-xs font-bold uppercase tracking-wider text-brand-maroon mb-3">
              <Building2 className="w-3.5 h-3.5" />
              <span>Primary Administrator Account</span>
            </div>

            <div className="space-y-4">
              <div>
                <Label htmlFor="adminFullName" required>
                  Administrator Full Name
                </Label>
                <Input
                  id="adminFullName"
                  placeholder="e.g. Abhisek Paswan"
                  error={errors.adminFullName?.message}
                  {...register('adminFullName')}
                />
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <Label htmlFor="adminEmail" required>
                    Email Address
                  </Label>
                  <Input
                    id="adminEmail"
                    type="email"
                    placeholder="admin@company.com"
                    error={errors.adminEmail?.message}
                    {...register('adminEmail')}
                  />
                </div>

                <div>
                  <Label htmlFor="adminUsername" required>
                    Username
                  </Label>
                  <Input
                    id="adminUsername"
                    placeholder="e.g. admin"
                    error={errors.adminUsername?.message}
                    {...register('adminUsername')}
                  />
                </div>
              </div>

              <div>
                <Label htmlFor="adminPassword" required>
                  Password
                </Label>
                <Input
                  id="adminPassword"
                  type="password"
                  placeholder="Minimum 6 characters"
                  error={errors.adminPassword?.message}
                  {...register('adminPassword')}
                />
              </div>
            </div>
          </div>

          <div className="pt-4">
            <Button
              type="submit"
              variant="primary"
              size="lg"
              className="w-full"
              isLoading={isRegistering}
            >
              Create Company & Initialize Ledger
            </Button>
          </div>
        </form>

        <div className="mt-6 pt-4 border-t border-paper-border text-center text-xs text-paper-muted">
          Already registered?{' '}
          <Link
            to="/login"
            className="text-brand-navy font-semibold hover:underline"
          >
            Sign in to existing account
          </Link>
        </div>
      </div>
    </div>
  );
};
