import 'package:flutter/material.dart';

class GmailooAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  const GmailooAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(title: title);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
