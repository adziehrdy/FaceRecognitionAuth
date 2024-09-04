import 'package:face_net_authentication/models/user.dart';
import 'package:flutter/material.dart';

class selecUser extends StatelessWidget {
  final List<User> users;

  selecUser({required this.users});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select User'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(users[index].employee_name ?? 'NO NAME'),
            onTap: () {
              Navigator.of(context)
                  .pop(users[index]); // Return the selected user
            },
          );
        },
      ),
    );
  }
}
