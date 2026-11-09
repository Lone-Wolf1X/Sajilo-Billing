import React from 'react';
import { Combobox, type ComboboxOption } from '../ui/combobox';
import { useItems } from '../../hooks/useItems';
import type { Item } from '../../types/item';

interface Props {
  value: number | null | undefined;
  onChange: (itemId: number, item?: Item) => void;
  placeholder?: string;
  disabled?: boolean;
  error?: string;
  className?: string;
}

export const ItemCombobox: React.FC<Props> = ({
  value,
  onChange,
  placeholder = 'Search item by SKU or name...',
  disabled = false,
  error,
  className,
}) => {
  const { items = [] } = useItems();

  const options: ComboboxOption[] = React.useMemo(() => {
    return items
      .filter((i) => i.active)
      .map((i) => ({
        value: i.id,
        code: i.sku,
        label: i.name,
        type: i.unitOfMeasure,
      }));
  }, [items]);

  const handleChange = (selectedId: number) => {
    const selectedItem = items.find((i) => i.id === selectedId);
    onChange(selectedId, selectedItem);
  };

  return (
    <Combobox
      value={value ?? undefined}
      onChange={handleChange}
      options={options}
      placeholder={placeholder}
      disabled={disabled}
      error={error}
      className={className}
    />
  );
};

