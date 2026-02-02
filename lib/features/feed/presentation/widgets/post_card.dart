import 'package:flutter/material.dart';
import 'package:only_law_app/features/feed/domain/entities/post_entity.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;

  const PostCard({
    super.key,
    required this.post,
    this.onTap,
    this.onLike,
    this.onComment,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildContent(context),
            if (post.tags != null && post.tags!.isNotEmpty) _buildTags(context),
            _buildEngagement(context),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final typeInfo = _getTypeInfo(post.type);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar with online indicator
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: typeInfo.color.withValues(alpha: 0.3), width: 2),
                ),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    _getInitials(post.authorName),
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        post.authorName,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (post.type == PostType.announcement) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.verified, size: 16, color: theme.colorScheme.primary),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  post.authorTitle,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(post.createdAt),
                      style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _PostTypeBadge(type: post.type),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        post.content,
        style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
        maxLines: 8,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildTags(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: post.tags!.take(4).map((tag) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '#$tag',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEngagement(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          if (post.likesCount > 0) ...[
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite, size: 12, color: Colors.red),
            ),
            const SizedBox(width: 6),
            Text(
              '${post.likesCount} ${post.likesCount == 1 ? 'like' : 'likes'}',
              style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
          if (post.likesCount > 0 && post.commentsCount > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text('•', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
            ),
          if (post.commentsCount > 0)
            Text(
              '${post.commentsCount} ${post.commentsCount == 1 ? 'comment' : 'comments'}',
              style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5))),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              icon: post.isLiked ? Icons.favorite : Icons.favorite_outline,
              label: 'Like',
              isActive: post.isLiked,
              activeColor: Colors.red,
              onTap: onLike,
            ),
          ),
          Container(width: 1, height: 24, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
          Expanded(
            child: _ActionButton(
              icon: Icons.chat_bubble_outline,
              label: 'Comment',
              onTap: onComment,
            ),
          ),
          Container(width: 1, height: 24, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
          Expanded(
            child: _ActionButton(
              icon: Icons.share_outlined,
              label: 'Share',
              onTap: onShare,
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  _TypeInfo _getTypeInfo(PostType type) {
    switch (type) {
      case PostType.discussion:
        return _TypeInfo('Discussion', Icons.chat_bubble_outline, Colors.blue);
      case PostType.legalUpdate:
        return _TypeInfo('Update', Icons.new_releases_outlined, Colors.green);
      case PostType.caseAnalysis:
        return _TypeInfo('Analysis', Icons.analytics_outlined, Colors.purple);
      case PostType.question:
        return _TypeInfo('Question', Icons.help_outline, Colors.orange);
      case PostType.jobPosting:
        return _TypeInfo('Job', Icons.work_outline, Colors.teal);
      case PostType.announcement:
        return _TypeInfo('Official', Icons.campaign_outlined, Colors.red);
    }
  }
}

class _TypeInfo {
  final String label;
  final IconData icon;
  final Color color;

  _TypeInfo(this.label, this.icon, this.color);
}

class _PostTypeBadge extends StatelessWidget {
  final PostType type;

  const _PostTypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final info = _getInfo();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: info.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(info.icon, size: 14, color: info.color),
          const SizedBox(width: 4),
          Text(
            info.label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: info.color),
          ),
        ],
      ),
    );
  }

  _TypeInfo _getInfo() {
    switch (type) {
      case PostType.discussion:
        return _TypeInfo('Discussion', Icons.chat_bubble_outline, Colors.blue);
      case PostType.legalUpdate:
        return _TypeInfo('Update', Icons.new_releases_outlined, Colors.green);
      case PostType.caseAnalysis:
        return _TypeInfo('Analysis', Icons.analytics_outlined, Colors.purple);
      case PostType.question:
        return _TypeInfo('Question', Icons.help_outline, Colors.orange);
      case PostType.jobPosting:
        return _TypeInfo('Job', Icons.work_outline, Colors.teal);
      case PostType.announcement:
        return _TypeInfo('Official', Icons.campaign_outlined, Colors.red);
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color? activeColor;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.activeColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isActive ? (activeColor ?? theme.colorScheme.primary) : theme.colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
