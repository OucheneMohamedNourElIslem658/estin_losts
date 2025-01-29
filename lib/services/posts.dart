// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

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

class Posts {
  static const _route = "/posts";
  static Future<PostsPaginationResult?> getPosts(BuildContext context, {
    String? query,
    PostType? type,
    String? userId,
    String? claimedOrFoundByUserId,
    double? locationLatitude,
    double? locationLongitude,
    bool? hasBeenFound,
    bool? hasBeenDelivered,
    int pageNumber = 1,
  }) async {
    var uri = Uri.parse("$host$_route/");

    final queryParams = {
      "content": query ?? "",
      "type": type?.toString().split('.').last ?? "",
      "user_id": userId ?? "",
      "claimed_or_found_by_user_id": claimedOrFoundByUserId ?? "",
      "location_latitude": locationLatitude?.toString() ?? "",
      "location_longitude": locationLongitude?.toString() ?? "",
      "has_been_found": hasBeenFound?.toString() ?? "",
      "has_been_delivered": hasBeenDelivered?.toString() ?? "",
      "page_size": "10",
      "page_number": pageNumber.toString(),
    };
    uri = uri.replace(queryParameters: queryParams);

    try {
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

      // case 400:
      //   final ok = await Auth.refreshIdToken(context);
      //   if (ok) {
      //     await getPosts(context);
      //   }
      //   return null;
      default:
      print(reponse.body);
        return null;
    }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}