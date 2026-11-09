export type PeriodStatus = 'OPEN' | 'CLOSED' | 'LOCKED';

export interface AccountingPeriod {
  id: number;
  periodName: string;
  startDate: string; // ISO format: YYYY-MM-DD
  endDate: string;   // ISO format: YYYY-MM-DD
  status: PeriodStatus;
}

export interface CreatePeriodRequest {
  periodName: string;
  startDate: string;
  endDate: string;
}
