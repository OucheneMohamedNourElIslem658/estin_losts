import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostBottomBarController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController bottomBarAnimationController;
  late Animation<double> bottomBarAnimation;
  late ScrollController scrollController;

  void _initAnimation() {
    bottomBarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200)
    );

    bottomBarAnimation = Tween<double>(
      begin: 0,
      end: 1
    ).animate(bottomBarAnimationController);

    scrollController = ScrollController();
    scrollController.addListener(() {
      final isInTopOfScroll = scrollController.offset <= 0;
      _toggleBottomBar(isInTopOfScroll);
    });
  }

  void _toggleBottomBar(bool isInTopOfScroll) {
    if (!isInTopOfScroll) {
        bottomBarAnimationController.forward();
    } else {
        bottomBarAnimationController.reverse();
    }
  }

  @override
  void onInit() {
    _initAnimation();
    super.onInit();
  }
}