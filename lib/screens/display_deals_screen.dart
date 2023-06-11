import 'package:flutter/material.dart';

import '../widgets/auth_container.dart';
import '../widgets/display_deals.dart';

class DisplayDealsScreen extends StatelessWidget {
  const DisplayDealsScreen({Key? key}) : super(key: key);

  static const String routeName = '/display-deals';

  @override
  Widget build(BuildContext context) {
    return  AuthContainer(
        title: "Deals", child: DisplayDeals());
  }
}
