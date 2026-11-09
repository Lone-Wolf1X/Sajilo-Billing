import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { setupService } from '../services/setupService';
import type { UpdateProfileRequest } from '../types/setup';

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
