import React, { useState } from 'react';
import { ChevronDown, ChevronRight, Plus } from 'lucide-react';
import { AccountTreeNode } from './AccountTreeNode';
import type { AccountNode, AccountTypeGroup } from '../../lib/accountTree';
import type { AccountType } from '../../types/account';

interface Props {
  group: AccountTypeGroup;
  selectedId: number | null;
  onSelect: (account: AccountNode) => void;
  highlightIds: Set<number>;
  forceExpandIds: Set<number>;
  onAddInType: (type: AccountType) => void;
  hasSearchFilter: boolean;
}

export const AccountTypeSection: React.FC<Props> = ({
  group,
  selectedId,
  onSelect,
  highlightIds,
  forceExpandIds,
  onAddInType,
  hasSearchFilter,
}) => {
  const [expanded, setExpanded] = useState(true);

  // Hide empty sections when search is active (only show matching categories)
  if (hasSearchFilter && group.roots.length === 0) return null;

  return (
    <div className="mb-3 border border-paper-border rounded bg-paper-surface overflow-hidden">
      <div
        className="flex items-center justify-between px-3 py-2 bg-paper-alt cursor-pointer select-none border-b border-paper-border hover:bg-paper-hover transition-colors"
        onClick={() => setExpanded(!expanded)}
      >
        <div className="flex items-center gap-2">
          {expanded ? (
            <ChevronDown className="w-4 h-4 text-paper-muted" />
          ) : (
            <ChevronRight className="w-4 h-4 text-paper-muted" />
          )}
          <span className="font-serif font-semibold text-sm text-brand-navy">
            {group.label}
          </span>
          <span className="text-xs text-paper-muted font-mono">
            ({group.roots.length})
          </span>
        </div>

        <button
          type="button"
          className="text-xs text-brand-navy hover:text-brand-navy-hover font-semibold flex items-center gap-0.5 px-2 py-0.5 rounded hover:bg-paper-alt transition-colors cursor-pointer"
          onClick={(e) => {
            e.stopPropagation();
            onAddInType(group.type);
          }}
        >
          <Plus className="w-3.5 h-3.5" />
          <span>Add</span>
        </button>
      </div>

      {expanded && (
        <div className="p-1.5 space-y-0.5">
          {group.roots.length === 0 ? (
            <div className="px-4 py-3 text-xs text-paper-muted italic text-center">
              No {group.label.toLowerCase()} accounts created yet. Click "+ Add" above.
            </div>
          ) : (
            group.roots.map((node) => (
              <AccountTreeNode
                key={node.id}
                node={node}
                depth={0}
                selectedId={selectedId}
                onSelect={onSelect}
                highlightIds={highlightIds}
                forceExpandIds={forceExpandIds}
              />
            ))
          )}
        </div>
      )}
    </div>
  );
};
