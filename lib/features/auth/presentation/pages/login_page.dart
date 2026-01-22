import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../state/auth_state.dart';
import '../view_model/auth_viewmodel.dart';
import '../widgets/social_login_buttons.dart';
import '../widgets/auth_link_text.dart';
import 'signup_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authViewModelProvider.notifier)
          .login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  void _navigateToSignup() => AppRoutes.push(context, const SignupPage());
  void _handleForgotPassword() =>
      SnackbarUtils.showInfo(context, 'Forgot password feature coming soon');
  void _handleGoogleSignIn() =>
      SnackbarUtils.showInfo(context, 'Google Sign In coming soon');
  void _handleAppleSignIn() =>
      SnackbarUtils.showInfo(context, 'Apple Sign In coming soon');

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textDark;
    final secondaryTextColor =
        Theme.of(context).textTheme.bodySmall?.color ?? AppColors.textMuted;

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        AppRoutes.pushReplacement(context, const DashboardPage());
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                _buildLogo(isDarkMode),
                const SizedBox(height: 32),
                _buildTitle(textColor, secondaryTextColor),
                const SizedBox(height: 40),
                _buildEmailField(textColor),
                const SizedBox(height: 16),
                _buildPasswordField(textColor),
                const SizedBox(height: 8),
                _buildForgotPassword(),
                const SizedBox(height: 24),
                _buildLoginButton(authState),
                const SizedBox(height: 24),
                _buildDivider(secondaryTextColor),
                const SizedBox(height: 24),
                SocialLoginButtons(
                  onGoogleTap: _handleGoogleSignIn,
                  onAppleTap: _handleAppleSignIn,
                ),
                const SizedBox(height: 24),
                AuthLinkText(
                  text: "Don't have an account? ",
                  linkText: 'Sign Up',
                  onTap: _navigateToSignup,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(bool isDarkMode) {
    return Center(
      child: SvgPicture.asset(
        'assets/svg/softwarica_logo.svg',
        width: 200,
        height: 70,
        colorFilter: ColorFilter.mode(
          isDarkMode ? AppColors.darkTextPrimary : AppColors.primary,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Widget _buildTitle(Color textColor, Color secondaryTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Welcome Back!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to continue',
          style: TextStyle(fontSize: 16, color: secondaryTextColor),
        ),
      ],
    );
  }

  Widget _buildEmailField(Color textColor) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: textColor),
      decoration: const InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        prefixIcon: Icon(Icons.email_outlined),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your email';
        if (!value.contains('@')) return 'Please enter a valid email';
        return null;
      },
    );
  }

  Widget _buildPasswordField(Color textColor) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your password';
        if (value.length < 6) return 'Password must be at least 6 characters';
        return null;
      },
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _handleForgotPassword,
        child: Text(
          'Forgot Password?',
          style: TextStyle(
            color: AppColors.authPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(AuthState authState) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: authState.status == AuthStatus.loading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.authPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: authState.status == AuthStatus.loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Login',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildDivider(Color secondaryTextColor) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(
              color: secondaryTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
