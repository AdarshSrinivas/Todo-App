import 'package:flutter/material.dart';
import 'package:todo_app/database/auth.dart';
import 'package:provider/provider.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Colors.black,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: <Widget>[
            const SizedBox(
              height: 48,
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.cyan,
              ),
              title: Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.cyan,
                ),
              ),
              hoverColor: Colors.cyanAccent,
              onTap: () {
                context.read<AuthenticationService>().logOut();
              },
            ),
            
          ],
        ),
      ),
    );
  }
}
