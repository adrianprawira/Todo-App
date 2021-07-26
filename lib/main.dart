import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:muslimpedia_todo_flutter/BLoC/authentication/authentication_bloc.dart';
import 'package:muslimpedia_todo_flutter/ui/home.dart';
import 'package:muslimpedia_todo_flutter/utils/notification_services.dart';

import 'BLoC/app_bloc_observer.dart';
import 'BLoC/database/database_bloc.dart';
import 'data/providers/authentication_firebase_provider.dart';
import 'data/providers/google_sign_in_provider.dart';
import 'data/repositories/authentication_repository.dart';

NotificationService notifService;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = AppBlocObserver();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(
        authenticationRepository: AuthenticationRepository(
          authenticationFirebaseProvider: AuthenticationFirebaseProvider(
            firebaseAuth: FirebaseAuth.instance,
          ),
          googleSignInProvider: GoogleSignInProvider(
            googleSignIn: GoogleSignIn(),
          ),
        ),
      ),
      ) , 
        BlocProvider<DatabaseBloc>(
          create: (context) => DatabaseBloc()..add(InitEvent()),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
      ),
    );
  }
}