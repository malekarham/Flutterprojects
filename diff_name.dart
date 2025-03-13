import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: FS()));

class FS extends StatefulWidget {
  @override
  _FSState createState() => _FSState();
}

class _FSState extends State<FS> {
  int i = 0;
  List<String> n = ['Ali', 'Adil', 'Ahmad', 'Nauman'];

  @override
  Widget build(BuildContext c) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(n[i]),
          ElevatedButton(
            onPressed: () => setState(() => i = (i + 1) % 4),
            child: Text('Press me'),
          ),
        ],
      ),
    ),
  );
}
