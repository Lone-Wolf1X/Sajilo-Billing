import React, { useState } from 'react';
import { ChevronRight, ChevronDown } from 'lucide-react';
import type { AccountNode } from '../../lib/accountTree';

interface Props {
  node: AccountNode;
  depth: number;
  selectedId: number | null;
  onSelect: (account: AccountNode) => void;
  highlightIds: Set<number>;
  forceExpandIds: Set<number>;
}

export const AccountTreeNode: React.FC<Props> = ({
  node,
  depth,
  selectedId,
  onSelect,
  highlightIds,
  forceExpandIds,
}) => {
  const [expanded, setExpanded] = useState(true);
  const hasChildren = node.children.length > 0;
  const isSelected = selectedId === node.id;
  const isHighlighted = highlightIds.has(node.id);
  const mustExpand = forceExpandIds.has(node.id);
  const isActuallyExpanded = expanded || mustExpand;

  return (
    <div>
      <div
        className={`flex items-center gap-1.5 px-2.5 py-1.5 cursor-pointer rounded text-xs transition-colors select-none ${
          isSelected
            ? 'bg-brand-navy-light text-brand-navy font-semibold border-l-2 border-brand-navy'
            : 'hover:bg-paper-hover text-paper-text'
        } ${isHighlighted ? 'bg-amber-100 font-medium' : ''}`}
        style={{ paddingLeft: `${8 + depth * 18}px` }}
        onClick={() => onSelect(node)}
      >
        {hasChildren ? (
          <button
            type="button"
            onClick={(e) => {
              e.stopPropagation();
              setExpanded(!expanded);
            }}
            className="p-0.5 hover:bg-paper-border rounded text-paper-muted hover:text-paper-text"
            aria-label={isActuallyExpanded ? 'Collapse' : 'Expand'}
          >
            {isActuallyExpanded ? (
              <ChevronDown className="w-3.5 h-3.5" />
            ) : (
              <ChevronRight className="w-3.5 h-3.5" />
            )}
          </button>
        ) : (
          <span className="w-4" />
        )}

        <code className="font-mono text-[11px] text-paper-muted w-14 shrink-0 font-medium">
          {node.accountCode}
        </code>
        <span className="truncate flex-1">{node.accountName}</span>

        {node.systemAccount && (
          <span className="text-[10px] bg-paper-alt px-1.5 py-0.2 rounded border border-paper-border text-paper-muted shrink-0">
            SYS
          </span>
        )}
      </div>

      {hasChildren && isActuallyExpanded && (
        <div className="border-l border-paper-border/60 ml-4">
          {node.children.map((child) => (
            <AccountTreeNode
              key={child.id}
              node={child}
              depth={depth + 1}
              selectedId={selectedId}
              onSelect={onSelect}
              highlightIds={highlightIds}
              forceExpandIds={forceExpandIds}
            />
          ))}
        </div>
      )}
    </div>
  );
};

