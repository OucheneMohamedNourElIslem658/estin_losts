import 'package:estin_losts/shared/constents/colors.dart';
import 'package:estin_losts/shared/constents/fonts.dart';
import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({
    super.key, 
    required this.image,
    required this.name
  });

  final ImageProvider<Object> image;
  final String name;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                child: Image(
                  image: image,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: AppBar(
                title: Row(
                  children: [
                    const Icon(
                      Icons.image,
                      color: CustomColors.red1,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontFamily: Fonts.airbndcereal,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ],
                ),
                
                foregroundColor: Colors.white,
                backgroundColor: CustomColors.grey1.withValues(alpha: 0.2),
              )
            )
          ],
        ),
      ),
    );
  }
}