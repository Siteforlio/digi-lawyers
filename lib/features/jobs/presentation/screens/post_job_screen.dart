import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:only_law_app/features/jobs/domain/entities/job_entity.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _salaryMinController = TextEditingController();
  final _salaryMaxController = TextEditingController();
  final _locationController = TextEditingController();

  JobType _selectedType = JobType.fullTime;
  ExperienceLevel _selectedLevel = ExperienceLevel.midLevel;
  bool _isRemote = false;
  final List<String> _selectedPracticeAreas = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _salaryMinController.dispose();
    _salaryMaxController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Job'),
        actions: [
          TextButton(
            onPressed: _submitJob,
            child: const Text('Post'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildBasicInfo(context),
            const SizedBox(height: 24),
            _buildJobType(context),
            const SizedBox(height: 24),
            _buildExperienceLevel(context),
            const SizedBox(height: 24),
            _buildSalary(context),
            const SizedBox(height: 24),
            _buildLocation(context),
            const SizedBox(height: 24),
            _buildPracticeAreas(context),
            const SizedBox(height: 24),
            _buildDescription(context),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _submitJob,
              child: const Text('Post Job'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfo(BuildContext context) {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Job Title *',
        hintText: 'e.g., Senior Associate - Corporate Law',
        prefixIcon: Icon(Icons.work_outline),
      ),
      validator: (v) => v?.isEmpty == true ? 'Title is required' : null,
    );
  }

  Widget _buildJobType(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Job Type',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: JobType.values.map((type) {
            return ChoiceChip(
              label: Text(_getJobTypeLabel(type)),
              selected: _selectedType == type,
              onSelected: (_) => setState(() => _selectedType = type),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExperienceLevel(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Experience Level',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ExperienceLevel.values.map((level) {
            return ChoiceChip(
              label: Text(_getExperienceLevelLabel(level)),
              selected: _selectedLevel == level,
              onSelected: (_) => setState(() => _selectedLevel = level),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSalary(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Salary Range (KES)',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _salaryMinController,
                decoration: const InputDecoration(
                  labelText: 'Minimum',
                  prefixText: 'KES ',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('-'),
            ),
            Expanded(
              child: TextFormField(
                controller: _salaryMaxController,
                decoration: const InputDecoration(
                  labelText: 'Maximum',
                  prefixText: 'KES ',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocation(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _locationController,
          decoration: const InputDecoration(
            labelText: 'Location *',
            hintText: 'e.g., Nairobi',
            prefixIcon: Icon(Icons.location_on_outlined),
          ),
          validator: (v) => v?.isEmpty == true ? 'Location is required' : null,
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          value: _isRemote,
          onChanged: (v) => setState(() => _isRemote = v ?? false),
          title: const Text('Remote work available'),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildPracticeAreas(BuildContext context) {
    final theme = Theme.of(context);
    final areas = [
      'Corporate Law',
      'Litigation',
      'Banking & Finance',
      'Real Estate',
      'Employment',
      'Tax',
      'IP',
      'Family Law',
      'Criminal Law',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Practice Areas',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: areas.map((area) {
            final isSelected = _selectedPracticeAreas.contains(area);
            return FilterChip(
              label: Text(area),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedPracticeAreas.add(area);
                  } else {
                    _selectedPracticeAreas.remove(area);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Job Description *',
        hintText: 'Describe the role, responsibilities, and what you\'re looking for...',
        alignLabelWithHint: true,
      ),
      maxLines: 6,
      validator: (v) => v?.isEmpty == true ? 'Description is required' : null,
    );
  }

  String _getJobTypeLabel(JobType type) {
    switch (type) {
      case JobType.fullTime:
        return 'Full-time';
      case JobType.partTime:
        return 'Part-time';
      case JobType.contract:
        return 'Contract';
      case JobType.pupillage:
        return 'Pupillage';
      case JobType.internship:
        return 'Internship';
    }
  }

  String _getExperienceLevelLabel(ExperienceLevel level) {
    switch (level) {
      case ExperienceLevel.entry:
        return 'Entry Level';
      case ExperienceLevel.midLevel:
        return 'Mid Level';
      case ExperienceLevel.senior:
        return 'Senior';
      case ExperienceLevel.partner:
        return 'Partner';
    }
  }

  void _submitJob() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job posted successfully')),
      );
      context.pop();
    }
  }
}
