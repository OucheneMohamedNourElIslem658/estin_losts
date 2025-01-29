import 'package:estin_losts/shared/utils/utils.dart';
import 'package:estin_losts/shared/models/user.dart';

enum PostType { lost, found }

class Post {
  final String id;
  final DateTime createdAt;
  final String? timeAgo;
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
  final List<PostImage> images;
  final int claimersCount;
  final List<User> claimers;
  final int foundersCount;
  final List<User> founders;

  Post({
    required this.id,
    required this.createdAt,
    this.timeAgo,
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
    this.images = const [],
    this.claimersCount = 0,
    this.claimers = const [],
    this.foundersCount = 0,
    this.founders = const [],
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      timeAgo: json['time_ago'],
      updatedAt: DateTime.parse(json['updated_at']),
      title: json['title'],
      description: json['description'] ?? "",
      locationLatitude: json['location_latitude'] ?? 0.0,
      locationLongitude: json['location_longitude'] ?? 0.0,
      locationDescription: json['location_description'],
      type: json['type'] as String == 'lost' 
        ? PostType.lost 
        : PostType.found,  
      hasBeenFound: json['has_been_found'],
      hasBeenDelivered: json['has_been_delivered'],
      claimedByUser: json['claimed_by_user'],
      foundByUser: json['found_by_user'],
      userID: json['user_id'],
      user: json['user'] != null ? User.fromMap(json['user']) : null,
      images: ((json['images'] ?? []) as List<dynamic>)
        .map((imageJson) => PostImage.fromJson(imageJson))
        .toList(),
      claimersCount: json['claimers_count'] ?? 0,
      claimers: ((json['claimers'] ?? []) as List<dynamic>)
        .map((imageJson) => User.fromMap(imageJson))
        .toList(),
      foundersCount: json['founders_count'] ?? 0,
      founders: ((json['founders'] ?? []) as List<dynamic>)
        .map((imageJson) => User.fromMap(imageJson))
        .toList(),
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
    if (url  == "") {
      url = Utils.getRandomImageURL();
    } else {
      url = "http://$url";
    }
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