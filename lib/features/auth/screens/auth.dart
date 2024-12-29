import 'package:cached_network_image/cached_network_image.dart';
import 'package:estin_losts/shared/constents/colors.dart';
import 'package:estin_losts/shared/constents/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CachedNetworkImage(
          imageUrl: "https://atlas-content-cdn.pixelsquid.com/stock-images/street-sign-traffic-signs-G9mkD8D-600.jpg"
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(
          top: 40,
          bottom: 30,
          left: 20,
          right: 20
        ),
        decoration: const BoxDecoration(
          color: CustomColors.primaryBlue,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30)
          )
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "To Look Up More Events or Activities Nearby By Map",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: Fonts.airbndcereal,
                fontWeight: FontWeight.w400,
                fontSize: 22,
                color: Colors.white
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "In publishing and graphic design, Lorem is a placeholder text commonly",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: Fonts.airbndcereal,
                fontWeight: FontWeight.w300,
                fontSize: 15,
                color: Colors.white
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: (){}, 
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/icons/google.svg"),
                  const SizedBox(width: 10),
                  const Text(
                    "Login with estin.dz",
                    style: TextStyle(
                      color: CustomColors.black1,
                      fontFamily: Fonts.airbndcereal,
                      fontWeight: FontWeight.w500,
                      fontSize: 16
                    ),
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}