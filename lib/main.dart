import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

typedef DirectoryCallback = void Function(Directory);
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MainWidget(),
    );
  }
}

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  String? directory;
  Map<String, dynamic>? parent;
  List<FileSystemEntity> file = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listofFiles();
  }

  // Make New Function
  void _listofFiles() async {
    var permission = await Permission.mediaLibrary.request();
    if (permission.isGranted) {
      print("granted");
      directory = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS);

      setFileAndParent(Directory(directory!));
    } else {
      print("not granted");
    }
  }

  void setFileAndParent(Directory dir) {
    print(dir);
    final someFile = dir.listSync(followLinks: false).toList();
    setState(
      () {
        file = someFile; //use your folder name insted of resume.
        parent = {
          "dir": dir,
          "name": dir.path.split("/").last,
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
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 249, 240, 100),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            color: const Color(0xff468908),
            width: double.infinity,
            height: height / 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [const MainTexts(), Flag(width: width, height: height)],
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
                          itemBuilder: (BuildContext context, int index) {
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
    );
  }
}

class ListFIleItem extends StatelessWidget {
  const ListFIleItem({
    Key? key,
    required this.height,
    required this.name,
    required this.dir,
    required this.callback,
  }) : super(key: key);

  final double height;
  final String name;
  final Directory dir;
  final DirectoryCallback callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 16.0,
      ),
      child: GestureDetector(
        onTap: () {
          callback(dir);
        },
        child: BoxWithShadow(
          width: double.infinity,
          height: height / 10,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.folder_rounded,
                        size: 45,
                        color: Color.fromRGBO(107, 123, 250, 0.7),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Text(
                        name,
                      ),
                    ],
                  ),
                ),
                const Text(
                  "10 items",
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BoxWithShadow extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;

  const BoxWithShadow(
      {Key? key,
      required this.height,
      required this.width,
      required this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(70, 137, 8, 0.08),
            blurRadius: 20,
            offset: Offset(0, 10), // changes position of shadow
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: child,
    );
  }
}

class TopBarWithSearch extends StatelessWidget {
  const TopBarWithSearch({
    Key? key,
    required this.height,
    required this.width,
    required this.data,
  }) : super(key: key);

  final double height;
  final double width;
  final Map<String, dynamic>? data;

  @override
  Widget build(BuildContext context) {
    return BoxWithShadow(
      height: height / 6,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data!["name"]?.toString() ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "${data!["children"] ?? 0} Folders",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                )
              ],
            ),
            SearchForm(width: width)
          ],
        ),
      ),
    );
  }
}

class SearchForm extends StatelessWidget {
  const SearchForm({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Container(
          width: (2 * width / 3) + 100,
          color: const Color.fromRGBO(93, 206, 4, 0.1),
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              hintText: "Search",
              hintStyle: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.5),
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Color.fromRGBO(0, 0, 0, 0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainTexts extends StatelessWidget {
  const MainTexts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        bottom: 20.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Minesec",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            "Distance Learning",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(255, 255, 255, 50),
            ),
          ),
        ],
      ),
    );
  }
}

class Flag extends StatelessWidget {
  const Flag({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (width / 3) + 45,
      height: (height / 3) - 20,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                color: Color.fromRGBO(93, 206, 4, 20),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  width: double.infinity,
                  color: const Color.fromRGBO(232, 70, 65, 80),
                ),
                const Icon(
                  Icons.star,
                  size: 30,
                  color: Color.fromRGBO(236, 223, 0, 80),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(236, 223, 0, 80),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
