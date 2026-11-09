import React, { useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { Dialog } from '../ui/dialog';
import { Input } from '../ui/input';
import { Label } from '../ui/label';
import { Button } from '../ui/button';
import { useCreateItem, useUpdateItem } from '../../hooks/useItems';
import type { Item } from '../../types/item';

const schema = z.object({
  sku: z
    .string()
    .min(1, 'SKU is required')
    .max(64)
    .regex(/^[A-Za-z0-9_-]+$/, 'Alphanumeric, underscores, hyphens only'),
  name: z.string().min(1, 'Item name is required').max(255),
  description: z.string().optional(),
  unitOfMeasure: z.string().min(1).max(16),
  hsnCode: z.string().max(16).optional(),
  tracksInventory: z.boolean(),
  salePrice: z.string().regex(/^\d*(\.\d{1,4})?$/, 'Enter valid numeric sale price'),
  purchasePrice: z.string().regex(/^\d*(\.\d{1,4})?$/, 'Enter valid numeric purchase price'),
  reorderLevel: z.string().regex(/^\d*(\.\d{1,4})?$/, 'Enter valid reorder level').optional(),
  active: z.boolean().optional(),
});

type FormData = z.infer<typeof schema>;

const UOMS = ['NOS', 'PCS', 'KG', 'GM', 'L', 'ML', 'M', 'FT', 'BOX', 'SET', 'PAIR'];

interface Props {
  open: boolean;
  onClose: () => void;
  editingItem?: Item | null;
}

export const ItemForm: React.FC<Props> = ({ open, onClose, editingItem }) => {
  const isEdit = !!editingItem;
  const createMut = useCreateItem();
  const updateMut = useUpdateItem();

  const {
    register,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm<FormData>({
    resolver: zodResolver(schema),
    defaultValues: {
      sku: '',
      name: '',
      description: '',
      unitOfMeasure: 'NOS',
      hsnCode: '',
      tracksInventory: true,
      salePrice: '0.00',
      purchasePrice: '0.00',
      reorderLevel: '0',
      active: true,
    },
  });

  useEffect(() => {
    if (!open) return;
    if (editingItem) {
      reset({
        sku: editingItem.sku,
        name: editingItem.name,
        description: editingItem.description ?? '',
        unitOfMeasure: editingItem.unitOfMeasure,
        hsnCode: editingItem.hsnCode ?? '',
        tracksInventory: editingItem.tracksInventory,
        salePrice: editingItem.salePrice !== null && editingItem.salePrice !== undefined ? String(editingItem.salePrice) : '0.00',
        purchasePrice: editingItem.purchasePrice !== null && editingItem.purchasePrice !== undefined ? String(editingItem.purchasePrice) : '0.00',
        reorderLevel: editingItem.reorderLevel !== null && editingItem.reorderLevel !== undefined ? String(editingItem.reorderLevel) : '0',
        active: editingItem.active,
      });
    } else {
      reset({
        sku: '',
        name: '',
        description: '',
        unitOfMeasure: 'NOS',
        hsnCode: '',
        tracksInventory: true,
        salePrice: '0.00',
        purchasePrice: '0.00',
        reorderLevel: '0',
        active: true,
      });
    }
  }, [open, editingItem, reset]);

  const onSubmit = async (data: FormData) => {
    try {
      if (isEdit && editingItem) {
        await updateMut.mutateAsync({
          id: editingItem.id,
          data: {
            name: data.name.trim(),
            description: data.description?.trim() || undefined,
            unitOfMeasure: data.unitOfMeasure,
            hsnCode: data.hsnCode?.trim() || undefined,
            salePrice: data.salePrice || '0',
            purchasePrice: data.purchasePrice || '0',
            reorderLevel: data.reorderLevel || '0',
            active: data.active ?? true,
          },
        });
      } else {
        await createMut.mutateAsync({
          sku: data.sku.trim().toUpperCase(),
          name: data.name.trim(),
          description: data.description?.trim() || undefined,
          unitOfMeasure: data.unitOfMeasure,
          hsnCode: data.hsnCode?.trim() || undefined,
          tracksInventory: data.tracksInventory,
          salePrice: data.salePrice || '0',
          purchasePrice: data.purchasePrice || '0',
          reorderLevel: data.reorderLevel || '0',
        });
      }
      onClose();
    } catch {
      // toast shown in mutation hook
    }
  };

  return (
    <Dialog
      open={open}
      onClose={onClose}
      title={isEdit ? `Edit SKU: ${editingItem?.sku}` : 'Register New Item'}
      description={
        isEdit
          ? 'Modify pricing, reorder rules, and operational parameters.'
          : 'Create a stock-tracked or service SKU in the inventory master.'
      }
    >
      <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
        <div className="grid grid-cols-2 gap-3">
          <div>
            <Label className="text-xs font-serif text-brand-navy">SKU Code *</Label>
            <Input
              {...register('sku')}
              disabled={isEdit}
              placeholder="e.g. WIDGET-001"
              className="font-mono text-xs uppercase"
            />
            {errors.sku && (
              <p className="text-xs text-ledger-red mt-1">{errors.sku.message}</p>
            )}
            {isEdit && (
              <p className="text-[11px] text-paper-muted mt-0.5">
                SKU is immutable once referenced in documents.
              </p>
            )}
          </div>

          <div>
            <Label className="text-xs font-serif text-brand-navy">Unit of Measure (UOM) *</Label>
            <select
              className="w-full px-2.5 py-1.5 text-xs font-serif border border-paper-border-strong rounded bg-white text-brand-navy focus:outline-none focus:ring-1 focus:ring-brand-navy h-9"
              {...register('unitOfMeasure')}
            >
              {UOMS.map((u) => (
                <option key={u} value={u}>
                  {u}
                </option>
              ))}
            </select>
          </div>
        </div>

        <div>
          <Label className="text-xs font-serif text-brand-navy">Item Name *</Label>
          <Input
            {...register('name')}
            placeholder="e.g. Commercial Widget Grade A"
            className="text-xs"
          />
          {errors.name && (
            <p className="text-xs text-ledger-red mt-1">{errors.name.message}</p>
          )}
        </div>

        <div>
          <Label className="text-xs font-serif text-brand-navy">Description / Specifications</Label>
          <Input
            {...register('description')}
            placeholder="Optional technical specifications or notes"
            className="text-xs"
          />
        </div>

        <div className="grid grid-cols-2 gap-3">
          <div>
            <Label className="text-xs font-serif text-brand-navy">HSN / SAC Code</Label>
            <Input
              {...register('hsnCode')}
              placeholder="e.g. 8471"
              className="font-mono text-xs"
            />
          </div>

          <div>
            <Label className="text-xs font-serif text-brand-navy">Reorder Minimum Level</Label>
            <Input
              {...register('reorderLevel')}
              placeholder="0"
              className="font-mono text-xs text-right"
            />
            <p className="text-[11px] text-paper-muted mt-0.5">
              Alerts triggered when total stock falls below this.
            </p>
          </div>
        </div>

        <div className="grid grid-cols-2 gap-3">
          <div>
            <Label className="text-xs font-serif text-brand-navy">Cost / Purchase Price (₹) *</Label>
            <Input
              {...register('purchasePrice')}
              className="text-right font-mono text-xs"
              placeholder="0.00"
            />
            {errors.purchasePrice && (
              <p className="text-xs text-ledger-red mt-1">{errors.purchasePrice.message}</p>
            )}
          </div>

          <div>
            <Label className="text-xs font-serif text-brand-navy">Default Sale Price (₹) *</Label>
            <Input
              {...register('salePrice')}
              className="text-right font-mono text-xs"
              placeholder="0.00"
            />
            {errors.salePrice && (
              <p className="text-xs text-ledger-red mt-1">{errors.salePrice.message}</p>
            )}
          </div>
        </div>

        <div className="pt-2 border-t border-paper-border space-y-2">
          <label className="flex items-center gap-2 text-xs font-serif text-brand-navy cursor-pointer">
            <input
              type="checkbox"
              className="rounded border-paper-border text-brand-navy focus:ring-0"
              {...register('tracksInventory')}
              disabled={isEdit}
            />
            <span className="font-semibold">Track Inventory & Continuous Weighted Average Cost (WAC)</span>
          </label>
          <p className="text-[11px] text-paper-muted pl-5">
            {isEdit
              ? 'Inventory tracking policy cannot be modified post-creation to prevent COGS divergence.'
              : 'Uncheck for service items (consulting, labor, shipping) which do not hold physical stock.'}
          </p>

          {isEdit && (
            <label className="flex items-center gap-2 text-xs font-serif text-brand-navy cursor-pointer pt-1">
              <input
                type="checkbox"
                className="rounded border-paper-border text-brand-navy focus:ring-0"
                {...register('active')}
              />
              <span className="font-semibold">Active for Trading & Billing</span>
            </label>
          )}
        </div>

        <div className="flex justify-end gap-2 pt-3 border-t border-paper-border">
          <Button
            type="button"
            variant="outline"
            onClick={onClose}
            className="border-paper-border text-brand-navy hover:bg-paper-alt font-serif text-xs"
          >
            Cancel
          </Button>
          <Button
            type="submit"
            disabled={createMut.isPending || updateMut.isPending}
            className="bg-brand-navy hover:bg-brand-navy/90 text-white font-serif text-xs px-4"
          >
            {createMut.isPending || updateMut.isPending
              ? 'Saving...'
              : isEdit
              ? 'Save Changes'
              : 'Create Item'}
          </Button>
        </div>
      </form>
    </Dialog>
  );
};
