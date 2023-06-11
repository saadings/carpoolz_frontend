import 'package:carpoolz_frontend/screens/deals_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/home_screen.dart';
import '../widgets/small_loading.dart';
import '../providers/deal_provider.dart';

class AddDealsForm extends StatefulWidget {
  const AddDealsForm({Key? key}) : super(key: key);

  @override
  State<AddDealsForm> createState() => AddDealsFormState();
}

class AddDealsFormState extends State<AddDealsForm> {
  var _isLoading = false;
  final Map<String, dynamic> _initValue = {
    'title': '',
    'description': '',
    'price': '',
  };
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _buttonFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
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

    try {
      await Provider.of<DealProvider>(context, listen: false).addDeal(
        _initValue["title"],
        _initValue["description"],
        _initValue["price"],
      );
      await _showDialog("Deal Added Successfully");

      Navigator.of(context).pushReplacementNamed(DealsListScreen.routeName);
    } on DioError catch (e) {
      await _showDialog(e.response!.data['message']);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

   }

  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Form(
      key: _form,
      child: ListView(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: "Title"),
            initialValue: _initValue['title'],
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            focusNode: _titleFocusNode,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_descriptionFocusNode);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter title';
              }

              return null;
            },
            onSaved: (value) {
              _initValue['title'] = value;
            },
          ),
          
          TextFormField(
            decoration: const InputDecoration(labelText: "Description"),
            initialValue: _initValue['description'],
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            focusNode: _descriptionFocusNode,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_priceFocusNode);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter description';
              }

              return null;
            },
            onSaved: (value) {
              _initValue['description'] = value;
            },
          ),

          TextFormField(
            decoration: const InputDecoration(labelText: "Price"),
            initialValue: _initValue['price'],
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            focusNode: _priceFocusNode,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_buttonFocusNode);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter price';
              }

              return null;
            },
            onSaved: (value) {
              _initValue['price'] = value;
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
                      "Add",
                      style: Theme.of(context).textTheme.headline6,
                    ),
            ),
          )
        ],
      ),
    );
  }
}
