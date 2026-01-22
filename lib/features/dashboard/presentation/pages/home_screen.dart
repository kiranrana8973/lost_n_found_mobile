import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/theme_extensions.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/services/storage/user_session_service.dart';
import '../../../item/presentation/pages/item_detail_page.dart';
import '../../../item/domain/entities/item_entity.dart';
import '../../../item/presentation/view_model/item_viewmodel.dart';
import '../../../item/presentation/state/item_state.dart';
import '../../../category/domain/entities/category_entity.dart';
import '../../../category/presentation/view_model/category_viewmodel.dart';
import '../widgets/stat_card.dart';
import '../widgets/item_card.dart';
import '../widgets/filter_tabs.dart';
import '../widgets/category_chip_list.dart';
import '../widgets/empty_items_view.dart';
import '../widgets/home_header.dart';
import '../widgets/search_bar_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedFilter = 0;
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

  List<ItemEntity> _getFilteredItems(ItemState itemState) {
    List<ItemEntity> items = itemState.items;

    if (_selectedFilter == 1) {
      items = items.where((item) => item.type == ItemType.lost).toList();
    } else if (_selectedFilter == 2) {
      items = items.where((item) => item.type == ItemType.found).toList();
    }

    if (_selectedCategoryId != null) {
      items = items
          .where((item) => item.category == _selectedCategoryId)
          .toList();
    }

    return items;
  }

  String _getCategoryNameById(String? categoryId, List<CategoryEntity> categories) {
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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: HomeHeader(userName: userName),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const SearchBarWidget(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: FilterTabs(
                  filters: _filters,
                  selectedIndex: _selectedFilter,
                  onFilterChanged: (index) {
                    setState(() => _selectedFilter = index);
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(
              child: CategoryChipList(
                categories: categoryState.categories,
                selectedCategoryId: _selectedCategoryId,
                onCategorySelected: (id) {
                  setState(() => _selectedCategoryId = id);
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        icon: Icons.search_off_rounded,
                        title: 'Lost Items',
                        value: '${itemState.lostItems.length}',
                        gradient: AppColors.lostGradient,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
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
            _buildItemsList(itemState, filteredItems, categoryState.categories),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList(
    ItemState itemState,
    List<ItemEntity> filteredItems,
    List<CategoryEntity> categories,
  ) {
    if (itemState.status == ItemStatus.loading) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (filteredItems.isEmpty) {
      return const SliverToBoxAdapter(child: EmptyItemsView());
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = filteredItems[index];
            final categoryName = _getCategoryNameById(item.category, categories);
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ItemCard(
                title: item.itemName,
                location: item.location,
                category: categoryName,
                isLost: item.type == ItemType.lost,
                imageUrl: item.media != null
                    ? ApiEndpoints.itemPicture(item.media!)
                    : null,
                onTap: () {
                  AppRoutes.push(
                    context,
                    ItemDetailPage(
                      title: item.itemName,
                      location: item.location,
                      category: categoryName,
                      isLost: item.type == ItemType.lost,
                      description: item.description ?? 'No description provided.',
                      reportedBy: item.reportedBy ?? 'Anonymous',
                      imageUrl: item.media != null
                          ? ApiEndpoints.itemPicture(item.media!)
                          : null,
                    ),
                  );
                },
              ),
            );
          },
          childCount: filteredItems.length,
        ),
      ),
    );
  }
}
