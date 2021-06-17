import 'package:flutter/material.dart';

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

enum AnAlignment { center, left, right }

class MainTexts extends StatelessWidget {
  final AnAlignment align;
  const MainTexts({
    Key? key,
    required this.align,
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
        crossAxisAlignment: align != AnAlignment.center
            ? (align == AnAlignment.left
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end)
            : CrossAxisAlignment.center,
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
