import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:silent_talk/features/chat/services/send_messages.dart';

import 'package:silent_talk/features/chat/widgets/map_bubble.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils/contact/add_contact.dart';
import '../../../core/utils/contact/send_contact.dart';
import '../../../core/utils/file_picker/documents.dart';
import '../../../core/utils/file_picker/file_picker.dart';
import '../../../core/utils/file_saver/file_service.dart';
import '../../../core/utils/image_picker/image_picker.dart';
import '../../../core/utils/message_type/message_checker.dart';
import 'text_viewer.dart';
import '../../auth/services/authenticator.dart';

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
    final authenticator = Authenticator();
    final provider = Provider.of<Picker>(context);
    return ListView.builder(
      itemBuilder: (context, index) {
        final msg = messages[index]['message'];
        return GestureDetector(
          onTap: () async {
            final coords = msg.split("q=").last;
            final parts = coords.split(",");
            if (msg.contains("https://res.cloudinary.com")) {
              // String fileName,String urlPath, Uint8List bytes
              // Uint8List bytes = Uint8List.fromList(
              //   utf8.encode(messages[index]['message']),
              // );

              Filer.saveNetworkImage(msg);
              // FileSaver.downloadAndSave(messages[index]['message'], 'file1');
              print(msg);
            } else if (msg.contains('.txt') ||
                msg.contains('.pdf') ||
                msg.contains('.doc') ||
                msg.contains('.docx')) {
              DocumentsUtilty().saveFromLink(msg, msg.split('/').last);
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                  await readFileContent(msg).toString(),
                  style: const TextStyle(fontSize: 16, fontFamily: 'monospace'),
                ),
              );
            } else if (msg.contains("https://www.google.com/maps?q") ||
                msg.contains("maps://?q")) {
              await context.pushNamed(
                'mapLayer',
                extra: {
                  'latitude': double.parse(parts[0].trim()),
                  'longitude': double.parse(parts[1].trim()),
                  "receiverId": 'adf',
                },
              );
            } else if (msg.isNotEmpty) {
              final uri = Uri.tryParse(msg);
              if (MessageTypeChecker.isUrl(msg)) {
                await launchUrl(uri!);
              }
            }
          },
          onLongPress: () {
            MessageService().deleteMessage(id1, id2, messages[index]['docId']);
          },
          child: Align(
            alignment:
                messages[index]['senderId'] == authenticator.user?.uid
                    ? Alignment.topRight
                    : Alignment.topLeft,

            //here checkin//
            child:
                msg.contains("https://www.google.com/maps?q") ||
                        msg.contains("maps://?q")
                    ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MapPreview(url: msg),
                    )
                    : (msg.contains('.txt') ||
                        msg.contains('.pdf') ||
                        msg.contains('.doc') ||
                        msg.contains('.docx'))
                    ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 240,
                          height: 90,
                          color: Color(0xFFFFA726),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset(
                                'assets/icons/document.png',
                                scale: 15,
                              ),
                              Expanded(
                                child: Text(
                                  msg.split('/').last,
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.indigoAccent,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    : msg.contains("https://res.cloudinary.com")
                    ? Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          msg,
                          fit: BoxFit.cover,
                          width: 250,
                          height: 250,
                        ),
                      ),
                    )
                    : msg.contains("Name:")
                    ? Container(
                      width: 300,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                                    '${extractName(msg)}',
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
                                    '${extractPhone(msg)}',
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
                              addContact(
                                extractName(msg).toString(),
                                extractPhone(msg).toString(),
                              );
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
                                    authenticator.user?.uid
                                ? Color.fromRGBO(24, 85, 115, 0.91)
                                : Color.fromRGBO(40, 174, 39, 0.91),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      child: Text(
                        msg,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          decoration:
                              MessageTypeChecker.isUrl(msg)
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                        ),
                      ),
                    ),
          ),
        );
      },

      itemCount: messages.length,
    );
  }
}
