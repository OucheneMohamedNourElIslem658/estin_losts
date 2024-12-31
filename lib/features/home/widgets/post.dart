import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/constents/colors.dart';
import '../../../shared/constents/fonts.dart';
import '../../../shared/constents/posts_examples.dart';
import '../../../shared/models/post.dart';

class PostsList extends StatelessWidget {
  const PostsList({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 100
        ),
        child: Column(
          spacing: 10,
          children: List.generate(
            postsEamples.length, 
            (index) => PostCard(post: postsEamples[index])
          ),
        ),
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
            leading: const CircleAvatar(),
            trailing: TypeLabel(
              type: post.type,
            ),
            title: const Text(
              "Ouchene Mohamed",
              style: TextStyle(
                fontFamily: Fonts.airbndcereal,
                fontWeight: FontWeight.w600
              ),
            ),
            subtitle: const Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: CustomColors.grey1,
                  size: 15,
                ),
                Expanded(
                  child: Text(
                    "36 Guild Street London, UK ",
                    style: TextStyle(
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
                imageUrl: postImageURL,
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Lost Not Book!",
                      style: TextStyle(
                        fontFamily: Fonts.airbndcereal,
                        fontWeight: FontWeight.w500,
                        fontSize: 18
                      ),
                    ),
                    Text(
                      "2 days ago",
                      style: TextStyle(
                        fontFamily: Fonts.airbndcereal,
                        color: CustomColors.grey1,
                        fontSize: 12
                      ),
                    ),
                  ],
                ),
                const Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla eget nunc sed nisl. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla eget nunc sed nisl.",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: Fonts.airbndcereal,
                    color: CustomColors.grey1,
                    fontSize: 13
                  ),
                ),
                const SizedBox(height: 10),
                ReactButtonButton(
                  onPressed: (){},
                  hasReacted: true,
                  type: post.type
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
    required this.type,
  });

  final VoidCallback onPressed;
  final bool hasReacted;
  final PostType type;

  @override
  Widget build(BuildContext context) {
    final primaryColor = type == PostType.found 
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
                "20",
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
        FirstClaims(color: primaryColor)
      ],
    );
  }
}

class FirstClaims extends StatelessWidget {
  const FirstClaims({
    super.key,
    required this.color
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    final images = [
      "https://img.freepik.com/photos-gratuite/mode-vie-emotions-gens-concept-decontracte-confiant-belle-femme-asiatique-souriante-bras-croises-poitrine-confiante-prete-aider-ecoute-ses-collegues-prenant-part-conversation_1258-59335.jpg",
      "https://www.jordanharbinger.com/wp-content/uploads/2018/09/be-the-most-interesting-360x360.jpg",
      "https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg",
    ];

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
        Text(
          "+20 others",
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

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(
      color: Colors.white,
      fontFamily: Fonts.airbndcereal,
      fontSize: 16
    );

    return const TabBar(
      unselectedLabelColor: Colors.white,
      labelColor: Colors.white,
      dividerColor: Colors.transparent,
      indicatorColor: Colors.white,
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      padding: EdgeInsets.only(bottom: 2),
      labelPadding: EdgeInsets.only(bottom: 6),
      tabs: [
        Text("All", style: labelStyle),
        Text("Lost", style: labelStyle),
        Text("Found", style: labelStyle)
      ]
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