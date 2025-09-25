import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:silent_talk/constants/texts.dart';

import '../../l10n/app_localizations.dart';

class AuthService {
  final LocalAuthentication auth = LocalAuthentication();
  Future<bool> isDeviceHave()async{
    final bool isD=await auth.isDeviceSupported();
    print(isD);
    return isD;
  }
  AuthService(){
    isDeviceHave();
  }
  Future<bool> checkAuth() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    return canAuthenticate;
  }

  Future<void> checkAvailable(BuildContext context) async {
    final bool canAuth = await checkAuth();

    try {
      if (!canAuth) {
        print("object");
        return ;
      }
      final List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();
      if (availableBiometrics.isNotEmpty) {
        final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Put Your Finger To Open App',
          options: const AuthenticationOptions(biometricOnly: true),
        );
      } else {
        final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Enter The Pin To Open App',
          options: const AuthenticationOptions(biometricOnly: false),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.isAuth
          ),
        ),
      );
    }
  }

  // if (availableBiometrics.contains(BiometricType.strong) ||
  //     availableBiometrics.contains(BiometricType.face)) {
  //   // Specific types of biometrics are available.
  //   // Use checks like this with caution!
  //
  //   print("There is ALSO AUHT");
  // }
}
