import 'package:equatable/equatable.dart';

class AuthSession extends Equatable {
  final String userId;
  final String email;
  final String? displayName;
  final String? photoUrl;

  const AuthSession({
    required this.userId,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [userId, email, displayName, photoUrl];
}
