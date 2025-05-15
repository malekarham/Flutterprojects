import 'package:flutter/material.dart';

class FlagImageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flag Screen'),
      ),
      body: Center(
        child: Image.asset('assets/images/pic.png'),
      ),
    );
  }
}
