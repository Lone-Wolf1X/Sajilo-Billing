import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import { adminService } from '../services/adminService';
import type { OnboardTenantPayload, EmailSettings } from '../types/admin';

export const useTenants = () => {
  return useQuery({
    queryKey: ['admin', 'tenants'],
    queryFn: adminService.listTenants,
  });
};

export const useOnboardTenant = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (payload: OnboardTenantPayload) => adminService.onboardTenant(payload),
    onSuccess: (data) => {
      queryClient.invalidateQueries({ queryKey: ['admin', 'tenants'] });
      toast.success(`ग्राहक/संस्था "${data.companyName}" सफलतापूर्वक दर्ता गरियो!`);
    },
    onError: (err: any) => {
      const msg = err.response?.data?.message || err.message || 'Tenant दर्ता गर्न सकिएन।';
      toast.error(msg);
    },
  });
};

export const useToggleTenantStatus = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, status }: { id: number; status: string }) =>
      adminService.toggleTenantStatus(id, status),
    onSuccess: (data) => {
      queryClient.invalidateQueries({ queryKey: ['admin', 'tenants'] });
      toast.success(`Tenant ${data.tenantCode} स्थिति "${data.status}" मा परिवर्तन गरियो।`);
    },
    onError: (err: any) => {
      toast.error(err.response?.data?.message || 'स्थिति परिवर्तन गर्न सकिएन।');
    },
  });
};

export const useEmailSettings = () => {
  return useQuery({
    queryKey: ['admin', 'email-settings'],
    queryFn: adminService.getEmailSettings,
  });
};

export const useUpdateEmailSettings = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (settings: EmailSettings) => adminService.updateEmailSettings(settings),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin', 'email-settings'] });
      toast.success('इमेल सेटिङ सफलतापूर्वक सुरक्षित गरियो!');
    },
    onError: (err: any) => {
      toast.error(err.response?.data?.message || 'इमेल सेटिङ सुरक्षित गर्न सकिएन।');
    },
  });
};

export const useSendTestEmail = () => {
  return useMutation({
    mutationFn: (recipient?: string) => adminService.sendTestEmail(recipient),
    onSuccess: (data) => {
      toast.success(`परीक्षण इमेल सफलतापुर्वक "${data.recipient}" मा पठाइयो!`);
    },
    onError: (err: any) => {
      toast.error(err.response?.data?.message || err.message || 'परीक्षण इमेल पठाउन सकिएन।');
    },
  });
};
