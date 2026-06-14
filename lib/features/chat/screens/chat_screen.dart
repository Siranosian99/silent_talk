import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_contacts/src/model/contact.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:silent_talk/constants/texts.dart';
import 'package:silent_talk/features/auth/services/authenticator.dart';
import 'package:silent_talk/features/auth/services/request_check.dart';
import 'package:silent_talk/features/chat/services/get_messages.dart';
import 'package:silent_talk/features/chat/services/send_messages.dart';

import 'package:silent_talk/features/user/service/users_service.dart';

import '../../../core/notification/message_detecter.dart';
import '../../../core/utils/image_picker/image_picker.dart';
import '../../../core/utils/last_seen/last_seen_provider.dart';
import '../../../core/utils/time_format/time_convertor.dart';

import '../../auth/services/get_deviceId.dart';
import '../../user/service/get_userIds.dart';
import '../../user/model/user_model.dart';
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
  final ScrollController _scrollController = ScrollController();
  final messageService = MessageService();

  // final _messageChanger=MessageChanger();
  List<Users> _users = [];
  late final Authenticator _authenticator;
  final Picker _picker = Picker();

  // String? photoLink;
  // String? photoServer;
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
    _authenticator = Authenticator();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final deviceId = await DeviceIdHelper().getDeviceId();
        _authenticator.listenForAnotherDeviceLogin(context, deviceId);
      }
    });
    // loadIsAuth();
    // Authenticator().anotherDeviceLoginListener(context);
    // ;
    // request();
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
    if (_authenticator.user?.uid != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_authenticator.user?.uid)
          .update({'isOnline': true});
    }
  }

  void setOfflineStatus() async {
    if (_authenticator.user?.uid != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_authenticator.user?.uid)
          .update({
            'isOnline': false,
            'lastSeen': lastSeenFormat(DateTime.now()),
          });
    }
  }

  @override
  void didChangeDependencies() {
    // selectedContact();
    getUsersDetails();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   scrollToBottom();
    // });
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
      if (_authenticator.user?.uid != null) {
        setOnlineStatus();
      }
    } else {
      setOfflineStatus();
    }
    super.didChangeAppLifecycleState(state);
  }

  // Future<void> noti() async {
  //   if (widget.receiverId != null) {
  //     await _messageChanger.notificationCheck(
  //       _authenticator.user!.uid,
  //       widget.receiverId!,
  //     );
  //   }
  // }

  // void scrollToBottom() {
  //   Future.delayed(const Duration(milliseconds: 100), () {
  //     if (_scrollController.hasClients) {
  //       _scrollController.animateTo(
  //         _scrollController.position.maxScrollExtent,
  //         duration: const Duration(milliseconds: 300),
  //         curve: Curves.easeOut,
  //       );
  //     }
  //   });
  // }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    messageController.dispose();
    searchController.dispose();
    _scrollController.dispose();
    setOfflineStatus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final lastProvider = Provider.of<LastSeenProvider>(context);

    final reciever = getReceiver();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:
          _users.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 50,top: 20,right: 50),
                        width: double.infinity,
                        height: 110,
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
                                  radius: 35,
                                  backgroundColor: Colors.grey.shade300,
                                  child: ClipOval(
                                    child: (reciever!.image.isEmpty)
                                        ? Image.asset(
                                      'assets/images/noProfile.png',
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    )
                                        : Image.network(
                                      reciever.image,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) {
                                        return Image.asset(
                                          'assets/images/noProfile.png',
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
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
                                      : "  ",
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
                        icon:isArabic ? Icon(Icons.navigate_next, size: 30): Icon(Icons.navigate_before, size: 30),
                      ),
                    ],
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection('chats')
                              .doc(
                                getChatId(
                                  _authenticator.user!.uid,
                                  widget.receiverId!,
                                ),
                              )
                              .collection('messages')
                              .orderBy('messageTime', descending: false)
                              .snapshots(),
                      builder: (context, snapshot) {
                      // _messageChanger.notificationCheck(
                      //     _authenticator.user!.uid,
                      //     widget.receiverId!,
                      //   );
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
                                    id1: _authenticator.user!.uid,
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
                  ),
                 Consumer<Picker>(
                    builder: (context, provider, child) {
                      return Stack(
                        children: [
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
                                      borderRadius: BorderRadius.circular(
                                        12,
                                      ),
                                      child: Image.file(
                                        File(provider.imgPath ?? ''),
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.black
                                          .withOpacity(0.6),
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
                                        final photoLink = provider.imgPath;
                                        final text = messageController.text.trim();

                                        //normal Message
                                        if (photoLink == null ||
                                            photoLink.isEmpty) {
                                          if (text.isNotEmpty) {
                                            await messageService.sendMessage(
                                              text,
                                              Authenticator().user!.uid,
                                              reciever.id,
                                            );
                                            messageController.clear();
                                          }
                                          return;
                                        }
                                        messageController.clear();
                                        provider.clearImage();
                                        final docId = await messageService
                                            .sendMessage(
                                          photoLink,
                                          _authenticator.user!.uid,
                                          reciever.id,
                                        );
                                        String cloudinaryUpload =
                                            await _picker.imgUploaderToServer(
                                              photoLink,
                                            ) ??
                                                '';
                                        if (cloudinaryUpload.isNotEmpty) {
                                          await messageService.updateMessages(
                                            cloudinaryUpload,
                                            _authenticator.user!.uid,
                                            reciever.id,
                                            docId,
                                          );
                                        }

                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )

                ],
              ),
    );
  }
}

// onPressed: () async {
//                                     final photoLink = provider.imgPath;
//                                     final text = messageController.text.trim();
//
//                                     // TEXT MESSAGE
//                                     if (photoLink == null || photoLink.isEmpty) {
//                                       if (text.isNotEmpty) {
//                                         await messageService.sendMessage(
//                                           text,
//                                           Authenticator().user!.uid,
//                                           reciever.id,
//                                         );
//                                       }
//
//                                       messageController.clear(); // ✔ burada
//                                       return;
//                                     }
//
//                                     // IMAGE MESSAGE
//
//                                     final docId = await messageService.sendMessage(
//                                       photoLink,
//                                       Authenticator().user!.uid,
//                                       reciever.id,
//                                     );
//
//                                     messageController.clear(); // 🔥 BURAYA AL
//
//                                     final cloudUrl =
//                                         await _picker.imgUploaderToServer(photoLink) ?? '';
//
//                                     if (cloudUrl.isNotEmpty) {
//                                       await messageService.updateMessages(
//                                         cloudUrl,
//                                         Authenticator().user!.uid,
//                                         reciever.id,
//                                         docId,
//                                       );
//                                     }
//
//                                     provider.clearImage();
//                                   }
