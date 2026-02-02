import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? labelText;
  final String? hintText;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.validator,
    this.labelText = 'Phone Number',
    this.hintText = '7XX XXX XXX',
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      enabled: enabled,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d\s\-+()]')),
        _KenyanPhoneFormatter(),
      ],
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🇰🇪', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                '+254',
                style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 8),
              Container(
                height: 24,
                width: 1,
                color: theme.colorScheme.outlineVariant,
              ),
            ],
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }
}

/// Formats Kenyan phone numbers as user types
class _KenyanPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digits
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Remove leading 0 or 254 if present (we show +254 prefix already)
    String normalized = digitsOnly;
    if (normalized.startsWith('254')) {
      normalized = normalized.substring(3);
    } else if (normalized.startsWith('0')) {
      normalized = normalized.substring(1);
    }

    // Limit to 9 digits (Kenyan mobile numbers after +254)
    if (normalized.length > 9) {
      normalized = normalized.substring(0, 9);
    }

    // Format as XXX XXX XXX
    final buffer = StringBuffer();
    for (int i = 0; i < normalized.length; i++) {
      if (i == 3 || i == 6) {
        buffer.write(' ');
      }
      buffer.write(normalized[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// A widget for entering OTP codes
class OtpInputField extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;

  const OtpInputField({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.onChanged,
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _currentValue => _controllers.map((c) => c.text).join();

  void _onChanged(int index, String value) {
    if (value.length == 1 && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    widget.onChanged?.call(_currentValue);

    if (_currentValue.length == widget.length) {
      widget.onCompleted(_currentValue);
    }
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 48,
          height: 56,
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) => _onKeyEvent(index, event),
            child: TextFormField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                ),
                filled: true,
                fillColor: _controllers[index].text.isNotEmpty
                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                    : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) => _onChanged(index, value),
            ),
          ),
        );
      }),
    );
  }
}
