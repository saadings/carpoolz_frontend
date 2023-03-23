import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:provider/provider.dart';

import '../models/google_maps.dart';
import '../providers/google_maps_provider.dart';

class GoogleAutoComplete extends StatefulWidget {
  const GoogleAutoComplete({super.key});

  @override
  State<GoogleAutoComplete> createState() => _GoogleAutoCompleteState();
}

class _GoogleAutoCompleteState extends State<GoogleAutoComplete> {
  late GooglePlace googlePlace;
  String apiKey = 'AIzaSyAXD-Jtq7KNo93Sw7lEdidS-J5zX6NjTrs';

  @override
  void initState() {
    googlePlace = GooglePlace(apiKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Autocomplete<GoogleMapsModel>(
      optionsViewBuilder: (
        BuildContext context,
        AutocompleteOnSelected<GoogleMapsModel> onSelected,
        Iterable<GoogleMapsModel> options,
      ) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 6,
            child: Container(
              height: mediaQuery.height / 2.5,
              width: mediaQuery.width - 40,
              child: options.length < 1
                  ? ListView(
                      children: [
                        Text('Location not found!'),
                      ],
                    )
                  : ListView(
                      children: [
                        Divider(
                          height: 0,
                        ),
                        ...options.map(
                          (GoogleMapsModel option) => Column(
                            children: [
                              ListTile(
                                title: Text(option.description),
                                onTap: () {
                                  onSelected(option);
                                },
                              ),
                              Divider(
                                height: 0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
      onSelected: (GoogleMapsModel selection) {
        // When the user selects a search result, update the text field with the selection
        // _destinationController.text = selection;
        Provider.of<GoogleMapsProvider>(context, listen: false).addMarker(
          selection,
          googlePlace,
        );
      },
      fieldViewBuilder: (BuildContext context, TextEditingController controller,
          FocusNode focusNode, VoidCallback onFieldSubmitted) {
        // Return the text field with the controller and focus node
        return TextField(
          controller: controller,
          focusNode: focusNode,
          onSubmitted: (String value) {
            onFieldSubmitted();
          },
          decoration: InputDecoration(
            hintText: "Destination",
            hintStyle: TextStyle(
              color: Colors.grey[400],
            ),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey[900],
            prefixIcon: Icon(
              Icons.location_on_outlined,
              color: Colors.grey[400],
            ),
          ),
        );
      },
      optionsBuilder: (
        TextEditingValue textEditingValue,
      ) async {
        if (textEditingValue.text.length < 3 || textEditingValue.text.isEmpty) {
          return const Iterable<GoogleMapsModel>.empty();
        }

        // if (_debounce?.isActive ?? false)
        //   _debounce?.cancel();
        // List<String> options = [];
        // _debounce = Timer(
        //   const Duration(milliseconds: 1000),
        //   () async {
        //     options = await _autoCompleteSearch(
        //       textEditingValue.text,
        //     );
        //     setState(() {});
        //   },
        // );
        // return await options;
        return await Provider.of<GoogleMapsProvider>(context, listen: false)
            .autoCompleteSearch(
          textEditingValue.text,
          googlePlace,
          mounted,
        );
      },
      displayStringForOption: (GoogleMapsModel option) => option.description,
    );
  }
}
