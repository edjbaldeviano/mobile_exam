import 'package:flutter/material.dart';
import 'package:otp_plus/otp_inputs.dart';
import 'package:otp_plus/utils/enum/otp_field_shape.dart';

import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.grey),
      ),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class HomePageLoginScreenLogos extends StatelessWidget {
  const HomePageLoginScreenLogos({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 150,
      child: Center(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  'lib/assets/images/youtube.png',
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            Positioned(
              top: 25,
              left: 75,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  'lib/assets/images/spotify.png',
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  'lib/assets/images/facebook.png',
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePageLoginForm extends StatefulWidget {
  const HomePageLoginForm({super.key});

  @override
  State<HomePageLoginForm> createState() => _HomePageLoginState();
}

class _HomePageLoginState extends State<HomePageLoginForm> {
  final _loginFormKey = GlobalKey<FormState>();
  final int _userNameMaxLength = 24;
  final int _otpLength = 6;
  final TextEditingController _userNameController = TextEditingController();
  bool _isButtonEnabled = false;
  String _userName = '';
  String _otp = '';

  void _onInputChanged(String text) {
    setState(() {
      _userName = text;
      _isButtonEnabled = text.trim().isNotEmpty;
    });
  }

  String? validateInput(String? value) {
    final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    if (value.length > _userNameMaxLength) {
      return 'Must not exceed $_userNameMaxLength characters';
    }
    if (!alphanumeric.hasMatch(value)) {
      return 'Values must be alphanumeric';
    }
    return null;
  }

  void _onPressed(BuildContext context) {
    if (_loginFormKey.currentState!.validate()) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Verify It's You"),
            alignment: Alignment.center,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Please enter your 6-digit PIN'),
                OtpPlusInputs(
                  size: 30,
                  horizontalSpacing: 5,
                  shape: OtpFieldShape.underline,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                  length: _otpLength,
                  textDirection: TextDirection.ltr,
                  textStyle: TextStyle(fontSize: 18),
                  onChanged: (code) {
                    setState(() {
                      _otp = code;
                    });
                  },
                  onSubmit: (code) {
                    _loginFormKey.currentState?.reset();
                  },
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (context) {
                      return LoadingPage(
                        context: context,
                        userName: _userName,
                        otp: _otp
                      );
                    })
                  );
                },
                child: const Text(
                  'Enter',
                  style: TextStyle(color: Colors.green),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  setState(() {
                    _otp = '';
                  });
                },
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _userNameController.dispose(); // Always clean up controllers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Form(
        key: _loginFormKey,
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _userNameController,
              onChanged: _onInputChanged,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (String? value) => validateInput(value),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Username',
                errorStyle: TextStyle()
              ),
            ),
            FilledButton(
              onPressed: _isButtonEnabled ? () => _onPressed(context) : null,
              style: FilledButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                fixedSize: Size(250, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(5)
                ),
              ),
              child: const Text('Enter')
            ),
          ],
        ),
      ),
    );
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 100,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HomePageLoginScreenLogos(),
            HomePageLoginForm(),
          ],
        ),
      ),
    );
  }
}
