
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_contacts/properties/phone.dart';

Future<void> addContact(String name, String phone) async {
  if (await FlutterContacts.requestPermission()) {

  final contact = Contact()
    ..name.first = name
    ..phones = [Phone(phone)];

  await contact.insert();
  print("Contact added successfully!");
}}