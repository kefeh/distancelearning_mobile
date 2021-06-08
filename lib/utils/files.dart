import 'dart:io';

List<FileSystemEntity> getFilesAndFolders(String path) {
  List<FileSystemEntity> files = [];
  Directory dir = Directory(path);
  print(path);
  List<FileSystemEntity> tempFile = dir.listSync();
  for (FileSystemEntity file in tempFile) {
    if (!basename(file.path).startsWith(".")) {
      print(file.path);
      files.add(file);
    }
  }
  return files;
}

String basename(String path) {
  return path.split("/").last;
}
