import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:only_law_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:only_law_app/features/auth/presentation/widgets/phone_input_field.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  final bool isRegistration;

  const OtpScreen({
    super.key,
    required this.phone,
    this.isRegistration = false,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool _isVerifying = false;
  String? _error;
  int _resendCountdown = 60;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _resendCountdown = 60;
      _canResend = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  Future<void> _handleVerify(String code) async {
    setState(() {
      _isVerifying = true;
      _error = null;
    });

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.verifyOtp(
      phone: widget.phone,
      otp: code,
    );

    if (success && mounted) {
      if (widget.isRegistration) {
        // After OTP verification for registration, go to document upload
        context.go('/profile-setup');
      } else {
        // After OTP verification for password reset, go to reset password screen
        context.go('/reset-password', extra: {'phone': widget.phone, 'otp': code});
      }
    } else {
      setState(() {
        _error = authProvider.error ?? 'Invalid OTP code';
        _isVerifying = false;
      });
    }
  }

  Future<void> _handleResend() async {
    if (!_canResend) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.sendOtp(widget.phone);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent successfully')),
      );
      _startCountdown();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.error ?? 'Failed to send OTP')),
      );
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
              _Header(phone: widget.phone),
              const SizedBox(height: 48),
              OtpInputField(
                onCompleted: _handleVerify,
                onChanged: (code) {
                  if (_error != null) {
                    setState(() => _error = null);
                  }
                },
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                _ErrorMessage(message: _error!),
              ],
              const SizedBox(height: 32),
              _ResendSection(
                canResend: _canResend,
                countdown: _resendCountdown,
                onResend: _handleResend,
              ),
              const SizedBox(height: 32),
              if (_isVerifying) const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 24),
              _InfoBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String phone;

  const _Header({required this.phone});

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
            Icons.phone_android,
            size: 48,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Verify Your Phone',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            text: 'We sent a 6-digit code to\n',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            children: [
              TextSpan(
                text: phone,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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

class _ResendSection extends StatelessWidget {
  final bool canResend;
  final int countdown;
  final VoidCallback onResend;

  const _ResendSection({
    required this.canResend,
    required this.countdown,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive the code? ",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (canResend)
          GestureDetector(
            onTap: onResend,
            child: Text(
              'Resend',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        else
          Text(
            'Resend in 0:${countdown.toString().padLeft(2, '0')}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'For testing, use the code: 123456',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.blue.shade800),
            ),
          ),
        ],
      ),
    );
  }
}
