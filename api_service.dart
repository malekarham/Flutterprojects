// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'https://bgnuerp.online/api/gradeapi';

  static Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) {
          return {
            'subject': item['subject_name'] ?? 'Unknown',
            'marks': item['marks'] ?? 0,
            'creditHours': item['credit_hours'] ?? 0,
            'semester': item['semester'] ?? 'N/A',
            'grade': item['grade'] ?? 'N/A',
            'percentage': item['percentage']?.toDouble() ?? 0.0,
          };
        }).toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}