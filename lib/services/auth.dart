import 'dart:async';
import 'dart:convert';

import 'package:estin_losts/shared/constents/backend.dart';
import 'package:estin_losts/shared/models/user.dart';
import 'package:get_storage/get_storage.dart';
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
    final idToken = uri.queryParameters["id_token"] ?? "";
    final refreshToken = uri.queryParameters["refresh_token"] ?? "";
    final userName = uri.queryParameters["name"] ?? "";
    final userEmail = uri.queryParameters["email"] ?? "";
    final userImageURL = uri.queryParameters["image_url"] ?? "";
    final isAdmin = uri.queryParameters["is_admin"] ?? "";
    final isUserInfoValid = 
      idToken != "" && 
      refreshToken != "" &&
      userName != "" &&
      userEmail != "" &&
      userImageURL != "" &&
      isAdmin != "";
    if (isUserInfoValid) {
      _localStorage.write("id_token", idToken);
      _localStorage.write("refresh_token", refreshToken);
      _localStorage.write("full_name", userName);
      _localStorage.write("email", userEmail);
      _localStorage.write("image_url", userImageURL);
      _localStorage.write("is_admin", isAdmin == "true");
    }
  }

  // static String get _idToken => _localStorage.read("id_token");
  static String get _refreshToken => _localStorage.read("refresh_token");

  static Future<void> _refreshIdToken() async {
    final response = await http.get(
      Uri.parse("$route/oauth/refresh"),
      headers: {
        "Content-Type" : "application/json",
        "Authorization": "Bearer $_refreshToken"
      }
    );
    if (response.statusCode == 200) {
      final idToken = response.getCookie("id_token");
      _localStorage.write("id_token", idToken);
    } else {
      await signOut();
    }
  }

  static User? get currentUser {
    final userName = _localStorage.read("full_name");
    final email = _localStorage.read("email");
    final imageURL = _localStorage.read("image_url");

    final isUserLogedIn = userName != "" && email != "" && imageURL != "";

    if (isUserLogedIn) {
      return User(
        name: userName, 
        email: email, 
        imageURL: imageURL
      );
    }

    return null;
  }

  static Stream<bool> get authChanges {
    final streamController = StreamController<bool>();
    try {
      streamController.add(false);
      GetStorage().listenKey("id_token", (idToken){
        final isLogedIn = idToken != null && idToken != "";
        streamController.add(isLogedIn);
      });
    } finally {
      streamController.close();
    }
    return streamController.stream;
  }

  static Future<void> signOut() async {
    await _localStorage.erase();
  }
}


// add extention to Response That gets cookie from reponse
extension ResponseCookieExtension on http.Response {
  /// Get a cookie value by its key from the 'set-cookie' header.
  String? getCookie(String key) {
    // Retrieve 'set-cookie' header
    final setCookieHeader = headers['set-cookie'];

    if (setCookieHeader == null) {
      return null; // No cookies found
    }

    // Split the header into individual cookies
    final cookies = setCookieHeader.split('; ');

    // Find the cookie by key
    for (final cookie in cookies) {
      final cookieParts = cookie.split('=');
      if (cookieParts.length == 2 && cookieParts[0] == key) {
        return cookieParts[1]; // Return the cookie value
      }
    }

    return null; // Cookie not found
  }
}