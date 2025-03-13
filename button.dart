import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center horizontally
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(onPressed: () {}, child: const Text('Press me')),
          ],
        ),
      ),
    ),
  ),
);
