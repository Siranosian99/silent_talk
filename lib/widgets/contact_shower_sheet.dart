import 'dart:async';
import 'dart:convert';
import 'dart:typed_data' as td;

import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:silent_talk/contact/send_contact.dart';

import '../service/authenticator/authenticator.dart';
import 'contact_dialog.dart';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<Contact> _contacts = const [];
  String? _text;

  bool _isLoading = false;

  List<ContactField> _fields = ContactField.values.toList();

  @override
  void initState() {
    loadContacts();
    super.initState();
  }

  final _ctrl = ScrollController();

  Future<void> loadContacts() async {
    try {
      await Permission.contacts.request();
      _isLoading = true;
      if (mounted) setState(() {});
      final sw = Stopwatch()..start();
      _contacts = await FastContacts.getAllContacts(fields: _fields);
      sw.stop();
      _text = 'Contacts: ${_contacts.length}';
    } on PlatformException catch (e) {
      _text = 'Failed to get contacts:\n${e.details}';
    } finally {
      _isLoading = false;
    }
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scrollbarTheme: ScrollbarThemeData(
          trackVisibility: WidgetStateProperty.all(true),
          thumbVisibility: WidgetStateProperty.all(true),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.pop(); // ✅ This works because the original ChatScreen is still in memory

            },
            icon: Icon(Icons.navigate_before),
          ),
          title: const Text('Search Contact'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Text(_text ?? 'Tap to load contacts', textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Expanded(
              child: Scrollbar(
                controller: _ctrl,
                interactive: true,
                thickness: 24,
                child: ListView.separated(
                  controller: _ctrl,
                  itemCount: _contacts.length,
                  // itemExtent: _ContactItem.height,
                  itemBuilder:
                      (_, index) {
                     return   _ContactItem(contact: _contacts[index],index:index);

                      },
                  separatorBuilder:
                      (BuildContext context, int index) => SizedBox(height: 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {

   const _ContactItem({Key? key, required this.contact,required this.index}) : super(key: key);

  static final height = 86.0;

   final Contact contact;
   final int index;


  @override
  Widget build(BuildContext context) {
    final phones = contact.phones.map((e) => e.number).join(', ');
    final emails = contact.emails.map((e) => e.address).join(', ');
    final name = contact.structuredName;
    final nameStr =
        name != null
            ? [
              if (name.namePrefix.isNotEmpty) name.namePrefix,
              if (name.givenName.isNotEmpty) name.givenName,
              if (name.middleName.isNotEmpty) name.middleName,
              if (name.familyName.isNotEmpty) name.familyName,
              if (name.nameSuffix.isNotEmpty) name.nameSuffix,
            ].join(', ')
            : '';
    final organization = contact.organization;
    final organizationStr =
        organization != null
            ? [
              if (organization.company.isNotEmpty) organization.company,
              if (organization.department.isNotEmpty) organization.department,
              if (organization.jobDescription.isNotEmpty)
                organization.jobDescription,
            ].join(', ')
            : '';

    return SizedBox(
      height: height,
      child: ListTile(
        onTap:
            () {
              context.pushNamed(
                'chat',
                extra: {
                  'id': index,
                  'senderId': '',
                  'receiverId': '',
                  'name': contact.displayName,
                },
              );
              },
        leading: _ContactImage(contact: contact),
        title: Text(
          contact.displayName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (phones.isNotEmpty)
              Text(phones, maxLines: 1, overflow: TextOverflow.ellipsis),
            if (emails.isNotEmpty)
              Text(emails, maxLines: 1, overflow: TextOverflow.ellipsis),
            if (nameStr.isNotEmpty)
              Text(nameStr, maxLines: 1, overflow: TextOverflow.ellipsis),
            if (organizationStr.isNotEmpty)
              Text(
                organizationStr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}

class _ContactImage extends StatefulWidget {
  const _ContactImage({Key? key, required this.contact}) : super(key: key);

  final Contact contact;

  @override
  __ContactImageState createState() => __ContactImageState();
}

class __ContactImageState extends State<_ContactImage> {
  late Future<td.Uint8List?> _imageFuture;

  @override
  void initState() {
    super.initState();
    _imageFuture = FastContacts.getContactImage(widget.contact.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<td.Uint8List?>(
      future: _imageFuture,
      builder:
          (context, snapshot) => Container(
            width: 56,
            height: 56,
            child:
                snapshot.hasData
                    ? Image.memory(snapshot.data!, gaplessPlayback: true)
                    : Icon(Icons.account_box_rounded),
          ),
    );
  }
}
//
// class _ContactDetailsPage extends StatefulWidget {
//   const _ContactDetailsPage({Key? key, required this.contactId})
//     : super(key: key);
//
//   final String contactId;
//
//   @override
//   State<_ContactDetailsPage> createState() => _ContactDetailsPageState();
// }
//
// class _ContactDetailsPageState extends State<_ContactDetailsPage> {
//   late Future<Contact?> _contactFuture;
//
//   Duration? _timeTaken;
//
//   @override
//   void initState() {
//     super.initState();
//     final sw = Stopwatch()..start();
//     _contactFuture = FastContacts.getContact(widget.contactId).then((value) {
//       _timeTaken = (sw..stop()).elapsed;
//       return value;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Contact details: ${widget.contactId}')),
//       body: FutureBuilder<Contact?>(
//         future: _contactFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           final error = snapshot.error;
//           if (error != null) {
//             return Center(child: Text('Error: $error'));
//           }
//
//           final contact = snapshot.data;
//           if (contact == null) {
//             return const Center(child: Text('Contact not found'));
//           }
//
//           final contactJson = JsonEncoder.withIndent(
//             '  ',
//           ).convert(contact.toMap());
//           final convertToText = jsonDecode(contactJson);
//
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _ContactImage(contact: contact),
//                   const SizedBox(height: 16),
//                   const SizedBox(height: 16),
//                   Text(contactJson),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
