import 'dart:convert' as convert;
import 'dart:io';

import 'package:distancelearning_mobile/utils/files.dart';
import 'package:encrypt/encrypt.dart';
import 'package:path_provider/path_provider.dart';

class EncryptDecrypt {
  static Future<String> encrypt(String filePath) async {
    //TODO: Encryption fails with large files, try breaking down the file into
    //chunks, encrypting them and merging them, then do the same thing when
    // decrypting the file.
    // Also consider compressing the file to reduce the size (NOT very Important)
    final appDocDir = await getApplicationDocumentsDirectory();
    final mainPath = await getMainDirPath();
    final relPathToFile = filePath.split(mainPath).last;
    final File inFile = File(filePath);

    final somePath = "${relPathToFile.split('.').first}_file";
    final String mPath = "${appDocDir.path}/$somePath";
    final Directory outDir = Directory(mPath);
    final bool dExists = await outDir.exists();
    if (!dExists) {
      await outDir.create();
    } else {
      return outDir.path;
    }
    final videoFileContents =
        await inFile.readAsString(encoding: convert.latin1);

    final v = (videoFileContents.length / 10).floor();
    for (var i = 0; i < videoFileContents.length; i = i + v) {
      final String outFilePath = '$mPath/$i.aes';

      final File outFile = File(outFilePath);

      final bool outFileExists = await outFile.exists();
      if (!outFileExists) {
        await outFile.create();
      } else {
        print("encrypted");
        return outFilePath;
      }

      final key = Key.fromUtf8("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      final iv = IV.fromLength(16);

      final encrypter = Encrypter(AES(key));

      List<int> x = convert.utf8.encode(videoFileContents.substring(
          i,
          (i + v) > videoFileContents.length
              ? videoFileContents.length
              : i + v));
      final encrypted = encrypter.encryptBytes(x, iv: iv);
      await outFile.writeAsBytes(encrypted.bytes, mode: FileMode.append);
    }

    print("DONE");

    return 'outFilePath';
  }

  Future<String> decryptFile(String filePath) async {
    final String outFileName = "${basename(filePath)}.mp4";
    //TODO: Consider holding the decrypted file in a temporaty file and delete
    // after it is played (probably delete it during the dispose)
    final String outFilePath =
        '${await getParentDirPath(filePath)}/$outFileName';
    final File outFile = File(outFilePath);
    final bool outFileExists = await outFile.exists();

    if (!outFileExists) {
      await outFile.create();
    }
    print("outfile created");
    final key = Key.fromUtf8("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));
    final fileDir = Directory(filePath);
    final someFiles = fileDir.listSync();
    for (var file in someFiles) {
      final videoFileContents = (file as File).readAsBytesSync();
      print("file read");

      final encryptedFile = Encrypted(videoFileContents);

      print("encrypter created");
      final decrypted = encrypter.decrypt(encryptedFile, iv: iv);

      print("decrypted");
      final decryptedBytes = convert.latin1.encode(decrypted);
      await outFile.writeAsBytes(decryptedBytes, mode: FileMode.append);
    }

    print("written to the file");
    return outFilePath;
  }
}
