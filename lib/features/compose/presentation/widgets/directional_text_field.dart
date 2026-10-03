import 'package:flutter/material.dart';

class DirectionalTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;

  const DirectionalTextField({super.key, required this.label, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }
}
