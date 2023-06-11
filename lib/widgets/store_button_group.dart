import 'package:carpoolz_frontend/screens/register_store_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/deals_screen.dart';
import '../providers/store_list_provider.dart'; // Assuming you have the StoreListProvider available

class StoreButtonGroup extends StatefulWidget {
  const StoreButtonGroup({Key? key}) : super(key: key);

  @override
  State<StoreButtonGroup> createState() => StoreButtonGroupState();
}

class StoreButtonGroupState extends State<StoreButtonGroup> {
  
  @override
  void didChangeDependencies(){
    Provider.of>(context,listen: false );
    super.didChangeDependencies();
  }














  @override
  Widget build(BuildContext context) {
    final List<Stores> storeList = Provider.of<StoreListProvider>(context).storeList;

    return Scaffold(
      appBar: AppBar(
        title: Text('Vendor Stores'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(RegisterStoreScreen.routeName);
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        children: [
          ...storeList.map((store) {
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
                  store.storeName, // Use the storeName from the storeList
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
