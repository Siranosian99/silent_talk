import 'package:firebase_messaging/firebase_messaging.dart';

class GetToken {
  static String token='';
  static void getToken()async{
    token = (await FirebaseMessaging.instance.getToken())!;
  }
}

