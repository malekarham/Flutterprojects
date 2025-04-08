// home_screen.dart
import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'form_screen.dart';
import 'api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> formData = [];
  List<Map<String, dynamic>> apiData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadLocalData();
  }

  Future<void> _loadLocalData() async {
    setState(() => isLoading = true);
    try {
      formData = await DbHelper.fetchSubjectData();
      setState(() {});
    } catch (e) {
      _showError('Error loading local data: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadApiData() async {
    setState(() => isLoading = true);
    try {
      apiData = await ApiService.fetchData();
      setState(() {});
      _showSuccess('API data loaded successfully');
    } catch (e) {
      _showError('Error loading API data: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _eraseData() async {
    await DbHelper.deleteAllData();
    setState(() => formData = []);
    _showSuccess('All local data erased');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Subject Data')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0), // Removed 'const' here
              child: Column(
                children: [
                  // Action Buttons
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FormScreen()),
                        ).then((_) => _loadLocalData()),
                        child: Text('Add Subject'),
                      ),
                      ElevatedButton(
                        onPressed: _loadLocalData,
                        child: Text('Load Local Data'),
                      ),
                      ElevatedButton(
                        onPressed: _loadApiData,
                        child: Text('Load API Data'),
                      ),
                      ElevatedButton(
                        onPressed: _eraseData,
                        child: Text('Erase Local Data'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Data Display
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          TabBar(
                            tabs: [
                              Tab(text: 'Your Subjects (${formData.length})'),
                              Tab(text: 'API Data (${apiData.length})'),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                _buildDataList(formData),
                                _buildDataList(apiData),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDataList(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      return Center(child: Text('No data available'));
    }

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(item['subject']?.toString() ?? 'Unknown Subject'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Semester: ${item['semester'] ?? 'N/A'}'),
                Text('Marks: ${item['marks'] ?? 'N/A'}'),
                Text('Credits: ${item['creditHours'] ?? 'N/A'}'),
                Text('Grade: ${item['grade'] ?? 'N/A'}'),
              ],
            ),
            trailing: Text('${item['percentage']?.toStringAsFixed(1) ?? 'N/A'}%'),
          ),
        );
      },
    );
  }
}