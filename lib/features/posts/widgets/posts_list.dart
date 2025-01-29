import 'package:cached_network_image/cached_network_image.dart';
import 'package:estin_losts/features/posts/controllers/posts.dart';
import 'package:estin_losts/shared/widgets/profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../shared/constents/colors.dart';
import '../../../shared/constents/fonts.dart';
import '../../../shared/constents/posts_examples.dart';
import '../../../shared/models/post.dart';

class PostsList extends StatelessWidget {
  const PostsList({
    super.key, 
    this.postType
  });

  final PostType? postType;

  @override
  Widget build(BuildContext context) {
    final postController = Get.put(PostsController(), tag: 'main');

    return RefreshIndicator(
      onRefresh: () async => await postController.refreshPosts(
        context,
        postType: postType
      ),
      color: CustomColors.primaryBlue,
      child: GetBuilder<PostsController>(
        tag: "main",
        builder: (_) {
          final posts = postController.posts;

          if (postController.isLoading && (posts == null || posts.isEmpty)) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (posts == null || posts.isEmpty) {
            return const Center(
              child: Text(
                'Sorry!\nThere is no posts here :(',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: Fonts.airbndcereal,
                  color: Colors.black
                ),
              ),
            );
          }

          return NotificationListener(
            onNotification: (ScrollNotification notification) {
              if (notification.metrics.extentAfter < 500) {
                postController.appendToPosts(
                  context,
                  postType: postType
                );
              }
              return true;
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 100
                ),
                child: Column(
                  children: List.generate(
                    posts.length, 
                    (index) {
                      return PostCard(
                        post: posts[index]
                      );
                    }
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  const PostCard({
    super.key, 
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: CustomColors.grey1.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5)
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: ProfilePic(
              imageURL: post.user!.imageURL,
              size: 40,
            ),
            trailing: TypeLabel(
              type: post.type,
            ),
            title: Text(
              post.user!.name,
              style: const TextStyle(
                fontFamily: Fonts.airbndcereal,
                fontWeight: FontWeight.w600
              ),
            ),
            subtitle: Row(
              children: [
                if (post.locationDescription != null) const Icon(
                  Icons.location_on_outlined,
                  color: CustomColors.grey1,
                  size: 15,
                ),
                if (post.locationDescription != null) Expanded(
                  child: Text(
                    post.locationDescription!,
                    style: const TextStyle(
                      fontFamily: Fonts.airbndcereal,
                      color: CustomColors.grey1,
                      fontSize: 12
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            width: double.maxFinite,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: CachedNetworkImage(
                imageUrl: post.images.isEmpty
                  ? postImageURL
                  : post.images.first.url,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      post.title,
                      style:const TextStyle(
                        fontFamily: Fonts.airbndcereal,
                        fontWeight: FontWeight.w500,
                        fontSize: 18
                      ),
                    ),
                    if (post.timeAgo != null) Text(
                      post.timeAgo!,
                      style: const TextStyle(
                        fontFamily: Fonts.airbndcereal,
                        color: CustomColors.grey1,
                        fontSize: 12
                      ),
                    ),
                  ],
                ),
                if (post.description != null) Text(
                  post.description!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: Fonts.airbndcereal,
                    color: CustomColors.grey1,
                    fontSize: 13
                  ),
                ),
                const SizedBox(height: 10),
                ReactButtonButton(
                  onPressed: (){},
                  hasReacted: true,
                  post: post,
                  count: post.type == PostType.found 
                    ? post.claimersCount
                    : post.foundersCount
                ),
              ],
            ),
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}

class TypeLabel extends StatelessWidget {
  const TypeLabel({
    super.key,
    required this.type,
  });

  final PostType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 60,
      decoration: BoxDecoration(
        color: type == PostType.found 
        ? CustomColors.primaryBlue
        : CustomColors.red1,
        borderRadius: BorderRadius.circular(10)
      ),
      alignment: Alignment.center,
      child: Text(
        type.name.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontFamily: Fonts.airbndcereal,
          fontWeight: FontWeight.w600
        ),
      ),
    );
  }
}

class ReactButtonButton extends StatelessWidget {
  const ReactButtonButton({
    super.key,
    required this.onPressed,
    this.hasReacted = false,
    required this.post,
    this.count = 0,
  });

  final VoidCallback onPressed;
  final bool hasReacted;
  final Post post;
  final int count;

  @override
  Widget build(BuildContext context) {
    final primaryColor = post.type == PostType.found 
      ? CustomColors.primaryBlue 
      : CustomColors.red1;

    return Row(
      children: [
        OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
            side: BorderSide.none,
            backgroundColor: primaryColor.withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            )
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                !hasReacted ? Icons.back_hand_outlined : Icons.back_hand_rounded,
                color: primaryColor,
              ),
              const SizedBox(width: 5),
              Text(
                count.toString(),
                style: TextStyle(
                  fontFamily: Fonts.airbndcereal,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: primaryColor
                ),
              )
            ],
          ),
        ),
        const SizedBox(width:  10),
        if (count >= 1) FirstClaims(
          color: primaryColor,
          post: post
        )
      ],
    );
  }
}

class FirstClaims extends StatelessWidget {
  const FirstClaims({
    super.key,
    required this.color,
    required this.post
  });

  final Color color;
  final Post post;

  @override
  Widget build(BuildContext context) {
    final reactors = post.type == PostType.found 
      ? post.claimers
      : post.founders;

    final reactionsCount = post.type == PostType.found
      ? post.claimersCount
      : post.foundersCount;

    final othersCount = reactionsCount - reactors.length;

    final images = reactors
      .map((reactor) => reactor.imageURL)
      .toList();

    return Row(
      children: [
        Stack(
          children: List.generate(
            images.length, 
            (index) => Padding(
              padding: EdgeInsets.only(left: ((images.length - 1) - index)*20),
              child: SizedBox(
                height: 28,
                width: 28,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: images[index],
                    fit: BoxFit.cover,
                  ),
                ),
              )
            )
          ),
        ),
        const SizedBox(width: 5),
        if (othersCount >= 1) Text(
          "+$othersCount others",
          style: TextStyle(
            fontFamily: Fonts.airbndcereal,
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: color
          ),
        )
      ],
    );
  }
}

class NotificationButton extends StatelessWidget {
  const NotificationButton({
    super.key, 
    required this.onPressed, 
    this.isThereNewNotifications = true,
  });

  final VoidCallback onPressed;
  final bool isThereNewNotifications;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed, 
      icon: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: CustomColors.purple1
            ),
            child: SvgPicture.asset("assets/icons/notification.svg")
          ),
          if (isThereNewNotifications) Positioned(
            right: 10,
            top: 10,
            child: Container(
              height: 7,
              width: 7,
              decoration: BoxDecoration(
                color: CustomColors.blue1,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 1,
                  color: CustomColors.primaryBlue
                )
              ),
            ),
          )
        ],
      )
    );
  }
}