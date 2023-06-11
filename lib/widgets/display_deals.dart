import 'package:carpoolz_frontend/providers/deal_provider.dart';
import 'package:carpoolz_frontend/providers/deals_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class DisplayDeals extends StatefulWidget {
  DisplayDeals({Key? key}) : super(key: key);

  @override
  State<DisplayDeals> createState() => _DisplayDealsState();
}

class _DisplayDealsState extends State<DisplayDeals> {
  // final List<Deal> deals = [
  bool _firstTime = false;

  Future<void> getDeals() async {
    final _storeId = Provider.of<DealProvider>(context, listen: false).storeID;
    await Provider.of<DealListProvider>(context, listen: false)
        .getDeals(_storeId);
  }

  @override
  void didChangeDependencies() {
    if (!_firstTime) {
      getDeals();
      _firstTime = true;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final List<Deals> deals = Provider.of<DealListProvider>(context).DealList;
    return Scaffold(
      appBar: AppBar(
        title: Text('Deal List'),
      ),
      body: ListView.builder(
        itemCount: deals.length,
        itemBuilder: (BuildContext context, int index) {
          Deals deal = deals[index];
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
                    'Price: ${deal.price}',
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
