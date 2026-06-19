import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Social {
  final String name;
  final String history;
  final String iconUrl;
  final String imgUrl;
  final String webUrl;

  const Social({
    required this.name,
    required this.history,
    required this.iconUrl,
    required this.imgUrl,
    required this.webUrl,
  });

  factory Social.fromJson(Map<String, dynamic> json) {
    return Social(
      name: json['name'] as String,
      history: json['history'] as String,
      iconUrl: json['iconUrl'] as String,
      imgUrl: json['imgUrl'] as String,
      webUrl: json['webUrl'] as String,
    );
  }
}

class SocialPage extends StatefulWidget {
  final String name;
  final String history;
  final String imgUrl;
  final String webUrl;

  const SocialPage({
    super.key,
    required this.name,
    required this.history,
    required this.imgUrl,
    required this.webUrl,
  });

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  String _url = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      _url = widget.webUrl;
    });
  }

  Future<void> _openInAppWebsite() async {
    Uri webUrl = Uri.parse(_url);
    if (!await launchUrl(
      webUrl,
      mode: LaunchMode.inAppWebView,
      webOnlyWindowName: '_self',
    )) {
      throw Exception('Could not launch $webUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(widget.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              widget.imgUrl,
              width: double.infinity,
              height: 300.0,
              fit: BoxFit.cover,
            ),
            Padding (
              padding: const EdgeInsets.all(20),
              child: Column(
                spacing: 20,
                children: [
                  Text(
                    widget.history,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  FilledButton(
                    onPressed: _openInAppWebsite,
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
                    child: Text('Visit ${widget.name}')
                  ),
                ],
              ),
            ),
          ]
        )
      )
    );
  }
}