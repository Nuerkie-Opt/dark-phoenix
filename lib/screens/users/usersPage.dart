import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lotusadmin/models/user.dart';
import 'package:lotusadmin/providers/usersProvider.dart';
import 'package:lotusadmin/screens/dashboard/header.dart';
import 'package:lotusadmin/screens/users/usersTable.dart';

import '../../../constants.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(children: [
          Header(
            title: 'Users',
            user: user,
          ),
          SizedBox(height: defaultPadding),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("users").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return Center(child: Text('${snapshot.error.toString()}'));
                if (!snapshot.hasData) return Center(child: Text('Something went wrong'));
                var output = snapshot.data?.docs.map((doc) => doc.data()).toList();
                print(output);
                Users.usersList = (output as List).map((item) => User.fromMap(item)).toList();
                print(Users.usersList);
                return Row(
                  children: [
                    Expanded(child: UsersTable()),
                  ],
                );
              })
        ]),
      ),
    );
  }
}
