import React, { useState, useEffect } from 'react';
import {
  Warehouse,
  Boxes,
  Plus,
  Trash2,
  ClipboardPaste,
  ArrowRight,
  ArrowLeft,
  CheckCircle2,
  Sparkles,
  AlertCircle,
  Layers,
} from 'lucide-react';
import { useWarehouses, useCreateWarehouse } from '../../hooks/useWarehouses';
import { useItems, useCreateBulkItems } from '../../hooks/useItems';
import {
  useOpeningStock,
  usePostOpeningStock,
  useCompleteSetup,
  useCompanyProfile,
  useOpeningBalance,
} from '../../hooks/useSetup';
import { formatMoney } from '../../lib/invoiceUtils';
import { Dialog } from '../ui/dialog';
import type { BusinessNature } from '../../types/setup';
import type { CreateItemRequest } from '../../types/item';

interface Props {
  businessNature?: BusinessNature;
  onBack: () => void;
  onComplete: () => void;
}

interface ItemRow {
  sku: string;
  name: string;
  unitOfMeasure: string;
  hsnCode: string;
  purchasePrice: string;
  salePrice: string;
  reorderLevel: string;
}

const COMMON_UOMS = ['PCS', 'NOS', 'KG', 'LTR', 'BOX', 'MTR', 'PACK', 'SET'];

