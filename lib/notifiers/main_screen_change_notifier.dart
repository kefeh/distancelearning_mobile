import 'dart:io';

import 'package:distancelearning_mobile/utils/files.dart';
import 'package:flutter/material.dart';

class MainScreenChangeNotifier extends ChangeNotifier {
  late List<FileSystemEntity> _files = [];
  late Map<String, dynamic> _parent = {};
  late bool landscapeHeightTall = false;

  List<FileSystemEntity> get files => _files;
  Map<String, dynamic> get parent => _parent;

  Future<void> setFiles([String? dirPath]) async {
    _files = await getFilesAndFolders(dirPath);
    final String parentPath = dirPath ??
        await getParentDirPath(_files.isNotEmpty ? _files[0].path : null);
    _parent = {
      "dir": Directory(parentPath),
      "name": parentPath.split("/").last,
      "children": _files.length.toString()
    };
    notifyListeners();
  }

  void search(String searchTerm) {
    if (searchTerm.replaceAll(" ", "") == "") {
      setFiles(parent["dir"].path.toString());
    } else {
      _files = _files
          .where(
            (file) => basename(file.path).contains(
              searchTerm.replaceAll(" ", ""),
            ),
          )
          .toList();
    }

    notifyListeners();
  }
}
