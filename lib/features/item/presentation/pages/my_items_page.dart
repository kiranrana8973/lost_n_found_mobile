import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lost_n_found/core/api/api_endpoints.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/theme_extensions.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/services/storage/user_session_service.dart';
import '../../../category/presentation/bloc/category_bloc.dart';
import '../../../category/presentation/bloc/category_event.dart';
import '../bloc/item_bloc.dart';
import '../bloc/item_event.dart';
import '../state/item_state.dart';
import '../widgets/my_item_card.dart';

class MyItemsPage extends StatefulWidget {
  const MyItemsPage({super.key});

  @override
  State<MyItemsPage> createState() => _MyItemsPageState();
}

class _MyItemsPageState extends State<MyItemsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() => _loadData());
  }

  void _loadData() {
    final userSessionService = serviceLocator<UserSessionService>();
    final userId = userSessionService.getCurrentUserId();
    if (userId != null) {
      context.read<ItemBloc>().add(ItemGetMyItemsEvent(userId: userId));
    }
    context.read<CategoryBloc>().add(const CategoryGetAllEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getCategoryName(String? categoryId) {
    if (categoryId == null) return 'Other';
    final categoryState = context.read<CategoryBloc>().state;
    final category = categoryState.categories.where(
      (c) => c.categoryId == categoryId,
    );
    return category.isNotEmpty ? category.first.name : 'Other';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ItemBloc, ItemState>(
          builder: (context, itemState) {
            final myLostItems = itemState.myLostItems;
            final myFoundItems = itemState.myFoundItems;

            return Column(
              children: [
                _buildHeader(context),
                _buildTabBar(
                    context, myLostItems.length, myFoundItems.length),
                const SizedBox(height: 20),
                Expanded(
                  child: itemState.status == ItemStatus.loading
                      ? Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primary),
                        )
                      : TabBarView(
                          controller: _tabController,
                          children: [
                            _buildItemsList(myLostItems, true),
                            _buildItemsList(myFoundItems, false),
                          ],
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Items',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Track your reports',
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

  Widget _buildTabBar(BuildContext context, int lostCount, int foundCount) {
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
        labelStyle:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        tabs: [
          _buildTab(Icons.search_off_rounded, 'Lost', lostCount),
          _buildTab(Icons.check_circle_rounded, 'Found', foundCount),
        ],
      ),
    );
  }

  Widget _buildTab(IconData icon, String label, int count) {
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  Text('$count', style: const TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList(List<ItemEntity> items, bool isLost) {
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
              isLost ? 'No lost items reported' : 'No found items reported',
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
        final categoryName = _getCategoryName(item.category);
        final status =
            item.status ?? (item.isClaimed ? 'claimed' : 'active');

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
            onDelete: () => _showDeleteDialog(context, item),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, ItemEntity item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Item',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content:
            Text('Are you sure you want to delete "${item.itemName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TextStyle(color: context.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              if (item.itemId != null) {
                context
                    .read<ItemBloc>()
                    .add(ItemDeleteEvent(itemId: item.itemId!));
                final userSessionService =
                    serviceLocator<UserSessionService>();
                final userId = userSessionService.getCurrentUserId();
                if (userId != null) {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) {
                      context.read<ItemBloc>().add(
                          ItemGetMyItemsEvent(userId: userId));
                    }
                  });
                }
              }
            },
            child: Text(
              'Delete',
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
