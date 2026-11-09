import React, { useState } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { Dialog } from '../ui/dialog';
import { Button } from '../ui/button';
import { Input } from '../ui/input';
import { Label } from '../ui/label';
import { useCreateCustomer } from '../../hooks/useCustomers';
import type { Customer, CreateCustomerRequest } from '../../types/customer';

const schema = z.object({
  customerCode: z.string().min(2, 'Customer code must be at least 2 characters'),
  customerName: z.string().min(2, 'Customer name is required'),
  phone: z.string().optional(),
  email: z.string().email('Invalid email').or(z.literal('')).optional(),
  pan: z.string().optional(),
  gstin: z.string().optional(),
  state: z.string().optional(),
  billingAddress: z.string().optional(),
});

type FormData = z.infer<typeof schema>;

interface Props {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onCustomerCreated: (customer: Customer) => void;
}

export const QuickCustomerModal: React.FC<Props> = ({
  open,
  onOpenChange,
  onCustomerCreated,
}) => {
  const createMutation = useCreateCustomer();
  const [errorMsg, setErrorMsg] = useState<string | null>(null);

  const {
    register,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm<FormData>({
    resolver: zodResolver(schema),
    defaultValues: {
      customerCode: `CUST-${Math.floor(1000 + Math.random() * 9000)}`,
      customerName: '',
      phone: '',
      email: '',
      pan: '',
      gstin: '',
      state: 'Bagmati',
      billingAddress: '',
    },
  });

  const onSubmit = async (data: FormData) => {
    setErrorMsg(null);
    try {
      const payload: CreateCustomerRequest = {
        customerCode: data.customerCode.trim().toUpperCase(),
        customerName: data.customerName.trim(),
        phone: data.phone?.trim() || undefined,
        email: data.email?.trim() || undefined,
        pan: data.pan?.trim() || undefined,
        gstin: data.gstin?.trim() || undefined,
        state: data.state?.trim() || undefined,
        billingAddress: data.billingAddress?.trim() || undefined,
      };

      const created = await createMutation.mutateAsync(payload);
      reset();
      onCustomerCreated(created);
      onOpenChange(false);
    } catch (err: any) {
      setErrorMsg(
        err.response?.data?.message || err.message || 'Failed to create customer.'
      );
    }
  };

  return (
    <Dialog
      open={open}
      onOpenChange={onOpenChange}
      title="Quick Add Customer"
      description="Add a new customer profile without leaving the invoice voucher."
    >
      <div className="space-y-3.5">
        {errorMsg && (
          <div className="bg-[#fdf2f2] border border-[#7a2e2e] text-[#7a2e2e] text-xs p-2.5 rounded-sm">
            {errorMsg}
          </div>
        )}

        <form onSubmit={handleSubmit(onSubmit)} className="space-y-3.5">
          <div className="grid grid-cols-2 gap-3">
            <div>
              <Label className="text-xs font-serif font-bold text-paper-text">
                Customer Code *
              </Label>
              <Input
                {...register('customerCode')}
                placeholder="e.g. CUST-1001"
                className="font-mono text-xs mt-1"
              />
              {errors.customerCode && (
                <p className="text-[11px] text-[#7a2e2e] mt-0.5">
                  {errors.customerCode.message}
                </p>
              )}
            </div>

            <div>
              <Label className="text-xs font-serif font-bold text-paper-text">
                Full Name / Company *
              </Label>
              <Input
                {...register('customerName')}
                placeholder="e.g. Kathmandu Traders"
                className="text-xs mt-1"
              />
              {errors.customerName && (
                <p className="text-[11px] text-[#7a2e2e] mt-0.5">
                  {errors.customerName.message}
                </p>
              )}
            </div>
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div>
              <Label className="text-xs font-serif text-paper-text">
                Phone Number
              </Label>
              <Input
                {...register('phone')}
                placeholder="98XXXXXXXX"
                className="font-mono text-xs mt-1"
              />
            </div>

            <div>
              <Label className="text-xs font-serif text-paper-text">
                Email Address
              </Label>
              <Input
                {...register('email')}
                type="email"
                placeholder="billing@example.com"
                className="text-xs mt-1"
              />
              {errors.email && (
                <p className="text-[11px] text-[#7a2e2e] mt-0.5">
                  {errors.email.message}
                </p>
              )}
            </div>
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div>
              <Label className="text-xs font-serif text-paper-text">
                PAN / VAT / GSTIN
              </Label>
              <Input
                {...register('pan')}
                placeholder="Tax ID / PAN"
                className="font-mono text-xs mt-1"
              />
            </div>

            <div>
              <Label className="text-xs font-serif text-paper-text">State / Province</Label>
              <Input
                {...register('state')}
                placeholder="e.g. Bagmati"
                className="text-xs mt-1"
              />
            </div>
          </div>

          <div>
            <Label className="text-xs font-serif text-paper-text">Billing Address</Label>
            <Input
              {...register('billingAddress')}
              placeholder="Street, City, Postal Code"
              className="text-xs mt-1"
            />
          </div>

          <div className="flex items-center justify-end gap-2 pt-3 border-t border-paper-border mt-4">
            <Button
              type="button"
              variant="outline"
              onClick={() => onOpenChange(false)}
              className="text-xs"
            >
              Cancel
            </Button>
            <Button
              type="submit"
              disabled={createMutation.isPending}
              className="bg-brand-navy hover:bg-[#152943] text-white text-xs font-serif px-4"
            >
              {createMutation.isPending ? 'Saving...' : 'Save & Select Customer'}
            </Button>
          </div>
        </form>
      </div>
    </Dialog>
  );
};
