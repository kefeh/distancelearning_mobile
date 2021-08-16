import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:distancelearning_mobile/utils/files.dart';
import 'package:encrypt/encrypt.dart';
import 'package:path_provider/path_provider.dart';

class EncryptDecrypt {
  static Future<String> encrypt(String filePath, {Worker? worker}) async {
    //TODO: Encryption fails with large files, try breaking down the file into
    //chunks, encrypting them and merging them, then do the same thing when
    // decrypting the file.
    // Also consider compressing the file to reduce the size (NOT very Important)
    final appDocDir = await getMainDirPath(forApp: true);

    final mainPath = await getMainDirPath();
    final relPathToFile = filePath.split(mainPath).last;
    final File inFile = File(filePath);

    final somePath = "${relPathToFile.split('.').first}_file";
    final String mPath = "$appDocDir/$somePath";
    final Directory outDir = Directory(mPath);
    final bool dExists = await outDir.exists();
    if (!dExists) {
      await outDir.create(recursive: true);
    } else {
      return outDir.path;
    }
    // final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
    // final arguments = [
    //   "-i",
    //   filePath,
    //   "-ss",
    //   "00:00:00",
    //   "-t",
    //   "00:03:30",
    //   "-c",
    //   "copy",
    //   "$mPath/x.mp4",
    // ];
    // _flutterFFmpeg
    //     .executeWithArguments(arguments)
    //     .then((rc) => print("FFmpeg process exited with rc $rc"));
    // print(filePath);
    worker == null
        ? await encryptFile(mPath, inFile: inFile)
        : await worker.encrypt({
            "filePath": mPath,
            "inFile": inFile,
          });

    return 'outFilePath';
  }

  static Future<String> encryptFile(String mPath, {File? inFile}) async {
    //TODO: Encryption fails with large files, try breaking down the file into
    //chunks, encrypting them and merging them, then do the same thing when
    // decrypting the file.
    // Also consider compressing the file to reduce the size (NOT very Important)
    final videoFileContents =
        await inFile!.readAsString(encoding: convert.latin1);
    final key = Key.fromUtf8("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    final iv = IV.fromLength(16);
    final chunkSize = videoFileContents.indexOf("mdat") + 4;

    final encrypter = Encrypter(AES(key));
    final x = convert.utf8.encode(videoFileContents.substring(0, chunkSize));
    final String outFilePath0 = '$mPath/0.aes';
    final String outFilePath1 = '$mPath/1.aes';

    final File outFile = File(outFilePath0);
    final File outFile2 = File(outFilePath1);

    final bool outFileExists = await outFile.exists();
    if (!outFileExists) {
      final encrypted = encrypter.encryptBytes(x, iv: iv);
      await outFile.create();
      await outFile2.create();
      await outFile2.writeAsBytes(
          convert.latin1.encode(videoFileContents.substring(chunkSize)));
      await outFile.writeAsBytes(encrypted.bytes);
    } else {
      return "somePath";
    }
    return "somePath";
  }

  static Future<String> decryptFile(String filePath) async {
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
    final key = Key.fromUtf8("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));
    final fileDir = Directory(filePath);
    final someFiles = fileDir.listSync();
    final List<Future<void>> futureThings = [];
    final zeroFile = someFiles
        .where((element) => (element as File).path.contains("0.aes"))
        .toList()[0];
    final firstFile = someFiles
        .where((element) => (element as File).path.contains("1.aes"))
        .toList()[0];

    final videoFileContents0 = (zeroFile as File).readAsBytesSync();
    await decrypting({
      'content': videoFileContents0,
      'file': outFile,
    });
    final lastSectionContent =
        await (firstFile as File).readAsString(encoding: convert.latin1);
    final decodedBytes = convert.latin1.encode(lastSectionContent);
    outFile.writeAsBytesSync(decodedBytes, mode: FileMode.append);

    // await Future.wait(futureThings);
    return outFilePath;
  }
}

Future<void> decrypting(Map vars) async {
  final Uint8List content = vars['content'] as Uint8List;
  final File outFile = vars['file'] as File;
  final key = Key.fromUtf8("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(key));
  final encryptedFile = Encrypted(content);

  final decrypted = encrypter.decrypt(encryptedFile, iv: iv);
  final decryptedBytes = convert.latin1.encode(decrypted);
  outFile.writeAsBytesSync(decryptedBytes, mode: FileMode.append);
}

class Worker {
  late SendPort _sendPort;
  late Isolate _isolate;
  final _isolateReady = Completer<void>();
  late Completer<String> _decryptedPath;
  late Completer<String> _encryptedPath;
  Worker() {
    init();
  }

  Future<String> decrypt(Map<String, dynamic> fileInfo) async {
    _sendPort.send(fileInfo);
    _decryptedPath = Completer<String>();
    final k = await _decryptedPath.future;
    return _decryptedPath.future;
  }

  Future<String> encrypt(Map<String, dynamic> fileInfo) async {
    _sendPort.send(fileInfo);
    _encryptedPath = Completer<String>();
    return _encryptedPath.future;
  }

  Future<void> init() async {
    final receivePort = ReceivePort();

    receivePort.listen(_handleMessage);

    _isolate = await Isolate.spawn(_isolateEntry, receivePort.sendPort);
  }

  Future<void> _handleMessage(message) async {
    if (message is SendPort) {
      _sendPort = message;
      _isolateReady.complete();
      return;
    }
    message == 'somePath'
        ? _encryptedPath.complete(message as String)
        : _decryptedPath.complete(message as String);
  }

  Future<void> get isReady => _isolateReady.future;

  void dispose() {
    _isolate.kill();
  }

  static void _isolateEntry(SendPort message) {
    late SendPort sendPort;
    final receivePort = ReceivePort();

    receivePort.listen((message) async {
      final pathString = message["type"] == 'decrypt'
          ? await EncryptDecrypt.decryptFile(message["filePath"] as String)
          : await EncryptDecrypt.encryptFile(
              message["filePath"] as String,
              inFile: message["inFile"] as File,
            );
      sendPort.send(pathString);
    });

    if (message is SendPort) {
      sendPort = message;
      sendPort.send(receivePort.sendPort);
      return;
    }
  }
}
