import 'package:flutter/material.dart';

class QuietHoursTile extends StatelessWidget {
  const QuietHoursTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const SwitchListTile(value: false, onChanged: null, title: Text('Quiet Hours'));
  }
}
