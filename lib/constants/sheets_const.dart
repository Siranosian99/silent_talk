class Sheets {
  // Private constructor
  Sheets._privateConstructor();

  // Single instance
  static final Sheets _instance = Sheets._privateConstructor();

  // Public accessor
  static Sheets get instance => _instance;

  final String photo="Photo";
  final String camera="Camera";
  final String location="Location";
  final String contact="Contact";
  final String document="Document";


}