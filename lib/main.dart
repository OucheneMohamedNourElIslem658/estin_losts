import 'package:estin_losts/shared/utils/navigator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white ,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            overlayColor: Colors.grey
          )
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent
        ),
      ),
      routerConfig: router,
    );
  }
}