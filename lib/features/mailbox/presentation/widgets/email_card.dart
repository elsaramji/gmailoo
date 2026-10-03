import 'package:flutter/material.dart';

class EmailCard extends StatelessWidget {
  final String subject;
  final String from;
  final VoidCallback onTap;

  const EmailCard({
    super.key,
    required this.subject,
    required this.from,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(subject),
      subtitle: Text(from),
      onTap: onTap,
    );
  }
}
