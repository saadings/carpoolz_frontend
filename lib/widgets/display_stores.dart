import 'package:carpoolz_frontend/screens/display_deals_screen.dart';
import 'package:flutter/material.dart';

class Store {
  final String name;
  final String address;
  final String contactNumber;
  final String timing;

  Store({
    required this.name,
    required this.address,
    required this.contactNumber,
    required this.timing,
  });
}

class DisplayStores extends StatelessWidget {
  DisplayStores({Key? key}) : super(key: key);

  final List<Store> stores = [
    Store(
      name: 'Store 1',
      address: '123 Main Street',
      contactNumber: '123-456-7890',
      timing: '9:00 AM - 6:00 PM',
    ),
    Store(
      name: 'Store 2',
      address: '456 Elm Street',
      contactNumber: '987-654-3210',
      timing: '8:30 AM - 7:00 PM',
    ),
    // Add more stores as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store List'),
      ),
      body: ListView.separated(
        itemCount: stores.length,
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 1,
          color: Colors.grey,
        ),
        itemBuilder: (BuildContext context, int index) {
          Store store = stores[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(DisplayDealsScreen.routeName);
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    store.address,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Contact: ${store.contactNumber}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Timing: ${store.timing}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
