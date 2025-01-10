import 'dart:async';

import 'package:estin_losts/features/auth/screens/auth.dart';
import 'package:estin_losts/features/posts/screens/posts.dart';
import 'package:estin_losts/screens/landing.dart';
import 'package:estin_losts/services/auth.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: "/landing",
  routes: [
    GoRoute(
      path: "/landing",
      builder: (context, state) => const LandingScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/posts',
      builder: (context, state) {
        Auth.storeCurrentUser(uri: state.uri);
        return const PostsScreen();
      },
    )
  ]
);