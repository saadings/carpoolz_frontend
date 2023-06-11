import 'package:flutter/material.dart';
import '../widgets/store_button_group.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({Key? key}) : super(key: key);
  static const String routeName = '/stores';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stores'),
      ),
      body: StoreButtonGroup(),
    );
  }
}
