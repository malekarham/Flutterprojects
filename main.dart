import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(SubjectMarksApp());

class SubjectMarksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SubjectMarksScreen(),
    );
  }
}

class SubjectMarksScreen extends StatefulWidget {
  @override
  _SubjectMarksScreenState createState() => _SubjectMarksScreenState();
}

class _SubjectMarksScreenState extends State<SubjectMarksScreen> {
  final List<String> subjects = [
    'E-Commerce',
    'Numerical Computing',
    'Professional Practice',
    'Operating System',
    'Theory of Automata',
    'Data Structure and Algorithm',
    'App Development'
  ];

  String? selectedSubject;
  TextEditingController marksController = TextEditingController();
  List<Map<String, dynamic>> subjectMarks = [];
  int totalMarks = 0;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'subject_marks.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute('CREATE TABLE marks(id INTEGER PRIMARY KEY, subject TEXT, marks INTEGER)');
      },
      version: 1,
    );
  }

  Future<void> _addSubjectMarks() async {
    final db = await _initDatabase();
    int marks = int.tryParse(marksController.text) ?? 0;
    if (selectedSubject != null && marks >= 0 && marks <= 100) {
      await db.insert('marks', {'subject': selectedSubject, 'marks': marks});
      marksController.clear();
      _loadSubjectMarks();
    }
  }

  Future<void> _removeAllRecords() async {
    final db = await _initDatabase();
    await db.delete('marks');
    _loadSubjectMarks();
  }

  Future<void> _loadSubjectMarks() async {
    final db = await _initDatabase();
    final data = await db.query('marks');
    setState(() {
      subjectMarks = data;
      totalMarks = subjectMarks.fold(0, (sum, item) => sum + (item['marks'] as int));
    });
  }

  String _calculateGrade(int marks) {
    if (marks >= 85) return 'A';
    if (marks >= 65) return 'B';
    if (marks >= 51) return 'C';
    return 'F';
  }

  double _calculateGPA(int marks) {
    if (marks >= 80) return 4.0;
    if (marks == 79) return 3.94;
    if (marks == 78) return 3.87;
    if (marks == 77) return 3.80;
    if (marks == 76) return 3.74;
    if (marks == 75) return 3.67;
    if (marks == 74) return 3.60;
    if (marks == 73) return 3.54;
    if (marks == 72) return 3.47;
    if (marks == 71) return 3.40;
    if (marks == 70) return 3.34;
    if (marks == 69) return 3.27;
    if (marks == 68) return 3.20;
    if (marks == 67) return 3.14;
    if (marks == 66) return 3.07;
    if (marks == 65) return 3.00;
    if (marks >= 51) return 2.00 + (marks - 50) * 0.06;
    if (marks == 50) return 2.00;
    return 1.00;
  }

  @override
  Widget build(BuildContext context) {
    double totalGPA = subjectMarks.isNotEmpty
        ? subjectMarks.fold(0.0, (sum, item) => sum + _calculateGPA(item['marks'] as int)) / subjectMarks.length
        : 0.0;
    double totalPercentage = subjectMarks.isNotEmpty ? (totalMarks / (subjectMarks.length * 100)) * 100 : 0.0;

    return Scaffold(
      appBar: AppBar(title: Text('Subject Marks')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedSubject,
              hint: Text('Select Subject'),
              onChanged: (value) {
                setState(() => selectedSubject = value);
              },
              items: subjects.map((subject) {
                return DropdownMenuItem(
                  value: subject,
                  child: Text(subject),
                );
              }).toList(),
            ),
            TextField(
              controller: marksController,
              decoration: InputDecoration(labelText: 'Enter Marks (0-100)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addSubjectMarks,
              child: Text('Submit'),
            ),
            ElevatedButton(
              onPressed: _removeAllRecords,
              child: Text('Remove All Records'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(columns: [
                  DataColumn(label: Text('Subject')),
                  DataColumn(label: Text('Marks')),
                  DataColumn(label: Text('Grade')),
                  DataColumn(label: Text('Percentage')),
                  DataColumn(label: Text('GPA')),
                ], rows: subjectMarks.map((item) {
                  final marks = item['marks'] as int;
                  return DataRow(cells: [
                    DataCell(Text(item['subject'])),
                    DataCell(Text('$marks')),
                    DataCell(Text(_calculateGrade(marks))),
                    DataCell(Text('${(marks / 100 * 100).toStringAsFixed(2)}%')),
                    DataCell(Text(_calculateGPA(marks).toStringAsFixed(2))),
                  ]);
                }).toList()),
              ),
            ),
            Text('Total Marks: $totalMarks / ${subjectMarks.length * 100}'),
            Text('Total Percentage: ${totalPercentage.toStringAsFixed(2)}%'),
            Text('Total GPA: ${totalGPA.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
