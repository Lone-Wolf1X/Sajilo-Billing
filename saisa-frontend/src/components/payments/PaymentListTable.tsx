import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Eye } from 'lucide-react';
import { PaymentStatusBadge } from './PaymentStatusBadge';
import { PaymentTypeBadge } from './PaymentTypeBadge';
import { formatMoney } from '../../lib/invoiceUtils';
import type { Payment } from '../../types/payment';
import type { Customer } from '../../types/customer';
import type { Vendor } from '../../types/vendor';

interface Props {
  payments: Payment[];
  customers: Customer[];
  vendors: Vendor[];
}

export const PaymentListTable: React.FC<Props> = ({
  payments,
  customers,
  vendors,
}) => {
  const navigate = useNavigate();

  const customerMap = React.useMemo(() => {
    return new Map(customers.map((c) => [c.id, c.customerName]));
  }, [customers]);

  const vendorMap = React.useMemo(() => {
    return new Map(vendors.map((v) => [v.id, v.vendorName]));
  }, [vendors]);

  const getPartyName = (p: Payment) => {
    if (p.partyType === 'CUSTOMER') {
      return (
        p.partyName ||
        customerMap.get(p.partyId) ||
        `Customer #${p.partyId}`
      );
    }
    return (
      p.partyName ||
      vendorMap.get(p.partyId) ||
      `Vendor #${p.partyId}`
    );
  };

  return (
    <div className="overflow-x-auto">
      <table className="w-full text-xs border-collapse min-w-[800px]">
        <thead className="bg-paper-alt border-b-2 border-paper-border-strong text-paper-muted select-none">
          <tr>
            <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border w-36">
              Voucher / Payment #
            </th>
            <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border w-28">
              Date
            </th>
            <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-center border-r border-paper-border w-32">
              Type
            </th>
            <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border">
              Party / Entity
            </th>
            <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-left border-r border-paper-border w-32">
              Method
            </th>
            <th className="px-3 py-2.5 font-serif uppercase tracking-wider text-right border-r border-paper-border w-32">
              Amount (NPR)
            </th>
            <th className="px-2.5 py-2.5 font-serif uppercase tracking-wider text-center border-r border-paper-border w-24">
              Status
            </th>
            <th className="px-2.5 py-2.5 font-serif uppercase tracking-wider text-center w-16">
              Action
            </th>
          </tr>
        </thead>
        <tbody className="divide-y divide-paper-border">
          {payments.map((p) => {
            const isReceipt = p.partyType === 'CUSTOMER';

            return (
              <tr
                key={p.id}
                onClick={() => navigate(`/payments/${p.id}`)}
                className="hover:bg-paper-warm/30 transition-colors cursor-pointer group"
              >
                {/* Payment Number */}
                <td className="px-3 py-2.5 font-mono font-bold text-brand-navy border-r border-paper-border">
                  <span className="underline decoration-dotted group-hover:decoration-solid">
                    {p.paymentNumber}
                  </span>
                </td>

                {/* Date */}
                <td className="px-3 py-2.5 font-mono text-paper-muted border-r border-paper-border">
                  {p.paymentDate}
                </td>

                {/* Type Badge */}
                <td className="px-3 py-2 text-center border-r border-paper-border">
                  <PaymentTypeBadge partyType={p.partyType} />
                </td>

                {/* Party Name */}
                <td className="px-3 py-2.5 border-r border-paper-border font-medium text-paper-text">
                  {getPartyName(p)}
                </td>

                {/* Payment Method */}
                <td className="px-3 py-2.5 border-r border-paper-border text-paper-muted font-mono text-[11px] uppercase">
                  {p.paymentMethod.replace('_', ' ')}
                </td>

                {/* Amount */}
                <td
                  className={`px-3 py-2.5 text-right font-mono font-bold border-r border-paper-border ${
                    isReceipt ? 'text-[#2d6a4f]' : 'text-paper-text'
                  }`}
                >
                  {formatMoney(p.amount, '')}
                </td>

                {/* Status */}
                <td className="px-2.5 py-2 text-center border-r border-paper-border">
                  <PaymentStatusBadge status={p.status} />
                </td>

                {/* Actions */}
                <td
                  className="px-2 py-2 text-center"
                  onClick={(e) => e.stopPropagation()}
                >
                  <Link
                    to={`/payments/${p.id}`}
                    className="p-1 rounded text-paper-muted hover:text-brand-navy hover:bg-paper-alt transition-colors inline-flex"
                    title="View Voucher"
                  >
                    <Eye className="h-3.5 w-3.5" />
                  </Link>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
};
