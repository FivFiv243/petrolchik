part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {}

//auth events

class LoginEvent extends AppEvent {
  final email;
  final password;
  final cont;
  @override
  LoginEvent({required this.email, required this.password, required this.cont});
  List<Object?> get props => [email, password, cont];
}

class RegistrationEvent extends AppEvent {
  final email;
  final password;
  final cont;
  RegistrationEvent({required this.email, required this.password, required this.cont});
  @override
  List<Object?> get props => [email, password, cont];
}

class LogoutEvent extends AppEvent {
  @override
  List<Object?> get props => [];
}

class ToForgotPasswordEvent extends AppEvent {
  @override
  List<Object?> get props => [];
}

class ToAuthEvent extends AppEvent {
  @override
  List<Object?> get props => [];
}

class CheckEvent extends AppEvent {
  @override
  List<Object?> get props => [];
}

class ToSettingsEvent extends AppEvent {
  @override
  List<Object?> get props => [];
}
