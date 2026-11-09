import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import { creditNotesService } from '../services/creditNotesService';
import type {
  CreateCreditNoteRequest,
  CreditNoteListParams,
} from '../types/creditNote';

export function useCreditNotes(params: CreditNoteListParams = {}) {
  return useQuery({
    queryKey: ['credit-notes', params],
    queryFn: () => creditNotesService.list(params),
    staleTime: 30_000,
  });
}

export function useCreditNote(id: number) {
  return useQuery({
    queryKey: ['credit-notes', id],
    queryFn: () => creditNotesService.getById(id),
    enabled: id > 0,
  });
}

export function useCreateCreditNote() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (payload: CreateCreditNoteRequest) => creditNotesService.create(payload),
    onSuccess: (cn) => {
      qc.invalidateQueries({ queryKey: ['credit-notes'] });
      qc.invalidateQueries({ queryKey: ['sales-invoices'] });
      qc.invalidateQueries({ queryKey: ['invoices'] });
      qc.invalidateQueries({ queryKey: ['ar-aging'] });
      qc.invalidateQueries({ queryKey: ['accounts'] });
      qc.invalidateQueries({ queryKey: ['ledger'] });
      toast.success(`Credit note ${cn.creditNoteNumber} posted successfully`);
    },
    onError: (err: unknown) => {
      const msg = (err as { response?: { data?: { message?: string } } })?.response?.data?.message;
      toast.error(msg ?? 'Failed to create credit note');
    },
  });
}
