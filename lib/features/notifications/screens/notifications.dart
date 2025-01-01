import 'package:estin_losts/shared/constents/colors.dart';
import 'package:estin_losts/shared/constents/fonts.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            snap: true,
            floating: true,
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_back_rounded, 
                color: Colors.black,
                size: 30,
              )
            ),
            title: const Text(
              "Notifications",
              style: TextStyle(
                color: CustomColors.black1,
                fontSize: 25,
                fontFamily: Fonts.airbndcereal,
                fontWeight: FontWeight.w500
              ),
            ),
          )
        ], 
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              spacing: 20,
              children: List.generate(
                10, 
                (index) => ListTile(
                  leading: const Column(
                    children: [
                      SizedBox(
                        height: 45,
                        width: 45,
                        child: CircleAvatar()
                      ),
                    ],
                  ),
                  minVerticalPadding: 0,
                  title: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "John Doe",
                          style: TextStyle(
                            color: CustomColors.black1,
                            fontSize: 15,
                            fontFamily: Fonts.airbndcereal,
                            fontWeight: FontWeight.w500
                          )
                        ),
                        TextSpan(
                          text: " found your big blue hat that you lost it like a dummy",
                          style: TextStyle(
                            color: CustomColors.grey1,
                            fontSize: 15,
                            fontFamily: Fonts.airbndcereal,
                            fontWeight: FontWeight.w300
                          )
                        ),
                      ]
                    ),
                  ),
                  trailing: const Column(
                    children: [
                      Text(
                        "1 min ago",
                        style: TextStyle(
                          color: CustomColors.grey1,
                          fontSize: 14,
                          fontFamily: Fonts.airbndcereal,
                          fontWeight: FontWeight.w300
                        ),
                      ),
                    ],
                  )
              ),
            ),
                    ),
          )
      )
      )
    );
  }
}