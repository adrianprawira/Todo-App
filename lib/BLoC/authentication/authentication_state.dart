part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}


class AuthenticationFailure extends AuthenticationState {

  final String message;
  AuthenticationFailure({
    @required this.message,
  });

  @override
  List<Object> get props => [message];
}

class AuthenticationSuccess extends AuthenticationState {
   final AuthenticationDetail authenticationDetail;
  AuthenticationSuccess({
    @required this.authenticationDetail
  });

  List<Object> get props => [authenticationDetail];
}