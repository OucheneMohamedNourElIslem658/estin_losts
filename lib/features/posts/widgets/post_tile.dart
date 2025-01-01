import 'package:cached_network_image/cached_network_image.dart';
import 'package:estin_losts/shared/constents/colors.dart';
import 'package:estin_losts/shared/constents/fonts.dart';
import 'package:estin_losts/shared/constents/posts_examples.dart';
import 'package:flutter/material.dart';

class PostTile extends StatelessWidget {
  const PostTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
              imageUrl: postImageURL,
              height: 90,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "1st  May- Sat -2:00 PM",
                  style: TextStyle(
                    color: CustomColors.primaryBlue,
                    fontSize: 14,
                    fontFamily: Fonts.airbndcereal,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "A virtual evening of smooth jazz",
                  style: TextStyle(
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
