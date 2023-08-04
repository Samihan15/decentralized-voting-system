import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Center(
              child: Text(
                'Voting DApp',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          ListTile(
            title: Text('Voting Page'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/voting');
            },
          ),
          ListTile(
            title: Text('Registration Page'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/registration');
            },
          ),
          ListTile(
            title: Text('Result Page'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/result');
            },
          ),
        ],
      ),
    );
  }
}
