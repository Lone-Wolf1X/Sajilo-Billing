import apiClient from '../lib/axios';
import type { LedgerStatement } from '../types/ledger';

export const ledgerService = {
  async getStatement(
    accountId: number,
    from: string,
    to: string
  ): Promise<LedgerStatement> {
    const res = await apiClient.get<LedgerStatement>(
      `/api/v1/ledger/${accountId}`,
      {
        params: { from, to },
      }
    );
    return res.data;
  },
};

