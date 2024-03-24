import 'package:pharmbrew/data/_ip_api.dart';

Future<String?> getCountry() async {
  Map<String, dynamic> fetchedData = await fetchIPInfo();

  if (fetchedData.isNotEmpty) {
    return fetchedData['country'];
  } else {
    return null;
  }
}

Future<String?> getRegion() async {
  Map<String, dynamic> fetchedData = await fetchIPInfo();

  if (fetchedData.isNotEmpty) {
    return fetchedData['region'];
  } else {
    return null;
  }
}

Future<Map<String, dynamic>?> getLocation() async {
  Map<String, dynamic> fetchedData = await fetchIPInfo();

  if (fetchedData.isNotEmpty) {
    print(fetchedData['loc']);
    return {
      'lattitude': fetchedData['loc'].toString().split(',')[0],
      'longitude': fetchedData['loc'].toString().split(',')[1]
    };
  } else {
    return null;
  }
}

void main(List<String> args) {
  getLocation().then((value) => print(value));
}
