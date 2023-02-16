import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'modal_expanded.dart';

void logOut(){
  FirebaseAuth.instance.signOut();
}

class MyAppDrawer extends StatelessWidget {
  const MyAppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'CastOrNot',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Settings'),
            onTap: () {
              //TODO: Add settings screen if any
              Navigator.pushNamed(context, 'settings_screen');
            },
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Login'),
            onTap: () {
              Navigator.pushNamed(context, 'login_screen');
            },
          ),
          ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                showSimpleModalDialog(context, [
                  const Text('Are you sure you want to logout?'),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          logOut();
                          Navigator.pushNamedAndRemoveUntil(context, 'welcome_screen', (route) => false);
                        },
                        child: const Text('Yes'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('No'),
                      ),
                    ],
                  ),
                ]);
              }
          ),
        ],
      ),
    );
  }
}