import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:only_law_app/features/auth/data/models/user_model.dart';
import 'package:only_law_app/features/auth/domain/entities/user_entity.dart';
import 'package:only_law_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:only_law_app/features/auth/presentation/widgets/phone_input_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _pageController = PageController();
  int _currentStep = 0;
  final _totalSteps = 3;

  // Step 1: Basic Info
  final _basicFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;

  // Step 2: Professional Info
  final _professionalFormKey = GlobalKey<FormState>();
  final _lskNumberController = TextEditingController();
  final _admissionYearController = TextEditingController();
  final _lawFirmController = TextEditingController();
  String? _selectedPosition;

  // Step 3: Practice Areas
  final Set<PracticeArea> _selectedPracticeAreas = {};

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _lskNumberController.dispose();
    _admissionYearController.dispose();
    _lawFirmController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (!_basicFormKey.currentState!.validate()) return;
      if (!_agreedToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please agree to the Terms & Conditions')),
        );
        return;
      }
    } else if (_currentStep == 1) {
      if (!_professionalFormKey.currentState!.validate()) return;
    }

    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _handleRegister();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      context.pop();
    }
  }

  Future<void> _handleRegister() async {
    if (_selectedPracticeAreas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one practice area')),
      );
      return;
    }

    final registerData = RegisterData(
      fullName: _nameController.text.trim(),
      phone: '+254${_phoneController.text.replaceAll(' ', '')}',
      email: _emailController.text.trim(),
      password: _passwordController.text,
      lskNumber: _lskNumberController.text.trim().toUpperCase(),
      admissionYear: int.parse(_admissionYearController.text.trim()),
      lawFirm: _lawFirmController.text.trim().isNotEmpty ? _lawFirmController.text.trim() : null,
      position: _selectedPosition,
      practiceAreas: _selectedPracticeAreas.toList(),
    );

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(registerData);

    if (success && mounted) {
      context.go('/otp', extra: {'phone': registerData.phone, 'isRegistration': true});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              onBack: _previousStep,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _BasicInfoStep(
                    formKey: _basicFormKey,
                    nameController: _nameController,
                    phoneController: _phoneController,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                    obscurePassword: _obscurePassword,
                    obscureConfirmPassword: _obscureConfirmPassword,
                    agreedToTerms: _agreedToTerms,
                    onTogglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
                    onToggleConfirmPassword: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    onTermsChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                  ),
                  _ProfessionalInfoStep(
                    formKey: _professionalFormKey,
                    lskNumberController: _lskNumberController,
                    admissionYearController: _admissionYearController,
                    lawFirmController: _lawFirmController,
                    selectedPosition: _selectedPosition,
                    onPositionChanged: (v) => setState(() => _selectedPosition = v),
                  ),
                  _PracticeAreasStep(
                    selectedAreas: _selectedPracticeAreas,
                    onAreaToggled: (area) {
                      setState(() {
                        if (_selectedPracticeAreas.contains(area)) {
                          _selectedPracticeAreas.remove(area);
                        } else {
                          _selectedPracticeAreas.add(area);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            _BottomActions(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              onNext: _nextStep,
              onPrevious: _previousStep,
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;

  const _Header({required this.currentStep, required this.totalSteps, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final stepTitles = ['Basic Info', 'Professional', 'Practice Areas'];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back),
                style: IconButton.styleFrom(backgroundColor: theme.colorScheme.surfaceContainerHighest),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create Account', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    Text('Step ${currentStep + 1} of $totalSteps: ${stepTitles[currentStep]}',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(totalSteps, (index) {
              final isActive = index <= currentStep;
              final isCompleted = index < currentStep;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index < totalSteps - 1 ? 8 : 0),
                  height: 4,
                  decoration: BoxDecoration(
                    color: isActive ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _BasicInfoStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool agreedToTerms;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final ValueChanged<bool?> onTermsChanged;

  const _BasicInfoStep({
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.agreedToTerms,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onTermsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Personal Information', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Full Name',
                hintText: 'As it appears on your practicing certificate',
                prefixIcon: const Icon(Icons.person_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) => v == null || v.trim().length < 3 ? 'Enter your full name' : null,
            ),
            const SizedBox(height: 16),
            PhoneInputField(
              controller: phoneController,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Phone number is required';
                final cleaned = v.replaceAll(RegExp(r'[\s\-()]'), '');
                if (cleaned.length < 9) return 'Enter a valid phone number';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: 'your@email.com',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email is required';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              obscureText: obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  icon: Icon(obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                  onPressed: onTogglePassword,
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password is required';
                if (v.length < 8) return 'Password must be at least 8 characters';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: const Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  icon: Icon(obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                  onPressed: onToggleConfirmPassword,
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) {
                if (v != passwordController.text) return 'Passwords do not match';
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(value: agreedToTerms, onChanged: onTermsChanged),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: 'I agree to the ',
                      style: theme.textTheme.bodySmall,
                      children: [
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w500),
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfessionalInfoStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController lskNumberController;
  final TextEditingController admissionYearController;
  final TextEditingController lawFirmController;
  final String? selectedPosition;
  final ValueChanged<String?> onPositionChanged;

  const _ProfessionalInfoStep({
    required this.formKey,
    required this.lskNumberController,
    required this.admissionYearController,
    required this.lawFirmController,
    required this.selectedPosition,
    required this.onPositionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentYear = DateTime.now().year;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Professional Details', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'This information will be verified with the Law Society of Kenya',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: lskNumberController,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: 'LSK Admission Number *',
                hintText: 'LSK/XXXX/YYYY',
                prefixIcon: const Icon(Icons.badge_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                helperText: 'Format: LSK/1234/2015',
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'LSK number is required';
                if (!RegExp(r'^LSK/\d{1,5}/\d{4}$', caseSensitive: false).hasMatch(v.trim())) {
                  return 'Enter a valid LSK number (e.g., LSK/1234/2015)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: admissionYearController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Year of Admission *',
                hintText: 'YYYY',
                prefixIcon: const Icon(Icons.calendar_today_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Year is required';
                final year = int.tryParse(v);
                if (year == null || year < 1960 || year > currentYear) {
                  return 'Enter a valid year (1960-$currentYear)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: lawFirmController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Law Firm / Organization (Optional)',
                hintText: 'e.g., Kamau & Associates Advocates',
                prefixIcon: const Icon(Icons.business_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedPosition,
              decoration: InputDecoration(
                labelText: 'Position (Optional)',
                prefixIcon: const Icon(Icons.work_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: LawyerPosition.values.map((pos) {
                return DropdownMenuItem(value: pos.displayName, child: Text(pos.displayName));
              }).toList(),
              onChanged: onPositionChanged,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.amber, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your credentials will be verified within 24-48 hours after document submission.',
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.amber.shade800),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PracticeAreasStep extends StatelessWidget {
  final Set<PracticeArea> selectedAreas;
  final ValueChanged<PracticeArea> onAreaToggled;

  const _PracticeAreasStep({required this.selectedAreas, required this.onAreaToggled});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Practice Areas', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            'Select your areas of expertise (you can select multiple)',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: PracticeArea.values.map((area) {
              final isSelected = selectedAreas.contains(area);
              return FilterChip(
                label: Text(area.displayName),
                selected: isSelected,
                onSelected: (_) => onAreaToggled(area),
                selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
                checkmarkColor: theme.colorScheme.primary,
                side: BorderSide(
                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          if (selectedAreas.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    '${selectedAreas.length} area${selectedAreas.length > 1 ? 's' : ''} selected',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const _BottomActions({
    required this.currentStep,
    required this.totalSteps,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    final isLastStep = currentStep == totalSteps - 1;

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
          return Row(
            children: [
              if (currentStep > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: auth.isLoading ? null : onPrevious,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Back'),
                  ),
                ),
              if (currentStep > 0) const SizedBox(width: 12),
              Expanded(
                flex: currentStep > 0 ? 2 : 1,
                child: FilledButton(
                  onPressed: auth.isLoading ? null : onNext,
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
                      : Text(
                          isLastStep ? 'Create Account' : 'Continue',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
