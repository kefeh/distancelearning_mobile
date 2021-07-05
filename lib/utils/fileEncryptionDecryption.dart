import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:distancelearning_mobile/utils/files.dart';
import 'package:encrypt/encrypt.dart';
import 'package:path_provider/path_provider.dart';

Iterable<String> splitByLengthOf50Mb(String str) sync* {
  late String data;
  const int l50mb = 50 * 1000000;
  int lengthOf50Mb = 50 * 1000000;
  int initLength = 0;
  while (initLength < str.length) {
    if ((lengthOf50Mb > str.length) && (initLength < str.length)) {
      data = str.substring(initLength);
    } else {
      data = str.substring(initLength, lengthOf50Mb);
    }
    initLength = lengthOf50Mb;
    lengthOf50Mb = lengthOf50Mb + l50mb;
    print("yielding");
    print(initLength);
    yield data;
  }
}

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
    final String outFileRelPath = "${relPathToFile.split('.').first}.aes";
    final String outFilePath = '${appDocDir.path}/$outFileRelPath';

    final File outFile = File(outFilePath);

    final bool outFileExists = await outFile.exists();

    if (!outFileExists) {
      await outFile.create();
    } else {
      print("encrypted");
      return outFilePath;
    }
    final videoFileContents = await inFile.readAsString(encoding: latin1);

    final key = Key.fromUtf8("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    final iv = IV.fromLength(16);
    final byteBuilder = BytesBuilder();
    final encrypter = Encrypter(AES(key, padding: null));
    final Iterable<String> sequence = splitByLengthOf50Mb(videoFileContents);
    for (final String str in sequence) {
      await outFile.writeAsBytes(encrypter.encrypt(str, iv: iv).bytes,
          mode: FileMode.append);
      print(encrypter.encrypt(str, iv: iv).bytes);
      print("encrypter.encrypt(str, iv: iv).bytes");
    }
    print(videoFileContents);
    print("videoFileContents");

    return outFilePath;
  }

  Future<String> decryptFile(String filePath) async {
    print("decrypting files");
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

    final encrypter = Encrypter(AES(key, padding: null));

    final encryptedFile = Encrypted(videoFileContents);
    final decrypted = encrypter.decrypt(encryptedFile, iv: iv);
    print("Just finished decryptinh");

    final decryptedBytes = latin1.encode(decrypted);
    print("writing to the file");
    await outFile.writeAsBytes(decryptedBytes);
    return outFilePath;
  }
}
