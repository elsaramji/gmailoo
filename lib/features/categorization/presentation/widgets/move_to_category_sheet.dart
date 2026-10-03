import 'package:flutter/material.dart';
import '../../domain/entities/mail_bucket.dart';

class MoveToCategorySheet extends StatelessWidget {
  final void Function(MailBucket bucket) onSelect;
  const MoveToCategorySheet({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: MailBucket.values.map((b) => ListTile(
        title: Text(b.name),
        onTap: () => onSelect(b),
      )).toList(),
    );
  }
}
