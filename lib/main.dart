import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/user_provider.dart';

import './screens/login_screen.dart';
import './screens/register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Carpoolz',
        theme: ThemeData(
          fontFamily: 'UberMove',
          textTheme: const TextTheme(
              headline2: TextStyle(fontSize: 65),
              headline6: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1)),
          brightness: Brightness.dark,
          primarySwatch: Colors.purple,
          accentColor: const Color.fromARGB(150, 90, 224, 0),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(220, 165, 0, 206),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevatedButtonTheme: const ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Color.fromARGB(150, 88, 224, 0)),
            ),
          ),
        ),
        home: LoginScreen(),
        routes: {
          RegisterScreen.routeName: (ctx) => RegisterScreen(),
        },
      ),
    );
  }
}
