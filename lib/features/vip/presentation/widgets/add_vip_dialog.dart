import 'package:flutter/material.dart';

class AddVipDialog extends StatelessWidget {
  const AddVipDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add VIP Sender'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
      ],
    );
  }
}
