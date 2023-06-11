import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../screens/login_screen.dart';
import '../widgets/small_loading.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({super.key});

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  var _isLoading = false;
  var _isLoadingOtp = false;
  final Map<String, dynamic> _initValue = {
    'otp': '',
  };
  final FocusNode _buttonFocusNode = FocusNode();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  int _timeRemaining = 1 * 60; // 1 minutes in seconds
  bool _timerRunning = false;
  Timer? _timer;

  void _startTimer() {
    setState(() {
      _timerRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _stopTimer();
        }
      });
    });
  }

  void _stopTimer() {
    setState(() {
      _timerRunning = false;
    });

    _timer?.cancel();
    _timer = null;

    setState(() {
      _timeRemaining = 1 * 60;
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    _timer?.cancel();

    super.dispose();
  }

  Future<void> _showDialog(String title, String message) async {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  Future<void> _resendOtp() async {
    setState(() {
      _isLoadingOtp = true;
    });

    try {
      await Provider.of<UserProvider>(context, listen: false).resendOtp();
      await _showDialog("OTP Sent", "OTP sent successfully");
    } on DioError catch (e) {
      await _showDialog("OTP Sending Failed", e.response!.data['message']);
    } catch (e) {
      await _showDialog("An Error Occurred", "Something went wrong");
    } finally {
      setState(() {
        _isLoadingOtp = false;
      });
    }
  }

  Future<void> _submitForm() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();
    print(_initValue['otp']);

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<UserProvider>(context, listen: false).verify(
        _initValue['otp'],
      );
      await _showDialog(
          "User Verified Successfully", "Please Login to use the app");
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    } on DioError catch (e) {
      await _showDialog(
          "User Verification Failed", e.response!.data['message']);
    } catch (e) {
      await _showDialog("An Error Occurred", "Something went wrong");
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
            decoration: const InputDecoration(
              labelText: "OTP",
            ),
            maxLength: 6,
            initialValue: _initValue['otp'],
            textInputAction: TextInputAction.done,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'\d+')),
            ],
            keyboardType: TextInputType.number,
            onFieldSubmitted: (_) {
              _form.currentState!.validate();
              FocusScope.of(context).requestFocus(_buttonFocusNode);
            },
            onSaved: (newValue) => _initValue['otp'] = newValue,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your OTP';
              }
              if (value.length < 6) {
                return 'OTP should be at least 6 digits long';
              }
              return null;
            },
          ),
          // Text(
          //   _formatTime(_timeRemaining),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Didn't receive an OTP?",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                width: 1,
              ),
              TextButton(
                onPressed: _timerRunning
                    ? null
                    : () {
                        _resendOtp();
                        _startTimer();
                      },
                // Navigator.of(context)
                //     .pushReplacementNamed(RegisterScreen.routeName);

                child: _isLoadingOtp
                    ? const SmallLoading()
                    : Text(
                        _timerRunning
                            ? "Resend in:  ${_formatTime(_timeRemaining)}"
                            : "Resend OTP",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
              ),
            ],
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
                      "Verify",
                      style: Theme.of(context).textTheme.headline6,
                    ),
            ),
          )
        ],
      ),
    );
  }
}
