import 'package:flutter/material.dart';

class Store {
  final String name;
  final String address;

  Store({required this.name, required this.address});
}

class StoreListScreen extends StatelessWidget {
  final List<Store> stores = [
    Store(name: 'Store 1', address: 'Address 1'),
    Store(name: 'Store 2', address: 'Address 2'),
    Store(name: 'Store 3', address: 'Address 3'),
    // Add more stores as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store List'),
      ),
      body: ListView.builder(
        itemCount: stores.length,
        itemBuilder: (context, index) {
          final store = stores[index];
          return ListTile(
            title: Text(store.name),
            subtitle: Text(store.address),
          );
        },
      ),
    );
  }
}

