import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Muhammad Arham Maqsood'),
            ElevatedButton(onPressed: () {}, child: Text('Press me')),
          ],
        ),
      ),
    ),
  ),
);
