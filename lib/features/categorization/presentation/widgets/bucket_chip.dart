import 'package:flutter/material.dart';
import '../../domain/entities/mail_bucket.dart';

class BucketChip extends StatelessWidget {
  final MailBucket bucket;
  const BucketChip({super.key, required this.bucket});

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(bucket.name));
  }
}
