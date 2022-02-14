import 'package:event_manager/vendors/events.dart';
import 'package:event_manager/screens/create_new_event.dart';
import 'package:event_manager/screens/edit_club_screen.dart';
import 'package:event_manager/screens/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import './vendors/authentication.dart';
import './screens/login.dart';
import './screens/homepage.dart';
import './screens/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Authentication(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Events(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Login(),
        routes: {
          HomePage.routeName: (ctx) => HomePage(),
          SignUp.routeName: (ctx) => SignUp(),
          Login.routeName: (ctx) => Login(),
          EditclubScreen.routeName: (ctx) => EditclubScreen(),
          CreateNewEvent.routeName: (ctx) => CreateNewEvent(),
          CalendarScreen.routeName: (ctx) => CalendarScreen(),
        },
      ),
    );
  }
}
