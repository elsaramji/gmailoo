// ignore_for_file: avoid_print
import 'dart:io';

void main() {
  final dirs = [
    'lib/app/router',
    'lib/app/theme',
    'lib/app/di',
  ];

  for (final dir in dirs) {
    Directory(dir).createSync(recursive: true);
  }
  print('Directories verified.');
}
