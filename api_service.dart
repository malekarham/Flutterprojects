import 'dart:convert';
import 'package:http/http.dart' as http;
import 'db_helper.dart';

class ApiService {
  static const String apiUrl = 'https://bgnuerp.online/api/gradeapi';

  static Future<void> fetchAndStoreData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        print("API Response: $jsonData");

        for (var item in jsonData) {
          await DBHelper.insertData({
            'studentname': item['studentname'],
            'obtainedmarks': item['obtainedmarks'],
          });
        }
      } else {
        print("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      print("API Error: $e");
    }
  }
}
