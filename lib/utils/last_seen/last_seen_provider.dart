import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LastSeenProvider extends ChangeNotifier {
  var box = Hive.box('lastSeen');
  bool isSeen = false;

  LastSeenProvider(){
    loadlastSeen();
  }

  void lastSeenSwitch() {
    isSeen = !isSeen;
    savelastSeen();
    notifyListeners();
  }
  void savelastSeen() {
    box.put('lastSeen', isSeen);
    notifyListeners();
  }
  void loadlastSeen() {
    isSeen= box.get('lastSeen', defaultValue: false);
    notifyListeners();
  }


}