import 'package:shared_preferences/shared_preferences.dart';

Future<String> getLoggedInId() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("loggedInId")??'';
}


// void main() async{
//   String loggedInId = await getLoggedInId();
//   print(loggedInId);
// }