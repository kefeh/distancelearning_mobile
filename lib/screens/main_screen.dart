import 'dart:io';

import 'package:distancelearning_mobile/main.dart';
import 'package:distancelearning_mobile/utils/files.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MainWidget extends StatefulWidget {
  static const routeName = 'home';
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  String? directory;
  Map<String, dynamic>? parent;
  List<FileSystemEntity> file = [];
  bool shouldPop = true;
  @override
  void initState() {
    super.initState();
    _listofFiles();
  }

  // Make New Function
  void _listofFiles() async {
    PermissionStatus permission = await Permission.storage.status;
    if (permission.isGranted) {
      print("granted");
      directory = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_PICTURES);

      setFileAndParent(directory!);
    } else {
      print("not granted");
      PermissionStatus status = await Permission.storage.request();
      if (status.isGranted) {
        print("granted");
        directory = await ExtStorage.getExternalStoragePublicDirectory(
            ExtStorage.DIRECTORY_DOWNLOADS);

        setFileAndParent(directory!);
      } else {
        print('Please Grant Storage Permissions');
      }
    }
  }

  void setFileAndParent(String dirPath) {
    setState(
      () {
        file = getFilesAndFolders(
            dirPath); //use your folder name insted of resume.
        parent = {
          "dir": Directory(dirPath),
          "name": dirPath.split("/").last,
          "children": file.length.toString()
        };
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final List<ListFIleItem> listItems = file
        .map((element) => ListFIleItem(
              height: height,
              name: element.path.split("/").last,
              dir: Directory(element.path),
              callback: setFileAndParent,
            ))
        .toList();
    return WillPopScope(
        onWillPop: () async {
          return shouldPop;
        },
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(244, 249, 240, 1),
          resizeToAvoidBottomInset: false,
          body: PageView(
            children: [
              Stack(
                children: [
                  Container(
                    color: const Color(0xff468908),
                    width: double.infinity,
                    height: height / 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MainTexts(),
                        Flag(width: width, height: height)
                      ],
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      height: ((2 * height) / 3) + 15,
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              TopBarWithSearch(
                                height: height,
                                width: width,
                                data: parent,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: listItems.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return listItems[index];
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
