import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LastSeenProvider extends ChangeNotifier {
  var box = Hive.box('lastSeen');
  bool isSeen = false;

  LastSeenProvider(){
    loadLastSeen();
  }

  void lastSeenSwitch() {
    isSeen = !isSeen;
    saveLastSeen();
    notifyListeners();
  }
  void saveLastSeen() {
    box.put('lastSeen', isSeen);
    notifyListeners();
  }
  void loadLastSeen() {
    isSeen= box.get('lastSeen', defaultValue: false);
    notifyListeners();
  }


}