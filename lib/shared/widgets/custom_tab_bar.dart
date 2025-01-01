import 'package:estin_losts/shared/constents/colors.dart';
import 'package:estin_losts/shared/constents/fonts.dart';
import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    super.key,
    this.liteMode = false
  });

  final bool liteMode;

  @override
  Widget build(BuildContext context) {
    final primarySelectedColor = liteMode ? CustomColors.primaryBlue : Colors.white; 
    final primaryUnselectedColor = liteMode ? CustomColors.grey1 : Colors.white;

    const labelStyle = TextStyle(
      fontFamily: Fonts.airbndcereal,
      fontSize: 16
    );

    return TabBar(
      unselectedLabelColor: primaryUnselectedColor,
      labelColor: primarySelectedColor,
      dividerColor: Colors.transparent,  
      indicatorColor: primarySelectedColor,
      unselectedLabelStyle: labelStyle.copyWith(
        fontWeight: FontWeight.w400
      ),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      padding: const EdgeInsets.only(bottom: 2),
      labelPadding: const EdgeInsets.only(bottom: 6),
      tabs: const [
        Text("ALL", style: labelStyle),
        Text("LOST", style: labelStyle),
        Text("FOUND", style: labelStyle)
      ]
    );
  }
}