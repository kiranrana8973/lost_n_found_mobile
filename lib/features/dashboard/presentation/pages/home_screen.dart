import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/theme_extensions.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../core/services/storage/user_session_service.dart';
import '../../../item/presentation/pages/item_detail_page.dart';
import '../../../item/domain/entities/item_entity.dart';
import '../../../item/presentation/view_model/item_viewmodel.dart';
import '../../../item/presentation/state/item_state.dart';
import '../../../category/domain/entities/category_entity.dart';
import '../../../category/presentation/view_model/category_viewmodel.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedFilter = 0; // 0: All, 1: Lost, 2: Found
  String? _selectedCategoryId;

  final List<String> _filters = ['All', 'Lost', 'Found'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(itemViewModelProvider.notifier).getAllItems();
      ref.read(categoryViewModelProvider.notifier).getAllCategories();
    });
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'electronics':
        return Icons.devices_rounded;
      case 'personal':
        return Icons.person_rounded;
      case 'accessories':
        return Icons.watch_rounded;
      case 'documents':
        return Icons.description_rounded;
      case 'keys':
        return Icons.key_rounded;
      case 'bags':
        return Icons.backpack_rounded;
      default:
        return Icons.inventory_2_rounded;
    }
  }

  List<ItemEntity> _getFilteredItems(ItemState itemState) {
    List<ItemEntity> items = itemState.items;

    // Filter by Lost/Found
    if (_selectedFilter == 1) {
      items = items.where((item) => item.type == ItemType.lost).toList();
    } else if (_selectedFilter == 2) {
      items = items.where((item) => item.type == ItemType.found).toList();
    }

    // Filter by category
    if (_selectedCategoryId != null) {
      items = items
          .where((item) => item.categoryId == _selectedCategoryId)
          .toList();
    }

    return items;
  }

  String _getCategoryNameById(
    String? categoryId,
    List<CategoryEntity> categories,
  ) {
    if (categoryId == null) return 'Other';
    try {
      return categories.firstWhere((c) => c.categoryId == categoryId).name;
    } catch (e) {
      return 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemState = ref.watch(itemViewModelProvider);
    final categoryState = ref.watch(categoryViewModelProvider);
    final filteredItems = _getFilteredItems(itemState);
    final userSessionService = ref.watch(userSessionServiceProvider);
    final userName = userSessionService.getCurrentUserFullName() ?? 'User';

    return Scaffold(
      // backgroundColor: context.backgroundColor // Using theme default,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 16,
                            color: context.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userName,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(
                              Icons.notifications_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.lostColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: context.surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: context.softShadow,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search items...',
                      hintStyle: TextStyle(color: context.textTertiary),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: context.textSecondary,
                      ),
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Filter Tabs (All, Lost, Found)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: context.surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: context.softShadow,
                  ),
                  child: Row(
                    children: List.generate(_filters.length, (index) {
                      final isSelected = _selectedFilter == index;
                      Color? bgColor;
                      Gradient? gradient;

                      if (isSelected) {
                        if (index == 0) {
                          gradient = AppColors.primaryGradient;
                        } else if (index == 1) {
                          gradient = AppColors.lostGradient;
                        } else {
                          gradient = AppColors.foundGradient;
                        }
                      }

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedFilter = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              gradient: gradient,
                              color: bgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                _filters[index],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : context.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Category Chips
            SliverToBoxAdapter(
              child: SizedBox(
                height: 46,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      categoryState.categories.length + 1, // +1 for "All"
                  itemBuilder: (context, index) {
                    // First item is "All"
                    if (index == 0) {
                      final isSelected = _selectedCategoryId == null;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategoryId = null;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? AppColors.primaryGradient
                                  : null,
                              color: isSelected ? null : context.surfaceColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: context.softShadow,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.apps_rounded,
                                  size: 18,
                                  color: isSelected
                                      ? Colors.white
                                      : context.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'All',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : context.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    final category = categoryState.categories[index - 1];
                    final isSelected =
                        _selectedCategoryId == category.categoryId;

                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategoryId = category.categoryId;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? AppColors.primaryGradient
                                : null,
                            color: isSelected ? null : context.surfaceColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: context.softShadow,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _getCategoryIcon(category.name),
                                size: 18,
                                color: isSelected
                                    ? Colors.white
                                    : context.textSecondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                category.name,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : context.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Quick Stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.search_off_rounded,
                        title: 'Lost Items',
                        value: '${itemState.lostItems.length}',
                        gradient: AppColors.lostGradient,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.check_circle_rounded,
                        title: 'Found Items',
                        value: '${itemState.foundItems.length}',
                        gradient: AppColors.foundGradient,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Recent Items Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Items',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See All',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // Items List
            itemState.status == ItemStatus.loading
                ? const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                : filteredItems.isEmpty
                ? SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.inbox_rounded,
                              size: 64,
                              color: context.textTertiary.withAlpha(128),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No items found',
                              style: TextStyle(
                                fontSize: 16,
                                color: context.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Be the first to report a lost or found item!',
                              style: TextStyle(
                                fontSize: 14,
                                color: context.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final item = filteredItems[index];
                        final categoryName = _getCategoryNameById(
                          item.categoryId,
                          categoryState.categories,
                        );
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _ItemCard(
                            title: item.itemName,
                            location: item.location,
                            category: categoryName,
                            isLost: item.type == ItemType.lost,
                            onTap: () {
                              AppRoutes.push(
                                context,
                                ItemDetailPage(
                                  title: item.itemName,
                                  location: item.location,
                                  category: categoryName,
                                  isLost: item.type == ItemType.lost,
                                  description:
                                      item.description ??
                                      'No description provided.',
                                  reportedBy: item.reportedBy ?? 'Anonymous',
                                ),
                              );
                            },
                          ),
                        );
                      }, childCount: filteredItems.length),
                    ),
                  ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Gradient gradient;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: context.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: context.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final String title;
  final String location;
  final String category;
  final bool isLost;
  final VoidCallback? onTap;

  const _ItemCard({
    required this.title,
    required this.location,
    required this.category,
    required this.isLost,
    this.onTap,
  });

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Electronics':
        return Icons.devices_rounded;
      case 'Personal':
        return Icons.person_rounded;
      case 'Accessories':
        return Icons.watch_rounded;
      case 'Documents':
        return Icons.description_rounded;
      case 'Keys':
        return Icons.key_rounded;
      case 'Bags':
        return Icons.backpack_rounded;
      default:
        return Icons.inventory_2_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: context.softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Item Icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: isLost
                        ? AppColors.lostGradient
                        : AppColors.foundGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _getCategoryIcon(category),
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: context.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isLost
                                  ? AppColors.lostColor.withAlpha(26)
                                  : AppColors.foundColor.withAlpha(26),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isLost ? 'Lost' : 'Found',
                              style: TextStyle(
                                fontSize: 11,
                                color: isLost
                                    ? AppColors.lostColor
                                    : AppColors.foundColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 14,
                            color: context.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              style: TextStyle(
                                fontSize: 13,
                                color: context.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(26),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
