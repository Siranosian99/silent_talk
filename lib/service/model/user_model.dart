class Users {
  String id;
  String image;
  String userName;
  String name;
  String email;
  String password;
  String token;
  bool isOnline;

  Users({
    required this.id,
    required this.image,
    required this.name,
    required this.userName,
    required this.email,
    required this.password,
    required this.token,
    required this.isOnline,
  });

  Map toMap(Users user){
    var data = Map<String, dynamic>();
    data['id']=user.id;
    data['image']=user.image;
    data['userName']=user.userName;
    data['name'] = user.name;
    data['email'] = user.email;
    data['password'] = user.password;
    data['token']=user.token;
    data['isOnline']=user.isOnline;
    return data;

  }
}
