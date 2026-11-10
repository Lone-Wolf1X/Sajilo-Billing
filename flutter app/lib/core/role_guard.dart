import '../features/auth/domain/auth_models.dart';

enum AppMenu {
  dashboard,
  posBilling,
  salesRegister,
  purchases,
  inventory,
  khata,
  reports,
  businessInfo,
  backup,
  settings,
  adminPanel,
}

class RoleGuard {
  /// Checks whether [user] is allowed to access the specified [menu].
  static bool canAccess(AuthUser? user, AppMenu menu) {
    if (user == null) return false;
    final roles = user.roles;

    // PLATFORM_ADMIN has universal access
    if (roles.contains('PLATFORM_ADMIN')) return true;

    // ADMIN (Business Owner) has access to all operational & tenant admin modules
    if (roles.contains('ADMIN')) return true;

    switch (menu) {
      case AppMenu.dashboard:
        return roles.contains('ACCOUNTANT') || roles.contains('VIEWER');
      case AppMenu.posBilling:
        return roles.contains('CASHIER') || roles.contains('ACCOUNTANT');
      case AppMenu.salesRegister:
        return roles.contains('CASHIER') || roles.contains('ACCOUNTANT') || roles.contains('VIEWER');
      case AppMenu.purchases:
        return roles.contains('ACCOUNTANT');
      case AppMenu.inventory:
        return roles.contains('ACCOUNTANT') || roles.contains('VIEWER');
      case AppMenu.khata:
        return roles.contains('ACCOUNTANT');
      case AppMenu.reports:
        return roles.contains('ACCOUNTANT') || roles.contains('VIEWER');
      case AppMenu.businessInfo:
        return false; // ADMIN & PLATFORM_ADMIN only
      case AppMenu.backup:
        return false; // ADMIN & PLATFORM_ADMIN only
      case AppMenu.settings:
        return true; // All authenticated users can view their basic app settings
      case AppMenu.adminPanel:
        return false; // ADMIN & PLATFORM_ADMIN only
    }
  }

  static bool isPlatformAdmin(AuthUser? user) =>
      user != null && user.hasRole('PLATFORM_ADMIN');

  static bool isTenantAdmin(AuthUser? user) =>
      user != null && (user.hasRole('ADMIN') || user.hasRole('PLATFORM_ADMIN'));

  static bool isAccountant(AuthUser? user) =>
      user != null && (user.hasRole('ACCOUNTANT') || isTenantAdmin(user));

  static bool isCashierOnly(AuthUser? user) =>
      user != null && user.hasRole('CASHIER') && !isTenantAdmin(user) && !user.hasRole('ACCOUNTANT');

  static bool isViewerOnly(AuthUser? user) =>
      user != null && user.hasRole('VIEWER') && !isTenantAdmin(user) && !user.hasRole('ACCOUNTANT');
}

