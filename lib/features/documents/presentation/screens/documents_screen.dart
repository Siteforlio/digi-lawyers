import 'package:flutter/material.dart';
import 'package:only_law_app/features/documents/domain/entities/document_entity.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Files'),
            Tab(text: 'Templates'),
            Tab(text: 'Recent'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _MyFilesTab(),
          _TemplatesTab(),
          _RecentTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUploadOptions(context),
        icon: const Icon(Icons.add),
        label: const Text('Upload'),
      ),
    );
  }

  void _showUploadOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('Upload Document'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Scan Document'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.note_add_outlined),
              title: const Text('Create from Template'),
              onTap: () {
                Navigator.pop(context);
                _tabController.animateTo(1);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MyFilesTab extends StatelessWidget {
  final _folders = [
    ('Contracts', Icons.folder, 12, Colors.blue),
    ('Court Filings', Icons.folder, 8, Colors.orange),
    ('Correspondence', Icons.folder, 24, Colors.green),
    ('Client Documents', Icons.folder, 15, Colors.purple),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Folders',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: _folders.length,
          itemBuilder: (context, index) {
            final folder = _folders[index];
            return _FolderCard(
              name: folder.$1,
              icon: folder.$2,
              count: folder.$3,
              color: folder.$4,
            );
          },
        ),
        const SizedBox(height: 24),
        Text(
          'Recent Files',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _DocumentTile(
          name: 'Employment Contract - Kamau.pdf',
          category: 'Contracts',
          date: 'Today',
          size: '245 KB',
        ),
        _DocumentTile(
          name: 'Court Filing - HCCR2024.pdf',
          category: 'Court Filings',
          date: 'Yesterday',
          size: '1.2 MB',
        ),
        _DocumentTile(
          name: 'Client Agreement Draft.docx',
          category: 'Contracts',
          date: '2 days ago',
          size: '89 KB',
        ),
      ],
    );
  }
}

class _TemplatesTab extends StatelessWidget {
  final _templates = [
    ('Employment Contract', DocumentCategory.contract, 'Standard employment agreement'),
    ('Sale Agreement', DocumentCategory.agreement, 'Property sale agreement'),
    ('Power of Attorney', DocumentCategory.other, 'General power of attorney'),
    ('Affidavit Template', DocumentCategory.affidavit, 'Sworn statement template'),
    ('Demand Letter', DocumentCategory.correspondence, 'Payment demand letter'),
    ('Lease Agreement', DocumentCategory.agreement, 'Property lease contract'),
    ('Will Template', DocumentCategory.will, 'Last will and testament'),
    ('NDA Agreement', DocumentCategory.contract, 'Non-disclosure agreement'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _templates.length,
      itemBuilder: (context, index) {
        final template = _templates[index];
        return _TemplateTile(
          name: template.$1,
          category: template.$2,
          description: template.$3,
        );
      },
    );
  }
}

class _RecentTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _DocumentTile(
          name: 'Employment Contract - Kamau.pdf',
          category: 'Contracts',
          date: 'Today, 2:30 PM',
          size: '245 KB',
        ),
        _DocumentTile(
          name: 'Court Filing - HCCR2024.pdf',
          category: 'Court Filings',
          date: 'Today, 10:15 AM',
          size: '1.2 MB',
        ),
        _DocumentTile(
          name: 'Client Agreement Draft.docx',
          category: 'Contracts',
          date: 'Yesterday, 4:45 PM',
          size: '89 KB',
        ),
        _DocumentTile(
          name: 'Witness Statement.pdf',
          category: 'Court Filings',
          date: 'Jan 25, 2024',
          size: '156 KB',
        ),
        _DocumentTile(
          name: 'Property Deed - Wanjiku.pdf',
          category: 'Contracts',
          date: 'Jan 24, 2024',
          size: '2.1 MB',
        ),
      ],
    );
  }
}

class _FolderCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final int count;
  final Color color;

  const _FolderCard({
    required this.name,
    required this.icon,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                name,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$count files',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocumentTile extends StatelessWidget {
  final String name;
  final String category;
  final String date;
  final String size;

  const _DocumentTile({
    required this.name,
    required this.category,
    required this.date,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final extension = name.split('.').last.toUpperCase();

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getExtensionColor(extension).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              extension,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: _getExtensionColor(extension),
              ),
            ),
          ),
        ),
        title: Text(
          name,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text('$category • $size'),
        trailing: Text(
          date,
          style: theme.textTheme.bodySmall,
        ),
        onTap: () {},
      ),
    );
  }

  Color _getExtensionColor(String ext) {
    switch (ext) {
      case 'PDF':
        return Colors.red;
      case 'DOCX':
      case 'DOC':
        return Colors.blue;
      case 'XLSX':
      case 'XLS':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class _TemplateTile extends StatelessWidget {
  final String name;
  final DocumentCategory category;
  final String description;

  const _TemplateTile({
    required this.name,
    required this.category,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.description_outlined,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          name,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(description),
        trailing: FilledButton.tonal(
          onPressed: () {},
          child: const Text('Use'),
        ),
        onTap: () {},
      ),
    );
  }
}
