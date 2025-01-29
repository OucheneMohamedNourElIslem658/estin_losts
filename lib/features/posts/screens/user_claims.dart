import 'package:estin_losts/features/posts/controllers/posts_pagination.dart';
import 'package:estin_losts/features/posts/widgets/post_tile.dart';
import 'package:estin_losts/services/auth.dart';
import 'package:estin_losts/services/posts.dart';
import 'package:estin_losts/shared/constents/colors.dart';
import 'package:estin_losts/shared/constents/fonts.dart';
import 'package:estin_losts/shared/models/post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class UserClaimsScreen extends StatelessWidget {
  const UserClaimsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postsPaginationController = Get.put(
      PostsPaginationController(
        context, 
        userID: Auth.currentUser!.id,
        claimedOrFoundByUserID: UserPostRelation.claimed
      ), 
      tag: 'user-claims'
    );

    final pagingController = postsPaginationController.pagingController;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            snap: true,
            floating: true,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.arrow_back_rounded, 
                color: Colors.black,
                size: 30,
              )
            ),
            title: const Text(
              "My Claims",
              style: TextStyle(
                color: CustomColors.black1,
                fontSize: 25,
                fontFamily: Fonts.airbndcereal,
                fontWeight: FontWeight.w500
              ),
            ),
          )
        ], 
        body: GetBuilder<PostsPaginationController>(
          tag: 'user-claims',
          dispose: (_) => Get.delete<PostsPaginationController>(tag: 'user-claims'),
          builder: (_) {
            return RefreshIndicator(
              onRefresh: () => Future.sync(() => pagingController.refresh()),
              child: PagedListView<int, Post>(
                pagingController: pagingController,
                builderDelegate: PagedChildBuilderDelegate<Post>(
                  firstPageProgressIndicatorBuilder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  newPageProgressIndicatorBuilder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  firstPageErrorIndicatorBuilder: (context) => const Center(
                    child: Text(
                      'Error Occurred!',
                      style: TextStyle(
                        color: CustomColors.grey1,
                        fontFamily: Fonts.airbndcereal,
                        fontWeight: FontWeight.w500,
                        fontSize: 25
                      ),
                    ),
                  ),
                  noItemsFoundIndicatorBuilder: (context) => const Center(
                    child: Text(
                      'No posts here yet!',
                      style: TextStyle(
                        color: CustomColors.grey1,
                        fontFamily: Fonts.airbndcereal,
                        fontWeight: FontWeight.w500,
                        fontSize: 25
                      ),
                    ),
                  ),
                  newPageErrorIndicatorBuilder: (context) => const Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: CustomColors.grey1,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Error Occured',
                          style: TextStyle(
                            color: CustomColors.grey1,
                            fontFamily: Fonts.airbndcereal,
                            fontSize: 15
                          ),
                        ),
                      ],
                    ),
                  ),
                  itemBuilder: (context, post, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: PostTile(post: post),
                  ),
                ),
              ),
            );
          }
        ),
      )
    );
  }
}