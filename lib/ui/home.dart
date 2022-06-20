import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

///BloC
import '../BLoC/authentication/authentication_bloc.dart';
import '../BLoC/database/database_bloc.dart';

/// Model
import '../model/authentication/authentication_detail.dart';

/// Utils
import '../utils/geo_location.dart';

///UI
import '../widgets/home_body.dart';
import 'addTask.dart';
import 'login.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (context, auth) {
            if (auth is AuthenticationFailure) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => LoginPage()));
            }
          },
          builder: (context, auth) {
            if (auth is AuthenticationInitial) {
              return CircularProgressIndicator();
            } else if (auth is AuthenticationSuccess) {
              GetLocation.determinePos();
              return buildHomeBody(context, auth.authenticationDetail);
            }
            return Text('Error');
          },
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        overlayColor: Colors.black,
        overlayOpacity: 0.2,
        buttonSize: 60,
        children: [
          // SpeedDialChild(
          //   child: Icon(Icons.location_pin, color: Colors.white),
          //   label: 'Check Location Services',
          //   backgroundColor: Colors.amber,
          //   onTap: GetLocation.determinePos,
          // ),
          SpeedDialChild(
            child: Icon(Icons.add, color: Colors.white),
            label: 'Add Todo List',
            backgroundColor: Colors.blue,
            onTap: () => Navigator.push(
              context,
              CupertinoPageRoute(builder: (_) => AddTaskScreen()),
            ),
          ),
          SpeedDialChild(
              child: Icon(Icons.logout, color: Colors.white),
              label: 'Logout',
              backgroundColor: Colors.red,
              onTap: () => BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationExited()))
        ],
      ),
    );
  }

  Widget buildHomeBody(BuildContext context, AuthenticationDetail authDetail) {
    return BlocBuilder<DatabaseBloc, DatabaseState>(
      builder: (context, state) {
        return state is DatabaseLoadedState
            ? Padding(
                padding: EdgeInsets.only(top: 40, bottom: 5),
                child: HomePageBody(
                  authDetail: authDetail,
                  taskList: state.taskList,
                ),
              )
            : Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }
}
