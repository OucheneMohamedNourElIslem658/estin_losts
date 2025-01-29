import 'package:cached_network_image/cached_network_image.dart';
import 'package:estin_losts/shared/constents/colors.dart';
import 'package:estin_losts/shared/constents/fonts.dart';
import 'package:estin_losts/shared/constents/posts_examples.dart';
import 'package:estin_losts/shared/utils/utils.dart';
import 'package:estin_losts/shared/models/post.dart';
import 'package:flutter/material.dart';

class PostTile extends StatelessWidget {
  const PostTile({
    super.key,
    required this.post
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    final String imageURL = post.images.isNotEmpty ? post.images.first.url : postImageURL;
    final String date = Utils.formatDate1(post.createdAt);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.only(
        left: 10,
        right: 20,
        top: 10,
        bottom: 10
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5)
          )
        ]
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: imageURL,
              height: 90,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    color: CustomColors.primaryBlue,
                    fontSize: 14,
                    fontFamily: Fonts.airbndcereal,
                    fontWeight: FontWeight.w500
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  post.title,
                  style: const TextStyle(
                    color: CustomColors.black1,
                    fontSize: 18,
                    fontFamily: Fonts.airbndcereal,
                    fontWeight: FontWeight.w500
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
