import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:distancelearning_mobile/utils/files.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
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
    final key = Key.fromUtf8("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));
    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

    final arguments = [
      "-i",
      filePath,
      "-ss",
      "00:00:00",
      "-t",
      "00:03:30",
      "-c",
      "copy",
      "$mPath/x.mp4",
    ];
    _flutterFFmpeg
        .executeWithArguments(arguments)
        .then((rc) => print("FFmpeg process exited with rc $rc"));

    try {
      final x = convert.utf8.encode(videoFileContents);
      final String outFilePath = '$mPath/0.aes';

      final File outFile = File(outFilePath);

      final bool outFileExists = await outFile.exists();
      if (!outFileExists) {
        await outFile.create();
      } else {
        print("encrypted");
        return outFilePath;
      }

      final encrypted = encrypter.encryptBytes(x, iv: iv);
      await outFile.writeAsBytes(encrypted.bytes, mode: FileMode.append);
    } catch (e) {
      print("crashed very badly");
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

        List<int> x = convert.utf8.encode(videoFileContents.substring(
            i,
            (i + v) > videoFileContents.length
                ? videoFileContents.length
                : i + v));
        final encrypted = encrypter.encryptBytes(x, iv: iv);
        await outFile.writeAsBytes(encrypted.bytes, mode: FileMode.append);
      }
    }

    print("DONE");

    return 'outFilePath';
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
    print("outfile created");
    final key = Key.fromUtf8("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));
    final fileDir = Directory(filePath);
    final someFiles = fileDir.listSync();
    final List<Future<void>> futureThings = [];

    for (final file in someFiles) {
      final videoFileContents = (file as File).readAsBytesSync();
      if (basename(file.path, removeExtension: false) == "x.mp4") continue;
      print("file read");

      futureThings.add(decrypting({
        'content': videoFileContents,
        'file': outFile,
      }));
    }
    await Future.wait(futureThings);

    print("written to the file");
    print("Done");
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

  print("encrypter created");
  final decrypted = encrypter.decrypt(encryptedFile, iv: iv);
  print("decrypted");
  final decryptedBytes = convert.latin1.encode(decrypted);
  outFile.writeAsBytesSync(decryptedBytes, mode: FileMode.append);
}

class Worker {
  late SendPort _sendPort;
  late Isolate _isolate;
  final _isolateReady = Completer<void>();
  late Completer<String> _decryptedPath;
  Worker() {
    init();
  }

  Future<String> decrypt(String filePath) async {
    _sendPort.send(filePath);
    _decryptedPath = Completer<String>();
    var k = await _decryptedPath.future;
    print(k);
    return _decryptedPath.future;
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
    print("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
    print(message);
    print("oooooooooooooooooooooooooooooooooooo::=>$message");
    _decryptedPath.complete(message as String);
  }

  Future<void> get isReady => _isolateReady.future;

  void dispose() {
    _isolate.kill();
  }

  static void _isolateEntry(SendPort message) {
    late SendPort sendPort;
    final receivePort = ReceivePort();

    receivePort.listen((message) async {
      final pathString = await EncryptDecrypt.decryptFile(message as String);
      print(
          "final pathString = EncryptDecrypt.decryptFile(message as String);");
      print(pathString);
      sendPort.send(pathString);
    });

    if (message is SendPort) {
      sendPort = message;
      sendPort.send(receivePort.sendPort);
      return;
    }
  }
}
