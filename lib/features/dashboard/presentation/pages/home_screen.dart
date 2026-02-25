import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/routes/router_extensions.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/theme_extensions.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/services/storage/user_session_service.dart';
import '../../../../core/utils/snackbar_utils.dart';
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
  String _searchQuery = '';

  List<String> _getFilters(AppLocalizations? l10n) {
    return [l10n?.all ?? 'All', l10n?.lost ?? 'Lost', l10n?.found ?? 'Found'];
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(itemViewModelProvider.notifier).getAllItems();
      ref.read(categoryViewModelProvider.notifier).getAllCategories();
    });
  }

  List<ItemEntity> _getFilteredItems(ItemState itemState) {
    final items = itemState.items;
    final hasSearch = _searchQuery.isNotEmpty;
    final query = hasSearch ? _searchQuery.toLowerCase() : '';
    final filterType = _selectedFilter;
    final categoryId = _selectedCategoryId;

    return items.where((item) {
      if (filterType == 1 && item.type != ItemType.lost) return false;
      if (filterType == 2 && item.type != ItemType.found) return false;
      if (categoryId != null && item.category != categoryId) return false;
      if (hasSearch) {
        return item.itemName.toLowerCase().contains(query) ||
            item.location.toLowerCase().contains(query) ||
            (item.description?.toLowerCase().contains(query) ?? false);
      }
      return true;
    }).toList();
  }

  Map<String, String> _buildCategoryMap(List<CategoryEntity> categories) {
    return {
      for (final c in categories)
        if (c.categoryId != null) c.categoryId!: c.name,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final itemState = ref.watch(itemViewModelProvider);
    final categoryState = ref.watch(categoryViewModelProvider);
    final filteredItems = _getFilteredItems(itemState);
    final userSessionService = ref.watch(userSessionServiceProvider);
    final userName = userSessionService.getCurrentUserFullName() ?? 'User';

    ref.listen<ItemState>(itemViewModelProvider, (previous, next) {
      if (next.status == ItemStatus.error && next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: HomeHeader(userName: userName)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SearchBarWidget(
                  hintText: l10n?.searchItems ?? 'Search items...',
                  onChanged: (query) {
                    setState(() => _searchQuery = query);
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: FilterTabs(
                  filters: _getFilters(l10n),
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
                        title: l10n?.lostItems ?? 'Lost Items',
                        value:
                            l10n?.formatNumber(itemState.lostItems.length) ??
                            '${itemState.lostItems.length}',
                        gradient: AppColors.lostGradient,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        icon: Icons.check_circle_rounded,
                        title: l10n?.foundItems ?? 'Found Items',
                        value:
                            l10n?.formatNumber(itemState.foundItems.length) ??
                            '${itemState.foundItems.length}',
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
                      l10n?.recentItems ?? 'Recent Items',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        l10n?.seeAll ?? 'See All',
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
            _buildItemsList(
              itemState,
              filteredItems,
              _buildCategoryMap(categoryState.categories),
              l10n,
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList(
    ItemState itemState,
    List<ItemEntity> filteredItems,
    Map<String, String> categoryMap,
    AppLocalizations? l10n,
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

    if (itemState.status == ItemStatus.error && filteredItems.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                Icon(
                  Icons.cloud_off_rounded,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 12),
                Text(
                  itemState.errorMessage ?? 'Something went wrong',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(itemViewModelProvider.notifier).getAllItems();
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: Text(l10n?.retry ?? 'Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
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
        delegate: SliverChildBuilderDelegate((context, index) {
          final item = filteredItems[index];
          final categoryName =
              (item.category != null ? categoryMap[item.category] : null) ??
              'Other';
          final isVideo = item.isVideo;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ItemCard(
              title: item.itemName,
              location: item.location,
              category: categoryName,
              isLost: item.type == ItemType.lost,
              imageUrl: item.media != null && !isVideo
                  ? ApiEndpoints.itemPicture(item.media!)
                  : null,
              onTap: () {
                context.goToItemDetail(
                  id: item.itemId ?? '',
                  title: item.itemName,
                  location: item.location,
                  category: categoryName,
                  isLost: item.type == ItemType.lost,
                  description:
                      item.description ??
                      (l10n?.noDescription ?? 'No description provided.'),
                  reportedBy: item.reportedBy ?? 'Anonymous',
                  imageUrl: item.media != null && !isVideo
                      ? ApiEndpoints.itemPicture(item.media!)
                      : null,
                  videoUrl: item.media != null && isVideo
                      ? ApiEndpoints.itemVideo(item.media!)
                      : null,
                );
              },
            ),
          );
        }, childCount: filteredItems.length),
      ),
    );
  }
}
