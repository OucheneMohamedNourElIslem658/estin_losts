// ignore_for_file: use_build_context_synchronously, unused_element

import 'dart:async';

import 'package:estin_losts/shared/constents/backend.dart';
import 'package:estin_losts/shared/models/user.dart';
import 'package:estin_losts/shared/utils/cookie_extention.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Auth {
  static const route = "$host/users/auth";
  static final _localStorage = GetStorage();

  static Future<void> signInWithGoogle() async {
    const successURL = "myapp://example.com/posts";
    const failureRL = "https://www.youtube.com";

    const signInURL = "$route/oauth/google/login?success_url=$successURL&failure_url=$failureRL";

    await launchUrl(Uri.parse(signInURL));
  }

  static void storeCurrentUser({
    required Uri uri
  }) {
    if (idToken == null) {
      final idToken = uri.queryParameters["id_token"] ?? "";
      final refreshToken = uri.queryParameters["refresh_token"] ?? "";
      final userName = uri.queryParameters["name"] ?? "";
      final userEmail = uri.queryParameters["email"] ?? "";
      final userImageURL = uri.queryParameters["image_url"] ?? "";
      final isAdmin = uri.queryParameters["is_admin"] ?? "";
      final id = uri.queryParameters["id"] ?? "";
      final isUserInfoValid = 
        id != "" &&
        idToken != "" && 
        refreshToken != "" &&
        userName != "" &&
        userEmail != "" &&
        userImageURL != "" &&
        isAdmin != "";
      
      if (isUserInfoValid) {
        _localStorage.write("id", id);
        _localStorage.write("id_token", idToken);
        _localStorage.write("refresh_token", refreshToken);
        _localStorage.write("full_name", userName);
        _localStorage.write("email", userEmail);
        _localStorage.write("image_url", userImageURL);
        _localStorage.write("is_admin", isAdmin == "true");
      }
    }
  }

  static String? get idToken => _localStorage.read("id_token");
  static String? get refreshToken => _localStorage.read("refresh_token");

  static Future<bool> refreshIdToken(BuildContext context) async {
    final response = await http.get(
      Uri.parse("$route/oauth/refresh"),
      headers: {
        "Content-Type" : "application/json",
        "Authorization": "Bearer $refreshToken"
      }
    );
    if (response.statusCode == 200) {
      final idToken = response.getCookie("id_token");
      _localStorage.write("id_token", idToken);
      return true;
    } else {
      await signOut(context);
      return false;
    }
  }

  static User? get currentUser {
    final isUserLogedIn = idToken != null;

    if (isUserLogedIn) {
      final userName = _localStorage.read("full_name");
      final email = _localStorage.read("email");
      final imageURL = _localStorage.read("image_url");
      final id = _localStorage.read("id");
      return User(
        id: id,
        name: userName, 
        email: email, 
        imageURL: imageURL
      );
    }

    return null;
  }

  static Future<void> signOut(BuildContext context) async {
    await _localStorage.erase();
    context.go("/auth");
  }
}