import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:silent_talk/service/messages/send_messages.dart';
import 'package:silent_talk/utils/contact/add_contact.dart';
import 'package:silent_talk/utils/file_saver/file_service.dart';

import '../service/authenticator/authenticator.dart';
import '../utils/contact/send_contact.dart';
import '../utils/image_picker/image_picker.dart';

class MessageList extends StatelessWidget {
  const MessageList({
    super.key,
    required this.messages,
    required this.id1,
    required this.id2,
  });

  final List<QueryDocumentSnapshot<Object?>> messages;
  final String id1;
  final String id2;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Picker>(context);
    return ListView.builder(
      itemBuilder:
          (context, index) => GestureDetector(
            onTap: () {
              if (messages[index]['message'].contains(
                "https://res.cloudinary.com",
              )) {
                // String fileName,String urlPath, Uint8List bytes
                Uint8List bytes = Uint8List.fromList(
                  utf8.encode(messages[index]['message']),
                );

                FileSaver.saveNetworkImage(messages[index]['message']);
                // FileSaver.downloadAndSave(messages[index]['message'], 'file1');
                print(messages[index]['message']);
              }
            },
            onLongPress: () {
              MessageService().deleteMessage(
                id1,
                id2,
                messages[index]['docId'],
              );
            },
            child: Align(
              alignment:
                  messages[index]['senderId'] == Authenticator().user?.uid
                      ? Alignment.topRight
                      : Alignment.topLeft,

              //here checkin///
              child:
                  messages[index]['message'].contains(
                        "https://res.cloudinary.com",
                      )
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          messages[index]['message'],
                          fit: BoxFit.cover,
                          width: 250,
                          height: 250,
                        ),
                      )
                      : messages[index]['message'].contains("Name:")
                      ? Container(
                        width: 300,
                        margin: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                          border: Border(
                            left: BorderSide(
                              color: Colors.green.shade600,
                              width: 4,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor: Colors.green.shade100,
                                  child: Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${extractName(messages[index]['message'])}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      '${extractPhone(messages[index]['message'])}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            InkWell(
                              onTap: () {
                                addContact(extractName(messages[index]['message']).toString(), extractPhone(messages[index]['message']).toString());
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person_add,
                                    color: Colors.green.shade700,
                                    size: 20,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "Add to contacts",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      // : messages[index]['message'].contains(
                      //   "https://res.cloudinary.com:",
                      // )
                      // ? Container(
                      //   margin: const EdgeInsets.symmetric(
                      //     vertical: 6,
                      //     horizontal: 12,
                      //   ),
                      //   padding: const EdgeInsets.all(12),
                      //   constraints: const BoxConstraints(maxWidth: 250),
                      //   decoration: BoxDecoration(
                      //     color:
                      //         messages[index]['senderId'] ==
                      //                 Authenticator().user?.uid
                      //             ? Color.fromRGBO(24, 85, 115, 0.91)
                      //             : Color.fromRGBO(40, 174, 39, 0.91),
                      //     borderRadius: const BorderRadius.only(
                      //       topLeft: Radius.circular(20),
                      //       topRight: Radius.circular(20),
                      //       bottomLeft: Radius.circular(20),
                      //     ),
                      //   ),
                      //   child: Image.network(messages[index]['message']),
                      // )
                      // :
                      : Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12,
                        ),
                        padding: const EdgeInsets.all(12),
                        constraints: const BoxConstraints(maxWidth: 250),
                        decoration: BoxDecoration(
                          color:
                              messages[index]['senderId'] ==
                                      Authenticator().user?.uid
                                  ? Color.fromRGBO(24, 85, 115, 0.91)
                                  : Color.fromRGBO(40, 174, 39, 0.91),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        child: Text(
                          messages[index]['message'],
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
            ),
          ),

      itemCount: messages.length,
    );
  }
}
