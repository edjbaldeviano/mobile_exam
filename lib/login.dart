import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'user.dart';

Future<User> fetchUserData({required String userName, required String otp}) async {
  var uri = Uri.parse('https://indexcodex.com/api/v1/login');
  final Map<String, String> customHeaders = {
    'CLIENT_ID': 'rgbexam'
  };
  final Map<String, String> requestBody = {
    'userName': userName,
    'otp': otp,
  };
  try {
    final response = await http.post(
      uri,
      headers: customHeaders,
      body: jsonEncode(requestBody)
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Failed to load user data');
    }
  } catch (e) {
    throw Exception(e);
  }   
}

class LoadingPage extends StatefulWidget {
  final BuildContext context;
  final String userName;
  final String otp;

  const LoadingPage({
    super.key,
    required this.context,
    required this.userName,
    required this.otp,
  });

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  late Future<User> _apiResponse;

  @override
  void initState() {
    super.initState();
    _apiResponse = fetchUserData(userName: widget.userName, otp: widget.otp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<User>(
              future: _apiResponse,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const .symmetric(vertical: 20),
                        // ignore: deprecated_member_use
                        child: CircularProgressIndicator(year2023: true),
                      ),
                      Text('Logging in...'),
                    ],
                  );
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.hasData && snapshot.data != null) {
                  var data = snapshot.data!;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context, rootNavigator: true).pushReplacement(
                      MaterialPageRoute<void>(builder: (context) {
                        return UserPage(
                          context: context,
                          userId: data.userId,
                          userName: data.userName,
                          profilePicture: data.profilePicture
                        );
                      })
                    );
                  });
                  return const Column(children: []);
                }
                return Text('No data found');
              }
            )
          ]
        )
      )
    );
  }
}
