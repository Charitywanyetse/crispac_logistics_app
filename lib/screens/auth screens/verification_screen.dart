import 'package:flutter/material.dart';
import 'reset_password_screen.dart';
import 'dart:async';

class VerificationScreen extends StatefulWidget {
  final String email;

  const VerificationScreen({required this.email});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _canResend = false;
  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    setState(() {
      _canResend = false;
      _secondsRemaining = 30;
    });

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _verifyOTP() {
    if (_otpController.text.isEmpty ||
        _otpController.text.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid OTP')),
      );
      return;
    }

    // TODO: Add backend OTP verification later

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResetPasswordScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color.fromARGB(255, 142, 97, 219);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text(
              'Enter the 4–6 digit code sent to\n${widget.email}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),

            // 🔥 OTP Field (styled)
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 6,
              decoration: InputDecoration(
                counterText: "",
                hintText: "------",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              style: const TextStyle(
                letterSpacing: 8,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 Resend & Verify Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _canResend
                    ? TextButton(
                        onPressed: _startCountdown,
                        child: Text(
                          'Resend Code',
                          style: TextStyle(color: primaryColor),
                        ),
                      )
                    : Text(
                        'Resend in $_secondsRemaining s',
                        style: const TextStyle(color: Colors.grey),
                      ),

                ElevatedButton(
                  onPressed: _verifyOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  child: const Text(
                    'Verify',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
