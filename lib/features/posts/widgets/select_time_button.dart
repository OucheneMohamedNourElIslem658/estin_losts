import 'package:estin_losts/shared/constents/colors.dart';
import 'package:estin_losts/shared/constents/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectTimeButton extends StatelessWidget {
  const SelectTimeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: (){},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        side: BorderSide(
          color: CustomColors.grey1.withValues(alpha: 0.2),
          width: 1
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        )
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.clock_fill, 
            color: CustomColors.primaryBlue,
            size: 25,
          ),
          SizedBox(width: 10),
          Text(
            "Select Time",
            style: TextStyle(
              color: CustomColors.grey1,
              fontSize: 16,
              fontFamily: Fonts.airbndcereal,
              fontWeight: FontWeight.w300
            ),
          ),
          SizedBox(width: 10),
          Icon(
            Icons.arrow_forward_ios_rounded, 
            color: CustomColors.primaryBlue,
            size: 15,
          ),
        ],
      )
    );
  }
}
