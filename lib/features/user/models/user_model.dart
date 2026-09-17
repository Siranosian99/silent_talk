class Users {
  String id;
  String deviceId;
  String image;
  String userName;
  String name;
  String email;
  String password;
  String token;
  String lastSeen;
  bool isOnline;
  bool isNotification;

  Users({
    required this.id,
    required this.deviceId,
    required this.image,
    required this.name,
    required this.userName,
    required this.email,
    required this.password,
    required this.token,
    required this.lastSeen,
    required this.isOnline,
    required this.isNotification,
  });

  Map toMap(Users user) {
    var data = <String, dynamic>{};
    data['id'] = user.id;
    data['deviceId'] = user.deviceId;
    data['image'] = user.image;
    data['userName'] = user.userName;
    data['name'] = user.name;
    data['email'] = user.email;
    data['password'] = user.password;
    data['token'] = user.token;
    data['isOnline'] = user.isOnline;
    data['lastSeen'] = user.lastSeen;
    data['isNotification'] = user.isNotification;

    return data;
  }
}
