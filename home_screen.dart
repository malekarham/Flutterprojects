import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_service/firebase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController degreeController = TextEditingController();
  final FirebaseService firebaseService = FirebaseService();

  @override
  void dispose() {
    nameController.dispose();
    degreeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firestore CRUD App"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: degreeController,
              decoration: const InputDecoration(labelText: 'Degree'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitData,
              child: const Text("Submit"),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text("Submitted Users", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            _buildUserList(),
          ],
        ),
      ),
    );
  }

  Future<void> _submitData() async {
    final name = nameController.text.trim();
    final degree = degreeController.text.trim();

    if (name.isEmpty || degree.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      await firebaseService.add(name, degree);
      nameController.clear();
      degreeController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Widget _buildUserList() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: firebaseService.getUsersStream(), // Use service method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No data found."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(data['name'] ?? ''),
                subtitle: Text(data['degree'] ?? ''),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteUser(doc.id),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _deleteUser(String id) async {
    try {
      await firebaseService.delete(id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting: ${e.toString()}')),
      );
    }
  }
}