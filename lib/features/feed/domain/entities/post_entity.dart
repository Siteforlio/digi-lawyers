class PostEntity {
  final String id;
  final String authorId;
  final String authorName;
  final String authorTitle;
  final String? authorImageUrl;
  final String content;
  final PostType type;
  final DateTime createdAt;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final List<String>? tags;

  const PostEntity({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorTitle,
    this.authorImageUrl,
    required this.content,
    required this.type,
    required this.createdAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
    this.tags,
  });

  PostEntity copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorTitle,
    String? authorImageUrl,
    String? content,
    PostType? type,
    DateTime? createdAt,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
    List<String>? tags,
  }) {
    return PostEntity(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorTitle: authorTitle ?? this.authorTitle,
      authorImageUrl: authorImageUrl ?? this.authorImageUrl,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      tags: tags ?? this.tags,
    );
  }
}

enum PostType {
  discussion,
  legalUpdate,
  caseAnalysis,
  question,
  jobPosting,
  announcement,
}
