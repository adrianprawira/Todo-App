import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../BLoC/authentication/authentication_bloc.dart';

class GoogleLoginButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.all(4),
      child: OutlinedButton.icon(
        icon: FaIcon(FontAwesomeIcons.google, color: Colors.deepOrange),
        label: Text(
          'Sign In with Google',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        style: OutlinedButton.styleFrom(
          shape: StadiumBorder(side: BorderSide(color: Colors.black)),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        onPressed: () => BlocProvider.of<AuthenticationBloc>(context)
            .add(AuthenticationGoogleStarted()),
      ));
}
