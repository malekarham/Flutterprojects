import 'package:flutter/material.dart';
import 'flag_image_screen.dart';

class FlagTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text('Show Flag'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FlagImageScreen()),
          );
        },
      ),
    );
  }
}
