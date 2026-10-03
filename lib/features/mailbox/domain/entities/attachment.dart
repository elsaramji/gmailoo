import 'package:equatable/equatable.dart';

class Attachment extends Equatable {
  final String id;
  final String filename;
  final String mimeType;
  final int sizeBytes;

  const Attachment({
    required this.id,
    required this.filename,
    required this.mimeType,
    required this.sizeBytes,
  });

  @override
  List<Object?> get props => [id, filename, mimeType, sizeBytes];
}
