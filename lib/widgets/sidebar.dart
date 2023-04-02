import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../screens/home_screen.dart';
import '../screens/register_driver_screen.dart';


const List<Widget> users = <Widget>[
  Text('Driver'),
  Text('Passenger'),
  Text('Vendor')
];



class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => SideBarState();
}


class SideBarState extends State<SideBar> {
final List<bool> _selectedUsers = <bool>[true, false, false];
var  _userTypeState;

 Future<void> _checkUserType() async {
    try {
      await Provider.of<UserProvider>(context, listen: false)
          .setType(_userTypeState);
    } catch (e) {
      print(e.toString());
    }

    print(Provider.of<UserProvider>(context, listen: false).types);
    if(Provider.of<UserProvider>(context, listen: false).types!.contains(Type.driver)){
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
    else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterDriverScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      child: Column(
        children: [
          Text('Switch To', style: TextStyle(fontSize: 20.0)),
              const SizedBox(height: 5),
              ToggleButtons(
                direction: Axis.vertical,
                onPressed: (int index) {
                  setState(() {
                    // The button that is tapped is set to true, and the others to false.
                    for (int i = 0; i < _selectedUsers.length; i++) {
                      _selectedUsers[i] = i == index;
                      _userTypeState = users[index].toString();
                    }
                    _checkUserType();
                  });
                },
                textStyle: TextStyle(fontSize: 16.0),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedBorderColor: Color.fromARGB(150, 90, 224, 0),
                selectedColor: Colors.white,
                fillColor: Color.fromARGB(149, 116, 221, 46),
                color: Color.fromARGB(149, 98, 244, 1),
                constraints: const BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 300
                ),
                isSelected: _selectedUsers,
                children: users,
              )
    ]
   )
  );
  }
}
