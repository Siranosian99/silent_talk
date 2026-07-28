import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:silent_talk/constants/api_consts.dart';
import 'package:silent_talk/features/chat/services/send_messages.dart';

import 'package:silent_talk/features/chat/widgets/map_bubble.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils/contact/add_contact.dart';
import '../../../core/utils/contact/send_contact.dart';

import '../../../core/utils/files/file_service.dart';
import '../../../core/utils/files/documents.dart';
import '../../../core/utils/files/file_picker.dart';
import '../../../core/utils/image_picker/image_picker.dart';
import '../../../core/utils/message_type/message_checker.dart';
import '../../../core/widgets/location_dialog.dart';
import '../../../providers/loading_provider.dart';
import 'chat_image_bubble.dart';
import 'text_viewer.dart';
import '../../auth/services/authenticator.dart';

class MessageList extends StatefulWidget {
  const MessageList({
    super.key,
    required this.messages,
    required this.id1,
    required this.id2,
    required this.controller,
  });

  final List<QueryDocumentSnapshot<Object?>> messages;
  final String id1;
  final String id2;
  final ScrollController controller;

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final authenticator = Authenticator();

  final storageService = StorageService();

  final messageService = MessageService();

  @override
  Widget build(BuildContext context) {
    final loadingProvider = Provider.of<LoadingProvider>(context);

    // final provider = Provider.of<Picker>(context);
    return ListView.builder(
      controller: widget.controller,
      itemBuilder: (context, index) {
        final msg = widget.messages[index]['message'];
        final type = widget.messages[index].data() as Map<String, dynamic>;
        final fileName = msg.split('/').last.split('_').last;
        return GestureDetector(
          onTap: () async {
            final coords = msg.split("q=").last;
            final parts = coords.split(",");
            if (type['type'] == 'location') {
              if (!context.mounted) return;
              await ShowDialogLocation(context);
              if (!context.mounted) return;
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
          onLongPress: () async {
            await messageService.deleteMessage(
              widget.id1,
              widget.id2,
              widget.messages[index]['docId'],
            );
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Message Deleted successfully')),
            );
          },
          child: Align(
            alignment:
                widget.messages[index]['senderId'] == authenticator.user?.uid
                    ? Alignment.topRight
                    : Alignment.topLeft,

            //here checkin//
            child:
                type['type'] == 'location'
                    ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MapPreview(url: msg),
                    )
                    : (type['type'] == 'document')
                    ? Padding(
                      padding: const EdgeInsets.only(
                        left: 25,
                        right: 15,
                        bottom: 10,
                      ),
                      child: documentWidget(
                        fileName: fileName,
                        storageService: storageService,
                        msg: msg,
                        provider: loadingProvider,
                      ),
                    )
                    : type['type'] == 'image'
                    ? ChatImage(
                      onTap: () => Filer.saveNetworkImage(msg),
                      imageUrl: msg,
                      isMe:
                          widget.messages[index]['senderId'] ==
                          authenticator.user?.uid,
                    )
                    : // here contacts
                    type['type'] == 'contact'
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
                    : Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 12,
                      ),
                      padding: const EdgeInsets.all(12),
                      constraints: const BoxConstraints(maxWidth: 250),
                      decoration: BoxDecoration(
                        color:
                            widget.messages[index]['senderId'] ==
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

      itemCount: widget.messages.length,
    );
  }
}

class documentWidget extends StatelessWidget {
  const documentWidget({
    super.key,
    required this.fileName,
    required this.storageService,
    required this.msg,
    required this.provider,
  });

  final dynamic fileName;
  final StorageService storageService;
  final String msg;
  final LoadingProvider provider;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 250,
        height: 100,
        color: Color(0xFF3B82F6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/icons/document.png', scale: 10),
            ),
            Expanded(
              child: Text(
                fileName,
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFFFFFF),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                try {
                  provider.setLoading(true);
                  await storageService.openDocument(msg);
                  provider.setLoading(false);
                } finally {
                  provider.setLoading(false);
                }
              },
              icon:
                  provider.isLoading
                      ? Icon(Icons.timelapse)
                      : Icon(Icons.open_in_new),
            ),
            IconButton(
              onPressed: () async {
                try {
                  provider.setLoading(true);
                  await storageService.downloadFile(msg);
                  provider.setLoading(false);
                } finally {
                  provider.setLoading(false);
                }
              },
              icon:
                  provider.isLoading
                      ? Icon(Icons.timelapse)
                      : Icon(Icons.get_app),
            ),
          ],
        ),
      ),
    );
  }
}
