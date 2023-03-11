import 'package:flutter/material.dart';

class SmallLoading extends StatelessWidget {
  const SmallLoading({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
      width: 20,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
