import React, { useState, useEffect } from 'react';
import { toast } from 'sonner';
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
  Info,
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

const SUB_STEPS = [
  { key: 'WAREHOUSE', stepNum: 1, labelNp: '१. मुख्य गोदाम', labelEn: 'Warehouse', icon: Warehouse },
  { key: 'ITEMS', stepNum: 2, labelNp: '२. सामान सूची', labelEn: 'Items Quickstart', icon: Boxes },
  { key: 'STOCK', stepNum: 3, labelNp: '३. सुरुवाती स्टक', labelEn: 'Opening Stock', icon: Layers },
  { key: 'FINISH', stepNum: 4, labelNp: '४. सम्पन्न', labelEn: 'Finish Setup', icon: CheckCircle2 },
] as const;

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
  const { isLoading: loadingStock } = useOpeningStock();
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

    if (!whName.trim()) {
      toast.error('कृपया गोदामको नाम (Warehouse Name) अनिवार्य भर्नुहोस्।');
      return;
    }

    if (!whCode.trim()) {
      toast.error('कृपया गोदामको कोड (Warehouse Code) अनिवार्य भर्नुहोस्।');
      return;
    }

    try {
      const created = await createWhMutation.mutateAsync({
        name: whName.trim(),
        code: whCode.trim().toUpperCase(),
        isDefault: true,
      });
      setSelectedWarehouseId(created.id);
      toast.success('मुख्य गोदाम सफलतापूर्वक दर्ता गरियो।');
      setSubStep('ITEMS');
    } catch {
      // Handled by hook toast
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
      toast.success(`${parsed.length} वटा सामान सफलतापूर्वक आयात गरियो।`);
    } else {
      toast.error('कुनै मान्य डेटा भेटिएन। कृपया कोलम क्रम जाँच गर्नुहोस्।');
    }
  };

  const handleSaveItems = async () => {
    // Check partial rows
    for (let i = 0; i < rows.length; i++) {
      const r = rows[i];
      const hasAny = r.name.trim() || r.purchasePrice.trim() || r.salePrice.trim() || r.hsnCode.trim();
      if (hasAny && !r.name.trim()) {
        toast.error(`पङ्क्ति #${i + 1} मा सामानको नाम अनिवार्य भर्नुहोस्।`);
        return;
      }
      if (hasAny && !r.sku.trim()) {
        toast.error(`पङ्क्ति #${i + 1} मा SKU/संकेत अनिवार्य भर्नुहोस्।`);
        return;
      }
    }

    const validRows = rows.filter((r) => r.sku.trim() && r.name.trim());
    if (validRows.length === 0) {
      toast.info('कुनै सामान नथपिएकाले सुरुवाती स्टक चरणमा लगियो।');
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
      toast.success(`${validRows.length} वटा सामान सुरक्षित गरियो।`);
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
    for (const item of items) {
      const input = stockInputs[item.id];
      if (input) {
        const q = parseNum(input.qty);
        const c = parseNum(input.cost);
        if (q < 0 || c < 0) {
          toast.error(`सामान "${item.name}" को परिमाण वा लागत ० भन्दा कम हुन सक्दैन।`);
          return;
        }
      }
    }

    if (stockLinesToPost.length === 0) {
      toast.info('सुरुवाती स्टक शून्य राखिएको छ।');
      setSubStep('FINISH');
      return;
    }

    if (!selectedWarehouseId) {
      toast.error('कृपया पहिले गोदाम चयन गर्नुहोस्।');
      setSubStep('WAREHOUSE');
      return;
    }

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
      toast.success('प्रारम्भिक स्टक (Opening Stock) सफलतापूर्वक दर्ता गरियो।');
      setSubStep('FINISH');
    } catch {
      // Handled by toast
    }
  };

  const handleCompleteAll = async () => {
    try {
      await completeMutation.mutateAsync();
      toast.success('बधाई छ! SAISA सेटअप पूर्ण रूपमा सम्पन्न भयो।');
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

  return (
    <div className="space-y-6">
      {/* 4-Step Sub-navigation Stepper Bar */}
      <div className="bg-white border border-neutral-300 rounded-lg p-3 sm:p-4 shadow-sm">
        <div className="flex items-center justify-between gap-1 sm:gap-2">
          {SUB_STEPS.map((step, idx) => {
            const stepOrder = ['WAREHOUSE', 'ITEMS', 'STOCK', 'FINISH'];
            const currentIdx = stepOrder.indexOf(subStep);
            const isCompleted = idx < currentIdx;
            const isCurrent = step.key === subStep;

            return (
              <React.Fragment key={step.key}>
                <button
                  type="button"
                  onClick={() => setSubStep(step.key)}
                  className={`flex-1 flex items-center gap-2 sm:gap-3 p-2 rounded-lg text-left transition-all ${
                    isCurrent
                      ? 'bg-primary-50 border border-primary-300 text-primary-900 shadow-xs'
                      : isCompleted
                      ? 'bg-neutral-50 hover:bg-neutral-100 text-neutral-800'
                      : 'text-neutral-400 hover:text-neutral-600'
                  }`}
                >
                  <div
                    className={`w-7 h-7 sm:w-8 sm:h-8 rounded-full flex items-center justify-center text-xs font-bold flex-shrink-0 transition-colors ${
                      isCurrent
                        ? 'bg-primary-700 text-white'
                        : isCompleted
                        ? 'bg-emerald-600 text-white'
                        : 'bg-neutral-200 text-neutral-600'
                    }`}
                  >
                    {isCompleted ? '✓' : step.stepNum}
                  </div>
                  <div className="min-w-0 hidden md:block">
                    <p
                      className={`text-xs font-semibold truncate ${
                        isCurrent
                          ? 'text-primary-900 font-bold'
                          : isCompleted
                          ? 'text-neutral-900'
                          : 'text-neutral-500'
                      }`}
                    >
                      {step.labelNp}
                    </p>
                    <p className="text-[10px] text-neutral-500 truncate">{step.labelEn}</p>
                  </div>
                </button>

                {idx < SUB_STEPS.length - 1 && (
                  <div className="text-neutral-300 px-0.5 sm:px-1 flex-shrink-0">
                    <ArrowRight className="w-3.5 h-3.5" />
                  </div>
                )}
              </React.Fragment>
            );
          })}
        </div>
      </div>

      {/* ==================== SUB-STEP 1: WAREHOUSE ==================== */}
      {subStep === 'WAREHOUSE' && (
        <div className="space-y-6">
          <div className="bg-white border border-neutral-300 rounded-lg p-6 shadow-sm">
            <div className="flex items-start gap-4 pb-5 border-b border-neutral-200">
              <div className="w-12 h-12 rounded-lg bg-blue-50 border border-blue-200 flex items-center justify-center text-blue-700 flex-shrink-0">
                <Warehouse className="w-6 h-6" />
              </div>
              <div>
                <div className="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full bg-blue-50 text-blue-800 border border-blue-200 text-xs font-semibold mb-1">
                  <span>चरण ३.१: मुख्य गोदाम (Main Warehouse Setup)</span>
                </div>
                <h2 className="text-xl font-serif font-bold text-neutral-900">
                  सामान भण्डारण स्थान (Default Warehouse / Godown)
                </h2>
                <p className="text-xs text-neutral-600 mt-1">
                  बिक्री हुने सामान, खरिद दाखिला र स्टक गणनाका लागि तपाईंको मुख्य गोदाम दर्ता गर्नुहोस्।
                </p>
              </div>
            </div>

            {/* Informational Guidance Box */}
            <div className="mt-5 p-4 rounded-lg bg-blue-50 border border-blue-200 flex items-start gap-3 text-xs text-blue-900">
              <Info className="w-5 h-5 text-blue-600 flex-shrink-0 mt-0.5" />
              <div>
                <p className="font-bold text-sm mb-0.5">गोदाम किन आवश्यक छ? (Why Warehouse is required?)</p>
                <p className="leading-relaxed opacity-95">
                  SAISA मा खरिद दाखिला (Purchase Inwards), बिक्री बीजक (Sales Invoices), र स्टक गणना सधैं कुनै न कुनै गोदामसँग जोडिन्छन्। यदि पसल वा एउटै कार्यालय मात्र छ भने पनि त्यसलाई <strong>"Main Godown"</strong> वा <strong>"पसल / काउन्टर"</strong> का रूपमा दर्ता गर्नुहोस्।
                </p>
              </div>
            </div>

            {/* If Service Business Nature, show smart skip recommendation */}
            {businessNature === 'SERVICE' && (
              <div className="mt-4 p-4 rounded-lg bg-amber-50 border border-amber-300 flex items-start gap-3 text-xs text-amber-900">
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
                    className="mt-2.5 inline-flex items-center gap-1.5 px-3 py-1.5 rounded bg-amber-700 hover:bg-amber-800 text-white font-semibold text-xs shadow-sm"
                  >
                    <span>मौज्दात सेटअप छोड्नुहोस् (Skip to Finish Setup)</span>
                    <ArrowRight className="w-3.5 h-3.5" />
                  </button>
                </div>
              </div>
            )}

            <div className="grid grid-cols-1 md:grid-cols-2 gap-5 mt-6">
              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  Warehouse / Godown Name (गोदामको नाम) <span className="text-rose-600">*</span>
                </label>
                <input
                  type="text"
                  value={whName}
                  onChange={(e) => setWhName(e.target.value)}
                  placeholder="Main Godown / मुख्य गोदाम"
                  className="w-full px-3 py-2 text-sm border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 font-serif shadow-sm"
                />
                <p className="text-[11px] text-neutral-500 mt-1">
                  उदाहरण: Main Godown, Birgunj Depot, Kathmandu Store
                </p>
              </div>

              <div>
                <label className="block text-xs font-semibold text-neutral-800 mb-1">
                  Warehouse Code (संक्षिप्त संकेत) <span className="text-rose-600">*</span>
                </label>
                <input
                  type="text"
                  value={whCode}
                  onChange={(e) => setWhCode(e.target.value.toUpperCase())}
                  placeholder="MAIN"
                  className="w-full px-3 py-2 text-sm font-mono uppercase font-bold border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                />
                <p className="text-[11px] text-neutral-500 mt-1">
                  बीजक तथा ट्रान्सफर भौचरमा प्रयोग हुने ३-६ अक्षरको कोड
                </p>
              </div>
            </div>
          </div>

          {/* Action Bar */}
          <div className="flex flex-col sm:flex-row items-center justify-between gap-4 bg-white border border-neutral-300 rounded-lg p-5 shadow-sm">
            <button
              type="button"
              onClick={onBack}
              className="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-4 py-2 text-sm font-semibold text-neutral-700 hover:bg-neutral-100 rounded border border-neutral-300 transition-colors shadow-sm"
            >
              <ArrowLeft className="w-4 h-4" />
              <span>पछाडि फर्कनुहोस् (Back to Opening Balances)</span>
            </button>

            <div className="flex flex-wrap items-center gap-3 w-full sm:w-auto">
              <button
                type="button"
                onClick={() => setSubStep('FINISH')}
                className="px-4 py-2 text-sm font-semibold text-neutral-700 bg-neutral-100 hover:bg-neutral-200 rounded border border-neutral-300 transition-colors shadow-sm"
              >
                गोदाम नबनाई सम्पन्न गर्नुहोस् (Skip Warehouse & Finish)
              </button>

              <button
                type="button"
                onClick={handleWarehouseContinue}
                disabled={createWhMutation.isPending}
                className="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-6 py-2.5 text-sm font-semibold text-white bg-primary-700 hover:bg-primary-800 active:bg-primary-900 rounded shadow-sm transition-colors disabled:opacity-50"
              >
                <span>गोदाम सुरक्षित गरी सामान सूचीमा जानुहोस् (Save & Next: Items)</span>
                <ArrowRight className="w-4 h-4" />
              </button>
            </div>
          </div>
        </div>
      )}

      {/* ==================== SUB-STEP 2: ITEMS BULK ==================== */}
      {subStep === 'ITEMS' && (
        <div className="space-y-6">
          <div className="bg-white border border-neutral-300 rounded-lg p-6 shadow-sm">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-5 border-b border-neutral-200">
              <div className="flex items-start gap-3">
                <div className="w-10 h-10 rounded-lg bg-primary-50 border border-primary-200 flex items-center justify-center text-primary-700 flex-shrink-0">
                  <Boxes className="w-5 h-5" />
                </div>
                <div>
                  <div className="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full bg-primary-50 text-primary-800 border border-primary-200 text-xs font-semibold mb-1">
                    <span>चरण ३.२: उत्पादन तथा सामान (Add Items in Bulk)</span>
                  </div>
                  <h2 className="text-xl font-serif font-bold text-neutral-900">
                    सामान सूची दर्ता (Items Quick-add Table)
                  </h2>
                  <p className="text-xs text-neutral-600 mt-1">
                    तपाईंले बिक्री तथा खरिद गर्ने सामानहरू थप्नुहोस्। पछि थप सामानहरू मुख्य 'वस्तु व्यवस्थापन' खण्डबाट पनि थप्न सकिनेछ।
                  </p>
                </div>
              </div>

              <div className="flex items-center gap-2">
                <button
                  type="button"
                  onClick={() => setPasteModalOpen(true)}
                  className="inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-semibold rounded bg-neutral-100 hover:bg-neutral-200 text-neutral-800 border border-neutral-300 transition-colors shadow-sm"
                >
                  <ClipboardPaste className="w-3.5 h-3.5" />
                  <span>Excel / CSV बाट टाँस्नुहोस् (Paste)</span>
                </button>

                <button
                  type="button"
                  onClick={addRow}
                  className="inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-semibold rounded bg-primary-50 hover:bg-primary-100 text-primary-700 border border-primary-300 transition-colors shadow-sm"
                >
                  <Plus className="w-3.5 h-3.5" />
                  <span>नयाँ पंक्ति (Add Row)</span>
                </button>
              </div>
            </div>

            {/* Informational Guidance Box */}
            <div className="mt-4 p-3.5 rounded-lg bg-neutral-50 border border-neutral-200 text-xs text-neutral-700 flex items-start gap-2.5">
              <Info className="w-4 h-4 text-primary-600 flex-shrink-0 mt-0.5" />
              <span>
                <strong>सुझाव:</strong> यदि अहिल्यै सबै सामानको सूची छैन भने चिन्ता नगर्नुहोस्। तपाईं अहिले १-२ वटा नमुना सामान राख्न सक्नुहुन्छ वा तल <strong>"सामान पछि थप्छु"</strong> थिचेर सिधै सम्पन्न गर्न सक्नुहुन्छ।
              </span>
            </div>

            {/* Bulk Grid */}
            <div className="overflow-x-auto mt-4 border border-neutral-200 rounded-lg">
              <table className="w-full text-left text-xs">
                <thead className="bg-neutral-50 text-neutral-700 font-semibold border-b border-neutral-200 uppercase tracking-wider text-[11px]">
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
                <tbody className="divide-y divide-neutral-200">
                  {rows.map((row, idx) => (
                    <tr key={idx} className="hover:bg-neutral-50/50">
                      <td className="py-2 px-3 font-mono text-neutral-400">{idx + 1}</td>
                      <td className="py-1.5 px-2">
                        <input
                          type="text"
                          value={row.sku}
                          onChange={(e) => updateRow(idx, 'sku', e.target.value.toUpperCase())}
                          placeholder="SKU-001"
                          className="w-full px-2 py-1 font-mono uppercase font-semibold text-xs border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                        />
                      </td>
                      <td className="py-1.5 px-2">
                        <input
                          type="text"
                          value={row.name}
                          onChange={(e) => updateRow(idx, 'name', e.target.value)}
                          placeholder="e.g. Dell Monitor 24-inch"
                          className="w-full px-2 py-1 text-xs border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                        />
                      </td>
                      <td className="py-1.5 px-2">
                        <select
                          value={row.unitOfMeasure}
                          onChange={(e) => updateRow(idx, 'unitOfMeasure', e.target.value)}
                          className="w-full px-2 py-1 text-xs border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
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
                          className="w-full px-2 py-1 font-mono text-xs border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                        />
                      </td>
                      <td className="py-1.5 px-2">
                        <input
                          type="number"
                          step="0.01"
                          value={row.purchasePrice}
                          onChange={(e) => updateRow(idx, 'purchasePrice', e.target.value)}
                          placeholder="0.00"
                          className="w-full px-2 py-1 font-mono text-xs text-right border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                        />
                      </td>
                      <td className="py-1.5 px-2">
                        <input
                          type="number"
                          step="0.01"
                          value={row.salePrice}
                          onChange={(e) => updateRow(idx, 'salePrice', e.target.value)}
                          placeholder="0.00"
                          className="w-full px-2 py-1 font-mono text-xs text-right border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
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
          <div className="flex flex-col sm:flex-row items-center justify-between gap-4 bg-white border border-neutral-300 rounded-lg p-5 shadow-sm">
            <button
              type="button"
              onClick={() => setSubStep('WAREHOUSE')}
              className="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-4 py-2 text-sm font-semibold text-neutral-700 hover:bg-neutral-100 rounded border border-neutral-300 transition-colors shadow-sm"
            >
              <ArrowLeft className="w-4 h-4" />
              <span>गोदाममा फर्कनुहोस् (Back to Warehouse)</span>
            </button>

            <div className="flex flex-wrap items-center gap-3 w-full sm:w-auto">
              <button
                type="button"
                onClick={() => setSubStep('FINISH')}
                className="px-4 py-2 text-sm font-semibold text-neutral-700 bg-neutral-100 hover:bg-neutral-200 rounded border border-neutral-300 transition-colors shadow-sm"
              >
                सामान पछि थप्छु ➔ सिधै सम्पन्न गर्नुहोस् (Skip Items & Finish)
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
                    <span>सामान सुरक्षित गरी सुरुवाती स्टकमा जानुहोस् (Save Items & Next: Stock)</span>
                    <ArrowRight className="w-4 h-4" />
                  </>
                )}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* ==================== SUB-STEP 3: OPENING STOCK ==================== */}
      {subStep === 'STOCK' && (
        <div className="space-y-6">
          <div className="bg-white border border-neutral-300 rounded-lg p-6 shadow-sm">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-5 border-b border-neutral-200">
              <div className="flex items-start gap-3">
                <div className="w-10 h-10 rounded-lg bg-emerald-50 border border-emerald-200 flex items-center justify-center text-emerald-700 flex-shrink-0">
                  <Layers className="w-5 h-5" />
                </div>
                <div>
                  <div className="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full bg-emerald-50 text-emerald-800 border border-emerald-200 text-xs font-semibold mb-1">
                    <span>चरण ३.३: सुरुवाती मौज्दात (Opening Stock Quantity & Cost)</span>
                  </div>
                  <h2 className="text-xl font-serif font-bold text-neutral-900">
                    प्रारम्भिक स्टक तथा लागत गणना (Initial Stock Valuation)
                  </h2>
                  <p className="text-xs text-neutral-600 mt-1">
                    हरेक सामानको हाल गोदाममा रहेको परिमाण र खरिद लागत राख्नुहोस्। यसले <strong>OPENING</strong> भौचर मार्फत लेजरमा सम्पत्ति दर्ता गर्दछ।
                  </p>
                </div>
              </div>

              <div className="flex items-center gap-2">
                <label className="text-xs font-semibold text-neutral-800">
                  स्टक मिति:
                </label>
                <input
                  type="date"
                  value={openingDate}
                  onChange={(e) => setOpeningDate(e.target.value)}
                  className="px-2.5 py-1 text-xs font-mono border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
                />
              </div>
            </div>

            {items.length === 0 ? (
              <div className="py-12 text-center text-neutral-500 text-sm font-serif">
                <p>हाल कुनै सामान दर्ता गरिएको छैन।</p>
                <button
                  type="button"
                  onClick={() => setSubStep('ITEMS')}
                  className="mt-2 text-primary-600 underline text-xs font-semibold"
                >
                  ← पहिले सामान थप्नुहोस्
                </button>
              </div>
            ) : (
              <div className="overflow-x-auto mt-4 border border-neutral-200 rounded-lg">
                <table className="w-full text-left text-xs">
                  <thead className="bg-neutral-50 text-neutral-700 font-semibold border-b border-neutral-200 uppercase tracking-wider text-[11px]">
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
                  <tbody className="divide-y divide-neutral-200">
                    {items.map((item, idx) => {
                      const input = stockInputs[item.id] || { qty: '', cost: '' };
                      const q = parseNum(input.qty);
                      const c = parseNum(input.cost);
                      const lineTotal = q * c;

                      return (
                        <tr key={item.id} className="hover:bg-neutral-50/50">
                          <td className="py-2 px-3 font-mono text-neutral-400">{idx + 1}</td>
                          <td className="py-2 px-3 font-mono font-bold text-neutral-800">
                            {item.sku}
                          </td>
                          <td className="py-2 px-3 font-semibold text-neutral-900">
                            {item.name}
                          </td>
                          <td className="py-2 px-3 text-neutral-600 font-mono">{item.unitOfMeasure}</td>
                          <td className="py-1.5 px-2">
                            <input
                              type="number"
                              step="any"
                              value={input.qty}
                              onChange={(e) => updateStockInput(item.id, 'qty', e.target.value)}
                              placeholder="0"
                              className="w-full px-2 py-1 font-mono text-xs border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 text-right shadow-sm"
                            />
                          </td>
                          <td className="py-1.5 px-2">
                            <input
                              type="number"
                              step="0.01"
                              value={input.cost}
                              onChange={(e) => updateStockInput(item.id, 'cost', e.target.value)}
                              placeholder="0.00"
                              className="w-full px-2 py-1 font-mono text-xs border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 text-right shadow-sm"
                            />
                          </td>
                          <td className="py-2 px-3 font-mono font-bold text-right text-emerald-700">
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
            <div className="mt-5 p-4 rounded-lg bg-emerald-50 border border-emerald-300 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
              <div className="space-y-1">
                <div className="text-xs font-bold text-emerald-900 flex items-center gap-1.5">
                  <Sparkles className="w-4 h-4 text-emerald-600" />
                  <span>लेखा भौचर प्रविष्टि (Automatic Double-Entry Voucher):</span>
                </div>
                <div className="text-xs text-neutral-700 font-mono font-medium">
                  Dr. INVENTORY_ASSET ({formatMoney(totalStockVal.toFixed(2))}) / Cr. CAPITAL ({formatMoney(totalStockVal.toFixed(2))})
                </div>
              </div>

              <div className="text-right">
                <div className="text-[11px] text-neutral-600 uppercase font-semibold">कुल मौज्दात मूल्य</div>
                <div className="font-mono text-lg font-bold text-emerald-700">
                  {formatMoney(totalStockVal.toFixed(2))}
                </div>
                <div className="text-[10px] text-neutral-600 font-mono">
                  कुल संख्या: {totalStockQty} • वस्तुहरू: {stockLinesToPost.length}
                </div>
              </div>
            </div>
          </div>

          {/* Action Bar */}
          <div className="flex flex-col sm:flex-row items-center justify-between gap-4 bg-white border border-neutral-300 rounded-lg p-5 shadow-sm">
            <button
              type="button"
              onClick={() => setSubStep('ITEMS')}
              className="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-4 py-2 text-sm font-semibold text-neutral-700 hover:bg-neutral-100 rounded border border-neutral-300 transition-colors shadow-sm"
            >
              <ArrowLeft className="w-4 h-4" />
              <span>सामान सूचीमा फर्कनुहोस् (Back to Items)</span>
            </button>

            <div className="flex flex-wrap items-center gap-3 w-full sm:w-auto">
              <button
                type="button"
                onClick={() => setSubStep('FINISH')}
                className="px-4 py-2 text-sm font-semibold text-neutral-700 bg-neutral-100 hover:bg-neutral-200 rounded border border-neutral-300 transition-colors shadow-sm"
              >
                स्टक पछि हाल्छु ➔ सिधै सम्पन्न गर्नुहोस् (Skip Stock & Finish)
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
      )}

      {/* ==================== SUB-STEP 4: FINISH SCREEN ==================== */}
      {subStep === 'FINISH' && (
        <div className="space-y-6">
          <div className="bg-white border border-emerald-300 rounded-lg p-6 sm:p-8 shadow-sm">
            <div className="flex items-start gap-4 pb-6 border-b border-neutral-200">
              <div className="w-14 h-14 rounded-full bg-emerald-100 border border-emerald-300 flex items-center justify-center text-emerald-600 flex-shrink-0">
                <CheckCircle2 className="w-8 h-8" />
              </div>
              <div>
                <div className="inline-flex items-center gap-1.5 px-3 py-0.5 rounded-full bg-emerald-50 text-emerald-800 border border-emerald-300 text-xs font-semibold mb-1.5">
                  <Sparkles className="w-3.5 h-3.5 text-emerald-600" />
                  <span>सेटअप पूर्ण रूपमा सम्पन्न (Setup Complete!)</span>
                </div>
                <h2 className="text-2xl font-serif font-bold text-neutral-900">
                  बधाई छ! तपाईंको व्यापार SAISA मा सञ्चालनका लागि तयार छ।
                </h2>
                <p className="text-sm text-neutral-600 mt-1">
                  कम्पनी प्रोफाइल, सुरुआती वित्तीय मौज्दात र गोदाम व्यवस्थापन सुरक्षित भइसकेको छ।
                </p>
              </div>
            </div>

            {/* Setup Summary Overview */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 my-6">
              <div className="p-4 rounded-lg bg-neutral-50 border border-neutral-200">
                <div className="text-xs text-neutral-600 font-semibold mb-1">
                  १. व्यापार प्रोफाइल (Profile)
                </div>
                <div className="font-bold text-sm text-neutral-900 truncate">
                  {profile?.companyName || 'Registered'}
                </div>
                <div className="text-[11px] text-neutral-500 font-mono mt-0.5">
                  PAN: {profile?.panVatNo || profile?.pan || '—'}
                </div>
              </div>

              <div className="p-4 rounded-lg bg-neutral-50 border border-neutral-200">
                <div className="text-xs text-neutral-600 font-semibold mb-1">
                  २. प्रारम्भिक मौज्दात (Balance)
                </div>
                <div className="font-bold text-sm text-emerald-700">
                  {openingBalance?.posted ? 'दर्ता भयो (Posted)' : 'छोडिएको (Skipped)'}
                </div>
                <div className="text-[11px] text-neutral-500 font-mono mt-0.5">
                  {openingBalance?.journalEntryNumber ? `भौचर: ${openingBalance.journalEntryNumber}` : '—'}
                </div>
              </div>

              <div className="p-4 rounded-lg bg-neutral-50 border border-neutral-200">
                <div className="text-xs text-neutral-600 font-semibold mb-1">
                  ३. गोदाम (Warehouse)
                </div>
                <div className="font-bold text-sm text-neutral-900">
                  {warehouses.length > 0 ? warehouses[0].name : whName}
                </div>
                <div className="text-[11px] text-neutral-500 font-mono mt-0.5">
                  Code: {warehouses.length > 0 ? warehouses[0].code : whCode}
                </div>
              </div>

              <div className="p-4 rounded-lg bg-neutral-50 border border-neutral-200">
                <div className="text-xs text-neutral-600 font-semibold mb-1">
                  ४. मौज्दात सामान (Inventory)
                </div>
                <div className="font-bold text-sm text-blue-700">
                  {items.length} सामानहरू दर्ता
                </div>
                <div className="text-[11px] text-neutral-500 font-mono mt-0.5">
                  स्टक: {totalStockVal > 0 ? formatMoney(totalStockVal.toFixed(2)) : '—'}
                </div>
              </div>
            </div>

            {/* Final CTA Bar */}
            <div className="pt-6 border-t border-neutral-200 flex flex-col sm:flex-row items-center justify-between gap-4">
              <button
                type="button"
                onClick={() => setSubStep('STOCK')}
                className="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-4 py-2 text-sm font-semibold text-neutral-700 hover:text-neutral-900 transition-colors"
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
                <span>सेटअप पूरा गरी ड्यासबोर्ड खोल्नुहोस् (Finish & Open Dashboard)</span>
                <ArrowRight className="w-5 h-5" />
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Paste from Excel Dialog */}
      <Dialog
        open={pasteModalOpen}
        onClose={() => setPasteModalOpen(false)}
        title="Excel वा CSV बाट सामान टाँस्नुहोस् (Paste Items)"
        description="Excel बाट कोलमहरू सिधै कपी गरेर यहाँ पेस्ट गर्नुहोस्।"
      >
        <div className="space-y-4">
          <p className="text-xs text-neutral-600">
            कोलमको क्रम: <strong>SKU [ट्याब] Name [ट्याब] UOM [ट्याब] Purchase [ट्याब] Sale</strong>
          </p>
          <textarea
            value={pasteText}
            onChange={(e) => setPasteText(e.target.value)}
            placeholder="ITEM-001	Wireless Mouse	PCS	450	750&#10;ITEM-002	Mechanical Keyboard	PCS	1500	2400"
            rows={8}
            className="w-full p-2.5 text-xs font-mono border border-neutral-300 rounded bg-white text-neutral-900 focus:outline-none focus:ring-1 focus:ring-primary-500 shadow-sm"
          />
          <div className="flex items-center justify-end gap-3 pt-3 border-t border-neutral-200">
            <button
              type="button"
              onClick={() => setPasteModalOpen(false)}
              className="px-4 py-1.5 text-xs font-semibold text-neutral-600 hover:bg-neutral-100 rounded border border-neutral-300 shadow-sm"
            >
              रद्द गर्नुहोस् (Cancel)
            </button>
            <button
              type="button"
              onClick={handlePasteData}
              disabled={!pasteText.trim()}
              className="px-4 py-1.5 text-xs font-semibold text-white bg-primary-700 hover:bg-primary-800 rounded disabled:opacity-50 shadow-sm"
            >
              टाँसिएको डाटा आयात गर्नुहोस् (Import Data)
            </button>
          </div>
        </div>
      </Dialog>
    </div>
  );
};
