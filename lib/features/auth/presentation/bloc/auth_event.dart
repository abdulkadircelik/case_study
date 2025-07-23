import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../domain/models/login_request_model.dart';
import '../../domain/models/register_request_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final LoginRequestModel request;

  const LoginRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class RegisterRequested extends AuthEvent {
  final RegisterRequestModel request;

  const RegisterRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class UploadPhotoRequested extends AuthEvent {
  final File file;

  const UploadPhotoRequested(this.file);

  @override
  List<Object?> get props => [file];
}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}
