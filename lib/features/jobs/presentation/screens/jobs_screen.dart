import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:only_law_app/features/jobs/domain/entities/job_entity.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen>
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
        title: const Text('Jobs & Opportunities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Jobs'),
            Tab(text: 'Pupillage'),
            Tab(text: 'My Posts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _JobsTab(),
          _PupillageTab(),
          _MyPostsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/jobs/post'),
        icon: const Icon(Icons.add),
        label: const Text('Post Job'),
      ),
    );
  }
}

class _JobsTab extends StatelessWidget {
  final _jobs = [
    JobEntity(
      id: '1',
      title: 'Senior Associate - Corporate Law',
      description: 'Looking for an experienced corporate lawyer...',
      firmName: 'Anjarwalla & Khanna',
      location: 'Nairobi',
      type: JobType.fullTime,
      experienceLevel: ExperienceLevel.senior,
      salaryRange: 'KES 300,000 - 500,000',
      requirements: ['5+ years experience', 'LLB Degree'],
      practiceAreas: ['Corporate Law', 'M&A'],
      postedAt: DateTime.now().subtract(const Duration(days: 2)),
      applicantsCount: 15,
    ),
    JobEntity(
      id: '2',
      title: 'Litigation Associate',
      description: 'Join our growing litigation team...',
      firmName: 'Bowmans Kenya',
      location: 'Nairobi',
      type: JobType.fullTime,
      experienceLevel: ExperienceLevel.midLevel,
      salaryRange: 'KES 200,000 - 350,000',
      requirements: ['3+ years experience', 'Litigation background'],
      practiceAreas: ['Litigation', 'Dispute Resolution'],
      postedAt: DateTime.now().subtract(const Duration(days: 5)),
      applicantsCount: 28,
    ),
    JobEntity(
      id: '3',
      title: 'Legal Counsel - Banking',
      description: 'In-house position at major bank...',
      firmName: 'Equity Bank',
      location: 'Nairobi',
      type: JobType.fullTime,
      experienceLevel: ExperienceLevel.senior,
      salaryRange: 'KES 400,000 - 600,000',
      requirements: ['7+ years experience', 'Banking law expertise'],
      practiceAreas: ['Banking & Finance'],
      postedAt: DateTime.now().subtract(const Duration(days: 1)),
      isRemote: true,
      applicantsCount: 42,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _jobs.length,
      itemBuilder: (context, index) {
        return _JobCard(job: _jobs[index]);
      },
    );
  }
}

class _PupillageTab extends StatelessWidget {
  final _pupillages = [
    JobEntity(
      id: 'p1',
      title: 'Pupillage Program 2024',
      description: 'Join our prestigious pupillage program...',
      firmName: 'Kaplan & Stratton',
      location: 'Nairobi',
      type: JobType.pupillage,
      experienceLevel: ExperienceLevel.entry,
      salaryRange: 'KES 50,000/month',
      requirements: ['LLB Degree', 'KSL Admission'],
      practiceAreas: ['General Practice'],
      postedAt: DateTime.now().subtract(const Duration(days: 10)),
      deadline: DateTime.now().add(const Duration(days: 20)),
      applicantsCount: 156,
    ),
    JobEntity(
      id: 'p2',
      title: 'Pupillage - Corporate Practice',
      description: 'Specialized corporate law pupillage...',
      firmName: 'Coulson Harney',
      location: 'Nairobi',
      type: JobType.pupillage,
      experienceLevel: ExperienceLevel.entry,
      salaryRange: 'KES 60,000/month',
      requirements: ['LLB Degree', 'Strong academics'],
      practiceAreas: ['Corporate Law'],
      postedAt: DateTime.now().subtract(const Duration(days: 7)),
      deadline: DateTime.now().add(const Duration(days: 14)),
      applicantsCount: 89,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pupillages.length,
      itemBuilder: (context, index) {
        return _JobCard(job: _pupillages[index], showDeadline: true);
      },
    );
  }
}

class _MyPostsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work_outline,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No job posts yet',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Post a job to find qualified candidates',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final JobEntity job;
  final bool showDeadline;

  const _JobCard({
    required this.job,
    this.showDeadline = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/jobs/${job.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Text(
                      job.firmName.substring(0, 1),
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          job.firmName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _InfoChip(
                    icon: Icons.location_on_outlined,
                    label: job.location,
                  ),
                  _InfoChip(
                    icon: Icons.work_outline,
                    label: _getJobTypeLabel(job.type),
                  ),
                  if (job.isRemote)
                    const _InfoChip(
                      icon: Icons.home_outlined,
                      label: 'Remote',
                      color: Colors.green,
                    ),
                ],
              ),
              if (job.salaryRange != null) ...[
                const SizedBox(height: 8),
                Text(
                  job.salaryRange!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${job.applicantsCount} applicants',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (showDeadline && job.deadline != null)
                    Text(
                      'Deadline: ${_formatDate(job.deadline!)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  else
                    Text(
                      _getTimeAgo(job.postedAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
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

  String _getTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return 'Just now';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _InfoChip({
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chipColor = color ?? theme.colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: chipColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: chipColor),
          ),
        ],
      ),
    );
  }
}
