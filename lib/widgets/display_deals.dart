import 'package:flutter/material.dart';

class Deal {
  final String title;
  final String description;
  final double price;

  Deal({
    required this.title,
    required this.description,
    required this.price,
  });
}

class DisplayDeals extends StatelessWidget {
  DisplayDeals({Key? key}) : super(key: key);
  final List<Deal> deals = [
    Deal(
      title: 'Deal 1',
      description: 'Burger.',
      price: 200,
    ),
    Deal(
      title: 'Deal 2',
      description: 'Pizza',
      price: 700,
    ),
    // Add more deals as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deal List'),
      ),
      body: ListView.builder(
        itemCount: deals.length,
        itemBuilder: (BuildContext context, int index) {
          Deal deal = deals[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deal.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    deal.description,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Price: ${deal.price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Order Placed'),
                            content: Text('Your order has been placed.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Place Order'),
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
