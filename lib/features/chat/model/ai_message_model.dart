class MessageModel {
  final String role;
  final String text;
  final DateTime createdAt;

  MessageModel({
    required this.role,
    required this.text,
    required this.createdAt,
  });
}
