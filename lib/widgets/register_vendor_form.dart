import 'package:carpoolz_frontend/screens/register_store_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../providers/driver_provider.dart';
import '../screens/home_screen.dart';
import '../widgets/small_loading.dart';

class RegisterVendorForm extends StatefulWidget {
  const RegisterVendorForm({Key? key}) : super(key: key);

  @override
  State<RegisterVendorForm> createState() => RegisterVendorFormState();
}

class RegisterVendorFormState extends State<RegisterVendorForm> {
  var _isLoading = false;
  final Map<String, dynamic> _initValue = {
    'cnic': '',
  };
  final _cnicFocusNode = FocusNode();
  final _buttonFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _cnicFocusNode.dispose();
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

    Navigator.of(context).pushReplacementNamed(RegisterStoreScreen.routeName);

    // try {
    //   await Provider.of<DriverProvider>(context, listen: false).registerVendor(
    //     _initValue["cnic"],
    //   );

    //   Provider.of<UserProvider>(context, listen: false)
    //       .appendTypeList(Type.driver);

    //   await _showDialog("Vendor Registered Successfully");

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
            decoration: const InputDecoration(labelText: "CNIC"),
            initialValue: _initValue['cnic'],
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.phone,
            focusNode: _cnicFocusNode,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_buttonFocusNode);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your CNIC';
              }
              if (!RegExp(r'^\d+$').hasMatch(value)) {
                return 'Please enter a valid CNIC';
              }
              return null;
            },
            onSaved: (value) {
              _initValue['cnic'] = value;
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
