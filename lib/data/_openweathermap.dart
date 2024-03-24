import 'dart:convert';

import 'package:pharmbrew/domain/_get_location.dart'; // Assuming this import is correct and necessary.
import 'package:http/http.dart' as http;

Future<String?> getWeather() async {
  try {
    final Map<String, dynamic>? location = await getLocation();
    if (location == null) return null; // Handle case where location is null

    final String lat = location['lattitude'].toString();
    final String lon = location['longitude'].toString();
    const String apiKey =
        "108e658ece27b123c22273339290aec2"; // Replace with your actual API key
    final url =
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey";

    final response = await http.get(Uri.parse(url));
    // Print response body for debugging
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      Map<String, dynamic> main = data['main']; // Print main for debugging
      double temp = main['temp'] - 273.15;
      return temp
          .toStringAsFixed(2); // Return temperature rounded to 2 decimal places
    } else {
      return null;
    }
  } catch (e) {
    // print("Error: $e"); // Print error for debugging
    return null; // Return null in case of any error
  }
}
