import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

class NotificationService {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "silent-talk-473717",
      "private_key_id": "ffb9aa34d5826f0dd6d75c07d3c4ad3456756d42",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC3Ko/r5vSvi+13\nKHmz2KnJLERZWgryUL2GAgLiqUBXjiCSlzSrh4wjqq3qBXA/e4A+CKwD2BjyaZNQ\nmjvJZU2IaNUVyEmf14Y2pZ6EeMogJ1AAxBaj33JYRbhFg3g3Ie12h3RebqOb7T76\nTT6V3N4ZHOsd0RL/ujvfhT7Z9Npogo6nNYV+eUlbwTQsjAixCVXkr2gSKXHgEsTa\nf4FEYyDPaUOtAyQVT2I1t/NopC9CgGDiAaFc79UqZ7ew1Ed549E/nAjH6a3LgRw5\nSRirv5COesBZVuZK97JGdJmDONiun96cEhUEOqv+bhsT2Fm1PDC0BJCsditdp5gQ\nO/J19YexAgMBAAECggEAAjq7NJkrnWMh711LkW0DwIhIlvCT0WgajXHy8mqyVvp6\nsqQS4ttYESNRwXdiWtB0UrT48IVJ5PH0ZkLRU1nHfj995/lnjYGyX1IH3leIyMhH\nttGsL5+PsQu8suJnNT8VSIf8qm1U8hf6uDHWXx04ihRWN4dA4KJV+hoRZjZe7e6T\nGMLR+grCiSUNn5EWWJIGgAn0qaeoS+HmLHii+n514KUOpDHxF1B+wTgqW/VtAUOh\n+Vuey415aq6MVCGQgcFzarJnGe/ZPnMbAkjbIEcHi0wDqcLFhELeZQax1vjblqpn\nar0KNO0oGXCxbFC6humsplg+jLFSiBGTo49bzR3bwQKBgQDnouLOdiEpF8/X2fES\nO4dv9De8ZcGlq00ACE00dprxyMBjw0+w64FQJDrwUgOXIXb6lSmP5Zqg7WdB/4TC\nPoo26Odb0Xd/RBbhY/AD9TMYRw2Wr2tnY0hI003BymAiBIOYACFfQGK9YccFbhM/\nWgglKKKkatDtcxNqFcikgtge8QKBgQDKbo6IJCD7VELzYYVjZ0mXxdae3Gv8QJWI\nDAEYB4xpezetBmrZMj3kRGvMEdJ9eKA4JlewK2g6ljDbNW0+AOUCu7IIVo9UAHkb\nKDDQJvbBEKEbDbBvq6X5ijrX6MMIDWE6jHgoumZgJi03TViE/9COt684W0fR8Gap\nXwq/JRF0wQKBgDwkVq80jLeWryhkNet9+VRgHHiWEwloyL1RanpMsT5F2W4NsAtH\nmnOsdIEhSj1bOwEk6X2rJ9LQ0RaZuWaVxl0ra6azZEtu6mHrCM5+Q53yFN0i/sgB\nRythcbb3TK6IbYJxxjhtBzYUxQ/r3KN+RM8hFdmKwmRklI3eyhGsx2CBAoGAUnyk\nZcNbES6vrV7yrKO88DR0lP06n2ptxCcoFvOUerLz5/Rye5imcaqTxm8It4n8t4Sg\nPLAjY6QpullV72sL5oY3MICdHNyofLFu2pLV/6vYCh8U4xwtoLZ77djyCAjzspjk\nqavy5YEI8bz5shBPmqgspSlE5b4xBxksVuEy8MECgYEAy11jCmo6DvjOpGXzENe9\nNNDGgmQOrzvHmPcq/vdxsg+2VpJuXLmPJXW6WIaiZpeaLaaZXRwbq2/Dij6G4qs7\nTe/iyVu1iMQf/RRRVyv40cjr0/zK7qD6dDyA6J1oSqfdFxE5otMVZY/vaOn0HISb\nEH58aHornAVABa7bq3tVeJw=\n-----END PRIVATE KEY-----\n",
      "client_email": "silenttalk@silent-talk-473717.iam.gserviceaccount.com",
      "client_id": "106752069325648309178",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/silenttalk%40silent-talk-473717.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    }
    ;
    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];
    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );
    auth.AccessCredentials credentials =
    await auth.obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
        client);
    client.close();
    return credentials.accessToken.data;
  }

  static Future<void> sendNotification(
      String deviceToken, String title, String body) async {
    final String accessToken = await getAccessToken();
    String endpointFCM =
        'https://fcm.googleapis.com/v1/projects/silentTalk/messages:send';
    final Map<String, dynamic> message = {
      "message": {
        "token": deviceToken,
        "notification": {"title": title, "body": body},
        "data": {
          "route": "serviceScreen",
        }
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFCM),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
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