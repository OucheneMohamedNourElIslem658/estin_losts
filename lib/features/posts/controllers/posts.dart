import 'package:estin_losts/services/posts.dart';
import 'package:estin_losts/shared/models/post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostsController extends GetxController {
  var desiredPageNumber = 1;
  var isLoading = false;
  List<Post>? posts;

  Future<void> appendToPosts(BuildContext context, {
    PostType? postType
  }) async {
    print("entred");
    isLoading = true;
    update();
    try {
      final result = await Posts.getPosts(
        context,
        type: postType,
        pageNumber: desiredPageNumber
      );
      if (result == null) return;
      desiredPageNumber = result.currentPage + 1;
      if (posts == null) {
        posts = result.posts;
      } else {
        posts!.addAll(result.posts);  
      }
    } finally {
      isLoading = false;
    }
    update();
  }

  Future<void> refreshPosts(BuildContext context, {
    PostType? postType
  }) async {
    isLoading = true;
    update();
    try {
      final result = await Posts.getPosts(
        context,
        type: postType,
        pageNumber: 1
      );
      if (result == null) return;
      desiredPageNumber = result.currentPage + 1;
      posts = result.posts;
      update();
    } finally {
      isLoading = false;
    }
  }
}