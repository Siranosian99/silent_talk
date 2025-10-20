import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:silent_talk/widgets/requests_dialog.dart';

import '../ids/get_userIds.dart';
import '../model/request_model.dart';
import 'authenticator.dart';

class RequestsChats{
Future<void> sendRequest(bool request, String uId1, String uId2) async {
  try {

    final requests = FirebaseFirestore.instance
        .collection("requests")
        .doc(getChatId(uId1, uId2));
    String docId = '';
    await requests
        .set({
        "docId": docId,
      "requestId":uId2 ,
      "requestStatus": request,
      "requestSenderId": uId1,
      "requestReceiverId": uId2,

      // Firestore server time
    });
    //     .then((DocumentReference doc) {
    //   requests.doc(doc.id).update({"docId": doc.id});
    //   // print("------------${doc.id}----------");
    // });

    print("Requests Details SenderId:$uId1,RecieverId:$uId2");
  } catch (e) {
    print("Request Didnt Send");
  }
}
Future<List<Request>?> getRequests() async {

  if (Authenticator.user == null) return null;

  final doc = await FirebaseFirestore.instance
      .collection('requests')
      .where(FieldPath.documentId, isGreaterThanOrEqualTo: Authenticator.user?.uid)
      .where(FieldPath.documentId, isLessThanOrEqualTo: '${Authenticator.user?.uid}\uf8ff')
      .get();
  return doc.docs.where((doc) =>
  doc.id != Authenticator.user?.uid
  ) // hide current user
      .map((doc) {
    return Request(
      requestSenderId: doc['requestSenderId'], requestReceiverId:  doc['requestReceiverId'], requestId:doc['requestId'],requestStatus: doc['requestStatus'],
    );
  }).toList();
}}


//  final String requestSenderId;
//   final String requestReceiverId;
//   bool requestStatus;



// Future<List<Users>?> fetchAllUsers(String name) async {
//     try {
//       // Fetch all documents from the Category collection
//       QuerySnapshot? snapshot;
//       if(name.isEmpty){
//         snapshot=  await users.get();
//       }
//       else if(name.isNotEmpty){
//         snapshot = await users
//             .where('name', isGreaterThanOrEqualTo: name)
//             .where('name', isLessThanOrEqualTo: name + '\uf8ff')
//             .get();
//
//       }
//
//       // Map each document to its data
//       return snapshot?.docs.where((doc) =>
//       doc.id != Authenticator.user?.uid
//       ) // hide current user
//           .map((doc) {
//         return Users(
//             deviceId: doc['deviceId'],
//             lastSeen:doc['lastSeen'],
//             id: doc['id'],
//             name: doc['name'],
//             userName: doc['userName'],
//             email: doc['email'],
//             password: doc['password'],
//             token: doc['token'],
//             image: doc['image'],
//             isOnline: doc['isOnline'],
//         );
//       }).toList();
//     } catch (e) {
//       print('Error fetching categories: $e');
//       return [];
//     }
//   }



