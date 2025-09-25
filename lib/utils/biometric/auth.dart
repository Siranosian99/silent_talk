import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

class AuthService {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> checkAuth() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    return canAuthenticate;
  }

  Future<void> checkAvailable() async {
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    if (availableBiometrics.isNotEmpty) {
      final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to show account balance',
          options: const AuthenticationOptions(biometricOnly: true));
    }

    if (availableBiometrics.contains(BiometricType.strong) ||
        availableBiometrics.contains(BiometricType.face)) {
      // Specific types of biometrics are available.
      // Use checks like this with caution!

      print("There is ALSO AUHT");
    }
  }
}
