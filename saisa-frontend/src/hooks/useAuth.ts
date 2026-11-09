import { useMutation } from '@tanstack/react-query';
import { useNavigate } from 'react-router-dom';
import { useAuthStore } from '../stores/authStore';
import { authService } from '../services/authService';
import type { LoginRequest, RegisterTenantRequest } from '../types/auth';

export function useAuth() {
  const navigate = useNavigate();
  const { user, isAuthenticated, logout } = useAuthStore();

  const loginMutation = useMutation({
    mutationFn: (credentials: LoginRequest) => authService.login(credentials),
    onSuccess: () => {
      navigate('/dashboard', { replace: true });
    },
  });

  const registerMutation = useMutation({
    mutationFn: (data: RegisterTenantRequest) => authService.register(data),
    onSuccess: () => {
      navigate('/dashboard', { replace: true });
    },
  });

  const handleLogout = () => {
    logout();
    navigate('/login', { replace: true });
  };

  return {
    user,
    isAuthenticated: isAuthenticated(),
    login: loginMutation.mutateAsync,
    isLoggingIn: loginMutation.isPending,
    loginError: loginMutation.error,
    register: registerMutation.mutateAsync,
    isRegistering: registerMutation.isPending,
    registerError: registerMutation.error,
    logout: handleLogout,
  };
}

