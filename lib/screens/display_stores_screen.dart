import 'package:flutter/material.dart';

import '../widgets/auth_container.dart';
import '../widgets/display_stores.dart';

class DisplayStoresScreen extends StatelessWidget {
  const DisplayStoresScreen({Key? key}) : super(key: key);

  static const String routeName = '/display-stores';

  @override
  Widget build(BuildContext context) {
    return  AuthContainer(
        title: "Stores", child: DisplayStores());
  }
}
