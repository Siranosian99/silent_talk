import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silent_talk/service/authenticator/authenticator.dart';
import 'package:silent_talk/service/messages/get_messages.dart';
import 'package:silent_talk/service/messages/send_messages.dart';
import 'package:silent_talk/service/model/chat_model.dart';
import 'package:silent_talk/service/users/users_service.dart';

import '../service/ids/get_userIds.dart';
import '../service/model/user_model.dart';
import '../widgets/sheet_to_share.dart';

class ChatScreen extends StatefulWidget {
  final String? name;
  final int? id;
  final String? senderId;
  final String? receiverId;

  const ChatScreen({
    super.key,
    this.name,
    this.id,
    this.senderId,
    this.receiverId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  TextEditingController messageController = TextEditingController();
  List<Users> _users = [];

  // List<ChatModel> _chats = [];
  final UsersService _usersService = UsersService();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    setOnlineStatus();
    super.initState();
  }

  void setOnlineStatus() async {
    if (_usersService.user?.uid != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_usersService.user?.uid)
          .update({'isOnline': true});
    }
  }

  void setOfflineStatus() async {
    if (_usersService.user?.uid != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_usersService.user?.uid)
          .update({'isOnline': false});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    setOfflineStatus();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    selectedContact();
    // getChat();
    getUsersDetails();
    super.didChangeDependencies();
  }

  Future<void> getUsersDetails() async {
    _users = await _usersService.fetchAllUsers();
    setState(() {
      _users;
    });
  }

  void selectedContact() {
    messageController.text = widget.name ?? '';
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_usersService.user?.uid != null) {
        setOnlineStatus();
      }
    } else {
      setOfflineStatus();
    }
    super.didChangeAppLifecycleState(state);
  }

  // Future<void> getChat() async {
  //   _chats = await GetMessageService().getChats(widget.senderId!,widget.receiverId!);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _users.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 150,
                        color: Color.fromRGBO(52, 136, 176, 0.91),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage:
                                      _users[widget.id!].image.isEmpty
                                          ? AssetImage(
                                            "assets/images/noProfile.png",
                                          )
                                          : NetworkImage(
                                            _users[widget.id!].image,
                                          ),
                                ),
                                CircleAvatar(
                                  backgroundColor:
                                      _users[widget.id!].isOnline
                                          ? Colors.green
                                          : Colors.red,
                                  radius: 10,
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Text(
                              _users[widget.id!].userName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text("Last seen: 12-00"),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.goNamed('people');
                        },
                        icon: Icon(Icons.navigate_before, size: 30),
                      ),
                    ],
                  ),

                  StreamBuilder<QuerySnapshot>(
                    stream:
                        FirebaseFirestore.instance
                            .collection('chats')
                            .doc(
                              getChatId(
                                Authenticator.user!.uid,
                                widget.receiverId!,
                              ),
                            ) // Chat ID
                            .collection('messages')
                            .orderBy('messageTime')
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error loading messages'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final messages = snapshot.data!.docs;
                      return Expanded(
                        child:
                            messages.isNotEmpty
                                ? ListView.builder(
                                  itemBuilder:
                                      (context, index) => Align(
                                        alignment:
                                            messages[index]['senderId'] ==
                                                    Authenticator.user?.uid
                                                ? Alignment.topRight
                                                : Alignment.topLeft,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 6,
                                            horizontal: 12,
                                          ),
                                          padding: const EdgeInsets.all(12),
                                          constraints: const BoxConstraints(
                                            maxWidth: 250,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                messages[index]['senderId'] ==
                                                        Authenticator.user?.uid
                                                    ? Color.fromRGBO(
                                                      24,
                                                      85,
                                                      115,
                                                      0.91,
                                                    )
                                                    : Color.fromRGBO(
                                                      40,
                                                      174,
                                                      39,
                                                      0.91,
                                                    ),
                                            borderRadius:
                                                const BorderRadius.only(
                                                  topLeft: Radius.circular(12),
                                                  topRight: Radius.circular(12),
                                                  bottomLeft: Radius.circular(
                                                    12,
                                                  ),
                                                ),
                                          ),
                                          child: Text(
                                            messages[index]['message'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),

                                  itemCount: messages.length,
                                )
                                : Center(
                                  child: Text(
                                    "No messages yet. Start the conversation!",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      // Semi-bold
                                      color: Color.fromRGBO(97, 119, 138, 1),
                                      // Make it fully opaque
                                      fontStyle: FontStyle.italic,
                                      // Optional: gives it a stylish slant
                                      letterSpacing:
                                          0.3, // Slight spacing for polish
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                      );
                    },
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.all(10),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.stretch,
                  //     children: [
                  //       Align(
                  //         alignment: Alignment.topLeft,
                  //         child: Container(
                  //           margin: const EdgeInsets.symmetric(
                  //             vertical: 6,
                  //             horizontal: 12,
                  //           ),
                  //           padding: const EdgeInsets.all(12),
                  //           constraints: const BoxConstraints(maxWidth: 250),
                  //           decoration: BoxDecoration(
                  //             color: Colors.grey.shade200,
                  //             borderRadius: const BorderRadius.only(
                  //               topRight: Radius.circular(12),
                  //               topLeft: Radius.circular(12),
                  //               bottomRight: Radius.circular(12),
                  //             ),
                  //           ),
                  //           child: Text(
                  //             _chats[2].message,
                  //             style: const TextStyle(fontSize: 16),
                  //           ),
                  //         ),
                  //       ),
                  //       Align(
                  //         alignment: Alignment.topRight,
                  //         child: Container(
                  //           margin: const EdgeInsets.symmetric(
                  //             vertical: 6,
                  //             horizontal: 12,
                  //           ),
                  //           padding: const EdgeInsets.all(12),
                  //           constraints: const BoxConstraints(maxWidth: 250),
                  //           decoration: BoxDecoration(
                  //             color: Colors.blueAccent,
                  //             borderRadius: const BorderRadius.only(
                  //               topLeft: Radius.circular(12),
                  //               topRight: Radius.circular(12),
                  //               bottomLeft: Radius.circular(12),
                  //             ),
                  //           ),
                  //           child: const Text(
                  //             "Heeeeey",
                  //             style: TextStyle(color: Colors.white, fontSize: 16),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),7
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.attach_file),
                          onPressed: () {
                            showCustomBottomSheet(context, widget.id!);
                          },
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            MessageService().sendMessage(
                              messageController.text,
                              Authenticator.user!.uid,
                              _users[widget.id!].id,
                            );
                            print(
                              'Contact ID:${widget.name} Sender ID:${widget.senderId}  Receiver ID:${widget.receiverId} ID Normal${widget.id}',
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
