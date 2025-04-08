import 'package:flutter/material.dart';
import 'db_helper.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedSubject;
  String? _selectedSemester;
  String? _selectedCredit;
  final _marksController = TextEditingController();

  final List<String> subjects = [
    'Subject 1', 'Subject 2', 'Subject 3', 'Subject 4',
    'Subject 5', 'Subject 6', 'Subject 7', 'Subject 8'
  ];

  final List<String> semesters = List.generate(8, (index) => 'Semester ${index + 1}');
  final List<String> credits = ['1', '2', '4', '5', '6'];

  Future<void> _saveFormData() async {
    if (_formKey.currentState!.validate()) {
      final subject = _selectedSubject!;
      final semester = _selectedSemester!;
      final creditHours = int.parse(_selectedCredit!);
      final marks = int.parse(_marksController.text);

      // Calculate grade and percentage (simplified)
      String grade;
      double percentage;
      
      if (marks >= 85) {
        grade = 'A';
        percentage = 4.0;
      } else if (marks >= 75) {
        grade = 'B';
        percentage = 3.0;
      } else if (marks >= 65) {
        grade = 'C';
        percentage = 2.0;
      } else if (marks >= 50) {
        grade = 'D';
        percentage = 1.0;
      } else {
        grade = 'F';
        percentage = 0.0;
      }

      // Save form data to local storage (SQLite)
      await DbHelper.saveSubjectData(
        subject, 
        semester, 
        creditHours, 
        marks, 
        grade, 
        percentage
      );

      // Clear fields after saving
      _formKey.currentState!.reset();
      _marksController.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form data saved!'))
      );
    }
  }

  @override
  void dispose() {
    _marksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Subject Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Subject'),
                value: _selectedSubject,
                items: subjects.map((subject) {
                  return DropdownMenuItem(
                    value: subject,
                    child: Text(subject),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSubject = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a subject' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Semester'),
                value: _selectedSemester,
                items: semesters.map((semester) {
                  return DropdownMenuItem(
                    value: semester,
                    child: Text(semester),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSemester = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a semester' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Credit Hours'),
                value: _selectedCredit,
                items: credits.map((credit) {
                  return DropdownMenuItem(
                    value: credit,
                    child: Text(credit),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCredit = value;
                  });
                },
                validator: (value) => value == null ? 'Please select credit hours' : null,
              ),
              TextFormField(
                controller: _marksController,
                decoration: InputDecoration(labelText: 'Marks'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter marks';
                  }
                  final marks = int.tryParse(value);
                  if (marks == null || marks < 0 || marks > 100) {
                    return 'Enter valid marks (0-100)';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveFormData,
                child: Text('Save Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}