import 'package:flutter/material.dart';

import 'socials.dart';

class User {
  final String userId;
  final String userName;
  final String profilePicture;

  const User({
    required this.userId,
    required this.userName,
    required this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      profilePicture: json['profilePicture'] as String,
    );
  }
}

class UserPage extends StatefulWidget {
  final BuildContext context;
  final String userId;
  final String userName;
  final String profilePicture;

  const UserPage({
    super.key,
    required this.context,
    required this.userId,
    required this.userName,
    required this.profilePicture,
  });

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final MenuController _menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MenuAnchor(
              animated: true,
              controller: _menuController,
              builder: (BuildContext context, MenuController controller, Widget? child) {
                return IconButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  icon: Image.network(
                    widget.profilePicture,
                    width: 40,
                    height: 40,
                  ),
                );
              },
              menuChildren: <Widget>[
                MenuItemButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: SizedBox(
                    width: 200,
                    child: Center(
                      child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.red)
                      )
                    )
                  )
                ),
                MenuItemButton(
                  onPressed: () {
                    _menuController.close();
                  },
                  child: SizedBox(
                    width: 200,
                    child: Center(
                      child: Text('Cancel')
                    )
                  ),
                ),
              ],
              style: MenuStyle(
                padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userName,
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    widget.userId,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialsWidget()
          ],
        ),
      ),
    );
  }
}
