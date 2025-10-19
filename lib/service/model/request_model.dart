class Request {
  final String requestSenderId;
  final String requestReceiverId;
  final String requestId;
  bool requestStatus;

  Request({
    required this.requestSenderId,
    required this.requestReceiverId,
    required this.requestId,
    this.requestStatus = false,
  });

  // Convert from Firestore (or JSON)
  factory Request.fromMap(Map<String, dynamic> data) {
    return Request(
      requestId:data['requestId'] ?? '' ,
      requestSenderId: data['requestSenderId'] ?? '',
      requestReceiverId: data['requestReceiverId'] ?? '',
      requestStatus: data['requestStatus'] ?? false,
    );
  }

  // Convert to Firestore (or JSON)
  Map<String, dynamic> toMap() {
    return {
      'requestId':requestId,
      'requestSenderId': requestSenderId,
      'requestReceiverId': requestReceiverId,
      'requestStatus': requestStatus,
    };
  }
}
