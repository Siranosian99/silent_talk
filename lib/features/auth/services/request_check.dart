import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:silent_talk/features/user/widgets/requests_dialog.dart';

import '../../user/service/get_userIds.dart';
import '../../chat/model/request_model.dart';
import 'authenticator.dart';

class RequestsChats {
    Future<String> sendRequest(bool request, String uId1, String uId2) async {
      try {
        final requests = FirebaseFirestore.instance
            .collection("requests")
            .doc(getChatId(uId1, uId2));

        final docSnapshot = await requests.get();

        // If document doesn't exist, create it
        if (!docSnapshot.exists) {
          await requests.set({
            "docId": getChatId(uId1, uId2),
            "requestId": uId2,
            "requestStatus": request,
            "requestSenderId": uId1,
            "requestReceiverId": uId2,
            "participants":[uId1,uId2],
            "createdAt": FieldValue.serverTimestamp(),
          });

          return "✅ Request send to user";
        } else {

          return "⚠️ Request already exists ";
        }
      } catch (e) {
        return"❌ Request didn't send: $e";
      }
    }

  // Future<List<Request>?> getRequests(String docId) async {
  //   if (Authenticator().user == null) return null;
  //
  //   String fullId = docId;
  //   List<String> parts = fullId.split("_");
  //   String secondPart = parts[1];
  //   final doc =
  //       await FirebaseFirestore.instance
  //           .collection('requests')
  //           .where(
  //             FieldPath.documentId,
  //             isGreaterThanOrEqualTo: secondPart,
  //           )
  //           .where(
  //             FieldPath.documentId,
  //             isLessThanOrEqualTo: secondPart,
  //           )
  //           .get();
  //   return doc.docs
  //       .where((doc) => doc.id != secondPart) // hide current user
  //       .map((doc) {
  //         return Request(
  //           requestSenderId: doc['requestSenderId'],
  //           requestReceiverId: doc['requestReceiverId'],
  //           requestId: doc['requestId'],
  //           requestStatus: doc['requestStatus'],
  //           participants: doc['participants'],
  //         );
  //       })
  //       .toList();
  // }

  Future<bool?> getRequestStatus(String docId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('requests')
          .doc(docId)
          .get();

      if (doc.exists) {
        // Cast the document data to a Map
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Return the boolean value of requestStatus
        return data['requestStatus'] as bool?;
      } else {
        print('Document not found');
        return null;
      }
    } catch (e) {
      print('Error getting document: $e');
      return null;
    }
  }

  Future<void>acceptRequest(String docId)async{
    await FirebaseFirestore.instance.collection('requests').doc(docId).set(
      {'requestStatus': true},
      SetOptions(merge: true),
    );
  }
    Future<void>rejectRequest(String docId)async{
      try{
        await FirebaseFirestore.instance.collection('requests').doc(docId).delete();
        print("Cancelled successfully");
      }
      catch(e){
        print("There is error to Cancel");
      }
    }

}

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
