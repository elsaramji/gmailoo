import 'package:flutter/material.dart';

class GmailooButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  const GmailooButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: child);
  }
}
