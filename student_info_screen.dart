import 'package:flutter/material.dart';

class StudentInfoScreen extends StatefulWidget {
  final Function(String subject, String teacher, int credit) onSubmit;

  StudentInfoScreen({required this.onSubmit});

  @override
  _StudentInfoScreenState createState() => _StudentInfoScreenState();
}

class _StudentInfoScreenState extends State<StudentInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _subjectController = TextEditingController();
  final _teacherController = TextEditingController();
  final _creditHoursController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _teacherController.dispose();
    _creditHoursController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String subject = _subjectController.text.trim();
      String teacher = _teacherController.text.trim();
      int credit = int.parse(_creditHoursController.text.trim());

      widget.onSubmit(subject, teacher, credit);

      // Clear fields after submit
      _subjectController.clear();
      _teacherController.clear();
      _creditHoursController.clear();

      // Optional: show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student record added successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Info'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _subjectController,
                    decoration: InputDecoration(labelText: 'Subject Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter subject name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _teacherController,
                    decoration: InputDecoration(labelText: 'Teacher Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter teacher name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _creditHoursController,
                    decoration: InputDecoration(labelText: 'Credit Hours'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty || int.tryParse(value) == null) {
                        return 'Please enter valid credit hours';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Add Student'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
