import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bank_accounts_screen.dart';
import 'company_profile_screen.dart';
import 'users_management_screen.dart';

class AdminSettingsHome extends ConsumerStatefulWidget {
  const AdminSettingsHome({super.key});

  @override
  ConsumerState<AdminSettingsHome> createState() => _AdminSettingsHomeState();
}

class _AdminSettingsHomeState extends ConsumerState<AdminSettingsHome> {
  int _selectedTab = 0;

  static const _tabs = [
    _TabDef(
      'Users & Roles\nप्रयोगकर्ता व्यवस्थापन',
      Icons.admin_panel_settings_outlined,
      Icons.admin_panel_settings,
    ),
    _TabDef(
      'Company Profile\nकम्पनी विवरण',
      Icons.business_outlined,
      Icons.business,
    ),
    _TabDef(
      'Bank Accounts\nबैंक खाताहरू',
      Icons.account_balance_outlined,
      Icons.account_balance,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Secondary Admin Navigation Sidebar
        Container(
          width: 230,
          decoration: const BoxDecoration(
            color: Color(0xFFF8FAFC),
            border: Border(right: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  'COMPANY ADMIN SETTINGS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              for (var i = 0; i < _tabs.length; i++)
                _tabItem(i, _tabs[i]),
            ],
          ),
        ),

        // Active Admin Screen View
        Expanded(
          child: IndexedStack(
            index: _selectedTab,
            children: const [
              UsersManagementScreen(),
              CompanyProfileScreen(),
              BankAccountsScreen(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tabItem(int i, _TabDef def) {
    final selected = _selectedTab == i;
    return InkWell(
      onTap: () => setState(() => _selectedTab = i),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: selected ? const Color(0xFF1E3A8A) : Colors.transparent,
              width: 3.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? def.selectedIcon : def.icon,
              size: 20,
              color: selected ? const Color(0xFF1E3A8A) : const Color(0xFF64748B),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                def.label,
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.25,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  color: selected ? const Color(0xFF1E3A8A) : const Color(0xFF1E293B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabDef {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  const _TabDef(this.label, this.icon, this.selectedIcon);
}

