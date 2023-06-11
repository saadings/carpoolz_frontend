import 'package:flutter/material.dart';

import '../widgets/auth_container.dart';
import '../widgets/add_deals_form.dart';

class AddDealScreen extends StatelessWidget {
  const AddDealScreen({Key? key}) : super(key: key);

  static const String routeName = '/add_deal';

  @override
  Widget build(BuildContext context) {
    return const AuthContainer(
        title: "Add Deal", child: AddDealScreen());
  }
}
