import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lotusadmin/models/user.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:lotusadmin/providers/usersProvider.dart';

import '../../../constants.dart';

class RecentFiles extends StatelessWidget {
  const RecentFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Center(child: Text('${snapshot.error.toString()}'));
          if (!snapshot.hasData) return Center(child: Text('Loading ...'));
          var output = snapshot.data?.docs.map((doc) => doc.data()).toList();

          Users.usersList = (output as List).map((item) => User.fromMap(item)).toList();
          List recentUsers = Users.usersList!
              .where((element) =>
                  element.lastSeen!.isBefore(DateTime.now()) &&
                  element.lastSeen!.isAfter(DateTime.now().subtract(Duration(hours: 24))))
              .toList();
          return Container(
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Recent Users",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(
                  width: double.infinity,
                  child: DataTable2(
                    columnSpacing: defaultPadding,
                    minWidth: 600,
                    columns: [
                      DataColumn(
                        label: Text("Username"),
                      ),
                      DataColumn(
                        label: Text("Email"),
                      ),
                      DataColumn(
                        label: Text("Last Seen"),
                      ),
                    ],
                    rows: List.generate(
                      recentUsers.length,
                      (index) => recentUsersRow(recentUsers[index]),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

DataRow recentUsersRow(User userInfo) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Image.network(
              backAvatar,
              height: 30,
              width: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(userInfo.name),
            ),
          ],
        ),
      ),
      DataCell(Text(userInfo.emailAddress)),
      DataCell(Text('${userInfo.lastSeen}')),
    ],
  );
}

bool isCurrentDateInRange(DateTime startDate, DateTime lastSeenDate) {
  final endDate = DateTime.now();
  return lastSeenDate.isAfter(startDate) && lastSeenDate.isBefore(endDate);
}
