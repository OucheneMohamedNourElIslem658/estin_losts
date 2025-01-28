import 'package:estin_losts/features/posts/widgets/post_tile.dart';
import 'package:estin_losts/services/auth.dart';
import 'package:estin_losts/shared/constents/colors.dart';
import 'package:estin_losts/shared/constents/fonts.dart';
import 'package:estin_losts/shared/widgets/custom_tab_bar.dart';
import 'package:estin_losts/shared/widgets/profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            snap: true,
            floating: true,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.arrow_back_rounded, 
                color: Colors.black,
                size: 30,
              )
            ),
            title: const Text(
              "My Profile",
              style: TextStyle(
                color: CustomColors.black1,
                fontSize: 25,
                fontFamily: Fonts.airbndcereal,
                fontWeight: FontWeight.w500
              ),
            ),
          )
        ], 
        body: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    ProfilePic(
                      imageURL: Auth.currentUser!.imageURL,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      Auth.currentUser!.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: CustomColors.black1,
                        fontSize: 24,
                        fontFamily: Fonts.airbndcereal,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    Text(
                      Auth.currentUser!.email,
                      style: const TextStyle(
                        color: CustomColors.grey1,
                        fontSize: 15,
                        fontFamily: Fonts.airbndcereal,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 20,
                      children: [
                        const StatisticInfo(
                          objectsNumber: 10,
                          objectsType: "Objects"
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: CustomColors.grey1.withValues(alpha: 0.2),
                        ),
                        const StatisticInfo(
                          objectsNumber: 5,
                          objectsType: "Founds"
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: (){}, 
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              side: const BorderSide(
                                color: CustomColors.primaryBlue,
                                width: 1.5
                              )
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.report_problem_outlined,
                                  color: CustomColors.primaryBlue,
                                  size: 25,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Report",
                                  style: TextStyle(
                                    color: CustomColors.primaryBlue,
                                    fontSize: 16,
                                    fontFamily: Fonts.airbndcereal,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                              ],
                            )
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: (){}, 
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: CustomColors.primaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.message_outlined,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Message",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: Fonts.airbndcereal,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                              ],
                            )
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const CustomTabBar(liteMode: true),
              const SizedBox(height: 20),
              const Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    PostsList(),
                    PostsList(),
                    PostsList()
                  ]
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}

class PostsList extends StatelessWidget {
  const PostsList({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 10,
        children: List.generate(
          10, 
          (index) => const PostTile()
        ),
      ),
    );
  }
}

class StatisticInfo extends StatelessWidget {
  const StatisticInfo({
    super.key,
    required this.objectsNumber,
    required this.objectsType
  });

  final int objectsNumber;
  final String objectsType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "$objectsNumber",
          style: const TextStyle(
            color: CustomColors.black1,
            fontSize: 18,
            fontFamily: Fonts.airbndcereal,
            fontWeight: FontWeight.w500
          ),
        ),
        Text(
          objectsType,
          style: const TextStyle(
            color: CustomColors.grey1,
            fontSize: 14,
            fontFamily: Fonts.airbndcereal,
            fontWeight: FontWeight.w300
          ),
        ),
      ],
    );
  }
}