import 'package:estin_losts/features/auth/screens/auth.dart';
import 'package:estin_losts/features/posts/screens/add_post.dart';
import 'package:estin_losts/features/posts/screens/post.dart';
import 'package:estin_losts/features/posts/screens/posts.dart';
import 'package:estin_losts/features/posts/screens/user_claims.dart';
import 'package:estin_losts/features/posts/screens/user_founds.dart';
import 'package:estin_losts/features/user/screens/profile.dart';
import 'package:estin_losts/services/auth.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  // initialLocation: Auth.currentUser == null ? "/auth" : "/posts",
  initialLocation: '/posts/mmm',
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

    GoRoute(
      path: "/add-post",
      builder: (context, state) {
        return const AddPostScreen();
      },
    ),
    
    GoRoute(
      path: '/posts/:id',
      builder: (context, state) {
        // final postID = state.pathParameters['id'];
        const postID = "df52dcb0-4c9d-47b2-a892-21ecd8547055";
        return const PostScreen(
          postID: postID,
        );
      },
    )
  ]
);