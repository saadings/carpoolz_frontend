import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
// import '../screens/home_screen.dart';
import '../screens/register_driver_screen.dart';

class UserButtonGroup extends StatefulWidget {
  const UserButtonGroup({super.key});

  @override
  State<UserButtonGroup> createState() => UserButtonGroupState();
}

class UserButtonGroupState extends State<UserButtonGroup> {
  final List<String> _users = const [
    'Passenger',
    'Driver',
    'Vendor',
  ];

  bool _first = true;
  final List<bool> _selectedUsers = <bool>[false, false, false];
  String _userTypeState = "";

  void _checkUserType(int index) {
    setState(
      () {
        // The button that is tapped is set to true, and the others to false.
        for (int i = 0; i < _selectedUsers.length; i++) {
          _selectedUsers[i] = i == index;
          _userTypeState = _users[index].toString();
        }
        Provider.of<UserProvider>(context, listen: false)
            .setType(_userTypeState);
      },
    );

    if (!Provider.of<UserProvider>(context, listen: false)
            .types!
            .contains(Type.driver) &&
        _userTypeState == 'Driver') {
      // Navigator.of(context).pop();
      Navigator.of(context).pushNamed(RegisterDriverScreen.routeName);
    } else
      Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if (_first) {
      _first = false;

      if (Provider.of<UserProvider>(context, listen: false).currentType ==
          Type.driver) {
        _selectedUsers[1] = true;
        _userTypeState = _users[1].toString();
      } else if (Provider.of<UserProvider>(context, listen: false)
              .currentType ==
          Type.passenger) {
        _selectedUsers[0] = true;
        _userTypeState = _users[0].toString();
      } else if (Provider.of<UserProvider>(context, listen: false)
              .currentType ==
          Type.vendor) {
        _selectedUsers[2] = true;
        _userTypeState = _users[2].toString();
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Container(
      width: 200.0,
      child: Column(
        children: [
          Text('Switch To', style: TextStyle(fontSize: 20.0)),
          const SizedBox(height: 5),
          ToggleButtons(
            direction: Axis.vertical,
            onPressed: _checkUserType,
            textStyle: TextStyle(fontSize: 16.0),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedBorderColor: _theme.accentColor,
            selectedColor: Colors.white,
            fillColor: _theme.accentColor,
            color: _theme.accentColor,
            constraints: const BoxConstraints(minHeight: 40.0, minWidth: 300),
            isSelected: _selectedUsers,
            children: _users.map((e) => Text(e)).toList(),
          )
        ],
      ),
    );
  }
}
