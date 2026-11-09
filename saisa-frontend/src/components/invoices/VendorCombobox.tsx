import React, { useState } from 'react';
import { Combobox, type ComboboxOption } from '../ui/combobox';
import { useVendors } from '../../hooks/useVendors';
import { Button } from '../ui/button';
import { UserPlus } from 'lucide-react';
import { QuickVendorModal } from './QuickVendorModal';
import type { Vendor } from '../../types/vendor';

interface Props {
  value: number | null | undefined;
  onChange: (vendorId: number) => void;
  placeholder?: string;
  disabled?: boolean;
  error?: string;
  className?: string;
}

export const VendorCombobox: React.FC<Props> = ({
  value,
  onChange,
  placeholder = 'Search vendor by name, code or PAN...',
  disabled = false,
  error,
  className,
}) => {
  const { vendors = [] } = useVendors();
  const [modalOpen, setModalOpen] = useState(false);

  const options: ComboboxOption[] = React.useMemo(() => {
    return vendors
      .filter((v) => v.active)
      .map((v) => ({
        value: v.id,
        code: v.vendorCode,
        label: v.vendorName,
        type: v.phone || v.pan || undefined,
      }));
  }, [vendors]);

  const handleCreated = (newVen: Vendor) => {
    onChange(newVen.id);
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
        title="Quick Add Vendor"
        className="h-9 px-2.5 border-paper-border text-brand-navy hover:bg-paper-alt shrink-0"
      >
        <UserPlus className="h-3.5 w-3.5 mr-1" />
        <span className="text-xs font-serif hidden sm:inline">New</span>
      </Button>

      <QuickVendorModal
        open={modalOpen}
        onOpenChange={setModalOpen}
        onVendorCreated={handleCreated}
      />
    </div>
  );
};
