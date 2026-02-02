import 'package:flutter/material.dart';

class AppearanceSettingsScreen extends StatefulWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  State<AppearanceSettingsScreen> createState() => _AppearanceSettingsScreenState();
}

class _AppearanceSettingsScreenState extends State<AppearanceSettingsScreen> {
  String _themeMode = 'System';
  String _accentColor = 'Purple';
  String _language = 'English';
  double _textScale = 1.0;
  bool _reduceMotion = false;
  bool _highContrast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _Header()),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _SectionTitle(icon: Icons.dark_mode, title: 'Theme'),
                  const SizedBox(height: 12),
                  _ThemeSelector(
                    selected: _themeMode,
                    onChanged: (v) => setState(() => _themeMode = v),
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(icon: Icons.palette, title: 'Accent Color'),
                  const SizedBox(height: 12),
                  _ColorSelector(
                    selected: _accentColor,
                    onChanged: (v) => setState(() => _accentColor = v),
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(icon: Icons.language, title: 'Language'),
                  const SizedBox(height: 12),
                  _LanguageSelector(
                    selected: _language,
                    onChanged: (v) => setState(() => _language = v),
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(icon: Icons.text_fields, title: 'Text Size'),
                  const SizedBox(height: 12),
                  _TextScaleSlider(
                    value: _textScale,
                    onChanged: (v) => setState(() => _textScale = v),
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(icon: Icons.accessibility, title: 'Accessibility'),
                  const SizedBox(height: 12),
                  _AccessibilitySection(
                    reduceMotion: _reduceMotion,
                    highContrast: _highContrast,
                    onReduceMotionChanged: (v) => setState(() => _reduceMotion = v),
                    onHighContrastChanged: (v) => setState(() => _highContrast = v),
                  ),
                  const SizedBox(height: 24),
                  _PreviewCard(themeMode: _themeMode, accentColor: _accentColor),
                  const SizedBox(height: 24),
                ]),
              ),
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            style: IconButton.styleFrom(backgroundColor: theme.colorScheme.surfaceContainerHighest),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.palette, color: Colors.purple),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Appearance', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                Text('Customize your experience', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _ThemeSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final themes = [
      ('Light', Icons.light_mode, Colors.amber),
      ('Dark', Icons.dark_mode, Colors.indigo),
      ('System', Icons.settings_brightness, Colors.purple),
    ];

    return Row(
      children: themes.map((t) {
        final isSelected = selected == t.$1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: t.$1 != 'System' ? 12 : 0),
            child: InkWell(
              onTap: () => onChanged(t.$1),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? t.$3.withValues(alpha: 0.1) : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? t.$3 : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? t.$3.withValues(alpha: 0.2) : theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(t.$2, color: isSelected ? t.$3 : theme.colorScheme.onSurfaceVariant, size: 28),
                    ),
                    const SizedBox(height: 8),
                    Text(t.$1, style: theme.textTheme.labelLarge?.copyWith(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    if (isSelected)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: t.$3,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Active', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ColorSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _ColorSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colors = [
      ('Purple', Colors.deepPurple),
      ('Blue', Colors.blue),
      ('Teal', Colors.teal),
      ('Green', Colors.green),
      ('Orange', Colors.orange),
      ('Red', Colors.red),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: colors.map((c) {
          final isSelected = selected == c.$1;
          return InkWell(
            onTap: () => onChanged(c.$1),
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: c.$2,
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? Colors.white : Colors.transparent, width: 3),
                boxShadow: isSelected ? [BoxShadow(color: c.$2.withValues(alpha: 0.5), blurRadius: 8, spreadRadius: 2)] : null,
              ),
              child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _LanguageSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final languages = [
      ('English', '🇬🇧'),
      ('Kiswahili', '🇰🇪'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: languages.asMap().entries.map((entry) {
          final lang = entry.value;
          final isSelected = selected == lang.$1;
          final isLast = entry.key == languages.length - 1;

          return Column(
            children: [
              ListTile(
                leading: Text(lang.$2, style: const TextStyle(fontSize: 24)),
                title: Text(lang.$1, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                trailing: isSelected
                    ? Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check, size: 16, color: theme.colorScheme.onPrimary),
                      )
                    : null,
                onTap: () => onChanged(lang.$1),
              ),
              if (!isLast) const Divider(height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _TextScaleSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _TextScaleSlider({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text('A', style: TextStyle(fontSize: 14)),
              Expanded(
                child: Slider(
                  value: value,
                  min: 0.8,
                  max: 1.4,
                  divisions: 6,
                  label: '${(value * 100).round()}%',
                  onChanged: onChanged,
                ),
              ),
              const Text('A', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'This is a preview of your text size setting.',
              style: TextStyle(fontSize: 14 * value),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccessibilitySection extends StatelessWidget {
  final bool reduceMotion;
  final bool highContrast;
  final ValueChanged<bool> onReduceMotionChanged;
  final ValueChanged<bool> onHighContrastChanged;

  const _AccessibilitySection({
    required this.reduceMotion,
    required this.highContrast,
    required this.onReduceMotionChanged,
    required this.onHighContrastChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          _AccessibilityToggle(
            icon: Icons.animation,
            title: 'Reduce Motion',
            subtitle: 'Minimize animations',
            value: reduceMotion,
            onChanged: onReduceMotionChanged,
          ),
          const Divider(height: 1, indent: 56),
          _AccessibilityToggle(
            icon: Icons.contrast,
            title: 'High Contrast',
            subtitle: 'Increase color contrast',
            value: highContrast,
            onChanged: onHighContrastChanged,
          ),
        ],
      ),
    );
  }
}

class _AccessibilityToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _AccessibilityToggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  final String themeMode;
  final String accentColor;

  const _PreviewCard({required this.themeMode, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Changes will apply after you restart the app',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
