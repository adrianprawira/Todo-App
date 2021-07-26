import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslimpedia_todo_flutter/BLoC/authentication/authentication_bloc.dart';
import 'package:muslimpedia_todo_flutter/ui/home.dart';
import 'package:muslimpedia_todo_flutter/widgets/login_widget.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (context) {
      return BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
        if (state is AuthenticationSuccess) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else if (state is AuthenticationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      }, buildWhen: (current, next) {
        if (next is AuthenticationSuccess) {
          return false;
        }
        return true;
      }, builder: (context, state) {
        if (state is AuthenticationInitial || state is AuthenticationFailure) {
          return LoginWidget();
        } else if (state is AuthenticationLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return Center(child: Text('Error'));
      }
      );
    }
    )
    );
  }
}
