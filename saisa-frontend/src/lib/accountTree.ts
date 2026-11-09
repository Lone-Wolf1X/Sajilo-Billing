import type { ChartOfAccount, AccountType } from '../types/account';

export interface AccountNode extends ChartOfAccount {
  children: AccountNode[];
}

export interface AccountTypeGroup {
  type: AccountType;
  label: string;
  roots: AccountNode[];
}

/**
 * Groups flat accounts into 5 type sections, each containing a tree.
 * Root-level accounts (parentAccountId = null) start a tree.
 * Accounts with parent IDs get nested under their parents.
 */
export function buildAccountTree(accounts: ChartOfAccount[]): AccountTypeGroup[] {
  const groups: Record<AccountType, AccountNode[]> = {
    ASSET: [],
    LIABILITY: [],
    EQUITY: [],
    INCOME: [],
    EXPENSE: [],
  };

  // Map for O(1) parent lookup
  const nodesById = new Map<number, AccountNode>();
  for (const acc of accounts) {
    nodesById.set(acc.id, { ...acc, children: [] });
  }

  // Link children to parents, or add to roots
  for (const acc of accounts) {
    const node = nodesById.get(acc.id)!;
    if (acc.parentAccountId && nodesById.has(acc.parentAccountId)) {
      nodesById.get(acc.parentAccountId)!.children.push(node);
    } else {
      groups[acc.accountType].push(node);
    }
  }

  // Sort children by code
  const sortRecursive = (nodes: AccountNode[]) => {
    nodes.sort((a, b) => a.accountCode.localeCompare(b.accountCode));
    for (const node of nodes) sortRecursive(node.children);
  };
  for (const type of Object.keys(groups) as AccountType[]) {
    groups[type].sort((a, b) => a.accountCode.localeCompare(b.accountCode));
    for (const node of groups[type]) sortRecursive(node.children);
  }

  const labels: Record<AccountType, string> = {
    ASSET: 'Assets',
    LIABILITY: 'Liabilities',
    EQUITY: 'Equity',
    INCOME: 'Income',
    EXPENSE: 'Expenses',
  };

  return (Object.keys(groups) as AccountType[]).map((type) => ({
    type,
    label: labels[type],
    roots: groups[type],
  }));
}

/**
 * Filters accounts by search term (matches code OR name, case-insensitive).
 * Returns the original list plus a Set of account IDs that should be
 * highlighted (direct match) and a Set of parent IDs that should be
 * force-expanded (because a descendant matched).
 */
export function filterAccounts(accounts: ChartOfAccount[], search: string) {
  const term = search.trim().toLowerCase();
  if (!term) {
    return {
      filteredAccounts: accounts,
      highlightIds: new Set<number>(),
      expandIds: new Set<number>(),
    };
  }

  const matchedIds = new Set<number>();
  for (const acc of accounts) {
    if (
      acc.accountCode.toLowerCase().includes(term) ||
      acc.accountName.toLowerCase().includes(term)
    ) {
      matchedIds.add(acc.id);
    }
  }

  // Include matches + their ancestors (so tree structure preserved)
  const byId = new Map(accounts.map((a) => [a.id, a]));
  const includeIds = new Set<number>();
  const expandIds = new Set<number>();

  for (const id of matchedIds) {
    let cur: ChartOfAccount | undefined = byId.get(id);
    while (cur) {
      includeIds.add(cur.id);
      if (cur.id !== id) expandIds.add(cur.id);
      cur = cur.parentAccountId ? byId.get(cur.parentAccountId) : undefined;
    }
  }

  const filteredAccounts = accounts.filter((a) => includeIds.has(a.id));

  return {
    filteredAccounts,
    highlightIds: matchedIds,
    expandIds,
  };
}
