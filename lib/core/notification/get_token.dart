import 'package:firebase_messaging/firebase_messaging.dart';

class GetToken {
  static String token='';
  static Future<String> getToken()async{
    token = (await FirebaseMessaging.instance.getToken())!;
    print(token);
    return token;

  }

}

//Login/Register
// ↓
// FCM Token Al
// ↓
// Token'ı Firestore'a Kaydet
// ↓
// Mesaj Gönder
// ↓
// Firestore'a Kaydet
// ↓
// Karşı Tarafın Token'ını Bul
// ↓
// Backend/Cloud Function ile FCM Gönder
// ↓
// Telefon Notification Gösterir
// ↓
// Tıklanınca ChatScreen Açılır

