import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:lotusadmin/models/user.dart';
import 'package:lotusadmin/providers/usersProvider.dart';
import 'package:lotusadmin/responsive.dart';

import '../../../constants.dart';

class UsersTable extends StatelessWidget {
  const UsersTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            "Users",
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
                if (Responsive.isDesktop(context))
                  DataColumn(
                    label: Text("Date Signed Up"),
                  ),
              ],
              rows: List.generate(
                Users.usersList!.length,
                (index) => usersDataRow(Users.usersList![index], context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow usersDataRow(User user, BuildContext context) {
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
              child: Text(user.name),
            ),
          ],
        ),
      ),
      DataCell(Text(user.emailAddress)),
      DataCell(Text('${user.lastSeen}')),
      if (Responsive.isDesktop(context)) DataCell(Text('${user.dateSignedUp}')),
    ],
  );
}
