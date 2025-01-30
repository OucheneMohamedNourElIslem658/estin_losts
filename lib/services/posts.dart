// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:estin_losts/services/auth.dart';
import 'package:estin_losts/shared/constents/backend.dart';
import 'package:estin_losts/shared/models/post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// type GetPostsDTO struct {
// 	Content                string                 `form:"content"`
// 	Type                   string                 `form:"type" binding:"omitempty,oneof=lost found"`
// 	UserID                 string                 `form:"user_id"`
// 	ClaimedOrFoundByUserID ClaimedOrFoundByUserID `form:"claimed_or_found_by_user_id" binding:"omitempty,required_with=user_id,oneof=claimed found"`
// 	LocationLatitude       *float64               `form:"location_latitude" binding:"omitempty,required_with=LocationLongitude,min=-90,max=90"`
// 	LocationLongitude      *float64               `form:"location_longitude" binding:"omitempty,required_with=LocationLatitude,min=-180,max=180"`
// 	AppendWith             string                 `form:"append_with"`
// 	HasBeenFound           *bool                  `form:"has_been_found"`
// 	HasBeenDelivered       *bool                  `form:"has_been_delivered"`
// 	PageSize               int                    `form:"page_size,default=10" binding:"min=1"`
// 	PageNumber             int                    `form:"page_number,default=1" binding:"min=1"`
// }

class PostsPaginationResult {
  final List<Post> posts;
  final int totalPages;
  final int currentPage;

  PostsPaginationResult({
    required this.posts,
    required this.totalPages,
    required this.currentPage,
  });
}

enum UserPostRelation {
  claimed,
  found,
}

class Posts {
  static const _route = "/posts";
  static Future<PostsPaginationResult?> getPosts(BuildContext context, {
    String? query,
    PostType? type,
    String? userId,
    UserPostRelation? claimedOrFoundByUserId,
    double? locationLatitude,
    double? locationLongitude,
    bool? hasBeenFound,
    bool? hasBeenDelivered,
    int pageNumber = 1,
    int pageSize = 10
  }) async {
    var uri = Uri.parse("$host$_route/");

    final queryParams = {
      "content": query ?? "",
      "type": type?.toString().split('.').last ?? "",
      "user_id": userId ?? "",
      "claimed_or_found_by_user_id": claimedOrFoundByUserId?.toString().split('.').last ?? "",
      "location_latitude": locationLatitude?.toString() ?? "",
      "location_longitude": locationLongitude?.toString() ?? "",
      "has_been_found": hasBeenFound?.toString() ?? "",
      "has_been_delivered": hasBeenDelivered?.toString() ?? "",
      "page_size": pageSize.toString(),
      "page_number": pageNumber.toString(),
    };
    
    uri = uri.replace(queryParameters: queryParams);
      final reponse = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
      }
    );

    switch (reponse.statusCode) {
      case 200:
        final bodyJson = json.decode(reponse.body);

        final postsJson = bodyJson["posts"] as List<dynamic>;
        final posts = postsJson
        .map((postJson) {
          return Post.fromJson(postJson);
        })
        .toList();

        final totalPages = bodyJson["total_pages_number"] as int;
        final currentPage = bodyJson["page_number"] as int;

        return PostsPaginationResult(
          posts: posts,
          totalPages: totalPages,
          currentPage: currentPage,
        );

      default:
        final bodyJson = json.decode(reponse.body);
        throw Exception(bodyJson["message"]);
    }
  }

  static Future<void> addPost(BuildContext context, {
    required String title,
    required PostType type,
    String? description,
    String? locationDescription,
    List<File>? images,
  }) async {
    final uri = Uri.parse("$host$_route/");

    final request = http.MultipartRequest(
      "POST",
      uri,
    );

    // add headers
    request.headers.addAll({
      "Content-Type": "multipart/form-data",
      "Authorization": "Bearer ${Auth.idToken}"
    });

    request.fields["title"] = title;
    request.fields["type"] = type.toString().split('.').last;
    request.fields["description"] = description ?? "";
    request.fields["location_description"] = locationDescription ?? "";

    images = images ?? [];

     for (var image in images) {
      var fileStream = http.ByteStream(image.openRead());
      var length = await image.length();

      var multipartFile = http.MultipartFile(
        'images',
        fileStream,
        length,
        filename: image.path.split('/').last,
      );

      request.files.add(multipartFile);
    }

    final streamedResponse = await request.send();
    final response = await streamedResponse.stream.bytesToString();

    switch (streamedResponse.statusCode) {
      case 201:
        return;
      case 401:
        final ok = await Auth.refreshIdToken(context);
        if (ok) {
          return addPost(
            context,
            title: title,
            type: type,
            description: description,
            locationDescription: locationDescription,
            images: images,
          );
        }
        return;
      default:
        final bodyJson = json.decode(response);
        throw Exception(bodyJson["message"]);
    }
  }

  static Future<Post?> getPost(String id) async {
    final uri = Uri.parse("$host$_route/$id");

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
      }
    );

    switch (response.statusCode) {
      case 200:
        final bodyJson = json.decode(response.body);
        return Post.fromJson(bodyJson);
      default:
        final bodyJson = json.decode(response.body);
        throw Exception(bodyJson["message"]);
    }
  }

  static Future<void> claimPost(BuildContext context, String id) async {
    final uri = Uri.parse("$host$_route/$id/claim");

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Auth.idToken}"
      }
    );

    final body = response.body;

    switch (response.statusCode) {
      case 200:
        return;
      case 401:
        final ok = await Auth.refreshIdToken(context);
        if (ok) {
          return claimPost(context, id);
        }
        return;
      default:
        final bodyJson = json.decode(body);
        throw Exception(bodyJson["message"]);
    }
  }

  static Future<void> foundPost(BuildContext context, String id) async {
    final uri = Uri.parse("$host$_route/$id/found");

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Auth.idToken}"
      }
    );

    final body = response.body;

    switch (response.statusCode) {
      case 200:
        return;
      case 401:
        final ok = await Auth.refreshIdToken(context);
        if (ok) {
          return foundPost(context, id);
        }
        return;
      default:
        final bodyJson = json.decode(body);
        throw Exception(bodyJson["message"]);
    }
  }

  static Future<void> unclaimPost(BuildContext context, String id) async {
    final uri = Uri.parse("$host$_route/$id/unclaim");

    final response = await http.delete(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Auth.idToken}"
      }
    );

    final body = response.body;

    switch (response.statusCode) {
      case 200:
        return;
      case 401:
        final ok = await Auth.refreshIdToken(context);
        if (ok) {
          return unclaimPost(context, id);
        }
        return;
      default:
        final bodyJson = json.decode(body);
        throw Exception(bodyJson["message"]);
    }
  }

  static Future<void> unfoundPost(BuildContext context, String id) async {
    final uri = Uri.parse("$host$_route/$id/unfound");

    final response = await http.delete(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Auth.idToken}"
      }
    );

    final body = response.body;

    switch (response.statusCode) {
      case 200:
        return;
      case 401:
        final ok = await Auth.refreshIdToken(context);
        if (ok) {
          return unfoundPost(context, id);
        }
        return;
      default:
        final bodyJson = json.decode(body);
        throw Exception(bodyJson["message"]);
    }
  }
}