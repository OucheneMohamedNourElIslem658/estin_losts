import 'package:estin_losts/shared/models/post.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? photoURL;
  final String? bio;
  final List<Post> posts;
  final List<Post> claimedPosts;
  final List<Post> foundPosts;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photoURL,
    this.bio,
    required this.posts,
    required this.claimedPosts,
    required this.foundPosts,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      photoURL: json['photo_url'],
      bio: json['bio'],
      posts: json['posts'],
      claimedPosts: json['claimed_posts'],
      foundPosts: json['found_posts'],
    );
  }
}

class Claims {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String postID;
  final String userID;
  final Post post;
  final User user;

  Claims({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.postID,
    required this.userID,
    required this.post,
    required this.user,
  });

  factory Claims.fromJson(Map<String, dynamic> json) {
    return Claims(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      postID: json['post_id'],
      userID: json['user_id'],
      post: json['post'],
      user: json['user'],
    );
  }
}

class Founders {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String postID;
  final String userID;
  final Post post;
  final User user;

  Founders({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.postID,
    required this.userID,
    required this.post,
    required this.user,
  });

  factory Founders.fromJson(Map<String, dynamic> json) {
    return Founders(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      postID: json['post_id'],
      userID: json['user_id'],
      post: json['post'],
      user: json['user'],
    );
  }
}