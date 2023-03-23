import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import './providers/user_provider.dart';
import './providers/driver_provider.dart';
import './providers/google_maps_provider.dart';

import './screens/login_screen.dart';
import './screens/register_screen.dart';
import './screens/register_driver_screen.dart';
import './screens/otp_screen.dart';
import './screens/home_screen.dart';
import 'screens/ride_requests_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
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
        ChangeNotifierProxyProvider<UserProvider, DriverProvider>(
          create: (_) => DriverProvider(userName: ""),
          update: (ctx, user, previousState) =>
              DriverProvider(userName: user.userName),
        ),
        ChangeNotifierProxyProvider<UserProvider, GoogleMapsProvider>(
          create: (_) => GoogleMapsProvider(userName: ""),
          update: (ctx, user, previousState) =>
              GoogleMapsProvider(userName: user.userName),
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
                fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
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
              backgroundColor: MaterialStatePropertyAll(
                Color.fromARGB(150, 90, 224, 0),
              ),
            ),
          ),
        ),
        home: const LoginScreen(),
        // home: const HomeScreen(),
        // home: const RegisterDriverScreen(),
        routes: {
          RegisterScreen.routeName: (ctx) => const RegisterScreen(),
          RegisterDriverScreen.routeName: (ctx) => const RegisterDriverScreen(),
          OtpScreen.routeName: (ctx) => const OtpScreen(),
          HomeScreen.routeName: (ctx) => const HomeScreen(),
          RideRequestsScreen.routeName: (ctx) => const RideRequestsScreen(),
        },
      ),
    );
  }
}
