export interface ApiError {
  code: string;
  message: string;
  correlationId?: string;
  timestamp?: string;
  errors?: Record<string, string>;
  retryAfterSeconds?: number;
}

