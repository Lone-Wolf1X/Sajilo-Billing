import React, { useState } from 'react';
import { Combobox, type ComboboxOption } from '../ui/combobox';
import { useCustomers } from '../../hooks/useCustomers';
import { Button } from '../ui/button';
import { UserPlus } from 'lucide-react';
import { QuickCustomerModal } from './QuickCustomerModal';
import type { Customer } from '../../types/customer';

interface Props {
  value: number | null | undefined;
  onChange: (customerId: number) => void;
  placeholder?: string;
  disabled?: boolean;
  error?: string;
  className?: string;
}

export const CustomerCombobox: React.FC<Props> = ({
  value,
  onChange,
  placeholder = 'Search customer by name, code or phone...',
  disabled = false,
  error,
  className,
}) => {
  const { customers = [] } = useCustomers();
  const [modalOpen, setModalOpen] = useState(false);

  const options: ComboboxOption[] = React.useMemo(() => {
    return customers
      .filter((c) => c.active)
      .map((c) => ({
        value: c.id,
        code: c.customerCode,
        label: c.customerName,
        type: c.phone || c.pan || undefined,
      }));
  }, [customers]);

  const handleCreated = (newCust: Customer) => {
    onChange(newCust.id);
  };

  return (
    <div className="flex items-center gap-1.5 w-full">
      <div className="flex-1">
        <Combobox
          value={value ?? undefined}
          onChange={onChange}
          options={options}
          placeholder={placeholder}
          disabled={disabled}
          error={error}
          className={className}
        />
      </div>

      <Button
        type="button"
        variant="outline"
        size="sm"
        onClick={() => setModalOpen(true)}
        disabled={disabled}
        title="Quick Add Customer"
        className="h-9 px-2.5 border-paper-border text-brand-navy hover:bg-paper-alt shrink-0"
      >
        <UserPlus className="h-3.5 w-3.5 mr-1" />
        <span className="text-xs font-serif hidden sm:inline">New</span>
      </Button>

      <QuickCustomerModal
        open={modalOpen}
        onOpenChange={setModalOpen}
        onCustomerCreated={handleCreated}
      />
    </div>
  );
};

