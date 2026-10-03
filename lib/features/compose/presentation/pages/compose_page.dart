import 'package:flutter/material.dart';

class ComposePage extends StatelessWidget {
  const ComposePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compose')),
      body: const Center(child: Text('Email Compose View')),
    );
  }
}
