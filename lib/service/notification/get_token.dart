import 'package:firebase_messaging/firebase_messaging.dart';

class GetToken {
  static String token='';
  static Future<String> getToken()async{
    token = (await FirebaseMessaging.instance.getToken())!;
    print(token);
    return token;

  }

}

