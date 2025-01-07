import 'package:estin_losts/features/auth/screens/auth.dart';
import 'package:estin_losts/features/posts/screens/posts.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: "/auth",
  routes: [
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/posts',
      builder: (context, state) {
        print(state.uri.queryParameters["id_token"]);
        return const PostsScreen();
      },
    )
  ]
);