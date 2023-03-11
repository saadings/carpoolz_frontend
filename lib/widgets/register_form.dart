import 'package:flutter/material.dart';

import '../screens/login_screen.dart';

class RegisterForm extends StatefulWidget {
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  var _initValue = {
    'userName': '',
    'email': '',
    'firstName': '',
    'lastName': '',
    'password': '',
  };
  Map<String, dynamic> _registerData = {
    'userName': '',
    'email': '',
    'firstName': '',
    'lastName': '',
    'password': '',
  };
  var _passwordController = TextEditingController();
  var _emailFocusNode = FocusNode();
  var _firstNameFocusNode = FocusNode();
  var _lastNameFocusNode = FocusNode();
  var _passwordFocusNode = FocusNode();
  var _confirmPasswordFocusNode = FocusNode();
  var _buttonFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _buttonFocusNode.dispose();

    super.dispose();
  }

  bool _containsUppercase(String value) {
    return RegExp(r'[A-Z]').hasMatch(value);
  }

  bool _containsLowercase(String value) {
    return RegExp(r'[a-z]').hasMatch(value);
  }

  bool _containsNumber(String value) {
    return RegExp(r'\d').hasMatch(value);
  }

  bool _containsSpecialCharacter(String value) {
    return RegExp(r'[@$!%*?&.]').hasMatch(value);
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    // _form.currentState.validate();
    _form.currentState.save();
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
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_emailFocusNode);
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a username';
              }
              if (value.length < 8) {
                return 'Username must be at least 8 characters';
              }
              return null;
            },
            onSaved: (value) {
              _registerData['userName'] = value;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Email"),
            initialValue: _initValue['email'],
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            focusNode: _emailFocusNode,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_firstNameFocusNode);
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter an email';
              }
              if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                  .hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            onSaved: (value) {
              _registerData['email'] = value;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "First Name"),
            initialValue: _initValue['firstName'],
            textInputAction: TextInputAction.next,
            focusNode: _firstNameFocusNode,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_lastNameFocusNode);
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
            onSaved: (value) {
              _registerData['firstName'] = value;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Last Name"),
            initialValue: _initValue['lastName'],
            textInputAction: TextInputAction.next,
            focusNode: _lastNameFocusNode,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_passwordFocusNode);
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
            onSaved: (value) {
              _registerData['lastName'] = value;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Password"),
            // initialValue: _initValue['password'],
            textInputAction: TextInputAction.next,
            obscureText: true,
            focusNode: _passwordFocusNode,
            controller: _passwordController,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              if (!_containsUppercase(value)) {
                return 'Password must contain at least one uppercase letter';
              }
              if (!_containsLowercase(value)) {
                return 'Password must contain at least one lowercase letter';
              }
              if (!_containsNumber(value)) {
                return 'Password must contain at least one number';
              }
              if (!_containsSpecialCharacter(value)) {
                return 'Password must contain at least one special character';
              }
              return null;
            },
            onSaved: (value) {
              _registerData['password'] = value;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Confirm Password"),
            textInputAction: TextInputAction.done,
            obscureText: true,
            focusNode: _confirmPasswordFocusNode,
            onFieldSubmitted: (_) {
              _form.currentState.validate();
              FocusScope.of(context).requestFocus(_buttonFocusNode);
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.15),
            child: ElevatedButton(
              focusNode: _buttonFocusNode,
              onPressed: _saveForm,
              child: Text(
                "Register",
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
              const Text("Have an account?", textAlign: TextAlign.center),
              SizedBox(
                width: 1,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                },
                child: const Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
