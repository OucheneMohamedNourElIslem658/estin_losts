import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    super.key,
    required this.imageURL,
    this.size = 100,
  });

  final String imageURL;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: SizedBox(
        height: size,
        width: size,
        child: CachedNetworkImage(
          imageUrl: imageURL,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
