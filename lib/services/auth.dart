import 'package:estin_losts/shared/constents/backend.dart';
// import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Auth {
  static const route = "$host/users/auth";

  static Future<void> signInWithGoogle() async {
    const successURL = "myapp://example.com/posts";
    const failureRL = "https://www.youtube.com";

    const signInURL = "$route/oauth/google/login?success_url=$successURL&failure_url=$failureRL";

    await launchUrl(Uri.parse(signInURL));
  }

  // static Future<void> storeCurrentUser() async {

  // }

  // static Future<User> fetchCurrentUser() async {
    
  // }
}