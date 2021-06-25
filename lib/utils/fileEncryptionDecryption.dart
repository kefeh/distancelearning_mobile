import 'dart:convert';
import 'dart:io';

import 'package:distancelearning_mobile/utils/files.dart';
import 'package:encrypt/encrypt.dart';

class EncryptDecrypt {
  static Future<String> encrypt(String filePath) async {
    //TODO: Encryption fails with large files, try breaking down the file into
    //chunks, encrypting them and merging them, then do the same thing when
    // decrypting the file.
    // Also consider compressing the file to reduce the size (NOT very Important)
    final File inFile = File(filePath);
    final String outFileName = "${basename(filePath).split('.').first}enc.aes";
    final String outFilePath =
        '${await getParentDirPath(filePath)}/$outFileName';

    final File outFile = File(outFilePath);

    final bool outFileExists = await outFile.exists();

    if (!outFileExists) {
      await outFile.create();
    }
    final videoFileContents = inFile.readAsStringSync(encoding: latin1);

    final key = Key.fromUtf8("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(videoFileContents, iv: iv);
    await outFile.writeAsBytes(encrypted.bytes);

    // await inFile.delete();
    //TODO: Implement the delete of the file after it is encrypted
    return outFilePath;
  }

  Future<String> decryptFile(String filePath) async {
    final File inFile = File(filePath);
    final String outFileName = "${basename(filePath).split('.').first}.mp4";
    //TODO: Consider holding the decrypted file in a temporaty file and delete
    // after it is played (probably delete it during the dispose)
    final String outFilePath =
        '${await getParentDirPath(filePath)}/$outFileName';
    final File outFile = File(outFilePath);
    final bool outFileExists = await outFile.exists();

    if (!outFileExists) {
      await outFile.create();
    }

    final videoFileContents = inFile.readAsBytesSync();

    final key = Key.fromUtf8("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final encryptedFile = Encrypted(videoFileContents);
    final decrypted = encrypter.decrypt(encryptedFile, iv: iv);

    final decryptedBytes = latin1.encode(decrypted);
    await outFile.writeAsBytes(decryptedBytes);
    // await inFile.delete();
    return outFilePath;
  }
}
