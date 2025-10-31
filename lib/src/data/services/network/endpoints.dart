class Endpoints {
  static const base = 'https://dummyjson.com';

  /// Authentication
  static const String register = '/auth/register/';
  static const String login = '/auth/login';
  static const String forgotPassword = '/auth/forgot_password/';
  static const String resetPassword = '/auth/reset_password/';
  static const String refreshToken = '/auth/refresh_token/';

  /// OTP
  static const String verifyOtp = '/otp/verify_otp/';
  static const String resendOtp = '/otp/resend_otp/';

  /// Recipes
  static const String recipes = '/recipes';
  static String recipeById(int id) => '/recipes/$id';
  static String recipeSearch(String query) => '/recipes/search?q=$query';
}
