import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_contacts/src/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:silent_talk/constants/texts.dart';
import 'package:silent_talk/service/authenticator/authenticator.dart';
import 'package:silent_talk/service/messages/get_messages.dart';
import 'package:silent_talk/service/messages/send_messages.dart';
import 'package:silent_talk/service/model/chat_model.dart';
import 'package:silent_talk/service/users/users_service.dart';
import 'package:silent_talk/utils/contact/send_contact.dart';

import '../service/ids/get_userIds.dart';
import '../service/model/user_model.dart';
import '../utils/biometric/auth.dart';
import '../utils/image_picker/image_picker.dart';
import '../widgets/message_list.dart';
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
  final Picker _picker = Picker();
  String? photoLink;
  bool? isAuthActive;

  // List<ChatModel> _chats = [];
  final UsersService _usersService = UsersService();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // loadIsAuth();
    setOnlineStatus();
    super.initState();
  }
  // Future<bool?> loadIsAuth()async{
  //   isAuthActive=await AuthService().isDeviceHave();
  //   return isAuthActive;
  // }
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
          .update({'isOnline': false, 'lastSeen': DateTime.now()});
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

  void selectedPicture(String path) {
    messageController.text = _picker.imgPath ?? '';
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Picker>(context);

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
                            ) // Chat ID
                            .collection('messages')
                            .orderBy('messageTime', descending: false)
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
                                ? GestureDetector(
                                onLongPress: ()async{
                                  await MessageService().deleteMessage(Authenticator().user!.uid,
                                      _users[widget.id!].id);
                                  print("${Authenticator().user!.uid}${_users[widget.id!].id}");
                                },
                                  child: MessageList(
                                    messages: messages,
                                    // photo: provider.imgPath ?? '',
                                  ),
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
                      readOnly:  provider.isImage,
                      controller: messageController,
                      decoration: InputDecoration(
                        hint:
                            provider.isImage
                                ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    provider.imgPath ?? '',
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.black.withOpacity(0.6),
                                  child: IconButton(
                                    icon: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                    onPressed: (){
                                     provider.clearImage();
                                    }
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
                            showCustomBottomSheet(context, widget.id!);
                          },
                        ),
                        suffixIcon: Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () {
                                provider.isImage
                                    ? messageController.text =
                                        provider.imgPath.toString()
                                    : messageController.text =
                                        messageController.text;
                                MessageService().sendMessage(
                                  messageController.text,
                                  Authenticator().user!.uid,
                                  _users[widget.id!].id,
                                );
                                messageController.clear();
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
