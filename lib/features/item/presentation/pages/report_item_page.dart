import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/theme_extensions.dart';
import '../../../../core/services/storage/user_session_service.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../category/domain/entities/category_entity.dart';
import '../../../category/presentation/state/category_state.dart';
import '../../../category/presentation/view_model/category_viewmodel.dart';
import '../../domain/entities/item_entity.dart';
import '../state/item_state.dart';
import '../view_model/item_viewmodel.dart';

class ReportItemPage extends ConsumerStatefulWidget {
  const ReportItemPage({super.key});

  @override
  ConsumerState<ReportItemPage> createState() => _ReportItemPageState();
}

class _ReportItemPageState extends ConsumerState<ReportItemPage> {
  ItemType _selectedType = ItemType.lost;
  String? _selectedCategoryId;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  // Category icons mapping
  final Map<String, IconData> _categoryIcons = {
    'Electronics': Icons.devices_rounded,
    'Personal': Icons.person_rounded,
    'Accessories': Icons.watch_rounded,
    'Documents': Icons.description_rounded,
    'Keys': Icons.key_rounded,
    'Bags': Icons.backpack_rounded,
    'Other': Icons.more_horiz_rounded,
  };

  @override
  void initState() {
    super.initState();
    // Load categories on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryViewModelProvider.notifier).getAllCategories();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final userSessionService = ref.read(userSessionServiceProvider);
      final userId = userSessionService.getCurrentUserId();

      await ref.read(itemViewModelProvider.notifier).createItem(
            itemName: _titleController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            categoryId: _selectedCategoryId,
            location: _locationController.text.trim(),
            type: _selectedType,
            reportedBy: userId,
          );
    }
  }

  IconData _getIconForCategory(String categoryName) {
    return _categoryIcons[categoryName] ?? Icons.category_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final itemState = ref.watch(itemViewModelProvider);
    final categoryState = ref.watch(categoryViewModelProvider);

    // Listen to item state changes
    ref.listen<ItemState>(itemViewModelProvider, (previous, next) {
      if (next.status == ItemStatus.created) {
        SnackbarUtils.showSuccess(
          context,
          _selectedType == ItemType.lost
              ? 'Lost item reported successfully!'
              : 'Found item reported successfully!',
        );
        Navigator.pop(context);
      } else if (next.status == ItemStatus.error && next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });

    // Set default category when categories load
    if (categoryState.status == CategoryStatus.loaded &&
        _selectedCategoryId == null &&
        categoryState.categories.isNotEmpty) {
      _selectedCategoryId = categoryState.categories.first.categoryId;
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: context.surfaceColor,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: context.softShadow,
                      ),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: context.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Report Item',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Lost/Found Toggle
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: context.surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: context.softShadow,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedType = ItemType.lost;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    gradient: _selectedType == ItemType.lost
                                        ? AppColors.lostGradient
                                        : null,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off_rounded,
                                        size: 20,
                                        color: _selectedType == ItemType.lost
                                            ? Colors.white
                                            : context.textSecondary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'I Lost Something',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: _selectedType == ItemType.lost
                                              ? Colors.white
                                              : context.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedType = ItemType.found;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    gradient: _selectedType == ItemType.found
                                        ? AppColors.foundGradient
                                        : null,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_circle_rounded,
                                        size: 20,
                                        color: _selectedType == ItemType.found
                                            ? Colors.white
                                            : context.textSecondary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'I Found Something',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: _selectedType == ItemType.found
                                              ? Colors.white
                                              : context.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Photo/Video Upload Section
                      Text(
                        'Add Photos / Videos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          // Add Photo Button
                          GestureDetector(
                            onTap: () {
                              // TODO: Implement image picker
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: context.surfaceColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: context.borderColor,
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      gradient: _selectedType == ItemType.lost
                                          ? AppColors.lostGradient
                                          : AppColors.foundGradient,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.add_a_photo_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Add Photo / Video',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: context.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Item Title
                      Text(
                        'Item Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: context.surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: context.softShadow,
                        ),
                        child: TextFormField(
                          controller: _titleController,
                          style: TextStyle(color: context.textPrimary),
                          decoration: InputDecoration(
                            hintText: 'e.g., iPhone 14 Pro, Blue Wallet',
                            hintStyle: TextStyle(color: context.textTertiary),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter item name';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Category Selection
                      Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildCategorySelector(categoryState.categories),

                      const SizedBox(height: 24),

                      // Location
                      Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: context.surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: context.softShadow,
                        ),
                        child: TextFormField(
                          controller: _locationController,
                          style: TextStyle(color: context.textPrimary),
                          decoration: InputDecoration(
                            hintText: _selectedType == ItemType.lost
                                ? 'Where did you lose it?'
                                : 'Where did you find it?',
                            hintStyle:
                                TextStyle(color: context.textTertiary),
                            prefixIcon: Icon(
                              Icons.location_on_rounded,
                              color: context.textSecondary,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter location';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Description
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: context.surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: context.softShadow,
                        ),
                        child: TextFormField(
                          controller: _descriptionController,
                          maxLines: 4,
                          style: TextStyle(color: context.textPrimary),
                          decoration: InputDecoration(
                            hintText:
                                'Provide additional details about the item...',
                            hintStyle: TextStyle(color: context.textTertiary),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Submit Button
                      GestureDetector(
                        onTap: itemState.status == ItemStatus.loading
                            ? null
                            : _handleSubmit,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            gradient: _selectedType == ItemType.lost
                                ? AppColors.lostGradient
                                : AppColors.foundGradient,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: AppColors.buttonShadow,
                          ),
                          child: itemState.status == ItemStatus.loading
                              ? const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _selectedType == ItemType.lost
                                          ? Icons.campaign_rounded
                                          : Icons.add_task_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      _selectedType == ItemType.lost
                                          ? 'Report Lost Item'
                                          : 'Report Found Item',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector(List<CategoryEntity> categories) {
    if (categories.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: context.softShadow,
        ),
        child: Center(
          child: Text(
            'Loading categories...',
            style: TextStyle(color: context.textSecondary),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: categories.map((category) {
        final isSelected = _selectedCategoryId == category.categoryId;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCategoryId = category.categoryId;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? (_selectedType == ItemType.lost
                      ? AppColors.lostGradient
                      : AppColors.foundGradient)
                  : null,
              color: isSelected ? null : context.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: context.softShadow,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getIconForCategory(category.name),
                  size: 18,
                  color: isSelected ? Colors.white : context.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : context.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
