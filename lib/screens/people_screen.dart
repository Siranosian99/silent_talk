import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silent_talk/service/authenticator/authenticator.dart';
import 'package:silent_talk/service/ids/get_userIds.dart';

import 'package:silent_talk/service/users/user_details/users_service.dart';

import '../l10n/app_localizations.dart';
import '../service/authenticator/request_check.dart';
import '../service/model/user_model.dart';

import '../widgets/chats_searchBar.dart';

class PeopleScreen extends StatefulWidget {
  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  final TextEditingController searchController = TextEditingController();


  late List<Users> users = [];
  final UsersService _usersService = UsersService();
  final RequestsChats _requestsChats=RequestsChats();

  Future<void> callUsers(String query) async {
    users = await _usersService.fetchAllUsers(query) ?? [];
    setState(() {
      users;
    });
  }

  @override
  void initState() {
    callUsers('');

    super.initState();
  }


  void checkRequestStatus(String docId) async {
    String id = getChatId(Authenticator.user!.uid, docId);

    bool? status = await _requestsChats.getRequestStatus(id);

    if (status != null) {
      if (status) {
        print("Request is active/accepted");
      } else {
        print("Request exists but not accepted");
      }
    } else {
      print("No request found");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.chats),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.pushNamed('request');
            },
            icon: Icon(Icons.people),
          ),
          IconButton(
            onPressed: () {
              context.pushNamed('settings');
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          ChatSearchBar(
            controller: searchController,
            onChanged: (value) {
            callUsers(value);
            },
          ),
          SizedBox(height: 20),
          // Grid of users
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: users.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final user = users[index];
                return Column(
                  children: [
                    InkWell(
                      onTap: ()async {
                        String id = getChatId(Authenticator.user!.uid, user.id);

                        bool status = await _requestsChats.getRequestStatus(id) ??false;
                        print(status);
                        if(status){
                          GoRouter.of(context).pushNamed(
                            'chat',
                            extra: {
                              'id': user.id,
                              'senderId': Authenticator.user?.uid,
                              'receiverId': user.id,
                            },
                          );
                        }
                        else{
                          RequestsChats().sendRequest(false, Authenticator.user!.uid, user.id);
                        }
                        print("UserId:${user.id}");

                      },
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage:
                            user.image.isEmpty
                                ? AssetImage('assets/images/noProfile.png')
                                : NetworkImage(user.image),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.name,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
//StreamBuilder<QuerySnapshot>(
//                     stream:
//                         FirebaseFirestore.instance
//                             .collection('chats')
//                             .doc(
//                               getChatId(
//                                 Authenticator.user!.uid,
//                                 widget.receiverId!,
//                               ),
//                             ) // Chat ID
//                             .collection('messages')
//                             .orderBy('messageTime', descending: false)
//                             .snapshots(),
//                     builder: (context, snapshot) {
//                       if (snapshot.hasError) {
//                         return Center(child: Text('Error loading messages'));
//                       }
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return Center(child: CircularProgressIndicator());
//                       }
//
//                       final messages = snapshot.data!.docs;
//                       return Expanded(
//                         child:
//                             messages.isNotEmpty
//                                 ? MessageList(
//                                   messages: messages,
//                                   id1: Authenticator.user!.uid,
//                                   id2: reciever.id,
//                                   // photo: provider.imgPath ?? '',
//                                 )
//                                 : Center(
//                                   child: Text(
//                                     "No messages yet. Start the conversation!",
//                                     style: TextStyle(
//                                       fontSize: 17,
//                                       fontWeight: FontWeight.w600,
//                                       // Semi-bold
//                                       color: Color.fromRGBO(97, 119, 138, 1),
//                                       // Make it fully opaque
//                                       fontStyle: FontStyle.italic,
//                                       // Optional: gives it a stylish slant
//                                       letterSpacing:
//                                           0.3, // Slight spacing for polish
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                       );
//                     },
//                   ),