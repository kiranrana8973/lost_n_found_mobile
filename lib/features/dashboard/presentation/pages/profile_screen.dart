import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/theme_extensions.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/services/storage/user_session_service.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../auth/presentation/view_model/auth_viewmodel.dart';
import '../../../item/presentation/view_model/item_viewmodel.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/theme_toggle_item.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadMyItems());
  }

  void _loadMyItems() {
    final userSessionService = ref.read(userSessionServiceProvider);
    final userId = userSessionService.getCurrentUserId();
    if (userId != null) {
      ref.read(itemViewModelProvider.notifier).getMyItems(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final userSessionService = ref.watch(userSessionServiceProvider);
    final userName = userSessionService.getCurrentUserFullName() ?? 'User';
    final userEmail = userSessionService.getCurrentUserEmail() ?? '';
    final itemState = ref.watch(itemViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProfileHeader(
                userName: userName,
                userEmail: userEmail,
                lostCount: itemState.myLostItems.length,
                foundCount: itemState.myFoundItems.length,
                lostCountText: l10n?.formatNumber(itemState.myLostItems.length),
                foundCountText: l10n?.formatNumber(itemState.myFoundItems.length),
                totalCountText: l10n?.formatNumber(itemState.myLostItems.length + itemState.myFoundItems.length),
                lostLabel: l10n?.lost,
                foundLabel: l10n?.found,
                totalLabel: l10n?.total,
                myProfileLabel: l10n?.profile,
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    ProfileMenuItem(
                      icon: Icons.person_outline_rounded,
                      title: l10n?.editProfile ?? 'Edit Profile',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    ProfileMenuItem(
                      icon: Icons.history_rounded,
                      title: l10n?.myItems ?? 'My Items',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    ProfileMenuItem(
                      icon: Icons.notifications_outlined,
                      title: l10n?.notifications ?? 'Notifications',
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: AppColors.secondaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          l10n?.formatNumber(3) ?? '3',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    ProfileMenuItem(
                      icon: Icons.security_rounded,
                      title: l10n?.privacySecurity ?? 'Privacy & Security',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    const ThemeToggleItem(),
                    const SizedBox(height: 12),
                    ProfileMenuItem(
                      icon: Icons.help_outline_rounded,
                      title: l10n?.helpSupport ?? 'Help & Support',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    ProfileMenuItem(
                      icon: Icons.info_outline_rounded,
                      title: l10n?.about ?? 'About',
                      onTap: () {},
                    ),
                    const SizedBox(height: 24),
                    ProfileMenuItem(
                      icon: Icons.logout_rounded,
                      title: l10n?.logout ?? 'Logout',
                      iconColor: AppColors.error,
                      titleColor: AppColors.error,
                      onTap: () => _showLogoutDialog(context, l10n),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '${l10n?.version ?? 'Version'} ${l10n?.formatNumber('1.0.0') ?? '1.0.0'}',
                style: TextStyle(fontSize: 12, color: context.textSecondary60),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations? l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n?.logout ?? 'Logout', style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(l10n?.logoutConfirm ?? 'Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n?.cancel ?? 'Cancel', style: TextStyle(color: context.textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await ref.read(authViewModelProvider.notifier).logout();
              if (context.mounted) {
                AppRoutes.pushAndRemoveUntil(context, const LoginPage());
              }
            },
            child: Text(
              l10n?.logout ?? 'Logout',
              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
