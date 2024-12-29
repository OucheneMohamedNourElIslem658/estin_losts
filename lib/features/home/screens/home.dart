import 'package:estin_losts/features/home/screens/drawer.dart';
import 'package:estin_losts/shared/constents/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _translationAnimation;

  bool isDrawerOpen = false;

  @override
  void initState() {
    _initAnimation();
    super.initState();
  }

  void _initAnimation(){
     _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180)
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.75).animate(_animationController);
    _translationAnimation = Tween<double>(begin: 0, end: 4.8).animate(_animationController);
  }

  void toggleDrawer(){
    if(isDrawerOpen){
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    isDrawerOpen = !isDrawerOpen;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DrawerScreen(
            onDrawerClose: () => toggleDrawer(),
          ),
          AnimatedBuilder(
            animation: _animationController, 
            builder: (context, _) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                alignment: Alignment(_translationAnimation.value, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isDrawerOpen ? 50 : 0),
                  child: IgnorePointer(
                    ignoring: isDrawerOpen,
                    child: Container(
                      color: Colors.white,
                      child: PostsPage(
                        onDrawerButtonPressed: () => toggleDrawer(),
                      ),
                    )
                  ),
                ),
              );
            }
          )
        ],
      ),
    );
  }
}

class PostsPage extends StatelessWidget {
  const PostsPage({
    super.key,
    this.onDrawerButtonPressed
  });

  final VoidCallback? onDrawerButtonPressed;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: CustomColors.primaryBlue,
            leading: Center(
              child: IconButton(
                onPressed: onDrawerButtonPressed,
                icon: SvgPicture.asset("assets/icons/show_drawer.svg")
              )
            ),
            actions: [
              IconButton(
                onPressed: (){}, 
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
        body: const Padding(
          padding: EdgeInsets.only(top: 20),
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              PostsList(),
              PostsList(),
              PostsList()
            ]
          ),
        )
      ),
    );
  }
}