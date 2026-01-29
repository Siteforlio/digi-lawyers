class CommentEntity {
  final String id;
  final String postId;
  final String authorId;
  final String authorName;
  final String? authorImageUrl;
  final String content;
  final DateTime createdAt;
  final int likesCount;
  final bool isLiked;

  const CommentEntity({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorName,
    this.authorImageUrl,
    required this.content,
    required this.createdAt,
    this.likesCount = 0,
    this.isLiked = false,
  });
}
