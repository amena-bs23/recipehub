import 'dart:convert';

class JwtUtility {
  /// Decodes JWT token and extracts payload
  static Map<String, dynamic>? decodePayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      // Decode payload (second part)
      final payload = parts[1];
      final normalized = base64.normalize(payload);
      final decoded = utf8.decode(base64.decode(normalized));

      return json.decode(decoded) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Extracts email from JWT token payload
  static String? getEmailFromToken(String? token) {
    if (token == null) return null;

    final payload = decodePayload(token);
    return payload?['email'] as String?;
  }

  /// Extracts any claim from JWT token
  static T? getClaim<T>(String? token, String claim) {
    if (token == null) return null;

    final payload = decodePayload(token);
    return payload?[claim] as T?;
  }
}
