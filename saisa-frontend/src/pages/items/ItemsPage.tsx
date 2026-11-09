import React, { useMemo, useState } from 'react';
import { Plus, Package, Search } from 'lucide-react';
import { Button } from '../../components/ui/button';
import { Input } from '../../components/ui/input';
import { Skeleton } from '../../components/ui/skeleton';
import { ItemForm } from '../../components/items/ItemForm';
import { useItems } from '../../hooks/useItems';
import { formatMoney } from '../../lib/invoiceUtils';
import type { Item } from '../../types/item';

export const ItemsPage: React.FC = () => {
  const { items = [], isLoading } = useItems();
  const [search, setSearch] = useState('');
  const [showForm, setShowForm] = useState(false);
  const [editing, setEditing] = useState<Item | null>(null);

  const filtered = useMemo(() => {
    const term = search.trim().toLowerCase();
    if (!term) return items;
    return items.filter(
      (i) =>
        i.sku.toLowerCase().includes(term) ||
        i.name.toLowerCase().includes(term) ||
        (i.hsnCode && i.hsnCode.toLowerCase().includes(term))
    );
  }, [items, search]);

  const trackedCount = items.filter((i) => i.tracksInventory).length;
  const serviceCount = items.length - trackedCount;

  return (
    <div className="p-6 max-w-7xl mx-auto space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <div className="flex items-center gap-2">
            <h1 className="font-serif text-2xl font-bold text-brand-navy">
              Items & SKU Catalog
            </h1>
            <span className="text-xs px-2 py-0.5 rounded bg-brand-navy/10 text-brand-navy font-mono font-semibold border border-brand-navy/20">
              [F10]
            </span>
          </div>
          <p className="text-xs text-paper-muted mt-1">
            Master SKU inventory catalog, continuous weighted average costing (WAC), and pricing parameters.
          </p>
        </div>

        <Button
          onClick={() => {
            setEditing(null);
            setShowForm(true);
          }}
          className="bg-brand-navy hover:bg-brand-navy/90 text-white font-serif text-xs px-4 flex items-center gap-1.5 shadow-sm"
        >
          <Plus size={15} />
          <span>New Item / SKU</span>
        </Button>
      </div>

      {/* Metrics Ribbon */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div className="bg-white border border-paper-border rounded-lg p-4 shadow-sm">
          <div className="text-[11px] font-serif uppercase tracking-wider text-paper-muted">
            Total Catalog Items
          </div>
          <div className="font-mono text-2xl font-bold text-brand-navy mt-1">
            {items.length}
          </div>
          <div className="text-[11px] text-paper-muted mt-0.5">
            {items.filter((i) => i.active).length} Active · {items.filter((i) => !i.active).length} Inactive
          </div>
        </div>

        <div className="bg-white border border-paper-border rounded-lg p-4 shadow-sm border-l-4 border-l-brand-navy">
          <div className="text-[11px] font-serif uppercase tracking-wider text-paper-muted">
            Physical Goods (Tracked)
          </div>
          <div className="font-mono text-2xl font-bold text-brand-navy mt-1">
            {trackedCount}
          </div>
          <div className="text-[11px] text-paper-muted mt-0.5">
            Linked to inventory stock movements & COGS
          </div>
        </div>

        <div className="bg-white border border-paper-border rounded-lg p-4 shadow-sm">
          <div className="text-[11px] font-serif uppercase tracking-wider text-paper-muted">
            Service / Non-Stock Items
          </div>
          <div className="font-mono text-2xl font-bold text-paper-muted mt-1">
            {serviceCount}
          </div>
          <div className="text-[11px] text-paper-muted mt-0.5">
            Direct revenue/expense without balance sheet stock
          </div>
        </div>
      </div>

      {/* Search Bar Card */}
      <div className="bg-white border border-paper-border rounded-lg p-3 shadow-sm">
        <div className="relative max-w-md">
          <Search
            size={16}
            className="absolute left-3 top-1/2 -translate-y-1/2 text-paper-muted"
          />
          <Input
            placeholder="Search by SKU, item name, or HSN code..."
            className="pl-9 text-xs h-9"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
      </div>

      {/* Items Table Card */}
      <div className="bg-white border border-paper-border rounded-lg overflow-hidden shadow-sm">
        {isLoading ? (
          <div className="p-6 space-y-3">
            {[1, 2, 3, 4, 5].map((i) => (
              <Skeleton key={i} className="h-10 w-full" />
            ))}
          </div>
        ) : filtered.length === 0 ? (
          <div className="p-12 text-center space-y-3">
            <Package size={44} className="mx-auto text-paper-muted" />
            <h3 className="font-serif text-base font-semibold text-brand-navy">
              No catalog items found
            </h3>
            <p className="text-xs text-paper-muted max-w-sm mx-auto">
              {search
                ? 'No items match your search filter. Clear the search term to view all SKUs.'
                : 'Your inventory catalog is currently empty. Create your first SKU to begin purchasing and sales invoicing.'}
            </p>
            {!search && (
              <Button
                variant="outline"
                size="sm"
                onClick={() => {
                  setEditing(null);
                  setShowForm(true);
                }}
                className="mt-2 border-paper-border text-brand-navy hover:bg-paper-alt font-serif text-xs"
              >
                <Plus size={14} className="mr-1" /> Create First Item
              </Button>
            )}
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-sm border-collapse">
              <thead className="bg-paper-alt border-b-2 border-paper-border-strong text-brand-navy">
                <tr>
                  <th className="px-4 py-3 text-left font-serif text-xs uppercase tracking-wider text-paper-muted">
                    SKU Code
                  </th>
                  <th className="px-4 py-3 text-left font-serif text-xs uppercase tracking-wider text-paper-muted">
                    Item Name & Specifications
                  </th>
                  <th className="px-3 py-3 text-center font-serif text-xs uppercase tracking-wider text-paper-muted w-20">
                    UOM
                  </th>
                  <th className="px-3 py-3 text-center font-serif text-xs uppercase tracking-wider text-paper-muted w-24">
                    HSN
                  </th>
                  <th className="px-4 py-3 text-right font-serif text-xs uppercase tracking-wider text-paper-muted w-28">
                    Purchase Cost
                  </th>
                  <th className="px-4 py-3 text-right font-serif text-xs uppercase tracking-wider text-paper-muted w-28">
                    Sale Price
                  </th>
                  <th className="px-4 py-3 text-center font-serif text-xs uppercase tracking-wider text-paper-muted w-24">
                    Category
                  </th>
                  <th className="px-4 py-3 text-center font-serif text-xs uppercase tracking-wider text-paper-muted w-24">
                    Status
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-paper-border">
                {filtered.map((item) => (
                  <tr
                    key={item.id}
                    onClick={() => {
                      setEditing(item);
                      setShowForm(true);
                    }}
                    className="hover:bg-paper-alt/50 cursor-pointer transition-colors"
                  >
                    <td className="px-4 py-3 font-mono text-xs font-bold text-brand-navy">
                      {item.sku}
                    </td>
                    <td className="px-4 py-3">
                      <div className="font-serif text-xs font-semibold text-brand-navy">
                        {item.name}
                      </div>
                      {item.description && (
                        <div className="text-[11px] text-paper-muted truncate max-w-sm">
                          {item.description}
                        </div>
                      )}
                    </td>
                    <td className="px-3 py-3 text-center font-mono text-xs text-paper-muted">
                      {item.unitOfMeasure}
                    </td>
                    <td className="px-3 py-3 text-center font-mono text-xs text-paper-text">
                      {item.hsnCode || <span className="text-paper-muted/50">—</span>}
                    </td>
                    <td className="px-4 py-3 text-right font-mono tabular-nums text-xs text-paper-text">
                      {item.purchasePrice !== null && item.purchasePrice !== undefined
                        ? formatMoney(item.purchasePrice)
                        : '—'}
                    </td>
                    <td className="px-4 py-3 text-right font-mono tabular-nums text-xs font-semibold text-brand-navy">
                      {item.salePrice !== null && item.salePrice !== undefined
                        ? formatMoney(item.salePrice)
                        : '—'}
                    </td>
                    <td className="px-4 py-3 text-center">
                      <span
                        className={`inline-block text-[10px] font-serif uppercase tracking-wider font-semibold px-2 py-0.5 rounded border ${
                          item.tracksInventory
                            ? 'bg-blue-50 text-blue-800 border-blue-200'
                            : 'bg-purple-50 text-purple-800 border-purple-200'
                        }`}
                      >
                        {item.tracksInventory ? 'Goods' : 'Service'}
                      </span>
                    </td>
                    <td className="px-4 py-3 text-center">
                      <span
                        className={`inline-block text-[10px] font-serif uppercase tracking-wider font-semibold px-2 py-0.5 rounded border ${
                          item.active
                            ? 'bg-emerald-50 text-emerald-800 border-emerald-200'
                            : 'bg-gray-100 text-gray-700 border-gray-300'
                        }`}
                      >
                        {item.active ? 'Active' : 'Inactive'}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      <ItemForm
        open={showForm}
        onClose={() => setShowForm(false)}
        editingItem={editing}
      />
    </div>
  );
};
