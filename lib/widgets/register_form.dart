import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../widgets/small_loading.dart';
import '../screens/otp_screen.dart';
import '../screens/login_screen.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  var _isLoading = false;
  var _obscurePassword = true;
  var _obscurePassword2 = true;
  final Map<String, dynamic> _initValue = {
    'userName': '',
    'email': '',
    'firstName': '',
    'lastName': '',
    'password': '',
    'contactNumber': '',
    'gender': Gender.male,
  };
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _contactNumberFocusNode = FocusNode();
  final _genderFocusNode = FocusNode();
  final _buttonFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _contactNumberFocusNode.dispose();
    _genderFocusNode.dispose();
    _buttonFocusNode.dispose();

    super.dispose();
  }

  String? _validateGender(Gender? value) {
    return value == null ? 'Please select a gender' : null;
  }

  Future<void> _showDialog(String title, String content) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
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
      await Provider.of<UserProvider>(context, listen: false).register(
        _initValue["userName"],
        _initValue["email"],
        _initValue["firstName"],
        _initValue["lastName"],
        _initValue["contactNumber"],
        _initValue["gender"],
        _initValue["password"],
      );

      await _showDialog("User Registered Successfully",
          "An OTP has been sent to your email address. Please verify your account before logging in.");

      Navigator.of(context).pushReplacementNamed(OtpScreen.routeName);
    } on DioError catch (e) {
      await _showDialog("An Error Occurred", e.response!.data['message']);
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
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_emailFocusNode);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a username';
              }
              if (value.length < 8) {
                return 'Username must be at least 8 characters';
              }
              return null;
            },
            onSaved: (value) {
              _initValue['userName'] = value;
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
              if (value!.isEmpty) {
                return 'Please enter an email';
              }
              if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                  .hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            onSaved: (value) {
              _initValue['email'] = value;
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
              if (value!.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
            onSaved: (value) {
              _initValue['firstName'] = value;
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
              if (value!.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
            onSaved: (value) {
              _initValue['lastName'] = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Password",
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                child: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  size: 20,
                ),
              ),
            ),
            // initialValue: _initValue['password'],
            textInputAction: TextInputAction.next,
            obscureText: _obscurePassword,
            focusNode: _passwordFocusNode,
            controller: _passwordController,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a password';
              }

              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }

              // At least one lowercase letter
              if (!RegExp(r'[a-z]').hasMatch(value)) {
                return 'Password must contain at least one lowercase letter';
              }

              // At least one uppercase letter
              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                return 'Password must contain at least one uppercase letter';
              }

              // At least one digit
              if (!RegExp(r'\d').hasMatch(value)) {
                return 'Password must contain at least one number';
              }

              // At least one special character
              if (!RegExp(r'[^\w\s]').hasMatch(value)) {
                return 'Password must contain at least one special character';
              }

              // No whitespace or newline characters
              if (RegExp(r'[\s\n]').hasMatch(value)) {
                return 'Password must not contain whitespace or newline characters';
              }

              // All conditions passed, so password is valid
              return null;
            },
            onSaved: (value) {
              _initValue['password'] = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Confirm Password",
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscurePassword2 = !_obscurePassword2;
                  });
                },
                child: Icon(
                  _obscurePassword2 ? Icons.visibility : Icons.visibility_off,
                  size: 20,
                ),
              ),
            ),
            textInputAction: TextInputAction.next,
            obscureText: _obscurePassword2,
            focusNode: _confirmPasswordFocusNode,
            onFieldSubmitted: (_) {
              _form.currentState!.validate();
              FocusScope.of(context).requestFocus(_contactNumberFocusNode);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Contact Number"),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.phone,
            focusNode: _contactNumberFocusNode,
            onSaved: (newValue) => _initValue['contactNumber'] = newValue,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_genderFocusNode);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a contact number';
              }
              final phoneNumberRegex = RegExp(r'^\+?[0-9]{6,14}$');
              if (!phoneNumberRegex.hasMatch(value)) {
                return 'Please enter a valid contact number';
              }

              return null;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            'Gender',
            style: TextStyle(color: Colors.white60),
          ),
          DropdownButtonFormField<Gender>(
            focusNode: _genderFocusNode,
            value: _initValue['gender'],
            onChanged: (Gender? value) {
              setState(() {
                _initValue['gender'] = value;
              });
            },
            onSaved: (_) {
              FocusScope.of(context).requestFocus(_buttonFocusNode);
            },
            validator: (value) => _validateGender(value),
            items: const [
              DropdownMenuItem<Gender>(
                value: Gender.male,
                child: Text('Male'),
              ),
              DropdownMenuItem<Gender>(
                value: Gender.female,
                child: Text('Female'),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
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
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Have an account?", textAlign: TextAlign.center),
              const SizedBox(
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
