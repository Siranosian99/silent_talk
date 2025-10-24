import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_contacts/src/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:silent_talk/constants/texts.dart';
import 'package:silent_talk/service/authenticator/authenticator.dart';
import 'package:silent_talk/service/authenticator/request_check.dart';
import 'package:silent_talk/service/messages/get_messages.dart';
import 'package:silent_talk/service/messages/send_messages.dart';
import 'package:silent_talk/service/model/chat_model.dart';
import 'package:silent_talk/service/notification/get_token.dart';
import 'package:silent_talk/service/notification/message_detecter.dart';
import 'package:silent_talk/service/notification/notification_shower.dart';
import 'package:silent_talk/service/users/user_details/users_service.dart';
import 'package:silent_talk/utils/contact/send_contact.dart';
import 'package:silent_talk/utils/last_seen/last_seen_provider.dart';
import 'package:silent_talk/utils/time_format/time_convertor.dart';
import 'package:silent_talk/widgets/requests_dialog.dart';

import '../service/authenticator/authenticator.dart';
import '../service/ids/get_userIds.dart';
import '../service/model/user_model.dart';
import '../utils/biometric/auth.dart';
import '../utils/image_picker/image_picker.dart';
import '../widgets/message_list.dart';
import '../widgets/sheet_to_share.dart';

class ChatScreen extends StatefulWidget {
  final String? name;

  // final int? id;
  // final String? senderId;
  final String? receiverId;

  const ChatScreen({
    super.key,
    this.name,
    // this.id,
    // this.senderId,
    this.receiverId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  TextEditingController messageController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List<Users> _users = [];
  final Picker _picker = Picker();
  String? photoLink;
  String? photoServer;
  bool? isAuthActive;

  // List<ChatModel> _chats = [];
  final UsersService _usersService = UsersService();

  Users? getReceiver() {
    if (widget.receiverId == null) return null;
    try {
      return _users.firstWhere((user) => user.id == widget.receiverId);
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // loadIsAuth();
    // Authenticator().anotherDeviceLoginListener(context);
    // ;
    // request();
    print("----------------------------${widget.receiverId}");
    print("----------------------------${Authenticator().user?.uid}");

    setOnlineStatus();
    super.initState();
  }

  // Future<void> request() async {
  //   await RequestsChats().sendRequest(context);
  // }

  // Future<bool?> loadIsAuth()async{
  //   isAuthActive=await AuthService().isDeviceHave();
  //   return isAuthActive;
  // }
  void setOnlineStatus() async {
    if (Authenticator().user?.uid != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(Authenticator().user?.uid)
          .update({'isOnline': true});
    }
  }

  void setOfflineStatus() async {
    if (Authenticator().user?.uid != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(Authenticator().user?.uid)
          .update({
            'isOnline': false,
            'lastSeen': lastSeenFormat(DateTime.now()),
          });
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
    // selectedContact();
    getUsersDetails();
    super.didChangeDependencies();
  }

  Future<void> getUsersDetails() async {
    _users = await _usersService.fetchAllUsers('') ?? [];
    // noti();
    setState(() {
      _users;
    });
  }

  void selectedContact() {
    messageController.text = widget.name ?? '';
  }

  void selectedPicture(String path) {
    messageController.text = _picker.imgPath ?? '';
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (Authenticator().user?.uid != null) {
        setOnlineStatus();
      }
    } else {
      setOfflineStatus();
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> noti() async {
    if (widget.receiverId != null) {
      await MessageChanger().notificationCheck(
        Authenticator().user!.uid,
        widget.receiverId!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Picker>(context);
    final lastProvider = Provider.of<LastSeenProvider>(context);
    final reciever = getReceiver();
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
                        padding: EdgeInsets.only(left: 40),
                        width: double.infinity,
                        height: 90,
                        color: Color.fromRGBO(52, 136, 176, 0.91),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          spacing: 5,
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage:
                                      reciever!.image.isEmpty
                                          ? AssetImage(
                                            "assets/images/noProfile.png",
                                          )
                                          : NetworkImage(reciever.image),
                                ),
                                CircleAvatar(
                                  backgroundColor:
                                      reciever.isOnline
                                          ? Colors.green
                                          : Colors.red,
                                  radius: 10,
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  reciever.userName ?? "",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  lastProvider.isSeen
                                      ? reciever.lastSeen
                                      : "--------",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        Colors.grey[500], // silver-like color
                                  ),
                                ),
                              ],
                            ),

                            // Text(_users[widget.id!].lastSeen.toString()),
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
                                Authenticator().user!.uid,
                                widget.receiverId!,
                              ),
                            )
                            .collection('messages')
                            .orderBy('messageTime', descending: false)
                            .snapshots(),
                    builder: (context, snapshot) {
                       MessageChanger().notificationCheck(
                        Authenticator().user!.uid,
                        widget.receiverId!,
                      );
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
                                ? MessageList(
                                  messages: messages,
                                  id1: Authenticator().user!.uid,
                                  id2: reciever.id,
                                  // photo: provider.imgPath ?? '',
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
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      readOnly: provider.isImage,
                      controller: messageController,
                      decoration: InputDecoration(
                        hint:
                            provider.isImage
                                ? Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        File(provider.imgPath ?? ''),
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.black.withOpacity(
                                        0.6,
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          provider.clearImage();
                                        },
                                      ),
                                    ),
                                  ],
                                )
                                : Text(AppTexts.instance.typemsg),
                        filled: true,
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
                            showCustomBottomSheet(context, 21, reciever.id);
                          },
                        ),
                        suffixIcon: Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () async {
                                photoLink = provider.imgPath;
                                if (photoLink == null || photoLink!.isEmpty) {
                                  if (messageController.text.isNotEmpty) {
                                    await MessageService().sendMessage(
                                      messageController.text,
                                      Authenticator().user!.uid,
                                      reciever.id,
                                    );
                                  }
                                  messageController.clear();
                                }
                                photoServer = await provider
                                    .imgUploaderToServer(photoLink.toString());
                                if (photoServer != null ||
                                    photoServer!.isNotEmpty) {
                                  messageController.text = photoServer!;
                                  await MessageService().sendMessage(
                                    messageController.text,
                                    Authenticator().user!.uid,
                                    reciever.id,
                                  );
                                  messageController.clear();
                                  provider.clearImage();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
