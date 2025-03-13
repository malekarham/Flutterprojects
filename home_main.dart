import 'package:flutter/material.dart';
import 'user_controller.dart';
import 'profile_screen.dart';
import 'dashboard_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.teal,
      scaffoldBackgroundColor: Colors.grey[100],
      appBarTheme: const AppBarTheme(
        color: Colors.teal,
        elevation: 4,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => const HomePage(),
      '/register': (context) => const RegisterPage(),
      '/profile': (context) => const ProfilePage(),
      '/dashboard': (context) => const DashboardPage(),
    },
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Home')),
    drawer: AppDrawer(),
    body: const Center(
      child: Text(
        'Welcome to User App!',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    ),
  );
}

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Drawer(
    child: Column(
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(color: Colors.teal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.account_circle, size: 80, color: Colors.white),
              SizedBox(height: 10),
              Text(
                'User App',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
        _buildDrawerItem(context, Icons.home, 'Home', '/'),
        _buildDrawerItem(
          context,
          Icons.app_registration,
          'Register',
          '/register',
        ),
        _buildDrawerItem(context, Icons.person, 'My Profile', '/profile'),
        _buildDrawerItem(context, Icons.dashboard, 'Dashboard', '/dashboard'),
      ],
    ),
  );

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) => ListTile(
    leading: Icon(icon, color: Colors.teal),
    title: Text(title, style: const TextStyle(fontSize: 16)),
    onTap: () => Navigator.pushReplacementNamed(context, route),
  );
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isActive = true;

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      await UserController.saveUser(
        _nameController.text,
        _emailController.text,
        _isActive ? 'Active' : 'Inactive',
      );
      Navigator.pushNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Register')),
    drawer: AppDrawer(),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person, color: Colors.teal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator:
                        (value) => value!.isEmpty ? 'Enter your name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email, color: Colors.teal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator:
                        (value) => value!.isEmpty ? 'Enter your email' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Status: '),
                      Radio(
                        value: true,
                        groupValue: _isActive,
                        onChanged:
                            (value) => setState(() => _isActive = value!),
                      ),
                      const Text('Active'),
                      Radio(
                        value: false,
                        groupValue: _isActive,
                        onChanged:
                            (value) => setState(() => _isActive = value!),
                      ),
                      const Text('Inactive'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
