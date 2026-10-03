import 'package:equatable/equatable.dart';
import 'package:gmailoo/features/categorization/domain/entities/mail_bucket.dart';
import '../../domain/entities/email.dart';

abstract class MailboxState extends Equatable {
  const MailboxState();
  @override
  List<Object?> get props => [];
}

class MailboxInitial extends MailboxState {}
class MailboxLoading extends MailboxState {}
class MailboxLoaded extends MailboxState {
  final List<Email> emails;
  final MailBucket selectedBucket;
  const MailboxLoaded({required this.emails, required this.selectedBucket});
  @override
  List<Object?> get props => [emails, selectedBucket];
}
class MailboxError extends MailboxState {
  final String message;
  const MailboxError(this.message);
  @override
  List<Object?> get props => [message];
}
