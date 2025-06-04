class Users {
  String userName;
  String name;
  String email;
  String password;
  String token;

  Users({
    required this.name,
    required this.userName,
    required this.email,
    required this.password,
    required this.token,
  });

  Map toMap(Users user){
    var data = Map<String, dynamic>();
    data['userName']=user.userName;
    data['name'] = user.name;
    data['email'] = user.email;
    data['password'] = user.password;
    data['token']=user.token;
    return data;

  }
}
