import 'package:estin_losts/shared/constents/colors.dart';
import 'package:estin_losts/shared/constents/fonts.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    this.onDrawerClose,
  });

  final VoidCallback? onDrawerClose;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: CircleAvatar(),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Ouchene Mohamed",
                    style: TextStyle(
                      fontFamily: Fonts.airbndcereal,
                      fontWeight: FontWeight.w500,
                      color: CustomColors.black1,
                      fontSize: 20
                    ),
                  ),
                  Text(
                    "m_ouchene@estin.dz",
                    style: TextStyle(
                      fontFamily: Fonts.airbndcereal,
                      fontWeight: FontWeight.w500,
                      color: CustomColors.grey1,
                      fontSize: 14
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  DrawerTile(
                    label: "My Profile",
                    icon: Icons.person_outline_outlined,
                    onPressed: (){},
                  ),
                  const SizedBox(height: 10),
                  DrawerTile(
                    label: "My Claims",
                    icon: Icons.back_hand_outlined,
                    onPressed: (){},
                  ),
                  const SizedBox(height: 10),
                  DrawerTile(
                    label: "My Founds",
                    icon: Icons.visibility_outlined,
                    onPressed: (){},
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  DrawerTile(
                    label: "Settings", 
                    icon: Icons.settings_outlined, 
                    onPressed: (){}
                  ),
                  const SizedBox(height: 10),
                  DrawerTile(
                    label: "Privacy Policy", 
                    icon: Icons.policy_outlined, 
                    onPressed: (){}
                  ),
                  const SizedBox(height: 10),
                  DrawerTile(
                    label: "Help", 
                    icon: Icons.help_outline_rounded, 
                    onPressed: (){}
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  DrawerTile(
                    label: "Logout", 
                    icon: Icons.logout_rounded, 
                    onPressed: (){}
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Developed by Ouchene Mohamed © 2024", 
                textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: Fonts.airbndcereal,
                    fontWeight: FontWeight.w500,
                    color: CustomColors.grey1,
                    fontSize: 14
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed, 
      style: OutlinedButton.styleFrom(
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: CustomColors.grey1,
            size: 30,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontFamily: Fonts.airbndcereal,
              fontWeight: FontWeight.w500,
              color: CustomColors.black1,
              fontSize: 17
            ),
          ),
        ],
      )
    );
  }
}