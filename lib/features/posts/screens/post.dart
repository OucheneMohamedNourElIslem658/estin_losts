import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:estin_losts/features/posts/controllers/post_bottom_bar.dart';
import 'package:estin_losts/features/posts/widgets/posts_list.dart';
import 'package:estin_losts/services/auth.dart';
import 'package:estin_losts/services/posts.dart';
import 'package:estin_losts/shared/constents/colors.dart';
import 'package:estin_losts/shared/constents/fonts.dart';
import 'package:estin_losts/shared/models/post.dart';
import 'package:estin_losts/shared/screens/image.dart';
import 'package:estin_losts/shared/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({
    super.key,
    required this.postID
  });

  final String postID;

  @override
  Widget build(BuildContext context) {
    final postBottomBarController = Get.put(PostBottomBarController());

    final scrollController = postBottomBarController.scrollController;
    final bottomBarAnimationController = postBottomBarController.bottomBarAnimationController;
    final bottomBarAnimation = postBottomBarController.bottomBarAnimation;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(), 
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Post Detail",
          style: TextStyle(
            fontFamily: Fonts.airbndcereal,
            fontWeight: FontWeight.w500,
            color: Colors.white
          ),
        ),
      ),
      body: GetBuilder<PostBottomBarController>(
        dispose: (_) => Get.delete<PostBottomBarController>(),
        builder: (_) {
          return FutureBuilder<Post?>(
            future: Posts.getPost(postID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LinearProgressIndicator();
              }
          
              if (snapshot.data == null) {
                return const  Text(
                  'Error Occurred!',
                  style: TextStyle(
                    color: CustomColors.grey1,
                    fontFamily: Fonts.airbndcereal,
                    fontWeight: FontWeight.w500,
                    fontSize: 25
                  ),
                );
              }
          
              final post = snapshot.data;
          
              return Stack(
                children: [
                  Positioned.fill(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PostImagesSlider(
                            images: post!.images,
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: PostInfo(
                              post: post
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  if (post.userID != Auth.currentUser!.id) AnimatedBuilder(
                    animation: bottomBarAnimationController,
                    builder: (context, child) {
                      final opacity = 1 - bottomBarAnimation.value;
                      return Positioned(
                        left: 0,
                        right: 0,
                        bottom: -bottomBarAnimation.value * 150,
                        child: Opacity(
                          opacity: opacity,
                          child: ClaimBottomBar(
                            onPressed: () async {
                              // if (post.type == PostType.found) {
                              //   await Posts.claimPost(context, post.id);
                              // } else {
                              //   await Posts.foundPost(context, post.id);
                              // }
                            },
                            post: post,
                          )
                        ),
                      );
                    }
                  )
                ],
              );
            }
          );
        }
      ),
    );
  }
}

class PostImagesSlider extends StatefulWidget {
  const PostImagesSlider({
    super.key,
    required this.images
  });

  final List<PostImage> images;

  @override
  State<PostImagesSlider> createState() => _PostImagesSliderState();
}

class _PostImagesSliderState extends State<PostImagesSlider> {
  int currentIndex = 0;

  void _onPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: const BoxDecoration(
        color: CustomColors.black1,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30)
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(30)
            ),
            child: CarouselSlider(
              options: CarouselOptions(
                height: double.maxFinite,
                viewportFraction: 1,
                autoPlay: widget.images.length > 1,
                scrollPhysics: widget.images.length > 1 ? null : const NeverScrollableScrollPhysics(),
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) => _onPageChanged(index, reason),
              ),
              items: List.generate(
                widget.images.length, 
                (index) {
                  final image = widget.images[index];
                  return GestureDetector(
                    onTap: () => Utils.pushScreen(context, ImageScreen(
                      image: NetworkImage(image.url),
                      name: widget.images[index].name,
                    )),
                    child: CachedNetworkImage(
                      imageUrl: widget.images[index].url,
                      fit: BoxFit.cover,
                    ),
                  );
                }
              )
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                children: List.generate(
                  widget.images.length, 
                  (index) {
                    final double size = index == currentIndex ? 13 : 10;
                    final Color color = index == currentIndex 
                      ? Colors.white 
                      : Colors.white.withValues(alpha: 0.5);

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      height: size,
                      width: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color
                      ),
                    );
                  }
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PostInfo extends StatelessWidget {
  const PostInfo({
    super.key,
    required this.post
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              post.title,
              style: const TextStyle(
                fontFamily: Fonts.airbndcereal,
                fontSize: 35,
                color: CustomColors.black1
              ),
            ),
            TypeLabel(type: post.type)
          ],
        ),
        const SizedBox(height: 20),
        InfoTile(
          title: "Time",
          subtitle: Utils.formatDate1(post.createdAt),
          icon: CupertinoIcons.clock_fill,
        ),
        const SizedBox(height: 20),
        if (post.description != null) const Text(
          "Description",
          style: TextStyle(
            fontFamily: Fonts.airbndcereal,
            fontSize: 20,
            color: CustomColors.black1,
            fontWeight: FontWeight.w500
          ),
        ),
        const SizedBox(height: 15),
        if (post.description != null) Text(
          post.description!,
          style: const TextStyle(
            fontFamily: Fonts.airbndcereal,
            fontSize: 16
          ),
        ),
        const SizedBox(height: 20),
        if (post.locationDescription != null) const Text(
          "Location",
          style: TextStyle(
            fontFamily: Fonts.airbndcereal,
            fontSize: 20,
            color: CustomColors.black1,
            fontWeight: FontWeight.w500
          ),
        ),
        const SizedBox(height: 15),
        if (post.locationDescription != null) Text(
          post.description!,
          style: const TextStyle(
            fontFamily: Fonts.airbndcereal,
            fontSize: 16
          ),
        )
      ],
    );
  }
}

class ClaimBottomBar extends StatelessWidget {
  const ClaimBottomBar({
    super.key,
    required this.onPressed,
    required this.post
  });

  final VoidCallback onPressed;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 1),
            Colors.white.withValues(alpha: 0)
          ],
          begin: const Alignment(0,0),
          end: Alignment.topCenter
        )
      ),
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 10
      ),
      child: SizedBox(
        width: double.maxFinite,
        child: ElevatedButton(
          onPressed: onPressed, 
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.primaryBlue,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            )
          ),
          child: Row(
            children: [
              const SizedBox(width: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: CustomColors.blue2
                ),
                child: const Icon(
                  Icons.back_hand_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const Spacer(flex: 3),
              Text(
                post.type == PostType.found ? "Claim" : "Found",
                style: const TextStyle(
                  fontFamily: Fonts.airbndcereal,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
              const Spacer(flex: 5,)
            ],
          )
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon
  });

  final String title, subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: CustomColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12)
            ),
            child: Icon(
              icon,
              color:CustomColors.primaryBlue,
              size: 30,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: Fonts.airbndcereal,
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: Fonts.airbndcereal,
                    fontSize: 14,
                    color: CustomColors.grey1
                  ),
                )
              ],
            )
          )
        ],
      ),
    );
  }
}