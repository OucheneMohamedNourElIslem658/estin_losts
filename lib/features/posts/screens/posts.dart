import 'package:estin_losts/features/posts/widgets/drawer.dart';
import 'package:estin_losts/shared/constents/colors.dart';
import 'package:estin_losts/shared/constents/fonts.dart';
import 'package:estin_losts/shared/models/post.dart';
import 'package:estin_losts/shared/widgets/custom_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/posts_list.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      drawer: const CustomDrawer(),
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (_, innerBoxIsScrolled) => [
            SliverAppBar(
              snap: true,
              floating: true,
              backgroundColor: CustomColors.primaryBlue,
              leading: Center(
                child: IconButton(
                  onPressed: () => scaffoldKey.currentState?.openDrawer(),
                  icon: SvgPicture.asset("assets/icons/show_drawer.svg")
                )
              ),
              actions: [
                IconButton(
                  onPressed: () async {}, 
                  icon: SvgPicture.asset("assets/icons/search.svg")
                ),
                NotificationButton(onPressed: (){}),
              ],
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(52),
                child: CustomTabBar()
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30)
                )
              ),
            )
          ], 
          body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              PostsList(),
              PostsList(
                postType: PostType.lost,
              ),
              PostsList(
                postType: PostType.found,
              )
            ]
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){},
        backgroundColor: CustomColors.primaryBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          "Add Post",
          style: TextStyle(
            fontSize: 16,
            fontFamily: Fonts.airbndcereal,
            fontWeight: FontWeight.w500
          )
        ),
      )
    );
  }
}