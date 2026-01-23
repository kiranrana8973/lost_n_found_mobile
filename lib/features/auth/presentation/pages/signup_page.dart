import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/features/auth/presentation/state/auth_state.dart';
import 'package:lost_n_found/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:lost_n_found/features/batch/presentation/state/batch_state.dart';
import 'package:lost_n_found/features/batch/presentation/view_model/batch_viewmodel.dart';
import '../../../../app/theme/theme_extensions.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../widgets/auth_header.dart';
import '../widgets/password_field.dart';
import '../widgets/terms_checkbox.dart';
import '../widgets/auth_link_text.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _agreedToTerms = false;
  String? _selectedBatch;
  String _selectedCountryCode = '+977';

  final List<Map<String, String>> _countryCodes = [
    {'code': '+977', 'name': 'Nepal', 'flag': '🇳🇵'},
    {'code': '+91', 'name': 'India', 'flag': '🇮🇳'},
    {'code': '+1', 'name': 'USA', 'flag': '🇺🇸'},
    {'code': '+44', 'name': 'UK', 'flag': '🇬🇧'},
    {'code': '+86', 'name': 'China', 'flag': '🇨🇳'},
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(batchViewModelProvider.notifier).getAllBatches();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup(AppLocalizations? l10n) async {
    if (!_agreedToTerms) {
      SnackbarUtils.showError(
        context,
        l10n?.agreeTerms ?? 'Please agree to the Terms & Conditions',
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      await ref
          .read(authViewModelProvider.notifier)
          .register(
            fullName: _nameController.text.trim(),
            email: _emailController.text.trim(),
            username: _emailController.text.trim().split('@').first,
            password: _passwordController.text,
            phoneNumber: '$_selectedCountryCode${_phoneController.text.trim()}',
            batchId: _selectedBatch,
          );
    }
  }

  void _navigateToLogin() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final batchState = ref.watch(batchViewModelProvider);
    final authState = ref.watch(authViewModelProvider);

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.registered) {
        SnackbarUtils.showSuccess(
          context,
          l10n?.registrationSuccess ?? 'Registration successful! Please login.',
        );
        Navigator.of(context).pop();
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: context.softShadow,
            ),
            child: Icon(Icons.arrow_back, color: context.textPrimary, size: 20),
          ),
          onPressed: _navigateToLogin,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AuthHeader(
                    icon: Icons.person_add_rounded,
                    title: l10n?.joinUsToday ?? 'Join Us Today',
                    subtitle: l10n?.createAccountSubtitle ?? 'Create your account to get started',
                  ),
                  const SizedBox(height: 32),
                  _buildNameField(l10n),
                  const SizedBox(height: 16),
                  _buildEmailField(l10n),
                  const SizedBox(height: 16),
                  _buildPhoneRow(l10n),
                  const SizedBox(height: 16),
                  _buildBatchDropdown(batchState, l10n),
                  const SizedBox(height: 16),
                  PasswordField(
                    controller: _passwordController,
                    labelText: l10n?.password ?? 'Password',
                    hintText: l10n?.createStrongPassword ?? 'Create a strong password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n?.pleaseEnterPassword ?? 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return l10n?.passwordMinLength ?? 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  PasswordField(
                    controller: _confirmPasswordController,
                    labelText: l10n?.confirmPassword ?? 'Confirm Password',
                    hintText: l10n?.reenterPassword ?? 'Re-enter your password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n?.pleaseConfirmPassword ?? 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return l10n?.passwordsNotMatch ?? 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TermsCheckbox(
                    value: _agreedToTerms,
                    onChanged: (value) =>
                        setState(() => _agreedToTerms = value),
                  ),
                  const SizedBox(height: 32),
                  GradientButton(
                    text: l10n?.createAccount ?? 'Create Account',
                    onPressed: () => _handleSignup(l10n),
                    isLoading: authState.status == AuthStatus.loading,
                  ),
                  const SizedBox(height: 32),
                  AuthLinkText(
                    text: l10n?.alreadyHaveAccount ?? 'Already have an account? ',
                    linkText: l10n?.login ?? 'Login',
                    onTap: _navigateToLogin,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField(AppLocalizations? l10n) {
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: l10n?.fullName ?? 'Full Name',
        hintText: l10n?.enterFullName ?? 'Enter your full name',
        prefixIcon: const Icon(Icons.person_outline_rounded),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return l10n?.pleaseEnterName ?? 'Please enter your name';
        if (value.length < 3) return l10n?.nameMinLength ?? 'Name must be at least 3 characters';
        return null;
      },
    );
  }

  Widget _buildEmailField(AppLocalizations? l10n) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: l10n?.emailAddress ?? 'Email Address',
        hintText: l10n?.enterYourEmail ?? 'Enter your email',
        prefixIcon: const Icon(Icons.email_outlined),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return l10n?.pleaseEnterEmail ?? 'Please enter your email';
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return l10n?.pleaseEnterValidEmail ?? 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneRow(AppLocalizations? l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: DropdownButtonFormField<String>(
            initialValue: _selectedCountryCode,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: l10n?.code ?? 'Code',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
            ),
            selectedItemBuilder: (context) {
              return _countryCodes.map((country) {
                return Text(
                  '${country['flag']} ${country['code']}',
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                );
              }).toList();
            },
            items: _countryCodes.map((country) {
              return DropdownMenuItem<String>(
                value: country['code'],
                child: Row(
                  children: [
                    Text(
                      country['flag']!,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      country['code']!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) => _selectedCountryCode = value!,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.number,
            maxLength: 10,
            decoration: InputDecoration(
              labelText: l10n?.phoneNumber ?? 'Phone Number',
              hintText: '9800000000',
              prefixIcon: const Icon(Icons.phone_outlined),
              counterText: '',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter phone number';
              }
              if (value.length != 10) return 'Phone must be 10 digits';
              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return 'Only numbers allowed';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBatchDropdown(BatchState batchState, AppLocalizations? l10n) {
    return DropdownButtonFormField<String>(
      initialValue: _selectedBatch,
      decoration: InputDecoration(
        labelText: l10n?.selectBatch ?? 'Select Batch',
        hintText: batchState.status == BatchStatus.loading
            ? (l10n?.loadingBatches ?? 'Loading batches...')
            : (l10n?.chooseBatch ?? 'Choose your batch'),
        prefixIcon: const Icon(Icons.school_rounded),
      ),
      items: batchState.batches.map((batch) {
        return DropdownMenuItem<String>(
          value: batch.batchId,
          child: Text(batch.batchName),
        );
      }).toList(),
      onChanged: (value) => _selectedBatch = value,
      validator: (value) {
        if (value == null || value.isEmpty) return l10n?.pleaseSelectBatch ?? 'Please select your batch';
        return null;
      },
    );
  }
}
