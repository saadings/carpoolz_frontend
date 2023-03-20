import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/user_provider.dart';

import './screens/login_screen.dart';
import './screens/register_screen.dart';
import './screens/register_driver_screen.dart';
import './screens/otp_screen.dart';
import '../screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        // home: const LoginScreen(),
        home: const HomeScreen(),
        // home: const RegisterDriverScreen(),
        routes: {
          RegisterScreen.routeName: (ctx) => const RegisterScreen(),
          RegisterDriverScreen.routeName: (ctx) => const RegisterDriverScreen(),
          OtpScreen.routeName: (ctx) => const OtpScreen(),
        },
      ),
    );
  }
}
