import 'package:equatable/equatable.dart';

class DraftEmail extends Equatable {
  final String id;
  final String to;
  final String? cc;
  final String? bcc;
  final String subject;
  final String body;
  final DateTime updatedAt;

  const DraftEmail({
    required this.id,
    required this.to,
    this.cc,
    this.bcc,
    required this.subject,
    required this.body,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, to, cc, bcc, subject, body, updatedAt];
}
