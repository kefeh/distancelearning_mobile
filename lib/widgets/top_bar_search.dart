import 'package:distancelearning_mobile/notifiers/main_screen_change_notifier.dart';
import 'package:distancelearning_mobile/widgets/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopBarWithSearch extends StatelessWidget {
  const TopBarWithSearch({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    final data = context.watch<MainScreenChangeNotifier>().parent;
    return BoxWithShadow(
      width: width,
      child: Padding(
        padding: context.read<MainScreenChangeNotifier>().landscapeHeightTall
            ? const EdgeInsets.only(
                bottom: 8.0,
                left: 16.0,
                right: 16.0,
                top: 4.0,
              )
            : const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (context.read<MainScreenChangeNotifier>().largeScreen &&
                    context
                        .read<MainScreenChangeNotifier>()
                        .landscapeHeightTall)
                  NavCrum(data: data)
                else
                  Text(
                    data["name"].toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                const SizedBox(
                  width: 50,
                ),
                Text(
                  "${(data["children"] != null) ? data["children"] : 0} Items",
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

class NavCrum extends StatefulWidget {
  const NavCrum({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;

  @override
  _NavCrumState createState() => _NavCrumState();
}

class _NavCrumState extends State<NavCrum> {
  List listOfParents = [];
  final ScrollController _controller = ScrollController();

  void _scrollToEnd() {
    if (_controller.hasClients) {
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
      print(_controller.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      final Map<int, dynamic> listParent =
          context.read<MainScreenChangeNotifier>().parentListMap;
      if ((listParent.length - 1) == listOfParents.length) {
        listOfParents.add(listParent[listParent.length - 1]);
      } else {
        listOfParents = listOfParents.sublist(0, listParent.length);
      }
    });
    _scrollToEnd();
    return Expanded(
      child: SizedBox(
        height: 40,
        child: ListView.builder(
            controller: _controller,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: listOfParents.length,
            itemBuilder: (BuildContext context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (index >= 0) {
                      listOfParents = listOfParents.sublist(0, index + 1);
                      context
                          .read<MainScreenChangeNotifier>()
                          .parentListMap
                          .removeWhere((key, value) => key >= index);
                      context.read<MainScreenChangeNotifier>().setFiles(
                          listOfParents[index]["dir"].path.toString());
                    }
                  });
                },
                child: Row(
                  children: [
                    if (index > 0)
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 6,
                        ),
                        child: Icon(
                          Icons.navigate_next_rounded,
                          size: 40,
                          color: Colors.black54,
                        ),
                      )
                    else
                      Container(),
                    Text(
                      listOfParents[index]["name"].toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

class TrippleDots extends StatelessWidget {
  const TrippleDots({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(1),
            child: Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(1),
            child: Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(1),
            child: Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
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
            onChanged: context.read<MainScreenChangeNotifier>().search,
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
