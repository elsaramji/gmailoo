import 'package:flutter/material.dart';

class GmailooApp extends StatelessWidget {
  const GmailooApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Gmailoo',
      home: Scaffold(
        body: Center(
          child: Text('Gmailoo Initialized'),
        ),
      ),
    );
  }
}
