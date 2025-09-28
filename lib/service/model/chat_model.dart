class ChatModel {
  String docId;
  String chatId;
  String senderId;
  String receiverId;
  String message;
  String messageTime;

  ChatModel({
    required this.docId,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.messageTime,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      docId: map['docId'],
      chatId: map['chatId'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      message: map['message'],
      messageTime: map['messageTime'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'docId':docId,
      'chatId': chatId,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'messageTime': messageTime,
    };
  }
}
