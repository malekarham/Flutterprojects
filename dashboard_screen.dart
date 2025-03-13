import 'package:flutter/material.dart';
import 'user_controller.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder(
        future: UserController.getDashboardUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users registered.'));
          }
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index].split(',');
              final statusColor =
                  user[2].toLowerCase() == 'active' ? Colors.green : Colors.red;
              return ListTile(
                title: Text(user[0]),
                subtitle: Text(user[1]),
                trailing: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
