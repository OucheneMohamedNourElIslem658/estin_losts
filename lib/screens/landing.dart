import 'package:estin_losts/features/auth/screens/auth.dart';
import 'package:estin_losts/features/posts/screens/post.dart';
import 'package:estin_losts/services/auth.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Auth.authChanges, 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final isLogedIn = snapshot.data!;

          if (isLogedIn) {
            return const PostScreen();
          } else {
            return const AuthScreen();
          }
        },
      )
    );
  }
}