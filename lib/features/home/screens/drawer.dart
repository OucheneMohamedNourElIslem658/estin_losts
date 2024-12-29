import 'package:estin_losts/shared/constents/colors.dart';
import 'package:estin_losts/shared/constents/fonts.dart';
import 'package:flutter/material.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({
    super.key,
    this.onDrawerClose,
  });

  final VoidCallback? onDrawerClose;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ListTile(
          contentPadding: EdgeInsets.zero,
          titleAlignment: ListTileTitleAlignment.center,
          leading: SizedBox(
            height: 60,
            width: 60,
            child: CircleAvatar()
          ),
          title: Text(
            "ouchene mohamed",
            style: TextStyle(
              fontFamily: Fonts.airbndcereal,
              fontWeight: FontWeight.bold,
              fontSize: 19
            ),  
          ),
          subtitle: Text(
            "m_ouchene@estin.dz",
            style: TextStyle(
              fontFamily: Fonts.airbndcereal,
              fontSize: 14,
              color: CustomColors.grey1
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: onDrawerClose, 
            icon: const Icon(Icons.close_rounded)
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            const Spacer(),
            DrawerTile(
              label: "My Profile",
              icon: Icons.person_outline_outlined,
              onPressed: (){},
            ),
            DrawerTile(
              label: "Claims",
              icon: Icons.back_hand_outlined,
              onPressed: (){},
            ),
            DrawerTile(
              label: "Founds",
              icon: Icons.visibility_outlined,
              onPressed: (){},
            ),
            DrawerTile(
              label: "Settings", 
              icon: Icons.settings_outlined, 
              onPressed: (){}
            ),
            DrawerTile(
              label: "Privacy Policy", 
              icon: Icons.policy_outlined, 
              onPressed: (){}
            ),
            DrawerTile(
              label: "Help", 
              icon: Icons.help_outline_rounded, 
              onPressed: (){}
            ),
            DrawerTile(
              label: "Logout", 
              icon: Icons.logout_rounded, 
              onPressed: (){}
            ),
            const Spacer(flex: 3)
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