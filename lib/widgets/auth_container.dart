import 'package:flutter/material.dart';

class AuthContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const AuthContainer({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              child: Center(
                child: Image.asset(
                  'assets/images/carpoolz.png',
                  // fit: BoxFit.cover,
                  height: 80,
                ),
              ),
              // child: Center(
              //   child:
              //       Text("Login", style: Theme.of(context).textTheme.headline2),
              // ),
            ),
            // const SizedBox(
            //   height: 5,
            // ),
            SizedBox(
              height: deviceSize.height * 0.74,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: child,
              ),
            ),
            // ClipRRect(
            //   borderRadius: const BorderRadius.only(
            //       topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            //   child: Container(
            //     height: 517,
            //     width: double.infinity,
            //     decoration: const BoxDecoration(color: Colors.black38),
            //     child: LoginForm(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
