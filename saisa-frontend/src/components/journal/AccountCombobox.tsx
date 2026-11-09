import React from 'react';
import { Combobox, type ComboboxOption } from '../ui/combobox';
import { useAccounts } from '../../hooks/useAccounts';

interface Props {
  value: number | null | undefined;
  onChange: (accountId: number) => void;
  placeholder?: string;
  disabled?: boolean;
  error?: string;
  className?: string;
}

export const AccountCombobox: React.FC<Props> = ({
  value,
  onChange,
  placeholder = 'Search ledger account...',
  disabled = false,
  error,
  className,
}) => {
  const { accounts = [] } = useAccounts();

  const options: ComboboxOption[] = React.useMemo(() => {
    return accounts
      .filter((a) => a.active)
      .map((a) => ({
        value: a.id,
        code: a.accountCode,
        label: a.accountName,
        type: a.accountType,
      }));
  }, [accounts]);

  return (
    <Combobox
      value={value ?? undefined}
      onChange={onChange}
      options={options}
      placeholder={placeholder}
      disabled={disabled}
      error={error}
      className={className}
    />
  );
};