export const Phase3InventoryStep: React.FC<Props> = ({
  businessNature,
  onBack,
  onComplete,
}) => {
  const { data: profile } = useCompanyProfile();
  const { data: openingBalance } = useOpeningBalance();
  const { warehouses, isLoading: loadingWh } = useWarehouses();
  const createWhMutation = useCreateWarehouse();
  const { items, isLoading: loadingItems } = useItems();
  const createBulkMutation = useCreateBulkItems();
  const { data: openingStockData, isLoading: loadingStock } = useOpeningStock();
  const postStockMutation = usePostOpeningStock();
  const completeMutation = useCompleteSetup();

  // Internal Sub-step navigation: 'WAREHOUSE' | 'ITEMS' | 'STOCK' | 'FINISH'
  const [subStep, setSubStep] = useState<'WAREHOUSE' | 'ITEMS' | 'STOCK' | 'FINISH'>('WAREHOUSE');

  // Warehouse State
  const [whName, setWhName] = useState('Main Godown / मुख्य गोदाम');
  const [whCode, setWhCode] = useState('MAIN');
  const [selectedWarehouseId, setSelectedWarehouseId] = useState<number | null>(null);

  // Items State
  const [rows, setRows] = useState<ItemRow[]>([
    {
      sku: 'ITEM-001',
      name: '',
      unitOfMeasure: 'PCS',
      hsnCode: '',
      purchasePrice: '',
      salePrice: '',
      reorderLevel: '10',
    },
    {
      sku: 'ITEM-002',
      name: '',
      unitOfMeasure: 'PCS',
      hsnCode: '',
      purchasePrice: '',
      salePrice: '',
      reorderLevel: '10',
    },
  ]);
  const [pasteModalOpen, setPasteModalOpen] = useState(false);
  const [pasteText, setPasteText] = useState('');

  // Opening Stock State
  const [openingDate, setOpeningDate] = useState(() => {
    const today = new Date();
    const year = today.getMonth() >= 6 ? today.getFullYear() : today.getFullYear() - 1;
    return `${year}-07-17`;
  });
  const [stockInputs, setStockInputs] = useState<Record<number, { qty: string; cost: string }>>({});

  // Auto-select warehouse when loaded
  useEffect(() => {
    if (warehouses && warehouses.length > 0 && !selectedWarehouseId) {
      const def = warehouses.find((w) => w.defaultWarehouse) || warehouses[0];
      setSelectedWarehouseId(def.id);
    }
  }, [warehouses, selectedWarehouseId]);

  // If opening stock is already posted, we can default to FINISH or show stock
  useEffect(() => {
    if (openingStockData?.posted && subStep === 'WAREHOUSE') {
      // Default to review or finish
    }
  }, [openingStockData, subStep]);

  // Initial populate of stock inputs when items change
  useEffect(() => {
    if (items.length > 0) {
      setStockInputs((prev) => {
        const next = { ...prev };
        items.forEach((item) => {
          if (!next[item.id]) {
            next[item.id] = {
              qty: '',
              cost: item.purchasePrice ? String(item.purchasePrice) : '',
            };
          }
        });
        return next;
      });
    }
  }, [items]);

  // ==================== WAREHOUSE HANDLERS ====================
  const handleWarehouseContinue = async () => {
    if (selectedWarehouseId) {
      setSubStep('ITEMS');
      return;
    }

    if (!whName.trim() || !whCode.trim()) return;

    try {
      const created = await createWhMutation.mutateAsync({
        name: whName.trim(),
        code: whCode.trim().toUpperCase(),
        isDefault: true,
      });
      setSelectedWarehouseId(created.id);
      setSubStep('ITEMS');
    } catch {
      // Handled by toast
    }
  };

  // ==================== ITEM HANDLERS ====================
  const addRow = () => {
    const nextIdx = rows.length + 1;
    const padded = String(nextIdx).padStart(3, '0');
    setRows([
      ...rows,
      {
        sku: `ITEM-${padded}`,
        name: '',
        unitOfMeasure: 'PCS',
        hsnCode: '',
        purchasePrice: '',
        salePrice: '',
        reorderLevel: '10',
      },
    ]);
  };

  const removeRow = (idx: number) => {
    if (rows.length === 1) return;
    setRows(rows.filter((_, i) => i !== idx));
  };

  const updateRow = (idx: number, field: keyof ItemRow, val: string) => {
    const copy = [...rows];
    copy[idx][field] = val;
    setRows(copy);
  };

  const handlePasteData = () => {
    if (!pasteText.trim()) return;
    const lines = pasteText.trim().split(/\r?\n/);
    const parsed: ItemRow[] = [];

    lines.forEach((line, i) => {
      // Split by tab or comma
      const parts = line.includes('\t') ? line.split('\t') : line.split(',');
      if (parts.length >= 2) {
        const sku = parts[0]?.trim() || `ITEM-${String(rows.length + i + 1).padStart(3, '0')}`;
        const name = parts[1]?.trim() || '';
        const uom = parts[2]?.trim().toUpperCase() || 'PCS';
        const purchase = parts[3]?.trim() || '';
        const sale = parts[4]?.trim() || '';
        const hsn = parts[5]?.trim() || '';
        const reorder = parts[6]?.trim() || '10';

        if (name) {
          parsed.push({
            sku,
            name,
            unitOfMeasure: COMMON_UOMS.includes(uom) ? uom : 'PCS',
            hsnCode: hsn,
            purchasePrice: purchase,
            salePrice: sale,
            reorderLevel: reorder,
          });
        }
      }
    });

    if (parsed.length > 0) {
      setRows((prev) => [...prev.filter((r) => r.name.trim() !== ''), ...parsed]);
      setPasteModalOpen(false);
      setPasteText('');
    }
  };

  const handleSaveItems = async () => {
    const validRows = rows.filter((r) => r.sku.trim() && r.name.trim());
    if (validRows.length === 0) {
      // If user left all blank, skip to stock or finish
      setSubStep('STOCK');
      return;
    }

    const payload: CreateItemRequest[] = validRows.map((r) => ({
      sku: r.sku.trim(),
      name: r.name.trim(),
      unitOfMeasure: r.unitOfMeasure,
      hsnCode: r.hsnCode.trim() || undefined,
      tracksInventory: true,
      purchasePrice: r.purchasePrice ? parseFloat(r.purchasePrice) : undefined,
      salePrice: r.salePrice ? parseFloat(r.salePrice) : undefined,
      reorderLevel: r.reorderLevel ? parseFloat(r.reorderLevel) : undefined,
    }));

    try {
      await createBulkMutation.mutateAsync(payload);
      setSubStep('STOCK');
    } catch {
      // Handled by toast
    }
  };

  // ==================== OPENING STOCK HANDLERS ====================
  const updateStockInput = (itemId: number, field: 'qty' | 'cost', val: string) => {
    setStockInputs((prev) => ({
      ...prev,
      [itemId]: {
        ...prev[itemId],
        [field]: val,
      },
    }));
  };

  const parseNum = (v: string | undefined) => {
    if (!v) return 0;
    const n = parseFloat(v.replace(/,/g, '').trim());
    return isNaN(n) ? 0 : n;
  };

  // Calculate stock totals
  const stockLinesToPost = items
    .filter((item) => {
      const input = stockInputs[item.id];
      return input && parseNum(input.qty) > 0;
    })
    .map((item) => {
      const input = stockInputs[item.id];
      const qty = parseNum(input.qty);
      const cost = parseNum(input.cost);
      return {
        itemId: item.id,
        quantity: qty,
        unitCost: cost,
        total: qty * cost,
      };
    });

  const totalStockQty = stockLinesToPost.reduce((sum, l) => sum + l.quantity, 0);
  const totalStockVal = stockLinesToPost.reduce((sum, l) => sum + l.total, 0);

  const handlePostOpeningStock = async () => {
    if (stockLinesToPost.length === 0) {
      setSubStep('FINISH');
      return;
    }

    if (!selectedWarehouseId) return;

    try {
      await postStockMutation.mutateAsync({
        openingDate,
        warehouseId: selectedWarehouseId,
        lines: stockLinesToPost.map((l) => ({
          itemId: l.itemId,
          quantity: l.quantity,
          unitCost: l.unitCost,
        })),
      });
      setSubStep('FINISH');
    } catch {
      // Handled by toast
    }
  };

  const handleCompleteAll = async () => {
    try {
      await completeMutation.mutateAsync();
      onComplete();
    } catch {
      // Handled by toast
    }
  };

  if (loadingWh || loadingItems || loadingStock) {
    return (
      <div className="flex items-center justify-center min-h-[40vh]">
        <div className="text-center">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600 mx-auto mb-3" />
          <p className="text-sm text-neutral-500 font-serif">
            गोदाम तथा मौज्दात विवरण लोड हुँदैछ... (Loading Inventory Setup...)
          </p>
        </div>
      </div>
    );
  }

  // ==================== SUB-STEP 1: WAREHOUSE ====================
  if (subStep === 'WAREHOUSE') {
    return (
      <div className="space-y-6">
        <div className="bg-white dark:bg-neutral-900 border border-neutral-300 dark:border-neutral-800 rounded-lg p-6 shadow-sm">
          <div className="flex items-start gap-4 pb-5 border-b border-neutral-200 dark:border-neutral-800">
            <div className="w-12 h-12 rounded-lg bg-blue-50 dark:bg-blue-950/50 border border-blue-200 dark:border-blue-800 flex items-center justify-center text-blue-700 dark:text-blue-300 flex-shrink-0">
              <Warehouse className="w-6 h-6" />
            </div>
            <div>
              <div className="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full bg-blue-50 dark:bg-blue-950/40 text-blue-700 dark:text-blue-300 border border-blue-200 dark:border-blue-800 text-xs font-semibold mb-1">
                <span>चरण ३.१: मुख्य गोदाम (Main Warehouse Setup)</span>
              </div>
              <h2 className="text-xl font-serif font-bold text-neutral-900 dark:text-neutral-100">
                सामान भण्डारण स्थान (Default Warehouse / Godown)
              </h2>
              <p className="text-xs text-neutral-600 dark:text-neutral-400 mt-1">
                बिक्री हुने सामान, खरिद दाखिला र स्टक गणनाका लागि तपाईंको मुख्य गोदाम दर्ता गर्नुहोस्।
              </p>
            </div>
          </div>

          {/* If Service Business Nature, show smart skip recommendation */}
          {businessNature === 'SERVICE' && (
            <div className="mt-5 p-4 rounded-lg bg-amber-50 dark:bg-amber-950/40 border border-amber-200 dark:border-amber-900/60 flex items-start gap-3 text-xs text-amber-900 dark:text-amber-200">
              <AlertCircle className="w-5 h-5 text-amber-600 flex-shrink-0 mt-0.5" />
              <div>
                <p className="font-bold text-sm mb-1">
                  सेवामूलक व्यवसाय (Service Business Alert)
                </p>
                <p className="leading-relaxed opacity-95">
                  तपाईंको व्यवसाय सेवामूलक (Service) प्रकृतिको भएकाले मौज्दात (Inventory) ट्र्याकिङ अनिवार्य छैन। तपाईं सिधै सेटअप पूरा गर्न सक्नुहुन्छ वा आवश्यक भए गोदाम राख्न सक्नुहुन्छ।
                </p>
                <button
                  type="button"
                  onClick={() => setSubStep('FINISH')}
                  className="mt-2.5 inline-flex items-center gap-1.5 px-3 py-1.5 rounded bg-amber-600 hover:bg-amber-700 text-white font-semibold text-xs shadow-sm"
                >
                  <span>मौज्दात सेटअप छोड्नुहोस् (Skip to Finish Setup)</span>
                  <ArrowRight className="w-3.5 h-3.5" />
                </button>
              </div>
            </div>
          )}

          <div className="grid grid-cols-1 md:grid-cols-2 gap-5 mt-6">
            <div>
              <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
                Warehouse / Godown Name (गोदामको नाम) <span className="text-rose-600">*</span>
              </label>
              <input
                type="text"
                value={whName}
                onChange={(e) => setWhName(e.target.value)}
                placeholder="Main Godown / मुख्य गोदाम"
                className="w-full px-3 py-2 text-sm border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500 font-serif"
              />
              <p className="text-[11px] text-neutral-500 mt-1">
                उदाहरण: Main Godown, Birgunj Depot, Kathmandu Store
              </p>
            </div>

            <div>
              <label className="block text-xs font-semibold text-neutral-700 dark:text-neutral-300 mb-1">
                Warehouse Code (संक्षिप्त संकेत) <span className="text-rose-600">*</span>
              </label>
              <input
                type="text"
                value={whCode}
                onChange={(e) => setWhCode(e.target.value.toUpperCase())}
                placeholder="MAIN"
                className="w-full px-3 py-2 text-sm font-mono uppercase font-bold border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500"
              />
              <p className="text-[11px] text-neutral-500 mt-1">
                बीजक तथा ट्रान्सफर भौचरमा प्रयोग हुने ३-६ अक्षरको कोड
              </p>
            </div>
          </div>
        </div>

        {/* Action Bar */}
        <div className="flex flex-col sm:flex-row items-center justify-between gap-4 bg-white dark:bg-neutral-900 border border-neutral-300 dark:border-neutral-800 rounded-lg p-5 shadow-sm">
          <button
            type="button"
            onClick={onBack}
            className="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-4 py-2 text-sm font-semibold text-neutral-700 dark:text-neutral-300 hover:bg-neutral-100 dark:hover:bg-neutral-800 rounded border border-neutral-300 dark:border-neutral-700 transition-colors"
          >
            <ArrowLeft className="w-4 h-4" />
            <span>पछाडि फर्कनुहोस् (Back to Opening Balances)</span>
          </button>

          <div className="flex items-center gap-3 w-full sm:w-auto">
            <button
              type="button"
              onClick={() => setSubStep('FINISH')}
              className="px-4 py-2 text-sm font-semibold text-neutral-600 dark:text-neutral-400 hover:text-neutral-900 dark:hover:text-neutral-100 transition-colors"
            >
              अहिलेलाई छोड्नुहोस् (Skip Inventory)
            </button>

            <button
              type="button"
              onClick={handleWarehouseContinue}
              disabled={createWhMutation.isPending || (!selectedWarehouseId && (!whName.trim() || !whCode.trim()))}
              className="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-6 py-2.5 text-sm font-semibold text-white bg-primary-700 hover:bg-primary-800 active:bg-primary-900 rounded shadow-sm transition-colors disabled:opacity-50"
            >
              <span>अगाडि बढ्नुहोस्: सामान सूची (Continue to Items)</span>
              <ArrowRight className="w-4 h-4" />
            </button>
          </div>
        </div>
      </div>
    );
  }

  // ==================== SUB-STEP 2: ITEMS BULK ====================
  if (subStep === 'ITEMS') {
    return (
      <div className="space-y-6">
        <div className="bg-white dark:bg-neutral-900 border border-neutral-300 dark:border-neutral-800 rounded-lg p-6 shadow-sm">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-5 border-b border-neutral-200 dark:border-neutral-800">
            <div className="flex items-start gap-3">
              <div className="w-10 h-10 rounded-lg bg-primary-50 dark:bg-primary-950/50 border border-primary-200 dark:border-primary-800 flex items-center justify-center text-primary-700 dark:text-primary-300 flex-shrink-0">
                <Boxes className="w-5 h-5" />
              </div>
              <div>
                <div className="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full bg-primary-50 dark:bg-primary-950/40 text-primary-700 dark:text-primary-300 border border-primary-200 dark:border-primary-800 text-xs font-semibold mb-1">
                  <span>चरण ३.२: उत्पादन तथा सामान (Add Items in Bulk)</span>
                </div>
                <h2 className="text-xl font-serif font-bold text-neutral-900 dark:text-neutral-100">
                  सामान सूची दर्ता (Items Quick-add Table)
                </h2>
                <p className="text-xs text-neutral-600 dark:text-neutral-400 mt-1">
                  तपाईंले बिक्री तथा खरिद गर्ने सामानहरू थप्नुहोस्। पछि थप सामानहरू सामान व्यवस्थापन खण्डबाट पनि थप्न सकिनेछ।
                </p>
              </div>
            </div>

            <div className="flex items-center gap-2">
              <button
                type="button"
                onClick={() => setPasteModalOpen(true)}
                className="inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-semibold rounded bg-neutral-100 hover:bg-neutral-200 dark:bg-neutral-800 dark:hover:bg-neutral-700 text-neutral-800 dark:text-neutral-200 border border-neutral-300 dark:border-neutral-700 transition-colors"
              >
                <ClipboardPaste className="w-3.5 h-3.5" />
                <span>Excel / CSV बाट टाँस्नुहोस् (Paste)</span>
              </button>

              <button
                type="button"
                onClick={addRow}
                className="inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-semibold rounded bg-primary-50 hover:bg-primary-100 dark:bg-primary-950/40 dark:hover:bg-primary-900/50 text-primary-700 dark:text-primary-300 border border-primary-300 dark:border-primary-800 transition-colors"
              >
                <Plus className="w-3.5 h-3.5" />
                <span>नयाँ पंक्ति (Add Row)</span>
              </button>
            </div>
          </div>

          {/* Bulk Grid */}
          <div className="overflow-x-auto mt-4 border border-neutral-200 dark:border-neutral-800 rounded-lg">
            <table className="w-full text-left text-xs">
              <thead className="bg-neutral-50 dark:bg-neutral-800/60 text-neutral-600 dark:text-neutral-400 font-semibold border-b border-neutral-200 dark:border-neutral-800 uppercase tracking-wider text-[11px]">
                <tr>
                  <th className="py-2.5 px-3 w-10">#</th>
                  <th className="py-2.5 px-3 min-w-[120px]">SKU / संकेत *</th>
                  <th className="py-2.5 px-3 min-w-[200px]">सामानको नाम (Item Name) *</th>
                  <th className="py-2.5 px-3 w-28">एकाइ (UOM)</th>
                  <th className="py-2.5 px-3 w-28">HSN कोड</th>
                  <th className="py-2.5 px-3 min-w-[110px]">खरिद दर (Cost)</th>
                  <th className="py-2.5 px-3 min-w-[110px]">बिक्री दर (Price)</th>
                  <th className="py-2.5 px-3 w-10 text-center"></th>
                </tr>
              </thead>
              <tbody className="divide-y divide-neutral-200 dark:divide-neutral-800">
                {rows.map((row, idx) => (
                  <tr key={idx} className="hover:bg-neutral-50/50 dark:hover:bg-neutral-800/30">
                    <td className="py-2 px-3 font-mono text-neutral-400">{idx + 1}</td>
                    <td className="py-1.5 px-2">
                      <input
                        type="text"
                        value={row.sku}
                        onChange={(e) => updateRow(idx, 'sku', e.target.value.toUpperCase())}
                        placeholder="SKU-001"
                        className="w-full px-2 py-1 font-mono uppercase font-semibold text-xs border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500"
                      />
                    </td>
                    <td className="py-1.5 px-2">
                      <input
                        type="text"
                        value={row.name}
                        onChange={(e) => updateRow(idx, 'name', e.target.value)}
                        placeholder="e.g. Dell Monitor 24-inch"
                        className="w-full px-2 py-1 text-xs border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500"
                      />
                    </td>
                    <td className="py-1.5 px-2">
                      <select
                        value={row.unitOfMeasure}
                        onChange={(e) => updateRow(idx, 'unitOfMeasure', e.target.value)}
                        className="w-full px-2 py-1 text-xs border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500"
                      >
                        {COMMON_UOMS.map((u) => (
                          <option key={u} value={u}>
                            {u}
                          </option>
                        ))}
                      </select>
                    </td>
                    <td className="py-1.5 px-2">
                      <input
                        type="text"
                        value={row.hsnCode}
                        onChange={(e) => updateRow(idx, 'hsnCode', e.target.value)}
                        placeholder="8471"
                        className="w-full px-2 py-1 font-mono text-xs border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500"
                      />
                    </td>
                    <td className="py-1.5 px-2">
                      <input
                        type="number"
                        step="0.01"
                        value={row.purchasePrice}
                        onChange={(e) => updateRow(idx, 'purchasePrice', e.target.value)}
                        placeholder="0.00"
                        className="w-full px-2 py-1 font-mono text-xs text-right border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500"
                      />
                    </td>
                    <td className="py-1.5 px-2">
                      <input
                        type="number"
                        step="0.01"
                        value={row.salePrice}
                        onChange={(e) => updateRow(idx, 'salePrice', e.target.value)}
                        placeholder="0.00"
                        className="w-full px-2 py-1 font-mono text-xs text-right border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500"
                      />
                    </td>
                    <td className="py-2 px-2 text-center">
                      <button
                        type="button"
                        onClick={() => removeRow(idx)}
                        disabled={rows.length === 1}
                        className="text-neutral-400 hover:text-rose-600 disabled:opacity-20 cursor-pointer"
                        title="Delete row"
                      >
                        <Trash2 className="w-3.5 h-3.5" />
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* Action Bar */}
        <div className="flex flex-col sm:flex-row items-center justify-between gap-4 bg-white dark:bg-neutral-900 border border-neutral-300 dark:border-neutral-800 rounded-lg p-5 shadow-sm">
          <button
            type="button"
            onClick={() => setSubStep('WAREHOUSE')}
            className="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-4 py-2 text-sm font-semibold text-neutral-700 dark:text-neutral-300 hover:bg-neutral-100 dark:hover:bg-neutral-800 rounded border border-neutral-300 dark:border-neutral-700 transition-colors"
          >
            <ArrowLeft className="w-4 h-4" />
            <span>गोदाममा फर्कनुहोस् (Back to Warehouse)</span>
          </button>

          <div className="flex items-center gap-3 w-full sm:w-auto">
            <button
              type="button"
              onClick={() => setSubStep('STOCK')}
              className="px-4 py-2 text-sm font-semibold text-neutral-600 dark:text-neutral-400 hover:text-neutral-900 dark:hover:text-neutral-100 transition-colors"
            >
              छोड्नुहोस् (Skip to Stock Entry)
            </button>

            <button
              type="button"
              onClick={handleSaveItems}
              disabled={createBulkMutation.isPending}
              className="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-6 py-2.5 text-sm font-semibold text-white bg-primary-700 hover:bg-primary-800 active:bg-primary-900 rounded shadow-sm transition-colors disabled:opacity-50"
            >
              {createBulkMutation.isPending ? (
                <span>सुरक्षित गर्दैछ... (Saving...)</span>
              ) : (
                <>
                  <span>सामान सुरक्षित गरी मौज्दातमा जानुहोस् (Save & Next: Opening Stock)</span>
                  <ArrowRight className="w-4 h-4" />
                </>
              )}
            </button>
          </div>
        </div>

        {/* Paste from Excel Dialog */}
        <Dialog
          open={pasteModalOpen}
          onClose={() => setPasteModalOpen(false)}
          title="Excel वा CSV बाट सामान टाँस्नुहोस् (Paste Items)"
          description="Excel बाट कोलमहरू सिधै कपी गरेर यहाँ पेस्ट गर्नुहोस्।"
        >
          <div className="space-y-4">
            <p className="text-xs text-neutral-600 dark:text-neutral-400">
              कोलमको क्रम: <strong>SKU [ट्याब] Name [ट्याब] UOM [ट्याब] Purchase [ट्याब] Sale</strong>
            </p>
            <textarea
              value={pasteText}
              onChange={(e) => setPasteText(e.target.value)}
              placeholder="ITEM-001	Wireless Mouse	PCS	450	750&#10;ITEM-002	Mechanical Keyboard	PCS	1500	2400"
              rows={8}
              className="w-full p-2.5 text-xs font-mono border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500"
            />
            <div className="flex items-center justify-end gap-3 pt-3 border-t border-neutral-200 dark:border-neutral-800">
              <button
                type="button"
                onClick={() => setPasteModalOpen(false)}
                className="px-4 py-1.5 text-xs font-semibold text-neutral-600 dark:text-neutral-400 hover:bg-neutral-100 rounded border border-neutral-300"
              >
                रद्द गर्नुहोस् (Cancel)
              </button>
              <button
                type="button"
                onClick={handlePasteData}
                disabled={!pasteText.trim()}
                className="px-4 py-1.5 text-xs font-semibold text-white bg-primary-700 hover:bg-primary-800 rounded disabled:opacity-50"
              >
                टाँसिएको डाटा आयात गर्नुहोस् (Import Data)
              </button>
            </div>
          </div>
        </Dialog>
      </div>
    );
  }

  // ==================== SUB-STEP 3: OPENING STOCK ====================
  if (subStep === 'STOCK') {
    return (
      <div className="space-y-6">
        <div className="bg-white dark:bg-neutral-900 border border-neutral-300 dark:border-neutral-800 rounded-lg p-6 shadow-sm">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-5 border-b border-neutral-200 dark:border-neutral-800">
            <div className="flex items-start gap-3">
              <div className="w-10 h-10 rounded-lg bg-emerald-50 dark:bg-emerald-950/50 border border-emerald-200 dark:border-emerald-800 flex items-center justify-center text-emerald-700 dark:text-emerald-300 flex-shrink-0">
                <Layers className="w-5 h-5" />
              </div>
              <div>
                <div className="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full bg-emerald-50 dark:bg-emerald-950/40 text-emerald-700 dark:text-emerald-300 border border-emerald-200 dark:border-emerald-800 text-xs font-semibold mb-1">
                  <span>चरण ३.३: सुरुवाती मौज्दात (Opening Stock Quantity & Cost)</span>
                </div>
                <h2 className="text-xl font-serif font-bold text-neutral-900 dark:text-neutral-100">
                  प्रारम्भिक स्टक तथा लागत गणना (Initial Stock Valuation)
                </h2>
                <p className="text-xs text-neutral-600 dark:text-neutral-400 mt-1">
                  हरेक सामानको हाल गोदाममा रहेको परिमाण र खरिद लागत राख्नुहोस्। यसले <strong>OPENING</strong> भौचर मार्फत लेजरमा सम्पत्ति दर्ता गर्दछ।
                </p>
              </div>
            </div>

            <div className="flex items-center gap-2">
              <label className="text-xs font-semibold text-neutral-700 dark:text-neutral-300">
                स्टक मिति:
              </label>
              <input
                type="date"
                value={openingDate}
                onChange={(e) => setOpeningDate(e.target.value)}
                className="px-2.5 py-1 text-xs font-mono border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500"
              />
            </div>
          </div>

          {items.length === 0 ? (
            <div className="py-12 text-center text-neutral-500 text-sm font-serif">
              <p>हाल कुनै सामान दर्ता गरिएको छैन।</p>
              <button
                type="button"
                onClick={() => setSubStep('ITEMS')}
                className="mt-2 text-primary-600 underline text-xs"
              >
                ← पहिले सामान थप्नुहोस्
              </button>
            </div>
          ) : (
            <div className="overflow-x-auto mt-4 border border-neutral-200 dark:border-neutral-800 rounded-lg">
              <table className="w-full text-left text-xs">
                <thead className="bg-neutral-50 dark:bg-neutral-800/60 text-neutral-600 dark:text-neutral-400 font-semibold border-b border-neutral-200 dark:border-neutral-800 uppercase tracking-wider text-[11px]">
                  <tr>
                    <th className="py-2.5 px-3 w-10">#</th>
                    <th className="py-2.5 px-3 min-w-[120px]">SKU</th>
                    <th className="py-2.5 px-3 min-w-[200px]">सामानको नाम (Item Name)</th>
                    <th className="py-2.5 px-3 w-20">UOM</th>
                    <th className="py-2.5 px-3 min-w-[120px]">सुरुवाती परिमाण (Qty)</th>
                    <th className="py-2.5 px-3 min-w-[130px]">प्रति एकाइ लागत (Cost)</th>
                    <th className="py-2.5 px-3 min-w-[140px] text-right">कुल रकम (Total Value)</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-neutral-200 dark:divide-neutral-800">
                  {items.map((item, idx) => {
                    const input = stockInputs[item.id] || { qty: '', cost: '' };
                    const q = parseNum(input.qty);
                    const c = parseNum(input.cost);
                    const lineTotal = q * c;

                    return (
                      <tr key={item.id} className="hover:bg-neutral-50/50 dark:hover:bg-neutral-800/30">
                        <td className="py-2 px-3 font-mono text-neutral-400">{idx + 1}</td>
                        <td className="py-2 px-3 font-mono font-bold text-neutral-800 dark:text-neutral-200">
                          {item.sku}
                        </td>
                        <td className="py-2 px-3 font-semibold text-neutral-900 dark:text-neutral-100">
                          {item.name}
                        </td>
                        <td className="py-2 px-3 text-neutral-500 font-mono">{item.unitOfMeasure}</td>
                        <td className="py-1.5 px-2">
                          <input
                            type="number"
                            step="any"
                            value={input.qty}
                            onChange={(e) => updateStockInput(item.id, 'qty', e.target.value)}
                            placeholder="0"
                            className="w-full px-2 py-1 font-mono text-xs border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500 text-right"
                          />
                        </td>
                        <td className="py-1.5 px-2">
                          <input
                            type="number"
                            step="0.01"
                            value={input.cost}
                            onChange={(e) => updateStockInput(item.id, 'cost', e.target.value)}
                            placeholder="0.00"
                            className="w-full px-2 py-1 font-mono text-xs border border-neutral-300 dark:border-neutral-700 rounded bg-white dark:bg-neutral-900 text-neutral-900 dark:text-neutral-100 focus:outline-none focus:ring-1 focus:ring-primary-500 text-right"
                          />
                        </td>
                        <td className="py-2 px-3 font-mono font-bold text-right text-emerald-700 dark:text-emerald-400">
                          {formatMoney(lineTotal.toFixed(2))}
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          )}

          {/* Double Entry Posting Note */}
          <div className="mt-5 p-4 rounded-lg bg-emerald-50 dark:bg-emerald-950/30 border border-emerald-200 dark:border-emerald-800 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
            <div className="space-y-1">
              <div className="text-xs font-bold text-emerald-900 dark:text-emerald-200 flex items-center gap-1.5">
                <Sparkles className="w-4 h-4 text-emerald-600" />
                <span>लेखा भौचर प्रविष्टि (Automatic Double-Entry Voucher):</span>
              </div>
              <div className="text-xs text-neutral-600 dark:text-neutral-400 font-mono">
                Dr. INVENTORY_ASSET ({formatMoney(totalStockVal.toFixed(2))}) / Cr. CAPITAL ({formatMoney(totalStockVal.toFixed(2))})
              </div>
            </div>

            <div className="text-right">
              <div className="text-[11px] text-neutral-500 uppercase font-semibold">कुल मौज्दात मूल्य</div>
              <div className="font-mono text-lg font-bold text-emerald-700 dark:text-emerald-300">
                {formatMoney(totalStockVal.toFixed(2))}
              </div>
              <div className="text-[10px] text-neutral-500 font-mono">
                कुल संख्या: {totalStockQty} • वस्तुहरू: {stockLinesToPost.length}
              </div>
            </div>
          </div>
        </div>

        {/* Action Bar */}
        <div className="flex flex-col sm:flex-row items-center justify-between gap-4 bg-white dark:bg-neutral-900 border border-neutral-300 dark:border-neutral-800 rounded-lg p-5 shadow-sm">
          <button
            type="button"
            onClick={() => setSubStep('ITEMS')}
            className="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-4 py-2 text-sm font-semibold text-neutral-700 dark:text-neutral-300 hover:bg-neutral-100 dark:hover:bg-neutral-800 rounded border border-neutral-300 dark:border-neutral-700 transition-colors"
          >
            <ArrowLeft className="w-4 h-4" />
            <span>सामान सूचीमा फर्कनुहोस् (Back to Items)</span>
          </button>

          <div className="flex items-center gap-3 w-full sm:w-auto">
            <button
              type="button"
              onClick={() => setSubStep('FINISH')}
              className="px-4 py-2 text-sm font-semibold text-neutral-600 dark:text-neutral-400 hover:text-neutral-900 dark:hover:text-neutral-100 transition-colors"
            >
              छोड्नुहोस् (Skip Stock Entry)
            </button>

            <button
              type="button"
              onClick={handlePostOpeningStock}
              disabled={postStockMutation.isPending}
              className="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-6 py-2.5 text-sm font-semibold text-white bg-primary-700 hover:bg-primary-800 active:bg-primary-900 rounded shadow-sm transition-colors disabled:opacity-50"
            >
              {postStockMutation.isPending ? (
                <span>दर्ता गर्दैछ... (Posting Stock...)</span>
              ) : (
                <>
                  <span>मौज्दात दर्ता गरी सम्पन्न गर्नुहोस् (Post Stock & Finish)</span>
                  <ArrowRight className="w-4 h-4" />
                </>
              )}
            </button>
          </div>
        </div>
      </div>
    );
  }

  // ==================== SUB-STEP 4: FINISH SCREEN ====================
  return (
    <div className="space-y-6">
      <div className="bg-white dark:bg-neutral-900 border border-emerald-300 dark:border-emerald-800 rounded-lg p-6 sm:p-8 shadow-sm">
        <div className="flex items-start gap-4 pb-6 border-b border-neutral-200 dark:border-neutral-800">
          <div className="w-14 h-14 rounded-full bg-emerald-100 dark:bg-emerald-950/60 border border-emerald-300 dark:border-emerald-700 flex items-center justify-center text-emerald-600 dark:text-emerald-400 flex-shrink-0">
            <CheckCircle2 className="w-8 h-8" />
          </div>
          <div>
            <div className="inline-flex items-center gap-1.5 px-3 py-0.5 rounded-full bg-emerald-50 dark:bg-emerald-950/40 text-emerald-700 dark:text-emerald-300 border border-emerald-200 dark:border-emerald-800 text-xs font-semibold mb-1.5">
              <Sparkles className="w-3.5 h-3.5" />
              <span>सेटअप पूर्ण रूपमा सम्पन्न (Setup Complete!)</span>
            </div>
            <h2 className="text-2xl font-serif font-bold text-neutral-900 dark:text-neutral-100">
              बधाई छ! तपाईंको व्यापार SAISA मा सञ्चालनका लागि तयार छ।
            </h2>
            <p className="text-sm text-neutral-600 dark:text-neutral-400 mt-1">
              कम्पनी प्रोफाइल, सुरुआती वित्तीय मौज्दात र गोदाम व्यवस्थापन सुरक्षित भइसकेको छ।
            </p>
          </div>
        </div>

        {/* Setup Summary Overview */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 my-6">
          <div className="p-4 rounded-lg bg-neutral-50 dark:bg-neutral-800/40 border border-neutral-200 dark:border-neutral-800">
            <div className="text-xs text-neutral-500 font-semibold mb-1">
              १. व्यापार प्रोफाइल (Profile)
            </div>
            <div className="font-bold text-sm text-neutral-900 dark:text-neutral-100 truncate">
              {profile?.companyName || 'Registered'}
            </div>
            <div className="text-[11px] text-neutral-500 font-mono mt-0.5">
              PAN: {profile?.panVatNo || profile?.pan || '—'}
            </div>
          </div>

          <div className="p-4 rounded-lg bg-neutral-50 dark:bg-neutral-800/40 border border-neutral-200 dark:border-neutral-800">
            <div className="text-xs text-neutral-500 font-semibold mb-1">
              २. प्रारम्भिक मौज्दात (Balance)
            </div>
            <div className="font-bold text-sm text-emerald-700 dark:text-emerald-400">
              {openingBalance?.posted ? 'दर्ता भयो (Posted)' : 'छोडिएको (Skipped)'}
            </div>
            <div className="text-[11px] text-neutral-500 font-mono mt-0.5">
              {openingBalance?.journalEntryNumber ? `भौचर: ${openingBalance.journalEntryNumber}` : '—'}
            </div>
          </div>

          <div className="p-4 rounded-lg bg-neutral-50 dark:bg-neutral-800/40 border border-neutral-200 dark:border-neutral-800">
            <div className="text-xs text-neutral-500 font-semibold mb-1">
              ३. गोदाम (Warehouse)
            </div>
            <div className="font-bold text-sm text-neutral-900 dark:text-neutral-100">
              {warehouses.length > 0 ? warehouses[0].name : whName}
            </div>
            <div className="text-[11px] text-neutral-500 font-mono mt-0.5">
              Code: {warehouses.length > 0 ? warehouses[0].code : whCode}
            </div>
          </div>

          <div className="p-4 rounded-lg bg-neutral-50 dark:bg-neutral-800/40 border border-neutral-200 dark:border-neutral-800">
            <div className="text-xs text-neutral-500 font-semibold mb-1">
              ४. मौज्दात सामान (Inventory)
            </div>
            <div className="font-bold text-sm text-blue-700 dark:text-blue-400">
              {items.length} सामानहरू दर्ता
            </div>
            <div className="text-[11px] text-neutral-500 font-mono mt-0.5">
              स्टक: {totalStockVal > 0 ? formatMoney(totalStockVal.toFixed(2)) : '—'}
            </div>
          </div>
        </div>

        {/* Final CTA Bar */}
        <div className="pt-6 border-t border-neutral-200 dark:border-neutral-800 flex flex-col sm:flex-row items-center justify-between gap-4">
          <button
            type="button"
            onClick={() => setSubStep('STOCK')}
            className="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-4 py-2 text-sm font-semibold text-neutral-600 dark:text-neutral-400 hover:text-neutral-900 dark:hover:text-neutral-100 transition-colors"
          >
            <ArrowLeft className="w-4 h-4" />
            <span>मौज्दात विवरण सच्याउनुहोस् (Review Stock)</span>
          </button>

          <button
            type="button"
            onClick={handleCompleteAll}
            disabled={completeMutation.isPending}
            className="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-8 py-3 text-base font-bold text-white bg-emerald-600 hover:bg-emerald-700 active:bg-emerald-800 rounded-lg shadow transition-colors disabled:opacity-50"
          >
            <Sparkles className="w-5 h-5" />
            <span>ड्यासबोर्डमा जानुहोस् (Finish & Open Dashboard)</span>
            <ArrowRight className="w-5 h-5" />
          </button>
        </div>
      </div>
    </div>
  );
};
