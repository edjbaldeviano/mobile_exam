import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'social.dart';

Future<List<Social>> fetchSocialsData() async {
  var uri = Uri.parse('https://indexcodex.com/api/v1/socials');
  final Map<String, String> customHeaders = {
    'CLIENT_ID': 'rgbexam'
  };
  try {
    final response = await http.get(
      uri,
      headers: customHeaders,
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Social.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load user data');
    }
  } catch (e) {
    throw Exception(e);
  }   
}

class SocialsWidget extends StatefulWidget {
  const SocialsWidget({super.key});

  @override
  State<SocialsWidget> createState() => _SocialsWidgetState();
}

class _SocialsWidgetState extends State<SocialsWidget> {
  late Future<List<Social>> _apiResponse;

  @override
  void initState() {
    super.initState();
    _apiResponse = fetchSocialsData();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 250,
      child: FutureBuilder<List<Social>>(
        future: _apiResponse,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.hasData && snapshot.data != null) {
            final socials = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: socials.length,
              // Controls columns and grid proportions
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,          // Number of columns
                crossAxisSpacing: 20.0,     // Spacing between columns
                mainAxisSpacing: 20.0,      // Spacing between rows
                childAspectRatio: 1,     // Width-to-height item ratio
              ),
              itemBuilder: (context, index) {
                final social = socials[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (context) {
                        return SocialPage(
                          name: social.name,
                          history: social.history,
                          imgUrl: social.imgUrl,
                          webUrl: social.webUrl
                        );
                      })
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      social.iconUrl,
                      width: 100,
                      height: 100,
                    ),
                  ),
                );
              }
            );
          }
          return Text('No data found');
        }
      )
    );
  }
}