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
      appBar: AppBar(
        title: const Text('Feed'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<FeedProvider>(
        builder: (context, feedProvider, child) {
          if (feedProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (feedProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${feedProvider.error}'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => feedProvider.loadPosts(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              _FilterChips(
                selectedFilter: feedProvider.selectedFilter,
                onFilterChanged: feedProvider.setFilter,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => feedProvider.loadPosts(),
                  child: feedProvider.posts.isEmpty
                      ? _buildEmptyState(context)
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: feedProvider.posts.length,
                          itemBuilder: (context, index) {
                            final post = feedProvider.posts[index];
                            return PostCard(
                              post: post,
                              onTap: () => context.push('/feed/${post.id}'),
                              onLike: () => feedProvider.toggleLike(post.id),
                              onComment: () => context.push('/feed/${post.id}'),
                              onShare: () => _sharePost(context, post),
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/feed/create'),
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No posts yet',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to share something',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _sharePost(BuildContext context, PostEntity post) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon')),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final PostType? selectedFilter;
  final ValueChanged<PostType?> onFilterChanged;

  const _FilterChips({
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      (null, 'All'),
      (PostType.discussion, 'Discussions'),
      (PostType.legalUpdate, 'Updates'),
      (PostType.question, 'Questions'),
      (PostType.jobPosting, 'Jobs'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter.$2),
              selected: isSelected,
              onSelected: (_) => onFilterChanged(filter.$1),
            ),
          );
        }).toList(),
      ),
    );
  }
}
