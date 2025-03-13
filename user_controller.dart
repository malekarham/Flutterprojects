import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  static Future<void> saveUser(String name, String email, String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('profile_user', [name, email, status]);

    final users = prefs.getStringList('dashboard_users') ?? [];
    users.add('$name,$email,$status');
    await prefs.setStringList('dashboard_users', users);
  }

  static Future<List<String>> getProfileUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('profile_user') ?? [];
  }

  static Future<List<String>> getDashboardUsers() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('dashboard_users') ?? [];
  }
}
