import 'package:flutter/material.dart';

class OpenInGmailButton extends StatelessWidget {
  final String messageId;
  const OpenInGmailButton({super.key, required this.messageId});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: const Text('Open in Gmail'),
    );
  }
}
