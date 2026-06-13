import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:silent_talk/features/user/service/user_account.dart';
import 'package:silent_talk/features/user/service/users_service.dart';

class NotificationProvider extends ChangeNotifier {
  var box = Hive.box('notification');
  final UsersService _usersService = UsersService();
  final UserAccountEdits _accountEdits = UserAccountEdits();
  bool isNotification = true;

  NotificationProvider() {
    init();
  }
  Future<void> init()async{
    loadIsNotification();
    await getFromFireStore();
  }

  void loadIsNotification() {
    isNotification = box.get('notification', defaultValue: true);
    notifyListeners();
  }

  Future<void> getFromFireStore() async {
    final data = await _usersService.getUserData();
    if (data == null) return;
    isNotification = data['isNotification'] ?? true;
    await  box.put('notification', isNotification);
    notifyListeners();
  }

  Future<void> isNotificationSwitch() async {
    isNotification = !isNotification;
    await  box.put('notification', isNotification);
    await _accountEdits.updateNotification(isNotification);
    notifyListeners();
  }

}
