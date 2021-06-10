import 'dart:io';

import 'package:ext_storage/ext_storage.dart';

Future<List<FileSystemEntity>> getFilesAndFolders([String? path]) async {
  final String newPath = path ?? await getMainDirPath();
  final List<FileSystemEntity> files = [];
  final Directory dir = Directory(newPath);
  final List<FileSystemEntity> tempFile = dir.listSync();
  for (final FileSystemEntity file in tempFile) {
    if (!basename(file.path).startsWith(".")) {
      files.add(file);
    }
  }
  return files;
}

String basename(String path) {
  return path.split("/").last;
}

Future<String> getParentDirPath(String? path) async {
  if (path == null) {
    return getMainDirPath();
  } else {
    final List<String> splitPath = path.split("/");
    return splitPath.sublist(0, splitPath.length - 1).join("/");
  }
}

Future<String> getMainDirPath() {
  return ExtStorage.getExternalStoragePublicDirectory(
      ExtStorage.DIRECTORY_DOWNLOADS);
}