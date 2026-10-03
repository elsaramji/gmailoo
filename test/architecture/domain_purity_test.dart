import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Domain layer purity: no flutter, firebase, googleapis, or drift imports', () {
    final forbiddenPatterns = [
      RegExp(r'''import\s+['"]package:flutter/'''),
      RegExp(r'''import\s+['"]package:firebase_'''),
      RegExp(r'''import\s+['"]package:googleapis/'''),
      RegExp(r'''import\s+['"]package:drift/'''),
    ];

    final domainDirs = [
      Directory('lib/core/usecase'),
      Directory('lib/core/error'),
    ];

    final featuresDir = Directory('lib/features');
    if (featuresDir.existsSync()) {
      for (final feature in featuresDir.listSync()) {
        if (feature is Directory) {
          final domainDir = Directory('${feature.path}/domain');
          if (domainDir.existsSync()) {
            domainDirs.add(domainDir);
          }
        }
      }
    }

    final violations = <String>[];

    for (final dir in domainDirs) {
      if (!dir.existsSync()) continue;
      final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
      for (final file in files) {
        final lines = file.readAsLinesSync();
        for (int i = 0; i < lines.length; i++) {
          final line = lines[i];
          for (final pattern in forbiddenPatterns) {
            if (pattern.hasMatch(line)) {
              violations.add('${file.path}:${i + 1} -> $line');
            }
          }
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason: 'Domain layer must be pure Dart. Violations:\n${violations.join('\n')}',
    );
  });
}
