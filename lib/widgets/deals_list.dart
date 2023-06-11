import 'package:carpoolz_frontend/screens/add_deal_screen.dart';
import 'package:flutter/material.dart';


class Deal {
  final String title;
  final String description;
  final double price;

  Deal({required this.title, required this.description, required this.price});
}

class DealsList extends StatefulWidget {
  const DealsList({super.key});

  @override
  State<DealsList> createState() => DealsListState();
}

class DealsListState extends State<DealsList> {
    List<Deal> deals = [
    Deal(
      title: 'Deal 1',
      description: 'This is the description for Deal 1',
      price: 19.99,
    ),
    Deal(
      title: 'Deal 2',
      description: 'This is the description for Deal 2',
      price: 29.99,
    ),
    Deal(
      title: 'Deal 3',
      description: 'This is the description for Deal 3',
      price: 39.99,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deals'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
             Navigator.of(context).pushNamed(AddDealScreen.routeName);
              // Add new deal logic here
             /* setState(() {
                deals.add(
                  Deal(
                    title: 'New Deal',
                    description: 'This is a new deal',
                    price: 49.99,
                  ),
                );
              });*/
            },
            child: Text('Add Deals'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: deals.length,
              itemBuilder: (context, index) {
                final deal = deals[index];
                return ListTile(
                  title: Text(deal.title),
                  subtitle: Text(deal.description),
                  trailing: IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      // Remove deal logic here
                      setState(() {
                        deals.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
