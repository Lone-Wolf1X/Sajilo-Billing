import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import { debitNotesService } from '../services/debitNotesService';
import type {
  CreateDebitNoteRequest,
  DebitNoteListParams,
} from '../types/debitNote';

export function useDebitNotes(params: DebitNoteListParams = {}) {
  return useQuery({
    queryKey: ['debit-notes', params],
    queryFn: () => debitNotesService.list(params),
    staleTime: 30_000,
  });
}

export function useDebitNote(id: number) {
  return useQuery({
    queryKey: ['debit-notes', id],
    queryFn: () => debitNotesService.getById(id),
    enabled: id > 0,
  });
}

export function useCreateDebitNote() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (payload: CreateDebitNoteRequest) => debitNotesService.create(payload),
    onSuccess: (dn) => {
      qc.invalidateQueries({ queryKey: ['debit-notes'] });
      qc.invalidateQueries({ queryKey: ['purchase-invoices'] });
      qc.invalidateQueries({ queryKey: ['invoices'] });
      qc.invalidateQueries({ queryKey: ['ap-aging'] });
      qc.invalidateQueries({ queryKey: ['accounts'] });
      qc.invalidateQueries({ queryKey: ['ledger'] });
      toast.success(`Debit note ${dn.debitNoteNumber} posted successfully`);
    },
    onError: (err: unknown) => {
      const msg = (err as { response?: { data?: { message?: string } } })?.response?.data?.message;
      toast.error(msg ?? 'Failed to create debit note');
    },
  });
}

