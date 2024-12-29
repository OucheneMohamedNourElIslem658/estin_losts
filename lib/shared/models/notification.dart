import 'package:estin_losts/shared/models/post.dart';

import 'user.dart';

enum NotificationTag { created, found, delivered }

class Notification {
  final String id;
  final String postID;
  final String userID;
  final Post post;
  final User user;
  final bool seen;
  final NotificationTag tag;

  Notification({
    required this.id,
    required this.postID,
    required this.userID,
    required this.post,
    required this.user,
    required this.seen,
    required this.tag,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      postID: json['post_id'],
      userID: json['user_id'],
      post: json['post'],
      user: json['user'],
      seen: json['seen'],
      tag: json['tag'],
    );
  } 
}
