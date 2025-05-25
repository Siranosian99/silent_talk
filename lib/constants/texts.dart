class AppTexts {
  // Private constructor
  AppTexts._privateConstructor();

  // Single instance
  static final AppTexts _instance = AppTexts._privateConstructor();

  // Public accessor
  static AppTexts get instance => _instance;

  // Text values
  final String appName = "Silent Talk";
  final String email = "Email";
  final String password = "Password";
  final String login = "Login";
  final String forgetPass="Forget Password?";
  final String dntHveAccount = "Don’t have an account?";
  final String signUp = "Sign Up";
}
