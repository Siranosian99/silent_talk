// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:silent_talk/constants/texts.dart';
// import 'package:silent_talk/service/authenticator/authenticator.dart';
// import 'package:silent_talk/service/messages/get_messages.dart';
// import 'package:silent_talk/service/messages/send_messages.dart';
// import 'package:silent_talk/service/model/user_model.dart';
// import 'package:silent_talk/service/notification/notification_shower.dart';
// import 'package:silent_talk/service/users/users_service.dart';
// import '../utils/time_format/time_convertor.dart';
// import '../widgets/message_list.dart';
// import '../widgets/sheet_to_share.dart';
//
// class ChatScreen extends StatefulWidget {
//   final String? receiverId; // ID of the user we are chatting with
//
//   const ChatScreen({super.key, this.receiverId});
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
//   TextEditingController messageController = TextEditingController();
//   List<Users> _users = [];
//   final UsersService _usersService = UsersService();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     setOnlineStatus();
//     getUsersDetails();
//   }
//
//   Future<void> getUsersDetails() async {
//     _users = await _usersService.fetchAllUsers();
//     setState(() {});
//   }
//
//   Users? getReceiver() {
//     if (widget.receiverId == null) return null;
//     try {
//       return _users.firstWhere((user) => user.id == widget.receiverId);
//     } catch (e) {
//       return null;
//     }
//   }
//
//   void setOnlineStatus() async {
//     if (_usersService.user?.uid != null) {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(_usersService.user!.uid)
//           .update({'isOnline': true});
//     }
//   }
//
//   void setOfflineStatus() async {
//     if (_usersService.user?.uid != null) {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(_usersService.user!.uid)
//           .update({
//         'isOnline': false,
//         'lastSeen': lastSeenFormat(DateTime.now()),
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     setOfflineStatus();
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       setOnlineStatus();
//     } else {
//       setOfflineStatus();
//     }
//     super.didChangeAppLifecycleState(state);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final receiver = getReceiver();
//
//     if (receiver == null) {
//       return Scaffold(
//         appBar: AppBar(title: Text("User not found")),
//         body: Center(child: Text("The selected user does not exist.")),
//       );
//     }
//
//     return Scaffold(
//       body: Column(
//         children: [
//           // Top bar with user info
//           Container(
//             padding: EdgeInsets.only(left: 40),
//             width: double.infinity,
//             height: 90,
//             color: Color.fromRGBO(52, 136, 176, 0.91),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     print("Receiver ID: ${receiver.id}");
//                   },
//                   child: Stack(
//                     alignment: Alignment.bottomRight,
//                     children: [
//                       CircleAvatar(
//                         radius: 40,
//                         backgroundImage: receiver.image.isEmpty
//                             ? AssetImage("assets/images/noProfile.png")
//                             : NetworkImage(receiver.image),
//                       ),
//                       CircleAvatar(
//                         radius: 10,
//                         backgroundColor:
//                         receiver.isOnline ? Colors.green : Colors.red,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       receiver.userName,
//                       style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                     ),
//                     Text(
//                       receiver.lastSeen,
//                       style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//                 Spacer(),
//                 IconButton(
//                   onPressed: () => context.goNamed('people'),
//                   icon: Icon(Icons.navigate_before, size: 30),
//                 ),
//               ],
//             ),
//           ),
//
//           // Messages list
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('chats')
//                   .doc(getChatId(
//                 Authenticator().user!.uid,
//                 receiver.id!,
//               ))
//                   .collection('messages')
//                   .orderBy('messageTime', descending: false)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error loading messages'));
//                 }
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//
//                 final messages = snapshot.data!.docs;
//                 return messages.isNotEmpty
//                     ? MessageList(
//                   messages: messages,
//                   id1: Authenticator().user!.uid,
//                   id2: receiver.id!,
//                 )
//                     : Center(
//                   child: Text(
//                     "No messages yet. Start the conversation!",
//                     style: TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.w600,
//                       color: Color.fromRGBO(97, 119, 138, 1),
//                       fontStyle: FontStyle.italic,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 );
//               },
//             ),
//           ),
//
//           // Message input
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: TextFormField(
//               controller: messageController,
//               decoration: InputDecoration(
//                 hintText: AppTexts.instance.typemsg,
//                 filled: true,
//                 contentPadding:
//                 const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(24),
//                   borderSide: BorderSide.none,
//                 ),
//                 prefixIcon: IconButton(
//                   icon: Icon(Icons.attach_file),
//                   onPressed: () => showCustomBottomSheet(context, receiver.id!),
//                 ),
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () {
//                     MessageService().sendMessage(
//                       messageController.text,
//                       Authenticator().user!.uid,
//                       receiver.id!,
//                     );
//
//                     // Trigger local notification for receiver
//                     NotificationHandler(
//                       id: DateTime.now().millisecondsSinceEpoch,
//                       senderId: Authenticator().user!.uid,
//                       recieverId: receiver.id!,
//                     )._showNotificationForReceiver(
//                         title: "New message", body: messageController.text);
//
//                     messageController.clear();
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
