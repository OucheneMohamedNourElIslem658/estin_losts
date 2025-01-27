import 'package:http/http.dart' as http;

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