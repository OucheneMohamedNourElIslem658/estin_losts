import 'package:estin_losts/shared/constents/utils.dart';
import 'package:estin_losts/shared/models/user.dart';

enum PostType { lost, found }

class Post {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final String? description;
  final double? locationLatitude;
  final double? locationLongitude;
  final String? locationDescription;
  final PostType type;
  final bool hasBeenFound;
  final bool hasBeenDelivered;
  final bool? claimedByUser;
  final bool? foundByUser;
  final String userID;
  final User? user;
  final List<PostImage>? images;
  final int? claimersCount;
  final List<User> claimers;
  final int? foundersCount;
  final List<User> founders;

  Post({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    this.description,
    this.locationLatitude,
    this.locationLongitude,
    this.locationDescription,
    required this.type,
    required this.hasBeenFound,
    required this.hasBeenDelivered,
    this.claimedByUser,
    this.foundByUser,
    required this.userID,
    this.user,
    required this.images,
    this.claimersCount,
    required this.claimers,
    this.foundersCount,
    required this.founders,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      title: json['title'],
      description: json['description'],
      locationLatitude: json['location_latitude'],
      locationLongitude: json['location_longitude'],
      locationDescription: json['location_description'],
      type: json['type'],
      hasBeenFound: json['has_been_found'],
      hasBeenDelivered: json['has_been_delivered'],
      claimedByUser: json['claimed_by_user'],
      foundByUser: json['found_by_user'],
      userID: json['user_id'],
      user: json['user'],
      images: json['images'],
      claimersCount: json['claimers_count'],
      claimers: json['claimers'],
      foundersCount: json['founders_count'],
      founders: json['founders'],
    );
  }
}

class PostImage {
  final String id;
  final String name;
  String url;
  final String fileStorageFolder;
  final String postID;
  final Post? post;

  PostImage({
    required this.url,
    required this.id,
    required this.name,
    required this.fileStorageFolder,
    required this.postID,
    this.post,
  }){
    url = Utils.getRandomImageURL();
  }

  factory PostImage.fromJson(Map<String, dynamic> json) {
    return PostImage(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      fileStorageFolder: json['file_storage_folder'],
      postID: json['post_id'],
      post: json['post'],
    );
  }
}