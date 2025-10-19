import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:silent_talk/widgets/requests_dialog.dart';

import '../ids/get_userIds.dart';
import 'authenticator.dart';

class RequestsChats{
Future<void> sendRequest(bool request, String uId1, String uId2) async {
  try {

    CollectionReference requests = FirebaseFirestore.instance
        .collection("requests")
        .doc(getChatId(uId1, uId2))
        .collection("users_requests");
    String docId = '';
    await requests
        .add({
        "docId": docId,
      "requestId": getChatId(uId1, uId2),
      "requestStatus": request,
      "requestSenderId": uId1,
      "requestReceiverId": uId2,

      // Firestore server time
    })
        .then((DocumentReference doc) {
      requests.doc(doc.id).update({"docId": doc.id});
      // print("------------${doc.id}----------");
    });

    print("Requests Work");
  } catch (e) {
    print("Request Didnt Send");
  }
}}


//  final String requestSenderId;
//   final String requestReceiverId;
//   bool requestStatus;