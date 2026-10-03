import 'package:flutter/material.dart';

class CycleProgressBanner extends StatelessWidget {
  final String cycleId;
  const CycleProgressBanner({super.key, required this.cycleId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text('Cycle: $cycleId'),
    );
  }
}
