import 'package:carpoolz_frontend/providers/deal_provider.dart';
import 'package:carpoolz_frontend/providers/deals_list_provider.dart';
import 'package:carpoolz_frontend/screens/add_deal_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DealsList extends StatefulWidget {
  const DealsList({super.key});

  @override
  State<DealsList> createState() => DealsListState();
}

class DealsListState extends State<DealsList> {
     bool _firstTime = false;


  void getStoreData() async {
    final storeID = Provider.of<DealProvider>(context, listen: false).storeID;
    await Provider.of<DealListProvider>(context, listen: false)
        .getDeals(storeID);
  }



  @override
  void didChangeDependencies() {
    if (!_firstTime) {
      getStoreData();
      _firstTime = true;
    }

    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {

    List<Deals> deals = Provider.of<DealListProvider>(context).DealList;

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
