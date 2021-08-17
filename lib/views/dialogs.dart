import 'package:fluttertoast/fluttertoast.dart';

Future<bool?> showToast(String value) {
  return Fluttertoast.showToast(
    msg: value,
    toastLength: Toast.LENGTH_LONG,
  );
}
