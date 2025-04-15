import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() => runApp(const GradeApp());

class GradeApp extends StatelessWidget {
  const GradeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Colors.teal,
          secondary: Colors.tealAccent,
        ),
      ),
      home: const GradeHomePage(),
    );
  }
}

class GradeHomePage extends StatefulWidget {
  const GradeHomePage({super.key});

  @override
  State<GradeHomePage> createState() => _GradeHomePageState();
}

class _GradeHomePageState extends State<GradeHomePage> {
  final TextEditingController _userIdController = TextEditingController();
  List<dynamic> _grades = [];
  bool _loading = false;
  String _errorMessage = '';

  Future<void> _fetchGrades() async {
    final userId = _userIdController.text.trim();
    if (userId.isEmpty) {
      setState(() => _errorMessage = 'Please enter a User ID.');
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse('https://devtechtop.com/management/public/api/select_data?user_id=$userId'),
      ).timeout(const Duration(seconds: 10));

      final data = json.decode(response.body);
      setState(() {
        if (response.statusCode == 200) {
          _grades = data is List ? data : (data['data'] ?? []);
          if (_grades.isEmpty) _errorMessage = 'No grades found.';
        } else {
          _errorMessage = data['message'] ?? 'Failed to load grades.';
        }
      });
    } catch (e) {
      setState(() => _errorMessage = 'Request failed: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showAddGradeForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const AddGradeForm(),
    );
  }

  Widget _buildGradeCard(Map grade) {
    final double marks = double.tryParse(grade['marks'].toString()) ?? 0.0;
    final String gradeLetter = marks >= 90 ? 'A' : marks >= 80 ? 'B' : marks >= 70 ? 'C' : marks >= 60 ? 'D' : 'F';
    final double gpa = marks >= 90 ? 4.0 : marks >= 80 ? 3.0 : marks >= 70 ? 2.0 : marks >= 60 ? 1.0 : 0.0;

    return Card(
      color: Colors.teal.shade900.withOpacity(0.3),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal,
          child: Text(gradeLetter, style: const TextStyle(color: Colors.white)),
        ),
        title: Text(grade['course_name'] ?? 'Unknown'),
        subtitle: Text('Semester ${grade['semester_no']}, ${grade['credit_hours']} credit hrs'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Marks: ${grade['marks']}%', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('GPA: ${gpa.toStringAsFixed(1)}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Grades'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchGrades,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(
                labelText: 'Enter User ID',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _fetchGrades(),
            ),
            const SizedBox(height: 16),
            if (_loading)
              const CircularProgressIndicator()
            else if (_errorMessage.isNotEmpty)
              Text(_errorMessage, style: const TextStyle(color: Colors.redAccent))
            else if (_grades.isEmpty)
              const Text('No grades available.')
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _grades.length,
                  itemBuilder: (context, index) => _buildGradeCard(_grades[index]),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddGradeForm,
        icon: const Icon(Icons.add),
        label: const Text('Add Grade'),
      ),
    );
  }
}

class AddGradeForm extends StatefulWidget {
  const AddGradeForm({super.key});

  @override
  State<AddGradeForm> createState() => _AddGradeFormState();
}

class _AddGradeFormState extends State<AddGradeForm> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  String? _selectedCourse;
  final _semesterController = TextEditingController();
  final _creditController = TextEditingController();
  final _marksController = TextEditingController();
  List<Map<String, String>> _courses = [];
  List<Map<String, String>> _filteredCourses = [];
  bool _loadingCourses = false;
  String _coursesError = '';
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch courses initially with a default or empty user ID
    _fetchCourses();
    _searchController.addListener(_filterCourses);
  }

  Future<void> _fetchCourses() async {
    setState(() {
      _loadingCourses = true;
      _coursesError = '';
      _courses.clear(); // Clear previous courses
      _selectedCourse = null; // Reset selected course
    });
    final userId = _userIdController.text.trim();
    final uri = Uri.parse('https://bgnuerp.online/api/get_courses?user_id=$userId');

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _courses = data.map((course) => {
            'id': course['id'].toString(),
            'name': course['subject_name'].toString(),
          }).toList();
          _filteredCourses = List.from(_courses);
        });
      } else {
        setState(() {
          _coursesError = 'Failed to load courses.';
        });
      }
    } catch (e) {
      setState(() {
        _coursesError = 'Error loading courses: $e';
      });
    } finally {
      setState(() {
        _loadingCourses = false;
      });
    }
  }

  void _filterCourses() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCourses = _courses
          .where((course) => course['name']!.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> _submitGrade() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCourse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a course')),
      );
      return;
    }

    final uri = Uri.https('devtechtop.com', '/management/public/api/grades');

    try {
      final response = await http.post(
        uri,
        body: {
          'user_id': _userIdController.text,
          'course_name': _selectedCourse,
          'semester_no': _semesterController.text,
          'credit_hours': _creditController.text,
          'marks': _marksController.text,
        },
      ).timeout(const Duration(seconds: 10));
      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Grade submitted successfully')),
        );
        // Optionally, refresh the grade list in the home page
        if (context.mounted) {
          final homePageState = context.findAncestorStateOfType<_GradeHomePageState>();
          homePageState?._fetchGrades();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Submission failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(20)),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add Grade', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(labelText: 'User ID'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onChanged: (_) {
                  // Fetch courses again when User ID changes
                  _fetchCourses();
                },
              ),
              const SizedBox(height: 16),
              if (_loadingCourses)
                const CircularProgressIndicator()
              else if (_coursesError.isNotEmpty)
                Text(_coursesError, style: const TextStyle(color: Colors.redAccent))
              else if (_courses.isNotEmpty)
                Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: 'Search Course',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Course Name'),
                      value: _selectedCourse,
                      items: _filteredCourses.map((course) {
                        return DropdownMenuItem<String>(
                          value: course['name'],
                          child: Text(course['name']!),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCourse = newValue;
                        });
                      },
                      validator: (value) => value == null ? 'Please select a course' : null,
                    ),
                  ],
                )
              else
                const Text('No courses available for this User ID.'),
              TextFormField(
                controller: _semesterController,
                decoration: const InputDecoration(labelText: 'Semester'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _creditController,
                decoration: const InputDecoration(labelText: 'Credit Hours'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _marksController,
                decoration: const InputDecoration(labelText: 'Marks'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final val = double.tryParse(value ?? '');
                  if (val == null || val < 0 || val > 100) return 'Enter 0-100';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('Submit Grade'),
                onPressed: _submitGrade,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
