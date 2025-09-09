import 'package:fast_contacts/fast_contacts.dart';

String contactDetails(Contact contact) {
  final firstName = contact.structuredName?.givenName ?? 'Unknown';
  final lastName = contact.structuredName?.familyName ?? 'Unknown';
  final phone =
      contact.phones.isNotEmpty == true
          ? contact.phones.first.number ?? 'No number'
          : 'No number';

  return '''
Name & LastName: $firstName $lastName

Phone Number: $phone
''';
}
