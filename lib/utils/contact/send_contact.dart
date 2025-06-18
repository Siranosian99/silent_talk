import 'package:fast_contacts/fast_contacts.dart';

String sendContacts(Contact contact){
  String contactName=contact.displayName;
  String contactNumber=contact.phones.toString();
  return '📞 Contact:\nName: $contactName\nPhone: $contactNumber';
}