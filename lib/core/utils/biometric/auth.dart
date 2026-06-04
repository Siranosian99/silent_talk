import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:silent_talk/constants/texts.dart';

import '../../../l10n/app_localizations.dart';
import 'auth_provider.dart';

class AuthService {
  final LocalAuthentication auth = LocalAuthentication();
  // bool isD =false;
  // Future<bool?> isDeviceHave()async{
  //   isD=await auth.isDeviceSupported();
  //   print("the device is HAve SECure:$isD");
  //   return isD;
  // }
  Future<bool> checkAuth() async {
    final bool canAuthenticate =
        await auth.canCheckBiometrics && await auth.isDeviceSupported();
    print(canAuthenticate);
    return canAuthenticate;
  }

  Future<void> checkAvailable(BuildContext context) async {
    try {
      final _authProvider = Provider.of<AuthenticateProvider>(context, listen: false);

      // 🔑 If security is disabled → skip authentication
      if (!_authProvider.isAuth) {
        context.goNamed('login');
        return;
      }

      // ✅ Security is enabled → continue
      final bool canAuth = await checkAuth();
      if (!canAuth) {
        context.goNamed('login');
        return;
      }

      final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

      bool didAuthenticate = false;
      if (availableBiometrics.isNotEmpty) {
        didAuthenticate = await auth.authenticate(
          localizedReason: 'Put Your Finger To Open App',
          options: const AuthenticationOptions(biometricOnly: true),
        );
      } else {
        didAuthenticate = await auth.authenticate(
          localizedReason: 'Enter The Pin To Open App',
          options: const AuthenticationOptions(biometricOnly: false),
        );
      }

      if (didAuthenticate) {
        return ;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.isAuth)),
        );
        SystemNavigator.pop(); // close app
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
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
