import 'dart:io';
import 'package:distancelearning_mobile/screens/main_screen.dart';
import 'package:distancelearning_mobile/screens/splash.dart';
import 'package:flutter/material.dart';

typedef DirectoryCallback = void Function(String);
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: Splash.routeName,
      routes: {
        Splash.routeName: (context) => const Splash(),
        MainWidget.routeName: (context) => MainWidget(),
      },
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
          callback(dir.path);
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
                  (data != null) ? data!["name"].toString() : "",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "${(data != null) ? data!["children"] : 0} Folders",
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
