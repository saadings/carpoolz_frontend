import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../providers/driver_provider.dart';
import '../screens/home_screen.dart';
import '../widgets/small_loading.dart';
import '../widgets/google_auto_complete_vendor.dart';

class RegisterStoreForm extends StatefulWidget {
  const RegisterStoreForm({Key? key}) : super(key: key);

  @override
  State<RegisterStoreForm> createState() => RegisterStoreFormState();
}

class RegisterStoreFormState extends State<RegisterStoreForm> {
  var _isLoading = false;
  final Map<String, dynamic> _initValue = {
    'name': '',
    'address': '',
    'longitude': '',
    'latitude': '',
    'contactNumber': '',
    'timing': '',
  };
  final _nameFocusNode = FocusNode();
  // final _addressFocusNode = FocusNode();
  final _contactNumberFocusNode = FocusNode();
  final _timingFocusNode = FocusNode();
  final _buttonFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameFocusNode.dispose();
    // _addressFocusNode.dispose();
    _contactNumberFocusNode.dispose();
    _timingFocusNode.dispose();
    _buttonFocusNode.dispose();

    super.dispose();
  }

  Future<void> _showDialog(String content) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("Okay"),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState!.save();

    // try {
    //   await Provider.of<DriverProvider>(context, listen: false).registerStore(
    //    _initValue["name"],
    // _initValue["address"],
    // _initValue["longitude"],
    // _initValue["latitude"],
    // _initValue["contactNumber"],
    // _initValue["timing"],
    //   );

    //   Provider.of<UserProvider>(context, listen: false)
    //       .appendTypeList(Type.driver);

    //   await _showDialog("Store Registered Successfully");

    //   Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    // } on DioError catch (e) {
    //   await _showDialog(e.response!.data['message']);
    // } finally {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }

  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Form(
      key: _form,
      child: ListView(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: "Store Name"),
            initialValue: _initValue['name'],
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            focusNode: _nameFocusNode,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_contactNumberFocusNode);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter store name';
              }
              if (!RegExp('').hasMatch(value)) {
                return 'Please enter a valid Store Name';
              }
              return null;
            },
            onSaved: (value) {
              _initValue['name'] = value;
            },
          ),

          //  TextFormField(
          //   decoration: const InputDecoration(labelText: "Address"),
          //   initialValue: _initValue['address'],
          //   textInputAction: TextInputAction.next,
          //   keyboardType: TextInputType.streetAddress,
          //   focusNode: _addressFocusNode,
          //   onFieldSubmitted: (_) {
          //     FocusScope.of(context).requestFocus(_contactNumberFocusNode);
          //   },
          //   validator: (value) {
          //     if (value!.isEmpty) {
          //       return 'Please enter store address';
          //     }
          //     if (!RegExp('').hasMatch(value)) {
          //       return 'Please enter a valid address';
          //     }
          //     return null;
          //   },
          //   onSaved: (value) {
          //     _initValue['address'] = value;
          //   },
          // ),
          SizedBox(height: 8),
          GoogleAutoCompleteVendor(),
          // SizedBox(height: 5),
          TextFormField(
            decoration: const InputDecoration(labelText: "Contact Number"),
            initialValue: _initValue['contactNumber'],
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.phone,
            focusNode: _contactNumberFocusNode,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_timingFocusNode);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter contact Number';
              }
              if (!RegExp('').hasMatch(value)) {
                return 'Please enter a valid contact number';
              }
              return null;
            },
            onSaved: (value) {
              _initValue['contactNumber'] = value;
            },
          ),

          TextFormField(
            decoration: const InputDecoration(labelText: "Store Timing"),
            initialValue: _initValue['timing'],
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            focusNode: _timingFocusNode,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_buttonFocusNode);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter store timing';
              }
              return null;
            },
            onSaved: (value) {
              _initValue['timing'] = value;
            },
          ),

          const SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.15),
            child: ElevatedButton(
              focusNode: _buttonFocusNode,
              onPressed: _isLoading ? null : _submitForm,
              child: _isLoading
                  ? const SmallLoading()
                  : Text(
                      "Register",
                      style: Theme.of(context).textTheme.headline6,
                    ),
            ),
          )
        ],
      ),
    );
  }
}
