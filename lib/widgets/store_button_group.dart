import 'package:flutter/material.dart';
import '../screens/deals_screen.dart';

class StoreButtonGroup extends StatefulWidget {
  const StoreButtonGroup({super.key});

  @override
  State<StoreButtonGroup> createState() => StoreButtonGroupState();
}

class StoreButtonGroupState extends State<StoreButtonGroup> {
  final List<String> buttonLabels = [
    'Button 1',
    'Button 2',
    'Button 3',
    'Button 4',
    'Button 5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendor Stores'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        children: buttonLabels.map((label) {
          return Container(
            margin: EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(DealsListScreen.routeName);
                // Add your button logic here
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.all(16.0),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
              child: Text(
                label,
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
