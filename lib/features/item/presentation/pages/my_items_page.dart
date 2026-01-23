import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/api/api_endpoints.dart';
import 'package:lost_n_found/core/localization/app_localizations.dart';
import 'package:lost_n_found/core/services/storage/user_session_service.dart';
import 'package:lost_n_found/features/category/presentation/view_model/category_viewmodel.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:lost_n_found/features/item/presentation/state/item_state.dart';
import 'package:lost_n_found/features/item/presentation/view_model/item_viewmodel.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/theme_extensions.dart';
import '../widgets/my_item_card.dart';

class MyItemsPage extends ConsumerStatefulWidget {
  const MyItemsPage({super.key});

  @override
  ConsumerState<MyItemsPage> createState() => _MyItemsPageState();
}

class _MyItemsPageState extends ConsumerState<MyItemsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() => _loadData());
  }

  void _loadData() {
    final userSessionService = ref.read(userSessionServiceProvider);
    final userId = userSessionService.getCurrentUserId();
    if (userId != null) {
      ref.read(itemViewModelProvider.notifier).getMyItems(userId);
    }
    ref.read(categoryViewModelProvider.notifier).getAllCategories();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getCategoryName(String? categoryId, AppLocalizations? l10n) {
    if (categoryId == null) return l10n?.other ?? 'Other';
    final categoryState = ref.read(categoryViewModelProvider);
    final category = categoryState.categories.where(
      (c) => c.categoryId == categoryId,
    );
    return category.isNotEmpty ? category.first.name : (l10n?.other ?? 'Other');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final itemState = ref.watch(itemViewModelProvider);
    final myLostItems = itemState.myLostItems;
    final myFoundItems = itemState.myFoundItems;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, l10n),
            _buildTabBar(context, l10n, myLostItems.length, myFoundItems.length),
            const SizedBox(height: 20),
            Expanded(
              child: itemState.status == ItemStatus.loading
                  ? Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    )
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildItemsList(myLostItems, true, l10n),
                        _buildItemsList(myFoundItems, false, l10n),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations? l10n) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n?.myItems ?? 'My Items',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n?.trackYourReports ?? 'Track your reports',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: context.softShadow,
            ),
            child: Icon(Icons.sort_rounded, color: context.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, AppLocalizations? l10n, int lostCount, int foundCount) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: context.softShadow,
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: AppColors.primaryGradient,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: context.textSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        tabs: [
          _buildTab(Icons.search_off_rounded, l10n?.lost ?? 'Lost', lostCount, l10n),
          _buildTab(Icons.check_circle_rounded, l10n?.found ?? 'Found', foundCount, l10n),
        ],
      ),
    );
  }

  Widget _buildTab(IconData icon, String label, int count, AppLocalizations? l10n) {
    return Tab(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 6),
            Text(label),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(l10n?.formatNumber(count) ?? '$count', style: const TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList(List<ItemEntity> items, bool isLost, AppLocalizations? l10n) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isLost ? Icons.search_off_rounded : Icons.check_circle_rounded,
              size: 64,
              color: context.textTertiary.withAlpha(128),
            ),
            const SizedBox(height: 16),
            Text(
              isLost
                  ? (l10n?.noLostItems ?? 'No lost items reported')
                  : (l10n?.noFoundItems ?? 'No found items reported'),
              style: TextStyle(
                fontSize: 16,
                color: context.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final categoryName = _getCategoryName(item.category, l10n);
        final status = item.status ?? (item.isClaimed ? 'claimed' : 'active');

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MyItemCard(
            title: item.itemName,
            location: item.location,
            category: categoryName,
            status: status,
            isLost: isLost,
            imageUrl: item.media != null
                ? ApiEndpoints.itemPicture(item.media!)
                : null,
            onTap: () {},
            onEdit: () {},
            onDelete: () => _showDeleteDialog(context, item, l10n),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, ItemEntity item, AppLocalizations? l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n?.deleteItem ?? 'Delete Item',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('${l10n?.deleteConfirm ?? 'Are you sure you want to delete'} "${item.itemName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              l10n?.cancel ?? 'Cancel',
              style: TextStyle(color: context.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              if (item.itemId != null) {
                ref.read(itemViewModelProvider.notifier).deleteItem(item.itemId!);
                final userSessionService = ref.read(userSessionServiceProvider);
                final userId = userSessionService.getCurrentUserId();
                if (userId != null) {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    ref.read(itemViewModelProvider.notifier).getMyItems(userId);
                  });
                }
              }
            },
            child: Text(
              l10n?.delete ?? 'Delete',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
