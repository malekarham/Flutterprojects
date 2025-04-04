import 'package:flutter/material.dart';
import 'button.dart'; // Ensure this file exists and is correctly imported
import 'diff_name.dart'; // Ensure this file exists and is correctly imported
import 'name_button.dart'; // Ensure this file exists and is correctly imported
import 'name_2.dart'; // Ensure this file exists and is correctly imported

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.indigo[50],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedSection = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Section Switcher')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Text(
                'Sections',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(title: const Text('Home'), onTap: () => _switchSection(0)),
            ListTile(
              title: const Text('Result Card'),
              onTap: () => _switchSection(1),
            ),
            ListTile(
              title: const Text('Calculator'),
              onTap: () => _switchSection(2),
            ),
            ListTile(
              title: const Text('Button'),
              onTap: () => _switchSection(3),
            ),
            ListTile(
              title: const Text('Diff Name'),
              onTap: () => _switchSection(4),
            ),
            ListTile(
              title: const Text('Name Button'),
              onTap: () => _switchSection(5),
            ),
            ListTile(
              title: const Text('Name 2'),
              onTap: () => _switchSection(6),
            ),
          ],
        ),
      ),
      body: _buildSection(),
    );
  }

  void _switchSection(int index) {
    setState(() => _selectedSection = index);
    Navigator.pop(context); // Close the drawer after selection
  }

  Widget _buildSection() {
    switch (_selectedSection) {
      case 0:
        return const HomeScreen(); // Home Screen
      case 1:
        return const ResultCardSection();
      case 2:
        return CalculatorSection();
      case 3:
        return Scaffold(
          // From button.dart
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('Press me')),
              ],
            ),
          ),
        );
      case 4:
        return FS(); // From diff_name.dart
      case 5:
        return Scaffold(
          // From name_button.dart
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Muhammad Arham MAqsood'),
                ElevatedButton(onPressed: () {}, child: Text('Press me')),
              ],
            ),
          ),
        );
      case 6:
        return Center(
          // From name_2.dart
          child: Text(
            'Muhammad Arham Maqsood',
            textDirection: TextDirection.ltr,
          ),
        );
      default:
        return const HomeScreen(); // Default to Home Screen
    }
  }
}

/// Home Screen Widget
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Welcome to the App!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the drawer
            },
            child: const Text('Open Sidebar'),
          ),
        ],
      ),
    );
  }
}

/// Result Card Section (unchanged)
class ResultCardSection extends StatelessWidget {
  const ResultCardSection({super.key});

  final List<Map<String, String>> students = const [
    {
      "name": "Anas",
      "roll": "E45",
      "department": "Computer Science",
      "cgpa": "3.0",
      "email": "anasalikhan@example.com",
    },
    {
      "name": "Saeed Ahmad",
      "roll": "E14",
      "department": "Computer Science",
      "cgpa": "3.5",
      "email": "saeedahmad@example.com",
    },
    {
      "name": "Ayaan Akmal",
      "roll": "M22",
      "department": "Computer Science",
      "cgpa": "3.9",
      "email": "Ayaanali@example.com",
    },
    {
      "name": "Rana Azeem",
      "roll": "M05",
      "department": "Computer Science",
      "cgpa": "3.66",
      "email": "ranaazeem@example.com",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Roll No')),
          DataColumn(label: Text('Department')),
          DataColumn(label: Text('CGPA')),
          DataColumn(label: Text('Email')),
        ],
        rows:
            students
                .map(
                  (student) => DataRow(
                    cells: [
                      DataCell(Text(student['name']!)),
                      DataCell(Text(student['roll']!)),
                      DataCell(Text(student['department']!)),
                      DataCell(Text(student['cgpa']!)),
                      DataCell(Text(student['email']!)),
                    ],
                  ),
                )
                .toList(),
      ),
    );
  }
}

/// Calculator Section (unchanged)
class CalculatorSection extends StatefulWidget {
  @override
  _CalculatorSectionState createState() => _CalculatorSectionState();
}

class _CalculatorSectionState extends State<CalculatorSection> {
  double operand1 = 0, operand2 = 0;
  String operation = '';
  String result = '';

  void _calculateResult() {
    double res = 0;
    switch (operation) {
      case 'Add':
        res = operand1 + operand2;
        break;
      case 'Subtract':
        res = operand1 - operand2;
        break;
      case 'Multiply':
        res = operand1 * operand2;
        break;
      case 'Divide':
        if (operand2 != 0) {
          res = operand1 / operand2;
        } else {
          result = "Cannot divide by zero";
          return;
        }
        break;
      default:
        return;
    }
    setState(() {
      result = res.toString();
    });
  }

  Future<String?> _showInputDialog(BuildContext context, String title) async {
    String input = '';
    return showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: TextField(onChanged: (value) => input = value),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, input),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  final input = await _showInputDialog(
                    context,
                    'Enter Operand 1',
                  );
                  setState(() => operand1 = double.tryParse(input ?? '0') ?? 0);
                },
                child: const Text('Operand 1'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final input = await _showInputDialog(
                    context,
                    'Enter Operand 2',
                  );
                  setState(() => operand2 = double.tryParse(input ?? '0') ?? 0);
                },
                child: const Text('Operand 2'),
              ),
            ],
          ),
          Wrap(
            children: <Widget>[
              ElevatedButton(
                onPressed:
                    () => setState(() {
                      operation = 'Add';
                      _calculateResult();
                    }),
                child: const Text('Add'),
              ),
              ElevatedButton(
                onPressed:
                    () => setState(() {
                      operation = 'Subtract';
                      _calculateResult();
                    }),
                child: const Text('Subtract'),
              ),
              ElevatedButton(
                onPressed:
                    () => setState(() {
                      operation = 'Multiply';
                      _calculateResult();
                    }),
                child: const Text('Multiply'),
              ),
              ElevatedButton(
                onPressed:
                    () => setState(() {
                      operation = 'Divide';
                      _calculateResult();
                    }),
                child: const Text('Divide'),
              ),
              ElevatedButton(
                onPressed: () => setState(() => result = ""),
                child: const Text("Clear"),
              ),
            ],
          ),
          Text(
            'Result: $result',
            style: const TextStyle(fontSize: 18, color: Colors.indigo),
          ),
        ],
      ),
    );
  }
}
