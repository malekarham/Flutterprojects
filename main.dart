// main.dart
import 'package:flutter/material.dart';
import 'flag_task_screen.dart';
import 'flag_image_screen.dart';
import 'student_info_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static List<Map<String, dynamic>> studentRecords = [
    {'subject': 'Math', 'teacher': 'Mr. Ali', 'credit': 3},
    {'subject': 'Physics', 'teacher': 'Ms. Sara', 'credit': 4},
    {'subject': 'CS', 'teacher': 'Dr. Ahmad', 'credit': 3},
  ];

  void addStudentRecord(String subject, String teacher, int credit) {
    setState(() {
      studentRecords.add({'subject': subject, 'teacher': teacher, 'credit': credit});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Multi Screen App',
      home: HomeScreen(records: studentRecords),
      routes: {
        '/home': (_) => HomeScreen(records: studentRecords),
        '/flag': (_) => FlagTaskScreen(),
        '/studentInfo': (_) => StudentInfoScreen(onSubmit: addStudentRecord),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> records;

  HomeScreen({required this.records});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home'), actions: []),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Navigation Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () => Navigator.pushNamed(context, '/home'),
            ),
            ListTile(
              title: Text('Flag Task'),
              onTap: () => Navigator.pushNamed(context, '/flag'),
            ),
            ListTile(
              title: Text('Student Info'),
              onTap: () => Navigator.pushNamed(context, '/studentInfo'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/pic.png', height: 150),
            SizedBox(height: 16),
            Text('Enrolled Subjects:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = records[index];
                  return SubjectTile(
                    subject: record['subject'],
                    teacher: record['teacher'],
                    credit: record['credit'],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SubjectTile extends StatelessWidget {
  final String subject, teacher;
  final int credit;

  const SubjectTile({required this.subject, required this.teacher, required this.credit});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(subject),
        subtitle: Text('Teacher: $teacher\nCredits: $credit'),
      ),
    );
  }
}
