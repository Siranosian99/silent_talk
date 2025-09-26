import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:silent_talk/constants/texts.dart';

import '../../l10n/app_localizations.dart';
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
    return canAuthenticate;
  }

  Future<void> checkAvailable(BuildContext context,bool isAuth) async {
    try {
      final authProvider = Provider.of<AuthenticateProvider>(context);
      // final bool canAuth =  await auth.canCheckBiometrics || await auth.isDeviceSupported();
      final bool canAuth=await checkAuth();
      if (!canAuth) {
        context.goNamed('main');
        isAuth =false;
        return ;
      }

      final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

      bool didAuthenticate = false;

      if (availableBiometrics.isNotEmpty && authProvider.isAuth ) {
        didAuthenticate = await auth.authenticate(
          localizedReason: 'Put Your Finger To Open App',
          options: const AuthenticationOptions(biometricOnly: true),
        );
      } else if(availableBiometrics.isNotEmpty && authProvider.isAuth){
        didAuthenticate = await auth.authenticate(
          localizedReason: 'Enter The Pin To Open App',
          options: const AuthenticationOptions(biometricOnly: false),
        );
      }

      if (didAuthenticate) {
        isAuth=true;
        context.goNamed('login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.isAuth)),
        );
        isAuth=false;
        SystemNavigator.pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.isAuth)),
      );
      isAuth=false;
    }
    return ;
  }


// if (availableBiometrics.contains(BiometricType.strong) ||
  //     availableBiometrics.contains(BiometricType.face)) {
  //   // Specific types of biometrics are available.
  //   // Use checks like this with caution!
  //
  //   print("There is ALSO AUHT");
  // }
}
