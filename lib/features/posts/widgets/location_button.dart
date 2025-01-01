import 'package:estin_losts/shared/constents/colors.dart';
import 'package:estin_losts/shared/constents/fonts.dart';
import 'package:flutter/material.dart';

class LocationButton extends StatelessWidget {
  const LocationButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: (){},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(10),
        side: BorderSide(
          color: CustomColors.grey1.withValues(alpha: 0.2),
          width: 1
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13)
        )
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: CustomColors.primaryBlue.withValues(alpha: 0.1),
            ),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: const Icon(
                Icons.location_on_outlined, 
                color: CustomColors.primaryBlue,
                size: 25,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            "New Yourk, USA",
            style: TextStyle(
              color: CustomColors.grey1,
              fontSize: 16,
              fontFamily: Fonts.airbndcereal,
              fontWeight: FontWeight.w300
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_forward_ios_rounded, 
            color: CustomColors.primaryBlue,
            size: 15,
          ),
        ],
      )
    );
  }
}
