import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:only_law_app/features/feed/domain/entities/post_entity.dart';
import 'package:only_law_app/features/feed/presentation/providers/feed_provider.dart';
import 'package:only_law_app/features/feed/presentation/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<FeedProvider>(
          builder: (context, feedProvider, child) {
            if (feedProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: () => feedProvider.loadPosts(),
              child: CustomScrollView(
                slivers: [
                  // Custom App Bar
                  SliverToBoxAdapter(child: _FeedHeader()),

                  // Create Post Card
                  SliverToBoxAdapter(
                    child: _CreatePostCard(onTap: () => context.push('/feed/create')),
                  ),

                  // Trending Topics
                  SliverToBoxAdapter(child: _TrendingTopics()),

                  // Filter Tabs
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _FilterTabsDelegate(
                      selectedFilter: feedProvider.selectedFilter,
                      onFilterChanged: feedProvider.setFilter,
                    ),
                  ),

                  // Posts
                  if (feedProvider.posts.isEmpty)
                    SliverFillRemaining(child: _buildEmptyState(context))
                  else
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final post = feedProvider.posts[index];
                            return PostCard(
                              post: post,
                              onTap: () => context.push('/feed/${post.id}'),
                              onLike: () => feedProvider.toggleLike(post.id),
                              onComment: () => context.push('/feed/${post.id}'),
                              onShare: () => _sharePost(context, post),
                            );
                          },
                          childCount: feedProvider.posts.length,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.forum_outlined,
                size: 48,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text('No posts yet', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'Be the first to share insights with the legal community',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.push('/feed/create'),
              icon: const Icon(Icons.edit),
              label: const Text('Create Post'),
            ),
          ],
        ),
      ),
    );
  }

  void _sharePost(BuildContext context, PostEntity post) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon')),
    );
  }
}

class _FeedHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Text(
            'Community',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => context.push('/notifications'),
            icon: Badge(
              smallSize: 8,
              child: const Icon(Icons.notifications_outlined),
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
    );
  }
}

class _CreatePostCard extends StatelessWidget {
  final VoidCallback onTap;

  const _CreatePostCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  'JK',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Text(
                    'Share legal insights...',
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.edit, color: theme.colorScheme.onPrimary, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrendingTopics extends StatelessWidget {
  final _topics = const [
    ('Employment Act', Icons.work, Colors.blue),
    ('Land Law', Icons.landscape, Colors.green),
    ('Tax Updates', Icons.receipt_long, Colors.orange),
    ('Court Rules', Icons.gavel, Colors.purple),
    ('Cybercrime', Icons.security, Colors.red),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
              const SizedBox(width: 6),
              Text('Trending', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 36,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _topics.length,
            itemBuilder: (context, index) {
              final topic = _topics[index];
              return Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: (topic.$3 as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: (topic.$3 as Color).withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(topic.$2, size: 16, color: topic.$3),
                    const SizedBox(width: 6),
                    Text(
                      topic.$1,
                      style: TextStyle(fontSize: 13, color: topic.$3, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _FilterTabsDelegate extends SliverPersistentHeaderDelegate {
  final PostType? selectedFilter;
  final ValueChanged<PostType?> onFilterChanged;

  _FilterTabsDelegate({required this.selectedFilter, required this.onFilterChanged});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);

    final filters = [
      (null, 'All', Icons.dashboard_outlined),
      (PostType.discussion, 'Discussions', Icons.chat_bubble_outline),
      (PostType.legalUpdate, 'Updates', Icons.new_releases_outlined),
      (PostType.question, 'Q&A', Icons.help_outline),
      (PostType.caseAnalysis, 'Analysis', Icons.analytics_outlined),
    ];

    return Container(
      color: theme.colorScheme.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: filters.map((filter) {
            final isSelected = selectedFilter == filter.$1;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                avatar: Icon(
                  filter.$3,
                  size: 18,
                  color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant,
                ),
                label: Text(filter.$2),
                selected: isSelected,
                onSelected: (_) => onFilterChanged(filter.$1),
                showCheckmark: false,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 56;

  @override
  double get minExtent => 56;

  @override
  bool shouldRebuild(covariant _FilterTabsDelegate oldDelegate) {
    return selectedFilter != oldDelegate.selectedFilter;
  }
}
