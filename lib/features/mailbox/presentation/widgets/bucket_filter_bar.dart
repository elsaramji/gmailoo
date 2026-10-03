import 'package:flutter/material.dart';

class BucketFilterBar extends StatelessWidget {
  const BucketFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Chip(label: Text('All')),
      ],
    );
  }
}
