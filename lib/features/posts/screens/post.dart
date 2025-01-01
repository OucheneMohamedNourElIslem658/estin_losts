import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:estin_losts/features/posts/widgets/post.dart';
import 'package:estin_losts/shared/constents/colors.dart';
import 'package:estin_losts/shared/constents/fonts.dart';
import 'package:estin_losts/shared/constents/posts_examples.dart';
import 'package:estin_losts/shared/models/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> with SingleTickerProviderStateMixin {
  late AnimationController bottomBarAnimationController;
  late Animation<double> bottomBarAnimation;
  late ScrollController scrollController;

  void _initAnimation() {
    bottomBarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200)
    );

    bottomBarAnimation = Tween<double>(
      begin: 0,
      end: 1
    ).animate(bottomBarAnimationController);

    scrollController = ScrollController();
    scrollController.addListener(() {
      final isInTopOfScroll = scrollController.offset <= 0;
      _toggleBottomBar(isInTopOfScroll);
    });
  }

  void _toggleBottomBar(bool isInTopOfScroll) {
    if (!isInTopOfScroll) {
        bottomBarAnimationController.forward();
    } else {
        bottomBarAnimationController.reverse();
    }
  }

  @override
  void initState() {
    _initAnimation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){}, 
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
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostImagesSlider(),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: PostInfo(),
                )
              ],
            ),
          ),
          AnimatedBuilder(
            animation: bottomBarAnimationController,
            builder: (context, child) {
              final opacity = 1 - bottomBarAnimation.value;
              return Positioned(
                left: 0,
                right: 0,
                bottom: -bottomBarAnimation.value * 150,
                child: Opacity(
                  opacity: opacity,
                  child: const ClaimBottomBar()
                ),
              );
            }
          )
        ],
      ),
    );
  }
}

class PostImagesSlider extends StatefulWidget {
  const PostImagesSlider({
    super.key,
  });

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

  final List<String> imagesList = List.generate(
    3, 
    (index) => postImageURL
  );

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
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) => _onPageChanged(index, reason),
              ),
              items: List.generate(
                imagesList.length, 
                (index) {
                  return CachedNetworkImage(
                    imageUrl: imagesList[index],
                    fit: BoxFit.cover,
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
                  imagesList.length, 
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
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              postsEamples.first.title,
              style: const TextStyle(
                fontFamily: Fonts.airbndcereal,
                fontSize: 35,
                color: CustomColors.black1
              ),
            ),
            const TypeLabel(type: PostType.found)
          ],
        ),
        const SizedBox(height: 20),
        const InfoTile(
          title: "14 December, 2021",
          subtitle: "14 December, 2021",
          icon: CupertinoIcons.clock_fill,
        ),
        const SizedBox(height: 10),
        const InfoTile(
          title: "14 December, 2021",
          subtitle: "14 December, 2021",
          icon: Icons.location_on_rounded,
        ),
        const SizedBox(height: 20),
        const Text(
          "Description",
          style: TextStyle(
            fontFamily: Fonts.airbndcereal,
            fontSize: 20,
            color: CustomColors.black1,
            fontWeight: FontWeight.w500
          ),
        ),
        const SizedBox(height: 15),
        Text(
          postsEamples.first.description! * 20,
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
  });

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
          onPressed: (){}, 
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
              const Text(
                "Claim",
                style: TextStyle(
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