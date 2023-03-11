import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../screens/register_screen.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var _initValue = {
    'userName': '',
    'password': '',
  };
  Map<String, dynamic> _loginData = {
    'userName': '',
    'password': '',
  };
  var _passwordFocusNode = FocusNode();
  var _buttonFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _buttonFocusNode.dispose();
    super.dispose();
  }

  void _submitForm() {
    final isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }

    _form.currentState.save();
    Provider.of<UserProvider>(context, listen: false)
        .login(_loginData['userName'], _loginData['password']);
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
            onSaved: (newValue) => _loginData['userName'] = newValue,
            validator: (value) {
              if (value.isEmpty) {
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
              _form.currentState.validate();
              FocusScope.of(context).requestFocus(_buttonFocusNode);
            },
            onSaved: (newValue) => _loginData['password'] = newValue,
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
              onPressed: _submitForm,
              child: Text(
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
              SizedBox(
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
