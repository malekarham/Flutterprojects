import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Database database;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> records = [];

  @override
  void initState() {
    super.initState();
    initDB();
  }

  Future<void> initDB() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE texts(id INTEGER PRIMARY KEY AUTOINCREMENT, content TEXT)',
        );
      },
    );
    await fetchRecords();
  }

  Future<void> fetchRecords() async {
    final List<Map<String, dynamic>> maps = await database.query('texts');
    setState(() {
      records = maps;
    });
  }

  Future<void> insertRecord(String text) async {
    await database.insert(
      'texts',
      {'content': text},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await fetchRecords();
  }

  @override
  void dispose() {
    _controller.dispose();
    database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite Text Storage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter text',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final text = _controller.text.trim();
                if (text.isNotEmpty) {
                  await insertRecord(text);
                  _controller.clear();
                }
              },
              child: const Text('Submit'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: records.isEmpty
                  ? const Center(child: Text('No records yet'))
                  : ListView.builder(
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Text(records[index]['id'].toString()),
                          title: Text(records[index]['content']),
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
