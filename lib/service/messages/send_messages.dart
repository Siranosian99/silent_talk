import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService{
  String getChatId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort(); // ensures same order
    return ids.join("_");
  }

Future<void> sendMessage(String messageTxt,String uId1,String uId2,)async{
    getChatId(uId1, uId2);
    CollectionReference collectionReference=await FirebaseFirestore.instance.collection('chats');
}

}