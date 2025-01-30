import 'package:estin_losts/shared/constents/colors.dart';
import 'package:estin_losts/shared/constents/fonts.dart';
import 'package:flutter/material.dart';

class CustomFilterShip extends StatelessWidget {
  const CustomFilterShip({
    super.key,
    required this.label,
    this.isSelected = true,
    required this.onTap
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = !isSelected 
        ? CustomColors.black1 
        : Colors.white;

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: foregroundColor,  
          fontSize: 16,
          fontFamily: Fonts.airbndcereal,
          fontWeight: FontWeight.w300
        ),
      ),
      onSelected: (_) => onTap(),
      selected: isSelected,
      selectedColor: CustomColors.primaryBlue,
      backgroundColor: Colors.white,
      checkmarkColor: foregroundColor,
    );
  }
}