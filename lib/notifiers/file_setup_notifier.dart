import 'package:flutter/foundation.dart';

class FileSetupNotifier extends ChangeNotifier {
  int _numOfFiles = 0;
  int _numFilesMod = 0;

  int get numOfFiles => _numOfFiles;
  int get numFilesMod => _numFilesMod;

  bool get numAreEqual => _numFilesMod == _numOfFiles;
  set numOfFiles(int num) {
    _numOfFiles = num;
    notifyListeners();
  }

  set numFilesMod(int num) {
    _numFilesMod = num;
    notifyListeners();
  }
}
