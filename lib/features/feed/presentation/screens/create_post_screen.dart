import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:only_law_app/features/feed/domain/entities/post_entity.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();
  PostType _selectedType = PostType.discussion;
  final List<String> _tags = [];

  @override
  void dispose() {
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton(
            onPressed: _canPost() ? _submitPost : null,
            child: const Text('Post'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAuthorHeader(context),
            const SizedBox(height: 16),
            _buildTypeSelector(context),
            const SizedBox(height: 16),
            _buildContentField(context),
            const SizedBox(height: 16),
            _buildTagsSection(context),
            const SizedBox(height: 24),
            _buildAttachmentOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthorHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            'JK',
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Adv. John Kamau',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Posting as yourself',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeSelector(BuildContext context) {
    final theme = Theme.of(context);

    final types = [
      (PostType.discussion, 'Discussion', Icons.forum_outlined),
      (PostType.question, 'Question', Icons.help_outline),
      (PostType.caseAnalysis, 'Case Analysis', Icons.analytics_outlined),
      (PostType.legalUpdate, 'Legal Update', Icons.update),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Post Type',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: types.map((type) {
            final isSelected = _selectedType == type.$1;
            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(type.$3, size: 18),
                  const SizedBox(width: 4),
                  Text(type.$2),
                ],
              ),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _selectedType = type.$1;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildContentField(BuildContext context) {
    String hintText;
    switch (_selectedType) {
      case PostType.discussion:
        hintText = 'Start a discussion with your colleagues...';
        break;
      case PostType.question:
        hintText = 'What would you like to ask the community?';
        break;
      case PostType.caseAnalysis:
        hintText = 'Share your case analysis or insights...';
        break;
      case PostType.legalUpdate:
        hintText = 'Share an important legal update...';
        break;
      default:
        hintText = 'What\'s on your mind?';
    }

    return TextField(
      controller: _contentController,
      maxLines: 8,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        alignLabelWithHint: true,
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  Widget _buildTagsSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (_tags.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _tags.map((tag) {
              return Chip(
                label: Text('#$tag'),
                onDeleted: () {
                  setState(() {
                    _tags.remove(tag);
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
        ],
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _tagsController,
                decoration: InputDecoration(
                  hintText: 'Add a tag (e.g., CorporateLaw)',
                  prefixIcon: const Icon(Icons.tag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onSubmitted: _addTag,
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: () => _addTag(_tagsController.text),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            _SuggestedTag(
              label: 'Corporate Law',
              onTap: () => _addTag('CorporateLaw'),
            ),
            _SuggestedTag(
              label: 'Land Law',
              onTap: () => _addTag('LandLaw'),
            ),
            _SuggestedTag(
              label: 'Family Law',
              onTap: () => _addTag('FamilyLaw'),
            ),
            _SuggestedTag(
              label: 'Criminal Law',
              onTap: () => _addTag('CriminalLaw'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAttachmentOptions(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attachments',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _AttachmentButton(
              icon: Icons.image_outlined,
              label: 'Image',
              onTap: () {},
            ),
            const SizedBox(width: 12),
            _AttachmentButton(
              icon: Icons.attach_file,
              label: 'Document',
              onTap: () {},
            ),
            const SizedBox(width: 12),
            _AttachmentButton(
              icon: Icons.link,
              label: 'Link',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  void _addTag(String tag) {
    final trimmed = tag.trim().replaceAll(' ', '');
    if (trimmed.isNotEmpty && !_tags.contains(trimmed)) {
      setState(() {
        _tags.add(trimmed);
        _tagsController.clear();
      });
    }
  }

  bool _canPost() {
    return _contentController.text.trim().isNotEmpty;
  }

  void _submitPost() {
    if (!_canPost()) return;

    // In real app, add to provider
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post created successfully')),
    );
    context.pop();
  }
}

class _SuggestedTag extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SuggestedTag({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      avatar: const Icon(Icons.add, size: 16),
      onPressed: onTap,
    );
  }
}

class _AttachmentButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AttachmentButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
