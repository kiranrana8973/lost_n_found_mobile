import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../batch/presentation/bloc/batch_bloc.dart';
import '../../../batch/presentation/bloc/batch_event.dart';
import '../../../batch/presentation/state/batch_state.dart';
import '../../../../app/theme/theme_extensions.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../state/auth_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/password_field.dart';
import '../widgets/terms_checkbox.dart';
import '../widgets/auth_link_text.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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
      context.read<BatchBloc>().add(const BatchGetAllEvent());
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

  Future<void> _handleSignup() async {
    if (!_agreedToTerms) {
      SnackbarUtils.showError(
        context,
        'Please agree to the Terms & Conditions',
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthRegisterEvent(
              fullName: _nameController.text.trim(),
              email: _emailController.text.trim(),
              username: _emailController.text.trim().split('@').first,
              password: _passwordController.text,
              phoneNumber: '$_selectedCountryCode${_phoneController.text.trim()}',
              batchId: _selectedBatch,
            ),
          );
    }
  }

  void _navigateToLogin() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.registered) {
          SnackbarUtils.showSuccess(
            context,
            'Registration successful! Please login.',
          );
          Navigator.of(context).pop();
        } else if (state.status == AuthStatus.error &&
            state.errorMessage != null) {
          SnackbarUtils.showError(context, state.errorMessage!);
        }
      },
      child: Scaffold(
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
                    const AuthHeader(
                      icon: Icons.person_add_rounded,
                      title: 'Join Us Today',
                      subtitle: 'Create your account to get started',
                    ),
                    const SizedBox(height: 32),
                    _buildNameField(),
                    const SizedBox(height: 16),
                    _buildEmailField(),
                    const SizedBox(height: 16),
                    _buildPhoneRow(),
                    const SizedBox(height: 16),
                    BlocBuilder<BatchBloc, BatchState>(
                      builder: (context, batchState) {
                        return _buildBatchDropdown(batchState);
                      },
                    ),
                    const SizedBox(height: 16),
                    PasswordField(
                      controller: _passwordController,
                      labelText: 'Password',
                      hintText: 'Create a strong password',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    PasswordField(
                      controller: _confirmPasswordController,
                      labelText: 'Confirm Password',
                      hintText: 'Re-enter your password',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
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
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, authState) {
                        return GradientButton(
                          text: 'Create Account',
                          onPressed: _handleSignup,
                          isLoading: authState.status == AuthStatus.loading,
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    AuthLinkText(
                      text: 'Already have an account? ',
                      linkText: 'Login',
                      onTap: _navigateToLogin,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(
        labelText: 'Full Name',
        hintText: 'Enter your full name',
        prefixIcon: Icon(Icons.person_outline_rounded),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your name';
        if (value.length < 3) return 'Name must be at least 3 characters';
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email Address',
        hintText: 'Enter your email',
        prefixIcon: Icon(Icons.email_outlined),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your email';
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: DropdownButtonFormField<String>(
            initialValue: _selectedCountryCode,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Code',
              contentPadding: EdgeInsets.symmetric(
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
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              hintText: '9800000000',
              prefixIcon: Icon(Icons.phone_outlined),
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

  Widget _buildBatchDropdown(BatchState batchState) {
    return DropdownButtonFormField<String>(
      initialValue: _selectedBatch,
      decoration: InputDecoration(
        labelText: 'Select Batch',
        hintText: batchState.status == BatchStatus.loading
            ? 'Loading batches...'
            : 'Choose your batch',
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
        if (value == null || value.isEmpty) return 'Please select your batch';
        return null;
      },
    );
  }
}
