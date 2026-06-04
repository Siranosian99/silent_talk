class MessageTypeChecker {
  /// Check if message is URL
  static bool isUrl(String text) {
    final uri = Uri.tryParse(text);
    return uri != null &&
        (uri.scheme == "http" ||
            uri.scheme == "https" ||
            uri.scheme == "maps" ||       // apple
            uri.scheme == "comgooglemaps" // google
        );
  }

  /// Check if message is Email
  static bool isEmail(String text) {
    return RegExp(r'^[\w\.\-]+@(gmail\.com|googlemail\.com)$').hasMatch(text);
  }

  /// Check if message is Phone number
  static bool isPhone(String text) {
    return RegExp(r'^\+?[0-9]{6,15}$').hasMatch(text);
  }

  /// Check if message is Map URL
  static bool isMapLink(String text) {
    return text.contains("maps.apple.com") ||
        text.contains("maps://") ||
        text.contains("comgooglemaps://") ||
        text.contains("www.google.com/maps") ||
        text.contains("goo.gl/maps");
  }

  /// Main check: return type
  static MessageType getType(String text) {
    if (isEmail(text)) return MessageType.email;
    if (isPhone(text)) return MessageType.phone;
    if (isMapLink(text)) return MessageType.map;
    if (isUrl(text)) return MessageType.url;
    return MessageType.text;
  }
}

enum MessageType { text, url, email, phone, map }
