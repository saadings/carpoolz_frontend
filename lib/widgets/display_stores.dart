import 'package:carpoolz_frontend/providers/deal_provider.dart';
import 'package:carpoolz_frontend/providers/store_list_provider.dart';
import 'package:carpoolz_frontend/screens/display_deals_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DisplayStores extends StatefulWidget {
  DisplayStores({Key? key}) : super(key: key);

  @override
  State<DisplayStores> createState() => _DisplayStoresState();
}

class _DisplayStoresState extends State<DisplayStores> {
  bool _firstTime = false;

  void getPassengerStores() async {
    await Provider.of<StoreListProvider>(context, listen: false)
        .getPassengerStores();
  }

  @override
  void didChangeDependencies() {
    if (!_firstTime) {
      getPassengerStores();
      _firstTime = true;
    }
    // getPassengerStores();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final List<Stores> stores =
        Provider.of<StoreListProvider>(context).storeList;
    print(stores);
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
          Stores store = stores[index];
          return GestureDetector(
            onTap: () {
              Provider.of<DealProvider>(context, listen: false)
                  .setStoreID(store.storeID);
              Navigator.of(context).pushNamed(DisplayDealsScreen.routeName);
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.storeName,
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
