import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> records;

  HomeScreen({required this.records});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Navigation Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
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
            Text(
              'Enrolled Subjects:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
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
            ),
          ],
        ),
      ),
    );
  }
}

class SubjectTile extends StatelessWidget {
  final String subject;
  final String teacher;
  final int credit;

  const SubjectTile({
    required this.subject,
    required this.teacher,
    required this.credit,
  });

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
