import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../app/theme/theme_extensions.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/services/storage/user_session_service.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../category/presentation/state/category_state.dart';
import '../../../category/presentation/view_model/category_viewmodel.dart';
import '../../domain/entities/item_entity.dart';
import '../state/item_state.dart';
import '../view_model/item_viewmodel.dart';
import '../widgets/item_type_toggle.dart';
import '../widgets/media_upload_section.dart';
import '../widgets/category_chip_selector.dart';
import '../widgets/media_picker_bottom_sheet.dart';
import '../widgets/form_section_header.dart';
import '../widgets/styled_text_field.dart';
import '../widgets/gradient_submit_button.dart';

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

  final List<File> _selectedMedia = [];
  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedMediaType;

  @override
  void initState() {
    super.initState();
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
      final uploadedPhotoUrl = ref.read(itemViewModelProvider).uploadedPhotoUrl;

      await ref.read(itemViewModelProvider.notifier).createItem(
            itemName: _titleController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            category: _selectedCategoryId,
            location: _locationController.text.trim(),
            type: _selectedType,
            reportedBy: userId,
            media: uploadedPhotoUrl,
            mediaType: uploadedPhotoUrl != null ? _selectedMediaType : null,
          );
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) return true;

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
      return false;
    }

    return false;
  }

  void _showPermissionDeniedDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n?.permissionRequired ?? "Permission Required"),
        content: Text(
          l10n?.permissionDeniedMessage ?? "This feature requires permission to access your camera or gallery. Please enable it in your device settings.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              openAppSettings();
            },
            child: Text(l10n?.openSettings ?? 'Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFromCamera() async {
    final hasPermission = await _requestPermission(Permission.camera);
    if (!hasPermission) return;

    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo != null) {
      setState(() {
        _selectedMedia.clear();
        _selectedMedia.add(File(photo.path));
        _selectedMediaType = 'photo';
      });
      await ref
          .read(itemViewModelProvider.notifier)
          .uploadPhoto(File(photo.path));
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedMedia.clear();
          _selectedMedia.add(File(image.path));
          _selectedMediaType = 'photo';
        });
        await ref
            .read(itemViewModelProvider.notifier)
            .uploadPhoto(File(image.path));
      }
    } catch (e) {
      debugPrint('Gallery Error $e');
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        SnackbarUtils.showError(
          context,
          l10n?.galleryError ?? 'Unable to access gallery. Please try using the camera instead.',
        );
      }
    }
  }

  Future<void> _pickFromVideo() async {
    try {
      final hasPermission = await _requestPermission(Permission.camera);
      if (!hasPermission) return;

      final hasMicPermission = await _requestPermission(Permission.microphone);
      if (!hasMicPermission) return;

      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 1),
      );

      if (video != null) {
        setState(() {
          _selectedMedia.clear();
          _selectedMedia.add(File(video.path));
          _selectedMediaType = 'video';
        });
        await ref
            .read(itemViewModelProvider.notifier)
            .uploadVideo(File(video.path));
      }
    } catch (e) {
      _showPermissionDeniedDialog();
    }
  }

  Future<void> _pickVideoFromGallery() async {
    try {
      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5),
      );

      if (video != null) {
        final file = File(video.path);
        final fileSize = await file.length();

        // Check file size (limit to 50MB)
        if (fileSize > 50 * 1024 * 1024) {
          if (mounted) {
            SnackbarUtils.showError(
              context,
              'Video is too large. Please select a video under 50MB.',
            );
          }
          return;
        }

        setState(() {
          _selectedMedia.clear();
          _selectedMedia.add(file);
          _selectedMediaType = 'video';
        });

        await ref
            .read(itemViewModelProvider.notifier)
            .uploadVideo(file);
      }
    } catch (e) {
      debugPrint('Video Gallery Error: $e');
      if (mounted) {
        SnackbarUtils.showError(
          context,
          'Unable to access video gallery. Please try again.',
        );
      }
    }
  }

  void _showMediaPicker() {
    MediaPickerBottomSheet.show(
      context,
      onCameraTap: _pickFromCamera,
      onGalleryTap: _pickFromGallery,
      onVideoTap: _pickFromVideo,
      onVideoGalleryTap: _pickVideoFromGallery,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final itemState = ref.watch(itemViewModelProvider);
    final categoryState = ref.watch(categoryViewModelProvider);

    ref.listen<ItemState>(itemViewModelProvider, (previous, next) {
      if (next.status == ItemStatus.created) {
        SnackbarUtils.showSuccess(
          context,
          _selectedType == ItemType.lost
              ? (l10n?.lostItemSuccess ?? 'Lost item reported successfully!')
              : (l10n?.foundItemSuccess ?? 'Found item reported successfully!'),
        );
        Navigator.pop(context);
      } else if (next.status == ItemStatus.error && next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });

    if (categoryState.status == CategoryStatus.loaded &&
        _selectedCategoryId == null &&
        categoryState.categories.isNotEmpty) {
      _selectedCategoryId = categoryState.categories.first.categoryId;
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, l10n),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ItemTypeToggle(
                        selectedType: _selectedType,
                        onTypeChanged: (type) {
                          setState(() => _selectedType = type);
                        },
                      ),
                      const SizedBox(height: 24),
                      MediaUploadSection(
                        selectedMedia: _selectedMedia,
                        itemType: _selectedType,
                        onAddMedia: _showMediaPicker,
                        onRemoveMedia: () {
                          setState(() => _selectedMedia.clear());
                        },
                      ),
                      const SizedBox(height: 24),
                      FormSectionHeader(title: l10n?.itemName ?? 'Item Name'),
                      const SizedBox(height: 12),
                      StyledTextField(
                        controller: _titleController,
                        hintText: l10n?.itemNameHint ?? 'e.g., iPhone 14 Pro, Blue Wallet',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n?.pleaseEnterItemName ?? 'Please enter item name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      FormSectionHeader(title: l10n?.category ?? 'Category'),
                      const SizedBox(height: 12),
                      CategoryChipSelector(
                        categories: categoryState.categories,
                        selectedCategoryId: _selectedCategoryId,
                        itemType: _selectedType,
                        onCategorySelected: (id) {
                          setState(() => _selectedCategoryId = id);
                        },
                      ),
                      const SizedBox(height: 24),
                      FormSectionHeader(title: l10n?.location ?? 'Location'),
                      const SizedBox(height: 12),
                      StyledTextField(
                        controller: _locationController,
                        hintText: _selectedType == ItemType.lost
                            ? (l10n?.whereLost ?? 'Where did you lose it?')
                            : (l10n?.whereFound ?? 'Where did you find it?'),
                        prefixIcon: Icons.location_on_rounded,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n?.pleaseEnterLocation ?? 'Please enter location';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      FormSectionHeader(title: l10n?.description ?? 'Description'),
                      const SizedBox(height: 12),
                      StyledTextField(
                        controller: _descriptionController,
                        hintText: l10n?.provideDetails ?? 'Provide additional details about the item...',
                        maxLines: 4,
                      ),
                      const SizedBox(height: 32),
                      GradientSubmitButton(
                        itemType: _selectedType,
                        isLoading: itemState.status == ItemStatus.loading,
                        onTap: _handleSubmit,
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

  Widget _buildHeader(BuildContext context, AppLocalizations? l10n) {
    return Padding(
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
              l10n?.reportItem ?? 'Report Item',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
