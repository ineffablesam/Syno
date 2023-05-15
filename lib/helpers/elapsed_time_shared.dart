import 'package:shared_preferences/shared_preferences.dart';

Future<void> _saveElapsedTime(int time) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('elapsedTime', time);
}
