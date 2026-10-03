import 'package:flutter/material.dart';

class EmailDetailPage extends StatelessWidget {
  final String messageId;
  const EmailDetailPage({super.key, required this.messageId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Detail')),
      body: Center(child: Text('Message: $messageId')),
    );
  }
}
