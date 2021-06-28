import 'dart:io';

import 'package:distancelearning_mobile/utils/fileEncryptionDecryption.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thumbnails/thumbnails.dart';

Future<List<FileSystemEntity>> getFilesAndFolders([String? path]) async {
  final String newPath = path ?? await getMainDirPath();
  final List<FileSystemEntity> files = [];
  final Directory dir = Directory(newPath);
  final List<FileSystemEntity> tempFile = dir.listSync();
  for (final FileSystemEntity file in tempFile) {
    if (!basename(file.path, removeExtension: false).startsWith(".")) {
      // if (file is File && basename(file.path).split(".").last == "mp4") {
      //   await createThumbnail(file.path);
      //   files.add(File(await EncryptDecrypt.encrypt(file.path)));
      // }
      final appDocDir = await getApplicationDocumentsDirectory();
      // var s = await createThumbnail(file.path);
      // print(s);

      if (file is File &&
          basename(file.path, removeExtension: false).split(".").last ==
              "mp4") {
        files.add(file);
      }
      if (file is Directory) {
        files.add(file);
      }
    }
  }
  return files;
}

String basename(String path, {bool removeExtension = true}) {
  //TODO: consider removing the extention from the basename
  final String aBasename = path.split("/").last;
  if (aBasename.startsWith(".")) {
    return aBasename;
  }
  if (removeExtension) {
    final List listBasename = aBasename.split(".");
    listBasename.removeLast();
    return listBasename.join(".");
  }
  return aBasename;
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

Future<String> getThumbnail(String videoPathUrl) async {
  final appDocDir = await getApplicationDocumentsDirectory();
  final folderPath = appDocDir.path;
  final String thumb = await Thumbnails.getThumbnail(
      thumbnailFolder: folderPath,
      videoFile: videoPathUrl,
      imageType: ThumbFormat.PNG,
      quality: 30);
  return thumb;
}

Future<String?> getAThumbnail(String videoPathUrl) async {
  final appDocDir = await getApplicationDocumentsDirectory();
  final List<FileSystemEntity> thumbnailFile = appDocDir
      .listSync()
      .where((element) => basename(element.path) == basename(videoPathUrl))
      .toList();
  return thumbnailFile.isNotEmpty ? thumbnailFile[0].path : null;
}

Future<String> createThumbnail(String videoPathUrl) async {
  final appDocDir = await getApplicationDocumentsDirectory();
  final folderPath = appDocDir.path;
  final String thumb = await Thumbnails.getThumbnail(
      thumbnailFolder: folderPath,
      videoFile: videoPathUrl,
      imageType: ThumbFormat.PNG,
      quality: 30);
  return thumb;
}
