import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../services/auth.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: SizedBox(
        height: 100,
        width: 100,
        child: CachedNetworkImage(
          imageUrl: Auth.currentUser!.imageURL,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
