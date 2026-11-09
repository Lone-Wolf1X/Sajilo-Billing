import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import { setupService } from '../services/setupService';
import type { UpdateProfileRequest, OpeningBalanceRequest } from '../types/setup';

export const useCompanyProfile = () => {
  return useQuery({
    queryKey: ['company-profile'],
    queryFn: setupService.getProfile,
    staleTime: 5 * 60 * 1000,
  });
};

export const useSetupStatus = () => {
  return useQuery({
    queryKey: ['setup-status'],
    queryFn: setupService.getStatus,
    staleTime: 60 * 1000,
  });
};

export const useUpdateProfile = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: UpdateProfileRequest) => setupService.updateProfile(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['company-profile'] });
      queryClient.invalidateQueries({ queryKey: ['setup-status'] });
    },
  });
};

export const useCompleteSetup = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: () => setupService.completeSetup(),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['company-profile'] });
      queryClient.invalidateQueries({ queryKey: ['setup-status'] });
    },
  });
};

export const useOpeningBalance = () => {
  return useQuery({
    queryKey: ['setup', 'opening-balance'],
    queryFn: () => setupService.getOpeningBalance(),
    staleTime: 0,
  });
};

export const usePostOpeningBalance = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (payload: OpeningBalanceRequest) => setupService.postOpeningBalance(payload),
    onSuccess: (resp) => {
      queryClient.invalidateQueries({ queryKey: ['setup'] });
      queryClient.invalidateQueries({ queryKey: ['accounts'] });
      queryClient.invalidateQueries({ queryKey: ['journal-entries'] });
      queryClient.invalidateQueries({ queryKey: ['trial-balance'] });
      queryClient.invalidateQueries({ queryKey: ['profit-loss'] });
      queryClient.invalidateQueries({ queryKey: ['balance-sheet'] });
      queryClient.invalidateQueries({ queryKey: ['cash-flow'] });
      queryClient.invalidateQueries({ queryKey: ['ledger'] });
      queryClient.invalidateQueries({ queryKey: ['ar-aging'] });
      queryClient.invalidateQueries({ queryKey: ['ap-aging'] });
      toast.success(`Opening balance posted as ${resp.journalEntryNumber || 'JE'}`);
    },
    onError: (err: any) => {
      toast.error(err?.response?.data?.message ?? 'Failed to post opening balance');
    },
  });
};

export const useResetOpeningBalance = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (reason: string) => setupService.resetOpeningBalance(reason),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['setup'] });
      queryClient.invalidateQueries({ queryKey: ['journal-entries'] });
      queryClient.invalidateQueries({ queryKey: ['trial-balance'] });
      queryClient.invalidateQueries({ queryKey: ['accounts'] });
      queryClient.invalidateQueries({ queryKey: ['ledger'] });
      toast.success('Opening balance reset. You can now re-enter.');
    },
    onError: (err: any) => {
      toast.error(err?.response?.data?.message ?? 'Failed to reset opening balance');
    },
  });
};
