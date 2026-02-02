import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:only_law_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:only_law_app/features/auth/presentation/widgets/phone_input_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final phone = '+254${_phoneController.text.replaceAll(' ', '')}';
    final success = await authProvider.forgotPassword(phone);

    if (success && mounted) {
      context.go('/otp', extra: {'phone': phone, 'isRegistration': false});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back),
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.05),
                _Header(),
                const SizedBox(height: 48),
                PhoneInputField(
                  controller: _phoneController,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Phone number is required';
                    final cleaned = v.replaceAll(RegExp(r'[\s\-()]'), '');
                    if (cleaned.length < 9) return 'Enter a valid phone number';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    if (auth.error != null && auth.status == AuthStatus.error) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _ErrorMessage(message: auth.error!),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                _SubmitButton(onPressed: _handleSubmit),
                const SizedBox(height: 24),
                _BackToLoginLink(onTap: () => context.go('/login')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.lock_reset,
            size: 48,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Forgot Password?',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "No worries! Enter your phone number and we'll send you a code to reset your password",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  final String message;

  const _ErrorMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SubmitButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return FilledButton(
          onPressed: auth.isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: auth.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text(
                  'Send Reset Code',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
        );
      },
    );
  }
}

class _BackToLoginLink extends StatelessWidget {
  final VoidCallback onTap;

  const _BackToLoginLink({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.arrow_back, size: 16),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: onTap,
          child: Text(
            'Back to Login',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
