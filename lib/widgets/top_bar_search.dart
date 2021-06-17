import 'package:distancelearning_mobile/notifiers/main_screen_change_notifier.dart';
import 'package:distancelearning_mobile/widgets/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopBarWithSearch extends StatelessWidget {
  const TopBarWithSearch({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final data = context.watch<MainScreenChangeNotifier>().parent;
    return BoxWithShadow(
      height: height,
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 16.0,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data["name"].toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "${(data["children"] != null) ? data["children"] : 0} Folders",
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
