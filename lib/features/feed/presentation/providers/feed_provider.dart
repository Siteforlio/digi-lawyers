import 'package:flutter/foundation.dart';
import 'package:only_law_app/features/feed/domain/entities/post_entity.dart';

class FeedProvider extends ChangeNotifier {
  List<PostEntity> _posts = [];
  bool _isLoading = false;
  String? _error;
  PostType? _selectedFilter;

  List<PostEntity> get posts => _selectedFilter == null
      ? _posts
      : _posts.where((p) => p.type == _selectedFilter).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;
  PostType? get selectedFilter => _selectedFilter;

  FeedProvider() {
    loadPosts();
  }

  Future<void> loadPosts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _posts = _generateDummyPosts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFilter(PostType? type) {
    _selectedFilter = type;
    notifyListeners();
  }

  void toggleLike(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      _posts[index] = post.copyWith(
        isLiked: !post.isLiked,
        likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
      );
      notifyListeners();
    }
  }

  void addPost(PostEntity post) {
    _posts.insert(0, post);
    notifyListeners();
  }

  List<PostEntity> _generateDummyPosts() {
    return [
      PostEntity(
        id: '1',
        authorId: 'u1',
        authorName: 'Adv. Sarah Muthoni',
        authorTitle: 'Corporate Law Specialist',
        content:
            'Just had a landmark ruling on shareholder disputes. The court emphasized the importance of proper documentation in company resolutions. Key takeaway: Always ensure your AGM minutes are properly recorded and signed. #CorporateLaw #KenyaLaw',
        type: PostType.caseAnalysis,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        likesCount: 24,
        commentsCount: 8,
        tags: ['Corporate Law', 'Shareholder Disputes'],
      ),
      PostEntity(
        id: '2',
        authorId: 'u2',
        authorName: 'Adv. James Otieno',
        authorTitle: 'Criminal Defense Attorney',
        content:
            'Important update: The Judiciary has released new Practice Directions on virtual hearings. Key changes include mandatory pre-trial conferences for criminal matters. Check the Kenya Law Reports for the full document.',
        type: PostType.legalUpdate,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        likesCount: 56,
        commentsCount: 12,
        tags: ['Practice Directions', 'Virtual Hearings'],
      ),
      PostEntity(
        id: '3',
        authorId: 'u3',
        authorName: 'Adv. Grace Wambui',
        authorTitle: 'Family Law Practitioner',
        content:
            'Question for fellow advocates: How are you handling the new requirements for children matters under the Children Act amendments? Specifically regarding custody evaluations. Looking for insights on best practices.',
        type: PostType.question,
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        likesCount: 18,
        commentsCount: 23,
        tags: ['Family Law', 'Children Act'],
      ),
      PostEntity(
        id: '4',
        authorId: 'u4',
        authorName: 'Kiprop & Partners',
        authorTitle: 'Law Firm',
        content:
            'We are hiring! Looking for an Associate with 3-5 years experience in conveyancing and property law. Competitive salary, flexible working arrangements. Send your CV to careers@kiproplaw.co.ke',
        type: PostType.jobPosting,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        likesCount: 34,
        commentsCount: 5,
        tags: ['Job Opening', 'Property Law'],
      ),
      PostEntity(
        id: '5',
        authorId: 'u5',
        authorName: 'Law Society of Kenya',
        authorTitle: 'Official Account',
        content:
            'Reminder: Annual Practicing Certificate renewal deadline is approaching. All advocates must renew by March 31st to avoid penalties. The online portal is now open for applications.',
        type: PostType.announcement,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        likesCount: 89,
        commentsCount: 15,
        tags: ['LSK', 'Practicing Certificate'],
      ),
      PostEntity(
        id: '6',
        authorId: 'u6',
        authorName: 'Adv. Michael Kiprop',
        authorTitle: 'Land & Property Expert',
        content:
            'Interesting discussion at the ELC conference yesterday on adverse possession claims. The consensus is that the 12-year rule is becoming increasingly complex with digitization of land records. What are your thoughts?',
        type: PostType.discussion,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        likesCount: 42,
        commentsCount: 31,
        tags: ['Land Law', 'Adverse Possession'],
      ),
    ];
  }
}
