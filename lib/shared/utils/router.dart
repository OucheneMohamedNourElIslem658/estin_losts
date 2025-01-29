import 'package:estin_losts/features/auth/screens/auth.dart';
import 'package:estin_losts/features/posts/screens/posts.dart';
import 'package:estin_losts/features/posts/screens/user_claims.dart';
import 'package:estin_losts/features/posts/screens/user_founds.dart';
import 'package:estin_losts/features/user/screens/profile.dart';
import 'package:estin_losts/services/auth.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: Auth.currentUser == null ? "/auth" : "/posts",
  routes: [
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
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) {
        return const ProfileScreen();
      },
    ),
    GoRoute(
      path: '/user-claims',
      builder: (context, state) {
        return const UserClaimsScreen();
      },
    ),
    GoRoute(
      path: '/user-founds',
      builder: (context, state) {
        return const UserFoundsScreen();
      },
    ),
  ]
);