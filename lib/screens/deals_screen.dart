import 'package:flutter/material.dart';

import '../widgets/auth_container.dart';
import '../widgets/deals_list.dart';


class DealsListScreen extends StatelessWidget {
  const DealsListScreen({Key? key}) : super(key: key);
  static const String routeName = '/deals';

  @override
  Widget build(BuildContext context) {
    return const AuthContainer(title: "Deals", child: DealsList());
  }
}
