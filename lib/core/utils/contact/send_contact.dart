import 'package:fast_contacts/fast_contacts.dart';

String contactDetails(Contact contact, {bool nameOnly = false, bool phoneOnly = false}) {
  final firstName = contact.structuredName?.givenName ?? 'Unknown';
  final lastName = contact.structuredName?.familyName ?? 'Unknown';
  final phone = contact.phones.isNotEmpty
      ? contact.phones.first.number ?? 'No number'
      : 'No number';

  if (nameOnly) return "$firstName $lastName";
  if (phoneOnly) return phone;

  return '''
Name: $firstName $lastName

Phone: $phone
''';

}
String? extractName(String input) {
  final match = RegExp(r"Name:\s*(.+)").firstMatch(input);
  return match?.group(1)?.trim();
}

String? extractPhone(String input) {
  final match = RegExp(r"Phone:\s*(.+)").firstMatch(input);
  return match?.group(1)?.trim();
}

