import 'dart:convert';

import 'package:estin_losts/shared/models/post.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String imageURL;
  final List<Post> posts;
  final List<Post> claimedPosts;
  final List<Post> foundPosts;

  User({
    this.id = "",
    required this.name,
    required this.email,
    required this.imageURL,
    this.posts = const [],
    this.claimedPosts = const [],
    this.foundPosts = const [],
  });

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      imageURL: json['photo_url'],
      posts: json['posts'],
      claimedPosts: json['claimed_posts'],
      foundPosts: json['found_posts'],
    );
  }

  factory User.fromJson(String json) {
    return User.fromMap(jsonDecode(json));
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

  factory Claims.fromMap(Map<String, dynamic> json) {
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

  factory Founders.fromMap(Map<String, dynamic> json) {
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