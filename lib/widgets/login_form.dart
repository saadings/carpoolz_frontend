import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../screens/register_screen.dart';
import './small_loading.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  Map<String, dynamic> _initValue = {
    'userName': '',
    'password': '',
  };
  var _isLoading = false;

  var _passwordFocusNode = FocusNode();
  var _buttonFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _buttonFocusNode.dispose();
    super.dispose();
  }

  Future<void> _showErrorDialog(String message) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("An error occurred!"),
        content: Text(message),
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
      await Provider.of<UserProvider>(context, listen: false)
          .login(_initValue['userName'], _initValue['password']);
    } on DioError catch (e) {
      await _showErrorDialog(e.response!.data['message']);
    } catch (e) {
      await _showErrorDialog(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Form(
      key: _form,
      child: ListView(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: "Username"),
            initialValue: _initValue['userName'],
            textInputAction: TextInputAction.next,
            // keyboardType: TextInputType.,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_passwordFocusNode);
            },
            onSaved: (newValue) => _initValue['userName'] = newValue,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your username';
              }
              if (value.length < 8) {
                return 'Username should be at least 8 characters long';
              }
              return null;
            },
          ),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Password",
            ),
            initialValue: _initValue['password'],
            textInputAction: TextInputAction.done,
            focusNode: _passwordFocusNode,
            onFieldSubmitted: (_) {
              _form.currentState!.validate();
              FocusScope.of(context).requestFocus(_buttonFocusNode);
            },
            onSaved: (newValue) => _initValue['password'] = newValue,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 8) {
                return 'Password should be at least 8 characters long';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 90), // set the width to your desired value
            child: TextButton(
              onPressed: () {},
              child: const Text(
                "Forgot Password?",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
          // const SizedBox(
          //   height: 5,
          // ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.15),
            child: ElevatedButton(
              focusNode: _buttonFocusNode,
              onPressed: _isLoading ? null : _submitForm,
              child: _isLoading
                  ? const SmallLoading()
                  : Text(
                      "Login",
                      style: Theme.of(context).textTheme.headline6,
                    ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Don't have an account?",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                width: 1,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(RegisterScreen.routeName);
                },
                child: const Text(
                  "Register",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
