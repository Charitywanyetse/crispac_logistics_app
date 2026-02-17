import 'package:flutter/material.dart';
import 'reset_password_screen.dart';
import 'dart:async';

class VerificationScreen extends StatefulWidget {
  final String email;

  VerificationScreen({required this.email});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _canResend = false;
  int _secondsRemaining = 30;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _canResend = false;
    _secondsRemaining = 30;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _canResend = true;
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _verifyOTP() {
    // TODO: Add real verification logic
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ResetPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.deepPurple;

    return Scaffold(
      appBar: AppBar(title: Text('Verification'), backgroundColor: primaryColor),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Enter the 4–6 digit code sent to ${widget.email}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter OTP',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _canResend
                    ? TextButton(
                        onPressed: () {
                          _startCountdown();
                        },
                        child: Text('Resend Code', style: TextStyle(color: primaryColor)),
                      )
                    : Text('Resend in $_secondsRemaining s', style: TextStyle(color: Colors.grey)),
                ElevatedButton(
                  onPressed: _verifyOTP,
                  child: Text('Verify'),
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
