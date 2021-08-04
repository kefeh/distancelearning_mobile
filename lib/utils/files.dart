import 'dart:io';

import 'package:distancelearning_mobile/utils/fileEncryptionDecryption.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thumbnails/thumbnails.dart';

Future<List<FileSystemEntity>> getFilesAndFolders([String? path]) async {
  final String newPath = path ?? await getMainDirPath();
  final String newOtherPath =
      path ?? (await getApplicationDocumentsDirectory()).path;
  final List<FileSystemEntity> files = [];
  final Directory dir = Directory(newPath);
  final Directory otherDir = Directory(newOtherPath);
  final List<FileSystemEntity> tempFile = dir.listSync();
  for (final FileSystemEntity file in tempFile) {
    if (!basename(file.path, removeExtension: false).startsWith(".")) {
      // print(file.path);
      if (file is File &&
          basename(file.path, removeExtension: false).split(".").last ==
              "mp4") {
        print(file.path);
        final String? thumbnail = await getAThumbnail(file.path);
        if (thumbnail == null) await createThumbnail(file.path);
        await EncryptDecrypt.encrypt(file.path);
      }
    }
  }

  final List<FileSystemEntity> realFile = otherDir.listSync();
  for (final FileSystemEntity afile in realFile) {
    print(afile.path);
    // afile.deleteSync(recursive: true);
    if (afile is File &&
        basename(afile.path, removeExtension: false).split(".").last == "aes") {
      files.add(afile);
    }
    if (afile is File &&
        basename(afile.path, removeExtension: false).split(".").last == "mp4") {
      files.add(afile);
    }
    if (afile is Directory) {
      files.add(afile);
    }
  }

  return files;
}

Future<List<FileSystemEntity>> getFilesAndFoldersONLY([String? path]) async {
  final String newPath = path ?? await getMainDirPath();
  final String newOtherPath =
      path ?? (await getApplicationDocumentsDirectory()).path;
  final List<FileSystemEntity> files = [];
  final Directory dir = Directory(newPath);
  final Directory otherDir = Directory(newOtherPath);
  final List<FileSystemEntity> realFile = otherDir.listSync();
  for (final FileSystemEntity afile in realFile) {
    print(afile.path);
    // afile.deleteSync(recursive: true);
    if (afile is File &&
        basename(afile.path, removeExtension: false).split(".").last == "aes") {
      files.add(afile);
    }
    if (afile is File &&
        basename(afile.path, removeExtension: false).split(".").last == "mp4") {
      files.add(afile);
    }
    if (afile is Directory) {
      files.add(afile);
    }
  }

  return files;
}

String basename(String path, {bool removeExtension = true}) {
  final String aBasename = path.split("/").last;
  if (aBasename.startsWith(".")) {
    return aBasename;
  }
  if (removeExtension) {
    List listBasename = aBasename.split(".");
    if (listBasename.length >= 2) {
      listBasename.removeLast();
    }
    listBasename = listBasename.join(".").split("_file");
    return listBasename[0] as String;
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

  List<FileSystemEntity>? thumbnailFile = appDocDir
      .listSync()
      .where((element) => element.path.split(".").last == "png")
      .toList();
  for (final file in thumbnailFile) {
    print(basename(file.path));
    print(basename(videoPathUrl));
    print(basename(file.path) == basename(videoPathUrl));
    print("mmmmmmmmmmmmmmmmmmmmmmm");
  }
  thumbnailFile = thumbnailFile
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
