import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

class NotificationService {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "silenttalk-53850",
      "private_key_id": "a377b5e373a71949d0fd703f3fee1dc606e906b3",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC8AuAYB/WfEIMk\n0Ef3G/F7l90fkOPJsF40JSq6tghOmpLFkRv7XPYtKYAwlxlJBq65tvnKC79lugD9\nomIj0O60TblSgQZkC/3R4qRcQWE9VFxl5huS6tkFKhWdDZDbSkBt3knVKP6xZ3OW\nVvJD7bvJAiCDxhCrr4dvU0mFojyp6mm0R2f8N6xitbFiuAZI2UOUfNWiF/LNoUUm\nF9D/T8UD+yqqKgA4P949C72bXbmeAnjgil07VeLRZvnI5w0mrJS5qe2lpNcaYOIx\ny4g6kvJwzwXPRdavdq7CJ61ZgpD5zVdVf0ViA6nsPbbiPzBKf5NYRNuAxFxIL/lb\ney/c4Cs9AgMBAAECggEAO9AIXezOUevtZN1UP8OmiATQxrWQGj6fQaSfWuYFb4hS\ncEMRbV7uPIDq9MplM2vKU2/oOMSS//h0TzyFT1KtVjQx5JMCpvp/pfGeC3GLT3kS\nqiJSHGPVZgS0+pFxx6nwJGPnBkbz/Blm1unTShQMPU8NbA6riAsgIaUUC00JUp6i\nHi+UJZI1ydM/evNvQg/K58hYHEqSQ1xdREBY4y/fCG3QVdFpl1GCGjl3T8/5BKdo\n6gG9uP/sl7xruaFiJLRrQn7ZKiVK+SR0izIiMTbqpXnLeUDtVjWSehbe/zYIMrvz\nhQHkwh+Ya6ZoWx6nMHhXnJ2Wlinvf09i4pyB9vu52wKBgQDvqzcJqutny9C6t+Dr\nNbFqY6jLmS0wvMeJ9ABHB0NymRCClj88l17p91rktY5cY717B7m+U3pMfnZmj5nS\nIzFWMVJNmd0J5Xnn3mhdrycLL/O8arEgI9BTwiPVvIaPhe/jEsXy+/u1kwT4Bkm8\nufBiGQXX81vHdhUVDWS4XcgZ7wKBgQDI0ouMUSiR6zdimt30X4VfuZt99EfjvYiL\nXp5RafPMlCAD+wT3sUTuwA0TmP+gdPL+wBvV+MBKgKC10u24FL6DJuFuPp649dKO\nc4x0NH0TlHeyVh47GJh0NkA6CVRLjlkO85P0iRs4B9RsmWjMOEn9afwsbJ/uQp7I\n5kZL8E4pkwKBgDqDEmzJza8Jk2wCeGb0NNxEeHE8dEvxysVjTK4Kl+zicaVwCQBB\n9GoqeYZczOTBdQEUYcSVnMYQGdfwNx2WefURFYbciZpg6+Iv6kr0+BNDIb5eTeAK\n3lGUlCsaW7+uc2J8stcfrdQmkI/8+QOaYZWRhluyjjWkHoGFQ5G/U5sBAoGAKZXH\nxeescgL2NhoBqi/5i2gA9eUW2ecOlmWifRNmo89sjcZ2MeBoeNQWIR/Gl3CAPRaE\n7RsUnpjiLqSeC0doZ/ouJkkbTwvAbTUqOYoA+IP/AVPp8KzYLQBq7lmuNfMlJ/5y\nfenCVCjy6QYfeGKTl8FRsdVQjOMIxGtC1UjOtrcCgYB3IMGFTnNgF9tLvt5MmfEp\nnzgfjhKCZxdYXz+eJH35jDFF/g8DZD4yTd/2t1IIrepAikmTfIxzUa3P75KK9kI6\n4rk05bikepQeJxHXZjOnXBkIo6cjX6eosBZRxLa5Dq3xAtUWDxP2BiS8dUiq04XQ\n0M9SBE1QZrsIm3YEltw4rQ==\n-----END PRIVATE KEY-----\n",
      "client_email":
          "silenttalk-53850@silenttalk-53850.iam.gserviceaccount.com",
      "client_id": "113555532900134046516",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/silenttalk-53850%40silenttalk-53850.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com",
    };
    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging",
    ];
    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );
    auth.AccessCredentials credentials = await auth
        .obtainAccessCredentialsViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
          scopes,
          client,
        );
    client.close();
    return credentials.accessToken.data;
  }

  static Future<void> sendNotification(
    String deviceToken,
    String title,
    String body,
    String receiverId,
  ) async {
    final String accessToken = await getAccessToken();

    String endpointFCM =
        'https://fcm.googleapis.com/v1/projects/silenttalk-53850/messages:send';
    final Map<String, dynamic> message = {
      "message": {
        "token": deviceToken,
        // "notification": {"title": title, "body": body},
        "data": {
          "route": "chats",
          "receiverId": receiverId,
          "title": title,
          "body": body,
        },
      },
    };
    //
    final http.Response response = await http.post(
      Uri.parse(endpointFCM),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification :$deviceToken');
      print('Response Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }
  }
}
