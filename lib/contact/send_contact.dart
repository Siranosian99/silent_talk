import 'package:fast_contacts/fast_contacts.dart';

void sendContacts(Contact contact){
  String contactName=contact.displayName;
  String contactNumber=contact.phones.toString();
  String message = '📞 Contact:\nName: $contactName\nPhone: $contactNumber';
}