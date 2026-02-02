import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:only_law_app/features/auth/presentation/providers/auth_provider.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  String? _practicingCertPath;
  String? _nationalIdPath;
  String? _photoPath;

  Future<void> _handleSkip() async {
    if (mounted) {
      context.go('/dashboard');
    }
  }

  Future<void> _handleSubmit() async {
    if (_practicingCertPath == null || _nationalIdPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload both Practicing Certificate and National ID'),
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.uploadVerificationDocuments(
      practicingCertPath: _practicingCertPath!,
      nationalIdPath: _nationalIdPath!,
      photoPath: _photoPath,
    );

    if (success && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _SuccessDialog(
          onDismiss: () {
            Navigator.pop(context);
            context.go('/dashboard');
          },
        ),
      );
    }
  }

  Future<void> _pickDocument(String type) async {
    // In real implementation, use file_picker or image_picker
    // For now, simulate file selection
    await Future.delayed(const Duration(milliseconds: 500));

    final mockPath = '/mock/path/to/$type.pdf';
    setState(() {
      if (type == 'cert') {
        _practicingCertPath = mockPath;
      } else if (type == 'id') {
        _nationalIdPath = mockPath;
      } else if (type == 'photo') {
        _photoPath = mockPath;
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${type == 'cert' ? 'Certificate' : type == 'id' ? 'ID' : 'Photo'} selected')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: size.height * 0.02),
                    _Header(),
                    const SizedBox(height: 32),
                    _DocumentCard(
                      title: 'Practicing Certificate (2024/2025)',
                      subtitle: 'Current year certificate required',
                      icon: Icons.description,
                      isUploaded: _practicingCertPath != null,
                      onUpload: () => _pickDocument('cert'),
                    ),
                    const SizedBox(height: 16),
                    _DocumentCard(
                      title: 'National ID / Passport',
                      subtitle: 'For identity verification',
                      icon: Icons.badge,
                      isUploaded: _nationalIdPath != null,
                      onUpload: () => _pickDocument('id'),
                    ),
                    const SizedBox(height: 16),
                    _DocumentCard(
                      title: 'Professional Photo (Optional)',
                      subtitle: 'For your profile',
                      icon: Icons.camera_alt,
                      isUploaded: _photoPath != null,
                      onUpload: () => _pickDocument('photo'),
                      isOptional: true,
                    ),
                    const SizedBox(height: 24),
                    _InfoBox(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _BottomActions(
              onSkip: _handleSkip,
              onSubmit: _handleSubmit,
              canSubmit: _practicingCertPath != null && _nationalIdPath != null,
            ),
          ],
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
            Icons.verified_user,
            size: 48,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Complete Verification',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Upload your documents to get verified and unlock all features',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isUploaded;
  final VoidCallback onUpload;
  final bool isOptional;

  const _DocumentCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isUploaded,
    required this.onUpload,
    this.isOptional = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUploaded
              ? theme.colorScheme.primary.withValues(alpha: 0.5)
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onUpload,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUploaded
                        ? Colors.green.withValues(alpha: 0.1)
                        : theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isUploaded ? Icons.check_circle : icon,
                    color: isUploaded ? Colors.green : theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isUploaded ? Icons.edit : Icons.upload_file,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
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
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Text(
                'Verification Process',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.amber.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoItem(text: 'Documents are reviewed within 24-48 hours'),
          const SizedBox(height: 6),
          _InfoItem(text: 'Verified with Law Society of Kenya records'),
          const SizedBox(height: 6),
          _InfoItem(text: 'You can still use the app while pending'),
          const SizedBox(height: 6),
          _InfoItem(text: 'Full features unlock after verification'),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String text;

  const _InfoItem({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.amber.shade700,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.amber.shade900,
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomActions extends StatelessWidget {
  final VoidCallback onSkip;
  final VoidCallback onSubmit;
  final bool canSubmit;

  const _BottomActions({
    required this.onSkip,
    required this.onSubmit,
    required this.canSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: auth.isLoading || !canSubmit ? null : onSubmit,
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
                          'Submit for Verification',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: auth.isLoading ? null : onSkip,
                child: const Text('Skip for Now'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SuccessDialog extends StatelessWidget {
  final VoidCallback onDismiss;

  const _SuccessDialog({required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle, color: Colors.green, size: 64),
          ),
          const SizedBox(height: 24),
          Text(
            'Documents Submitted!',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'Your verification documents have been submitted successfully. We\'ll review them within 24-48 hours.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onDismiss,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Continue to DigiLaw'),
            ),
          ),
        ],
      ),
    );
  }
}
