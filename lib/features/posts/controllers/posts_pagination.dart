import 'package:estin_losts/services/posts.dart';
import 'package:estin_losts/shared/models/post.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PostsPaginationController extends GetxController {
  final PostType? postType;
  final String? userID;
  final UserPostRelation? claimedOrFoundByUserID;
  final BuildContext context;

  PostsPaginationController(this.context, {
    this.postType,
    this.userID,
    this.claimedOrFoundByUserID
  });

  static const _pageSize = 2;
  final PagingController<int, Post> pagingController = PagingController(firstPageKey: 1);

  Future<void> _fetchPage(int pageKey) async {
    try {
      final result = await Posts.getPosts( 
        context,
        pageNumber: pageKey, 
        type: postType, 
        pageSize: _pageSize,
        userId: userID,
        claimedOrFoundByUserId: claimedOrFoundByUserID
      );
      if (result == null) {
        return;
      }
      final newItems = result.posts;
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  void onInit() {
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.onInit();
  }
}