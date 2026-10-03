import 'package:flutter/material.dart';

class VipFolderTile extends StatelessWidget {
  final String senderName;
  final VoidCallback onTap;

  const VipFolderTile({super.key, required this.senderName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.star, color: Colors.amber),
      title: Text(senderName),
      onTap: onTap,
    );
  }
}
