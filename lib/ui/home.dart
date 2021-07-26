import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///BloC
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslimpedia_todo_flutter/BLoC/authentication/authentication_bloc.dart';
import 'package:muslimpedia_todo_flutter/BLoC/database/database_bloc.dart';

///UI
import 'package:muslimpedia_todo_flutter/ui/addTask.dart';
import 'package:muslimpedia_todo_flutter/ui/login.dart';
import 'package:muslimpedia_todo_flutter/utils/geo_location.dart';
import 'package:muslimpedia_todo_flutter/widgets/home_body.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          overlayColor: Colors.black,
          overlayOpacity: 0.2,
          buttonSize: 60,
          children: [
            SpeedDialChild(
                child: Icon(
                  Icons.location_pin,
                  color: Colors.white,
                ),
                label: 'Check Location Services',
                backgroundColor: Colors.amber,
                onTap: () => GetLocation.determinePos(),
                onLongPress: () => GetLocation.determinePos()),
            SpeedDialChild(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: 'Add Todo List',
                backgroundColor: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<DatabaseBloc>(context),
                        child: AddTaskScreen(),
                      ),
                    ),
                  );
                },
                onLongPress: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<DatabaseBloc>(context),
                        child: AddTaskScreen(),
                      ),
                    ),
                  );
                }),
            SpeedDialChild(
                child: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                label: 'Logout',
                backgroundColor: Colors.red,
                onTap: () {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(AuthenticationExited());
                })
          ],
        ),
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
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(AuthenticationStarted());
                return CircularProgressIndicator();
              } else if (auth is AuthenticationSuccess) {
                return BlocBuilder<DatabaseBloc, DatabaseState>(
                  bloc: BlocProvider.of<DatabaseBloc>(context),
                  builder: (context, DatabaseState state) {
                    return state is DatabaseLoadedState
                        ? Padding(
                            padding: EdgeInsets.only(top: 40, bottom: 5),
                            child: HomePageBody(authDetail: auth.authenticationDetail,
                              taskList: state.taskList,
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.list_alt,
                              color: Colors.teal,
                              size: 80,
                            ),
                          );
                  },
                );
              }
              return Text('Error');
            },
          ),
        ));
  }
}
