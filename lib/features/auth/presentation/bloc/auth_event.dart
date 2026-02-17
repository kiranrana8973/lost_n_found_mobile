import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthRegisterEvent extends AuthEvent {
  final String fullName;
  final String email;
  final String username;
  final String password;
  final String? phoneNumber;
  final String? batchId;

  const AuthRegisterEvent({
    required this.fullName,
    required this.email,
    required this.username,
    required this.password,
    this.phoneNumber,
    this.batchId,
  });

  @override
  List<Object?> get props => [fullName, email, username, password, phoneNumber, batchId];
}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthGetCurrentUserEvent extends AuthEvent {
  const AuthGetCurrentUserEvent();
}

class AuthLogoutEvent extends AuthEvent {
  const AuthLogoutEvent();
}

class AuthClearErrorEvent extends AuthEvent {
  const AuthClearErrorEvent();
}
